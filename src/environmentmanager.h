#ifndef ENVIRONMENTMANAGER_H
#define ENVIRONMENTMANAGER_H

#include <KActivities/Controller>

class PluginShowWidgets;

namespace KActivities
{
class Controller;
}

namespace Plasma {
class Containment;
class Corona;
}

/*
 *This class holds all the code which couldnt moved to qml plugins because it
 *needed containment() and corona() from the plasmoid. If a different solution
 *is discovered then this code can be moved to qml plugins
 */
class EnvironmentManager : public QObject
{
    Q_OBJECT
public:
    explicit EnvironmentManager(QObject *parent = 0);
    ~EnvironmentManager();

    Q_INVOKABLE QString getWallpaper(QString source);
    Q_INVOKABLE void showWidgetsExplorer(QString);

    void setContainment(Plasma::Containment *);

signals:
    void hidePopup();

public slots:
    //SIGNALS FROM THE PLUGINS
    void showWidgetsEndedSlot();

private:
    KActivities::Controller *m_activitiesCtrl;
    Plasma::Containment *m_mainContainment;
    Plasma::Corona *m_corona;

    PluginShowWidgets *m_plShowWidgets;

    Plasma::Containment *getContainment(QString actId);
};

#endif // EnvironmentManager_H
