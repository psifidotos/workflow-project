#ifndef PTASKMANAGER_H
#define PTASKMANAGER_H

#include <QObject>

#include <taskmanager/taskmanager.h>
#include <KWindowSystem>
#include <KTempDir>

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

#ifdef Q_WS_X11
    Q_INVOKABLE void slotAddDesktop();
    Q_INVOKABLE void slotRemoveDesktop();
    Q_INVOKABLE void setOnlyOnActivity(QString, QString);
    Q_INVOKABLE void setOnAllActivities(QString);
#endif

    Q_INVOKABLE inline QObject *model(){return m_taskModel;}
    Q_INVOKABLE inline QObject *subModel(){return m_taskSubModel;}
    Q_INVOKABLE void setSubModel(QString, int, bool everywhere = false);
    Q_INVOKABLE void emptySubModel();

signals:
    void taskRemoved(QString win);
    void hidePopup();

protected:
    void init();

public slots:
 //void dataUpdated(QString source, Plasma::DataEngine::Data data);
  void taskAdded(::TaskManager::Task *);
  void taskRemoved(::TaskManager::Task *);
  void taskUpdated(::TaskManager::TaskChanges changes);

private:
    TaskManager::TaskManager *taskMainM;
    KWindowSystem *kwinSystem;
    
    QObject *qmlTaskEngine;

    ListModel *m_taskModel;
    ListModel *m_taskSubModel;

};

#endif // PTASKMANAGER_H
