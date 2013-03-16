#include "workflowmanager.h"

#include "subengines/activitymanager.h"
#include "subengines/workareasmanager.h"
#include "models/activitiesenhancedmodel.h"

#include "models/activityitem.h"

WorkflowManager::WorkflowManager(QObject *parent) :
    QObject(parent),
    m_activityManager(0),
    m_workareaManager(0),
    m_model(0)
{
    init();
}

WorkflowManager::~WorkflowManager()
{
    if(m_activityManager)
        delete m_activityManager;
    if(m_workareaManager)
        delete m_workareaManager;
    //Delete model here in order not to trigger the countChanged from
    //workareas signals for activityManager and m_workflowManager
    //No need, the children will be deleted by the parent
    //was creating occussionaly crashes
    if(m_model)
        delete m_model;
}

void WorkflowManager::init()
{
    m_model = new ActivitiesEnhancedModel(this);

    //First fill the activities in the model
    m_activityManager = new ActivityManager(m_model,this);
    m_workareaManager = new WorkareasManager(m_model, this);
}

#include "workflowmanager.moc"
