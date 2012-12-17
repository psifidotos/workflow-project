#include <sessionparameters.h>

#include <QDBusInterface>
#include <QDBusConnection>

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

    resetTaskInDragging();

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


void SessionParameters::setTaskInDragging(QString task)
{
    m_taskInDragging = task;
    emit taskInDraggingChanged(m_taskInDragging);
}

QString SessionParameters::taskInDragging()
{
    return m_taskInDragging;
}

void SessionParameters::resetTaskInDragging()
{
    m_taskInDragging = "";
}

bool SessionParameters::taskInDraggingIsSet()
{
    return (m_taskInDragging == "");
}



#include <sessionparameters.moc>
