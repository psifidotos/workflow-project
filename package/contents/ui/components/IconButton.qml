import QtQuick 1.1

import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.qtextracomponents 0.1
import "../tooltips"

import "../../code/settings.js" as Settings

Item {
    id: container
    property real hoverScale: 1.3
    property string icon: ""
    property int animationSpeed: 2*Settings.global.animationStep
    property string tooltipText: ""
    property string tooltipTitle: ""
    property alias containsMouse: mouseArea.containsMouse

    width: 42
    height: 42

    signal clicked
    signal entered
    signal exited

    QIconItem {
        id: image
        icon: container.icon !== "" ? QIcon(container.icon) : QIcon()
        anchors.fill: parent
        scale: mouseArea.containsMouse ? hoverScale : 1

        smooth:true

        Behavior on scale {
            NumberAnimation {
                duration: animationSpeed
                easing.type: Easing.InOutQuad
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true

        onEntered: {
            container.entered()
        }

        onExited: {
            container.exited()
        }

        onClicked: {
            container.clicked()
        }
    }

    PlasmaCore.ToolTip{
        mainText: tooltipTitle
        subText: tooltipText
        target: mouseArea
        image: container.icon
    }
}
