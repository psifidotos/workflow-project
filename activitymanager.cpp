#include "activitymanager.h"

#include <QDeclarativeEngine>

#include <QDBusInterface>

#include <Plasma/Service>
#include <Plasma/ServiceJob>
#include <Plasma/Applet>
#include <Plasma/DataEngineManager>
#include <Plasma/DataEngine>


#include <KIconDialog>
#include <KWindowSystem>
#include <KConfigGroup>



ActivityManager::ActivityManager(QObject *parent) :
    QObject(parent)
{
}

ActivityManager::~ActivityManager()
{
}

void ActivityManager::setQMlObject(QObject *obj, Plasma::DataEngine *engin)
{
    qmlActEngine = obj;
    plasmaActEngine = engin;

    connect(this, SIGNAL(activityAddedIn(QVariant,QVariant,QVariant,QVariant,QVariant)),
            qmlActEngine,SLOT(activityAddedIn(QVariant,QVariant,QVariant,QVariant,QVariant)));

    // connect data sources

    foreach (const QString source, plasmaActEngine->sources())
      activityAdded(source);

    // activity addition and removal
    connect(plasmaActEngine, SIGNAL(sourceAdded(QString)), this, SLOT(activityAdded(QString)));
    connect(plasmaActEngine, SIGNAL(sourceRemoved(QString)), this, SLOT(activityRemoved(QString)));
}


void ActivityManager::dataUpdated(QString source, Plasma::DataEngine::Data data) {
  //if (!m_activities.contains(source))
    //return;



    QVariant returnedValue;
    //QVariant  = "Hello from C++";
    QMetaObject::invokeMethod(qmlActEngine, "getIndexFor",
             Q_RETURN_ARG(QVariant, returnedValue),
             Q_ARG(QVariant, source));

    if(returnedValue.toInt() == -1)
    {
        emit activityAddedIn(QVariant(source),
                             QVariant(data["Name"].toString()),
                             QVariant(data["Icon"].toString()),
                             QVariant(data["State"].toString()),
                             QVariant(data["Current"].toBool()));
    }
  /*
  ActivityWidget *activity = m_activities[source];
  // update activity info
  activity->setName(data["Name"].toString());
  activity->setState(data["State"].toString());
  activity->setIcon(data["Icon"].toString());
  activity->setCurrent(data["Current"].toBool());
  // update current activity name and icon
  if (data["Current"].toBool()) {
    m_currentName = data["Name"].toString();
    m_currentIcon = data["Icon"].toString();
  }
  // sort activities */
 // sortActivities();
}

void ActivityManager::activityAdded(QString id) {
  // skip the Status source
  if (id == "Status")
    return;
  // create a new activity object
 // ActivityWidget *activity = new ActivityWidget(extender()->item("Activities"), id);
  // add activity to the list
//  m_activities.insert(id, activity);
  // connect activity update signal

  plasmaActEngine->connectSource(id, this);
  // connect activity start/stop signals
//  connect(activity, SIGNAL(setCurrent(QString)), this, SLOT(setCurrent(QString)));
//  connect(activity, SIGNAL(startActivity(QString)), this, SLOT(start(QString)));
//  connect(activity, SIGNAL(stopActivity(QString)), this, SLOT(stop(QString)));
//  connect(activity, SIGNAL(addActivity(QString)), this, SLOT(add(QString)));
//  connect(activity, SIGNAL(removeActivity(QString)), this, SLOT(remove(QString)));
//  connect(activity, SIGNAL(renameActivity(QString,QString)), this, SLOT(setName(QString,QString)));
}

void ActivityManager::activityRemoved(QString id) {
 // if (!m_activities.contains(id))
 //   return;
  // delete the activity
 // delete m_activities.take(id);
}




void ActivityManager::setIcon(QString id, QString name) const
{
  Plasma::Service *service = plasmaActEngine->serviceForSource(id);
  KConfigGroup op = service->operationDescription("setIcon");
  op.writeEntry("Icon", name);
  Plasma::ServiceJob *job = service->startOperationCall(op);
  connect(job, SIGNAL(finished(KJob*)), service, SLOT(deleteLater()));
}

QString ActivityManager::chooseIcon(QString id) const
{
    KIconDialog *dialog = new KIconDialog;
    dialog->setup(KIconLoader::Desktop);
    dialog->setProperty("DoNotCloseController", true);
    KWindowSystem::setOnDesktop(dialog->winId(), KWindowSystem::currentDesktop());
    dialog->showDialog();
    KWindowSystem::forceActiveWindow(dialog->winId());
    QString icon = dialog->openDialog();
    dialog->deleteLater();

    if (icon != "")
        ActivityManager::setIcon(id,icon);

    return icon;
}

void ActivityManager::add(QString id, QString name) {
  Plasma::Service *service = plasmaActEngine->serviceForSource(id);
  KConfigGroup op = service->operationDescription("add");
  op.writeEntry("Name", name);
  Plasma::ServiceJob *job = service->startOperationCall(op);
  connect(job, SIGNAL(finished(KJob*)), service, SLOT(deleteLater()));
}

void ActivityManager::clone(QString id, QString name, QString icon) {
  Plasma::Service *service = plasmaActEngine->serviceForSource(id);
  KConfigGroup op = service->operationDescription("add");
  op.writeEntry("Name", name);
  Plasma::ServiceJob *job = service->startOperationCall(op);
  connect(job, SIGNAL(finished(KJob*)), service, SLOT(deleteLater()));
}

void ActivityManager::setCurrent(QString id) {
  Plasma::Service *service = plasmaActEngine->serviceForSource(id);
  Plasma::ServiceJob *job = service->startOperationCall(service->operationDescription("setCurrent"));
  connect(job, SIGNAL(finished(KJob*)), service, SLOT(deleteLater()));
}

void ActivityManager::stop(QString id) {
  // TODO: when activity is stopped, take a screenshot and use that icon
  Plasma::Service *service = plasmaActEngine->serviceForSource(id);
  Plasma::ServiceJob *job = service->startOperationCall(service->operationDescription("stop"));
  connect(job, SIGNAL(finished(KJob*)), service, SLOT(deleteLater()));
}

void ActivityManager::start(QString id) {
  Plasma::Service *service = plasmaActEngine->serviceForSource(id);
  Plasma::ServiceJob *job = service->startOperationCall(service->operationDescription("start"));
  connect(job, SIGNAL(finished(KJob*)), service, SLOT(deleteLater()));
}

void ActivityManager::setName(QString id, QString name) {
  Plasma::Service *service = plasmaActEngine->serviceForSource(id);
  KConfigGroup op = service->operationDescription("setName");
  op.writeEntry("Name", name);
  Plasma::ServiceJob *job = service->startOperationCall(op);
  connect(job, SIGNAL(finished(KJob*)), service, SLOT(deleteLater()));
}

void ActivityManager::remove(QString id) {
  ActivityManager::stop(id);

  Plasma::Service *service = plasmaActEngine->serviceForSource(id);
  KConfigGroup op = service->operationDescription("remove");
  op.writeEntry("Id", id);
  Plasma::ServiceJob *job = service->startOperationCall(op);
  connect(job, SIGNAL(finished(KJob*)), service, SLOT(deleteLater()));

  //KActivities::Consumer *m_C = new KActivities::Consumer(this);
  //m_C->removeActivity(id);
//  KActivities::Controller().removeActivity(id);

}


#include "activitymanager.moc"
