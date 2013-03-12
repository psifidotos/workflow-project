// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.qtextracomponents 0.1

import "ui-elements"
import "../components"
import "../../code/settings.js" as Settings

Item{
    id:mainActivity
    property string neededState:"Running"
    property string typeId : "RunningActivityDelegate"

    property string ccode:code
    property string tCState: CState
    property string activityName: Name

    opacity: CState === neededState ? 1 : 0

    property int defWidth: CState === neededState ? mainView.workareaWidth : 0
    property color activeBackColor: "#ff444444"
    property color actUsedColor: ccode===sessionParameters.currentActivity? activeBackColor:actImag1.color

    width: defWidth
    height:actImag1.height

    property bool shown: CState === neededState

    property bool activityDragged2: (draggingActivities.activityId === code) &&
                                   (draggingActivities.activityStatus === "Running")

    property bool activityDragged: false

    Behavior on opacity{
        NumberAnimation {
            duration: 2*Settings.global.animationStep;
            easing.type: Easing.InOutQuad;
        }
    }

    Behavior on width{
        NumberAnimation {
            duration: 2*Settings.global.animationStep;
            easing.type: Easing.InOutQuad;
        }
    }

    MouseArea{
        id: globalMouseArea
        anchors.fill: parent
        hoverEnabled: true
    }

    Rectangle{
        y:-activitiesList.y+actImag1.height-1

        height:parent.width
        width:actImag1.height - 2

        rotation: -90
        transformOrigin: Item.TopLeft

        gradient: Gradient {
            GradientStop { position: 0; color:actImag1.color }
            GradientStop { position: 0.03; color: mainActivity.activeBackColor }
            GradientStop { position: 0.97; color: mainActivity.activeBackColor }
            GradientStop { position: 1.0; color: actImag1.color }
        }

        opacity:((ccode === sessionParameters.currentActivity)&&(!activityDragged))
    }

    Rectangle{
        id:draggingRectangle
        anchors.horizontalCenter: parent.horizontalCenter
        width:parent.width - 10
        height:parent.height - 10
        radius:10
        color: "#333333"
        opacity:activityDragged2 ? 0.5 : 0
    }

    QIconItem{
        id:activityIcon
        //rotation: 0
        opacity: ((CState===neededState)&&(!activityDragged))

        icon: Icon === "" ? QIcon("plasma") : QIcon(Icon)

        anchors.bottom:parent.bottom
        anchors.bottomMargin: 3
        anchors.left: parent.left
        anchors.leftMargin: 8

        width: 5+mainView.scaleMeter
        height:width
        smooth:true

        rotation: (activityIconMouseArea.containsMouse &&
                   (!activityName.focused)&&
                   (!Settings.global.lockActivities)) ? -20 : 0

        //for the animation to be precise
        property int toRX:x - width/2
        property int toRY:y - height/2

        Behavior on rotation{
            NumberAnimation {
                duration: Settings.global.animationStep;
                easing.type: Easing.InOutQuad;
            }
        }

        DraggingMouseArea{
            id:activityIconMouseArea
            anchors.fill: parent

            draggingInterface: draggingActivities

            onClickedOverrideSignal: {
                if(!inDragging){
                    if (!Settings.global.lockActivities)
                        workflowManager.activityManager().chooseIcon(ccode);
                    else{
                        workflowManager.activityManager().setCurrent(ccode);
                    }
                }
            }

            onDraggingStarted: {
                if(!Settings.global.lockActivities){
                    wasDragged = true;
                    var coords = mapToItem(mainView, mouse.x, mouse.y);
                    draggingActivities.enableDragging(mouse, coords, code, "Running", Icon);
                }
            }

        }

        PlasmaCore.ToolTip {
            target:activityIconMouseArea
            mainText: Settings.global.lockActivities === false ? i18n("Change Activity Icon"):i18n("Activity")
            subText:Settings.global.lockActivities === false ? i18n("Change your Activity Icon to recognize better your work."):
                                                               i18n("Enable this Activity by clicking on the Activity name or icon")
            image: Icon === "" ? "plasma" : Icon
        }

    }

    Rectangle{
        id:fadeIcon

        opacity: ((CState===neededState) &&
                  !activityDragged &&
                  activityIconMouseArea.containsMouse &&
                  !activityIconMouseArea.inDragging &&
                  !Settings.global.lockActivities) ? 1:0

        x:activityIcon.x+0.15*activityIcon.width
        y:activityIcon.y
        rotation: 90
        transformOrigin: Item.Center

        width:1.2*activityIcon.width
        height:0.8*activityIcon.height

        gradient: Gradient {
            GradientStop { position: 0.0; color: mainActivity.actUsedColor }
            GradientStop { position: 0.15; color: mainActivity.actUsedColor }
            GradientStop { position: 1.0; color: "#00000000" }
        }

        Behavior on opacity{
            NumberAnimation {
                duration:  Settings.global.animationStep;
                easing.type: Easing.InOutQuad;
            }
        }
    }

    DTextEdit{
        id:activityName
        text: Name

        //Workaround for a bug not changing the title when used with dbus
        property string activityName:Name
        onActivityNameChanged: {
                text = Name;
        }

        x:activityIcon.x+0.9*activityIcon.width

        width:mainActivity.width - 1.05*activityIcon.width
        height:mainActivity.height
        nHeight:height-10

        anchors.bottom: separatorLine.bottom
        anchors.bottomMargin: 1

        opacity: ((CState===neededState)&&(!activityDragged)) ? 1:0

        Connections{
            target:Settings.global
            onLockActivitiesChanged:{
                if (activityName.state === "active"){
                    activityName.textNotAccepted();
                }
            }
        }

        onTextAcceptedSignal: {
            workflowManager.activityManager().setName(mainActivity.ccode, finalText);
        }

        PlasmaCore.ToolTip {
            target:activityName.tooltipItem
            mainText: Settings.global.lockActivities === false ? i18n("Activity Name") : i18n("Activity")
            subText: Settings.global.lockActivities === false ? i18n("Edit the Activity name by clicking on it."):
                                                                i18n("Enable this Activity by clicking on the Activity name or icon")

            property string actIcon: Icon === "" ? "plasma" : Icon
            image: Settings.global.lockActivities ? actIcon : "im-status-message-edit"
        }

    }

    ActivityBtns{
        id:activityBtnsI

        width:parent.width
        height:mainView.scaleMeter - 15

        opacity: ((activityName.containsMouse ||
                   activityIconMouseArea.containsMouse ||
                   globalMouseArea.containsMouse ||
                   activityBtnsI.containsMouse)&&
                   (!activityDragged2)&&
                  (!activityName.focused))

/*        state: (editActivityNameMouseArea.containsMouse &&
                (activityName.state === "inactive") &&
                (!Settings.global.lockActivities) )*/

        z:40

        Behavior on opacity {
            NumberAnimation { duration: 2 * Settings.global.animationStep }
        }
    }

    Rectangle{
        id:separatorLine

        anchors.right:parent.right
        y:-activitiesList.y
        width:1
        height:actImag1.height - 1
        color:"#15222222"
        z:10
    }

    ListView.onAdd: ParallelAnimation {
        PropertyAction { target: mainActivity; property: "width"; value: 0 }
        PropertyAction { target: mainActivity; property: "opacity"; value: 0 }

        NumberAnimation { target: mainActivity; property: "width"; to: mainActivity.defWidth; duration: 2*Settings.global.animationStep; easing.type: Easing.InOutQuad }
        NumberAnimation { target: mainActivity; property: "opacity"; to: 1; duration: 2*Settings.global.animationStep; easing.type: Easing.InOutQuad }
    }

    ListView.onRemove: SequentialAnimation {
        PropertyAction { target: mainActivity; property: "ListView.delayRemove"; value: true }

        ParallelAnimation{
            NumberAnimation { target: mainActivity; property: "width"; to: 0; duration: 2*Settings.global.animationStep; easing.type: Easing.InOutQuad }
            NumberAnimation { target: mainActivity; property: "opacity"; to: 0; duration: 2*Settings.global.animationStep; easing.type: Easing.InOutQuad }
        }
        // Make sure delayRemove is set back to false so that the item can be destroyed
        PropertyAction { target: mainActivity; property: "ListView.delayRemove"; value: false }
    }


    function getCurrentIndex(){
        for(var i=0; ListView.view.model.count; ++i){
            var obj = ListView.view.model.get(i);
            if (obj.code === code)
                return i;
        }
        return -1;
    }

    function getIcon(){
        return activityIcon;
    }

   /* Connections{
        target:activitiesSignals
        onShowButtons:{
            if(CState === neededState)
                activityBtnsI.state="show";
        }

        onHideButtons:{
            if(CState === neededState)
                activityBtnsI.state="hide";

        }
    }*/


}

