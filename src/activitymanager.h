#ifndef ACTIVITYMANAGER_H
#define ACTIVITYMANAGER_H


#include <KActivities/Controller>

class PluginShowWidgets;
class PluginCloneActivity;
class PluginChangeWorkarea;
class PluginAddActivity;

class ActivitiesEnhancedModel;

namespace KActivities
{
class Controller;
}

namespace Plasma {
class Containment;
class Corona;
}

class ActivityManager : public QObject
{
    Q_OBJECT
public:
    explicit ActivityManager(ActivitiesEnhancedModel *,QObject *parent = 0);
    ~ActivityManager();

    //  Q_INVOKABLE void createActivityFromScript(const QString &script, const QString &name, const QString &icon, const QStringList &startupApps);
    //  Q_INVOKABLE void downloadActivityScripts();

    Q_INVOKABLE QString getWallpaper(QString source);
    Q_INVOKABLE QPixmap disabledPixmapForIcon(const QString &ic);
    Q_INVOKABLE void add(QString name);

    Q_INVOKABLE void setCurrent(QString id);
    Q_INVOKABLE void stop(QString id);
    Q_INVOKABLE void start(QString id);
    Q_INVOKABLE void setName(QString id, QString name);
    Q_INVOKABLE void remove(QString id);
    Q_INVOKABLE void setIcon(QString id, QString name);
    Q_INVOKABLE QString chooseIcon(QString);
    Q_INVOKABLE QString name(QString id);
    Q_INVOKABLE QString cstate(QString id);
    Q_INVOKABLE void setCurrentNextActivity();
    Q_INVOKABLE void setCurrentPreviousActivity();

    //    Q_INVOKABLE int askForDelete(QString activityName);

    Q_INVOKABLE void showWidgetsExplorer(QString);
    Q_INVOKABLE void cloneActivity(QString);

    void loadActivitiesInModel();

    void setContainment(Plasma::Containment *);

    QString getCurrentActivityName();
    QString getCurrentActivityIcon();

signals:
    void showedIconDialog();
    void answeredIconDialog();
    void hidePopup();
    void currentActivityInformationChanged(QString name, QString icon);

    void activityAdded(QString);
    void activityRemoved(QString);

    void cloningStarted();
    void cloningEnded();
    void cloningCopyWorkareas(QString from, QString to);

    void activitiesLoading(bool);

public slots:
    void activityAddedSlot(QString id);
    void activityRemovedSlot(QString id);
    void activityUpdatedSlot();
    void activityStateChangedSlot();
    void currentActivityChangedSlot(const QString &);

    void updateWallpaper(QString);

    //SIGNALS FROM THE PLUGINS
    void showWidgetsEndedSlot();

    void cloningEndedSlot();

    void changeWorkareaEnded(QString, int);

    void addActivityEnded();

    Q_INVOKABLE void setCurrentActivityAndDesktop(QString, int);

private:

    KActivities::Controller *m_activitiesCtrl;
    Plasma::Containment *m_mainContainment;
    Plasma::Corona *m_corona;

    QString activityForDelete;

    PluginShowWidgets *m_plShowWidgets;
    PluginCloneActivity *m_plCloneActivity;
    PluginChangeWorkarea *m_plChangeWorkarea;
    PluginAddActivity *m_plAddActivity;

    Plasma::Containment *getContainment(QString actId);

    bool m_firstTime;
    int m_nextDefaultWallpaper;

    ActivitiesEnhancedModel *m_actModel;

    QString stateToString(int);
    QString nextRunningActivity();
    QString previousRunningActivity();
    QString getNextDefWallpaper();
};

#endif // ACTIVITYMANAGER_H
