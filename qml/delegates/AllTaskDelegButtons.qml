// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import "../ui"

Item {
    id: buttonsArea
    width: buttonsSize
    height: taskDeleg2.height

    state: "hide"

    x:imageTask2.x+0.75*imageTask2.width
    y:imageTask2.y-0.6*buttonsSize

    property string status:"nothover"

    signal changedStatus();

    //y: -height/5

    property alias opacityClose: closeBtn.opacity
    property alias yClose: closeBtn.y
    property alias opacityWSt:  placeStateBtn.opacity
    property alias yWSt:  placeStateBtn.y

    property int buttonsSize: 0.35*imageTask2.width
    property int buttonsSpace: -buttonsSize/8


    CloseWindowButton{
        id:closeBtn

        width: parent.buttonsSize
        height: width
        y:0

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onEntered: {
                closeBtn.onEntered();
                buttonsArea.state = "show"
                buttonsArea.status = "hover"
                changedStatus();
            }

            onExited: {
                closeBtn.onExited();
                buttonsArea.state = "hide"
                buttonsArea.status = "nothover"
                changedStatus();
            }

            onReleased: {
                closeBtn.onReleased();
            }

            onPressed: {
                closeBtn.onPressed();
            }

            onClicked: {
                closeBtn.onClicked();
                instanceOfTasksList.removeTask(taskDeleg2.ccode);
                allActT.changedChildState();
            }


        }

    }

    WindowPlaceButton{
        id: placeStateBtn

        width: parent.buttonsSize
        height: width
        y:buttonsSize + buttonsSpace

        allDesks: onAllDesktops || 0 ? true : false
        allActiv: onAllActivities || 0 ? true : false

        function informState(){
            if (placeStateBtn.state == "one")
                instanceOfTasksList.setTaskState(taskDeleg2.ccode,"oneDesktop");
            else if (placeStateBtn.state == "allDesktops")
                instanceOfTasksList.setTaskState(taskDeleg2.ccode,"allDesktops");
            else if (placeStateBtn.state == "everywhere")
                instanceOfTasksList.setTaskState(taskDeleg2.ccode,"allActivities");
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            z:4

            onEntered: {
                placeStateBtn.onEntered();
                buttonsArea.state = "show";
                buttonsArea.status = "hover"
                changedStatus();
            }

            onExited: {
                placeStateBtn.onExited();
                buttonsArea.state = "hide";
                buttonsArea.status = "nothover"
                changedStatus();
            }

            onClicked: {
                placeStateBtn.onClicked();
                placeStateBtn.nextState();
                placeStateBtn.informState();

                if (placeStateBtn !== "everywhere"){
                    var x1 = imageTask2.x;
                    var y1 = imageTask2.y;

                    mainView.getDynLib().animateEverywhereToActivity(code,imageTask2.mapToItem(mainView,x1, y1),1);
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
                opacityWSt: 1
            }
        },
       State {
           name: "hide"
           PropertyChanges {
               target: buttonsArea

               opacityClose: 0
               opacityWSt: 0
           }
        }
    ]

    transitions: [

        Transition {
            from:"hide"; to:"show"
            reversible: true
            SequentialAnimation{
                ParallelAnimation{
                    NumberAnimation {
                        target: buttonsArea;
                        property: "opacityClose";
                        duration: 300;
                        easing.type: Easing.InOutQuad;
                    }
                }

                ParallelAnimation{
                    NumberAnimation {
                        target: buttonsArea;
                        property: "opacityWSt";
                        duration: 300;
                        easing.type: Easing.InOutQuad;
                    }
                }

            }
        }
    ]

}
