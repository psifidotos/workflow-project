// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import ".."

Component{

    Item{
        id: taskDeleg1

        property bool shown: ( (((onAllActivities !== true)&&
                                 ((gridRow === desktop)&&
                                  (actCode === activities))) ||
                                ((onAllActivities !== true)&&
                                 ((onAllDesktops === true)&&
                                  (actCode === activities))))
                              && (isPressed === false) )


        width:mainWorkArea.imagewidth - imageTask.width - 5
        height: shown ? 1.1 * imageTask.height : 0
        opacity: shown ? 1 : 0

        property string ccode:code
        property bool isPressed:false



        property alias taskTitleRecColor : taskTitleRec.color
        property alias taskTitleColor: taskTitle.color

        property color taskTitleRecColorD : onAllDesktops === false ? "#eee2e2e2" : "#f7f7f7";
        property color taskTitleRecColorH : "#ff00b110";
        property color taskTitleColorD : "#222222";
        property color taskTitleColorH : "#ffffff";

        //        property color taskTitleColorD : taskOrFTitle.color;
        //       property color taskTitleColorH : "#ffffff";

        //property color taskTitleRecColorD : "#0000b110";
        //property color taskTitleRecColorH : "#ff00b110";

        Behavior on height{
            NumberAnimation {
                duration: 400;
                easing.type: Easing.InOutQuad;
            }
        }

        Behavior on opacity{
            NumberAnimation {
                duration: 400;
                easing.type: Easing.InOutQuad;
            }
        }

        Image{
            id:imageTask
            source: "../" + icon
            width:1.5*taskTitleRec.height
            height:width
            y:0.1 * taskDeleg1.height

            property int toRX:x
            property int toRY:y

            MouseArea {
                id: imageMouseArea
                anchors.fill: parent
                hoverEnabled: true

                onEntered: {
                    taskDeleg1.onEntered();
                }

                onExited: {
                    taskDeleg1.onExited();
                }

                onClicked: {
                    taskDeleg1.onClicked(mouse);
                }

                onPressAndHold:{
                    taskDeleg1.onPressAndHold(mouse,imageMouseArea);
                }

                onPositionChanged: {
                    taskDeleg1.onPositionChanged(mouse,imageMouseArea);
                }

                onReleased:{
                    taskDeleg1.onReleased(mouse);
                }
            }
        }


        Rectangle{
            id:taskTitleRec

            anchors.left: imageTask.right
            anchors.bottom: imageTask.bottom
            width:taskDeleg1.width
            height:taskTitle.height
            color: taskDeleg1.taskTitleRecColorD
            radius:height/3
            y:0.1 * taskDeleg1.height
            clip:true

            Behavior on color{
                ColorAnimation {
                    duration: 500
                }
            }

            Text{
                id:taskTitle

                //width:parent.width
                //clip:true

                text:name
                font.family: "Helvetica"
                font.italic: false
                font.bold: true
                font.pointSize: 3+(mainView.scaleMeter) / 12
                color: taskDeleg1.taskTitleColorD

                Behavior on color{
                    ColorAnimation {
                        duration: 500
                    }
                }
            }
            MouseArea {
                id:mstArea

                anchors.fill: parent
                hoverEnabled: true

                onEntered: {
                    taskDeleg1.onEntered();
                }

                onExited: {
                    taskDeleg1.onExited();
                }

                onClicked: {
                    taskDeleg1.onClicked(mouse);
                }

                onPressAndHold:{
                    taskDeleg1.onPressAndHold(mouse,mstArea);
                }

                onPositionChanged: {
                    taskDeleg1.onPositionChanged(mouse,mstArea);
                }

                onReleased:{
                    taskDeleg1.onReleased(mouse);
                }

            }
        }

        WATaskDelegButtons{
            id:tasksBtns
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
                taskDeleg1.state = "hovered"
                workAreaButtons.state="show"
                tasksBtns.state = "show"
            }
        }

        function onExited() {
            taskDeleg1.state = "def";
            tasksBtns.state = "hide";
        }

        function onClicked(mouse) {
            mainWorkArea.clickedWorkarea();
        }

        function onPressAndHold(mouse,obj) {
            taskDeleg1.isPressed = true;
            taskDeleg1.state = "def";
            tasksBtns.state = "hide";
            workAreaButtons.state="hide";

            var nCor = obj.mapToItem(mainView,mouse.x,mouse.y);
            mDragInt.enableDragging(nCor,imageTask.source);
        }

        function onPositionChanged(mouse,obj) {
            if (taskDeleg1.isPressed === true){
                var nCor = obj.mapToItem(mainView,mouse.x,mouse.y);
                mDragInt.onPstChanged(nCor);
            }
        }

        function onReleased(mouse) {
            taskDeleg1.isPressed = false;
            mDragInt.disableDragging();
        }
    }



}
