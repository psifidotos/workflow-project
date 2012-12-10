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
    property bool locked: false

    WorkFlowComponents.ActivityManager {
        id: activityManagerInstance
    }

    PlasmaCore.DataSource {
        id: activitySource
        engine: "org.kde.activities"
        connectedSources: sources
        onDataChanged: {
            connectedSources = sources
            // 0 is the highlight item, so skip it
            for (var i = 1; i < listView.contentItem.children.length; i++) {
                if (listView.contentItem.children[i].current) {
                    listView.currentActivity = listView.contentItem.children[i]
                    break
                }
            }
        }
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
            id: delegateItem
            width: model["State"] == "Running" ? (70 + 3 * container.scale) : 0;
            height: 500
            opacity: model["State"] == "Running" ? 1 : 0
            property bool current: model["Current"]
            property string name: model["Name"]

            Behavior on opacity{
                NumberAnimation {
                    // TODO read config value
                    duration: 300;
                    easing.type: Easing.InOutQuad;
                }
            }

            Behavior on width{
                NumberAnimation {
                    // TODO read config value
                    duration: 300;
                    easing.type: Easing.InOutQuad;
                }
            }

            function setCurrent() {
                var service = activitySource.serviceForSource(model["DataEngineSource"])
                var operation = service.operationDescription("setCurrent")
                service.startOperationCall(operation)
            }

            Item {
                id: header
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: 100
                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: delegateItem.setCurrent()

                }
                ActivityIcon {
                    id: activityIcon
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.bottomMargin: 5
                    anchors.leftMargin: 5
                    anchors.rightMargin: 5
                    icon: model["Icon"] == "" ? QIcon("plasma") : model["Icon"]
                    locked: container.locked
                }
                ActivityTitle {
                    id: activityTitle
                    text: model["Name"]
                    anchors.left: activityIcon.right
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottomMargin: 5
                    anchors.leftMargin: 5
                    anchors.rightMargin: 5
                    locked: container.locked
                    onClicked: delegateItem.setCurrent()
                }
                ActivityButtons {
                    id: buttons
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    opacity: containsMouse || activityIcon.containsMouse || activityTitle.containsMouse || mouseArea.containsMouse
                    activityID: DataEngineSource
                    activityManager: activityManagerInstance
                    oneActivityShown: activitySource.data["Status"]["Running"].length == 1
                    locked: container.locked
                }
            }
            Item {
                id: body
                anchors.top: header.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom

                Rectangle {
                    //TODO change to a nice gradient
                    color: "black"
                    anchors.right: parent.right
                    width: 1
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                }
            }
        }
    }

    PlasmaExtras.ScrollArea {
        anchors.fill: parent
        Flickable {
            anchors.fill: parent
            boundsBehavior: Flickable.StopAtBounds
            contentWidth: width > listView.contentWidth ? width : listView.contentWidth
            contentHeight: listView.height

            ListView {
                id: listView
                height: 500
                width: parent.width > contentWidth ? parent.width : contentWidth
                property Item currentActivity
                orientation: ListView.Horizontal
                interactive: false
                highlightFollowsCurrentItem: false
                model: activityModel
                delegate: modelDelegate
                highlight: Component {
                        Rectangle {
                            x: listView.currentActivity ? listView.currentActivity.x : 0
                            height: 100
                            id: currentActivityBackground
                            color: "#ff444444"
                            width: 70 + 3 * container.scale
                            Item {
                                anchors.top: parent.top
                                anchors.left: parent.right
                                anchors.bottom: parent.bottom
                                width: 10//parent.height
                                Rectangle {
                                    width: parent.height
                                    height: parent.width
                                    rotation: -90
                                    y: (parent.height - height) / 2
                                    x: (-parent.height + height) / 2
                                    color: "red"
                                    gradient: Gradient {
                                        GradientStop { position: 0.0; color: "#ff444444" }
                                        GradientStop { position: 1.0; color: "#00000000" }
                                    }
                                }
                            }
                            Item {
                                anchors.top: parent.top
                                anchors.right: parent.left
                                anchors.bottom: parent.bottom
                                width: 10
                                Rectangle {
                                    width: parent.height
                                    height: parent.width
                                    rotation: 90
                                    y: (parent.height - height) / 2
                                    x: (-parent.height + height) / 2
                                    color: "red"
                                    gradient: Gradient {
                                        GradientStop { position: 0.0; color: "#ff444444" }
                                        GradientStop { position: 1.0; color: "#00000000" }
                                    }
                                }
                            }
                            Behavior on x {
                                SpringAnimation {
                                    spring: 2
                                    damping: 0.2
                                }
                        }
                    }
                }

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
}
