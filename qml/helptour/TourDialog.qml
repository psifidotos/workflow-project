// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import "uielements"

Rectangle {


    width:mainView.width
    height:mainView.height

    color: "#75333333"

    opacity:0

    Behavior on opacity{
        NumberAnimation {
            duration: 2*mainView.animationsStep;
            easing.type: Easing.InOutQuad;
        }
    }

    MouseArea{
        anchors.fill: parent
        onClicked:parent.opacity = 0;

    }


    NumberedList{
        id:nmList
        x:250
        y:200
        width:150
        texts:["asdfasdf","asdfasdf232323asdf","asdfasdf234","asdfasdf2323"]
    }

    AnimatedLine{
        height:3
        width:1

        x:100
        y:300


        lengthEnd:150

        transformOrigin: Item.BottomLeft

        moveForward: true

        startRotation:90
        endRotation: 0


        z:35

        onMoveForwardChanged: {
            if (moveForward === true){
                nmList.startAnimation();
            }
            else{
                nmList.resetAnimation();

            }

        }
    }
}
