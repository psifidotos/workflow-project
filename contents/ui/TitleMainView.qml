// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import "ui"

Rectangle{
    id:oxygenTitle
    anchors.top:parent.top
    width:mainView.width
    color:"#dcdcdc"
    height: workareaY/3

    Image{
        source:"Images/buttons/titleLight.png"
        clip:true
        width:parent.width
        height:parent.height
        smooth:true
        fillMode:Image.PreserveAspectCrop
    }


    Rectangle{
        id:mainRect
        anchors.top: oxygenTitle.bottom
        width:oxygenTitle.width
        height:oxygenTitle.height/2
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#aa0f0f0f" }
            GradientStop { position: 1.0; color: "#00797979" }
        }
    }

    Text{
        anchors.top:oxygenTitle.top
        anchors.horizontalCenter: oxygenTitle.horizontalCenter
        text:"Activities"
        font.family: "Helvetica"
        font.italic: true
        font.pointSize: 5+(mainView.scaleMeter) /10
        color:"#777777"
    }


    ToggleButton{
        id:lckBtn
        x:parent.height/2
        y:(oxygenTitle.height-height)/2

        height: 0.91 * oxygenTitle.height
        width: 0.95 * height

        state: mainView.lockActivities ? "active" : "inactive"

        mainIconWidthInactive: 0.95 * height
        mainIconHeightInactive: 0.91 * oxygenTitle.height

        mainIconWidthActive: 0.95 * height
        mainIconHeightActive: 0.91 * oxygenTitle.height

        imgIconActive: "../Images/buttons/plasma_ui/lockedIcon.png"
        imgIconInActive: "../Images/buttons/plasma_ui/unlockedIcon.png"

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onEntered: {
                lckBtn.onEntered();
            }

            onExited: {
                lckBtn.onExited();
            }

            onClicked: {
                lckBtn.onClicked();
                if (mainView.lockActivities === true)
                    mainView.lockActivities = false;
                else
                    mainView.lockActivities = true;
            }

        }
    }

    ToggleButton{
        id:shWinBtn
        x:lckBtn.x+1.5*lckBtn.width
        y:(1.1*oxygenTitle.height-height)/2

        width:1.6*height
        height:0.85*oxygenTitle.height

        mainIconWidthInactive: 1.6*height
        mainIconHeightInactive: 0.85*oxygenTitle.height

        mainIconWidthActive: 1.85*height
        mainIconHeightActive: 0.75*oxygenTitle.height

        imgIconActive: "../Images/buttons/withwindowsicon.png"
        imgIconInActive: "../Images/buttons/nowindowsicon.png"

        Component.onCompleted: {
            if (mainView.showWinds)
                shWinBtn.state = "active";
            else
                shWinBtn.state = "inactive";
        }

        Connections{
            target:shWinBtn
            onStatusChanged:{
                if (shWinBtn.status == "active")
                    mainView.showWinds = true;
                else
                    mainView.showWinds = false;
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onEntered: {
                shWinBtn.onEntered();
            }

            onExited: {
                shWinBtn.onExited();
            }

            onClicked: {
                shWinBtn.onClicked();
            }

        }
    }

}
