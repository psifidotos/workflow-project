// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import ".."
import "ui-elements"
import "../tooltips"
import "../../code/settings.js" as Settings

Item{
    id: workList

    property string tCState : CState
    property string ccode:code
    property string neededState:"Running"

    property int addedHeight:addWorkArea.height + taskOrFTitle.height + taskOrFTitleL.height + orphansList.rHeight

    property bool showWindowsSection:(orphansList.shownOrphanWindows > 0) && (Settings.global.showWindows  === true)

    property string typeId : "WorkareasColumnAppearanceDelegate"

    //   state: tCState === neededState ? "show" : "hide"
    state:"hide"

    property int workAreaImageHeight: sessionParameters.screenRatio*bWidth
    property int workAreaNameHeight:20 + mainView.scaleMeter/2
    property int realWorkAreaNameHeight: 0.8*workAreaNameHeight

    property int bWidth: mainView.workareaWidth

    property int bHeight: (workAreaImageHeight+realWorkAreaNameHeight+0.7*workalist.addedHeightForCurrent)*(workalist.model.count+0.02)

    //    width: bWidth
    height: bHeight+addedHeight

    property bool activityDragged: (draggingActivities.activityId === code) &&
                                   (draggingActivities.activityStatus === "Running")

    onHeightChanged: allareas.changedChildHeight();

    onAddedHeightChanged: allareas.changedChildHeight();

    onStateChanged: allareas.changedChildHeight();

    Rectangle{
        id:draggingRectangle
        anchors.horizontalCenter: parent.horizontalCenter
        width:workalist.width - 10
        height:workalist.height - 10
        radius:10
        color: "#333333"
        opacity:activityDragged ? 0.15 : 0
    }

    ListView{
        id:workalist

        height:workList.bHeight
       // width: workList.tCState === workList.neededState ? workList.bWidth : 0
        property string typeId : "WorkareasListView"

        property int addedHeightForCurrent:(sessionParameters.screenRatio*0.2*mainView.scaleMeter)

        opacity:activityDragged ? 0 : 1
        z:5

        interactive:false

        model: workflowManager.model().workareas(code)

        orientation:ListView.Vertical

        delegate:WorkAreaDeleg{
        }

    }

    AddWorkAreaButton{
        id:addWorkArea

        property string typeId : "AddWorkareaButton"

        property string activityCode: workList.ccode
        property int newDesktop: workalist.model.count + 1

        anchors.top: workalist.bottom
        anchors.horizontalCenter: workalist.horizontalCenter

        width:0.9*parent.width

        opacity: (workList.tCState === workList.neededState)&&(!activityDragged) ? 1 : 0

        MouseArea {
            anchors.fill: parent

            onClicked:{
                workflowManager.workareaManager().addWorkArea(code,"");
            }
        }

    }


    Text{
        id:taskOrFTitle
        anchors.topMargin: mainView.scaleMeter/5
        anchors.top:addWorkArea.bottom
        anchors.left: addWorkArea.left

        width:parent.width
        opacity: workList.showWindowsSection === true ? 1:0

        text:i18n("Orphaned Windows")
        font.family: mainView.defaultFont.family
        font.italic: true
        font.bold: true
        font.pixelSize: (0.095+mainView.defFontRelStep)*(mainView.workareaHeight)

        color: "#80808c";

        Behavior on height{
            NumberAnimation{
                duration: 3*Settings.global.animationStep2;
                easing.type: Easing.InOutQuad;
            }
        }
        Behavior on opacity{
            NumberAnimation{
                duration: 3*Settings.global.animationStep2;
                easing.type: Easing.InOutQuad;
            }
        }
    }

    Rectangle{
        id:taskOrFTitleL
        width: 0.9 * workList.bWidth

        anchors.top : taskOrFTitle.bottom
        anchors.left: taskOrFTitle.left

        opacity: workList.showWindowsSection === true ? 1:0
        height: workList.showWindowsSection === true ? 2:0
        color:taskOrFTitle.color;

        Behavior on height{
            NumberAnimation{
                duration: 3*Settings.global.animationStep2;
                easing.type: Easing.InOutQuad;
            }
        }
        Behavior on opacity{
            NumberAnimation{
                duration: 3*Settings.global.animationStep2;
                easing.type: Easing.InOutQuad;
            }
        }
    }

    ListView {
        id:orphansList

        width: workList.tCState === workList.neededState ? workList.bWidth : 0

        anchors.topMargin: windsHeight/3
        //y: taskOrFTitleL.height+taskOrFTitle.height

        anchors.top : taskOrFTitleL.bottom
        anchors.left: taskOrFTitleL.left

        property int fontSize:(0.095+mainView.defFontRelStep)*(mainView.workareaHeight)
        property int windsHeight:1.4 * fontSize

        //for scrolling in vertical
        opacity: workList.showWindowsSection === true ? 1 : 0
        property int rHeight: workList.showWindowsSection === true ? (shownOrphanWindows+2) * windsHeight : 0

        height: model.count * windsHeight

        property int shownOrphanWindows: 0

        interactive:false


        model: taskManager.model()

        delegate:WorkAreaOrphanTaskDeleg{
        }

        Behavior on height{
            NumberAnimation{
                duration: 3*Settings.global.animationStep2;
                easing.type: Easing.InOutQuad;
            }
        }

    }

    Rectangle{
        //x: 1 * parent.width
        anchors.right:workalist.right
        width:1
        height:2*mainView.height
        color:"#25727272"

    }

    /*
        ListView.onAdd:
            NumberAnimation { target: workList;
                property: "opacity";
                to: 1;
                duration: 2*Settings.global.animationStep;
                easing.type: Easing.InOutQuad
        }*/


    ListView.onRemove: SequentialAnimation {
        PropertyAction { target: workList; property: "ListView.delayRemove"; value: true }

        NumberAnimation { target: workList; property: "opacity"; to: 0; duration: 2*Settings.global.animationStep; easing.type: Easing.InOutQuad }

        // Make sure delayRemove is set back to false so that the item can be destroyed
        PropertyAction { target: workList; property: "ListView.delayRemove"; value: false }
    }

    states: [
        State {
            name: "show"
            when: tCState === neededState
            PropertyChanges {
                target: workList
                //width: bWidth
                opacity: 1
                width: bWidth
            }
            PropertyChanges {
                target: workalist
                width: workList.bWidth
            }
        },
        State {
            name: "hide"
            when: tCState !== neededState
            PropertyChanges {
                target: workList

                opacity: 0
                width: 0
            }
            PropertyChanges {
                target: workalist
                width: 0
            }

        }
    ]

    transitions: [

        Transition {
            from:"hide"; to:"show"
            reversible: false
            ParallelAnimation{
                NumberAnimation {
                    target: workList;
                    property: "opacity";
                    duration: 2*Settings.global.animationStep;
                    easing.type: Easing.InOutQuad;
                }
                NumberAnimation {
                    target: workList;
                    property: "width";
                    duration: 2*Settings.global.animationStep;
                    easing.type: Easing.InOutQuad;
                }
                NumberAnimation {
                    target: workalist;
                    property: "opacity";
                    duration: 2*Settings.global.animationStep;
                    easing.type: Easing.InOutQuad;
                }
                NumberAnimation {
                    target: workalist;
                    property: "width";
                    duration: 2*Settings.global.animationStep;
                    easing.type: Easing.InOutQuad;
                }
            }
        },
        Transition {
            from:"show"; to:"hide"
            reversible: false
            ParallelAnimation{
                NumberAnimation {
                    target: workList;
                    property: "opacity";
                    duration: 2*Settings.global.animationStep;
                    easing.type: Easing.InOutQuad;
                }
                NumberAnimation {
                    target: workList;
                    property: "width";
                    duration: 2*Settings.global.animationStep;
                    easing.type: Easing.InOutQuad;
                }
                NumberAnimation {
                    target: workalist;
                    property: "opacity";
                    duration: 2*Settings.global.animationStep;
                    easing.type: Easing.InOutQuad;
                }
                NumberAnimation {
                    target: workalist;
                    property: "width";
                    duration: 2*Settings.global.animationStep;
                    easing.type: Easing.InOutQuad;
                }
            }
        }
    ]

    function getOrphanList(){
        return orphansList;
    }

    function getWorkarea(war){ //desktop counts from 1
        return workalist.children[0].children[war+1];
    }

    function getAddWorkAreaButton(){
        return addWorkArea;
    }

    function getWorkareaSize(){
        return workalist.model.count;
    }


}

