#include <activitymanager.h>
#include <KActivities/Controller>

ActivityManager::ActivityManager(QObject *parent)
: QObject(parent), m_controller(new KActivities::Controller(this))
{
}

ActivityManager::~ActivityManager()
{
    if (m_controller)
        delete m_controller;
}

#include <activitymanager.moc>
