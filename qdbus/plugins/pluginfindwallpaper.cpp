#include "pluginfindwallpaper.h"

#include <QFileInfo>
#include <QDir>

#include <KStandardDirs>

#include <Plasma/Containment>

#include <KActivities/Controller>

PluginFindWallpaper::PluginFindWallpaper(KActivities::Controller *actControl, QObject *parent):
    QObject(parent),
    m_activitiesCtrl(actControl),
    m_active(true)
{
}

PluginFindWallpaper::~PluginFindWallpaper()
{
}

void PluginFindWallpaper::initBackgrounds()
{
    connect(m_activitiesCtrl, SIGNAL(activityAdded(QString)), this, SLOT(activityAddedSlot(QString)));
    connect(m_activitiesCtrl, SIGNAL(currentActivityChanged(QString)), this, SLOT(currentActivityChangedSlot(QString)));

    //Load backgrounds in the beginning
    QStringList activities = m_activitiesCtrl->listActivities();

    foreach (const QString &id, activities)
        activityAddedSlot(id);
}


void PluginFindWallpaper::setPluginActive(bool active)
{
    m_active = active;
}

QString PluginFindWallpaper::getWallpaperForSingleImage(KConfigGroup &conGrp)
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

        if (QFile(tmD.absolutePath() + "/contents/screenshot.png").exists())
            return tmD.absolutePath() + "/contents/screenshot.png";
        else if (QFile(tmD.absolutePath() + "/contents/screenshot.jpg").exists())
            return tmD.absolutePath() + "/contents/screenshot.jpg";
        else if (QFile(tmD.absolutePath() + "/screenshot.jpg").exists())
            return tmD.absolutePath() + "/screenshot.jpg"; //SUSE default Wallpaper fix
        else if (QFile(tmD.absolutePath() + "/screenshot.png").exists())
            return tmD.absolutePath() + "/screenshot.png";
        else
            return "";
    }
}


QString PluginFindWallpaper::getWallpaperFromFile(QString source, QString file)
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

            int desktop = tempG.readEntry("desktop",-1);
            int screen = tempG.readEntry("screen",-1);

            if( (desktop == -1) &&
                ((screen == -1)||(screen == 0)) ){
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
/*
QString PluginFindWallpaper::getWallpaperFromContainment(Plasma::Containment *actContainment)
{
    //QString fpath = QDir::home().filePath(file);
    KConfigGroup mainConf = actContainment->config();
    QString res1 = getWallpaperForSingleImage(mainConf);

    if (QFile::exists(res1))
        return res1;
    else
        return "";
}*/


QString  PluginFindWallpaper::getWallpaperForRunning(QString source)
{
    QString fPath =KStandardDirs::locate("config","plasma-desktop-appletsrc");

    //QString(".kde4/share/config/plasma-desktop-appletsrc")
    return getWallpaperFromFile(source,fPath);
}

QString  PluginFindWallpaper::getWallpaperForStopped(QString source)
{
    QString fPath = kStdDrs.localkdedir()+"share/apps/plasma-desktop/activities/"+source;

    //QString actPath(".kde4/share/apps/plasma-desktop/activities/"+source);
    return getWallpaperFromFile(source,fPath);
}

/////////////////////////////////////

QString PluginFindWallpaper::getWallpaper(QString source)
{
    QString res = "";

    /* Plasma::Containment *currentContainment = m_mainContainment;
    if(currentContainment){
        res = getWallpaperFromContainment(currentContainment);
    //    qDebug()<<"From Containment:"<<res;
        if(res != "")
            return res;
    }*/

    res = getWallpaperForStopped(source);
    //qDebug()<<"From Stopped:"<<res;
    if (res=="")
        res = getWallpaperForRunning(source);

    //qDebug()<<"From Running:"<<res;
    return res;
}
//////////////////////////////////

void PluginFindWallpaper::activityAddedSlot(QString id)
{
    KActivities::Info *activity = new KActivities::Info(id, this);

    connect(activity, SIGNAL(stateChanged(KActivities::Info::State)),
            this, SLOT(activityStateChangedSlot()) );

    if(m_active){
        QString wallpaper = getWallpaper(id);
        emit updateWallpaper( id, wallpaper );
    }
}

void PluginFindWallpaper::activityStateChangedSlot()
{
    if(m_active){
        KActivities::Info *activity = qobject_cast<KActivities::Info*>(sender());
        const QString id = activity->id();

        QString wallpaper = getWallpaper(id);
        emit updateWallpaper( id, wallpaper );
    }
}

void PluginFindWallpaper::currentActivityChangedSlot(QString id)
{
    if(m_active){
        QString wallpaper = getWallpaper(id);
        emit updateWallpaper( id, wallpaper );
    }
}

