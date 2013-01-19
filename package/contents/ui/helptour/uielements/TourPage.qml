// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import "../../../code/settings.js" as Settings

Item{
    id:mainPag

    property string pageTitle

    property string objectNameType:"TourPage"

    opacity:0

    Behavior on opacity{
        NumberAnimation {
            duration: 2*Settings.global.animationStep;
            easing.type: Easing.InOutQuad;
        }
    }

    function startAnimation(){
        opacity = 1;
        if(children.length>0){

            for(var i=0; i<children.length; i++){
                var chd = children[i];
                if( (chd.objectNameType === "AnimatedParagraph") ||
                    (chd.objectNameType === "AnimatedText") ||
                    (chd.objectNameType === "AnimatedLine"))
                    chd.startAnimation();
                else
                    chd.opacity = 1;
            }
        }
    }

    function resetAnimation(){
        opacity = 0;
        if(children.length>0){

            for(var i=0; i<children.length; i++){
                var chd = children[i];
                if( (chd.objectNameType === "AnimatedParagraph") ||
                    (chd.objectNameType === "AnimatedText") ||
                    (chd.objectNameType === "AnimatedLine"))
                    chd.resetAnimation();
                else
                    chd.opacity = 0;
            }
        }
    }

}
