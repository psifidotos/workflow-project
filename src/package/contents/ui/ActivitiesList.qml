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
                ActivityIcon {
                    id: activityIcon
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                }
                ActivityTitle {
                    text: Name
                    anchors.left: activityIcon.right
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    anchors.top: parent.top
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
