#include "activitymanager.h"

#include <QDeclarativeEngine>
#include <QDBusInterface>
#include <QDir>

#include <Plasma/Service>
#include <Plasma/ServiceJob>
#include <Plasma/Applet>
#include <Plasma/DataEngineManager>
#include <Plasma/DataEngine>


#include <KIconDialog>
#include <KIcon>
#include <KWindowSystem>
#include <KConfigGroup>
#include <KMessageBox>
#include <KStandardDirs>



ActivityManager::ActivityManager(QObject *parent) :
    QObject(parent)
{
}

ActivityManager::~ActivityManager()
{
    foreach (const QString source, plasmaActEngine->sources())
        plasmaActEngine->disconnectSource(source, this);
}

void ActivityManager::setQMlObject(QObject *obj, Plasma::DataEngine *engin)
{
    qmlActEngine = obj;
    plasmaActEngine = engin;

    connect(this, SIGNAL(activityAddedIn(QVariant,QVariant,QVariant,QVariant,QVariant)),
            qmlActEngine,SLOT(activityAddedIn(QVariant,QVariant,QVariant,QVariant,QVariant)));

    connect(this, SIGNAL(activityUpdatedIn(QVariant,QVariant,QVariant,QVariant,QVariant)),
            qmlActEngine,SLOT(activityUpdatedIn(QVariant,QVariant,QVariant,QVariant,QVariant)));
    // connect data sources

    foreach (const QString source, plasmaActEngine->sources())
        activityAdded(source);

    // activity addition and removal
    connect(plasmaActEngine, SIGNAL(sourceAdded(QString)), this, SLOT(activityAdded(QString)));
    connect(plasmaActEngine, SIGNAL(sourceRemoved(QString)), this, SLOT(activityRemoved(QString)));
    //connect(plasmaActEngine, SIGNAL(sourceRemoved(QString)), qmlActEngine, SLOT(activityRemovedIn(QVariant(QString))));
}

QString ActivityManager::getWallpaperFromFile(QString source, QString file) const
{
    //QString fpath = QDir::home().filePath(file);
    QString fpath = file;

    KConfig config( fpath, KConfig::SimpleConfig );
    KConfigGroup conGps = config.group("Containments");

    int iterat = 0;
    bool found = false;

    while((iterat<conGps.groupList().size() && (!found))){
        QString gps = conGps.groupList().at(iterat);
        KConfigGroup tempG = conGps.group(gps);

        if(tempG.readPathEntry("activityId",QString("null")) == source){

       //     qDebug()<<"Found:"<<gps<<"-"<<tempG.readPathEntry("activityId",QString("null"));
            KConfigGroup gWall = tempG.group("Wallpaper").group("image");

            found = true;
            QString foundF = gWall.readPathEntry("wallpaper",QString("null"));
            QDir tmD(foundF+"/contents/images");
            if (tmD.exists()){
                QStringList files;
                files = tmD.entryList(QDir::Files | QDir::NoSymLinks);

                if (!files.isEmpty())
                    foundF = tmD.absoluteFilePath(files.at(0));

      //          qDebug()<<files.at(0);
            }

            if (QFile::exists(foundF))
                return foundF;
            else
                return "";
        }


        iterat++;
    }
    return "";

}

QString ActivityManager::getWallpaper(QString source) const
{
    QString res = getWallpaperForStopped(source);
    if (res=="")
        res = getWallpaperForRunning(source);

    return res;
}

QString  ActivityManager::getWallpaperForRunning(QString source) const
{
    QString fPath =KStandardDirs::locate("config","plasma-desktop-appletsrc");

    //QString(".kde4/share/config/plasma-desktop-appletsrc")
    return getWallpaperFromFile(source,fPath);
}

QString  ActivityManager::getWallpaperForStopped(QString source) const
{


    QString fPath = kStdDrs.localkdedir()+"share/apps/plasma-desktop/activities/"+source;

    //QString actPath(".kde4/share/apps/plasma-desktop/activities/"+source);
    return getWallpaperFromFile(source,fPath);
}

QPixmap ActivityManager::disabledPixmapForIcon(const QString &ic)
{
    KIcon icon3(ic);
    return icon3.pixmap(KIconLoader::SizeHuge, QIcon::Disabled);
}

void ActivityManager::dataUpdated(QString source, Plasma::DataEngine::Data data) {
    //if (!m_activities.contains(source))
    //return;
    QVariant returnedValue;

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

        QString walp = this->getWallpaper(source);
      //  qDebug()<<source<<"-"<<walp;
    }
    else
    {
        emit activityUpdatedIn(QVariant(source),
                               QVariant(data["Name"].toString()),
                               QVariant(data["Icon"].toString()),
                               QVariant(data["State"].toString()),
                               QVariant(data["Current"].toBool()));
    }

}

void ActivityManager::activityAdded(QString id) {

    if (id == "Status")
        return;

    plasmaActEngine->connectSource(id, this);

}

void ActivityManager::activityRemoved(QString id) {

    QMetaObject::invokeMethod(qmlActEngine, "activityRemovedIn",
                              Q_ARG(QVariant, id));

    plasmaActEngine->disconnectSource(id, this);

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

int ActivityManager::askForDelete(QString activityName)
{
    QString question("Do you yeally want to delete activity ");
    question.append(activityName);
    question.append(" ?");
    int responce =  KMessageBox::questionYesNo(0,question,"Delete Activity");
    return responce;
}

void ActivityManager::add(QString id, QString name) {
    Plasma::Service *service = plasmaActEngine->serviceForSource(id);
    KConfigGroup op = service->operationDescription("add");
    op.writeEntry("Name", name);
    Plasma::ServiceJob *job = service->startOperationCall(op);
    connect(job, SIGNAL(finished(KJob*)), service, SLOT(deleteLater()));
}

void ActivityManager::clone(QString id, QString name) {
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
