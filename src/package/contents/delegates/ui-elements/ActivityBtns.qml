// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.qtextracomponents 0.1

Item{
    id: activityButtons

    property int buttonsSize:0.5 * mainView.scaleMeter
    property int buttonsSpace:mainView.scaleMeter / 10
    //   property int buttonsX:mainView.scaleMeter / 3.5
    // property int buttonsY:mainView.scaleMeter / 10

    //    property alias opacityDel : deleteActivityBtn.opacity
    //    property alias opacityDup : duplicateActivityBtn.opacity
    //    property alias opacityStop : stopActivityBtn.opacity
    //    property alias opacityAddWidget : addWidgetsBtn.opacity




    state: "hide"

    property real curBtnScale:1.3


    Rectangle{
        id:fRect
        width:1.5*addWidgetsBtn.width
        height:1.5*addWidgetsBtn.height
        radius:3

        x:buttonsSize/2
        anchors.top: parent.top

        border.color: mainView.currentActivity !== ccode ? "#404040" : "#333333"
        border.width:  1
        color: mainView.currentActivity !== ccode ? "#222222" : "#0a0a0a"


        QIconItem{
            id:addWidgetsBtn
            icon: QIcon("add")
            width: buttonsSize
            height: buttonsSize
            anchors.centerIn: parent


            smooth:true

            Behavior on scale{
                NumberAnimation {
                    duration: mainView.animationsStep;
                    easing.type: Easing.InOutQuad;
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onEntered: {
                    activityButtons.state = "show";
                    addWidgetsBtn.scale = curBtnScale;
                }

                onExited: {
                    activityButtons.state = "hide";
                    addWidgetsBtn.scale = 1;
                }

                onClicked: {

                }

            }
        }
    }

    Rectangle{
        id:sRect

        radius:3

        anchors.right: parent.right
        anchors.rightMargin:0.5*buttonsSize
        anchors.top: parent.top

        border.color: mainView.currentActivity !== ccode ? "#404040" : "#333333"
        border.width:  1
        color: mainView.currentActivity !== ccode ? "#222222" : "#0a0a0a"


        Row{
            id:rightActions
            spacing:buttonsSpace
            anchors.centerIn: parent

            QIconItem{
                id:stopActivityBtn
                icon: QIcon("player_stop")
                width: buttonsSize
                height: buttonsSize

                smooth:true

                Behavior on scale{
                    NumberAnimation {
                        duration: mainView.animationsStep;
                        easing.type: Easing.InOutQuad;
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true

                    onEntered: {
                        activityButtons.state = "show";
                        stopActivityBtn.scale = curBtnScale;
                    }

                    onExited: {
                        activityButtons.state = "hide";
                        stopActivityBtn.scale = 1;
                    }

                    onClicked: {
                        activityButtons.clickedStopped();
                    }

                }
            }

            // Image{
            QIconItem{
                id:duplicateActivityBtn

                //   source:"../../Images/buttons/cloneActivity.png"

                icon:QIcon("tab-duplicate")
                width: buttonsSize
                height: buttonsSize
                smooth:true

                Behavior on scale{
                    NumberAnimation {
                        duration: mainView.animationsStep;
                        easing.type: Easing.InOutQuad;
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true

                    onEntered: {
                        activityButtons.state = "show";
                        duplicateActivityBtn.scale = curBtnScale;
                    }

                    onExited: {
                        activityButtons.state = "hide";
                        duplicateActivityBtn.scale = 1;
                    }

                    onClicked: {
                        instanceOfActivitiesList.cloneActivityDialog(ccode);
                    }


                }
            }

            QIconItem{
                id:deleteActivityBtn
                icon: QIcon("editdelete")
                width: buttonsSize
                height: buttonsSize
                //     x:2*buttonsSize+2*buttonsSpace+buttonsX
                //    y:buttonsY

                smooth:true

                Behavior on scale{
                    NumberAnimation {
                        duration: mainView.animationsStep;
                        easing.type: Easing.InOutQuad;
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true

                    onEntered: {
                        activityButtons.state = "show";
                        deleteActivityBtn.scale = curBtnScale;
                    }

                    onExited: {
                        activityButtons.state = "hide";
                        deleteActivityBtn.scale = 1;
                    }

                    onClicked: {
                        instanceOfActivitiesList.removeActivityDialog(ccode);
                    }

                }

            }
        }

        QIconItem{
            id:stopActLockedBtn
            opacity:1
            icon: QIcon("player_stop")
            anchors.centerIn: parent


            width:1.2*buttonsSize
            height:width


            Behavior on scale{
                NumberAnimation {
                    duration: 2*mainView.animationsStep;
                    easing.type: Easing.InOutQuad;
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true


                onEntered: {
                    activityButtons.state = "show";
                    stopActLockedBtn.scale = curBtnScale;
                }

                onExited: {
                    activityButtons.state = "hide";
                    stopActLockedBtn.scale = 1;
                }

                onClicked: {
                    activityButtons.clickedStopped();
                }

            }

        }
    }

    states: [
        State {
            name: "show"

            PropertyChanges{
                target:activityButtons
                opacity: 1
            }

            PropertyChanges{
                target:deleteActivityBtn
                opacity: ((allwlists.activitiesShown>1)&&(!mainView.lockActivities)) ? 1 : 0
            }

            PropertyChanges{
                target:duplicateActivityBtn
                opacity: ((!mainView.lockActivities)||(allwlists.activitiesShown===1)) ? 1 : 0
            }

            PropertyChanges{
                target:stopActivityBtn
                opacity: ((allwlists.activitiesShown>1)&&(!mainView.lockActivities)) ? 1 : 0
            }
            PropertyChanges{
                target:addWidgetsBtn
                opacity: (!mainView.lockActivities) ? 1 :0
            }

            PropertyChanges {
                target: stopActLockedBtn
                opacity:((mainView.lockActivities)&&(allwlists.activitiesShown>1)) ? 1 : 0
            }

            PropertyChanges {
                target:fRect
                opacity:(!mainView.lockActivities) ? 1:0
            }

            PropertyChanges {
                target:sRect
                opacity:1
                width:((mainView.lockActivities)||(allwlists.activitiesShown===1))? 1.4*stopActLockedBtn.width : 1.25*rightActions.width
                height:((mainView.lockActivities)||(allwlists.activitiesShown===1))? 1.3*stopActLockedBtn.height : 1.5*rightActions.height
            }
        },
        State {
            name: "hide"


            PropertyChanges{
                target:activityButtons
                opacity: 0
            }

            PropertyChanges{
                target:deleteActivityBtn
                opacity: ((allwlists.activitiesShown>1)&&(!mainView.lockActivities)) ? 1 : 0
            }

            PropertyChanges{
                target:duplicateActivityBtn
                opacity: ((!mainView.lockActivities)||(allwlists.activitiesShown===1)) ? 1 : 0
            }

            PropertyChanges{
                target:stopActivityBtn
                opacity: ((allwlists.activitiesShown>1)&&(!mainView.lockActivities)) ? 1 : 0
            }
            PropertyChanges{
                target:addWidgetsBtn
                opacity: (!mainView.lockActivities) ? 1 :0
            }

            PropertyChanges {
                target: stopActLockedBtn
                opacity:((mainView.lockActivities)&&(allwlists.activitiesShown>1)) ? 1 : 0
            }

            PropertyChanges {
                target:fRect
                opacity:(!mainView.lockActivities) ? 1:0
            }

            PropertyChanges {
                target:sRect
                opacity:1
                width:((mainView.lockActivities)||(allwlists.activitiesShown===1))? 1.4*stopActLockedBtn.width : 1.25*rightActions.width
                height:((mainView.lockActivities)||(allwlists.activitiesShown===1))? 1.3*stopActLockedBtn.height : 1.5*rightActions.height
            }
/*
            PropertyChanges{
                target:deleteActivityBtn
                opacity: 0
            }
            PropertyChanges{
                target:duplicateActivityBtn
                opacity: 0
            }

            PropertyChanges{
                target:stopActivityBtn
                opacity: 0
            }
            PropertyChanges{
                target:addWidgetsBtn
                opacity: 0
            }

            PropertyChanges {
                target: stopActLockedBtn
                opacity: 0
            }

            PropertyChanges {
                target:fRect
                opacity:0
            }

            PropertyChanges {
                target:sRect
                opacity:0
                width:((mainView.lockActivities)||(allwlists.activitiesShown===1))? 1.4*stopActLockedBtn.width : 1.25*rightActions.width
                height:((mainView.lockActivities)||(allwlists.activitiesShown===1))? 1.3*stopActLockedBtn.height : 1.5*rightActions.height
            }*/
        }


    ]

    transitions: [

        Transition {
            from:"hide"; to:"show"
            reversible: false
            ParallelAnimation{

                NumberAnimation {
                    target: activityButtons;
                    property: "opacity";
                    duration: mainView.animationsStep;
                    easing.type: Easing.InOutQuad;
                }
            }
        },
        Transition {
            from:"show"; to:"hide"
            reversible: false
            ParallelAnimation{
                NumberAnimation {
                    target: activityButtons;
                    property: "opacity";
                    duration: mainView.animationsStep;
                    easing.type: Easing.InOutQuad;
                }
            }
        }
    ]


    function clickedStopped(){
        instanceOfActivitiesList.stopActivity(ccode);

        if(mainView.animationsStep2!==0){
            var x1 = activityIcon.x;
            var y1 = activityIcon.y;

            mainView.getDynLib().animateActiveToStop(ccode,activityIcon.mapToItem(mainView,x1, y1));
        }

    }
}

