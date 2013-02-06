// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.qtextracomponents 0.1

DialogTemplate2{
    id:firCalibDialog
    anchors.centerIn: mainView

    insideWidth: Math.max(mainTextInf.width,mainTextInf2.width)+110
    insideHeight: 10+infIcon.height+mainTextInf2.height+10

    dialogTitle: i18n("First Activation for Window Previews")+"..."

    isModal: true
    forceModality: true

    //Title
    Item{
        anchors.centerIn:parent
        width: firCalibDialog.insideWidth
        height:firCalibDialog.insideHeight

        //Main Area
        QIconItem{
            id:infIcon

            anchors.verticalCenter: parent.verticalCenter
            anchors.topMargin:10
            icon:instanceOfThemeList.icons.DialogInformation
            width:70
            height:70
        }


        Rectangle{
            id:placementMeter
            width:insideWidth-110
            anchors.left: infIcon.right
        }

        Text{
            id:mainTextInf

            anchors.horizontalCenter: placementMeter.horizontalCenter
            anchors.bottom:infIcon.verticalCenter
            //color:"#ffffff"
            color:defColor
            text:i18n("It is the first time you enable window previews,<br/>Do you want to configure them according to your plasma theme?")

            font.family:theme.defaultFont.family
            //font.pixelSize: (0.14+mainView.defFontRelStep)*parent.height
            font.pointSize: theme.defaultFontSize
            font.bold:true
            horizontalAlignment: Text.AlignHCenter

        }
        Text{
            id:mainTextInf2

            text:i18n("-This option is always available with \"Pressing and Holding\"<br/>the Windows Previews toolbutton-")

            anchors.horizontalCenter: placementMeter.horizontalCenter
            anchors.top:infIcon.verticalCenter
            anchors.topMargin:5
            color:defColor
            opacity:0.6
            font.family:theme.defaultFont.family
            //font.pixelSize: (0.14+mainView.defFontRelStep)*parent.height
            font.pointSize: theme.defaultFontSize
            font.italic: true
            horizontalAlignment: Text.AlignHCenter

        }

    }

    Connections {
        target: firCalibDialog
        onClickedOk:{
            completed();
            mainView.getDynLib().showCalibrationDialog();
        }

        onClickedCancel:{
            completed();
        }
    }
}

