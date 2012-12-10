#include "parametersmanager.h"

#include <KConfigGroup>

ParametersManager::ParametersManager(QObject *parent, KConfigGroup *conf):
    QObject(parent),
    config(conf)
{
    m_lockActivities = config->readEntry("LockActivities", true);
}

ParametersManager::~ParametersManager()
{

}

void ParametersManager::setLockActivities(bool lockActivities)
{
    m_lockActivities = lockActivities;
    config->writeEntry("LockActivities",m_lockActivities);
    emit lockActivitiesChanged(m_lockActivities);
    emit configNeedsSaving();
}

bool ParametersManager::lockActivities() const
{
    return m_lockActivities;
}


#include "parametersmanager.moc"
