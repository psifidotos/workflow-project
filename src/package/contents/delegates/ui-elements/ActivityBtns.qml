// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.qtextracomponents 0.1
import "../../tooltips"

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
            icon: instanceOfThemeList.icons.AddWidget
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
                id:addWidgetsBtnMouseArea
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
                    instanceOfActivitiesList.showWidgetsExplorer(ccode);
                }

            }
        }

        DToolTip{
            title:i18n("Add Plasmoids")
            mainText: i18n("Add Plasmoids to your Activity in order to customize it more.")
            target:addWidgetsBtnMouseArea
           // masterMouseArea:addWidgetsMouseArea
            icon:instanceOfThemeList.icons.AddWidget
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
                icon: instanceOfThemeList.icons.PauseActivity
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
                    id:stopActivityBtnMouseArea
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

            DToolTip{
                title:i18n("Pause Activity")
                mainText: i18n("You can pause an Activity and place it on the right panel.This way the Activity will be always available to continue your work from where you stopped.")
                target:stopActivityBtnMouseArea
                //masterMouseArea:stopActivityBtnMouseArea
                icon:instanceOfThemeList.icons.PauseActivity
            }

            // Image{
            QIconItem{
                id:duplicateActivityBtn

                //   source:"../../Images/buttons/cloneActivity.png"

                icon:instanceOfThemeList.icons.CloneActivity
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
                    id:duplicateActivityBtnMouseArea
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

            DToolTip{
                title:i18n("Clone Activity")
                mainText: i18n("You can clone an Activity.")
                target:duplicateActivityBtnMouseArea
                //masterMouseArea:duplicateActivityBtnMouseArea
                icon:instanceOfThemeList.icons.CloneActivity
            }

            QIconItem{
                id:deleteActivityBtn
                icon: instanceOfThemeList.icons.DeleteActivity
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
                    id:deleteActivityBtnMouseArea
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

                DToolTip{
                    title:i18n("Delete Activity")
                    mainText: i18n("You can delete an Activity. Be careful, this action can not be undone.")
                    target:deleteActivityBtnMouseArea
                    //masterMouseArea:deleteActivityBtnMouseArea
                    icon:instanceOfThemeList.icons.DeleteActivity
                }

            }
        }

        QIconItem{
            id:stopActLockedBtn
            opacity:1
            icon: instanceOfThemeList.icons.PauseActivity
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
                id:stopActLockedBtnMouseArea
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

        DToolTip{
            title:i18n("Stop Activity")
            mainText: i18n("You can stop an Activity and place it on the right panel")
            target:stopActLockedBtnMouseArea
            //masterMouseArea:stopActLockedBtnMouseArea
            icon:instanceOfThemeList.icons.PauseActivity
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

