// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Component{

    Item{
        id: taskDeleg2

        width: onAllActivities === true ? allActRect.taskWidth+spacing :0
        height: onAllActivities === true ? imageTask2.height+taskTitle2.height : 0

        opacity: onAllActivities === true ? 1 : 0

        property int spacing: 20

        Image{
            id:imageTask2
            source: icon
            width:(3* allActTaskL.height / 5)
            height:width

            anchors.horizontalCenter: parent.horizontalCenter
        }

        Image{
            id:imageTask2Ref
            source: icon
            width:(3* allActTaskL.height / 5)
            height:width

            anchors.horizontalCenter: imageTask2.horizontalCenter
            anchors.top:imageTask2.bottom

            transform: Rotation { origin.x: 0; origin.y: height/3; axis { x: 1; y: 0; z: 0 } angle: 180 }

            opacity:0.15
        }


        Rectangle{
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: imageTask2.bottom
            width:taskDeleg2.width - taskDeleg2.spacing
            height:taskTitle2.height
            color:"#00e2e2e2"
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
                color:"#222222"
            }
        }


    }

}
