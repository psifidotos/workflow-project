// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import ".."
import "../ui"
import "ui-elements"


Item{
    id: taskDelegOr1

    property bool shown: ( (onAllActivities !== true)&&
                          ((desktop > workalist.model.count)&&
                           (workList.ccode === activities)) &&
                          (onAllDesktops !== true) )


    width: 0.9*orphansList.width

    height: shown? orphansList.windsHeight : 0
    opacity: shown ? 1 : 0
    state: "def"

    property string ccode:code

    property int buttonsSize: 1.2 * height

    property color taskTitleColorD : taskOrFTitle.color;
    property color taskTitleColorH : "#ffffff";

    property color taskTitleRecColorD : "#0000b110";
    property color taskTitleRecColorH : "#ff00b110";

    property alias taskTColor: taskOrTitle.color
    property alias taskTFontBold: taskOrTitle.font.bold
    property alias closeOpac: closeBtnOr.opacity
    property alias taskTitleRecCol: taskOrTitleRec.color

    property bool containsMouse: taskOrTitleRecMouseArea.containsMouse ||
                                 closeBtnOr.containsMouse


    Behavior on height{
        NumberAnimation {
            duration: 2*storedParameters.animationsStep2;
            easing.type: Easing.InOutQuad;
        }
    }

    Behavior on opacity{
        NumberAnimation {
            duration: 2*storedParameters.animationsStep2;
            easing.type: Easing.InOutQuad;
        }
    }

    onShownChanged: {
        if(shown)
            orphansList.shownOrphanWindows++;
        else
            orphansList.shownOrphanWindows--;
    }


    Rectangle{
        id:taskOrTitleRec
        width:parent.width
        height:parent.height
        radius: 0.4 * height

        property int toRX:x
        property int toRY:y


        Behavior on color{
            ColorAnimation {
                duration: 3*storedParameters.animationsStep
            }
        }

        Text{
            id:taskOrTitle

            width:parent.width - 5
            clip:true

            anchors.verticalCenter: parent.verticalCenter
            x : 5
            text:name || 0 ? name : ""
            font.family: mainView.defaultFont.family
            font.italic: true
            font.pixelSize: orphansList.fontSize


            elide:Text.ElideRight

            Behavior on color{
                ColorAnimation {
                    duration: 3*storedParameters.animationsStep
                }
            }


        }
        MouseArea {
            id:taskOrTitleRecMouseArea
            anchors.fill: parent
            hoverEnabled: true
        }
    }


    CloseWindowButton{
        id:closeBtnOr

        width: parent.buttonsSize
        height: width

        anchors.right: taskOrTitleRec.right

        y: - height/4

        onClicked: {
            instanceOfTasksList.removeTask(code);
            orphansList.changedOrphansWindows();
        }

    }

    states:[
        State {
            name: "def"
            when:!containsMouse
            PropertyChanges {
                target: taskDelegOr1
                taskTColor:taskDelegOr1.taskTitleColorD
                taskTFontBold: false
                closeOpac:0
                taskTitleRecCol: taskTitleRecColorD
            }
        },
        State {
            name:"hovered"
            when:containsMouse
            PropertyChanges {
                target: taskDelegOr1
                taskTColor:taskDelegOr1.taskTitleColorH
                taskTFontBold: true
                closeOpac:1
                taskTitleRecCol: taskTitleRecColorH
            }
        }

    ]

}

