#include "ptaskmanager.h"


#include <KDebug>
#include <KWindowSystem>

#include <taskmanager/task.h>


PTaskManager::PTaskManager(QObject *parent) :
    QObject(parent)
{
    taskMainM = TaskManager::TaskManager::self();

    kwinSystem = KWindowSystem::KWindowSystem::self();
}

void PTaskManager::setOnDesktop(QString id, int desk)
{
    TaskManager::Task *t = taskMainM->findTask(id.toULong());
    t->toDesktop(desk);
    kwinSystem->setOnDesktop(id.toULong(),desk);
}

void PTaskManager::setOnAllDesktops(QString id, bool b)
{
    kwinSystem->setOnAllDesktops(id.toULong(), b);
}

void PTaskManager::closeTask(QString id)
{
    TaskManager::Task *t = taskMainM->findTask(id.toULong());
    t->close();
}

void PTaskManager::activateTask(QString id)
{
    TaskManager::Task *t = taskMainM->findTask(id.toULong());
 //   t->restore();
    t->activate();
}

void PTaskManager::setCurrentDesktop(int desk)
{
    kwinSystem->setCurrentDesktop(desk);
}



#include "ptaskmanager.moc"
