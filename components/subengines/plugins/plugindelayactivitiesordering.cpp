#include "plugindelayactivitiesordering.h"

#include <QDebug>
#include <QTimer>


PluginDelayActivitiesOrdering::PluginDelayActivitiesOrdering(QObject *parent) :
    QObject(parent)
{
    m_timer = new QTimer(this);
    m_timer->setSingleShot(true);

    init();
}

PluginDelayActivitiesOrdering::~PluginDelayActivitiesOrdering()
{
}

void PluginDelayActivitiesOrdering::init()
{
    connect(m_timer, SIGNAL(timeout()), this, SIGNAL(orderActivitiesTriggered()));
}


void PluginDelayActivitiesOrdering::execute()
{
    m_timer->start(500);
}


#include "plugindelayactivitiesordering.moc"
