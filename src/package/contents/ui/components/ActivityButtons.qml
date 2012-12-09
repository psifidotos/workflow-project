// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import org.kde.workflow.components 0.1 as WorkFlowComponents
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.qtextracomponents 0.1
import "../tooltips"

Item{
    id: activityButtons

    property int buttonsSize: 24
    property int buttonsSpace: 5
    property bool containsMouse: fRect.containsMouse || sRect.containsMouse
    property bool lockActivities: false
    property bool oneActivityShown: false
    property string activityID

    WorkFlowComponents.ActivityManager {
        id: activityManager
    }

    Component.onCompleted: { console.log("Completed") }

    Rectangle{
        id: fRect
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin:0.5*buttonsSize
        width: 1.5 * addWidgetButton.width
        height: 1.5 * addWidgetButton.height
        radius: 3
        // TODO read config value instead
        opacity: lockActivities ? 0 : 1
        border.color: "#333333"
        border.width:  1
        color: "#222222"
        property alias containsMouse: addWidgetButton.containsMouse

        IconButton {
            id: addWidgetButton
            icon: "list-add"
            width: buttonsSize
            height: buttonsSize
            anchors.centerIn: parent

            onClicked: {
                console.log("TODO")
            }

            tooltipTitle: i18n("Add Widgets")
            tooltipText: i18n("Add widgets to your Activity in order to customize it more.")
        }
    }

    Rectangle{
        id:sRect

        radius:3
        anchors.right: parent.right
        anchors.rightMargin:0.5*buttonsSize
        anchors.top: parent.top
        opacity: oneActivityShown && mainView.lockActivities ? 0 : 1
        width: lockActivities || oneActivityShown ? 1.4 * stopButton.width : 1.25 * rightActions.width
        height: lockActivities ? 1.3 * stopButton.height : 1.5 * rightActions.height
        border.color: "#404040"
        border.width:  1
        color: "#222222"
        property bool containsMouse: stopButton.containsMouse || duplicateButton.containsMouse || deleteButton.containsMouse

        Row{
            id:rightActions
            spacing:buttonsSpace
            anchors.centerIn: parent

            IconButton {
                id:stopButton
                icon: "media-playback-pause"
                width: lockActivities ? 1.2 * buttonsSize : buttonsSize
                height: width
                opacity: oneActivityShown ? 0 : 1

                onClicked: {
                    activityManager.stopActivity(activityID)
                }

                tooltipTitle: i18n("Pause Activity")
                tooltipText: i18n("You can pause an Activity and place it on the right panel.This way the Activity will be always available to continue your work from where you stopped.")
            }

            IconButton {
                id: duplicateButton
                icon: "tab-duplicate"
                width: buttonsSize
                height: buttonsSize
                opacity: lockActivities ? 0 : 1
                onClicked: {
                    console.log("TODO")
                }
                tooltipTitle: i18n("Clone Activity")
                tooltipText: i18n("You can clone an Activity.")
            }

            IconButton {
                id: deleteButton
                icon: "edit-delete"
                width: buttonsSize
                height: buttonsSize
                opacity: oneActivityShown || lockActivities ? 0 : 1
                onClicked: {
                    activityManager.removeActivity(activityID)
                }
                tooltipTitle: i18n("Delete Activity")
                tooltipText: i18n("You can delete an Activity. Be careful, this action can not be undone.")
            }
        }
    }
}

