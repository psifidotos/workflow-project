#include "storedparameters.h"

#include <KConfigGroup>

StoredParameters::StoredParameters(QObject *parent, KConfigGroup *conf):
    QObject(parent),
    config(conf),
    m_animationsStep(0),
    m_animationsStep2(0)
{
    configChanged();
}

StoredParameters::~StoredParameters()
{

}

void StoredParameters::configChanged()
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
    m_firstRunLiveTour = config->readEntry("FirstRunTour", false);
    m_firstRunCalibrationPreviews = config->readEntry("FirstRunCalibration", false);
    m_hideOnClick = config->readEntry("HideOnClick",false);
    m_toolTipsDelay = config->readEntry("ToolTipsDelay", 300);

    m_currentTheme = config->readEntry("CurrentTheme", "Oxygen");
}

void StoredParameters::setLockActivities(bool lockActivities)
{
    if(m_lockActivities != lockActivities){
        m_lockActivities = lockActivities;
        config->writeEntry("LockActivities",m_lockActivities);
        emit lockActivitiesChanged(m_lockActivities);
        emit configNeedsSaving();
    }
}

bool StoredParameters::lockActivities() const
{
    return m_lockActivities;
}


void StoredParameters::setShowWindows(bool showWinds)
{
    if(m_showWindows != showWinds){
        m_showWindows = showWinds;
        config->writeEntry("ShowWindows",m_showWindows);
        emit showWindowsChanged(m_showWindows);
        emit configNeedsSaving();
    }
}

bool StoredParameters::showWindows() const
{
    return m_showWindows;
}


void StoredParameters::setZoomFactor(int zf)
{
    if(m_zoomFactor != zf){
        m_zoomFactor = zf;
        config->writeEntry("ZoomFactor",m_zoomFactor);
        emit zoomFactorChanged(m_zoomFactor);
        emit configNeedsSaving();
    }
}

int StoredParameters::zoomFactor() const
{
    return m_zoomFactor;
}


void StoredParameters::setAnimations(int an)
{
    if(m_animations != an){
        m_animations = an;
        config->writeEntry("Animations",m_animations);
        emit animationsChanged(m_animations);
        updateAnimationsSteps();
        emit configNeedsSaving();
    }
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
    if(m_windowsPreviews != winPrev){
        m_windowsPreviews = winPrev;
        config->writeEntry("WindowPreviews",m_windowsPreviews);
        emit windowsPreviewsChanged(m_windowsPreviews);
        emit configNeedsSaving();
    }
}

bool StoredParameters::windowsPreviews() const
{
    return m_windowsPreviews;
}

void StoredParameters::setWindowsPreviewsOffsetX(int offX)
{
    if(m_windowsPreviewsOffsetX != offX){
        m_windowsPreviewsOffsetX = offX;
        config->writeEntry("WindowPreviewsOffsetX",m_windowsPreviewsOffsetX);
        emit windowsPreviewsOffsetXChanged(m_windowsPreviewsOffsetX);
        emit configNeedsSaving();
    }
}

int StoredParameters::windowsPreviewsOffsetX() const
{
    return m_windowsPreviewsOffsetX;
}

void StoredParameters::setWindowsPreviewsOffsetY(int offY)
{
    if(m_windowsPreviewsOffsetY != offY){
        m_windowsPreviewsOffsetY = offY;
        config->writeEntry("WindowPreviewsOffsetY",m_windowsPreviewsOffsetY);
        emit windowsPreviewsOffsetYChanged(m_windowsPreviewsOffsetY);
        emit configNeedsSaving();
    }
}

int StoredParameters::windowsPreviewsOffsetY() const
{
    return m_windowsPreviewsOffsetY;
}


void StoredParameters::setFontRelevance(int fr)
{
    if(m_fontRelevance != fr){
        m_fontRelevance = fr;
        config->writeEntry("FontRelevance",m_fontRelevance);
        emit fontRelevanceChanged(m_fontRelevance);
        emit configNeedsSaving();
    }
}

int StoredParameters::fontRelevance() const
{
    return m_fontRelevance;
}

void StoredParameters::setShowStoppedActivities(bool showStpAct)
{
    if(m_showStoppedActivities != showStpAct){
        m_showStoppedActivities = showStpAct;
        config->writeEntry("ShowStoppedPanel",m_showStoppedActivities);
        emit showStoppedActivitiesChanged(m_showStoppedActivities);
        emit configNeedsSaving();
    }
}

bool StoredParameters::showStoppedActivities() const
{
    return m_showStoppedActivities;
}


void StoredParameters::setFirstRunLiveTour(bool firRunTour)
{
    if(m_firstRunLiveTour != firRunTour){
        m_firstRunLiveTour = firRunTour;
        config->writeEntry("FirstRunTour",m_firstRunLiveTour);
        emit firstRunLiveTourChanged(m_firstRunLiveTour);
        emit configNeedsSaving();
    }
}

bool StoredParameters::firstRunLiveTour() const
{
    return m_firstRunLiveTour;
}

void StoredParameters::setFirstRunCalibrationPreviews(bool firRunCalib)
{
    if(m_firstRunCalibrationPreviews != firRunCalib){
        m_firstRunCalibrationPreviews = firRunCalib;
        config->writeEntry("FirstRunCalibration",m_firstRunCalibrationPreviews);
        emit firstRunLiveTourChanged(m_firstRunCalibrationPreviews);
        emit configNeedsSaving();
    }
}

bool StoredParameters::firstRunCalibrationPreviews() const
{
    return m_firstRunCalibrationPreviews;
}


void StoredParameters::setHideOnClick(bool hideClick)
{
    if(m_hideOnClick != hideClick){
        m_hideOnClick = hideClick;
        config->writeEntry("HideOnClick",m_hideOnClick);
        emit hideOnClickChanged(m_hideOnClick);
        emit configNeedsSaving();
    }
}

bool StoredParameters::hideOnClick() const
{
    return m_hideOnClick;
}

void StoredParameters::setToolTipsDelay(int tDelay)
{
    if(m_toolTipsDelay != tDelay){
        m_toolTipsDelay = tDelay;
        config->writeEntry("ToolTipsDelay",m_toolTipsDelay);
        emit toolTipsDelayChanged(m_toolTipsDelay);
        emit configNeedsSaving();
    }
}

int StoredParameters::toolTipsDelay() const
{
    return m_toolTipsDelay;
}

void StoredParameters::setCurrentTheme(QString theme)
{
    if(m_currentTheme != theme){
        m_currentTheme = theme;
        config->writeEntry("CurrentTheme",m_currentTheme);
        emit currentThemeChanged(m_currentTheme);
        emit configNeedsSaving();
    }
}

QString StoredParameters::currentTheme() const
{
    return m_currentTheme;
}

void StoredParameters::addTheme(QString theme)
{
    m_loadedThemes.append(theme);
}


QList<QString> *StoredParameters::themesList()
{
    return &m_loadedThemes;
}



#include "storedparameters.moc"
