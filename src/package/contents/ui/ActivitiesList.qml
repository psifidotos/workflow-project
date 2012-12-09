import QtQuick 1.1

import org.kde.workflow.components 0.1 as WorkFlowComponents
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.plasma.extras 0.1 as PlasmaExtras
import org.kde.qtextracomponents 0.1

import "delegates"
import "tooltips"
import "components"

Item {
    id: container

    property int scale: 50
    property int animationsStep: 0

    WorkFlowComponents.ActivityManager {
        id: activityManagerInstance
        Component.onCompleted: { console.log("ActivityManager loaded") }
    }

    PlasmaCore.DataSource {
        id: activitySource
        engine: "org.kde.activities"
        connectedSources: sources
        onDataChanged: connectedSources = sources
    }

    PlasmaCore.DataModel {
        id: activityModel
        dataSource: activitySource
        // This is the better way, but breaks model[key] refences for some reason
        //keyRoleFilter: "Name"
        // Workaround to not display the Status source (can be remnoved if the above works)
        sourceFilter: "[^S].*"
    }

    Component {
        id: modelDelegate
        Item {
            width: model["State"] == "Running" ? (70 + 3 * container.scale) : 0;
            opacity: model["State"] == "Running" ? 1 : 0
            height: headerBackground.height
            Item {
                id: header
                anchors.fill: parent
                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                }
                ActivityIcon {
                    id: activityIcon
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.bottomMargin: 10
                    icon: model["Icon"] == "" ? QIcon("plasma") : model["Icon"]
                }
                ActivityTitle {
                    id: activityTitle
                    text: model["Name"]
                    anchors.left: activityIcon.right
                    anchors.bottom: activityIcon.bottom
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                }
                ActivityButtons {
                    id: buttons
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    opacity: containsMouse || activityIcon.containsMouse || activityTitle.containsMouse || mouseArea.containsMouse
                    lockActivities: mainView.lockActivities
                    activityID: DataEngineSource
                    activityManager: activityManagerInstance
                }
            }
        }
    }

    //PlasmaExtras.ScrollArea {
        ListView {
            anchors.fill: parent
            boundsBehavior: Flickable.StopAtBounds
            id: listView
            orientation: ListView.Horizontal
            model: activityModel
            delegate: modelDelegate
            Component.onCompleted: { console.log("Count: " + activityModel.count) }

            Rectangle {
                id: headerBackground
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                height: 100
                z: -100
                color: "#646464"
                border.color: "#333333"
                border.width:1
            }

            Rectangle{
                id: headerShadow
                anchors.top: headerBackground.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: 16
                z: -100
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#aa0f0f0f" }
                    GradientStop { position: 1.0; color: "#00797979" }
                }
            }
        }
    //}
}
