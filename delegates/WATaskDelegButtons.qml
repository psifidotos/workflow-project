// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item {
    id: buttonsArea
    width: mainWorkArea.imagewidth
    height: taskDeleg1.height
    state: "hide"

    property alias opacityClose: closeBtn.opacity
    property alias xClose: closeBtn.x

    property int buttonsSize:0.55*height
    property int buttonsSpace: buttonsSize/10

    Rectangle{
        id:closeBtn

        width: parent.buttonsSize
        height: width
        color: backDef
        border.color: "#616161"
        border.width: 1
        radius:4

        property color backDef: "#e4e4e4"
        property color backHover: "#fcd0d0"

        Image{
            source:"../Images/buttons/close_window.png"
            width:0.7 * parent.width
            height:width
            anchors.centerIn: parent
            smooth:true
        }

        Behavior on color{
            ColorAnimation {
                duration: 500
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onEntered: {
                buttonsArea.state = "show"
                closeBtn.color = closeBtn.backHover
            }

            onExited: {
                buttonsArea.state = "hide"
                closeBtn.color = closeBtn.backDef
            }
        }
    }

    states: [
        State {
            name: "show"

            PropertyChanges {
                target: buttonsArea

                opacityClose: 1
                xClose: width - buttonsSize - buttonsSpace
            }
        },
       State {
           name: "hide"
           PropertyChanges {
               target: buttonsArea

               opacityClose: 0
               xClose: 0
           }
        }
    ]

    transitions: [

        Transition {
            from:"hide"; to:"show"
            reversible: true
            SequentialAnimation{
                ParallelAnimation{
                    NumberAnimation {
                        target: buttonsArea;
                        property: "xClose";
                        duration: 300;
                        easing.type: Easing.InOutQuad;
                    }
                    NumberAnimation {
                        target: buttonsArea;
                        property: "opacityClose";
                        duration: 300;
                        easing.type: Easing.InOutQuad;
                    }
                }

            }
        }
    ]
/*
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onEntered: {
            buttonsArea.state = "show"
        }

        onExited: {
            buttonsArea.state = "hide"
        }
    }*/
}
