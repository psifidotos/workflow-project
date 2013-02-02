// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import org.kde.qtextracomponents 0.1

import "../../../code/settings.js" as Settings
import "../../components"

Item{
    id:container

    property alias text : mainText.text

    property string acceptedText : ""
    property bool containsMouse: (tickMouseArea.containsMouse ||
                                  mainTextMouseArea.containsMouse)

    property bool enableEditing: !Settings.global.lockActivities
    property alias focused : mainText.activeFocus
    property alias tooltipItem : mainTextMouseArea

    property int nHeight

    signal entered();
    signal exited();
    signal textAcceptedSignal(string finalText);

    onFocusedChanged: {
        if(!focused){
            textWasNotAccepted();
        }
    }

    onEnableEditingChanged:{
        if (container.focused){
            container.textWasNotAccepted();
        }
    }

    Component.onCompleted: {
        acceptedText = container.text;
    }

    BorderImage{
        id:backImage
        y:3
        source: tickMouseArea.containsMouse ? hoverSource : initSource
        opacity: container.focused ? 1 : 0.001


        border.left: 15; border.top: 15;
        border.right: 40; border.bottom: 15;
        horizontalTileMode: BorderImage.Repeat
        verticalTileMode: BorderImage.Repeat

        width:parent.width
        height:parent.height

        property string initSource:"../../Images/buttons/editBox2.png"
        property string hoverSource:"../../Images/buttons/editBoxHover2.png"

        Behavior on opacity{
            NumberAnimation {
                duration: Settings.global.animationStep;
                easing.type: Easing.InOutQuad;
            }
        }

        Item{
            id:tickRectangle
            width: 40
            height: parent.height
            anchors.right: parent.right

            Image{
                id:tickImage;
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - 15
                height: 0.75*width
                smooth:true

                source: tickMouseArea.containsMouse ? hoverTick : initTick
                opacity: container.focused ? 1 : 0

                property string initTick:"../../Images/buttons/darkTick.png"
                property string hoverTick:"../../Images/buttons/lightTick.png"
            }

            MouseArea{
                id:tickMouseArea
                anchors.fill: parent
                hoverEnabled: true

                onEntered: container.entered();
                onExited: container.exited();

                onClicked: {
                    if (container.enableEditing)
                        container.textWasAccepted();
                }
            }
        }
    }

    QIconItem {
        id:pencilImg
        anchors.right: container.right
        anchors.rightMargin: 10
        anchors.bottom: container.bottom
        anchors.bottomMargin: 3

        width:0.4*container.height
        height:1.15*width
        //height:container.height / 2
        icon: QIcon("im-status-message-edit")
        opacity: container.containsMouse && !container.focused && !mainTextMouseArea.inDragging && container.enableEditing ? 1 : 0
        smooth:true

        Behavior on opacity{
            NumberAnimation {
                duration: 2*Settings.global.animationStep;
                easing.type: Easing.InOutQuad;
            }
        }
    }

    Text{
        id:mainTextLabel2

        text:mainText.text
        width: container.width-5
        height: container.nHeight
        opacity: container.focused ? 0 : 1
        color: mainText.color
        verticalAlignment: mainText.verticalAlignment
        wrapMode: Text.Wrap
        maximumLineCount: 2
        elide:Text.ElideRight

        font{family: mainText.font.family; pixelSize: (0.22+mainView.defFontRelStep)*actImag1.height; bold: mainText.font.bold; italic: mainText.font.italic}
        anchors{left:parent.left; bottom: backImage.bottom; leftMargin: 8; bottomMargin: 8}
    }

    TextEdit {
        id:mainText
        property int space:0;

        width:container.width - 36;
        height: container.nHeight - 30;

        wrapMode: TextEdit.Wrap

        font.family: mainView.defaultFont.family
        font.bold: true
        font.italic: true

        font.pixelSize: 0.9*mainTextLabel2.font.pixelSize

        color: activeFocus ? activColor : origColor
        verticalAlignment: TextEdit.AlignBottom

        opacity: activeFocus ? 1 : 0.001
        visible: container.enableEditing ? true : false
        //visible: mainTextLabel2.opacity === 0 ? 1 : 0

        anchors.left: parent.left
        anchors.leftMargin: 8
        anchors.bottom: backImage.bottom
        anchors.bottomMargin: 8

        focus:true
        //  readOnly: !container.enableEditing
        //   enabled: container.enableEditing

        property color origColor: "#f0f0f0"
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
            var mappedMouse = mapToItem(mainText, mouse.x, mouse.y);

            return mainText.positionAt(mappedMouse.x, mappedMouse.y);
        }

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

    DraggingMouseArea{
        id:mainTextMouseArea
        anchors.left: parent.left
        width: container.focused ? parent.width - 35 : parent.width
        height: parent.height

        draggingInterface: draggingActivities

        onEntered: container.entered();
        onExited: container.exited();

        onInDraggingChanged: {
            if(inDragging)
                textWasNotAccepted();
        }

        onClickedOverrideSignal: {
            if(!inDragging){
                if(container.enableEditing)
                    container.clickedFunction(mouse);
                else
                    workflowManager.activityManager().setCurrent(code);
            }
        }

        onDraggingStarted: {
            if(!Settings.global.lockActivities){
                var coords = mapToItem(mainView, mouse.x, mouse.y);
                draggingActivities.enableDragging(mouse, coords, code, "Running", Icon);
            }
        }
    }


    function clickedFunction(mouse){
        mainText.forceActiveFocus();
        var pos = mainText.characterPositionAt(mouse);
        mainText.cursorPosition = pos;
        container.acceptedText = container.text
    }

    function textWasAccepted(){
        container.acceptedText = container.text;
        mainView.forceActiveFocus();
        container.textAcceptedSignal(container.acceptedText);
    }

    function textWasNotAccepted(){
        container.text = container.acceptedText;
        mainView.forceActiveFocus();
    }


}

