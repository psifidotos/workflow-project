#include "parametersmanager.h"

#include <KConfigGroup>

ParametersManager::ParametersManager(QObject *parent, KConfigGroup *conf):
    QObject(parent),
    config(conf),
    m_animationsStep(0),
    m_animationsStep2(0)
{
    m_lockActivities = config->readEntry("LockActivities", true);
    m_showWindows = config->readEntry("ShowWindows", true);
    m_zoomFactor = config->readEntry("ZoomFactor", 50);
    m_animations = config->readEntry("Animations", 1);
    updateAnimationsSteps();
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


void ParametersManager::setAnimations(int an)
{
    m_animations = an;
    config->writeEntry("Animations",m_animations);
    emit animationsChanged(m_animations);
    updateAnimationsSteps();
    emit configNeedsSaving();
}

int ParametersManager::animations() const
{
    return m_animations;
}

int ParametersManager::animationsStep() const
{
    return m_animationsStep;
}

int ParametersManager::animationsStep2() const
{
    return m_animationsStep2;
}

void ParametersManager::updateAnimationsSteps()
{
    int animationsStepOld = m_animationsStep;
    int animationsStep2Old = m_animationsStep2;

    if (m_animations>=1)
        m_animationsStep = 200;
    else
        m_animationsStep = 0;

    if (m_animations>=2)
        m_animationsStep2 = 200;
    else
        m_animationsStep2 = 0;

    if(m_animationsStep != animationsStepOld)
        emit animationsStepChanged(m_animationsStep);

    if(m_animationsStep2 != animationsStep2Old)
        emit animationsStep2Changed(m_animationsStep2);
}



#include "parametersmanager.moc"
