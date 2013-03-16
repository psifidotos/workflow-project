#include "workareaengine.h"
#include "workareaservice.h"

#include "../qdbus/client/workareainterface.h"

#include <QDBusPendingReply>
#include <QDBusPendingCall>
#include <QDBusServiceWatcher>
#include <QDebug>


WorkareaEngine::WorkareaEngine(QObject *parent, const QVariantList& args)
    : Plasma::DataEngine(parent, args),
      m_store(0)
{
    m_store = new WorkareaInterface("org.opentoolsandspace.WorkareaManager", "/", QDBusConnection::sessionBus(), 0);
}

WorkareaEngine::~WorkareaEngine()
{
    if(m_store)
        delete m_store;
}

void WorkareaEngine::init()
{
    connect(m_store, SIGNAL(ServiceStatusChanged(bool)), this, SLOT(onServiceRegistered(bool)));

    //check workareamanagerd status
    QDBusPendingCall async = m_store->asyncCall("ServiceStatus");
    QDBusPendingCallWatcher *watcher = new QDBusPendingCallWatcher(async, this);

    QObject::connect(watcher, SIGNAL(finished(QDBusPendingCallWatcher*)),
                     this, SLOT(serviceCallFinishedSlot(QDBusPendingCallWatcher*)));

    /*
    QDBusPendingReply<bool> replyStatus = m_store->ServiceStatus();
    replyStatus.waitForFinished();
    if(!replyStatus.isError()){
        bool result = replyStatus.value();
        if(result){
            initSession();
        }
    }
    else{
        qDebug() << replyStatus.error();
    }*/
}

void WorkareaEngine::serviceCallFinishedSlot(QDBusPendingCallWatcher* call)
{
    QDBusPendingReply<bool> replyStatus = *call;
    if (replyStatus.isError()) {
        qDebug() << replyStatus.error();
    } else {
        onServiceRegistered(replyStatus.value());
    }
    call->deleteLater();
}

void WorkareaEngine::onServiceRegistered(bool status)
{
    if (status){
        initSession();
    }
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
    connect(m_store, SIGNAL(ActivityInfoUpdated(QString,QStringList,QStringList)), this, SLOT(activityInfoUpdatedSlot(QString,QStringList,QStringList)));

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

void WorkareaEngine::activityInfoUpdatedSlot(QString id, QStringList backgrounds, QStringList workareas)
{
    //loadActivity(id);
    setData(id, "Backgrounds", backgrounds);
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

        QDBusPendingReply<QStringList> replyBackgrounds = m_store->ActivityBackgrounds(id);
        QDBusPendingReply<QStringList> replyWorkareas = m_store->Workareas(id);
        replyBackgrounds.waitForFinished();
        replyWorkareas.waitForFinished();

        if(!replyBackgrounds.isError())
            setData(id, "Backgrounds", replyBackgrounds.value());
        else
            qDebug() << replyBackgrounds.error();

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
