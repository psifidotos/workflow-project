// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import "../delegates/ui-elements"

import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.qtextracomponents 0.1

Rectangle{
    id:templDialog


    /*property alias insideWidth: dialogInsideRect.width
    property alias insideHeight: dialogInsideRect.height*/

    property int insideWidth: 200
    property int insideHeight: 200
    property int spaceX:5
    property int spaceY:15

    property int insideX: templMainDialog.x+dialogInsideRect.x + spaceX
    property int insideY: templMainDialog.y+dialogInsideRect.y+titleMesg.height+spaceY

    property alias dialogTitle: titleMesg.text

    visible:false

    property bool showButtons:true

    signal clickedOk
    signal clickedCancel
    signal completed

    property bool isModal:true

    width:mainView.width
    height:mainView.height

    color:isModal === true ? "#30333333" : "#00000000"

    Behavior on opacity{
        NumberAnimation {
            duration: 2*mainView.animationsStep;
            easing.type: Easing.InOutQuad;
        }
    }

    MouseArea{
        anchors.fill: parent
        hoverEnabled: templDialog.isModal
        enabled:templDialog.isModal
    }

    BorderImage {
        id:templMainDialog
        source: "../Images/buttons/selectedGrey.png"

        border.left: 70; border.top: 70;
        border.right: 80; border.bottom: 70;
        horizontalTileMode: BorderImage.Repeat
        verticalTileMode: BorderImage.Repeat

        width:templDialog.insideWidth+105+4*templDialog.spaceX
        height:templDialog.insideHeight+105+titleMesg.height+2*templDialog.spaceY

        anchors.centerIn: parent

        Behavior on width{
            NumberAnimation {
                duration: mainView.animationsStep;
                easing.type: Easing.InOutQuad;
            }
        }
        Behavior on height{
            NumberAnimation {
                duration: mainView.animationsStep;
                easing.type: Easing.InOutQuad;
            }
        }
        Behavior on x{
            NumberAnimation {
                duration: mainView.animationsStep;
                easing.type: Easing.InOutQuad;
            }
        }
        Behavior on y{
            NumberAnimation {
                duration: mainView.animationsStep;
                easing.type: Easing.InOutQuad;
            }
        }
        Rectangle{
            id:dialogInsideRect

            property real defOpacity:0.5

            color:"#d5333333"
            border.color: "#aaaaaa"
            border.width: 2
            radius:15

            width:parent.width - 105
            height:parent.height - 105

            anchors.centerIn: parent
     //       width:templDialog.insideWidth - templDialog.spaceX
      //      height:tempDialog.insideHeight - templDialog.spaceY
            //width: parent.width+200
            //height: parent.height+200
            //width:300
            //height:300
            //property int inWidth
            //property int inHeight

            //x:105/2
            //y:105/2

         //   width:mainTextInf.width+100
         //   height:infIcon.height+90

            //Title
            Text{
                id:titleMesg
                color:"#ffffff"
                width:parent.width
                horizontalAlignment:Text.AlignHCenter
                anchors.top:parent.top
                anchors.topMargin: 5
                font.family: mainView.defaultFont.family
                font.bold: true
                font.italic: true

                font.pixelSize: (0.3+mainView.defFontRelStep)*templMainDialog.border.top
            }

            Rectangle{
                anchors.top:titleMesg.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                width:0.93*parent.width
                color:"#ffffff"
                opacity:0.3
                height:1
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
                    text:i18n("Yes")
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
                    text:i18n("No")
                    iconSource:instanceOfThemeList.icons.DialogCancel

                    visible:templDialog.showButtons === true ? true : false

                    onClicked:{
                        templDialog.clickedCancel();
                        templDialog.close();
                    }
                }
            }


        }

        CloseWindowButton{
            id:closeBtnGlb

            width: 38
            height: width
            anchors.right:parent.right
            anchors.top:parent.top
            anchors.rightMargin: 35
            anchors.topMargin: 36

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onEntered: {
                    closeBtnGlb.onEntered();
                }

                onExited: {
                    closeBtnGlb.onExited();
                }

                onReleased: {
                    closeBtnGlb.onReleased();
                }

                onPressed: {
                    closeBtnGlb.onPressed();
                }

                onClicked: {
                    closeBtnGlb.onClicked();

                    templDialog.clickedCancel();
                    templDialog.close();
                }


            }

        }

    }

    function open(){
        templDialog.visible = true;
    }
    function close(){
        templDialog.visible = false;
    }

}
