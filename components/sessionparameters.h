#ifndef SESSIONPARAMETERS_H
#define SESSIONPARAMETERS_H

#include <QObject>
#include <QDesktopWidget>

#include <KActivities/Controller>


class KWindowSystem;

/* A simple wrapper around Environment's parameters */
class SessionParameters : public QObject
{
    Q_OBJECT
public:

    Q_PROPERTY(QString currentActivity READ currentActivity NOTIFY currentActivityChanged)
    Q_PROPERTY(int currentDesktop READ currentDesktop NOTIFY currentDesktopChanged)
    Q_PROPERTY(int numberOfDesktops READ numberOfDesktops NOTIFY numberOfDesktopsChanged)
    Q_PROPERTY(bool effectsSystemEnabled READ effectsSystemEnabled NOTIFY effectsSystemChanged)
  //  Q_PROPERTY(float screenRatio READ screenRatio NOTIFY screenRatioChanged)

    explicit SessionParameters(QObject *parent = 0);
    ~SessionParameters();

    QString currentActivity();
    int currentDesktop();
    int numberOfDesktops();
    bool effectsSystemEnabled();
 //  float screenRatio();

signals:
    void currentActivityChanged(QString);
    void currentDesktopChanged(int);
    void numberOfDesktopsChanged(int);
    void effectsSystemChanged(int);
 //   void screenRatioChanged(float);

public slots:
    void setCurrentActivitySlot(QString);
    void setCurrentDesktopSlot(int);
    void setNumberOfDesktopsSlot(int);
    void setEffectsSystemEnabledSlot(bool);

 //   void setScreensSizeSlot(int);

private:
    KActivities::Controller *m_controller;
    KWindowSystem *m_kwindowSystem;
 //   QDesktopWidget *m_desktopWidget;

    QString m_currentActivity;
    int m_currentDesktop;
    int m_numberOfDesktops;
    bool m_effectsSystemEnabled;
 //   float m_screenRatio;

    void initConnections();

    void setScreenRatio(float);
};

#endif /* SESSIONPARAMETERS_H */
