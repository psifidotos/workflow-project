// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import "../code/settings.js" as Settings
import org.kde.plasma.core 0.1 as PlasmaCore

Rectangle{
    id: addActivityBtn

    property bool showRedCross: ((stoppedPanel.shownActivities > 0)&&(stoppedPanel.doNotShow===false))

    width: showRedCross===true ? stoppedPanel.width : stoppedPanel.width /2
    height: showRedCross===true ? allWorkareas.actImagHeight : allWorkareas.actImagHeight / 2

    property int marginRight: showRedCross ? 0 : 7
    x:mainView.width - width - marginRight
    color: "#00ffffff"

    y:oxygenT.height+1

    opacity: (Settings.global.lockActivities===true) ? 0 : 1

    property color openStpActiv1: "#66333333"
    property color openStpActiv2: "transparent"
    property color closStpActiv1: "#66333333"
    property color closStpActiv2: "#66333333"

    property color currentColor1: showRedCross===true ? openStpActiv1 : closStpActiv1
    property color currentColor2: showRedCross===true ? openStpActiv2 : closStpActiv2

    border.color: showRedCross ? "#00000000" : allWorkareas.actImagBordColor
    border.width: showRedCross ? 0 : 1


    ///Left Shadow for Main Add Activity Button
    Rectangle{
        id:stpActShad
        height: workareaWidth/50
        width: parent.height+2
        //   anchors.right: stopActBack.left
        rotation: 90
        transformOrigin: Item.TopLeft
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#770f0f0f" }
            GradientStop { position: 1.0; color: "#00797979" }
        }
    }

    Rectangle{
        id:backgroundRectangle
        width: parent.width
        height: parent.height
        opacity: Settings.global.disableBackground ? 0.1 : 1
        color: Settings.global.disableBackground ?  theme.textColor : "#ebebeb"
    }

    Rectangle{
        id:leftBorderRectangle
        width:1
        height:parent.height
        anchors.left: parent.left
        color: "#d9808080"
        opacity: Settings.global.disableBackground ? 1 : 0
    }

    Rectangle{
        id:shadowsUpDown
        width:parent.width
        height:parent.height
        //visible:false
        //color:"#00ffffff"
        //visible: Settings.global.disableBackground ? false : true

        gradient: Gradient {
            GradientStop { position: 0.0; color: addActivityBtn.currentColor1  }
            GradientStop { position: 0.15; color: addActivityBtn.currentColor2 }
            GradientStop { position: 0.85; color: addActivityBtn.currentColor2 }
            GradientStop { position: 1.0; color: addActivityBtn.currentColor1 }
        }
    }

    Behavior on x{
        NumberAnimation {
            duration: 2*Settings.global.animationStep;
            easing.type: Easing.InOutQuad;
        }
    }

    Behavior on width{
        NumberAnimation {
            duration: stoppedPanel.shownActivities > 0 ? 0 : 400
            easing.type: Easing.InOutQuad;
        }
    }

    Behavior on currentColor1{
        ColorAnimation {
            duration: 2*Settings.global.animationStep;
            easing.type: Easing.InOutQuad;
        }
    }
    Behavior on currentColor2{
        ColorAnimation {
            duration: 2*Settings.global.animationStep;
            easing.type: Easing.InOutQuad;
        }
    }

    Behavior on opacity{
        NumberAnimation {
            duration: 2*Settings.global.animationStep;
            easing.type: Easing.InOutQuad;
        }
    }

    Image{
        id:plusIcon
        opacity:0.7
        anchors.centerIn: addActivityBtn
        width: addActivityBtn.showRedCross===true ? addActivityBtn.width/5 : addActivityBtn.height/2
        height:width
        source:addActivityBtn.showRedCross===true ? "Images/buttons/addActivity1.png" : "Images/buttons/addActivity2.png"

        Behavior on opacity{
            NumberAnimation {
                duration: 2*Settings.global.animationStep
                easing.type: Easing.InOutQuad;
            }
        }

        Behavior on scale{
            NumberAnimation {
                duration: 2*Settings.global.animationStep;
                easing.type: Easing.InOutQuad;
            }
        }
    }

    Rectangle{
        id:addActShad1
        anchors.top: addActivityBtn.top
        //y:actImag1.height
        width: addActivityBtn.width
        height: workareaY/6
        opacity: (addActivityBtn.showRedCross && !Settings.global.disableBackground)? 1:0
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#aa0f0f0f" }
            GradientStop { position: 1.0; color: "#00797979" }
        }
    }

    MouseArea {
        id:addActivityMouseArea
        anchors.fill: parent
        hoverEnabled: true

        onEntered: {
            plusIcon.opacity = 1;
            plusIcon.scale = 1.2;
        }

        onExited: {
            plusIcon.opacity = 0.7;
            plusIcon.scale = 1;
        }

        onClicked: {
            workflowManager.activityManager().add(i18n("New Activity"));
        }

    }

    PlasmaCore.ToolTip{
        mainText: i18n("Add Activity")
        subText: i18n("Add an Activity with default settings.")
        target: addActivityMouseArea
        //image: plusIcon.source
    }
}

