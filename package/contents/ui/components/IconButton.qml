import QtQuick 1.1

import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.qtextracomponents 0.1

import "../../code/settings.js" as Settings

Item {
    id: container
    property real hoverScale: 1.3
    property string icon: ""
    property int animationSpeed: 2*Settings.global.animationStep
    property string tooltipText: ""
    property string tooltipTitle: ""
    property alias containsMouse: mouseArea.containsMouse
    property bool opacityAnimation:false

    width: 42
    height: 42

    signal clicked
    signal entered
    signal exited

    QIconItem {
        id: image
        smooth:true
        icon: container.icon !== "" ? QIcon(container.icon) : QIcon()
        anchors.fill: parent
        property real hoverValue: !opacityAnimation ? hoverScale : 1
        property real opacityValue: opacityAnimation ? 0.5 : 1
        scale: mouseArea.containsMouse ? hoverValue : 1
        opacity: mouseArea.containsMouse  ? 1 : opacityValue

        Behavior on scale {
            NumberAnimation {
                duration: animationSpeed
                easing.type: Easing.InOutQuad
            }
        }
        Behavior on opacity {
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
