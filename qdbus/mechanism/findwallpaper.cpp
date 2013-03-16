#include "findwallpaper.h"

#include <QDebug>
#include <QFileInfo>
#include <QDir>

#include <KStandardDirs>
#include <KConfig>

//#include <Plasma/Containment>

#include <KActivities/Controller>
#include <KWindowSystem>

FindWallpaper::FindWallpaper(KActivities::Controller *actControl, QObject *parent):
    QObject(parent),
    m_activitiesCtrl(actControl),
    m_active(true),
    m_perVirtualDesktopsViews(false)
{
    m_previousActivity = m_activitiesCtrl->currentActivity();
    m_previousDesktop = KWindowSystem::self()->currentDesktop();
}

FindWallpaper::~FindWallpaper()
{
}

void FindWallpaper::initBackgrounds()
{
    connect(m_activitiesCtrl, SIGNAL(activityAdded(QString)), this, SLOT(activityAddedSlot(QString)));
    connect(m_activitiesCtrl, SIGNAL(currentActivityChanged(QString)), this, SLOT(currentActivityChangedSlot(QString)));
    connect(KWindowSystem::self(), SIGNAL(currentDesktopChanged(int)), this, SLOT(currentDesktopChangedSlot(int)) );

    //Load backgrounds in the beginning
    QStringList activities = m_activitiesCtrl->listActivities();

    foreach (const QString &id, activities)
        activityAddedSlot(id);
}


void FindWallpaper::setPluginActive(bool active)
{
    m_active = active;
}

void FindWallpaper::setPerVirtualDesktopViews(bool perVirtual)
{
    m_perVirtualDesktopsViews = perVirtual;
}

QString FindWallpaper::getWallpaperForSingleImage(KConfigGroup &conGrp)
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


QStringList FindWallpaper::getWallpapersFromFile(QString source, QString file)
{
    //QString fpath = QDir::home().filePath(file);
    QString fpath = file;

    KConfig config( fpath, KConfig::SimpleConfig );
    KConfigGroup conGps = config.group("Containments");

    int iterat = 0;
    bool found = false;

    QStringList wallpapers;

    while((iterat<conGps.groupList().size() && (!found))){
        QString gps = conGps.groupList().at(iterat);
        KConfigGroup tempG = conGps.group(gps);

        if(tempG.readPathEntry("activityId",QString("null")) == source){
            //     qDebug()<<"Found:"<<gps<<"-"<<tempG.readPathEntry("activityId",QString("null"));
            int desktop = tempG.readEntry("desktop",-1);
            int screen = tempG.readEntry("screen",-1);
            int lastDesktop = tempG.readEntry("lastDesktop", -1);

            if(!m_perVirtualDesktopsViews){

                if( (desktop == -1) && (lastDesktop == -1) &&
                        ((screen == -1)||(screen == 0)) ){
                    found = true;

                    QString res1 = getWallpaperForSingleImage(tempG);

                    if (QFile::exists(res1)){
                        wallpapers << res1;
                        return wallpapers;
                    }
                    else
                        wallpapers << "";
                }
            }
            else{//when each Desktop has different widgets

                if (lastDesktop == -1){//When lastDesktop is the default...
                    QString res1 = getWallpaperForSingleImage(tempG);

                    if (QFile::exists(res1)){
                        wallpapers << res1;
                    }
                    else{
                        wallpapers << "";
                    }
                }
                else{//In case lastDesktop record exists
                    if (lastDesktop>=wallpapers.size()){
                        for (int i=wallpapers.size(); i<lastDesktop+1; i++)
                            wallpapers << "";
                    }

                    QString res1 = getWallpaperForSingleImage(tempG);

                    if (QFile::exists(res1)){
                        wallpapers[lastDesktop] = res1;
                    }
                }
            }
        }
        iterat++;
    }

    return wallpapers;
}
/*
QString FindWallpaper::getWallpaperFromContainment(Plasma::Containment *actContainment)
{
    //QString fpath = QDir::home().filePath(file);
    KConfigGroup mainConf = actContainment->config();
    QString res1 = getWallpaperForSingleImage(mainConf);

    if (QFile::exists(res1))
        return res1;
    else
        return "";
}*/


QStringList  FindWallpaper::getWallpapersForRunning(QString source)
{
    QString fPath =KStandardDirs::locate("config","plasma-desktop-appletsrc");

    //QString(".kde4/share/config/plasma-desktop-appletsrc")
    return getWallpapersFromFile(source,fPath);
}

QStringList  FindWallpaper::getWallpapersForStopped(QString source)
{
    QString fPath = kStdDrs.localkdedir()+"share/apps/plasma-desktop/activities/"+source;

    //QString actPath(".kde4/share/apps/plasma-desktop/activities/"+source);
    return getWallpapersFromFile(source,fPath);
}

/////////////////////////////////////

QStringList FindWallpaper::getWallpapers(QString source)
{
    QStringList res;

    /* Plasma::Containment *currentContainment = m_mainContainment;
    if(currentContainment){
        res = getWallpaperFromContainment(currentContainment);
    //    qDebug()<<"From Containment:"<<res;
        if(res != "")
            return res;
    }*/

    res = getWallpapersForStopped(source);
    //qDebug()<<"From Stopped:"<<res;
    if ( res.isEmpty() )
        res = getWallpapersForRunning(source);

    //qDebug()<<"From Running:"<<res;

    QStringList backgrounds(res);
    return backgrounds;
}
//////////////////////////////////

void FindWallpaper::activityAddedSlot(QString id)
{
    KActivities::Info *activity = new KActivities::Info(id, this);

    connect(activity, SIGNAL(stateChanged(KActivities::Info::State)),
            this, SLOT(activityStateChangedSlot()) );

    if(m_active){
        QStringList wallpapers = getWallpapers(id);
        emit updateWallpaper( id, wallpapers );
    }
}

void FindWallpaper::activityStateChangedSlot()
{
    if(m_active){
        KActivities::Info *activity = qobject_cast<KActivities::Info*>(sender());
        const QString id = activity->id();

        QStringList wallpapers = getWallpapers(id);
        emit updateWallpaper( id, wallpapers );
    }
}

void FindWallpaper::currentActivityChangedSlot(QString id)
{
    if(m_active){
        QStringList wallpapers = getWallpapers(id);
        emit updateWallpaper( id, wallpapers );

        QStringList prevWallpapers = getWallpapers(m_previousActivity);
        emit updateWallpaper( m_previousActivity , prevWallpapers );
        m_previousActivity = id;
    }
}

void FindWallpaper::currentDesktopChangedSlot(int desktop)
{
    if(m_active){
        if(desktop != m_previousDesktop){
            QStringList wallpapers = getWallpapers(m_previousActivity);
            emit updateWallpaper( m_previousActivity, wallpapers );
            m_previousDesktop = desktop;
        }
    }
}
