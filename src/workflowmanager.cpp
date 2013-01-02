#include "workflowmanager.h"

#include "activitymanager.h"
#include "workareasmanager.h"
#include "models/activitiesenhancedmodel.h"

#include "models/activityitem.h"

void WorkflowManager::WorkflowManager(QObject *parent):
    QObject(parent),
    m_activityManager(0),
    m_workareasManager(0),
    m_model(0)
{
    m_model = new ActivitiesEnhancedModel(new ActivityItem,this);

    m_activityManager = new ActivityManager(m_model,this);
    m_workareasManager = new WorkareasManager(m_model, this);
}

WorkflowManager::~WorkflowManager()
{
    if(m_activityManager)
        delete m_activityManager;
    if(m_workareasManager)
        delete m_workareasManager;
    if(m_model)
        delete m_model;
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
