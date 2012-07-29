// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.qtextracomponents 0.1

import ".."
import "ui-elements"

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
        height: mainView.workareaWidth / 3

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
            x:mainView.scaleMeter/10
            y:mainView.scaleMeter/3

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
                anchors.fill: parent
                hoverEnabled: true

                onEntered: {
                    if(activityName.state === "inactive"){
                        if (mainView.lockActivities === false){
                            activityBtnsI.state="show";
                            stopActLocked.state="hide";
                            fadeIcon.opacity = 0;
                            activityIcon.rotation = 0;
                        }
                        else
                            stopActLocked.state="show";
                    }
                    else{
                        activityBtnsI.state="hide";
                        stopActLocked.state="hide";
                    }

                }

                onExited: {
                    if (mainView.lockActivities === false){
                        activityBtnsI.state="hide";
                        stopActLocked.state="hide";

                        fadeIcon.opacity = 1;

                        activityIcon.rotation = -20;
                    }
                    else
                        stopActLocked.state="hide";

                }
                onClicked: {
                    if (mainView.lockActivities === false)
                        instanceOfActivitiesList.setIcon(ccode);
                }

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

            //y: mainView.scaleMeter/18
            x: 0.7*mainView.scaleMeter+10

            property int spacingWidth:0.7*mainView.scaleMeter+10

            width:mainActivity.width - spacingWidth
            //height:mainActivity.height - y
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
                anchors.left: parent.left
                height:parent.height
                width:parent.width - 40

                hoverEnabled: true

                onEntered: {
                    if(activityName.state === "inactive"){
                        if (mainView.lockActivities === false){
                            activityBtnsI.state="show";
                            stopActLocked.state="hide";
                            activityName.entered();
                        }
                        else
                            stopActLocked.state="show";
                    }
                    else{
                        activityBtnsI.state="hide";
                        stopActLocked.state="hide";
                    }

                }

                onExited: {
                    if (mainView.lockActivities === false){
                        activityBtnsI.state="hide";
                        stopActLocked.state="hide";
                        activityName.exited();
                    }
                    else
                        stopActLocked.state="hide";
                }

                onClicked: {
                    if (mainView.lockActivities === false){
                        activityName.clicked(mouse);
                    }
                }

            }

        }

        ActivityBtns{
            id:activityBtnsI

            width:parent.width-(mainView.scaleMeter-10)
            x:mainView.scaleMeter-10
            height:mainView.scaleMeter - 15
            opacity: CState===neededState ? 1:0
        }

        QIconItem{
            id:stopActLocked
            opacity:1
            icon: QIcon("player_stop")
            anchors.top: parent.top
            anchors.right: parent.right

            width:5+0.8*mainView.scaleMeter
            height:width
            state: "hide"

            Behavior on opacity{
                NumberAnimation {
                    duration: 2*mainView.animationsStep;
                    easing.type: Easing.InOutQuad;
                }
            }

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
                    stopActLocked.state="show";
                    stopActLocked.scale=1.2;
                }

                onExited: {
                    stopActLocked.state="hide";
                    stopActLocked.scale=1;
                }

                onClicked: {
                    activityBtnsI.clickedStopped();
                }

            }

            states: [
                State {
                    name: "show"
                    PropertyChanges {
                        target: stopActLocked
                        opacity: allwlists.activitiesShown > 1 ? 1 : 0
                    }
                },
                State {
                    name:"hide"
                    PropertyChanges {
                        target: stopActLocked
                        opacity:0
                    }

                }

            ]
        }

        Rectangle{
            id:separatorLine

            anchors.right:parent.right
            y:-activitiesList.y
            width:1
            height:actImag1.height - 1
            color:"#15222222"
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

        Connections{
            target:activitiesSignals
            onShowButtons:{
                if(CState === neededState){
                    if (mainView.lockActivities === false)
                        activityBtnsI.state="show";
                    else
                        stopActLocked.state="show";
                }
            }

            onHideButtons:{
                if(CState === neededState){
                    activityBtnsI.state="hide";
                    stopActLocked.state="hide";
                }
            }
        }

    }


//}

