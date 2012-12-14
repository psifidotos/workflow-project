// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

TextB {
    Timer{
        id:txtTimer
        interval:20
        repeat:true
        onTriggered: {
            parent.stepAnimation();
        }
    }
    property string objectNameType:"AnimatedText"

    property string fullText
    property int stpCounter:0
    property bool onlyOpacity:false

    opacity:0

    Behavior on opacity{
        NumberAnimation {
            duration: 2*storedParameters.animationsStep;
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
        txtTimer.start();
        opacity=1;
    }

    function resetAnimation(){
        txtTimer.stop();
        stpCounter=0;
        text="";
        opacity=0;
    }

}
