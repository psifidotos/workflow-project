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
    explicit ActivityManager(QObject *parent = 0);
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
    Q_INVOKABLE QString chooseIcon(QString);
    Q_INVOKABLE void setIcon(QString id, QString name);

    //    Q_INVOKABLE int askForDelete(QString activityName);

    Q_INVOKABLE void showWidgetsExplorer(QString);
    Q_INVOKABLE void cloneActivity(QString);



    void setQMlObject(QObject *,Plasma::Containment *, ActivitiesEnhancedModel *);
    void setCurrentNextActivity();
    void setCurrentPreviousActivity();

    QString getCurrentActivityName();
    QString getCurrentActivityIcon();

signals:
    void activityAddedIn(QVariant id, QVariant title, QVariant icon, QVariant stat, QVariant cur);
    void activityUpdatedIn(QVariant id, QVariant title, QVariant icon, QVariant stat, QVariant cur);
    void showedIconDialog();
    void answeredIconDialog();
    void hidePopup();
    void currentActivityInformationChanged(QString name, QString icon);

public slots:
    void activityAdded(QString id);
    void activityRemoved(QString id);
    void activityDataChanged();
    void activityStateChanged();
    void currentActivityChanged(const QString &);

    void updateWallpaper(QString);

    //SIGNALS FROM THE PLUGINS
    void showWidgetsEndedSlot();

    void cloningStartedSlot();
    void cloningEndedSlot();
    void copyWorkareasSlot(QString,QString);

    void changeWorkareaEnded(QString, int);

    void addActivityEnded();

    Q_INVOKABLE void setCurrentActivityAndDesktop(QString, int);

private:

    KActivities::Controller *m_activitiesCtrl;
    Plasma::Containment *m_mainContainment;
    Plasma::Corona *m_corona;

    QObject *qmlActEngine;

    QString activityForDelete;

    PluginShowWidgets *m_plShowWidgets;
    PluginCloneActivity *m_plCloneActivity;
    PluginChangeWorkarea *m_plChangeWorkarea;
    PluginAddActivity *m_plAddActivity;

    Plasma::Containment *getContainment(QString actId);

    bool m_firstTime;

    ActivitiesEnhancedModel *m_actModel;
};

#endif // ACTIVITYMANAGER_H
