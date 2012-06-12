#include "activitymanager.h"

#include <QDeclarativeEngine>

#include <Plasma/Service>
#include <Plasma/ServiceJob>
#include <Plasma/Applet>
#include <Plasma/DataEngineManager>


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

void ActivityManager::setIcon(QString id, QString name) const
{
  Plasma::Service *service = Plasma::DataEngineManager::self()->engine("org.kde.activities")->serviceForSource(id);
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
  Plasma::Service *service = Plasma::DataEngineManager::self()->engine("org.kde.activities")->serviceForSource(id);
  KConfigGroup op = service->operationDescription("add");
  op.writeEntry("Name", name);
  Plasma::ServiceJob *job = service->startOperationCall(op);
  connect(job, SIGNAL(finished(KJob*)), service, SLOT(deleteLater()));
}

void ActivityManager::clone(QString id, QString name, QString icon) {
  Plasma::Service *service = Plasma::DataEngineManager::self()->engine("org.kde.activities")->serviceForSource(id);
  KConfigGroup op = service->operationDescription("add");
  op.writeEntry("Name", name);
  Plasma::ServiceJob *job = service->startOperationCall(op);
  connect(job, SIGNAL(finished(KJob*)), service, SLOT(deleteLater()));
}

void ActivityManager::setCurrent(QString id) {
  Plasma::Service *service = Plasma::DataEngineManager::self()->engine("org.kde.activities")->serviceForSource(id);
  Plasma::ServiceJob *job = service->startOperationCall(service->operationDescription("setCurrent"));
  connect(job, SIGNAL(finished(KJob*)), service, SLOT(deleteLater()));
}

void ActivityManager::stop(QString id) {
  // TODO: when activity is stopped, take a screenshot and use that icon
  Plasma::Service *service = Plasma::DataEngineManager::self()->engine("org.kde.activities")->serviceForSource(id);
  Plasma::ServiceJob *job = service->startOperationCall(service->operationDescription("stop"));
  connect(job, SIGNAL(finished(KJob*)), service, SLOT(deleteLater()));
}

void ActivityManager::start(QString id) {
  Plasma::Service *service = Plasma::DataEngineManager::self()->engine("org.kde.activities")->serviceForSource(id);
  Plasma::ServiceJob *job = service->startOperationCall(service->operationDescription("start"));
  connect(job, SIGNAL(finished(KJob*)), service, SLOT(deleteLater()));
}

void ActivityManager::setName(QString id, QString name) {
  Plasma::Service *service = Plasma::DataEngineManager::self()->engine("org.kde.activities")->serviceForSource(id);
  KConfigGroup op = service->operationDescription("setName");
  op.writeEntry("Name", name);
  Plasma::ServiceJob *job = service->startOperationCall(op);
  connect(job, SIGNAL(finished(KJob*)), service, SLOT(deleteLater()));
}

void ActivityManager::remove(QString id) {
  ActivityManager::stop(id);

  Plasma::Service *service = Plasma::DataEngineManager::self()->engine("org.kde.activities")->serviceForSource(id);
  KConfigGroup op = service->operationDescription("remove");
  op.writeEntry("Id", id);
  Plasma::ServiceJob *job = service->startOperationCall(op);
  connect(job, SIGNAL(finished(KJob*)), service, SLOT(deleteLater()));
}


#include "activitymanager.moc"
