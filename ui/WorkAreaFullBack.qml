// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

BorderImage {

   id:wbImage
   source: "../Images/activeActivitiesBorderImage.png"
   property alias mainImgP: mainImg.source

   border.left: 10; border.top: 10;
   border.right: 14; border.bottom: 14;
   horizontalTileMode: BorderImage.Repeat
   verticalTileMode: BorderImage.Repeat


   Rectangle{

       id:wbMainImage
       x:15
       y:15
       width:parent.width - 30
       height:parent.height - 30
           clip:true
           Image {
             id: mainImg
             fillMode:Image.PreserveAspectCrop
             width:parent.width
             height:parent.height
           }

           Image {
             source: "../Images/backgrounds/screenglass.png"
             opacity:0.6
             x:0.1 * parent.width
             y:0.1 * parent.height
             width:parent.width
             height:parent.height
           }
    }


}
