#include <sessionparameters.h>
#include <KActivities/Controller>

SessionParameters::SessionParameters(QObject *parent)
: QObject(parent), m_controller(new KActivities::Controller(this))
{
    m_currentActivity = m_controller->currentActivity();

    initConnections();
}

SessionParameters::~SessionParameters()
{
    if (m_controller)
        delete m_controller;
}

void SessionParameters::initConnections()
{
    connect(m_controller, SIGNAL(currentActivityChanged(QString)), this, SLOT(setCurrentActivity(QString)));
}


void SessionParameters::setCurrentActivity(QString curAct)
{
    m_currentActivity = curAct;
    emit currentActivityChanged(m_currentActivity);
}

QString SessionParameters::currentActivity()
{
    return m_currentActivity;
}

#include <sessionparameters.moc>
