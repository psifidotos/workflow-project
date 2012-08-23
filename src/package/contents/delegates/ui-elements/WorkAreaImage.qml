import QtQuick 1.0

BorderImage {

    id:workBordImage

    property bool isCurrentW:((mainWorkArea.actCode === mainView.currentActivity) &&
                              (mainWorkArea.desktop === mainView.currentDesktop))
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
