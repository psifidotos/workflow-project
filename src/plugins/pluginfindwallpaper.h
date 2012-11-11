#ifndef PLUGINFINDWALLPAPER_H
#define PLUGINFINDWALLPAPER_H

#include <QObject>

#include <KConfigGroup>
#include <KStandardDirs>

namespace Plasma {
    class Containment;
}

class PluginFindWallpaper{
  public:
    PluginFindWallpaper(Plasma::Containment *);
    ~PluginFindWallpaper();

    QString getWallpaper(QString source);

  private:
    QString getWallpaperForRunning(QString source);
    QString getWallpaperForStopped(QString source);
    QString getWallpaperFromFile(QString source,QString file);
    QString getWallpaperFromContainment(Plasma::Containment *actContainment);
    QString getWallpaperForSingleImage(KConfigGroup &);

    KStandardDirs kStdDrs;
    Plasma::Containment *m_mainContainment;
};

#endif
