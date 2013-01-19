// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import "../../../code/settings.js" as Settings

Rectangle {

    id:mRect

    //property int defRotation

    //   property bool moveForward:false
    property string objectNameType:"AnimatedLine"

    property bool isVertical:false
    property int lengthEnd

    //  rotation:startRotation

    property int endRotation
    property int startRotation

    color:defColor

    rotation:startRotation
    state:"backward"

    states: [
        State {
            name: "forward"
        },
        State {
            name: "backward"
        }
    ]

    transitions:[
        Transition{

            from:"backward"; to:"forward"
            SequentialAnimation{
                id:playRectAnimation1
                property int animationDur: 2*Settings.global.animationStep2

                NumberAnimation {
                    target: mRect
                    property: "opacity"
                    duration: 0;
                    easing.type: Easing.InOutQuad;
                    to: 1
                }

                NumberAnimation {
                    target: mRect
                    property: isVertical === true ? "height" : "width"
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
                    property: isVertical === true ? "height" : "width"
                    duration: playRectAnimation1.animationDur;
                    easing.type: Easing.InOutQuad;
                    to: 2
                }

                NumberAnimation {
                    target: mRect
                    property: "opacity"
                    duration: 0;
                    easing.type: Easing.InOutQuad;
                    to: 0
                }

            }
        }
    ]

    function startAnimation(){
        mRect.state="forward";
    }

    function resetAnimation(){
        mRect.state="backward";
    }

}
