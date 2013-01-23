#include "pluginfindwallpaper.h"

#include <QFileInfo>
#include <QDir>

#include <KStandardDirs>

#include <Plasma/Containment>

PluginFindWallpaper::PluginFindWallpaper(QObject *parent):
    QObject(parent)
{
}

PluginFindWallpaper::~PluginFindWallpaper()
{
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


