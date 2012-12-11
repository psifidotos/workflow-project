// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Text {

    font.family: "Sans"
    //color:"#fafafa"
    color:defColor
    wrapMode: Text.WordWrap


    Behavior on opacity{
        NumberAnimation {
            duration: 2*parametersManager.animationsStep;
            easing.type: Easing.InOutQuad;
        }
    }
}
