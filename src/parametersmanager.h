#ifndef PARAMETERSMANAGER_H
#define PARAMETERSMANAGER_H

#include <KConfigGroup>

class ParametersManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool lockActivities READ lockActivities WRITE setLockActivities NOTIFY lockActivitiesChanged)
    Q_PROPERTY(bool showWindows READ showWindows WRITE setShowWindows NOTIFY showWindowsChanged)
    Q_PROPERTY(int zoomFactor READ zoomFactor WRITE setZoomFactor NOTIFY zoomFactorChanged)
    Q_PROPERTY(int animations READ animations WRITE setAnimations NOTIFY animationsChanged)
    Q_PROPERTY(int animationsStep READ animationsStep NOTIFY animationsStepChanged)
    Q_PROPERTY(int animationsStep2 READ animationsStep2 NOTIFY animationsStep2Changed)

public:
    /*
    enum AnimationsLevel {
       NONE,
       BASIC,
       FULL
    };*/

   explicit ParametersManager(QObject *parent = 0, KConfigGroup *conf = 0);
    ~ParametersManager();

    void setLockActivities(bool);
    bool lockActivities() const;

    void setShowWindows(bool);
    bool showWindows() const;

    void setZoomFactor(int);
    int zoomFactor() const;

    void setAnimations(int);
    int animations() const;

    int animationsStep() const;
    int animationsStep2() const;

signals:
    void configNeedsSaving();

    void lockActivitiesChanged(bool);
    void showWindowsChanged(bool);
    void zoomFactorChanged(int);
    void animationsChanged(int);
    void animationsStepChanged(int);
    void animationsStep2Changed(int);

private:
   KConfigGroup *config;

   bool m_lockActivities;
   bool m_showWindows;
   int m_zoomFactor;
   int m_animations;
   int m_animationsStep; //Basic animations duration
   int m_animationsStep2; //Full animations duration

   void updateAnimationsSteps();
};


#endif
