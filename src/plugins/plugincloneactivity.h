#ifndef PLUGINCLONEACTIVITY_H
#define PLUGINCLONEACTIVITY_H

#include <QTimer>

#include <KActivities/Controller>

#include <taskmanager/taskmanager.h>

#include "../workflow.h"

namespace KActivities
{
class Controller;
}

class PluginCloneActivity : public QObject
{
    Q_OBJECT
public:
    explicit PluginCloneActivity(WorkFlow *, KActivities::Controller *);
    ~PluginCloneActivity();

    void execute(QString);
    void init();

signals:
    void cloningStarted();
    void copyWorkareas(QString,QString);
    void updateWallpaper(QString);
    void cloningEnded();

protected slots:
    void activityAddedSlot(QString);
    void activityStateChangedSlot();


private slots:
  void timerTrigerred();

private:

    WorkFlow *m_plasmoid;
    KActivities::Controller *m_activitiesCtrl;
    TaskManager::TaskManager *m_taskMainM;
    KStandardDirs kStdDrs;

    QTimer *m_timer;

    QString m_fromActivity;
    QString m_fromActivityContainmentId;
    QString m_fromCloneActivityText;

    QString m_toActivity;
    QString m_toActivityContainmentId;

    bool m_fromActivityWasCurrent;
    int m_timerPhase;

    void initCloningPhase02();
    void initCloningPhase04();
    void initCloningPhase05();

    QString getContainmentId(QString) const;
    int loadCloneActivitySettings();
    int storeCloneActivitySettings();
};

#endif
