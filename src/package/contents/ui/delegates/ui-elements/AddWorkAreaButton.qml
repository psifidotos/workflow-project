import QtQuick 1.0

import "../../tooltips"

Rectangle{


    height:40
    color: fromColor
    property color fromColor:"#00c9c9c9"
    property color toColor:"#ccfafafa"
    property color borderFromColor:"#00686868"
    property color borderToColor:"#ff686868"

    border.color: borderFromColor
    border.width: 2
    radius: 4
    z:6

    Rectangle{
        width:20
        height:20
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        color:"transparent"

        Image {
            id:addButtonImage
            source:"../../Images/addWorkAreaBtn.png"
            width:parent.width
            height:parent.height


        }

    }

    Behavior on color{
        ColorAnimation { from: addWorkArea.color; duration: 3*parametersManager.animationsStep }
    }
    Behavior on border.color{
        ColorAnimation { from: addWorkArea.border.color; duration: 3*parametersManager.animationsStep }
    }


    MouseArea {
        id:addWorkareaMouseArea

        anchors.fill: parent
        hoverEnabled: true

        onEntered: {
            addWorkArea.color = addWorkArea.toColor;
            addWorkArea.border.color = addWorkArea.borderToColor;
        }

        onExited: {
            addWorkArea.color = addWorkArea.fromColor;
            addWorkArea.border.color = addWorkArea.borderFromColor;
        }

    }

    DToolTip{
        title:i18n("Add WorkArea")
        mainText: i18n("You can add a Workarea in order to sub-organize better your work.")
        target:addWorkareaMouseArea
        localIcon:addButtonImage.source
    }

}

