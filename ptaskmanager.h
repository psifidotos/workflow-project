#ifndef PTASKMANAGER_H
#define PTASKMANAGER_H

#include <QObject>

#include <taskmanager/taskmanager.h>
#include <KWindowSystem>

class PTaskManager : public QObject
{
    Q_OBJECT
public:
    explicit PTaskManager(QObject *parent = 0);

    Q_INVOKABLE void setOnDesktop(QString id, int desk);
    Q_INVOKABLE void setOnAllDesktops(QString id, bool b);
    Q_INVOKABLE void closeTask(QString id);
    Q_INVOKABLE void activateTask(QString id);
    Q_INVOKABLE void setCurrentDesktop(int desk);

signals:
    
public slots:

private:
    TaskManager::TaskManager *taskMainM;
    KWindowSystem *kwinSystem;
    
};

#endif // PTASKMANAGER_H
