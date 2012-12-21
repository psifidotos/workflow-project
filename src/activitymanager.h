#ifndef ACTIVITYMANAGER_H
#define ACTIVITYMANAGER_H

#include <QObject>

#include <KStandardDirs>
#include <KActivities/Controller>
#include <KConfigGroup>

#include <QTimer>

class WorkFlow;
class PluginShowWidgets;
class PluginCloneActivity;

namespace KActivities
{
    class Controller;
    class Info;
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

//  Q_INVOKABLE void cloneCurrentActivity();
//  Q_INVOKABLE void createActivity(const QString &pluginName);
//  Q_INVOKABLE void createActivityFromScript(const QString &script, const QString &name, const QString &icon, const QStringList &startupApps);
//  Q_INVOKABLE void downloadActivityScripts();

    Q_INVOKABLE QString getWallpaper(QString source);
    Q_INVOKABLE QPixmap disabledPixmapForIcon(const QString &ic);
    Q_INVOKABLE QString add(QString name);
//    Q_INVOKABLE void clone(QString id, QString name);
    Q_INVOKABLE void setCurrent(QString id);
    Q_INVOKABLE void stop(QString id);
    Q_INVOKABLE void start(QString id);
    Q_INVOKABLE void setName(QString id, QString name);
    Q_INVOKABLE void remove(QString id);
    Q_INVOKABLE QString chooseIcon(QString);
    Q_INVOKABLE void setIcon(QString id, QString name);

    //are used in cloning
    Q_INVOKABLE void initCloningPhase02(QString id);
    Q_INVOKABLE void initCloningPhase04(QString id);
//    Q_INVOKABLE int askForDelete(QString activityName);

    //Interact with Corona() and Desktops Containments()

    Q_INVOKABLE void showWidgetsExplorer(QString);
    Q_INVOKABLE void cloneActivity(QString);

    void setQMlObject(QObject *,Plasma::Corona *, WorkFlow *);
    void setCurrentNextActivity();
    void setCurrentPreviousActivity();

signals:
    void activityAddedIn(QVariant id, QVariant title, QVariant icon, QVariant stat, QVariant cur);
    void activityUpdatedIn(QVariant id, QVariant title, QVariant icon, QVariant stat, QVariant cur);
    void showedIconDialog();
    void answeredIconDialog();

public slots:
 // void dataUpdated(QString source, Plasma::DataEngine::Data data);
  void activityAdded(QString id);
  void activityRemoved(QString id);
  void activityDataChanged();
  void activityStateChanged();
  void currentActivityChanged(const QString &);

  void updateWallpaper(QString);

  void cloningStartedSlot();
  void cloningEndedSlot();
  void copyWorkareasSlot(QString,QString);

private slots:
  void timerTrigerred();

private:

    QString getContainmentId(QString txt) const;

    int loadCloneActivitySettings();
    int storeCloneActivitySettings();

    QObject *qmlActEngine;

    KActivities::Controller *m_activitiesCtrl;
    QString activityForDelete;

    KStandardDirs kStdDrs;

    QString fromCloneActivityText;
    QString fromCloneActivityId;
    QString fromCloneContainmentId;

    QString toCloneContainmentId;
    QString toCloneActivityId;

    Plasma::Corona *m_corona;

    int m_timerPhase;

    QTimer *m_timer;

    //This is an indicator for the corona() actions in order to check
    //if widgets are already unlocked.
    QString m_unlockWidgetsText;
    WorkFlow *m_plasmoid;

    PluginShowWidgets *m_plShowWidgets;
    PluginCloneActivity *m_plCloneActivity;

    ////////////
    Plasma::Containment *getContainment(QString actId);
};

#endif // ACTIVITYMANAGER_H
