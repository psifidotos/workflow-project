import QtQuick 1.1

MouseArea {
    id:area
    anchors.fill: parent
    hoverEnabled: true

    property int px1:0
    property int py1:0
    property bool tempPressed:false
    property int draggingSpace:2

    property bool isPressed:false

    signal draggingStarted(variant mouse);
    signal draggingMovement(variant mouse);
    signal draggingEnded(variant mouse);

    onClicked: {
        tempPressed = false;
    }

    onPressed:{
        px1 = mouse.x;
        py1 = mouse.y;

        tempPressed = true;
    }

    onPositionChanged: {
        if(outOfInnerLimits(mouse)&&(tempPressed)){
            draggingStarted(mouse);
            tempPressed = false;
            isPressed = true;
        }

        if(isPressed){
            draggingMovement(mouse);
        }
    }

    onReleased:{
        draggingEnded(mouse);
        isPressed = false;
    }

    function outOfInnerLimits(ms){
        if((ms.x<px1-draggingSpace)||(ms.x>px1+draggingSpace)||
                (ms.y<py1-draggingSpace)||(ms.y>py1+draggingSpace))
            return true;
        else
            return false;
    }

}

