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
    foreach (const QString source, plasmaTaskEngine->sources())
        plasmaTaskEngine->disconnectSource(source, this);
}

void PTaskManager::setQMlObject(QObject *obj, Plasma::DataEngine *engin)
{
    qmlTaskEngine = obj;
    plasmaTaskEngine = engin;

    connect(this, SIGNAL(taskAddedIn(QVariant,QVariant,QVariant,QVariant,QVariant,QVariant,QVariant,QVariant,QVariant)),
            qmlTaskEngine,SLOT(taskAddedIn(QVariant,QVariant,QVariant,QVariant,QVariant,QVariant,QVariant,QVariant,QVariant)));

    //   connect(this, SIGNAL(activityUpdatedIn(QVariant,QVariant,QVariant,QVariant,QVariant)),
    //          qmlActEngine,SLOT(activityUpdatedIn(QVariant,QVariant,QVariant,QVariant,QVariant)));

    foreach (const QString source, plasmaTaskEngine->sources())
        taskAdded(source);

    // activity addition and removal
    connect(plasmaTaskEngine, SIGNAL(sourceAdded(QString)), this, SLOT(taskAdded(QString)));
    connect(plasmaTaskEngine, SIGNAL(sourceRemoved(QString)), this, SLOT(taskRemoved(QString)));
}
///////////


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

        qDebug()<<source;
    }
    /*   else
    {
        emit activityUpdatedIn(QVariant(source),
                               QVariant(data["Name"].toString()),
                               QVariant(data["Icon"].toString()),
                               QVariant(data["State"].toString()),
                               QVariant(data["Current"].toBool()));
    }*/

}

void PTaskManager::taskAdded(QString id) {

    plasmaTaskEngine->connectSource(id, this);

}

void PTaskManager::taskRemoved(QString id) {

    QVariant returnedValue;

    QMetaObject::invokeMethod(qmlTaskEngine, "removeTaskIn",
                              Q_ARG(QVariant, id));

    plasmaTaskEngine->disconnectSource(id, this);

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
