#ifndef PLUGINFINDWALLPAPER_H
#define PLUGINFINDWALLPAPER_H

#include <QObject>

#include <KConfigGroup>
#include <KStandardDirs>

namespace KActivities
{
class Controller;
}
/*
namespace Plasma {
    class Containment;
}*/

//Tries to find the wallpaper for an activity
class PluginFindWallpaper : public QObject{
  Q_OBJECT
  public:
    explicit PluginFindWallpaper(KActivities::Controller *actControl, QObject *parent = 0);
    ~PluginFindWallpaper();

    void initBackgrounds();

    void setPluginActive(bool);

  signals:
    void updateWallpaper(QString id, QString background);

  protected:
    void init();

  private slots:
    void activityAddedSlot(QString);
    void activityStateChangedSlot();
    void currentActivityChangedSlot(QString);
    void currentDesktopChangedSlot(int);

  private:
    KActivities::Controller *m_activitiesCtrl;
    bool m_active;

    QString getWallpaperForRunning(QString source);
    QString getWallpaperForStopped(QString source);
    QString getWallpaperFromFile(QString source,QString file);
  //  QString getWallpaperFromContainment(Plasma::Containment *actContainment);
    QString getWallpaperForSingleImage(KConfigGroup &);
    QString getWallpaper(QString source);

    KStandardDirs kStdDrs;
    QString m_previousActivity;
    int m_previousDesktop;
  //  Plasma::Containment *m_mainContainment;

};

#endif
