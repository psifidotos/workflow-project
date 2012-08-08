// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1


Column{

    id:numList
    property variant texts
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
            duration: 2*mainView.animationsStep;
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
