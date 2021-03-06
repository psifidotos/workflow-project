// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import ".."
import "../components/"
import "ui-elements"
import "../../code/settings.js" as Settings

import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.qtextracomponents 0.1

Item{
    id: taskDeleg1

    property bool oneDesktop: ((onAllActivities !== true)&&
                               ((sessionParameters.numberOfDesktops === 1)||(mainWorkArea.desktop === desktop))&&
                                (activities[0] === actCode))

    property bool allDesktops: ((onAllActivities !== true)&&
                                ((onAllDesktops === true)&&
                                 (actCode === activities[0])))

    property bool sameDesktops: ((onAllActivities === true)&&
                                 (onAllDesktops === false)&&
                                 (mainWorkArea.desktop === desktop))

    property bool onEverywhereAndMustBeShown:((Settings.global.disableEverywherePanel)&&
                                              (onAllActivities)&&
                                              (onAllDesktops))

    property bool shown: (oneDesktop || allDesktops || sameDesktops || onEverywhereAndMustBeShown )
                          && (!inDragging) //hide it in dragging


    width:mainWorkArea.imagewidth - imageTask.width - 5
    //height: shown ? 1.1 * imageTask.height : 0
    height: shown ? rHeight : 0
    opacity: shown ? 1 : 0

    property string ccode: code
    property bool inDragging: code === mDragInt.intTaskId
    //    property bool isPressed: mstArea.isPresse
    property int rHeight: 10


    property alias taskTitleRecColor : taskTitleRec.color
    property alias taskTitleColor: taskTitle.color

    property color taskTitleRecColorD : ((onAllDesktops === false)&&(onAllActivities === false)) ? "#eee2e2e2" : "#f7f7f7";
    property color taskTitleRecColorH : "#ff00b110";
    property color taskTitleColorD : "#333333";
    property color taskTitleColorH : "#ffffff";

    property bool containsMouse: mstArea.containsMouse ||
                                 tasksBtns.containsMouse

    ListView.onAdd: ParallelAnimation {
        PropertyAction { target: taskDeleg1; property: "height"; value: 0 }
        PropertyAction { target: taskDeleg1; property: "opacity"; value: 0 }

        NumberAnimation { target: taskDeleg1; property: "height"; to: shown ? rHeight : 0; duration: 2*Settings.global.animationStep; easing.type: Easing.InOutQuad }
        NumberAnimation { target: taskDeleg1; property: "opacity"; to: shown ? 1 : 0; duration: 2*Settings.global.animationStep; easing.type: Easing.InOutQuad }
    }

    ListView.onRemove: SequentialAnimation {
        PropertyAction { target: taskDeleg1; property: "ListView.delayRemove"; value: true }

        ParallelAnimation{
            NumberAnimation { target: taskDeleg1; property: "height"; to: 0; duration: 2*Settings.global.animationStep; easing.type: Easing.InOutQuad }
            NumberAnimation { target: taskDeleg1; property: "opacity"; to: 0; duration: 2*Settings.global.animationStep; easing.type: Easing.InOutQuad }
        }

        // Make sure delayRemove is set back to false so that the item can be destroyed
        PropertyAction { target: taskDeleg1; property: "ListView.delayRemove"; value: false }
    }


    Behavior on height{
        NumberAnimation {
            duration: 2*Settings.global.animationStep;
            easing.type: Easing.InOutQuad;
        }
    }

    Behavior on opacity{
        NumberAnimation {
            duration: 2*Settings.global.animationStep;
            easing.type: Easing.InOutQuad;
        }
    }

    QIconItem{
        id:imageTask

        icon:Icon
        smooth:true


        width:1.1*taskTitleRec.height
        height:width
        y:0.1 * taskDeleg1.height

        opacity: ((onEverywhereAndMustBeShown)&(taskDeleg1.state=="def")) ? 0.4 : 1

        property int toRX:x
        property int toRY:y

        Behavior on opacity{
            NumberAnimation {
                duration: 2*Settings.global.animationStep;
                easing.type: Easing.InOutQuad;
            }
        }

    }


    Rectangle{
        id:taskTitleRec

        anchors.left: imageTask.right
        anchors.bottom: imageTask.bottom
        width:taskDeleg1.width
        height:0.9*parent.height

        color: taskDeleg1.taskTitleRecColorD
        radius:height/3
        y:0.1 * taskDeleg1.height
        clip:true

        opacity: ((onEverywhereAndMustBeShown)&(taskDeleg1.state=="def")) ? 0.4 : 1

        Behavior on color{
            ColorAnimation {
                duration: 3*Settings.global.animationStep
            }
        }

        Behavior on opacity{
            NumberAnimation {
                duration: 2*Settings.global.animationStep;
                easing.type: Easing.InOutQuad;
            }
        }

        Text{
            id:taskTitle

            text: name || 0 ? name : ""
            font.family: theme.defaultFont.family
            font.italic: false

            anchors.verticalCenter: parent.verticalCenter

            font.pixelSize: (0.8+0.05)*parent.height
            color: taskDeleg1.taskTitleColorD
            elide: Text.ElideRight
            width: parent.width

            Behavior on color{
                ColorAnimation {
                    duration: 3*Settings.global.animationStep
                }
            }
        }

    }

    WATaskDelegButtons{
        id:tasksBtns
        z:5
    }

    DraggingMouseArea{
        id:mstArea
        anchors.fill: parent
        draggingInterface: mDragInt

        onClickedOverrideSignal: {
            workflowManager.activityManager().setCurrentActivityAndDesktop(mainWorkArea.actCode,mainWorkArea.desktop);
            taskManager.activateTask(taskDeleg1.ccode);
        }

        onDraggingStarted: {
            taskDeleg1.draggingStarted(mouse, mstArea);
        }
    }

    states:[
        State {
            name: "def"
            when: !containsMouse
            PropertyChanges {
                target: taskDeleg1
                taskTitleRecColor: taskDeleg1.taskTitleRecColorD
                taskTitleColor: taskDeleg1.taskTitleColorD
            }
        },
        State {
            name:"hovered"
            when:containsMouse
            PropertyChanges {
                target: taskDeleg1
                taskTitleRecColor: taskDeleg1.taskTitleRecColorH
                taskTitleColor: taskDeleg1.taskTitleColorH
            }

        }

    ]

    /////////////////*Dragging functions*///////////////////////

    function draggingStarted(mouse, obj){
        var nCor = obj.mapToItem(mainView, mouse.x, mouse.y);

        var coord1 = imageTask.mapToItem(mainView,imageTask.x, imageTask.y);

        var everySt = (onAllActivities === true);

        mDragInt.enableDragging(nCor,
                                imageTask.icon,
                                ccode,
                                mainWorkArea.actCode,
                                mainWorkArea.desktop,
                                coord1,
                                everySt);
    }

}


