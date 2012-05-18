// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import "../ui"

Item {
    id: buttonsArea
    width: mainWorkArea.imagewidth
    height: taskDeleg1.height
    state: "hide"

    //y: -height/5

    property alias opacityClose: closeBtn.opacity
    property alias xClose: closeBtn.x
    property alias opacityWSt:  placeStateBtn.opacity
    property alias xWSt:  placeStateBtn.x

    property int buttonsSize: 1.7*taskTitleRec.height
    property int buttonsSpace: -buttonsSize/8


    CloseWindowButton{
        id:closeBtn

        width: parent.buttonsSize
        height: width

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onEntered: {
                closeBtn.onEntered();
                buttonsArea.state = "show"
            }

            onExited: {
                closeBtn.onExited();
                buttonsArea.state = "hide"
            }

            onReleased: {
                closeBtn.onReleased();
            }

            onPressed: {
                closeBtn.onPressed();
            }

            onClicked: {
                closeBtn.onClicked();
                instanceOfTasksList.removeTask(code);
            }

        }

    }


    WindowPlaceButton{
        id: placeStateBtn

        width: parent.buttonsSize
        height: width

        allDesks: onAllDesktops
        allActiv: onAllActivities

        function informState(){

            if (placeStateBtn.state == "one")
                instanceOfTasksList.setTaskState(code,"oneDesktop");
            else if (placeStateBtn.state == "allDesktops")
                instanceOfTasksList.setTaskState(code,"allDesktops");
            else if (placeStateBtn.state == "everywhere")
                instanceOfTasksList.setTaskState(code,"allActivities");
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            z:4

            onEntered: {
                placeStateBtn.onEntered();
                buttonsArea.state = "show";
            }

            onExited: {
                placeStateBtn.onExited();
                buttonsArea.state = "hide";
            }

            onClicked: {
                placeStateBtn.onClicked();
                placeStateBtn.nextState();
                placeStateBtn.informState();
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
                xClose: width - buttonsSize
                opacityWSt: 1
                xWSt: width - 2*buttonsSize - buttonsSpace
            }
        },
       State {
           name: "hide"
           PropertyChanges {
               target: buttonsArea

               opacityClose: 0
               xClose: 0
               opacityWSt: 0
               xWSt: 0

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
                        property: "xClose";
                        duration: 300;
                        easing.type: Easing.InOutQuad;
                    }
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
                        property: "xWSt";
                        duration: 300;
                        easing.type: Easing.InOutQuad;
                    }
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
