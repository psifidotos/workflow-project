#ifndef FINDWALLPAPER_H
#define FINDWALLPAPER_H

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
class FindWallpaper : public QObject{
  Q_OBJECT
  public:
    explicit FindWallpaper(KActivities::Controller *actControl, QObject *parent = 0);
    ~FindWallpaper();

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
