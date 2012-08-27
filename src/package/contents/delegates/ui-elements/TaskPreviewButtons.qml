// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import "../../tooltips"
Item {
    id: buttonsArea
    width: buttonsSize
    height: taskDeleg2.height

    state: "hide"

    property string status:"nothover"

    signal changedStatus();

    property alias opacityClose: closeBtn.opacity
    property alias yClose: closeBtn.y
    property alias opacityWSt:  placeStateBtn.opacity
    property alias yWSt:  placeStateBtn.y

    property int buttonsSize
    property int buttonsSpace: -buttonsSize/8


    CloseWindowButton{
        id:closeBtn

        width: parent.buttonsSize
        height: width
        y:0

        MouseArea {
            id:closeBtnMouseArea
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

        DToolTip{
            title:i18n("Close Window")
            mainText: i18n("You can close this window if you want to.")
            target:closeBtnMouseArea
            //icon:instanceOfThemeList.icons.RunActivity
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
            if (placeStateBtn.state === "one"){
                instanceOfTasksList.setTaskState(taskDeleg2.ccode,"oneDesktop");
                if(taskDeleg2.dialogType === taskDeleg2.dTypes[1])
                    instanceOfTasksList.setTaskDesktopForAnimation(taskDeleg2.ccode,taskDeleg2.centralListView.desktopInd);
            }
            else if (placeStateBtn.state === "allDesktops")
                instanceOfTasksList.setTaskState(taskDeleg2.ccode,"allDesktops");
            else if (placeStateBtn.state === "everywhere")
                instanceOfTasksList.setTaskState(taskDeleg2.ccode,"allActivities");
        }

        MouseArea {
            id:placeStateBtnMouseArea
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

            onPressAndHold:{
                //if (placeStateBtn.state === "allDesktops"){
            //    toAllDesktopsAnimation();
               // if(taskDeleg2.centralListView === desktopDialog.getTasksList())

                placeStateBtn.previousState();
                placeStateBtn.informState();
                //    }
                //  }

                toDesktopAnimation();

            }

            onClicked: {
                //Animation must start before changing state
                toAllDesktopsAnimation();

                placeStateBtn.onClicked();
                placeStateBtn.nextState();
                placeStateBtn.informState();

                toDesktopAnimation();

            }

            function toDesktopAnimation(){
                if (placeStateBtn.state !== "everywhere"){
                    if(mainView.animationsStep2!==0){
                        var x1 = imageTask2.x;
                        var y1 = imageTask2.y;

                        mainView.getDynLib().animateEverywhereToActivity(code,imageTask2.mapToItem(mainView,x1, y1),1);
                    }
                }
            }

            function toAllDesktopsAnimation(){
                if (placeStateBtn.state === "allDesktops"){
                    if(mainView.animationsStep2!==0){
                        var x3 = imageTask2.x;
                        var y3 = imageTask2.y;

                        mainView.getDynLib().animateDesktopToEverywhere(code,imageTask2.mapToItem(mainView,x3, y3),1);
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

        DToolTip{
            title:i18n("Change Window State")
            mainText: i18n("You can change the window's state, there are three states available:<br/><br/>1.<b>\"Single\"</b>, is shown only on that Workarea<br/><br/>2.<b>\"All WorkAreas\"</b>, is shown on every WorkArea in that Activity<br/><br/>3.<b>\"Everywhere\"</b>, is shown on all WorkAreas.")
            target:placeStateBtnMouseArea
            //icon:instanceOfThemeList.icons.RunActivity
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
