import QtQuick 1.0

BorderImage {

    id:workBordImage


    source: isCurrentW === true ?
                "../../Images/activeActivitiesBorderImage.png" : "../../Images/activitiesBorderImage.png"

    property alias mainImgP: mainImg.source

    border.left: 10; border.top: 10;
    border.right: 14; border.bottom: 14;
    horizontalTileMode: BorderImage.Repeat
    verticalTileMode: BorderImage.Repeat

    Rectangle{

        id:workBordImageMainImage
        x:mainWorkArea.imagex
        y:mainWorkArea.imagey

        width:parent.width-2*x-1
        height:parent.height-2*y

        color:"#00000000"

        opacity: (tasksSList.shownTasks === 0)&&(filterWindows.text!=="") ? 0.10 : 1


       // clip:true
        Rectangle{
            width:parent.width
            height:parent.height
            color:"#ffffff"
        }

        Image {
            id: mainImg
            source: background
           // fillMode:Image.
            anchors.centerIn: parent
            width:parent.width
            height:parent.height
            opacity:isCurrentW === true ? 1:0.95
        }


        Image {
            source: "../../Images/backgrounds/screenglass.png"
            opacity:0.6
            width:mainImg.width
            height:mainImg.height
            anchors.centerIn: mainImg
        }

        Rectangle{

            border.color:isCurrentW ? "#f1f1f1":"#b1b1b1"
            color:"#00000000"
            border.width: 1
            anchors.centerIn: parent
            width:parent.width
            height:parent.height
        }


    }

}
