#include "pluginaddactivity.h"

#include <KActivities/Controller>

#include <taskmanager/task.h>

PluginAddActivity::PluginAddActivity(QObject *obj, KActivities::Controller *actControl) :
    QObject(obj),
    m_activitiesCtrl(actControl)
{
    init();
}

PluginAddActivity::~PluginAddActivity()
{
}

void PluginAddActivity::init()
{
    connect(m_activitiesCtrl, SIGNAL(activityAdded(QString)), this, SLOT(activityAddedSlot(QString)) );
    connect(m_activitiesCtrl, SIGNAL(currentActivityChanged(QString)), this, SLOT(currentActivityChangedSlot(QString)));
}


void PluginAddActivity::activityAddedSlot(QString activity)
{
    //Phase 02 of loading Wallpaper of New Activity
    if(m_newActivity == activity){
        KActivities::Info *activityNew = new KActivities::Info(m_newActivity, this);

        connect(activityNew, SIGNAL(stateChanged(KActivities::Info::State)), this,SLOT(activityStateChangedSlot()));

        m_activitiesCtrl->setCurrentActivity(m_newActivity);
    }
}


void PluginAddActivity::currentActivityChangedSlot(QString activity)
{
    //Phase 03 Of updating the wallpaper of new activity
    if(m_newActivity == activity)
        m_activitiesCtrl->setCurrentActivity(m_previousActivity);

    //Phase 04 Of updating the wallpaper of new activity
    if(m_previousActivity == activity)
        m_activitiesCtrl->stopActivity(m_newActivity);

}


//Phase 05 Of updating the wallpaper of new activity
void PluginAddActivity::activityStateChangedSlot()
{
    KActivities::Info *activity = qobject_cast<KActivities::Info*>(sender());
    const QString id = activity->id();
    if (!activity) {
        return;
    }
    QString state;
    switch (activity->state()) {
    case KActivities::Info::Running:
        state = "Running";
        break;
    case KActivities::Info::Starting:
        state = "Starting";
        break;
    case KActivities::Info::Stopping:
        state = "Stopping";
        break;
    case KActivities::Info::Stopped:
        state = "Stopped";
        break;
    case KActivities::Info::Invalid:
    default:
        state = "Invalid";
    }

    if ((m_newActivity == id) &&
            (state == "Stopped") ){
        m_activitiesCtrl->startActivity(m_newActivity);
        emit addActivityEnded();
    }

}

void PluginAddActivity::execute(QString name)
{
    m_previousActivity = m_activitiesCtrl->currentActivity();

    m_newActivity = m_activitiesCtrl->addActivity(name);
}


#include "pluginaddactivity.moc"
