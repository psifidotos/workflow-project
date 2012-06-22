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
    Q_INVOKABLE QString getDesktopName(int n);

    void setQMlObject(QObject *obj,Plasma::DataEngine *engin);

signals:
    void taskAddedIn(QVariant,QVariant,QVariant,QVariant,QVariant,QVariant,QVariant,QVariant,QVariant);
    void taskRemovedIn(QVariant);
    void taskUpdatedIn(QVariant,QVariant,QVariant,QVariant,QVariant,QVariant,QVariant,QVariant);
    void currentDesktopChanged(QVariant);

public slots:
 //void dataUpdated(QString source, Plasma::DataEngine::Data data);
  void taskAdded(::TaskManager::Task *);
  void taskRemoved(::TaskManager::Task *);
  void taskUpdated(::TaskManager::TaskChanges changes);
  void desktopChanged(int);

private:
    TaskManager::TaskManager *taskMainM;
    KWindowSystem *kwinSystem;
    
    QObject *qmlTaskEngine;
  //  Plasma::DataEngine *plasmaTaskEngine;

};

#endif // PTASKMANAGER_H
