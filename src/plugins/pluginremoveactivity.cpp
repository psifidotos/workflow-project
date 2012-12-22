#include "pluginremoveactivity.h"

#include <KActivities/Controller>

#include <taskmanager/task.h>

PluginRemoveActivity::PluginRemoveActivity(QObject *obj, KActivities::Controller *actControl) :
    QObject(obj),
    m_activitiesCtrl(actControl),
    m_toRemoveActivityInfo(0),
    m_toRemoveActivityId("")
{
    init();
}

PluginRemoveActivity::~PluginRemoveActivity()
{
    if(m_toRemoveActivityInfo)
        delete m_toRemoveActivityInfo;
}

void PluginRemoveActivity::init()
{

}

void PluginRemoveActivity::activityStateChanged()
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

    if ((m_toRemoveActivityId == id) &&
            (state == "Stopped") ){
        m_activitiesCtrl->removeActivity(m_toRemoveActivityId);
        emit activityRemovedEnded(m_toRemoveActivityId);
    }

}

void PluginRemoveActivity::execute(QString actId)
{
    m_toRemoveActivityId = actId;
    m_toRemoveActivityInfo = new KActivities::Info(m_toRemoveActivityId, this);

    connect(m_toRemoveActivityInfo, SIGNAL(stateChanged(KActivities::Info::State)), this, SLOT(activityStateChanged()));

    m_activitiesCtrl->stopActivity(m_toRemoveActivityId);
}


#include "pluginremoveactivity.moc"
