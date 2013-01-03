#ifndef PLUGINCHANGEWORKAREA_H
#define PLUGINCHANGEWORKAREA_H

#include <QObject>

#include <KActivities/Controller>

#include <KWindowSystem>

namespace KActivities
{
class Controller;
class Info;
}

//Helps in going to a workarea. Problem was that
//the movement could not be made at the same time
//for changing activity and the workarea (desktop)
//the solution is to be sequential. First we change
//activity and when we change desktop
class PluginChangeWorkarea : public QObject
{
    Q_OBJECT
public:
    explicit PluginChangeWorkarea(QObject *, KActivities::Controller *);
    ~PluginChangeWorkarea();

    void execute(QString, int);

protected:
    void init();

signals:
    void changeWorkareaEnded(QString, int);

public slots:
    void currentActivityChangedSlot(QString);

private:
    KActivities::Controller *m_activitiesCtrl;
    KWindowSystem *m_kwinSystem;

    QString m_toActivity;
    int m_toDesktop;
};

#endif
