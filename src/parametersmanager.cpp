#include "parametersmanager.h"

#include <KConfigGroup>

ParametersManager::ParametersManager(QObject *parent, KConfigGroup *conf):
    QObject(parent),
    config(conf)
{
    m_lockActivities = config->readEntry("LockActivities", true);
    m_showWindows = config->readEntry("ShowWindows", true);
    m_zoomFactor = config->readEntry("ZoomFactor", 50);
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


void ParametersManager::setShowWindows(bool showWinds)
{
    m_showWindows = showWinds;
    config->writeEntry("ShowWindows",m_showWindows);
    emit showWindowsChanged(m_showWindows);
    emit configNeedsSaving();
}

bool ParametersManager::showWindows() const
{
    return m_showWindows;
}


void ParametersManager::setZoomFactor(int zf)
{
    m_zoomFactor = zf;
    config->writeEntry("ZoomFactor",m_zoomFactor);
    emit zoomFactorChanged(m_zoomFactor);
    emit configNeedsSaving();
}

int ParametersManager::zoomFactor() const
{
    return m_zoomFactor;
}

#include "parametersmanager.moc"
