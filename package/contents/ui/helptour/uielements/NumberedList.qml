// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import "../../../code/settings.js" as Settings

Column{

    id:numList
    property variant texts:[]
    spacing:5

    opacity:0

    Repeater {

        model:texts.length

        delegate:NumberedText{
            number:index+1
            lineHeight: 15
            width:parent.width
            height:lineHeight
            text1:texts[index]
        }
    }

    Behavior on opacity{
        NumberAnimation {
            duration: 2*Settings.global.animationStep2;
            easing.type: Easing.InOutQuad;
        }
    }

    function startAnimation(){
        numList.opacity = 1;
    }

    function resetAnimation(){
        numList.opacity = 0;
    }
}
