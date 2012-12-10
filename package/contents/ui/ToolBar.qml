// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import "components"

import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.qtextracomponents 0.1

PlasmaComponents.ToolBar {
    id:oxygenTitle
    property bool activitiesLocked: !activityLockButton.checked
    property alias windowsChecked: windowsToolBtn.checked
    property alias effectsChecked: effectsToolBtn.checked

    tools: PlasmaComponents.ToolBarLayout {
    height: parent.height
        PlasmaComponents.ToolButton {
            id: activityLockButton
            width: parent.height
            height: parent.height
            iconSource: checked ? "object-locked" : "object-unlocked" 
            checkable: true
            onCheckedChanged: plasmoid.writeConfig("ActivitiesLocked", checked)
            Component.onCompleted: checked = plasmoid.readConfig("ActivitiesLocked")
        }
        PlasmaComponents.ToolButton{
            id:windowsToolBtn
            width: parent.height
            height: parent.height
            checkable:true
            iconSource: "window-duplicate"
            //TODO write to config
            onCheckedChanged: console.log("Todo: " + checked)
        }

        PlasmaComponents.ToolButton{
            id: effectsToolBtn
            checkable: true
            width: parent.height
            height: parent.height
            iconSource: "view-preview"
            //TODO decouple this
            enabled: mainView.showWinds && mainView.effectsSystemEnabled
            //TODO write to config
            onCheckedChanged: console.log("Todo: " + checked)

            Image{
                smooth:true
                height: 0.2 * parent.height
                width: 1.4 * height
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.leftMargin: 3
                anchors.bottomMargin: 3
                source:"Images/buttons/downIndicator.png"
                opacity:0.6
            }
        }
        PlasmaComponents.ToolButton{
            id: helpButton
            width: parent.height
            height: parent.height
            iconSource: "help-about"
            onClicked: console.log("Todo")
        }
    }
}
