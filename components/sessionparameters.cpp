#include <sessionparameters.h>

#include <QDBusInterface>
#include <QDBusConnection>
#include <QDesktopWidget>

#include <KActivities/Controller>
#include <KWindowSystem>


SessionParameters::SessionParameters(QObject *parent)
: QObject(parent),
  m_controller(new KActivities::Controller(this)),
  m_kwindowSystem(KWindowSystem::KWindowSystem::self())
{
    m_currentActivity = m_controller->currentActivity();
    m_currentDesktop = m_kwindowSystem->currentDesktop();
    m_numberOfDesktops = m_kwindowSystem->numberOfDesktops();
    m_effectsSystemEnabled = m_kwindowSystem->compositingActive();

 //   m_screenRatio = 1;

 //   m_desktopWidget = qApp->desktop();

    initConnections();
}

SessionParameters::~SessionParameters()
{
    if (m_controller)
        delete m_controller;
}


//QDBusConnection::sessionBus().connect("org.kde.kwin", "/KWin", "org.kde..KWin" ,"compositingToggled", this, SLOT(MySlot(uint)));
void SessionParameters::initConnections()
{
    connect(m_controller, SIGNAL(currentActivityChanged(QString)), this, SLOT(setCurrentActivitySlot(QString)));
    connect(m_kwindowSystem, SIGNAL(currentDesktopChanged(int)), this, SLOT(setCurrentDesktopSlot(int)));
    connect(m_kwindowSystem, SIGNAL(numberOfDesktopsChanged(int)), this, SLOT(setNumberOfDesktopsSlot(int)));
    QDBusConnection::sessionBus().connect("org.kde.kwin", "/KWin", "org.kde.KWin" ,"compositingToggled", this, SLOT(setEffectsSystemEnabledSlot(bool)));
 //   connect(m_desktopWidget,SIGNAL(resized(int)),this,SLOT(setScreensSizeSlot(int)));
}


void SessionParameters::setCurrentActivitySlot(QString curAct)
{
    m_currentActivity = curAct;
    emit currentActivityChanged(m_currentActivity);
}

QString SessionParameters::currentActivity()
{
    return m_currentActivity;
}

void SessionParameters::setCurrentDesktopSlot(int desktop)
{
    m_currentDesktop = desktop;
    emit currentDesktopChanged(m_currentDesktop);
}

int SessionParameters::currentDesktop()
{
    return m_currentDesktop;
}

void SessionParameters::setNumberOfDesktopsSlot(int number)
{
    m_numberOfDesktops = number;
    emit numberOfDesktopsChanged(m_numberOfDesktops);
}

int SessionParameters::numberOfDesktops()
{
    return m_numberOfDesktops;
}


void SessionParameters::setEffectsSystemEnabledSlot(bool status)
{
    m_effectsSystemEnabled = status;
    emit numberOfDesktopsChanged(m_effectsSystemEnabled);
}

bool SessionParameters::effectsSystemEnabled()
{
    return m_effectsSystemEnabled;
}

/*
void SessionParameters::setScreensSizeSlot(int s)
{
    QRect screenRect = m_desktopWidget->screenGeometry(s);
    float ratio = (float)screenRect.height()/(float)screenRect.width();
    setScreenRatio(ratio);
}

void SessionParameters::setScreenRatio(float ratio)
{
    m_screenRatio = ratio;
    emit screenRatioChanged(m_screenRatio);
}

float SessionParameters::screenRatio()
{
    return m_screenRatio;
}*/


#include <sessionparameters.moc>
