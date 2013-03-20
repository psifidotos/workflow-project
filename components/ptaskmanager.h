#ifndef PTASKMANAGER_H
#define PTASKMANAGER_H

#include <QObject>

#include <KWindowSystem>
#include <KActivities/Controller>

#include "models/listmodel.h"


class PTaskManager : public QObject
{
    Q_OBJECT
public:
    explicit PTaskManager(QObject *parent = 0);
    ~PTaskManager();

    Q_INVOKABLE void setOnDesktop(QString id, int desk);
    Q_INVOKABLE void setOnAllDesktops(QString id, bool b);
    Q_INVOKABLE void removeTask(QString id);
    Q_INVOKABLE void activateTask(QString id);
    Q_INVOKABLE void minimizeTask(QString id);
    Q_INVOKABLE void setCurrentDesktop(int desk);

    Q_INVOKABLE QPixmap disabledPixmapForIcon(const QIcon &ic);
    Q_INVOKABLE void hideDashboard();
    Q_INVOKABLE void showDashboard();

    Q_INVOKABLE void setTaskState(QString wId, QString state, QString activity="", int desktop = -1);
    Q_INVOKABLE void setTaskActivityForAnimation(QString, QString);
    Q_INVOKABLE void setTaskDesktopForAnimation(QString, int);
    Q_INVOKABLE QStringList getTaskActivities(QString);
    Q_INVOKABLE QIcon getTaskIcon(QString);

    Q_INVOKABLE int tasksNumber(QString activity, int desktop, bool everywhereEnabled, QString excludeWindow = "", QString filter = "");
    Q_INVOKABLE QString windowState(QString window);
#ifdef Q_WS_X11
    Q_INVOKABLE void slotAddDesktop();
    Q_INVOKABLE void slotRemoveDesktop();
    Q_INVOKABLE void setOnlyOnActivity(QString, QString);
    Q_INVOKABLE void setOnAllActivities(QString);
#endif
    Q_INVOKABLE inline QObject *model(){return m_taskModel;}

    //These functions are created in order to workaround the issue
    //that from kwin scripting no signal triggering from KWindowSystem
    //should be invoked - caught
    Q_INVOKABLE void initSignals();
    Q_INVOKABLE bool windowAddedSlot(QString id);
    Q_INVOKABLE void windowRemovedSlot(QString id);
    Q_INVOKABLE void windowChangedSlot(QString id);

signals:
    void taskRemoved(QString win);
    void hidePopup();

protected:
    void init();

private slots:
 //void dataUpdated(QString source, Plasma::DataEngine::Data data);
    void windowAddedSlot(WId id);
    void windowRemovedSlot(WId id);
    void windowChangedSlot(WId id, const unsigned long *properties);

 /* void taskAdded(::TaskManager::Task *);
  void taskRemoved(::TaskManager::Task *);
  void taskUpdated(::TaskManager::TaskChanges changes);*/

private:
    KActivities::Controller *m_controller;
    KWindowSystem *kwinSystem;
    
    QObject *qmlTaskEngine;

    ListModel *m_taskModel;

    void updateValues(QString);
};

#endif // PTASKMANAGER_H
