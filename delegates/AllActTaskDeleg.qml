// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import ".."

Component{

    Item{
        id: taskDeleg2

        property bool mustBeShown: (onAllActivities === true)&&
                                   (onAllDesktops === true)

        width: mustBeShown ? allActRect.taskWidth+spacing : 0
        height: mustBeShown ? imageTask2.height+taskTitle2.height : 0

        opacity: mustBeShown ? 1 : 0

        property int spacing: 20

        property alias imageTask2Width: imageTask2.width
        property alias textY: taskTitleRec.y
        property alias textOpacity: taskTitleRec.opacity

        state:"nohovered"

        Behavior on width{
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
            id:imageTask2
            source: icon
            height:width

            anchors.horizontalCenter: parent.horizontalCenter

            y:-height/5

            width:(3* allActTaskL.height / 5)

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onEntered: {
                    taskDeleg2.state = "hovered";
                    allTasksBtns.state = "show";
                }

                onExited: {
                    taskDeleg2.state = "nohovered";
                    allTasksBtns.state = "hide";
                }
            }

        }

        Image{
            id:imageTask2Ref
            source: icon
            width:imageTask2.width
            height:width

            anchors.horizontalCenter: imageTask2.horizontalCenter
            anchors.top:imageTask2.bottom

            transform: Rotation { origin.x: 0; origin.y: height/3; axis { x: 1; y: 0; z: 0 } angle: 180 }

            opacity:0.15

        }


        Rectangle{
            id: taskTitleRec

            anchors.horizontalCenter: parent.horizontalCenter

            width:taskDeleg2.width - taskDeleg2.spacing
            height:taskTitle2.height
            color:"#00e2e2e2"

            y: imageTask2.y+imageTask2.height
            opacity: 0.3

            Text{
                id:taskTitle2

                clip:true

                anchors.horizontalCenter: parent.horizontalCenter


                text:name
                font.family: "Helvetica"
                font.italic: false
                font.bold: true
                font.pointSize: 4+(mainView.scaleMeter/12)
                color:"#333333"
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onEntered: {
                    taskDeleg2.state = "hovered";
                    allTasksBtns.state = "show";
                }

                onExited: {
                    taskDeleg2.state = "nohovered";
                    allTasksBtns.state = "hide";
                }
            }
        }

        AllTaskDelegButtons{
            id:allTasksBtns
        }

        Connections {
            target: allTasksBtns
            onChangedStatus:{
                if (allTasksBtns.status == "hover")
                    taskDeleg2.state = "hovered";
                else
                    taskDeleg2.state = "nohovered";
            }
        }


        states: [
            State {
                name: "nohovered"

            },
            State {
                name:"hovered"
                PropertyChanges {
                    target: taskDeleg2
                    textY: 4 * (imageTask2.y+imageTask2.height) / 5
                    imageTask2Width: 1.2 * allActTaskL.height
                    textOpacity: 1
                }

            }

        ]

        transitions: [

            Transition {
                from:"nohovered"; to:"hovered"
                reversible: true

                ParallelAnimation{
                    NumberAnimation {
                        target: taskDeleg2;
                        property: "imageTask2Width"
                        duration: 500;
                        easing.type: Easing.InOutQuad;
                    }
                    NumberAnimation {
                        target: taskDeleg2;
                        property: "textY"
                        duration: 500;
                        easing.type: Easing.InOutQuad;
                    }
                    NumberAnimation {
                        target: taskDeleg2;
                        property: "textOpacity"
                        duration: 500;
                        easing.type: Easing.InOutQuad;
                    }
                }

            }
        ]

    }

}
