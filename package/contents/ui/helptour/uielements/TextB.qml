// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import "../../../code/settings.js" as Settings

Text {

    font.family: "Sans"
    //color:"#fafafa"
    color:defColor
    wrapMode: Text.WordWrap


    Behavior on opacity{
        NumberAnimation {
            duration: 2*Settings.global.animationStep2;
            easing.type: Easing.InOutQuad;
        }
    }
}
