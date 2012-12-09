import QtQuick 1.1
import org.kde.qtextracomponents 0.1

Item {
    id: container
    property alias containsMouse: mouseArea.containsMouse
    signal clicked
    signal entered
    signal exited
    property int size: 55
    width: size
    height: size
    property alias icon: icon.icon

    // TODO use the settings value
    property bool locked: true

    QIconItem {
        id: icon
        rotation: mouseArea.containsMouse && !locked ? -10 : 0

        anchors.fill: parent
        smooth: true

        Behavior on rotation{
            NumberAnimation {
                // TODO Use the settings value
                duration: 300
                easing.type: Easing.InOutQuad;
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true

        onEntered: { entered }
        onExited: { exited }
        onClicked: { clicked }
    }

}
