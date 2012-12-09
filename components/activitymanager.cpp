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

QString ActivityManager::addActivity(const QString &name)
{
    return m_controller->addActivity(name);
}

void ActivityManager::removeActivity(const QString &name)
{
    m_controller->removeActivity(name);
}

void ActivityManager::startActivity(const QString &name)
{
    m_controller->startActivity(name);
}

void ActivityManager::stopActivity(const QString &name)
{
    m_controller->stopActivity(name);
}

QString ActivityManager::currentActivity() const
{
    return m_controller->currentActivity();
}

#include <activitymanager.moc>
