#include <sessionparameters.h>

#include <QDBusInterface>
#include <QDBusConnection>
#include <QDesktopWidget>
#include <QApplication>

#include <KActivities/Controller>
#include <KWindowSystem>
#include <KDebug>


SessionParameters::SessionParameters(QObject *parent)
    : QObject(parent),
      m_controller(new KActivities::Controller(this)),
      m_kwindowSystem(KWindowSystem::KWindowSystem::self()),
      m_dbus(0),
      m_currentActivityName(""),
      m_currentActivityIcon(""),
      m_screenRatio(1),
      m_isInPanel(0)
{
    m_currentActivity = m_controller->currentActivity();
    loadActivityIconAndName(m_currentActivity);
    m_currentDesktop = m_kwindowSystem->currentDesktop();
    m_numberOfDesktops = m_kwindowSystem->numberOfDesktops();
    m_effectsSystemEnabled = m_kwindowSystem->compositingActive();

    m_dbus = new QDBusInterface("org.kde.kwin", "/KWin", "org.kde.KWin");

    m_desktopWidget = QApplication::desktop();

    //init screen ratio
    setScreensSizeSlot(-1);

    initConnections();
}

SessionParameters::~SessionParameters()
{
    if (m_controller)
        delete m_controller;

    if (m_dbus)
        delete m_dbus;
}


//QDBusConnection::sessionBus().connect("org.kde.kwin", "/KWin", "org.kde..KWin" ,"compositingToggled", this, SLOT(MySlot(uint)));
void SessionParameters::initConnections()
{
    connect(m_controller, SIGNAL(currentActivityChanged(QString)), this, SLOT(setCurrentActivitySlot(QString)));
    connect(m_kwindowSystem, SIGNAL(currentDesktopChanged(int)), this, SLOT(setCurrentDesktopSlot(int)));
    connect(m_kwindowSystem, SIGNAL(numberOfDesktopsChanged(int)), this, SLOT(setNumberOfDesktopsSlot(int)));

    if(m_dbus->isValid()){
        m_dbus->setParent(this);
        connect(m_dbus,SIGNAL(compositingToggled(bool)), this, SLOT(setEffectsSystemEnabledSlot(bool)));
    }
    else{
        delete m_dbus;
        m_dbus=0;
    }

    connect(m_desktopWidget,SIGNAL(resized(int)),this,SLOT(setScreensSizeSlot(int)));
}


void SessionParameters::setCurrentActivitySlot(QString curAct)
{
    if(m_currentActivity != curAct){
        m_currentActivity = curAct;
        emit currentActivityChanged(m_currentActivity);
    }

    loadActivityIconAndName(curAct);
}

QString SessionParameters::currentActivity()
{
    return m_currentActivity;
}

void SessionParameters::setCurrentActivityName(QString name)
{
    if(m_currentActivityName != name){
        m_currentActivityName = name;
        emit currentActivityNameChanged(m_currentActivityName);
    }
}

void SessionParameters::setCurrentActivityIcon(QString icon)
{
    //fixes bug of not showing icon in activities that do not have one
    //and use the default one
    if (icon == "")
        icon = "plasma";

    if(m_currentActivityIcon != icon){
        m_currentActivityIcon = icon;
        emit currentActivityIconChanged(m_currentActivityIcon);
    }
}


void SessionParameters::loadActivityIconAndName(QString actId)
{
    KActivities::Info *activity = new KActivities::Info(actId, this);
    setCurrentActivityName(activity->name());
    setCurrentActivityIcon(activity->icon());
    delete activity;
}

void SessionParameters::setCurrentDesktopSlot(int desktop)
{
    if(m_currentDesktop != desktop){
        m_currentDesktop = desktop;
        emit currentDesktopChanged(m_currentDesktop);
    }
}

int SessionParameters::currentDesktop()
{
    return m_currentDesktop;
}

void SessionParameters::setNumberOfDesktopsSlot(int number)
{
    if(m_numberOfDesktops != number){
        m_numberOfDesktops = number;
        emit numberOfDesktopsChanged(m_numberOfDesktops);
    }
}

int SessionParameters::numberOfDesktops()
{
    return m_numberOfDesktops;
}


void SessionParameters::setEffectsSystemEnabledSlot(bool status)
{
    if(m_effectsSystemEnabled != status){
        m_effectsSystemEnabled = status;
        emit effectsSystemChanged(m_effectsSystemEnabled);
    }
}

bool SessionParameters::effectsSystemEnabled()
{
    return m_effectsSystemEnabled;
}


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
}


void SessionParameters::setIsInPanel(bool inpanel)
{
    if(m_isInPanel!=inpanel){
        m_isInPanel = inpanel;
        emit isInPanelChanged(m_isInPanel);
    }
}

bool SessionParameters::isInPanel()
{
    return m_isInPanel;
}

void SessionParameters::triggerKWinScript()
{
    QDBusInterface* kwin_dbus = new QDBusInterface("org.kde.kglobalaccel", "/component/kwin");
    if(kwin_dbus){
        kwin_dbus->call( "invokeShortcut", "WorkFlow: KWin Script" );
    }
}

#include <sessionparameters.moc>

