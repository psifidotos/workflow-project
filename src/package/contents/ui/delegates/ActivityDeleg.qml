// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.qtextracomponents 0.1

import "ui-elements"
import "../tooltips"

//Component{

Item{
    id:mainActivity
    property string neededState:"Running"

    property string ccode:code
    property string tCState: CState

    opacity: CState === neededState ? 1 : 0

    property int defWidth: CState === neededState ? mainView.workareaWidth : 0
    property color activeBackColor: "#ff444444"

    property color actUsedColor: ccode===mainView.currentActivity? activeBackColor:actImag1.color

    width: defWidth
    //   height: mainView.workareaWidth / 3
    height:actImag1.height

    Behavior on opacity{
        NumberAnimation {
            duration: 2*mainView.animationsStep;
            easing.type: Easing.InOutQuad;
        }
    }

    Behavior on width{
        NumberAnimation {
            duration: 2*mainView.animationsStep;
            easing.type: Easing.InOutQuad;
        }
    }

    MouseArea{
        anchors.fill: parent
        hoverEnabled: true
        onEntered:{
            activityBtnsI.state="show";
        }

        onExited:{
            activityBtnsI.state="hide";

        }
    }



    Rectangle{

        y:-activitiesList.y+actImag1.height-1

        height:parent.width
        width:actImag1.height

        rotation: -90
        transformOrigin: Item.TopLeft


        gradient: Gradient {
            GradientStop { position: 0; color:actImag1.color }
            GradientStop { position: 0.03; color: mainActivity.activeBackColor }
            GradientStop { position: 0.97; color: mainActivity.activeBackColor }
            GradientStop { position: 1.0; color: actImag1.color }
        }

        opacity:ccode === mainView.currentActivity ? 1 : 0
    }

    QIconItem{
        id:activityIcon
        rotation:-20
        opacity: CState===neededState ? 1:0

        icon: Icon === "" ? QIcon("plasma") : QIcon(Icon)
        //x:mainView.scaleMeter/10
        //y:mainView.scaleMeter/3

        anchors.bottom:parent.bottom
        anchors.bottomMargin: 3

        width: 5+mainView.scaleMeter
        height:width
        smooth:true

        //for the animation to be precise
        property int toRX:x - width/2
        property int toRY:y - height/2

        Behavior on rotation{
            NumberAnimation {
                duration: mainView.animationsStep;
                easing.type: Easing.InOutQuad;
            }
        }

        MouseArea {
            id:activityIconMouseArea
            anchors.fill: parent
            hoverEnabled: true

            onEntered: {
                if((activityName.state === "inactive")&&
                   (!mainView.lockActivities)){
                    activityBtnsI.state="show";

                    fadeIcon.opacity = 0;
                    activityIcon.rotation = 0;

                }
                else{
                    activityBtnsI.state="hide";
                }

            }

            onExited: {
                activityBtnsI.state="hide";

                fadeIcon.opacity = 1;
                activityIcon.rotation = -20;
            }

            onClicked: {
                if (mainView.lockActivities === false)
                    instanceOfActivitiesList.chooseIcon(ccode);
                else
                    instanceOfActivitiesList.setCurrent(ccode);
            }




        }

        DToolTip{
           // visible:!mainView.lockActivities
            id:activityIconTooltip

            title:mainView.lockActivities === false ? i18n("Change Activity Icon"):i18n("Activity")
            mainText: mainView.lockActivities === false ? i18n("You can change your Activity Icon in order to recognize better your work."):
                                                          i18n("You can enable this Activity by clicking on the Activity name or icon")
            target:activityIconMouseArea
            icon:Icon === "" ? "plasma" : Icon
        }

    }

    Rectangle{
        id:fadeIcon

        opacity: CState===neededState ? 1:0

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
                duration:  mainView.animationsStep;
                easing.type: Easing.InOutQuad;
            }
        }
    }

    DTextEdit{
        id:activityName
        text: Name

        x:activityIcon.x+0.9*activityIcon.width

        width:mainActivity.width - 1.05*activityIcon.width
        height:mainActivity.height
        nHeight:height-10

        anchors.bottom: separatorLine.bottom
        anchors.bottomMargin: 1

        opacity: CState===neededState ? 1:0

        enableEditing: !mainView.lockActivities

        actCode: mainActivity.ccode

        Connections{
            target:mainView
            onLockActivitiesChanged:{
                if (activityName.state === "active"){
                    activityName.textNotAccepted();
                }
            }
        }


        MouseArea {
            id:editActivityNameMouseArea
            anchors.left: parent.left
            height:parent.height
            width:activityName.state === "active" ? parent.width - 40 : parent.width

            hoverEnabled: true

            onEntered: {
                if(activityName.state === "inactive"){

                    activityBtnsI.state="show";

                    if (mainView.lockActivities === false)
                        activityName.entered();

                }
                else
                    activityBtnsI.state="hide";



            }

            onExited: {
                if (mainView.lockActivities === false){
                    activityBtnsI.state="hide";

                    activityName.exited();
                }
                else
                    activityBtnsI.state="hide";

            }

            onClicked: {
                instanceOfActivitiesList.setCurrent(ccode);
            }

            onDoubleClicked: {
                if (mainView.lockActivities === false){
                    activityName.clicked(mouse);
                }
            }



        }

        DToolTip{
            //visible:!mainView.lockActivities
            id:activityTooltip
            title:mainView.lockActivities === false ? i18n("Activity Name") : i18n("Activity")
            mainText: mainView.lockActivities === false ? i18n("You can enable this Activity by clicking or edit its name with double-clicking in order to represent your work."):
                                                          i18n("You can enable this Activity by clicking on the Activity name or icon")
            target:editActivityNameMouseArea
            //icon:instanceOfThemeList.icons.AddWidget
        }

    }



    ActivityBtns{
        id:activityBtnsI

        width:parent.width
        height:mainView.scaleMeter - 15

        opacity: CState===neededState ? 1:0
        z:40


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

        NumberAnimation { target: mainActivity; property: "width"; to: mainActivity.defWidth; duration: 2*mainView.animationsStep; easing.type: Easing.InOutQuad }
        NumberAnimation { target: mainActivity; property: "opacity"; to: 1; duration: 2*mainView.animationsStep; easing.type: Easing.InOutQuad }
    }

    ListView.onRemove: SequentialAnimation {
        PropertyAction { target: mainActivity; property: "ListView.delayRemove"; value: true }

        ParallelAnimation{
            NumberAnimation { target: mainActivity; property: "width"; to: 0; duration: 2*mainView.animationsStep; easing.type: Easing.InOutQuad }
            NumberAnimation { target: mainActivity; property: "opacity"; to: 0; duration: 2*mainView.animationsStep; easing.type: Easing.InOutQuad }
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

    Connections{
        target:activitiesSignals
        onShowButtons:{
            if(CState === neededState)
                activityBtnsI.state="show";
        }

        onHideButtons:{
            if(CState === neededState)
                activityBtnsI.state="hide";

        }
    }

}


//}

