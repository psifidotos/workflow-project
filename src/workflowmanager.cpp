#include "workflowmanager.h"

#include "activitymanager.h"
#include "workareasmanager.h"
#include "models/activitiesenhancedmodel.h"

#include "models/activityitem.h"

#include "plugins/pluginsyncactivitiesworkareas.h"

WorkflowManager::WorkflowManager(ActivitiesEnhancedModel * model,QObject *parent) :
    QObject(parent),
    m_activityManager(0),
    m_workareasManager(0),
    m_model(model),
    m_plgSyncActivitiesWorkareas(0)
{
    m_activityManager = new ActivityManager(m_model,this);
    m_workareasManager = new WorkareasManager(m_model, this);

    m_plgSyncActivitiesWorkareas = new PluginSyncActivitiesWorkareas(this);

    init();
}

WorkflowManager::~WorkflowManager()
{
    if(m_activityManager)
        delete m_activityManager;
    if(m_workareasManager)
        delete m_workareasManager;
    if(m_plgSyncActivitiesWorkareas)
        delete m_plgSyncActivitiesWorkareas;
}

void WorkflowManager::init()
{
    connect(m_activityManager, SIGNAL(activityAdded(QString)), m_workareasManager, SLOT(activityAddedSlot(QString)) );
    connect(m_activityManager, SIGNAL(activityRemoved(QString)), m_workareasManager, SLOT(activityRemovedSlot(QString)) );

    connect(m_activityManager, SIGNAL(activitiesLoading(bool)), m_workareasManager, SLOT(activitiesLoadingSlot(bool)) );

    connect(m_activityManager, SIGNAL(cloningCopyWorkareas(QString,QString)),
            m_workareasManager, SLOT(cloneWorkareas(QString,QString)) );

    connect(m_workareasManager, SIGNAL(maxWorkareasChanged(int)),
            m_plgSyncActivitiesWorkareas, SLOT(maxWorkareasUpdated(int)) );

}

ActivityManager *WorkflowManager::activityManager()
{
    return m_activityManager;
}

WorkareasManager *WorkflowManager::workareasManager()
{
    return m_workareasManager;
}

ActivitiesEnhancedModel *WorkflowManager::model()
{
    return m_model;
}

#include "workflowmanager.moc"
