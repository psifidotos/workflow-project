// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.qtextracomponents 0.1

import "../../components"
import "../../../code/settings.js" as Settings

Item{
    id: activityButtons

    property int buttonsSize:0.5 * mainView.scaleMeter
    property int buttonsSpace:mainView.scaleMeter / 10
    property bool containsMouse: fRect.containsMouse || sRect.containsMouse

    Rectangle{
        id:fRect
        width:1.5*addWidgetsBtn.width
        height:1.5*addWidgetsBtn.height
        radius:3
        opacity: Settings.global.lockActivities ? 0 : 1

        x:buttonsSize/2
        anchors.top: parent.top

        border.color: sessionParameters.currentActivity !== ccode ? "#404040" : "#333333"
        border.width:  1
        color: sessionParameters.currentActivity !== ccode ? "#222222" : "#0a0a0a"
        property alias containsMouse: addWidgetsBtn.containsMouse

        IconButton {
            id:addWidgetsBtn
            icon: instanceOfThemeList.icons.AddWidget
            width: buttonsSize
            height: buttonsSize
            anchors.centerIn: parent

            onClicked: {
                environmentManager.showWidgetsExplorer(ccode);
            }

            tooltipTitle: i18n("Add Plasmoids")
            tooltipText: i18n("Add Plasmoids to your Activity in order to customize it more.")
        }
    }

    Rectangle{
        id:sRect

        radius:3
        anchors.right: parent.right
        anchors.rightMargin:0.5*buttonsSize
        anchors.top: parent.top
        opacity: allwlists.activitiesShown == 1 && Settings.global.lockActivities ? 0 : 1

        width: Settings.global.lockActivities || allwlists.activitiesShown === 1 ? 1.4 * stopActivityBtn.width : 1.25 * rightActions.width
        height: Settings.global.lockActivities ? 1.3 * stopActivityBtn.height : 1.5 * rightActions.height
        border.color: sessionParameters.currentActivity !== ccode ? "#404040" : "#333333"
        border.width:  1
        color: sessionParameters.currentActivity !== ccode ? "#222222" : "#0a0a0a"
        property bool containsMouse: stopActivityBtn.containsMouse
                                     || duplicateActivityBtn.containsMouse

        Row{
            id:rightActions
            spacing:buttonsSpace
            anchors.centerIn: parent

            IconButton {
                id:duplicateActivityBtn
                icon:instanceOfThemeList.icons.CloneActivity
                width: buttonsSize
                height: buttonsSize
                opacity: Settings.global.lockActivities ? 0 : 1
                onClicked: {
                    mainView.getDynLib().showCloneDialog(ccode,workflowManager.activityManager().name(ccode));
                }
                tooltipTitle: i18n("Clone Activity")
                tooltipText: i18n("You can clone an Activity.")
            }

            IconButton {
                id:stopActivityBtn
                icon: instanceOfThemeList.icons.PauseActivity
                width: Settings.global.lockActivities ? 1.2 * buttonsSize : buttonsSize
                height: width
                opacity: allwlists.activitiesShown > 1 ? 1 : 0

                onClicked: {
                    activityButtons.clickedStopped();
                }

                tooltipTitle: i18n("Pause Activity")
                tooltipText: i18n("You can pause an Activity and place it on the right panel.This way the Activity will be always available to continue your work from where you stopped.")
            }

        }
    }

    function clickedStopped(){
        workflowManager.activityManager().stop(ccode);

        if(Settings.global.animationStep2!==0){
            var x1 = activityIcon.x;
            var y1 = activityIcon.y;

            mainView.getDynLib().animateActiveToStop(ccode,activityIcon.mapToItem(mainView,x1, y1));
        }

    }
}

