#ifndef ACTIVITYMANAGER_H
#define ACTIVITYMANAGER_H
#include <QObject>
#include <KActivities/Controller>

/* A simple wrapper around KActivities::Controller */
class ActivityManager : public QObject
{
    Q_OBJECT
public:
    explicit ActivityManager(QObject *parent = 0);
    ~ActivityManager();

private:
    KActivities::Controller *m_controller;
};

#endif /* ACTIVITYMANAGER_H */
