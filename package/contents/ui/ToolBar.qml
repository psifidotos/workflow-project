// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import "components"

import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.qtextracomponents 0.1

PlasmaComponents.ToolBar {
    id: component
    property bool activitiesLocked: !activityLockButton.checked
    property alias showWindows: windowsVisableButton.checked
    property alias showWindowPreviews: windowPreviewButton.checked

    tools: PlasmaComponents.ToolBarLayout {
        height: component.height * 0.8
        
        function windowStateChanged() {
            if (windowsVisableButton.checked) {
                windowPreviewButton.enabled = true
                if (windowPreviewButton.checked) {
                    plasmoid.writeConfig("ShowWindows", 2)
                } else {
                    plasmoid.writeConfig("ShowWindows", 1)
                }
            } else {
                windowPreviewButton.enabled = false
                plasmoid.writeConfig("ShowWindows", 0)
            }
        }
        
        PlasmaComponents.ToolButton {
            id: activityLockButton
            width: parent.height
            height: parent.height
            iconSource: checked ? "object-locked" : "object-unlocked" 
            checkable: true
            checked: plasmoid.readConfig("ActivitiesLocked")
        }
        PlasmaComponents.ToolButton{
            id: windowsVisableButton
            width: parent.height
            height: parent.height
            checkable:true
            iconSource: "window-duplicate"
        }

        PlasmaComponents.ToolButton{
            id: windowPreviewButton
            checkable: true
            width: parent.height
            height: parent.height
            iconSource: "view-preview"
            enabled: windowsVisableButton.checked
            onCheckedChanged: parent.windowStateChanged()

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
        Component.onCompleted: { 
            var showWindows =  plasmoid.readConfig("ShowWindows")
            if (showWindows == 2) {
                windowPreviewButton.checked = true
                windowsVisableButton.checked = true
                windowPreviewButton.enabled = true
            } else if (showWindows == 1) {
                windowPreviewButton.checked = false
                windowsVisableButton.checked = true
                windowPreviewButton.enabled = true
            } else {
                windowPreviewButton.checked = false
                windowsVisableButton.checked = false
                windowPreviewButton.enabled = false
            }
            windowPreviewButton.checkedChanged.connect(windowStateChanged)
            windowsVisableButton.checkedChanged.connect(windowStateChanged)
            activityLockButton.checkedChanged.connect(function() {
                plasmoid.writeConfig("ActivitiesLocked", activityLockButton.checked)
            })
        }
    }
}
