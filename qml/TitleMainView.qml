// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import "ui"

import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.qtextracomponents 0.1

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
        text:""
        font.family: "Helvetica"
        font.italic: true
        font.pointSize: 5+(mainView.scaleMeter) /10
        color:"#777777"
    }

    /*  Image{
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
        text:""
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
*/

    Rectangle{
        x:lockerToolBtn.x+3
        y:lockerToolBtn.y
        radius:4
        width:lockerToolBtn.width-6
        height:lockerToolBtn.height-2
        border.width: 2
        border.color: "#cccccc"
        color:"#00ffffff"
        opacity:1
    }

    PlasmaComponents.ToolButton{
        id:lockerToolBtn
        x: 0.7 * oxygenTitle.height
        y:-4
        //iconSource:"plasma"
        //iconSource: QUrl("Images/buttons/plasma")
        Image{
            smooth:true
            source:"Images/buttons/Padlock-gold.png"
            anchors.centerIn: parent
            width:0.8*parent.height
            height:0.7*parent.height

        }

        width: 1.6 * oxygenTitle.height
        height:1.1 * oxygenTitle.height

        checkable:true
        checked:mainView.lockActivities


        onCheckedChanged:{
            mainView.lockActivities = checked;
        }
    }

    Rectangle{
        x:windowsToolBtn.x+3
        y:windowsToolBtn.y
        radius:4
        width:windowsToolBtn.width-6
        height:windowsToolBtn.height-2
        border.width: 2
        border.color: "#cccccc"
        color:"#00ffffff"
        opacity:1
    }

    PlasmaComponents.ToolButton{
        id:windowsToolBtn
        x:lockerToolBtn.x+1.1*lockerToolBtn.width
        y:-4
        //iconSource:"plasma"
        //iconSource: QUrl("Images/buttons/plasma")
        Image{
            smooth:true
            source:"Images/buttons/blueWindowsIcon.png"
            anchors.centerIn: parent
            width:0.80*parent.height
            height:0.68*parent.height

        }

        width: lockerToolBtn.width
        height: lockerToolBtn.height

        checkable:true
        checked:mainView.showWinds

        onCheckedChanged:{
            mainView.showWinds = checked;
        }
    }

    Rectangle{
        x:effectsToolBtn.x+3
        y:effectsToolBtn.y
        radius:4
        width:effectsToolBtn.width-6
        height:effectsToolBtn.height-2
        border.width: 2
        border.color: "#cccccc"
        color:"#00ffffff"
        opacity:1
        visible:mainView.isOnDashBoard
    }

    PlasmaComponents.ToolButton{
        id:effectsToolBtn
        x:windowsToolBtn.x+1.1*windowsToolBtn.width
        y:-4
        //iconSource:"plasma"
        //iconSource: QUrl("Images/buttons/plasma")
        Image{
            smooth:true
            source:"Images/buttons/tools_wizard.png"
            anchors.centerIn: parent
            width:0.80*parent.height
            height:0.65*parent.height

        }

        width: lockerToolBtn.width
        height: lockerToolBtn.height

        checkable:true
        checked:mainView.enablePreviews
        visible:mainView.isOnDashBoard

        onCheckedChanged:{
            mainView.enablePreviews = checked;
        }
    }

}
