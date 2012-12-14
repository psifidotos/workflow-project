// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import "ui"
import "tooltips"

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
                    id:lockerImg
                    smooth:true
                    source:"Images/buttons/Padlock-gold.png"
                    anchors.centerIn: parent
                    width:0.8*parent.height
                    height:0.7*parent.height
                }

                width: oxygenTitle.buttonWidth
                height: oxygenTitle.buttonHeight

                checkable:true
                checked: storedParameters.lockActivities

                MouseArea{
                    id:lockerToolBtnMouseArea
                    anchors.fill:parent

                    onClicked:{
                        //lockerToolBtn.checked = !lockerToolBtn.checked;
                        storedParameters.lockActivities = !storedParameters.lockActivities;
                    }
                }
            }

            DToolTip{
                title:i18n("Lock Activities")
                mainText: i18n("You can lock your Activities if you want. In Locked state only Pause and Restore actions are enabled.")
                target:lockerToolBtnMouseArea
                localIcon:lockerImg.source
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
                    id:windowsImg
                    smooth:true
                    source:"Images/buttons/blueWindowsIcon.png"
                    anchors.centerIn: parent
                    width:0.80*parent.height
                    height:0.68*parent.height

                }

                width: oxygenTitle.buttonWidth
                height: oxygenTitle.buttonHeight

                checkable:true
                checked:storedParameters.showWindows

                onCheckedChanged:{

                    if(!checked)
                        effectsToolBtn.checked = false;
                }

                MouseArea{
                    id:windowsToolBtnMouseArea
                    anchors.fill:parent

                    onClicked:{
                        //windowsToolBtn.checked = !windowsToolBtn.checked;
                        storedParameters.showWindows = !storedParameters.showWindows;
                    }
                }
            }

            DToolTip{
                title:i18n("Show/Hide Windows")
                mainText: i18n("You can show or hide all the windows shown in order to enhance your workflow.")
                target:windowsToolBtnMouseArea
                localIcon:windowsImg.source
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
                    id:effectsImg
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

                width: oxygenTitle.buttonWidth
                height: oxygenTitle.buttonHeight

                checkable:true
                checked:storedParameters.windowsPreviews
                //checked: (mainView.enablePreviews&&())
              //  enabled:((mainView.isOnDashBoard)&&
                  enabled:((storedParameters.showWindows)&&
                            (mainView.effectsSystemEnabled))

                //onCheckedChanged:{
                 //   mainView.enablePreviews = checked;
               // }


                MouseArea{
                    id:effectsToolBtnMouseArea
                    anchors.fill:parent
                    onClicked:{
                        storedParameters.windowsPreviews = !storedParameters.windowsPreviews;
                        if(effectsToolBtn.checked){
                            if(mainView.firstRunCalibration === false){
                                mainView.getDynLib().showFirstCalibrationDialog();
                            }

                            if(taskManager.mainWindowIdisSet() === false){
                                workflowManager.updatePopWindowWId();
                            }
                        }
                    }

                    onPressAndHold: {
                        if(!effectsToolBtn.checked)
                            effectsToolBtn.checked = true;

                        mainView.getDynLib().showCalibrationDialog();
                    }
                }



            }

            DToolTip{
                title:i18n("Enable/Disable Previews")
                mainText: i18n("You can enable/disable window previews only when you place the plasmoid in the Dashboard.<br/> By <i>\"Pressing and Holding\"</i> the Calibration Dialog is appearing.")
                target:effectsToolBtnMouseArea
                localIcon:effectsImg.source
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
            id:helpBtnMouseArea
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
                mainView.getDynLib().showAboutDialog();
            }

        }

        DToolTip{
            title:i18n("About Dialog")
            mainText: i18n("This dialog contains information about the application but you can also find \"Help Tour\" and \"Report Bug\" choices.")
            target:helpBtnMouseArea
            icon:instanceOfThemeList.icons.HelpTour
        }

    }

}
