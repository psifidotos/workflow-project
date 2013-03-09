#include "pluginchangeworkarea.h"

#include <KWindowSystem>

#include <KActivities/Controller>


PluginChangeWorkarea::PluginChangeWorkarea(QObject *obj, KActivities::Controller *actControl) :
    QObject(obj),
    m_activitiesCtrl(actControl),
    m_toActivity(""),
    m_toDesktop(-1)
{
    m_kwinSystem = KWindowSystem::KWindowSystem::self();

    init();
}

PluginChangeWorkarea::~PluginChangeWorkarea()
{
}

void PluginChangeWorkarea::init()
{
    connect(m_activitiesCtrl, SIGNAL(currentActivityChanged(QString)), this, SLOT(currentActivityChangedSlot(QString)));
}

void PluginChangeWorkarea::currentActivityChangedSlot(QString id)
{
    if(m_toActivity == id){
        m_kwinSystem->setCurrentDesktop(m_toDesktop);
        emit changeWorkareaEnded(m_toActivity,m_toDesktop);
    }
}

void PluginChangeWorkarea::execute(QString actId, int desktop)
{
    //When it is called again in second time before sending endsignal
    if (m_toActivity != "")
        m_toActivity = actId;

    if (m_activitiesCtrl->currentActivity() != actId){
        m_toActivity = actId;
        m_toDesktop = desktop;

        m_activitiesCtrl->setCurrentActivity(actId);
    }
    else{
        if(desktop != m_kwinSystem->currentDesktop())
            m_kwinSystem->setCurrentDesktop(desktop);

        emit changeWorkareaEnded(actId,desktop);
    }

}


#include "pluginchangeworkarea.moc"
