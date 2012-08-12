// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import "ui"

import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.qtextracomponents 0.1

Rectangle{
    id:oxygenTitle
    anchors.top:parent.top
    width:mainView.width
    color:"#dcdcdc"
    height: workareaY/3

    property alias lockerChecked:lockerToolBtn.checked
    property alias windowsChecked:windowsToolBtn.checked
    property alias effectsChecked:effectsToolBtn.checked

    property int buttonWidth:1.6 * oxygenTitle.height
    //property int buttonHeight:1.07 * oxygenTitle.height
    property int buttonHeight:oxygenTitle.height + 3

    Rectangle{
        id:mainRect
        anchors.top: oxygenTitle.bottom
        width:oxygenTitle.width
        height:oxygenTitle.height/2
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#aa0f0f0f" }
            GradientStop { position: 1.0; color: "#00797979" }
        }
    }

    Rectangle{
        y:parent.height

        height:parent.width
        width:parent.height

        rotation: -90
        transformOrigin: Item.TopLeft

        gradient: Gradient {
            GradientStop { position: 0.0; color:"#00ffffff" }
            GradientStop { position: 0.35; color: "#ffffffff" }
            GradientStop { position: 0.65; color: "#ffffffff" }
            GradientStop { position: 1.0; color: "#00ffffff" }
        }

    }


    Text{
        anchors.top:oxygenTitle.top
        anchors.horizontalCenter: oxygenTitle.horizontalCenter
        text:"   "
        font.family: "Helvetica"
        font.italic: true
        font.pointSize: 5+mainView.scaleMeter/10
        color:"#777777"
    }


    Row{
        x: 0.7 * oxygenTitle.height
        y: -4
        spacing:0.25 * oxygenTitle.height < 8 ? 8 : 0.25*oxygenTitle.height

        //First Button///////
        Rectangle{
            radius:4
            width:oxygenTitle.buttonWidth-6
            height:oxygenTitle.buttonHeight-2
            border.width: 2
            border.color: "#cccccc"
            color:"#00ffffff"
            opacity:1

            PlasmaComponents.ToolButton{
                id:lockerToolBtn
                anchors.centerIn: parent

                Image{
                    smooth:true
                    source:"Images/buttons/Padlock-gold.png"
                    anchors.centerIn: parent
                    width:0.8*parent.height
                    height:0.7*parent.height
                }

                width: oxygenTitle.buttonWidth
                height: oxygenTitle.buttonHeight

                checkable:true
                //  checked:mainView.lockActivities

                onCheckedChanged:{
                    mainView.lockActivities = checked;
                }
            }

        }

        //Second Button///////////
        Rectangle{
            radius:4
            width:oxygenTitle.buttonWidth-6
            height:oxygenTitle.buttonHeight-2
            border.width: 2
            border.color: "#cccccc"
            color:"#00ffffff"
            opacity:1

            PlasmaComponents.ToolButton{
                id:windowsToolBtn
                anchors.centerIn: parent

                Image{
                    smooth:true
                    source:"Images/buttons/blueWindowsIcon.png"
                    anchors.centerIn: parent
                    width:0.80*parent.height
                    height:0.68*parent.height

                }

                width: oxygenTitle.buttonWidth
                height: oxygenTitle.buttonHeight

                checkable:true
                // checked:mainView.showWinds

                onCheckedChanged:{
                    mainView.showWinds = checked;
                    if(!checked)
                        effectsToolBtn.checked = false;
                }
            }

        }

        //Third Button
        Rectangle{
            radius:4
            width:oxygenTitle.buttonWidth-6
            height:oxygenTitle.buttonHeight-2
            border.width: 2
            border.color: "#cccccc"
            color:"#00ffffff"
            opacity:1

            PlasmaComponents.ToolButton{
                id:effectsToolBtn

                anchors.centerIn: parent

                Image{
                    smooth:true
                    source:"Images/buttons/tools_wizard.png"
                    anchors.centerIn: parent
                    width:0.80*parent.height
                    height:0.65*parent.height

                    Image{
                        smooth:true
                        height:0.3*parent.height
                        width:1.42*height

                        x:-width/3
                        y:parent.height- 0.6*height

                        source:"Images/buttons/downIndicator.png"

                        opacity:0.6
                    }
                }

                MouseArea{
                    anchors.fill:parent
                    onClicked:{
                        effectsToolBtn.checked = !effectsToolBtn.checked;
                    }

                    onPressAndHold: {
                        if(!effectsToolBtn.checked)
                            effectsToolBtn.checked = true;

                        mainView.getDynLib().showCalibrationDialog();
                    }
                }

                width: oxygenTitle.buttonWidth
                height: oxygenTitle.buttonHeight

                checkable:true
                //checked: (mainView.enablePreviews&&())
                enabled:((mainView.isOnDashBoard)&&
                         (mainView.showWinds)&&
                         (mainView.effectsSystemEnabled))

                onCheckedChanged:{
                    mainView.enablePreviews = checked;
                }

            }

        }

    }// End Of Left Set of Buttons // Row

    Text{
        id:helpBtn
        text:"?"
        font.family: "Serif"
        font.pixelSize: 0.75*oxygenTitle.height

        color:"#444444"
        opacity:defOpacity
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter

        property real defOpacity:0.6

        MouseArea {
            anchors.fill: parent

            hoverEnabled: true

            onEntered: {
                helpBtn.opacity = 1;
                helpBtn.font.bold = true;
            }

            onExited: {
                helpBtn.opacity = helpBtn.defOpacity;
                helpBtn.font.bold = false;
            }


            onClicked: {
                //calibrationDialog.openD();
                //liveTourDialog.opacity = 1;
                mainView.getDynLib().showLiveTourDialog();
            }

        }

    }

}
