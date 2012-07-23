// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.qtextracomponents 0.1

BorderImage {
    id:templDialog
    source: "../Images/buttons/selectedGrey.png"

    // property int tempMeter: mainView.scaleMeter/5;

    border.left: 70; border.top: 70;
    border.right: 80; border.bottom: 70;
    horizontalTileMode: BorderImage.Repeat
    verticalTileMode: BorderImage.Repeat

    visible:false

    //TO MOVE IN OFFICIAL REMOVE DIALOG
    //anchors.centerIn: mainView
    //property string activityCode
    //property string activityName

    width:insideWidth+105
    height:insideHeight+105

    property alias insideWidth: dialogInsideRect.width
    property alias insideHeight: dialogInsideRect.height
    property alias insideX: dialogInsideRect.x
    property alias insideY: dialogInsideRect.y

    property alias dialogTitle: titleMesg.text

    signal clickedOk
    signal clickedCancel


    Rectangle{
        id:dialogInsideRect
        //     visualParent:mainView


       // x:65
    //    y:60
        anchors.centerIn: parent

        property real defOpacity:0.5

        color:"#d5333333"
        border.color: "#aaaaaa"
        border.width: 2
        radius:15

        width:mainTextInf.width+100
        height:infIcon.height+90

        //Title
        Text{
            id:titleMesg
            color:"#ffffff"
            width:parent.width
            horizontalAlignment:Text.AlignHCenter
            anchors.top:parent.top
            anchors.topMargin: 5
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
                iconSource:"dialog-apply"

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
                iconSource:"editdelete"

                onClicked:{
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
