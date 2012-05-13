// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import ".."

Component{

    Item{
        id: taskDeleg1

        property bool shown: (onAllActivities !== true)&&((gridRow === desktop)&&(actCode === activities))

        width:mainWorkArea.imagewidth - imageTask.width - 5
        height: shown ? imageTask.height : 0

        opacity: shown ? 1 : 0

        Image{
            id:imageTask
            source: icon
            width:25
            height:width
        }


        Rectangle{
            anchors.left: imageTask.right
            anchors.bottom: imageTask.bottom
            width:taskDeleg1.width
            height:taskTitle.height
            color:"#eee2e2e2"
            radius:height/3
            Text{
                id:taskTitle

                //width:parent.width
                //clip:true

                text:name
                font.family: "Helvetica"
                font.italic: false
                font.bold: true
                font.pointSize: 3+(mainView.scaleMeter) / 12
                color:"#222222"
            }
        }


    }



}
