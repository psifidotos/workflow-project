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

    Q_INVOKABLE QString addActivity(const QString &name);
    Q_INVOKABLE void removeActivity(const QString &name);
    Q_INVOKABLE void startActivity(const QString &name);
    Q_INVOKABLE void stopActivity(const QString &name);
    Q_INVOKABLE QString currentActivity() const;

private:
    KActivities::Controller *m_controller;
};

#endif /* ACTIVITYMANAGER_H */
