#ifndef PTASKMANAGER_H
#define PTASKMANAGER_H

#include <QObject>

#include <taskmanager/taskmanager.h>
#include <KWindowSystem>

#include <Plasma/DataEngine>

class PTaskManager : public QObject
{
    Q_OBJECT
public:
    explicit PTaskManager(QObject *parent = 0);
    ~PTaskManager();

    Q_INVOKABLE void setOnDesktop(QString id, int desk);
    Q_INVOKABLE void setOnAllDesktops(QString id, bool b);
    Q_INVOKABLE void closeTask(QString id);
    Q_INVOKABLE void activateTask(QString id);
    Q_INVOKABLE void setCurrentDesktop(int desk);

    void setQMlObject(QObject *obj,Plasma::DataEngine *engin);

signals:
    void taskAddedIn(QVariant source,QVariant onalld,QVariant onalla,QVariant classc,QVariant nam,
                     QVariant icn,QVariant  indrag,QVariant  desk,QVariant  activit);
    //void activityUpdatedIn(QVariant id, QVariant title, QVariant icon, QVariant stat, QVariant cur);

public slots:
  void dataUpdated(QString source, Plasma::DataEngine::Data data);
  void taskAdded(QString id);
  void taskRemoved(QString id);

private:
    TaskManager::TaskManager *taskMainM;
    KWindowSystem *kwinSystem;
    
    QObject *qmlTaskEngine;
    Plasma::DataEngine *plasmaTaskEngine;

};

#endif // PTASKMANAGER_H
