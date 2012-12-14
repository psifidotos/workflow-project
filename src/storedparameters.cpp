#include "storedparameters.h"

#include <KConfigGroup>

StoredParameters::StoredParameters(QObject *parent, KConfigGroup *conf):
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

    m_windowsPreviews = config->readEntry("WindowPreviews", false);
    m_windowsPreviewsOffsetX = config->readEntry("WindowPreviewsOffsetX", 0);
    m_windowsPreviewsOffsetY = config->readEntry("WindowPreviewsOffsetY", 0);

    m_fontRelevance = config->readEntry("FontRelevance", 0);
    m_showStoppedActivities = config->readEntry("ShowStoppedPanel", true);
}

StoredParameters::~StoredParameters()
{

}

void StoredParameters::setLockActivities(bool lockActivities)
{
    m_lockActivities = lockActivities;
    config->writeEntry("LockActivities",m_lockActivities);
    emit lockActivitiesChanged(m_lockActivities);
    emit configNeedsSaving();
}

bool StoredParameters::lockActivities() const
{
    return m_lockActivities;
}


void StoredParameters::setShowWindows(bool showWinds)
{
    m_showWindows = showWinds;
    config->writeEntry("ShowWindows",m_showWindows);
    emit showWindowsChanged(m_showWindows);
    emit configNeedsSaving();
}

bool StoredParameters::showWindows() const
{
    return m_showWindows;
}


void StoredParameters::setZoomFactor(int zf)
{
    m_zoomFactor = zf;
    config->writeEntry("ZoomFactor",m_zoomFactor);
    emit zoomFactorChanged(m_zoomFactor);
    emit configNeedsSaving();
}

int StoredParameters::zoomFactor() const
{
    return m_zoomFactor;
}


void StoredParameters::setAnimations(int an)
{
    m_animations = an;
    config->writeEntry("Animations",m_animations);
    emit animationsChanged(m_animations);
    updateAnimationsSteps();
    emit configNeedsSaving();
}

int StoredParameters::animations() const
{
    return m_animations;
}

int StoredParameters::animationsStep() const
{
    return m_animationsStep;
}

int StoredParameters::animationsStep2() const
{
    return m_animationsStep2;
}

void StoredParameters::updateAnimationsSteps()
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


void StoredParameters::setWindowsPreviews(bool winPrev)
{
    m_windowsPreviews = winPrev;
    config->writeEntry("WindowPreviews",m_windowsPreviews);
    emit windowsPreviewsChanged(m_windowsPreviews);
    emit configNeedsSaving();
}

bool StoredParameters::windowsPreviews() const
{
    return m_windowsPreviews;
}

void StoredParameters::setWindowsPreviewsOffsetX(int offX)
{
    m_windowsPreviewsOffsetX = offX;
    config->writeEntry("WindowPreviewsOffsetX",m_windowsPreviewsOffsetX);
    emit windowsPreviewsOffsetXChanged(m_windowsPreviewsOffsetX);
    emit configNeedsSaving();
}

int StoredParameters::windowsPreviewsOffsetX() const
{
    return m_windowsPreviewsOffsetX;
}

void StoredParameters::setWindowsPreviewsOffsetY(int offY)
{
    m_windowsPreviewsOffsetY = offY;
    config->writeEntry("WindowPreviewsOffsetY",m_windowsPreviewsOffsetY);
    emit windowsPreviewsOffsetYChanged(m_windowsPreviewsOffsetY);
    emit configNeedsSaving();
}

int StoredParameters::windowsPreviewsOffsetY() const
{
    return m_windowsPreviewsOffsetY;
}


void StoredParameters::setFontRelevance(int fr)
{
    m_fontRelevance = fr;
    config->writeEntry("FontRelevance",m_fontRelevance);
    emit fontRelevanceChanged(m_fontRelevance);
    emit configNeedsSaving();
}

int StoredParameters::fontRelevance() const
{
    return m_fontRelevance;
}

void StoredParameters::setShowStoppedActivities(bool showStpAct)
{
    m_showStoppedActivities = showStpAct;
    config->writeEntry("ShowStoppedPanel",m_showStoppedActivities);
    emit showStoppedActivitiesChanged(m_showStoppedActivities);
    emit configNeedsSaving();
}

bool StoredParameters::showStoppedActivities() const
{
    return m_showStoppedActivities;
}


#include "storedparameters.moc"
