#include "environmentmanager.h"

#include <KActivities/Controller>

#include <Plasma/Containment>
#include <Plasma/Corona>

////Plugins/////
#include "plugins/pluginfindwallpaper.h"
#include "plugins/pluginshowwidgets.h"

EnvironmentManager::EnvironmentManager(QObject *parent) :
    QObject(parent),
    m_activitiesCtrl(0),
    m_mainContainment(0),
    m_corona(0),
    m_plShowWidgets(0)
{
    m_activitiesCtrl = new KActivities::Controller(this);
}

EnvironmentManager::~EnvironmentManager()
{
    if (m_activitiesCtrl)
        delete m_activitiesCtrl;
    if (m_plShowWidgets)
        delete m_plShowWidgets;

}

void EnvironmentManager::setContainment(Plasma::Containment *containment)
{
    m_mainContainment = containment;

    if(m_mainContainment)
        if(m_mainContainment->corona())
            m_corona = m_mainContainment->corona();
}

void EnvironmentManager::showWidgetsEndedSlot()
{
    if (m_plShowWidgets){
        delete m_plShowWidgets;
        m_plShowWidgets = 0;
    }
}



Plasma::Containment *EnvironmentManager::getContainment(QString actId)
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

///////////////Plugins

QString EnvironmentManager::getWallpaper(QString source)
{
    PluginFindWallpaper plg(getContainment(source));
    return plg.getWallpaper(source);
}

void EnvironmentManager::showWidgetsExplorer(QString actId)
{
    if(!m_plShowWidgets){
        m_plShowWidgets = new PluginShowWidgets(this,m_mainContainment, m_activitiesCtrl);

        connect(m_plShowWidgets, SIGNAL(showWidgetsEnded()), this, SLOT(showWidgetsEndedSlot()));
        connect(m_plShowWidgets, SIGNAL(hidePopup()), this, SIGNAL(hidePopup()));

        m_plShowWidgets->execute(actId);
    }
}





#include "environmentmanager.moc"
