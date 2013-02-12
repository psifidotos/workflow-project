// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import "../../../code/settings.js" as Settings

Item {
    id: buttonsArea
    width: buttonsSize
    height: taskDeleg2.height

    state: "hide"

    property bool containsMouse: (closeBtn.containsMouse || placeStateBtn.containsMouse)

    property alias opacityClose: closeBtn.opacity
    property alias yClose: closeBtn.y
    property alias opacityWSt:  placeStateBtn.opacity
    property alias yWSt:  placeStateBtn.y

    property alias windowState: placeStateBtn.state

    property int buttonsSize
    property int buttonsSpace: -buttonsSize/8

    signal informStateClicked;

    CloseWindowButton{
        id:closeBtn

        width: parent.buttonsSize
        height: width
        y:0

        tooltipTitle: i18n("Close Window")
        tooltipText: i18n("Close this window.")

        onClicked: {
            taskManager.removeTask(taskDeleg2.ccode);
        }
    }

    WindowPlaceButton{
        id: placeStateBtn
        width: parent.buttonsSize
        height: width
        y:buttonsSize + buttonsSpace

        allDesks: onAllDesktops || 0 ? true : false
        allActiv: onAllActivities || 0 ? true : false

        onPressAndHold:{
            placeStateBtn.previousState();
            informStateClicked();
            //placeStateBtn.informState();

            toDesktopAnimation();
        }

        onClicked: {
            placeStateBtn.nextState();
            informStateClicked();
            //placeStateBtn.informState();

            toDesktopAnimation();
        }

        function informState(){
            taskManager.setTaskState(taskDeleg2.ccode, state, taskDeleg2.dialogActivity, taskDeleg2.dialogDesktop);
        }

        function toDesktopAnimation(){
            if (state !== "allActivities"){
                if(Settings.global.animationStep2!==0){
                    var x1 = imageTask2.x;
                    var y1 = imageTask2.y;

                    mainView.getDynLib().animateEverywhereToActivity(taskDeleg2.ccode,imageTask2.mapToItem(mainView,x1, y1),1);
                }
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
            reversible: false

            SequentialAnimation{

                ParallelAnimation{
                    NumberAnimation {
                        target: buttonsArea;
                        property: "opacityClose";
                        duration: Settings.global.animationStep;
                        easing.type: Easing.InOutQuad;

                    }

                }

                ParallelAnimation{
                    NumberAnimation {
                        target: buttonsArea;
                        property: "opacityWSt";
                        duration: Settings.global.animationStep;
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
                        duration: Settings.global.animationStep;
                        easing.type: Easing.InOutQuad;

                    }

                }

                ParallelAnimation{
                    NumberAnimation {
                        target: buttonsArea;
                        property: "opacityWSt";
                        duration: Settings.global.animationStep;
                        easing.type: Easing.InOutQuad;
                    }
                }

            }
        }
    ]

}
