// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle{
    id: addActivityBtn
    width: stoppedPanel.shownActivities > 0 ? stoppedPanel.width-1 : stoppedPanel.width /2
    height: stoppedPanel.shownActivities > 0 ? allWorkareas.actImagHeight : allWorkareas.actImagHeight / 2
    x:mainView.width - width

    anchors.top: stoppedPanel.top

    property color openStpActiv1: "#ebebeb"
    property color openStpActiv2: "#bdbdbd"
    property color closStpActiv1: "#77333333"
    property color closStpActiv2: "#77333333"

    property color currentColor1: stoppedPanel.shownActivities > 0 ? openStpActiv1 : closStpActiv1
    property color currentColor2: stoppedPanel.shownActivities > 0 ? openStpActiv2 : closStpActiv2

    border.color: stoppedPanel.shownActivities > 0 ? "#00000000" : allWorkareas.actImagBordColor
    border.width: stoppedPanel.shownActivities > 0 ? 0 : 1



    gradient: Gradient {
        GradientStop { position: 0.0; color: addActivityBtn.currentColor2  }
        GradientStop { position: 0.15; color: addActivityBtn.currentColor1 }
        GradientStop { position: 0.85; color: addActivityBtn.currentColor1 }
        GradientStop { position: 1.0; color: addActivityBtn.currentColor2  }
    }

    Behavior on x{
        NumberAnimation {
            duration: 400;
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
            duration: 400;
            easing.type: Easing.InOutQuad;
        }
    }
    Behavior on currentColor2{
        ColorAnimation {
            duration: 400;
            easing.type: Easing.InOutQuad;
        }
    }


    Image{
        id:plusIcon
        opacity:0.5
        anchors.centerIn: addActivityBtn
        width:stoppedPanel.shownActivities > 0 ? addActivityBtn.width/5 : addActivityBtn.height/2
        height:width
        source:stoppedPanel.shownActivities > 0 ? "Images/buttons/addActivity1.png" : "Images/buttons/addActivity2.png"

        Behavior on opacity{
            NumberAnimation {
                duration: 400
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
        opacity: stoppedPanel.shownActivities > 0 ? 1:0
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#aa0f0f0f" }
            GradientStop { position: 1.0; color: "#00797979" }
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onEntered: {
            plusIcon.opacity = 1;
        }

        onExited: {
            plusIcon.opacity = 0.5;
        }

        onClicked: {
            instanceOfActivitiesList.addNewActivity();
        }

    }
}

