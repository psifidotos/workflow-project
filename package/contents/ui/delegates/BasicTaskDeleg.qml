import QtQuick 1.1

import "../components"
import "ui-elements"
import ".."
import "../../code/settings.js" as Settings

//import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.qtextracomponents 0.1

Item{
    id: container

    property string ccode: code
    property string cActCode: ((activities === undefined) || (activities[0] === undefined) ) ?
                                  sessionParameters.currentActivity : activities[0]
    property int cDesktop:desktop === undefined ? sessionParameters.currentDesktop : desktop

    property int iconWidth:80

    property string selectedWin: ""
    property bool isSelected: selectedWin === ccode

    property color taskTitleTextDef
    property color taskTitleTextHov
    property color taskTitleTextSel

    property bool containsMouse : hoverArea.containsMouse

    signal taskClicked(string win);

    state:"default"


    Rectangle{
        id:taskHoverRect
        width:parent.width-2*border.width
        height:parent.height
        radius:5
        color:container.isSelected === false ? "#30ffffff" : "#a2222222"
        border.width: 1
        border.color: "#aaffffff"
    }

    QIconItem{
        id:imageTask2
        smooth:true
        icon: Icon

        height: width

        Behavior on width{
            NumberAnimation{
                duration: Settings.global.animationStep;  easing.type: Easing.InOutQuad;
            }
        }
        Behavior on x{
            NumberAnimation{
                duration: Settings.global.animationStep;  easing.type: Easing.InOutQuad;
            }
        }
        Behavior on y{
            NumberAnimation{
                duration: Settings.global.animationStep;  easing.type: Easing.InOutQuad;
            }
        }
    }


    QIconItem{
        id:imageTask2Ref
        icon: Icon
        x:imageTask2.x
        y:imageTask2.y+2*imageTask2.height
        width:imageTask2.width
        height:imageTask2.height
        transform: Rotation {  axis { x: 1; y: 0; z: 0 } angle: 180 }
        opacity:0.15
    }

    Rectangle{
        id: taskTitleRec
        height:taskTitle2.height
        color:"#00ffffff"
        anchors.left: imageTask2.right
        anchors.bottom: imageTask2.bottom

        Behavior on x{
            NumberAnimation{
                duration: Settings.global.animationStep;  easing.type: Easing.InOutQuad;
            }
        }
        Behavior on y{
            NumberAnimation{
                duration: Settings.global.animationStep;  easing.type: Easing.InOutQuad;
            }
        }
        Behavior on width{
            NumberAnimation{
                duration: Settings.global.animationStep;  easing.type: Easing.InOutQuad;
            }
        }
        Behavior on opacity{
            NumberAnimation{
                duration: Settings.global.animationStep;  easing.type: Easing.InOutQuad;
            }
        }
        Text{
            id:taskTitle2

            anchors.horizontalCenter: parent.horizontalCenter

            text:name === undefined ? "" : name
            font.family: mainView.defaultFont.family
            font.italic: container.isSelected === true ? true : false
            font.bold: true

            elide:Text.ElideRight
            width:parent.width
        }
    }

    MouseArea{
        id:hoverArea
        anchors.fill: parent
        hoverEnabled: true

        onClicked: {
            taskClicked(ccode);
        }
    }

    states: [
        State {
            name: "default"
            when: !container.containsMouse
            PropertyChanges{
                target: imageTask2
                width: 0.6 * container.height
                x:10
                y:(0.4 *container.height) / 2
                opacity:1
            }
            PropertyChanges{
                target:taskTitleRec
                color: "#00e2e2e2"
                width: container.width - 0.6*container.height - 10
                opacity: container.isSelected === false ? 0.7 : 1
            }
            PropertyChanges{
                target:taskTitle2
                color:container.isSelected===false ? container.taskTitleTextDef: container.taskTitleTextSel
                font.pixelSize: Math.max((0.28+mainView.defFontRelStep)*container.height,15)
            }
            PropertyChanges{
                target:taskHoverRect
                opacity:container.isSelected===false ? 0.001 : 1
            }
        },
        State {
            name: "hovered"
            when: container.containsMouse
            PropertyChanges{
                target:imageTask2
                width: 0.8*container.height
                x:10
                y:(0.2*container.height) / 2
            }

            PropertyChanges{
                target:taskTitleRec
                width: container.width - 0.8*container.height - 10
                opacity: 1
            }
            PropertyChanges{
                target:taskTitle2
                color:container.isSelected===false ? container.taskTitleTextHov : container.taskTitleTextSel
                font.pixelSize: Math.max((0.28+mainView.defFontRelStep)*container.height, 15)
                opacity: 1
            }
            PropertyChanges{
                target:taskHoverRect
                opacity:1
            }
        }


    ]

}
