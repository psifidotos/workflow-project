import QtQuick 1.1

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

    PlasmaCore.DataSource {
        id: activitySource
        engine: "org.kde.activities"
        connectedSources: sources
        onDataChanged: connectedSources = sources
    }

    PlasmaCore.DataModel {
        id: activityModel
        dataSource: activitySource
    }

    Component {
        id: modelDelegate
        Item {
            width: 70 + 3 * container.scale;
            height: headerBackground.height
            Item {
                id: headder
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
                }
                ActivityTitle {
                    id: activityTitle
                    text: Name
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
                }
            }
        }
    }

    PlasmaExtras.ScrollArea {
        anchors.fill: parent
        ListView {
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
    }
}
