// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Component{

    Item{
        id: taskDeleg1

        width:mainWorkArea.imagewidth - imageTask.width - 5
        height:(gridRow === desktop)&&(actCode === activities) ? imageTask.height : 0

        opacity: (gridRow === desktop)&&(actCode === activities) ? 1 : 0

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
            Text{
                id:taskTitle

                //width:parent.width
                //clip:true

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
