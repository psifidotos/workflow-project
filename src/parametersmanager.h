#ifndef PARAMETERSMANAGER_H
#define PARAMETERSMANAGER_H

#include <KConfigGroup>

class ParametersManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool lockActivities READ lockActivities WRITE setLockActivities NOTIFY lockActivitiesChanged)
    Q_PROPERTY(bool showWindows READ showWindows WRITE setShowWindows NOTIFY showWindowsChanged)
    Q_PROPERTY(int zoomFactor READ zoomFactor WRITE setZoomFactor NOTIFY zoomFactorChanged)

public:
   explicit ParametersManager(QObject *parent = 0, KConfigGroup *conf = 0);
    ~ParametersManager();

    void setLockActivities(bool);
    bool lockActivities() const;

    void setShowWindows(bool);
    bool showWindows() const;

    void setZoomFactor(int);
    int zoomFactor() const;


signals:
    void configNeedsSaving();

    void lockActivitiesChanged(bool);
    void showWindowsChanged(bool);
    void zoomFactorChanged(int);

private:
   KConfigGroup *config;

   bool m_lockActivities;
   bool m_showWindows;
   int m_zoomFactor;

};


#endif
