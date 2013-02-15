#include "workareaengine.h"
#include "workareaservice.h"

#include "workareas/store.h"
#include "workareas/info.h"

#include <KAction>

WorkareaEngine::WorkareaEngine(QObject *parent, const QVariantList& args)
    : Plasma::DataEngine(parent, args),
      m_store(0),
      actionCollection(0),
      m_signalMapper(new QSignalMapper(this))
{
}

WorkareaEngine::~WorkareaEngine()
{
    if(m_store)
        delete m_store;
    if(actionCollection)
        delete actionCollection;
    if(m_signalMapper)
        delete m_signalMapper;
}

void WorkareaEngine::init()
{
    m_store = new Workareas::Store(this);
    QStringList activities = m_store->activities();
    foreach(QString activity, activities)
        activityAddedSlot(activity);

    connect(m_store, SIGNAL(activityAdded(QString)), this, SLOT(activityAddedSlot(QString)));
    connect(m_store, SIGNAL(activityRemoved(QString)), this, SLOT(activityRemovedSlot(QString)));
    connect(m_store, SIGNAL(workareaAdded(QString,QString)), this, SLOT(workareaAddedSlot(QString,QString)));
    connect(m_store, SIGNAL(workareaRemoved(QString,int)), this, SLOT(workareaRemovedSlot(QString,int)));
    connect(m_store, SIGNAL(workareaInfoUpdated(QString)), this, SLOT(workareaInfoUpdatedSlot(QString)));

    connect(m_store, SIGNAL(activityOrdersChanged()), this, SLOT(activitiesOrderChangedSlot()));

    connect(m_store, SIGNAL(maxWorkareasChanged(int)), this, SLOT(maxWorkareasChangedSlot(int)));

    m_store->initBackgrounds();

    setData("Settings", "MaxWorkareas", m_store->maxWorkareas());

    //Global Shortcuts//

/*
    actionCollection = new KActionCollection(this);
    actionCollection->setConfigGlobal(true);
    actionCollection->setConfigGroup("workareas");

    KAction* a;
    //actionCollection->addAction("next-activity", this, SLOT(nextActivitySlot()));
    //actionCollection->addAction("previous-activity", this, SLOT(previousActivitySlot()));
    //actionCollection->readSettings();

    a = static_cast< KAction* >(actionCollection->addAction("Next-Activity", this, SLOT(nextActivitySlot())));
    a->setGlobalShortcut(KShortcut(Qt::META + Qt::Key_Plus));
    a = static_cast< KAction* >(actionCollection->addAction("Previous-Activity", this, SLOT(previousActivitySlot())));
    a->setGlobalShortcut(KShortcut(Qt::META + Qt::Key_Minus));

    actionCollection->writeSettings();*/
/*    a = static_cast< KAction* >(actionCollection->addAction(KStandardAction::ActualSize, this, SLOT(toggle())));
    a->setGlobalShortcut(KShortcut(Qt::META + Qt::Key_0));
    connect(effects, SIGNAL(mouseChanged(QPoint,QPoint,Qt::MouseButtons,Qt::MouseButtons,Qt::KeyboardModifiers,Qt::KeyboardModifiers)),
            this, SLOT(slotMouseChanged(QPoint,QPoint,Qt::MouseButtons,Qt::MouseButtons,Qt::KeyboardModifiers,Qt::KeyboardModifiers)));
    reconfigure(ReconfigureAll);*/
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
    updateOrders();
}

void WorkareaEngine::nextActivitySlot()
{
    m_store->setCurrentNextActivity();
}

void WorkareaEngine::previousActivitySlot()
{
    m_store->setCurrentPreviousActivity();
}

void WorkareaEngine::workareaAddedSlot(QString id,QString name)
{
    Q_UNUSED(name);
    loadActivity(id);
}

void WorkareaEngine::workareaRemovedSlot(QString id,int desktop)
{
    Q_UNUSED(desktop);
    loadActivity(id);
}

void WorkareaEngine::workareaInfoUpdatedSlot(QString id)
{
    loadActivity(id);
}

void WorkareaEngine::maxWorkareasChangedSlot(int size)
{
    setData("Settings", "MaxWorkareas", size);
}

void WorkareaEngine::activitiesOrderChangedSlot()
{
    updateOrders();
}

void WorkareaEngine::loadActivity(QString id)
{
    QStringList storeActivities = m_store->activities();
    if(storeActivities.contains(id)){
        Workareas::Info *info = m_store->get(id);
        int pos = storeActivities.indexOf(id);

        setData(id, "Background", info->background());
        setData(id, "Order", pos+1);
        setData(id, "Workareas", info->workareas());
    }
}

void WorkareaEngine::updateOrders()
{
    QStringList storeActivities = m_store->activities();
    for(int i=0; i<storeActivities.size(); ++i){
        setData(storeActivities[i], "Order", i+1);
    }
}

K_EXPORT_PLASMA_DATAENGINE(workareas, WorkareaEngine)

#include <workareaengine.moc>
