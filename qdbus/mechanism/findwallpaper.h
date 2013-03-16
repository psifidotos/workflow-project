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
    void setPerVirtualDesktopViews(bool);
  signals:
    void updateWallpaper(QString id, QStringList backgrounds);

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

    QStringList getWallpapersForRunning(QString source);
    QStringList getWallpapersForStopped(QString source);
    QStringList getWallpapersFromFile(QString source,QString file);
  //  QString getWallpaperFromContainment(Plasma::Containment *actContainment);
    QString getWallpaperForSingleImage(KConfigGroup &);
    QStringList getWallpapers(QString source);

    KStandardDirs kStdDrs;
    QString m_previousActivity;
    int m_previousDesktop;
    bool m_perVirtualDesktopsViews;
  //  Plasma::Containment *m_mainContainment;

};

#endif
