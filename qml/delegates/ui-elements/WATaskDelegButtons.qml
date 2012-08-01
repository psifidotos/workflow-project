// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import ".."

Item {
    id: buttonsArea
    width: mainWorkArea.imagewidth
    height: taskDeleg1.height
    state: "hide"

    property string status:"nothover"
    property int buttonsSize: 1.55*taskTitleRec.height
    property int buttonsSpace: -buttonsSize/8

    property alias opacityClose: closeBtn.opacity
    property alias xClose: closeBtn.x
    property alias opacityWSt:  placeStateBtn.opacity
    property alias xWSt:  placeStateBtn.x

    signal changedStatus();

    CloseWindowButton{
        id:closeBtn

        width: parent.buttonsSize
        height: width
        x: buttonsArea.width - buttonsSize

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onEntered: {
                closeBtn.onEntered();
                buttonsArea.state = "show";
                buttonsArea.status = "hover";
                buttonsArea.changedStatus();
            }

            onExited: {
                closeBtn.onExited();
                buttonsArea.state = "hide";
                buttonsArea.status = "nothoverred";
                buttonsArea.changedStatus();
            }

            onReleased: {
                closeBtn.onReleased();
            }

            onPressed: {
                closeBtn.onPressed();
            }

            onClicked: {
                closeBtn.onClicked();
                instanceOfTasksList.removeTask(taskDeleg1.ccode);
            }

        }

    }


    WindowPlaceButton{
        id: placeStateBtn

        width: parent.buttonsSize
        height: width
        x: buttonsArea.width - 2*buttonsSize - buttonsSpace

        allDesks: onAllDesktops || 0 ? true : false
        allActiv: onAllActivities || 0 ? true : false

        function informState(){

            if (placeStateBtn.state === "one")
                instanceOfTasksList.setTaskState(taskDeleg1.ccode,"oneDesktop");
            else if (placeStateBtn.state === "allDesktops")
                instanceOfTasksList.setTaskState(taskDeleg1.ccode,"allDesktops");
            else if (placeStateBtn.state === "everywhere")
                instanceOfTasksList.setTaskState(taskDeleg1.ccode,"allActivities");
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            z:4

            onEntered: {
                placeStateBtn.onEntered();
                buttonsArea.state = "show";
                buttonsArea.status = "hover";
                buttonsArea.changedStatus();
            }

            onExited: {
                placeStateBtn.onExited();
                buttonsArea.state = "hide";
                buttonsArea.status = "nothoverred";
                buttonsArea.changedStatus();
            }

            onPressAndHold:{
                if (placeStateBtn.state === "allDesktops"){
                    instanceOfTasksList.setTaskDesktop(taskDeleg1.ccode,desktop+1);
                    placeStateBtn.previousState();
                    placeStateBtn.informState();
                }

            }

            onClicked: {
                placeStateBtn.onClicked();
                placeStateBtn.nextState();
                placeStateBtn.informState();

                if (placeStateBtn.state === "everywhere"){
                    if(mainView.animationsStep2!==0){
                        var x1 = imageTask.x;
                        var y1 = imageTask.y;

                        mainView.getDynLib().animateDesktopToEverywhere(code,imageTask.mapToItem(mainView,x1, y1),1);
                    }
                }

            }

            onReleased: {
                placeStateBtn.onReleased();
            }

            onPressed: {
                placeStateBtn.onPressed();
            }


        }

    }


    states: [
        State {
            name: "show"

            PropertyChanges {
                target: buttonsArea

                opacityClose: 1
                //      xClose: width - buttonsSize
                opacityWSt: 1
                //      xWSt: width - 2*buttonsSize - buttonsSpace
            }
        },
        State {
            name: "hide"
            PropertyChanges {
                target: buttonsArea

                opacityClose: 0
                //   xClose: 0
                opacityWSt: 0
                //  xWSt: 0

            }
        }
    ]

    transitions: [

        Transition {
            from:"hide"; to:"show"
            reversible: false
            SequentialAnimation{
                ParallelAnimation{
                    NumberAnimation {
                        target: buttonsArea;
                        property: "opacityClose";
                        duration: mainView.animationsStep;
                        easing.type: Easing.InOutQuad;
                    }
                }

                ParallelAnimation{
                    NumberAnimation {
                        target: buttonsArea;
                        property: "opacityWSt";
                        duration: mainView.animationsStep;
                        easing.type: Easing.InOutQuad;
                    }
                }

            }
        },
        Transition {
            from:"show"; to:"hide"
            reversible: false
            SequentialAnimation{
                ParallelAnimation{
                    NumberAnimation {
                        target: buttonsArea;
                        property: "opacityClose";
                        duration: mainView.animationsStep;
                        easing.type: Easing.InOutQuad;
                    }
                }

                ParallelAnimation{
                    NumberAnimation {
                        target: buttonsArea;
                        property: "opacityWSt";
                        duration: mainView.animationsStep;
                        easing.type: Easing.InOutQuad;
                    }
                }

            }
        }

    ]

}
