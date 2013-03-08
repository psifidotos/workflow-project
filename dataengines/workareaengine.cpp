#include "workareaengine.h"
#include "workareaservice.h"

//#include "workareas/store.h"
//#include "workareas/info.h"

#include "../qdbus/client/storeinterface.h"

#include <QDBusPendingReply>
#include <QDBusServiceWatcher>
#include <QDebug>

#include <KAction>

WorkareaEngine::WorkareaEngine(QObject *parent, const QVariantList& args)
    : Plasma::DataEngine(parent, args),
      m_store(0),
      actionCollection(0)
{
    m_store = new StoreInterface("org.kde.kded", "/modules/workareamanagerd", QDBusConnection::sessionBus(), 0);
}

WorkareaEngine::~WorkareaEngine()
{
    if(m_store)
        delete m_store;
    if(actionCollection)
        delete actionCollection;
}

void WorkareaEngine::init()
{

    // Listen to activitymanagerd for starting/stopping
    QDBusServiceWatcher *watcher = new QDBusServiceWatcher("org.opentoolsandspace.WorkareaManager",
                                                           QDBusConnection::sessionBus(),
                                                           QDBusServiceWatcher::WatchForRegistration);
    connect(watcher, SIGNAL(serviceRegistered(QString)), this, SLOT(managerServiceRegistered()));

    if( (watcher->connection()).isConnected()){
            initSession();
    }
}

void WorkareaEngine::managerServiceRegistered()
{
    initSession();
}

void WorkareaEngine::initSession()
{
    //  m_store = new Workareas::Store(this);
      QStringList activities = m_store->Activities();
      foreach(QString activity, activities)
          activityAddedSlot(activity);

      connect(m_store, SIGNAL(ActivityAdded(QString)), this, SLOT(activityAddedSlot(QString)));
      connect(m_store, SIGNAL(ActivityRemoved(QString)), this, SLOT(activityRemovedSlot(QString)));
      connect(m_store, SIGNAL(WorkareaAdded(QString,QStringList)), this, SLOT(workareaAddedSlot(QString, QStringList)));
      connect(m_store, SIGNAL(WorkareaRemoved(QString, QStringList)), this, SLOT(workareaRemovedSlot(QString, QStringList)));
      connect(m_store, SIGNAL(ActivityInfoUpdated(QString,QString,QStringList)), this, SLOT(activityInfoUpdatedSlot(QString,QString,QStringList)));

      connect(m_store, SIGNAL(ActivityOrdersChanged(QStringList)), this, SLOT(activitiesOrderChangedSlot(QStringList)));

      connect(m_store, SIGNAL(MaxWorkareasChanged(int)), this, SLOT(maxWorkareasChangedSlot(int)));

    //  m_store->initBackgrounds();

      QDBusPendingReply<int> replyMaxWorkareas = m_store->MaxWorkareas();
      replyMaxWorkareas.waitForFinished();
      if(!replyMaxWorkareas.isError())
          setData("Settings", "MaxWorkareas", replyMaxWorkareas.value());
      else{
          setData("Settings", "MaxWorkareas", 1);
          qDebug() << replyMaxWorkareas.error();
      }
  //    setData("Settings", "MaxWorkareas", m_store->MaxWorkareas());


      //Global Shortcuts//
      actionCollection = new KActionCollection(this);
      actionCollection->setConfigGlobal(true);
      actionCollection->setConfigGroup("workareas");

      KAction* a;
      a = static_cast< KAction* >(actionCollection->addAction("WorkFlow: Next Activity", this, SLOT(nextActivitySlot())));
      a->setGlobalShortcut(KShortcut(Qt::META + Qt::Key_Tab));
      a = static_cast< KAction* >(actionCollection->addAction("WorkFlow: Previous Activity", this, SLOT(previousActivitySlot())));
      a->setGlobalShortcut(KShortcut( (Qt::META + Qt::SHIFT) + Qt::Key_Tab));

      actionCollection->writeSettings();
}

Plasma::Service * WorkareaEngine::serviceForSource(const QString &source)
{
    //FIXME validate the name
    WorkareaService *service = new WorkareaService(source, m_store);
    service->setParent(this);
    return service;
}

void WorkareaEngine::activityAddedSlot(QString id)
{
    loadActivity(id);
}

void WorkareaEngine::activityRemovedSlot(QString id)
{
    removeSource(id);
    updateOrders(QStringList());
}

void WorkareaEngine::nextActivitySlot()
{
    m_store->SetCurrentNextActivity();
}

void WorkareaEngine::previousActivitySlot()
{
    m_store->SetCurrentPreviousActivity();
}

void WorkareaEngine::workareaAddedSlot(QString id,QStringList workareas)
{
    setData(id, "Workareas", workareas);

    //setData(id, "Workareas", m_store->Workareas(id))
    //loadActivity(id);
}

void WorkareaEngine::workareaRemovedSlot(QString id,QStringList workareas)
{
    setData(id, "Workareas", workareas);

    //setData(id, "Workareas", m_store->Workareas(id))
    //loadActivity(id);
}

void WorkareaEngine::activityInfoUpdatedSlot(QString id, QString background, QStringList workareas)
{
    //loadActivity(id);
    setData(id, "Background", background);
    setData(id, "Workareas", workareas);
}

void WorkareaEngine::maxWorkareasChangedSlot(int size)
{
    setData("Settings", "MaxWorkareas", size);
}

void WorkareaEngine::activitiesOrderChangedSlot(QStringList activities)
{
    updateOrders(activities);
}

void WorkareaEngine::loadActivity(QString id)
{
    QStringList storeActivities;

    QDBusPendingReply<QStringList> replyActivities = m_store->Activities();
    replyActivities.waitForFinished();
    if(!replyActivities.isError())
        storeActivities = m_store->Activities();
    else
        qDebug() << replyActivities.error();

    if(storeActivities.contains(id)){
    //    Workareas::Info *info = m_store->get(id);
        int pos = storeActivities.indexOf(id);
        setData(id, "Order", pos+1);

        QDBusPendingReply<QString> replyBackground = m_store->ActivityBackground(id);
        QDBusPendingReply<QStringList> replyWorkareas = m_store->Workareas(id);
        replyBackground.waitForFinished();
        replyWorkareas.waitForFinished();

        if(!replyBackground.isError())
            setData(id, "Background", replyBackground.value());
        else
            qDebug() << replyBackground.error();

        if(!replyWorkareas.isError())
            setData(id, "Workareas", replyWorkareas.value());
        else
            qDebug() << replyWorkareas.error();

        //setData(id, "Background", m_store->Background(id));
        //setData(id, "Workareas", m_store->Workareas(id));
    }
}

void WorkareaEngine::updateOrders(QStringList activities)
{
    QStringList storeActivities;
    if(activities.size() == 0 ){
        QDBusPendingReply<QStringList> replyActivities = m_store->Activities();
        replyActivities.waitForFinished();
        if(!replyActivities.isError())
            storeActivities = m_store->Activities();
        else
            qDebug() << replyActivities.error();
    }
    else
        storeActivities = activities;

    for(int i=0; i<storeActivities.size(); ++i)
        setData(storeActivities[i], "Order", i+1);

}

K_EXPORT_PLASMA_DATAENGINE(workareas, WorkareaEngine)

#include <workareaengine.moc>
