#include "pluginshowwidgets.h"

#include <QAction>
#include <QDBusInterface>
#include <QDBusConnection>
#include <QGraphicsView>
#include <QTimer>


#include <KConfigGroup>
#include <KConfig>
#include <KActivities/Controller>

#include <Plasma/Containment>
#include <Plasma/Corona>
#include <Plasma/PopupApplet>

#include <taskmanager/task.h>

#include "../workflow.h"

PluginShowWidgets::PluginShowWidgets(WorkFlow *plasmoid, KActivities::Controller *actControl) :
    QObject(plasmoid),
    m_plasmoid(plasmoid),
    m_activitiesCtrl(actControl)
{
    m_unlockWidgetsText = "";
    m_widgetsExplorerAwaitingActivity = false;
    m_isOnDashboard = isOnDashboard();

    m_corona = NULL;

    if(m_plasmoid->containment())
        if(m_plasmoid->containment()->corona())
            m_corona = m_plasmoid->containment()->corona();


    m_taskMainM = TaskManager::TaskManager::self();


    init();
}

PluginShowWidgets::~PluginShowWidgets()
{
}

void PluginShowWidgets::init()
{
    connect(m_activitiesCtrl, SIGNAL(currentActivityChanged(QString)), this, SLOT(currentActivityChanged(QString)));
}


void PluginShowWidgets::currentActivityChanged(QString id)
{
    if (m_widgetsExplorerAwaitingActivity){               
        showWidgetsExplorer(id);
        m_widgetsExplorerAwaitingActivity = false;

        if(!m_isOnDashboard)
            emit hidePopup();

        emit showWidgetsEnded();
    }
}

void PluginShowWidgets::hideDashboard()
{
    QDBusInterface remoteApp( "org.kde.plasma-desktop", "/App" );
    remoteApp.call( "showDashboard", false );
}

void PluginShowWidgets::showDashboard()
{
    QDBusInterface remoteApp( "org.kde.plasma-desktop", "/App" );
    remoteApp.call( "showDashboard", true );
}

void PluginShowWidgets::unlockWidgets()
{
    //if(containment())
    if(m_corona)
        if(m_corona->actions().at(0)){
            QAction *unlockAction = m_corona->actions().at(0);

            //Just checking the text size usually the word unlock is a bigger text
            if(m_unlockWidgetsText == ""){

                QString str1(unlockAction->text());
                unlockAction->trigger();
                QString str2(unlockAction->text());

                if(str1.size() > str2.size())
                    m_unlockWidgetsText = str1;
                else
                    m_unlockWidgetsText = str2;
            }

            if(m_unlockWidgetsText == unlockAction->text())
                unlockAction->trigger();
            //else the widgets are already unlocked
        }

}


bool PluginShowWidgets::isOnDashboard()
{
    m_isOnDashboard = false;
    if(m_plasmoid->containment()){
        KConfigGroup kfg=m_plasmoid->containment()->config();
        QString inDashboard = kfg.readEntry("plugin","---");

        m_isOnDashboard = (inDashboard == "desktopDashboard");
    }
    return m_isOnDashboard;
}

void PluginShowWidgets::minimizeWindowsIn(QString actid,int desktop)
{
    foreach (TaskManager::Task *source, m_taskMainM->tasks()){
        if( (source->isOnAllActivities()) ||
                (source->activities().contains(actid) && source->isOnAllDesktops()) ||
                (source->activities().contains(actid) && (source->desktop() == desktop)) )
            if(!source->isMinimized())
                source->setIconified(true);

    }
}


Plasma::Containment *PluginShowWidgets::getContainment(QString actId)
{

    if(m_corona){
        for(int j=0; j<m_corona->containments().size(); j++){
            Plasma::Containment *tC = m_corona->containments().at(j);

            if (tC->containmentType() == Plasma::Containment::DesktopContainment){

                if((tC->config().readEntry("activityId","") == actId)&&
                        (tC->config().readEntry("plugin","") != "desktopDashboard")){

                    return tC;
                }

            }

        }
    }

    return 0;
}

void PluginShowWidgets::showWidgetsExplorerFromDelay()
{
    showWidgetsExplorer(m_toShowActivityId);
    emit showWidgetsEnded();
}


void PluginShowWidgets::showWidgetsExplorer(QString actId)
{
    Plasma::Containment *currentContainment = getContainment(actId);
    if(currentContainment && currentContainment->view()){
        currentContainment->view()->metaObject()->invokeMethod(currentContainment->view(),
                                                               "showWidgetExplorer");
    }
}

void PluginShowWidgets::execute(QString actid)
{
    if(m_isOnDashboard)
        hideDashboard();

    int nDesktop = m_taskMainM->currentDesktop();

    bool currentAct = (actid == m_activitiesCtrl->currentActivity());

    bool timerNeeded = false;

    if((currentAct) && (!m_isOnDashboard)){
        showWidgetsExplorer(actid);
        emit hidePopup();
    }
    else if ((currentAct) && (m_isOnDashboard)){
        // This is only for Dashboard and on current Activity
        // a workaround for the strange behavior showing
        // explorer and hide it afterwards
        timerNeeded = true;
        m_toShowActivityId = actid;

        QTimer::singleShot(200, this, SLOT(showWidgetsExplorerFromDelay()));
    }
    else if(!currentAct){
        m_widgetsExplorerAwaitingActivity = true; ///wait for activity activation....
        m_toShowActivityId = actid;
        m_activitiesCtrl->setCurrentActivity(actid);
        timerNeeded = true;
      //  nDesktop = m_plasmoid->setCurrentActivityAndDesktop(actid,nDesktop);
    }

    minimizeWindowsIn(actid, nDesktop);
    unlockWidgets();

    if(!timerNeeded)
        emit showWidgetsEnded();

}


#include "pluginshowwidgets.moc"
