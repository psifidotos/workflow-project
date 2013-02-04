import QtQuick 1.1

import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.qtextracomponents 0.1

import "../../code/settings.js" as Settings

BorderImage {
    id:container
    source: "../Images/buttons/selectedBlue.png"

    border.left: 50; border.top: 50;
    border.right: 60; border.bottom: 50;
    horizontalTileMode: BorderImage.Repeat
    verticalTileMode: BorderImage.Repeat

    x:0
    y:0
    width:0
    height:0

    opacity:0

    property int marginLeft: 25
    property int marginTop: 25
    property int marginWidth: 55
    property int marginHeight: 50

    Behavior on opacity{
        NumberAnimation {
            duration: 500;
            easing.type: Easing.InOutQuad;
        }
    }

    function setLocation(x1,y1,w1,h1){
        x= x1-marginLeft;
        y= y1-marginTop;
        width=w1+marginWidth;
        height=h1+marginHeight;
    }
}
