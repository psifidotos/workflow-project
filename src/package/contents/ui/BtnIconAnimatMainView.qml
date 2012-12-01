// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Image{
    id:btnIcon
    opacity:0

    property real imageRatio:1

    z:40
    smooth:true

    function animateIcon(pth,rt,wdth,coord){

        btnIcon.source = pth;
        btnIcon.x = coord.x;
        btnIcon.y = coord.y;
        btnIcon.imageRatio = rt;
        btnIcon.width = wdth;
        btnIcon.height = rt * wdth;
        btnIcon.opacity = 1;
        btnIcon.scale = 1;

        playIconAnimation.start();
    }


    ParallelAnimation{
        id:playIconAnimation
        property int animationDur:600

        NumberAnimation {
            target: btnIcon;
            property: "opacity";
            duration: playIconAnimation.animationDur;
            easing.type: Easing.InOutQuad;
            to: 0;
        }


        NumberAnimation {
            target: btnIcon;
            property: "scale";
            duration: playIconAnimation.animationDur;
            easing.type: Easing.InOutQuad;
            to: 8;
        }



    }

}

