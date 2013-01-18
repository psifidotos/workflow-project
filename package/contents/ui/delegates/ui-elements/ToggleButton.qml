// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import "../../../code/settings.js" as Settings

Item{
    id:togBtn

    height:width

    state:"inactive"

    property string status: state
    property real scaleSize: 1.1

    property string imgIconActive
    property string imgIconInActive

    property alias mainIconSource: mainIcon.source

    property alias mainIconWidth: mainIcon.width
    property alias mainIconHeight: mainIcon.height

    property int mainIconWidthActive: width
    property int mainIconHeightActive: height

    property int mainIconWidthInactive: width
    property int mainIconHeightInactive: height


    signal statusChanged


    Behavior on scale{
        NumberAnimation {
            duration: 3*Settings.global.animationStep;
            easing.type: Easing.InOutQuad;
        }
    }

    Image{
        id:mainIcon
        x:0
        y:0
        anchors.centerIn: parent
        width:parent.width
        height:parent.height
        smooth:true
    }



    states: [
        State {
            name: "active"
            PropertyChanges {
                target: togBtn
                mainIconSource: togBtn.imgIconActive
                width: mainIconWidthActive
                height: mainIconHeightActive
            }
        },
        State {
            name: "inactive"
            PropertyChanges {
                target: togBtn
                mainIconSource: togBtn.imgIconInActive
                width: mainIconWidthInactive
                height: mainIconHeightInactive
            }
        }
    ]

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onEntered: {
            togBtn.onEntered();
        }

        onExited: {
            togBtn.onExited();
        }

        onClicked: {
            togBtn.onClicked();
        }

    }

    function onEntered(){
        togBtn.scale = togBtn.scaleSize;
    }

    function onExited(){

        togBtn.scale = 1
    }

    function onClicked(){
        if (togBtn.state == "active")
            togBtn.state = "inactive";
        else
            togBtn.state = "active";

        togBtn.statusChanged();
    }

}

