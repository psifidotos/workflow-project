#ifndef PLUGINADDACTIVITY_H
#define PLUGINADDACTIVITY_H

#include <QObject>

#include <KActivities/Controller>


namespace KActivities
{
class Controller;
}

//Adds a new activity but creates signals to update the workreas
//in the process and to update the wallpaper
class PluginAddActivity : public QObject
{
    Q_OBJECT
public:
    explicit PluginAddActivity(QObject *, KActivities::Controller *);
    ~PluginAddActivity();

    void execute(QString);

signals:
    void addActivityEnded();

protected:
    void init();

public slots:
    void activityAddedSlot(QString);
    void currentActivityChangedSlot(QString);
    void activityStateChangedSlot();

private:
    KActivities::Controller *m_activitiesCtrl;
    QString m_previousActivity;
    QString m_newActivity;
};

#endif
