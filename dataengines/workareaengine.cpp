#include "workareaengine.h"
#include "workareaservice.h"

#include "workareas/store.h"
#include "workareas/info.h"


WorkareaEngine::WorkareaEngine(QObject *parent, const QVariantList& args)
: Plasma::DataEngine(parent, args),
  m_store(0)
{
}

WorkareaEngine::~WorkareaEngine()
{
    if(m_store)
        delete m_store;
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

    connect(m_store, SIGNAL(maxWorkareasChanged(int)), this, SLOT(maxWorkareasChangedSlot(int)));

    m_store->initBackgrounds();

    setData("Settings", "MaxWorkareas", m_store->maxWorkareas());
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


void WorkareaEngine::loadActivity(QString id)
{
    if(m_store->activities().contains(id)){
        Workareas::Info *info = m_store->get(id);

        setData(id, "Background", info->background());
        setData(id, "Workareas", info->workareas());
    }
}

K_EXPORT_PLASMA_DATAENGINE(workareas, WorkareaEngine)

#include <workareaengine.moc>
