// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import org.kde.plasma.core 0.1 as PlasmaCore

import ".."
import "../../tooltips"

Item {
    id: buttonsArea
    width: mainWorkArea.imagewidth-buttonsSize/4
    height: taskDeleg1.height
    state: "hide"

    // property string status:"nothover"
    property int buttonsSize: 1.55*taskTitleRec.height
    property int buttonsSpace: -buttonsSize/8

    property alias opacityClose: closeBtn.opacity
    property alias xClose: closeBtn.x
    property alias opacityWSt:  placeStateBtn.opacity
    property alias xWSt:  placeStateBtn.x

    y:-buttonsSize/6

    property bool containsMouse: closeBtn.containsMouse ||
                                 placeStateBtn.containsMouse

    property bool shown:containsMouse || taskDeleg1.containsMouse

    CloseWindowButton{
        id:closeBtn

        width: parent.buttonsSize
        height: width
        x: buttonsArea.width - buttonsSize

        tooltipTitle: i18n("Close Window")
        tooltipText: ("You can close this window if you want to.")

        onClicked: {
            taskManager.removeTask(taskDeleg1.ccode);
        }

    }


    WindowPlaceButton{
        id: placeStateBtn

        width: parent.buttonsSize
        height: width
        x: buttonsArea.width - 2*buttonsSize - buttonsSpace

        allDesks: onAllDesktops || 0 ? true : false
        allActiv: onAllActivities || 0 ? true : false

        tooltipTitle: i18n("Change Window State")
        tooltipText: i18n("You can change the window's state, there are three states available:<br/><br/>1.<b>\"Single\"</b>, is shown only on that Workarea<br/><br/>2.<b>\"All WorkAreas\"</b>, is shown on every WorkArea in that Activity<br/><br/>3.<b>\"Everywhere\"</b>, is shown on all WorkAreas.")

        onPressAndHold: {
            placeStateBtn.previousState();
            placeStateBtn.informState();
            taskManager.setTaskDesktop(taskDeleg1.ccode,desktop+1);
            toEveryWhereAnimation();
        }

        onClicked: {
            placeStateBtn.nextState();
            placeStateBtn.informState();

            toEveryWhereAnimation();
        }


        function toEveryWhereAnimation(){
            if (placeStateBtn.state === "everywhere"){
                if(storedParameters.animationsStep2!==0){
                    var x1 = imageTask.x;
                    var y1 = imageTask.y;

                    mainView.getDynLib().animateDesktopToEverywhere(code,imageTask.mapToItem(mainView,x1, y1),1);
                }
            }
        }


        function informState(){

            if (placeStateBtn.state === "one"){
                taskManager.setTaskState(taskDeleg1.ccode,"oneDesktop");
                taskManager.setTaskDesktopForAnimation(taskDeleg1.ccode,mainWorkArea.desktop-1)
            }
            else if (placeStateBtn.state === "allDesktops")
                taskManager.setTaskState(taskDeleg1.ccode,"allDesktops");
            else if (placeStateBtn.state === "everywhere")
                taskManager.setTaskState(taskDeleg1.ccode,"allActivities");
        }

    }




    states: [
        State {
            name: "show"
            when: shown

            PropertyChanges {
                target: buttonsArea
                opacityClose: 1
                opacityWSt: 1
            }
        },
        State {
            name: "hide"
            when: !shown
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
                        duration: storedParameters.animationsStep;
                        easing.type: Easing.InOutQuad;
                    }
                }

                ParallelAnimation{
                    NumberAnimation {
                        target: buttonsArea;
                        property: "opacityWSt";
                        duration: storedParameters.animationsStep;
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
                        duration: storedParameters.animationsStep;
                        easing.type: Easing.InOutQuad;
                    }
                }

                ParallelAnimation{
                    NumberAnimation {
                        target: buttonsArea;
                        property: "opacityWSt";
                        duration: storedParameters.animationsStep;
                        easing.type: Easing.InOutQuad;
                    }
                }

            }
        }

    ]

}
