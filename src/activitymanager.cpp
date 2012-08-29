#include "activitymanager.h"

#include <QDir>
#include <QDebug>
#include <QFile>
#include <QTextStream>
#include <QIODevice>
#include <QAction>
#include <QGraphicsView>


#include <KIconDialog>
#include <KIcon>
#include <KWindowSystem>
#include <KConfigGroup>
#include <KConfig>
#include <KMessageBox>
#include <KStandardDirs>


#include <KActivities/Controller>
#include <KActivities/Info>

#include <Plasma/Containment>
#include <Plasma/Corona>


ActivityManager::ActivityManager(QObject *parent) :
    QObject(parent)
{
    m_activitiesCtrl = new KActivities::Controller(this);
    m_timer = new QTimer(this);
    m_timerPhase = 0;
    m_unlockWidgetsText = "";

}

ActivityManager::~ActivityManager()
{

    delete m_activitiesCtrl;
}

void ActivityManager::setQMlObject(QObject *obj,Plasma::Corona *cor)
{
    qmlActEngine = obj;
    m_corona = cor;

    connect(this, SIGNAL(activityAddedIn(QVariant,QVariant,QVariant,QVariant,QVariant)),
            qmlActEngine,SLOT(activityAddedIn(QVariant,QVariant,QVariant,QVariant,QVariant)));

    connect(this, SIGNAL(activityUpdatedIn(QVariant,QVariant,QVariant,QVariant,QVariant)),
            qmlActEngine,SLOT(activityUpdatedIn(QVariant,QVariant,QVariant,QVariant,QVariant)));


    QStringList activities = m_activitiesCtrl->listActivities();

    foreach (const QString &id, activities) {
        activityAdded(id);
    }

    connect(m_activitiesCtrl, SIGNAL(activityAdded(QString)), this, SLOT(activityAdded(QString)));
    connect(m_activitiesCtrl, SIGNAL(activityRemoved(QString)), this, SLOT(activityRemoved(QString)));
    connect(m_activitiesCtrl, SIGNAL(currentActivityChanged(QString)), this, SLOT(currentActivityChanged(QString)));

    connect(m_timer, SIGNAL(timeout()), this, SLOT(timerTrigerred()));
}



QString ActivityManager::getWallpaperForSingleImage(KConfigGroup &conGrp)
{
    KConfigGroup gWall = conGrp.group("Wallpaper").group("image");

    QString foundF = gWall.readEntry("wallpaper", QString("null"));

    if (QFileInfo(foundF).isFile())
        return foundF;
    else{
        QDir tmD = QDir(foundF);
        if (tmD.isRelative()){
            QString foundF2 = gWall.readEntry("slidepaths",QString(""));
            tmD = QDir(foundF2 + tmD.dirName());
        }
        foundF = tmD.absolutePath() + "/contents/screenshot.png";

        if (QFile(foundF).exists())
            return foundF;
        else{
            QString foundF2 = tmD.absolutePath() + "/contents/screenshot.jpg";

            if (QFile(foundF2).exists())
                return foundF2;
            else
                return "";
        }
    }
}


QString ActivityManager::getWallpaperFromFile(QString source, QString file)
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
            if(tempG.readEntry("lastScreen",-1)==0){
                found = true;

                QString res1 = getWallpaperForSingleImage(tempG);

                if (QFile::exists(res1))
                    return res1;
            }

        }


        iterat++;
    }
    return "";

}

QString ActivityManager::getWallpaperFromContainment(Plasma::Containment *actContainment)
{
    //QString fpath = QDir::home().filePath(file);
    KConfigGroup mainConf = actContainment->config();
    QString res1 = getWallpaperForSingleImage(mainConf);

    if (QFile::exists(res1))
        return res1;
    else
        return "";
}


QString ActivityManager::getWallpaper(QString source)
{
    QString res = "";

    Plasma::Containment *currentContainment = getContainment(source);
    if(currentContainment){
        res = getWallpaperFromContainment(currentContainment);
    //    qDebug()<<"From Containment:"<<res;
        if(res != "")
            return res;
    }

    res = getWallpaperForStopped(source);
    //qDebug()<<"From Stopped:"<<res;
    if (res=="")
        res = getWallpaperForRunning(source);

    //qDebug()<<"From Running:"<<res;
    return res;
}

QString  ActivityManager::getWallpaperForRunning(QString source)
{
    QString fPath =KStandardDirs::locate("config","plasma-desktop-appletsrc");

    //QString(".kde4/share/config/plasma-desktop-appletsrc")
    return getWallpaperFromFile(source,fPath);
}

QString  ActivityManager::getWallpaperForStopped(QString source)
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

void ActivityManager::timerTrigerred(){
    QString cacheFile;

    if(m_timerPhase == 2)
        cacheFile = fromCloneActivityId;
    else if (m_timerPhase == 4)
        cacheFile = toCloneActivityId;

    if((m_timerPhase==2)||(m_timerPhase==4)){
        QString fPath = kStdDrs.localkdedir()+"share/apps/plasma-desktop/activities/"+cacheFile;

        QString line;

        QFile file(fPath);
        QTextStream stream ( &file );

        if (!file.open(QIODevice::ReadWrite)){
            qDebug() << "Error file found for "<<cacheFile;
            //return -1;
        }

        line = stream.readLine();

        if(!line.isNull()){
            m_timer->stop();

            file.close();

            if(m_timerPhase == 2)
                loadCloneActivitySettings();
            else if (m_timerPhase == 4)
                storeCloneActivitySettings();

            m_timerPhase = 0;
            m_timer->stop();
        }
        else{
            file.close();
        }

    }
    else
        m_timer->stop();

}

void ActivityManager::initCloningPhase02(QString id)
{
    fromCloneActivityId = id;
    m_timerPhase = 2;
    m_timer->start(200);
}

void ActivityManager::initCloningPhase04(QString id)
{
    toCloneActivityId = id;
    m_timerPhase = 4;
    m_timer->start(200);
}

QString ActivityManager::getContainmentId(QString txt) const
{
    QString findText1 = "[Containments][";
    QString findText2 = "]";

    int p1 = txt.indexOf(findText1)+findText1.length();
    int p2 = txt.indexOf(findText2,p1);

    QString res(txt.mid(p1,p2-p1));
    return res;
}


int ActivityManager::loadCloneActivitySettings(){
    QString fPath = kStdDrs.localkdedir()+"share/apps/plasma-desktop/activities/"+fromCloneActivityId;

    QString line;

    QFile file(fPath);
    QTextStream stream ( &file );

    fromCloneActivityText.clear();
    //This is done until the stopped activities properties to be written
    //This function must be called only for Stopped Activities

    //   while (line.isNull()){
    if (!file.open(QIODevice::ReadWrite)){
        qDebug() << "Error file found...";
        return -1;
    }

    line = stream.readLine();

    //    if(line.isNull())
    //         file.close();
    //  }
    //This is done until the stopped activities properties to be written

    while (!line.isNull()) {
        fromCloneActivityText.append(line+'\n');
        line = stream.readLine();
        //  qDebug() << "----- " <<line;
    }

    file.close();

    //  qDebug() << fromCloneActivityText;

    //fromCloneActivityId = id;
    fromCloneContainmentId = getContainmentId(fromCloneActivityText);

    QMetaObject::invokeMethod(qmlActEngine, "initPhase02Completed");

    return 0;
}



int ActivityManager::storeCloneActivitySettings(){
    QString fPath = kStdDrs.localkdedir()+"share/apps/plasma-desktop/activities/"+toCloneActivityId;

    QString line;

    QFile file(fPath);
    QTextStream stream ( &file );

    QString fContent;
    fContent.clear();
    //This is done until the stopped activities properties to be written
    //This function must be called only for Stopped Activities
    //    while (line.isNull()){

    if (!file.open(QIODevice::ReadWrite)){
        qDebug() << "Error file found...";
        return -1;
    }

    line = stream.readLine();

    //        if(line.isNull())
    //           file.close();
    //   }
    //This is done until the stopped activities properties to be written

    while (!line.isNull()) {
        fContent.append(line+'\n');
        line = stream.readLine();
    }

    file.close();

    //qDebug() << fContent;

    toCloneContainmentId = getContainmentId(fContent);

    //qDebug() << "-----------To:"<<toCloneActivityId;

    QString fromStr(QString("[Containments][")+fromCloneContainmentId+"]");
    QString toStr(QString("[Containments][")+toCloneContainmentId+"]");

    QString writeToFileRes = fromCloneActivityText.replace(fromStr,toStr);

    QString fromStr2("activityId="+fromCloneActivityId);
    QString toStr2("activityId="+toCloneActivityId);

    writeToFileRes = writeToFileRes.replace(fromStr2,toStr2);

    //qDebug() << writeToFileRes;

    if (!file.open(QIODevice::WriteOnly)){
        qDebug() << "Error file found...";
        return -1;
    }

    /* Check it opened OK */
    if(!file.isOpen()){
        qDebug() << "- Error, unable to open" << fPath << "for output";
        return -1;
    }

    stream << writeToFileRes;

    file.close();

    QMetaObject::invokeMethod(qmlActEngine, "initPhase04Completed");

    return 0;
}



void ActivityManager::activityAdded(QString id) {

    KActivities::Info *activity = new KActivities::Info(id, this);


    QString state;
    switch (activity->state()) {
    case KActivities::Info::Running:
        state = "Running";
        break;
    case KActivities::Info::Starting:
        state = "Starting";
        break;
    case KActivities::Info::Stopping:
        state = "Stopping";
        break;
    case KActivities::Info::Stopped:
        state = "Stopped";
        break;
    case KActivities::Info::Invalid:
    default:
        state = "Invalid";
    }

    emit activityAddedIn(QVariant(id),
                         QVariant(activity->name()),
                         QVariant(activity->icon()),
                         QVariant(state),
                         QVariant(m_activitiesCtrl->currentActivity() == id));

    connect(activity, SIGNAL(infoChanged()), this, SLOT(activityDataChanged()));
    connect(activity, SIGNAL(stateChanged(KActivities::Info::State)), this, SLOT(activityStateChanged()));

}

void ActivityManager::activityRemoved(QString id) {

    QMetaObject::invokeMethod(qmlActEngine, "activityRemovedIn",
                              Q_ARG(QVariant, id));

}

void ActivityManager::activityDataChanged()
{
    KActivities::Info *activity = qobject_cast<KActivities::Info*>(sender());
    if (!activity) {
        return;
    }

    QString state;
    switch (activity->state()) {
    case KActivities::Info::Running:
        state = "Running";
        break;
    case KActivities::Info::Starting:
        state = "Starting";
        break;
    case KActivities::Info::Stopping:
        state = "Stopping";
        break;
    case KActivities::Info::Stopped:
        state = "Stopped";
        break;
    case KActivities::Info::Invalid:
    default:
        state = "Invalid";
    }



    emit activityUpdatedIn(QVariant(activity->id()),
                           QVariant(activity->name()),
                           QVariant(activity->icon()),
                           QVariant(state),
                           QVariant(m_activitiesCtrl->currentActivity() == activity->id()));
}

void ActivityManager::activityStateChanged()
{
    KActivities::Info *activity = qobject_cast<KActivities::Info*>(sender());
    const QString id = activity->id();
    if (!activity) {
        return;
    }
    QString state;
    switch (activity->state()) {
    case KActivities::Info::Running:
        state = "Running";
        break;
    case KActivities::Info::Starting:
        state = "Starting";
        break;
    case KActivities::Info::Stopping:
        state = "Stopping";
        break;
    case KActivities::Info::Stopped:
        state = "Stopped";
        break;
    case KActivities::Info::Invalid:
    default:
        state = "Invalid";
    }

    //qDebug() <<activity->id()<< "-" << state;

    QMetaObject::invokeMethod(qmlActEngine, "setCState",
                              Q_ARG(QVariant, id),
                              Q_ARG(QVariant, state));

    if((activity->id()==activityForDelete)&&
            (state=="Stopped")){
        m_activitiesCtrl->removeActivity(activity->id());
        activityForDelete = "";
    }
}

void ActivityManager::currentActivityChanged(const QString &id)
{
    QMetaObject::invokeMethod(qmlActEngine, "setCurrentSignal",
                              Q_ARG(QVariant, id));
}



/////////SLOTS

void ActivityManager::setIcon(QString id, QString name)
{
    m_activitiesCtrl->setActivityIcon(id,name);
}

QString ActivityManager::chooseIcon(QString id)
{
    KIconDialog *dialog = new KIconDialog();
    dialog->setModal(true);
    dialog->setup(KIconLoader::Desktop);
    dialog->setProperty("DoNotCloseController", true);
    KWindowSystem::setOnDesktop(dialog->winId(), KWindowSystem::currentDesktop());
    dialog->showDialog();
    KWindowSystem::forceActiveWindow(dialog->winId());

    emit showedIconDialog();

    QString icon = dialog->openDialog();
    dialog->deleteLater();

    if (icon != "")
        setIcon(id,icon);

    emit answeredIconDialog();

    return icon;
}



QString ActivityManager::add(QString name) {
    return m_activitiesCtrl->addActivity(name);
}

/*
void ActivityManager::clone(QString id, QString name) {

}*/

void ActivityManager::setCurrent(QString id) {
    m_activitiesCtrl->setCurrentActivity(id);
}

void ActivityManager::stop(QString id) {
    m_activitiesCtrl->stopActivity(id);
}

void ActivityManager::start(QString id) {

    m_activitiesCtrl->startActivity(id);
}

void ActivityManager::setName(QString id, QString name) {
    m_activitiesCtrl->setActivityName(id,name);
}

void ActivityManager::remove(QString id) {
    m_activitiesCtrl->stopActivity(id);
    activityForDelete = id;
}

/*

 int ActivityManager::askForDelete(QString activityName)
{
    QString question("Do you yeally want to delete activity ");
    question.append(activityName);
    question.append(" ?");
    int responce =  KMessageBox::questionYesNo(0,question,"Delete Activity");
    return responce;
}


*/

//All The Widgets Explorer Hacking///

void ActivityManager::unlockWidgets()
{
    //if(containment())
        if(m_corona)
            if(m_corona->actions().at(0)){
                QAction *unlockAction = m_corona->actions().at(0);

                //Just checking the text size usually the word unlock is a bigger text
                if(m_unlockWidgetsText == ""){

                    QString str1(unlockAction->text());
                    unlockAction->trigger();
                    QString str2(unlockAction->text());

                    if(str1.size() > str2.size())
                        m_unlockWidgetsText = str1;
                    else
                        m_unlockWidgetsText = str2;
                }

                if(m_unlockWidgetsText == unlockAction->text())
                    unlockAction->trigger();
                //else the widgets are already unlocked
            }

}

Plasma::Containment *ActivityManager::getContainment(QString actId)
{
    //if(containment())
        if(m_corona){
            for(int j=0; j<m_corona->containments().size(); j++){
                Plasma::Containment *tC = m_corona->containments().at(j);

        //        qDebug()<<"Step1...";
                if (tC->containmentType() == Plasma::Containment::DesktopContainment){
         //           qDebug()<<"Step2...";
           //         qDebug()<<"Activity:"<<tC->activity()<<" - "<<tC->config().readEntry("activityId","");

                    if((tC->config().readEntry("activityId","") == actId)&&
                            (tC->config().readEntry("plugin","") != "desktopDashboard")){
//                        qDebug()<<"Step3..." << actId;

                   //     if (tC->view())
                            return tC;
                    }


                }

            }
        }

    return 0;
}




void ActivityManager::showWidgetsExplorer(QString actId)
{
    Plasma::Containment *currentContainment = getContainment(actId);
    if(currentContainment->view()){
    //    qDebug()<<"Step4...";
        currentContainment->view()->metaObject()->invokeMethod(currentContainment->view(),
                                                               "showWidgetExplorer");
/*
        if(m_isOnDashboard)
            taskManager->hideDashboard();
        else
            hidePopupDialog();*/

    }

}

#include "activitymanager.moc"
