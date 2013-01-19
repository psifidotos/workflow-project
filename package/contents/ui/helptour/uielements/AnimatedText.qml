// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import "../../../code/settings.js" as Settings

TextB {
    Timer{
        id:txtTimer
        interval: 10
        repeat:true
        onTriggered: {
            parent.stepAnimation();
        }
    }
    property string objectNameType:"AnimatedText"

    property string fullText
    property int stpCounter:0
    property bool onlyOpacity:false

    opacity: 0

    Behavior on opacity{
        NumberAnimation {
            duration: 2*Settings.global.animationStep2;
            easing.type: Easing.InOutQuad;
        }
    }

    function stepAnimation(){
        if (stpCounter >= fullText.length-1){
            txtTimer.stop();
            text = fullText.substring(0,fullText.length);
        }
        else{
            if (onlyOpacity === false){
                text = fullText.substring(0,stpCounter)+"_";
                stpCounter++;
            }
            else{
                txtTimer.stop();
                text = fullText.substring(0,fullText.length);
            }
        }
    }

    function startAnimation(){
        if(Settings.global.animationStep2 > 0)
            txtTimer.start();
        else
            text = fullText;

        opacity=1;
    }

    function resetAnimation(){
        txtTimer.stop();
        stpCounter=0;
        text="";
        opacity=0;
    }

}
