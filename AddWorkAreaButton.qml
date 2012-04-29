import QtQuick 1.0

Rectangle{

    width:60+3*mainView.scaleMeter

    height:40
    color: fromColor
    property color fromColor:"#00c9c9c9"
    property color toColor:"#ffc9c9c9"
    property color borderFromColor:"#00686868"
    property color borderToColor:"#ff686868"

    border.color: borderFromColor
    border.width: 1
    radius: 6
    z:6

    Rectangle{
        width:20
        height:20
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        color:"transparent"

        Image {
            id:addButtonImage
            source:"Images/addWorkAreaBtn.png"
            width:parent.width
            height:parent.height

        }

    }

    Behavior on color{
        ColorAnimation { from: addWorkArea.color; duration: 500 }
    }
    Behavior on border.color{
        ColorAnimation { from: addWorkArea.border.color; duration: 500 }
    }


    MouseArea {
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

}

