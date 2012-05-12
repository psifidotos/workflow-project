// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Component{

    Item{
        id: taskDeleg2

        width: onAllActivities === true ? allActRect.taskWidth+spacing :0
        height: onAllActivities === true ? imageTask2.height+taskTitle2.height : 0

        opacity: onAllActivities === true ? 1 : 0

        property int spacing: 20

        property alias imageTask2Width: imageTask2.width
        property alias textY: taskTitleRec.y
        property alias textOpacity: taskTitleRec.opacity

        state:"nohovered"

        Image{
            id:imageTask2
            source: icon
            height:width

            anchors.horizontalCenter: parent.horizontalCenter

            y:-height/5

            Behavior on width{
                NumberAnimation {
                    duration: 500;
                    easing.type: Easing.InOutQuad;
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

            Behavior on y{
                NumberAnimation {
                    duration: 500;
                    easing.type: Easing.InOutQuad;
                }
            }

            Behavior on opacity{
                NumberAnimation {
                    duration: 500;
                    easing.type: Easing.InOutQuad;
                }
            }

            Text{
                id:taskTitle2

                //width:parent.width
                clip:true
                //horizontalAlignment: Text.AlignLeft
                anchors.horizontalCenter: parent.horizontalCenter


                text:name
                font.family: "Helvetica"
                font.italic: false
                font.bold: true
                font.pointSize: 4+(mainView.scaleMeter) / 12
                color:"#333333"
            }
        }


        states: [
            State {
                name: "nohovered"
                PropertyChanges {
                    target: taskDeleg2
                    imageTask2Width:(3* allActTaskL.height / 5)
                    textY: imageTask2.y+imageTask2.height
                    textOpacity: 0.3
                }
            },
            State {
                name:"hovered"
                PropertyChanges {
                    target: taskDeleg2
                    textY: 4 * (imageTask2.y+imageTask2.height) / 5
                    imageTask2Width: 2* (3* allActTaskL.height / 5)
                    textOpacity: 1
                }

            }

        ]

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onEntered: {
                taskDeleg2.state = "hovered";
            }

            onExited: {
                taskDeleg2.state = "nohovered";
            }
        }
    }

}
