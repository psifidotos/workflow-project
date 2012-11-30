// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item{
    id:mainPag

    property string pageTitle

    property string objectNameType:"TourPage"

    function startAnimation(){
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
