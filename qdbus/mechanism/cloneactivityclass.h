#ifndef CLONEACTIVITYCLASS_H
#define CLONEACTIVITYCLASS_H

#include <QTimer>

#include <KActivities/Controller>
#include <KStandardDirs>

#include <taskmanager/taskmanager.h>

namespace KActivities
{
    class Controller;
}

//Clones an activity and creates many signals
//in the process in order to update the workareas and
//the backgrounds of the relevant activities
class CloneActivityClass : public QObject
{
    Q_OBJECT
public:
    explicit CloneActivityClass(QObject *, KActivities::Controller *);
    ~CloneActivityClass();

    void execute(QString);

protected:
    void init();

signals:
    void cloningStarted(bool updateWallpapers);
    void copyWorkareas(QString,QString);
    //void updateWallpaper(QString);
    void cloningEnded(bool updateWallpapers);

protected slots:
    void activityAddedSlot(QString);
    void activityStateChangedSlot();

private slots:
  void timerTrigerred();

private:
    KActivities::Controller *m_activitiesCtrl;
    KStandardDirs kStdDrs;

    QTimer *m_timer;

    QString m_currentActivityInBegin;

    QString m_fromActivity;
    QString m_fromActivityContainmentId;
    QString m_fromCloneActivityText;

    QString m_toActivity;
    QString m_toActivityContainmentId;

    int m_timerPhase;

    void initCloningPhase02();
    void initCloningPhase04();
    void initCloningPhase05();

    QString getContainmentId(QString) const;
    int loadCloneActivitySettings();
    int storeCloneActivitySettings();
};

#endif
