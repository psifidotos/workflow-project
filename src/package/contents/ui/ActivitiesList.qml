import QtQuick 1.1

import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.plasma.extras 0.1 as PlasmaExtras
import org.kde.qtextracomponents 0.1

import "delegates"
import "tooltips"

Item {
    id: container

    property int scale: 50
    //property alias actImagHeight: 20//actImag1.height
    //property color actImagBordColor: "#77ffffff"
    //property alias activitiesShown: activitiesList.shownActivities
    //property alias flickableV:view.interactive
    //property string typeId : "workareasMainView"
    //property int workareaWidth: 0
    //property int workareaHeight: 0
    property int animationsStep: 0
    //property int verticalScrollBarLocation: view.width

    PlasmaCore.DataSource {
        id: activitySource
        engine: "org.kde.activities"
        connectedSources: sources
    }

    PlasmaCore.DataModel {
        id: activityModel
        dataSource: activitySource
    }

    Component {
        id: modelDelegate
        Item {
            width: 70 + 3 * container.scale;
            Item {
                id: headder
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: 100
                QIconItem {
                    id: activityIcon
                    icon: Icon === "" ? "plasma" : Icon

                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 3

                    width: 5 + container.scale
                    height: width
                    smooth: true

                    Behavior on rotation{
                        NumberAnimation {
                            duration: mainView.animationsStep;
                            easing.type: Easing.InOutQuad;
                        }
                    }

                    MouseArea {
                        id:activityIconMouseArea
                        anchors.fill: parent
                        hoverEnabled: true

                        onEntered: {
                        }

                        onExited: {
                        }

                        onClicked: {
                        }
                    }
                }
                Text {
                    id: activityName
                    text: Name
                    anchors.left: activityIcon.right
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    verticalAlignment: Text.AlignBottom
                    wrapMode: TextEdit.Wrap

                    font.family: mainView.defaultFont.family
                    font.bold: true
                    font.italic: true

                    font.pixelSize: 0.22 * parent.height
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
        }
    }
}
