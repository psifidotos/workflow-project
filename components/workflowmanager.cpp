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
    //workareas signals
    if(m_model)
        delete m_model;
}

void WorkflowManager::init()
{
    m_model = new ActivitiesEnhancedModel(this);

    //First fill the activities in the model
    m_activityManager = new ActivityManager(m_model,this);
    m_workareaManager = new WorkareasManager(m_model, this);

   // connect(m_activityManager, SIGNAL(activityAdded(QString)), m_workareaManager, SLOT(activityAddedSlot(QString)) );
    //connect(m_activityManager, SIGNAL(activityRemoved(QString)), m_workareaManager, SLOT(activityRemovedSlot(QString)) );

    connect(m_activityManager, SIGNAL(cloningCopyWorkareas(QString,QString)),
            m_workareaManager, SLOT(cloneWorkareas(QString,QString)) );

}

#include "workflowmanager.moc"
