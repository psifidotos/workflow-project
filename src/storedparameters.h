#ifndef STOREDPARAMETERS_H
#define STOREDPARAMETERS_H

#include <QObject>

class StoredParameters : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool lockActivities READ lockActivities WRITE setLockActivities NOTIFY lockActivitiesChanged)
    Q_PROPERTY(bool showWindows READ showWindows WRITE setShowWindows NOTIFY showWindowsChanged)
    Q_PROPERTY(int zoomFactor READ zoomFactor WRITE setZoomFactor NOTIFY zoomFactorChanged)

    Q_PROPERTY(bool showStoppedActivities READ showStoppedActivities WRITE setShowStoppedActivities NOTIFY showStoppedActivitiesChanged)
    Q_PROPERTY(int fontRelevance READ fontRelevance WRITE setFontRelevance NOTIFY fontRelevanceChanged)

    Q_PROPERTY(bool firstRunLiveTour READ firstRunLiveTour WRITE setFirstRunLiveTour NOTIFY firstRunLiveTourChanged)
    Q_PROPERTY(bool firstRunCalibrationPreviews READ firstRunCalibrationPreviews WRITE setFirstRunCalibrationPreviews NOTIFY firstRunCalibrationPreviewsChanged)

    Q_PROPERTY(bool hideOnClick READ hideOnClick WRITE setHideOnClick NOTIFY hideOnClickChanged)
    Q_PROPERTY(bool toolTipsDelay READ toolTipsDelay WRITE setToolTipsDelay NOTIFY toolTipsDelayChanged)

    Q_PROPERTY(QString currentTheme READ currentTheme WRITE setCurrentTheme NOTIFY currentThemeChanged)

    Q_PROPERTY(int animations READ animations WRITE setAnimations NOTIFY animationsChanged)
    Q_PROPERTY(int animationsStep READ animationsStep NOTIFY animationsStepChanged)
    Q_PROPERTY(int animationsStep2 READ animationsStep2 NOTIFY animationsStep2Changed)

    Q_PROPERTY(bool windowsPreviews READ windowsPreviews WRITE setWindowsPreviews NOTIFY windowsPreviewsChanged)
    Q_PROPERTY(int windowsPreviewsOffsetX READ windowsPreviewsOffsetX WRITE setWindowsPreviewsOffsetX NOTIFY windowsPreviewsOffsetXChanged)
    Q_PROPERTY(int windowsPreviewsOffsetY READ windowsPreviewsOffsetY WRITE setWindowsPreviewsOffsetY NOTIFY windowsPreviewsOffsetYChanged)

    Q_PROPERTY(bool useActivityIcon READ useActivityIcon WRITE setUseActivityIcon NOTIFY useActivityIconChanged)
public:
    /*
    enum AnimationsLevel {
       NONE,
       BASIC,
       FULL
    };*/

    explicit StoredParameters(QObject *parent = 0);
    ~StoredParameters();

    Q_INVOKABLE void addTheme(QString);

    void setLockActivities(bool);
    bool lockActivities() const;

    void setShowWindows(bool);
    bool showWindows() const;

    void setZoomFactor(int);
    int zoomFactor() const;

    void setShowStoppedActivities(bool);
    bool showStoppedActivities() const;

    void setFontRelevance(int);
    int fontRelevance() const;

    void setFirstRunLiveTour(bool);
    bool firstRunLiveTour() const;

    void setFirstRunCalibrationPreviews(bool);
    bool firstRunCalibrationPreviews() const;

    void setHideOnClick(bool);
    bool hideOnClick() const;

    void setToolTipsDelay(int);
    int toolTipsDelay() const;

    void setCurrentTheme(QString);
    QString currentTheme() const;

    QList<QString> *themesList();


    void setAnimations(int);
    int animations() const;

    int animationsStep() const;
    int animationsStep2() const;

    void setWindowsPreviews(bool);
    bool windowsPreviews() const;

    void setWindowsPreviewsOffsetX(int);
    int windowsPreviewsOffsetX() const;

    void setWindowsPreviewsOffsetY(int);
    int windowsPreviewsOffsetY() const;

    void setUseActivityIcon(bool);
    bool useActivityIcon() const;

signals:
    void configNeedsSaving();

    void lockActivitiesChanged(bool);
    void showWindowsChanged(bool);
    void zoomFactorChanged(int);
    void showStoppedActivitiesChanged(bool);
    void fontRelevanceChanged(int);
    void firstRunLiveTourChanged(bool);
    void firstRunCalibrationPreviewsChanged(bool);
    void hideOnClickChanged(bool);
    void toolTipsDelayChanged(int);
    void currentThemeChanged(QString);

    void animationsChanged(int);
    void animationsStepChanged(int);
    void animationsStep2Changed(int);

    void windowsPreviewsChanged(bool);
    void windowsPreviewsOffsetXChanged(int);
    void windowsPreviewsOffsetYChanged(int);

    void useActivityIconChanged(bool);

private:
   bool m_lockActivities;
   bool m_showWindows;
   int m_zoomFactor;
   int m_fontRelevance;
   bool m_showStoppedActivities;
   bool m_firstRunLiveTour;
   bool m_firstRunCalibrationPreviews;
   bool m_hideOnClick;
   int m_toolTipsDelay;

   QString m_currentTheme;
   QList <QString> m_loadedThemes;

   int m_animations;
   int m_animationsStep; //Basic animations duration
   int m_animationsStep2; //Full animations duration

   bool m_windowsPreviews; //Windows previews enabled or not
   int m_windowsPreviewsOffsetX; // X Offset for Windows previews
   int m_windowsPreviewsOffsetY; // Y Offset for Windows previews

   bool m_useActivityIcon;

   void updateAnimationsSteps();
};


#endif
