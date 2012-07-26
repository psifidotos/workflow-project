import QtQuick 1.0

BorderImage {

    id:workBordImage
    source: ((mainWorkArea.actCode === mainView.currentActivity) && (mainWorkArea.desktop === mainView.currentDesktop)) ?
                "../../Images/activeActivitiesBorderImage.png" : "../../Images/activitiesBorderImage.png"
    property alias mainImgP: mainImg.source

    // property int tempMeter: mainView.scaleMeter/5;

    border.left: 10; border.top: 10;
    border.right: 14; border.bottom: 14;
    horizontalTileMode: BorderImage.Repeat
    verticalTileMode: BorderImage.Repeat


    Rectangle{

        id:workBordImageMainImage
        x:mainWorkArea.imagex
        y:mainWorkArea.imagey
        //width:mainWorkArea.imagewidth
        //height:mainWorkArea.imageheight

        width:parent.width-2*x
        height:parent.height-2*y


        clip:true
        Image {
            id: mainImg
            source: workList.eelemImg
            fillMode:Image.PreserveAspectCrop
            width:parent.width
            height:parent.height
        }

        Image {
            source: "../../Images/backgrounds/screenglass.png"
            opacity:0.6
            width:parent.width
            height:parent.height
        }
    }


}
