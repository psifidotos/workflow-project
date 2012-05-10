import QtQuick 1.0

BorderImage {

   id:workBordImage
   source: "Images/activitiesBorderImage.png"

   property int tempMeter: mainView.scaleMeter/5;

   border.left: 10; border.top: 10;
   border.right: 14; border.bottom: 14;
   horizontalTileMode: BorderImage.Repeat
   verticalTileMode: BorderImage.Repeat


   Rectangle{
      /*     x:(mainView.scaleMeter/2)-(mainView.scaleMeter/10)
           y:(mainView.scaleMeter/2)-(mainView.scaleMeter/10)
           width:parent.width-(3*workBordImage.tempMeter+mainView.scaleMeter/4)
           height:parent.height-(3*workBordImage.tempMeter+mainView.scaleMeter/5)*/
       id:workBordImageMainImage
       x:mainWorkArea.imagex
       y:mainWorkArea.imagey
       width:mainWorkArea.imagewidth
       height:mainWorkArea.imageheight
           clip:true
           Image {
             source: workList.eelemImg
             fillMode:Image.PreserveAspectCrop
             width:parent.width
             height:parent.height
           }

           Image {
             source: "Images/backgrounds/screenglass.png"
             opacity:0.6
          //   fillMode:Image.PreserveAspectCrop
             width:parent.width
             height:parent.height
           }
    }


}
