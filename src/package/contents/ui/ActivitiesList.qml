import QtQuick 1.1

import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.plasma.extras 0.1 as PlasmaExtras
import org.kde.qtextracomponents 0.1

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
            height: 50
            Rectangle { color: "blue"; anchors.fill: parent }
            Text { text: Name }
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
