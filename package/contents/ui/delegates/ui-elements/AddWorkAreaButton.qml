import QtQuick 1.0

import org.kde.plasma.core 0.1 as PlasmaCore
import "../../../code/settings.js" as Settings

Rectangle{

    property color fromColor:"#00c9c9c9"
    property color toColor:"#ccfafafa"
    property color borderFromColor:"#00686868"
    property color borderToColor:"#ff686868"

    height:40
    color: showSelection ? toColor : fromColor
    border.color: showSelection ? borderToColor : borderFromColor

    border.width: 2
    radius: 4
    z:6

    property bool isKeysSelected: ( (keyNavigation.isActive) &&
                                   (keyNavigation.selectedActivity === workList.ccode) &&
                                   (keyNavigation.selectedWorkarea === addWorkareaPosition) )


    property int addWorkareaPosition : workflowManager.model().workareas(workList.ccode).count + 1
    property bool showSelection : addWorkareaMouseArea.containsMouse || isKeysSelected

    Rectangle{
        width:20
        height:20
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        color:"transparent"

        Rectangle{
            width:parent.width
            height:3
            anchors.centerIn: parent
            color:"#777777"
        }

        Rectangle{
            height:parent.height
            width:3
            anchors.horizontalCenter: parent.horizontalCenter
            color:"#777777"
        }
    }

    Behavior on color{
        ColorAnimation { from: addWorkArea.color; duration: 3*Settings.global.animationStep }
    }
    Behavior on border.color{
        ColorAnimation { from: addWorkArea.border.color; duration: 3*Settings.global.animationStep }
    }

    MouseArea {
        id:addWorkareaMouseArea
        anchors.fill: parent
        hoverEnabled: true
    }

    PlasmaCore.ToolTip{
        mainText: i18n("Add WorkArea")
        subText: i18n("You can add a Workarea in order to sub-organize better your work.")
        target:addWorkareaMouseArea
        //localIcon:addButtonImage.source
    }

}

