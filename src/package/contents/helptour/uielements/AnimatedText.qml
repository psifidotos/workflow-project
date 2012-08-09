// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Text {
    Timer{
        id:txtTimer
        interval:20
        repeat:true
        onTriggered: {
            parent.stepAnimation();
        }
    }

    property string fullText

    property int stpCounter;

    font.family: "Helvetica"
    color:"#f5f5f5"
    wrapMode:Text.WordWrap

    function stepAnimation(){
        if (stpCounter >= fullText.length-1){
            txtTimer.stop();
            text = fullText.substring(0,fullText.length);
        }
        else{
            text = fullText.substring(0,stpCounter)+"_";
            stpCounter++;
        }
    }

    function startAnimation(){
        txtTimer.start();
    }

    function resetAnimation(){
        txtTimer.stop();
        stpCounter=0;
        text="";
    }

}
