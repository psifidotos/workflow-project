import QtQuick 1.1
import "../code/settings.js" as Settings
import org.kde.qtextracomponents 0.1

QtObject {
    property bool lockActivities: plasmoid.readConfig("LockActivities")
    property bool showWindows: plasmoid.readConfig("ShowWindows")
    property int scale: plasmoid.readConfig("Scale")
    property int animations: plasmoid.readConfig("Animations")
    property int animationSpeed: plasmoid.readConfig("AnimationSpeed")
    property int animationStep: animations >= 1 ? animationSpeed:0
    property int animationStep2: animations >= 2 ? animationSpeed:0
    property bool windowPreviews: plasmoid.readConfig("WindowPreviews")
    property int windowPreviewsOffsetX: plasmoid.readConfig("WindowPreviewsOffsetX")
    property int windowPreviewsOffsetY: plasmoid.readConfig("WindowPreviewsOffsetY")
    property int fontRelevance: plasmoid.readConfig("FontRelevance")
    property bool showStoppedPanel: plasmoid.readConfig("ShowStoppedPanel")
    property bool firstRunTour: plasmoid.readConfig("FirstRunTour")
    property bool firstRunCalibration: plasmoid.readConfig("FirstRunCalibration")
    property bool hideOnClick: plasmoid.readConfig("HideOnClick")
    property bool useCurrentActivityIcon: plasmoid.readConfig("UseCurrentActivityIcon")
    property bool disableEverywherePanel: plasmoid.readConfig("DisableEverywherePanel")
    property bool disableBackground: plasmoid.readConfig("DisableBackground")
    property bool triggerKWinScript: plasmoid.readConfig("TriggerKWinScript")
    property bool disableCompactRepresentation: plasmoid.readConfig("DisableCompactRepresentation")


    // Small hack to make sure the global settings object is set
    property bool setAsGlobal: false
    onSetAsGlobalChanged: {
        if (setAsGlobal) 
            Settings.global = settings
    }
    
    onLockActivitiesChanged: { plasmoid.writeConfig("LockActivities", lockActivities); }
    onShowWindowsChanged: { plasmoid.writeConfig("ShowWindows", showWindows) ; }
    onScaleChanged: { plasmoid.writeConfig("Scale", scale) ; }
    onAnimationsChanged: { plasmoid.writeConfig("Animations", animations) ; }
    onAnimationSpeedChanged: { plasmoid.writeConfig("AnimationSpeed", animationSpeed) ; }
    onWindowPreviewsChanged: { plasmoid.writeConfig("WindowPreviews", windowPreviews) ; }
    onWindowPreviewsOffsetXChanged: { plasmoid.writeConfig("WindowPreviewsOffsetX", windowPreviewsOffsetX) ; }
    onWindowPreviewsOffsetYChanged: { plasmoid.writeConfig("WindowPreviewsOffsetY", windowPreviewsOffsetY) ; }
    onFontRelevanceChanged: { plasmoid.writeConfig("FontRelevance", fontRelevance) ; }
    onShowStoppedPanelChanged: { plasmoid.writeConfig("ShowStoppedPanel", showStoppedPanel) ; }
    onFirstRunTourChanged: { plasmoid.writeConfig("FirstRunTour", firstRunTour) ; }
    onFirstRunCalibrationChanged: { plasmoid.writeConfig("FirstRunCalibration", firstRunCalibration) ; }
    onHideOnClickChanged: { plasmoid.writeConfig("HideOnClick", hideOnClick) ; }
    onUseCurrentActivityIconChanged: { plasmoid.writeConfig("UseCurrentActivityIcon", useCurrentActivityIcon) ; }
    onDisableEverywherePanelChanged: { plasmoid.writeConfig("DisableEverywherePanel", disableEverywherePanel) ; }
    onDisableBackgroundChanged: { plasmoid.writeConfig("DisableBackground", disableBackground) ; }
    onTriggerKWinScriptChanged: { plasmoid.writeConfig("TriggerKWinScript", triggerKWinScript) ;}
    //onDisableCompactRepresentationChanged: { plasmoid.writeConfig("DisableCompactRepresentation", disableCompactRepresentation) ; }
    

    function configChanged() {
        hideOnClick = plasmoid.readConfig("HideOnClick");
        animations = plasmoid.readConfig("Animations");
        useCurrentActivityIcon = plasmoid.readConfig("UseCurrentActivityIcon");
        disableEverywherePanel = plasmoid.readConfig("DisableEverywherePanel");
        disableBackground = plasmoid.readConfig("DisableBackground");
        triggerKWinScript = plasmoid.readConfig("TriggerKWinScript");
    }

    Component.onCompleted: {
/*        console.log("lockActivities: " + lockActivities)
        console.log("showWindows: " + showWindows)
        console.log("scale: " + scale)
        console.log("animations: " + animations)
        console.log("animationSpeed: " + animationSpeed)
        console.log("windowPreviews: " + windowPreviews)
        console.log("windowPreviewsOffsetX: " + windowPreviewsOffsetX)
        console.log("windowPreviewsOffsetY: " + windowPreviewsOffsetY)
        console.log("fontRelevance: " + fontRelevance)
        console.log("showStoppedPanel: " + showStoppedPanel)
        console.log("firstRunTour: " + firstRunTour)
        console.log("firstRunCalibration: " + firstRunCalibration)
        console.log("hideOnClick: " + hideOnClick)
        console.log("currentTheme: " + currentTheme)
        console.log("toolTipsDelay: " + toolTipsDelay)
      //  console.log("Theme size: " + theme.iconSizes.dialog)
        console.log("useCurrentActivityIcon: " + useCurrentActivityIcon)
        console.log("disableEverywherePanel: " + disableEverywherePanel)*/
    }
}
