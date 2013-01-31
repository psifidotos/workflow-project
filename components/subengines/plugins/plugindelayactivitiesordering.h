#ifndef PLUGINDELAYACTIVITIESORDERING_H
#define PLUGINDELAYACTIVITIESORDERING_H

#include <QTimer>


//Delays apply ordering of activities in order
//for the application to be more responsive
class PluginDelayActivitiesOrdering : public QObject
{
    Q_OBJECT
public:
    explicit PluginDelayActivitiesOrdering(QObject *);
    ~PluginDelayActivitiesOrdering();

    void execute();

signals:
    void orderActivitiesTriggered();

protected:
    void init();

private:
    QTimer *m_timer;
};

#endif
