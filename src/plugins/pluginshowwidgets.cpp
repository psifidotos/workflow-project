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
        showWidgetsExplorer(m_toShowActivityId);
        m_widgetsExplorerAwaitingActivity = false;
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



void PluginShowWidgets::showWidgetsExplorerFromDelay()
{
    showWidgetsExplorer(m_toShowActivityId);
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


void PluginShowWidgets::showWidgetsExplorer(QString actId)
{
    Plasma::Containment *currentContainment = getContainment(actId);
    if(currentContainment->view()){

        currentContainment->view()->metaObject()->invokeMethod(currentContainment->view(),
                                                               "showWidgetExplorer");

    }

}

void PluginShowWidgets::execute(QString actid)
{
    if(m_isOnDashboard)
        hideDashboard();

    int nDesktop = m_taskMainM->currentDesktop();

    bool currentAct = (actid == m_taskMainM->currentActivity());

    if(currentAct){
        if(!m_isOnDashboard)
            showWidgetsExplorer(actid);
        else{
            // This is only for Dashboard and on current Activity
            // a workaround for the strange behavior showing
            // explorer and hide it afterwards
            m_toShowActivityId = actid;

            QTimer::singleShot(200, this, SLOT(showWidgetsExplorerFromDelay()));
        }
    }
    else{
        m_widgetsExplorerAwaitingActivity = true; ///wait for activity activation....
        m_toShowActivityId = actid;
        nDesktop = m_plasmoid->setCurrentActivityAndDesktop(actid,nDesktop);

        showWidgetsExplorer(actid);
    }

    minimizeWindowsIn(actid, nDesktop);
    unlockWidgets();

    //Otherwise the widgets explorer it is hidden again because it loses focus
    //When we change activity the popup is hidden automaticaly from KDE
    if((!m_isOnDashboard)&&(currentAct))
        m_plasmoid->hidePopupDialog();
}


/////////////////////////////////////////////////////
/*
function showWidgetsExplorer(act){
    if(mainView.isOnDashBoard)
        taskManager.hideDashboard();

    var nDesktop = mainView.currentDesktop;

    var currentAct = (act === mainView.currentActivity);

    if(currentAct)
        //   if(!mainView.isOnDashBoard)
        activityManager.showWidgetsExplorer(act);
    //    else{
    // This is only for Dashboard and on current Activity
    // a workaround for the strange behavior showing
    // explorer and hide it afterwards
    showWidgetsExplorerTimer.actCode = act;
    showWidgetsExplorerTimer.start();
    //     }
    else{
        widgetsExplorerAwaitingActivity = true;
        nDesktop = setCurrentActivityAndDesktop(act,mainView.currentDesktop);
    }

    instanceOfTasksList.minimizeWindowsIn(act, nDesktop);
    activityManager.unlockWidgets();


    //Hide it after showing the widgets
    if((!mainView.isOnDashBoard)&&(currentAct))
        workflowManager.hidePopupDialog();

}
*/




#include "pluginshowwidgets.moc"
