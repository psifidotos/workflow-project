// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {

    id:mRect

    //property int defRotation



    property bool moveForward:false
    //  rotation:startRotation

    property int endRotation
    property int startRotation

    property int lengthEnd

    rotation:startRotation

    states: [
        State {
            name: "forward"
            when: moveForward === true
        },
        State {
            name: "backward"
            when: moveForward === false
        }
    ]

    transitions:[
        Transition{

            from:"backward"; to:"forward"
            SequentialAnimation{
                id:playRectAnimation1
                property int animationDur:750

                NumberAnimation {
                    target: mRect
                    property: mRect.height < 4 ? "width" : "height"
                    duration: playRectAnimation1.animationDur;
                    easing.type: Easing.InOutQuad;
                    to: mRect.lengthEnd
                }


                NumberAnimation {
                    target: mRect
                    property: "rotation";
                    duration: playRectAnimation1.animationDur;
                    easing.type: Easing.InOutQuad;
                    to: mRect.endRotation
                }
            }
        },
        Transition{

            from:"forward"; to:"backward"
            SequentialAnimation{

                NumberAnimation {
                    target: mRect
                    property: "rotation";
                    duration: playRectAnimation1.animationDur;
                    easing.type: Easing.InOutQuad;
                    to: mRect.startRotation
                }

                NumberAnimation {
                    target: mRect
                    property: mRect.height < 4 ? "width" : "height"
                    duration: playRectAnimation1.animationDur;
                    easing.type: Easing.InOutQuad;
                    to: 2
                }
            }
        }
    ]

    MouseArea{
        anchors.fill: parent
        hoverEnabled: true
        onEntered:{
            mRect.moveForward = !mRect.moveForward
        }

    }

}
