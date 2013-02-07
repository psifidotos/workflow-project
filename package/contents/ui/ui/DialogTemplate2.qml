// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import "../delegates/ui-elements"
import "../../code/settings.js" as Settings

import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.qtextracomponents 0.1


PlasmaCore.FrameSvgItem{
    id:templDialog
    imagePath:"opaque/dialogs/background"

    /*property alias insideWidth: dialogInsideRect.width
    property alias insideHeight: dialogInsideRect.height*/

    property int insideWidth: 200
    property int insideHeight: 200
    property int spaceX:10
    property int spaceY:30


    //    property int insideX: templMainDialog.x+dialogInsideRect.x + spaceX
    //    property int insideY: templMainDialog.y+dialogInsideRect.y+titleMesg.height+spaceY

    property int insideX: spaceX
    property int insideY: spaceY

    property color defColor:"#ffffff"

    property alias dialogTitle: titleMesg.text
    property alias closeBtnSize: closeBtnGlb.width

    visible:false

    property bool showButtons:true
    property bool showTitleLine:true
    property bool yesNoButtons:true

    signal clickedOk
    signal clickedCancel
    signal completed

    property bool isModal:true
    property bool forceModality:true

    // width:mainView.width
    //  height:mainView.height
    width:insideWidth+2*spaceX
    height:insideHeight+2*spaceY

    //   color:isModal === true ? "#30333333" : "#00000000"

    Behavior on opacity{
        NumberAnimation {
            duration: 2*Settings.global.animationStep;
            easing.type: Easing.InOutQuad;
        }
    }

    Rectangle{
        width:mainView.width
        height:mainView.height
        color:"#10333333"
        anchors.centerIn: parent
        MouseArea{
            anchors.fill: parent
            hoverEnabled: templDialog.isModal
            enabled:templDialog.isModal

            onClicked:{
                if(!forceModality)
                    clickedCancel();
            }
        }
    }

    MouseArea{
        anchors.fill: parent
    }

    Item{
        id:templMainDialog

        width:templDialog.insideWidth+2*templDialog.spaceX
        height:templDialog.insideHeight+2*templDialog.spaceY
        focus:true

        Behavior on width{
            NumberAnimation {
                duration: Settings.global.animationStep;
                easing.type: Easing.InOutQuad;
            }
        }
        Behavior on height{
            NumberAnimation {
                duration: Settings.global.animationStep;
                easing.type: Easing.InOutQuad;
            }
        }
        Behavior on x{
            NumberAnimation {
                duration: Settings.global.animationStep;
                easing.type: Easing.InOutQuad;
            }
        }
        Behavior on y{
            NumberAnimation {
                duration: Settings.global.animationStep;
                easing.type: Easing.InOutQuad;
            }
        }
        //Rectangle{
        Item{
            id:dialogInsideRect

            property real defOpacity:0.5

            width:parent.width
            height:parent.height


            anchors.centerIn: parent

            //Title
            Text{
                id:titleMesg
                //color:"#ffffff"
                color:defColor

                width:parent.width
                horizontalAlignment:Text.AlignHCenter
                anchors.top:parent.top
                anchors.topMargin: templDialog.margins.top
                font.family: theme.defaultFont.family
                font.bold: true
                font.italic: true

                font.pixelSize: (0.65)*templDialog.spaceY
            }

            Rectangle{
                anchors.top:titleMesg.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                width:0.95*parent.width
                color:defColor
                opacity:0.3
                height:1
                visible:templDialog.showTitleLine
            }

            //Buttons

            Item{
                anchors.bottom: dialogInsideRect.bottom
                anchors.bottomMargin:10
                anchors.right: parent.right
                anchors.rightMargin: 10
                height:30
                width:parent.width

                PlasmaComponents.Button{
                    id:button1
                    anchors.right: button2.left
                    anchors.rightMargin: 10
                    anchors.bottom: parent.bottom
                    width:100
                    text:yesNoButtons === true ? i18n("Yes") : i18n("Ok")
                    iconSource:instanceOfThemeList.icons.DialogAccept

                    visible:templDialog.showButtons === true ? true : false

                    onClicked:{
                        templDialog.clickedOk();
                        templDialog.close();
                    }
                }

                PlasmaComponents.Button{
                    id:button2
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    width:100
                    text:yesNoButtons === true ? i18n("No") :i18n("Cancel")
                    iconSource:instanceOfThemeList.icons.DialogCancel

                    visible:templDialog.showButtons === true ? true : false

                    onClicked:{
                        templDialog.clickedCancel();
                        templDialog.close();
                    }
                }
            }


        }

    }

    Item{
        id:positionHelper
        width:closeBtnGlb.width
        height:closeBtnGlb.height
        anchors.bottom: parent.top
        anchors.right: parent.right
        anchors.rightMargin: 0.5*width

    }

    CloseWindowButton{
        id:closeBtnGlb

        width: 38
        height: width

        //            y:-height/2
        //          x:parent.width+width/2
        anchors.top:positionHelper.top
        anchors.topMargin: 0.45*height
        anchors.left: positionHelper.right

        // anchors.right: parent.right
        // anchors.top: parent.top
        // anchors.rightMargin: 0
        // anchors.topMargin: 0

        onClicked: {
            templDialog.clickedCancel();
            templDialog.close();
        }


    }

    function open(){
        templDialog.visible = true;
        templDialog.forceActiveFocus();
    }
    function close(){
        templDialog.visible = false;
        mainView.forceActiveFocus();
    }

    /*******************/

    Keys.onLeftPressed: { }
    Keys.onRightPressed: { }
    Keys.onUpPressed: { }
    Keys.onDownPressed: { }
    Keys.onReturnPressed: { }
    Keys.onEnterPressed: { }
    Keys.onEscapePressed: { }
    Keys.onPressed: {
        if(event.key === Qt.Key_H){}
        else if(event.key === Qt.Key_J){}
        else if(event.key === Qt.Key_K){}
        else if(event.key === Qt.Key_L){}
        else if(event.key === Qt.Key_Pause){}
        else if(event.key === Qt.Key_Slash){}
    }

}
