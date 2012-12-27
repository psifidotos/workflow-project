// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import ".."
import "ui-elements"

import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.qtextracomponents 0.1


//Component{

    Item{
        id: taskDeleg1

        property bool shown: ( (((onAllActivities !== true)&&
                                 ((gridRow === desktop)&&
                                  (actCode === activities))) ||
                                ((onAllActivities !== true)&&
                                 ((onAllDesktops === true)&&
                                  (actCode === activities))))
                              && (isPressed === false) ) //hide it in dragging

        width:mainWorkArea.imagewidth - imageTask.width - 5
        //height: shown ? 1.1 * imageTask.height : 0
        height: shown ? rHeight : 0
        opacity: shown ? 1 : 0

        property string ccode: code
        property bool isPressed:false
        property int rHeight:10


        property alias taskTitleRecColor : taskTitleRec.color
        property alias taskTitleColor: taskTitle.color

        property color taskTitleRecColorD : onAllDesktops === false ? "#eee2e2e2" : "#f7f7f7";
        property color taskTitleRecColorH : "#ff00b110";
        property color taskTitleColorD : "#333333";
        property color taskTitleColorH : "#ffffff";


        onShownChanged:{
            if(shown)
                tasksSList.shownTasks++;
            else
                tasksSList.shownTasks--;
        }

        Behavior on height{
            NumberAnimation {
                duration: 2*storedParameters.animationsStep;
                easing.type: Easing.InOutQuad;
            }
        }

        Behavior on opacity{
            NumberAnimation {
                duration: 2*storedParameters.animationsStep;
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

            property int toRX:x
            property int toRY:y

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

            Behavior on color{
                ColorAnimation {
                    duration: 3*storedParameters.animationsStep
                }
            }

            Text{
                id:taskTitle

                text: name || 0 ? name : ""
                font.family: mainView.defaultFont.family
                font.italic: false

                anchors.verticalCenter: parent.verticalCenter

                font.pixelSize: (0.8+mainView.defFontRelStep)*parent.height
                color: taskDeleg1.taskTitleColorD
                elide: Text.ElideRight
                width: parent.width

                Behavior on color{
                    ColorAnimation {
                        duration: 3*storedParameters.animationsStep
                    }
                }
            }

        }

        WATaskDelegButtons{
            id:tasksBtns
            z:5
        }

        Connections {
            target: tasksBtns
            onChangedStatus:{
                if (tasksBtns.status == "hover")
                    taskDeleg1.state = "hovered";
                else
                    taskDeleg1.state = "def";
            }
        }


        MouseArea {
            id:mstArea

            anchors.fill: parent
            hoverEnabled: true

            property int px1:0
            property int py1:0
            property bool tempPressed:false
            property int draggingSpace:2

            onEntered: {
                taskDeleg1.onEntered();
            }

            onExited: {
                taskDeleg1.onExited();
            }

            onClicked: {
                tempPressed = false;
                taskDeleg1.onClicked(mouse);
            }

            onPressed:{
                px1 = mouse.x;
                py1 = mouse.y;

                tempPressed = true;
            }

            function outOfInnerLimits(ms){
                if((ms.x<px1-draggingSpace)||(ms.x>px1+draggingSpace)||
                        (ms.y<py1-draggingSpace)||(ms.y>py1+draggingSpace))
                    return true;
                else
                    return false;
            }

            onPositionChanged: {
                if(outOfInnerLimits(mouse)&&(tempPressed)){
                    taskDeleg1.onPressed(mouse.x,mouse.y,mstArea);
                    tempPressed = false;
                }

                if(taskDeleg1.isPressed)
                    taskDeleg1.onPositionChanged(mouse,mstArea);
            }

            onReleased:{
                taskDeleg1.onReleased(mouse, mstArea);
            }
        }


        states:[
            State {
                name: "def"
                PropertyChanges {
                    target: taskDeleg1
                    taskTitleRecColor: taskDeleg1.taskTitleRecColorD
                    taskTitleColor: taskDeleg1.taskTitleColorD
                }
            },
            State {
                name:"hovered"
                PropertyChanges {
                    target: taskDeleg1
                    taskTitleRecColor: taskDeleg1.taskTitleRecColorH
                    taskTitleColor: taskDeleg1.taskTitleColorH
                }

            }

        ]


        function onEntered() {
            if (taskDeleg1.isPressed === false){
                taskDeleg1.state = "hovered";
                mainWorkArea.showButtons();
                tasksBtns.state = "show";
            }
        }

        function onExited() {
            taskDeleg1.state = "def";
            tasksBtns.state = "hide";
        }

        function onClicked(mouse) {
           // mainWorkArea.clickedWorkarea();
            if(taskDeleg1.isPressed !== true){
                taskDeleg1.onExited();
                mainWorkArea.hideButtons();
                instanceOfTasksList.setCurrentTaskInWorkarea(mainWorkArea.actCode,mainWorkArea.desktop,taskDeleg1.ccode);
            }

        }

        function onPressed(x1,y1,obj) {
            taskDeleg1.isPressed = true;
            taskDeleg1.state = "def";
            tasksBtns.state = "hide";
            workAreaButtons.state="hide";

            var nCor = obj.mapToItem(mainView,x1,y1);

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

        function onPositionChanged(mouse,obj) {
            if (taskDeleg1.isPressed === true){
                var nCor = obj.mapToItem(mainView,mouse.x,mouse.y);
                mDragInt.onPstChanged(nCor);
            }
        }

        function onReleased(mouse, obj) {
            if (taskDeleg1.isPressed === true){
                var mouseV = obj.mapToItem(mainView,mouse.x,mouse.y);

                mDragInt.onMReleased(mouse,mouseV);
            }

            taskDeleg1.isPressed = false;
        }
    }



//}
