#include "workflowmanager.h"

#include "subengines/activitymanager.h"
#include "subengines/workareasmanager.h"
#include "models/activitiesenhancedmodel.h"

#include "models/activityitem.h"

#include "subengines/plugins/pluginsyncactivitiesworkareas.h"

WorkflowManager::WorkflowManager(QObject *parent) :
    QObject(parent),
    m_activityManager(0),
    m_workareaManager(0),
    m_model(0),
    m_plgSyncActivitiesWorkareas(0)
{
    m_model = new ActivitiesEnhancedModel(this);

    m_activityManager = new ActivityManager(m_model,this);
    m_workareaManager = new WorkareasManager(m_model, this);

    m_plgSyncActivitiesWorkareas = new PluginSyncActivitiesWorkareas(this);

    init();
}

WorkflowManager::~WorkflowManager()
{
    if(m_activityManager)
        delete m_activityManager;
    if(m_workareaManager)
        delete m_workareaManager;
    //Delete model here in order not to trigger the countChanged from
    //workareas signals
    if(m_model)
        delete m_model;
    if(m_plgSyncActivitiesWorkareas)
        delete m_plgSyncActivitiesWorkareas;
}

void WorkflowManager::init()
{
    connect(m_activityManager, SIGNAL(activityAdded(QString)), m_workareaManager, SLOT(activityAddedSlot(QString)) );
    connect(m_activityManager, SIGNAL(activityRemoved(QString)), m_workareaManager, SLOT(activityRemovedSlot(QString)) );

    connect(m_activityManager, SIGNAL(activitiesLoading(bool)), m_workareaManager, SLOT(activitiesLoadingSlot(bool)) );

    connect(m_activityManager, SIGNAL(cloningCopyWorkareas(QString,QString)),
            m_workareaManager, SLOT(cloneWorkareas(QString,QString)) );

    connect(m_workareaManager, SIGNAL(maxWorkareasChanged(int)),
            m_plgSyncActivitiesWorkareas, SLOT(maxWorkareasUpdated(int)) );

    m_activityManager->loadActivitiesInModel();

}
/*
ActivityManager *WorkflowManager::activityManager()
{
    return m_activityManager;
}

WorkareasManager *WorkflowManager::workareaManager()
{
    return m_workareaManager;
}

ActivitiesEnhancedModel *WorkflowManager::model()
{
    return m_model;
}*/

#include "workflowmanager.moc"
