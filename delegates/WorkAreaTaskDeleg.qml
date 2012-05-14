// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import ".."

Component{

    Item{
        id: taskDeleg1

        property bool shown: (onAllActivities !== true)&&((gridRow === desktop)&&(actCode === activities))

        width:mainWorkArea.imagewidth - imageTask.width - 5
        height: shown ? 1.3*imageTask.height : 0


        opacity: shown ? 1 : 0

        property alias taskTitleRecColor : taskTitleRec.color
        property alias taskTitleColor: taskTitle.color

        property color taskTitleRecColorD : "#eee2e2e2";
        property color taskTitleRecColorH : "#e8c5f3ca";
        property color taskTitleColorD : "#222222";
        property color taskTitleColorH : "#13200e";

        Image{
            id:imageTask
            source: icon
            width:25
            height:width
            y:0.1 * taskDeleg1.height
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
        }

        WATaskDelegButtons{
            id:tasksBtns
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

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onEntered: {
                taskDeleg1.state = "hovered"
                workAreaButtons.state="show"
                tasksBtns.state = "show"
            }

            onExited: {
                taskDeleg1.state = "def"
                tasksBtns.state = "hide"
            }

        }

    }



}
