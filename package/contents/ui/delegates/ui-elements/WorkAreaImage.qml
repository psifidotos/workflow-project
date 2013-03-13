import QtQuick 1.1

import "../../../code/settings.js" as Settings
BorderImage {

    id:workBordImage


    source: (isCurrentW && !mainWorkArea.isFilteredNoResults) ?
                "../../Images/activeActivitiesBorderImage.png" : "../../Images/activitiesBorderImage.png"

    property alias mainImgP: mainImg.source

    border.left: 10; border.top: 10;
    border.right: 14; border.bottom: 14;
    horizontalTileMode: BorderImage.Repeat
    verticalTileMode: BorderImage.Repeat

    Rectangle{
        x:mainWorkArea.imagex-5
        y:mainWorkArea.imagey-6
        width:parent.width-2*x-1+2
        height:parent.height-2*y+2
        radius:7
        property real opacityForDisableBackground : mainWorkArea.isCurrentW ? 0.8 : 0.25
        opacity: Settings.global.disableBackground ? opacityForDisableBackground : 0
        color:Settings.global.disableBackground ?  theme.textColor : "#00000000"

        visible: !mainWorkArea.isFilteredNoResults
    }

    Rectangle{

        id:workBordImageMainImage
        x:mainWorkArea.imagex
        y:mainWorkArea.imagey

        width:parent.width-2*x-1
        height:parent.height-2*y

        //color:Settings.global.disableBackground ?  theme.textColor : "#00000000"

        opacity: mainWorkArea.isFilteredNoResults ? 0.10 : 1

       // clip:true
        /*Rectangle{
            width:parent.width
            height:parent.height
            color:"#ffffff"
        }*/

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
