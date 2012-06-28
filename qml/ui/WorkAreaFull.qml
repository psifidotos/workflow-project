// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import ".."
import "../delegates/ui-elements"

Item {
    id: competRect

    property int fX
    property int fY
    property int fWidth
    property int fHeight

    property int eX:0
    property int eY:0
    property int eWidth:mainView.width
    property int eHeight:mainView.height

    property alias imgSrc : workImg.mainImgP
    property alias wrkTxt : workAreaTxt.text

    state:"hide"

    property int buttonsSize: 50

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onClicked: {
            competRect.changeState();
        }
    }

    WorkAreaFullBack{
        id:workImg
        anchors.fill: parent

        Text{
            id:workAreaTxt

            wrapMode: TextEdit.Wrap

            font.family: "Helvetica"
            font.bold: true
            font.italic: true
            font.pointSize: 12+(mainView.scaleMeter/10)
            anchors.bottom: workImg.bottom
            anchors.bottomMargin: 15
            anchors.left: workImg.left
            anchors.leftMargin: 15

            color:"#f2f2f2"
        }

        CloseWindowButton{
            id:closeBtn3

            width: competRect.buttonsSize
            height: width

            anchors.right: parent.right
            anchors.rightMargin: 15
            anchors.top: parent.top
            anchors.topMargin: 15

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onEntered: {
                    closeBtn3.onEntered();
                }

                onExited: {
                    closeBtn3.onExited();
                }

                onReleased: {
                    closeBtn3.onReleased();
                }

                onPressed: {
                    closeBtn3.onPressed();
                }

                onClicked: {
                    closeBtn3.onClicked();
                    competRect.changeState();
                }

            }

        }
    }

    states: [
        State {
            name: "show"

            PropertyChanges {
                target: competRect

                x:eX
                y:eY
                width:eWidth
                height:eHeight
                opacity:1
            }
        },
        State {
            name: "hide"
            PropertyChanges {
                target: competRect

                x:fX
                y:fY
                width:fWidth
                height:fHeight
                opacity:0
            }
        }
    ]

    transitions: [

        Transition {
            from:"hide"; to:"show"
            reversible: true

            ParallelAnimation{
                NumberAnimation {
                    target: competRect;
                    property: "opacity";
                    duration: 400;
                    easing.type: Easing.InOutQuad;
                }
                NumberAnimation {
                    target: competRect;
                    property: "x";
                    duration: 400;
                    easing.type: Easing.InOutQuad;
                }
                NumberAnimation {
                    target: competRect;
                    property: "y";
                    duration: 400;
                    easing.type: Easing.InOutQuad;
                }
                NumberAnimation {
                    target: competRect;
                    property: "width";
                    duration: 400;
                    easing.type: Easing.InOutQuad;
                }
                NumberAnimation {
                    target: competRect;
                    property: "height";
                    duration: 400;
                    easing.type: Easing.InOutQuad;
                }


            }
        }
    ]

    function setInitPosition(coord,w1,h1,src,title){
        competRect.fX = coord.x;
        competRect.fY = coord.y;
        competRect.fWidth = w1;
        competRect.fHeight = h1;
        competRect.imgSrc = src;
        competRect.wrkTxt = title;

        competRect.x = coord.x;
        competRect.y = coord.y;
        competRect.width = w1;
        competRect.height = h1;

        competRect.opacity = 0;
    }

    function changeState(){
        if ( competRect.state === "hide" )
            competRect.state = "show";
        else
            competRect.state = "hide";

    }
}
