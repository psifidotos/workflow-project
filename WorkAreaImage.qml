import QtQuick 1.0

BorderImage {

   id:workBordImage
   source: "Images/activitiesBorderImage.png"

   property int tempMeter: mainView.scaleMeter/5;

   border.left: 12; border.top: 12;
   border.right: 13; border.bottom: 14;


   Rectangle{
      /*     x:(mainView.scaleMeter/2)-(mainView.scaleMeter/10)
           y:(mainView.scaleMeter/2)-(mainView.scaleMeter/10)
           width:parent.width-(3*workBordImage.tempMeter+mainView.scaleMeter/4)
           height:parent.height-(3*workBordImage.tempMeter+mainView.scaleMeter/5)*/

       x:14
       y:15
       width:parent.width-28
       height:parent.height-30
           clip:true
           Image {
             source: elemImg
             fillMode:Image.PreserveAspectCrop
             width:parent.width
             height:parent.height
           }
    }

}
