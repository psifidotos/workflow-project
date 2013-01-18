#ifndef PLUGINREMOVEACTIVITY_H
#define PLUGINREMOVEACTIVITY_H

#include <QObject>

#include <KActivities/Controller>


namespace KActivities
{
class Controller;
class Info;
}

//DEPRECATED PLUGIN. This class was fixing the issue
//in which a running activity couldnt be deleted if
//it wasnt stopped. Ghosts activities were shown in
//the activities lists
class PluginRemoveActivity : public QObject
{
    Q_OBJECT
public:
    explicit PluginRemoveActivity(QObject *, KActivities::Controller *);
    ~PluginRemoveActivity();

    void execute(QString);

protected:
    void init();

signals:
    void activityRemovedEnded(QString);

public slots:
    void activityStateChanged();

private:
    KActivities::Controller *m_activitiesCtrl;
    KActivities::Info *m_toRemoveActivityInfo;

    QString m_toRemoveActivityId;
};

#endif
