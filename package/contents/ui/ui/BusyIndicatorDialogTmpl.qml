// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import org.kde.plasma.components 0.1 as PlasmaComponents

import "../../code/settings.js" as Settings

Rectangle{

    id:busDialog

    width:mainView.width
    height:mainView.height

    color:"#aa222222"

    opacity:0
    visible: busyIndicator.running;

    Behavior on opacity{
        NumberAnimation {
            duration: 2*Settings.global.animationStep;
            easing.type: Easing.InOutQuad;
        }
    }

    MouseArea{
        anchors.fill: parent
        hoverEnabled: true
    }


    PlasmaComponents.BusyIndicator{
        id:busyIndicator
        width:0.25*parent.height
        height:width
        anchors.centerIn: parent
    }

    function startAnimation(){
        busDialog.opacity = 1;
        busyIndicator.running = true;
    }

    function resetAnimation(){
        busDialog.opacity = 0;
        busyIndicator.running = false;
    }

}
