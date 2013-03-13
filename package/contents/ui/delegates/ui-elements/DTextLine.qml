// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.qtextracomponents 0.1
import "../../../code/settings.js" as Settings

Item{
    id:container

    property alias text : mainIText.text

    property string acceptedText : ""
    property bool containsMouse: (mouseAreaFull.containsMouse ||
                                 tick2MouseArea.containsMouse)

    property alias focused: mainIText.activeFocus
    property alias tooltipItem: mouseAreaFull

    signal entered();
    signal exited();
    signal textAcceptedSignal(string finalText);

    onFocusedChanged: {
        if(!focused){
                textWasNotAccepted();
        }
    }

    Component.onCompleted: {
        acceptedText = container.text;
    }

    BorderImage{
        id:backIImage
        source: tick2MouseArea.containsMouse ? hoverSource : initSource

        border.left: 15; border.top: 15;
        border.right: 40; border.bottom: 15;
        horizontalTileMode: BorderImage.Repeat
        verticalTileMode: BorderImage.Repeat

        width:parent.width
        height:parent.height

        opacity: container.focused ? 1 : 0.001

        property string initSource:"../../Images/buttons/editBox2.png"
        property string hoverSource:"../../Images/buttons/editBoxHover2.png"

        Behavior on opacity{
            NumberAnimation {
                duration: Settings.global.animationStep;
                easing.type: Easing.InOutQuad;
            }
        }

    }

    PlasmaComponents.Label {
         id:mainTextLabel
         text:mainIText.text
         width:mainIText.width+17
         font.italic: mainIText.font.italic
         font.pixelSize: 1.02 * mainIText.font.pixelSize

         color:Settings.global.disableBackground ? theme.textColor : mainIText.color
         elide:Text.ElideRight
         anchors {left:parent.left; top: parent.top; leftMargin:10; topMargin:5}

         property real notEditingOpacities: mainWorkArea.isFilteredNoResults ? 0.3 : 1

         opacity: container.focused ? 0 : notEditingOpacities
    }

    TextInput {
        id:mainIText
        width:container.width - 45

        property int space:0
        property int vspace:15

        font.family: theme.defaultFont.family
        font.italic: true

        font.pixelSize: (0.4)*parent.height

        color: activeFocus ? activColor : origColor

        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.verticalCenter: backIImage.verticalCenter

        focus:true
        opacity: activeFocus ? 1 : 0.001

        property color origColor: "#323232"
        property color activColor: "#444444"

        Behavior on color{
            ColorAnimation {
                duration: 2*Settings.global.animationStep;
                easing.type: Easing.InOutQuad;
            }
        }

        Behavior on width{
            NumberAnimation {
                duration: 2*Settings.global.animationStep;
                easing.type: Easing.InOutQuad;
            }
        }

        Behavior on height{
            NumberAnimation {
                duration: 2*Settings.global.animationStep;
                easing.type: Easing.InOutQuad;
            }
        }

        //from: http://qt.gitorious.org/qt-components/qt-components/blobs/1be426261941ce4751dbda11b3a6c2b974646225/components/behaviors/TextEditMouseBehavior.qml
        function characterPositionAt(mouse) {
            var mappedMouse = mapToItem(mainIText, mouse.x, mouse.y);

            return mainIText.positionAt(mappedMouse.x, mappedMouse.y);
        }

        Keys.onUpPressed: { }
        Keys.onDownPressed: { }
        Keys.onPressed: {
            if ((event.key === Qt.Key_Enter)||(event.key === Qt.Key_Return)) {
                container.textWasAccepted();
                event.accepted = true;
            }
            else if (event.key === Qt.Key_Escape){
                mainView.forceActiveFocus();
            }
        }

    }

    Item{
        id:tickRectangleI
        width: 40
        height: parent.height
        anchors.right: parent.right

        Image{
            id:tickIImage;

            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            source: tick2MouseArea.containsMouse ? hoverTick : initTick
            opacity: container.focused ? 1 : 0
            width: parent.width - 15
            height: 0.75*width
            smooth:true

            property string initTick:"../../Images/buttons/darkTick.png"
            property string hoverTick:"../../Images/buttons/lightTick.png"
        }

        MouseArea{
            id:tick2MouseArea
            anchors.fill: parent
            hoverEnabled: true

            onEntered: container.entered();
            onExited: container.exited();

            onClicked: {
                container.textWasAccepted();
            }
        }

    }

    QIconItem {
        id:pencilI
        anchors.right: container.right
        width: 0.6 * container.height
        height:0.66 * container.height
        icon: QIcon("im-status-message-edit")
        opacity: container.containsMouse && (!container.focused) ? 1 : 0
        smooth:true

        Behavior on opacity{
            NumberAnimation {
                duration: 2*Settings.global.animationStep;
                easing.type: Easing.InOutQuad;
            }
        }

    }

    MouseArea{
        id:mouseAreaFull
        width: container.focused ? parent.width - 40 : parent.width
        height: parent.height

        hoverEnabled: true

        onEntered: container.entered();
        onExited: container.exited();

        onClicked: {
            container.clickedFunction(mouse);
        }
    }

    function clickedFunction(mouse){
        var pos = mainIText.characterPositionAt(mouse);
        mainIText.cursorPosition = pos;
        mainIText.forceActiveFocus();

        container.acceptedText = container.text
    }

    function textWasAccepted(){
        container.acceptedText = container.text;
        mainView.forceActiveFocus();
        container.textAcceptedSignal(container.acceptedText);
    }


    function textWasNotAccepted(){
        container.text = container.acceptedText
        mainView.forceActiveFocus();
    }

}
