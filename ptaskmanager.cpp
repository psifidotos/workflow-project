#include "ptaskmanager.h"


#include <KDebug>
#include <KWindowSystem>

#include <taskmanager/task.h>


#include <Plasma/Service>
#include <Plasma/ServiceJob>
#include <Plasma/DataEngine>


PTaskManager::PTaskManager(QObject *parent) :
    QObject(parent)
{
    taskMainM = TaskManager::TaskManager::self();

    kwinSystem = KWindowSystem::KWindowSystem::self();
}


PTaskManager::~PTaskManager(){
    //  foreach (const QString source, plasmaTaskEngine->sources())
    //     plasmaTaskEngine->disconnectSource(source, this);
}

void PTaskManager::setQMlObject(QObject *obj, Plasma::DataEngine *engin)
{
    qmlTaskEngine = obj;

    connect(this, SIGNAL(taskAddedIn(QVariant,QVariant,QVariant,QVariant,QVariant,QVariant,QVariant,QVariant,QVariant)),
            qmlTaskEngine,SLOT(taskAddedIn(QVariant,QVariant,QVariant,QVariant,QVariant,QVariant,QVariant,QVariant,QVariant)));

    connect(this, SIGNAL(taskRemovedIn(QVariant)),
            qmlTaskEngine,SLOT(taskRemovedIn(QVariant)));

    connect(this, SIGNAL(taskUpdatedIn(QVariant,QVariant,QVariant,QVariant,QVariant,QVariant,QVariant,QVariant)),
            qmlTaskEngine,SLOT(taskUpdatedIn(QVariant,QVariant,QVariant,QVariant,QVariant,QVariant,QVariant,QVariant)));


    foreach (TaskManager::Task *source, taskMainM->tasks())
        taskAdded(source);

    // activity addition and removal
    connect(taskMainM , SIGNAL(taskAdded(::TaskManager::Task *)), this, SLOT(taskAdded(::TaskManager::Task *)));
    connect(taskMainM , SIGNAL(taskRemoved(::TaskManager::Task *)), this, SLOT(taskRemoved(::TaskManager::Task *)));
}
///////////

/*
void PTaskManager::dataUpdated(QString source, Plasma::DataEngine::Data data) {
    //if (!m_activities.contains(source))
    //return;
    QVariant returnedValue;

    QMetaObject::invokeMethod(qmlTaskEngine, "getIndexFor",
                              Q_RETURN_ARG(QVariant, returnedValue),
                              Q_ARG(QVariant, source));

    if(returnedValue.toInt() == -1)
    {

        emit taskAddedIn(QVariant(source),
                         data["onAllDesktops"],
                         data["onAllActivities"],
                         data["classClass"],
                         data["name"],
                         data["icon"],
                         QVariant(false),
                         data["desktop"],
                         data["activities"]);
*/
//   qDebug()<<source;
// }
/*   else
    {
        emit activityUpdatedIn(QVariant(source),
                               QVariant(data["Name"].toString()),
                               QVariant(data["Icon"].toString()),
                               QVariant(data["State"].toString()),
                               QVariant(data["Current"].toBool()));
    }*/

//}

void PTaskManager::taskAdded(::TaskManager::Task *task)
{
    QString wId;
    wId.setNum(task->window());

    qDebug()<<"WinAdded:"<<wId;
    emit taskAddedIn(QVariant(wId),
                     QVariant(task->isOnAllDesktops()),
                     QVariant(task->isOnAllActivities()),
                     QVariant(task->classClass()),
                     QVariant(task->name()),
                     QVariant(task->icon()),
                     QVariant(false),
                     QVariant(task->desktop()),
                     QVariant(task->activities()));

    connect(task,SIGNAL(changed(::TaskManager::TaskChanges)),this,SLOT(taskUpdated(::TaskManager::TaskChanges)));
}

void PTaskManager::taskRemoved(::TaskManager::Task *task) {

    QString wId;
    wId.setNum(task->window());

   // QMetaObject::invokeMethod(qmlTaskEngine, "taskRemovedIn",
     //                         Q_ARG(QVariant, wId));

    emit taskRemovedIn(QVariant(wId));
    /*                     QVariant(task->isOnAllDesktops()),
                     QVariant(task->isOnAllActivities()),
                     QVariant(task->classClass()),
                     QVariant(task->name()),
                     QVariant(task->icon()),
                     QVariant(false),
                     QVariant(task->desktop()),
                     QVariant(task->activities()));*/
    disconnect(task,SIGNAL(changed(::TaskManager::TaskChanges)),this,SLOT(taskUpdated(::TaskManager::TaskChanges)));
}

void PTaskManager::taskUpdated(::TaskManager::TaskChanges changes){
    ::TaskManager::Task *task = qobject_cast< ::TaskManager::Task * >(sender());

    if (!task) {
        return;
    }
    QString wId;
    wId.setNum(task->window());

    // only a subset of task information is exported
    switch (changes) {
    case TaskManager::EverythingChanged:
    case TaskManager::IconChanged:
    case TaskManager::NameChanged:
    case TaskManager::DesktopChanged:
    case TaskManager::ActivitiesChanged:
        emit taskUpdatedIn(QVariant(wId),
                           QVariant(task->isOnAllDesktops()),
                           QVariant(task->isOnAllActivities()),
                           QVariant(task->classClass()),
                           QVariant(task->name()),
                           QVariant(task->icon()),
                           QVariant(task->desktop()),
                           QVariant(task->activities()));

        break;
    default:
        break;
    }
}

///INVOKES

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
