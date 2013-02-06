// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.qtextracomponents 0.1

DialogTemplate2{
    id:firHelpDialog
    anchors.centerIn: mainView

    insideWidth: Math.max(mainTextInf.width,mainTextInf2.width)+110
    insideHeight: infIcon.height+60

    dialogTitle: i18n("First Run for Help Tour")+"..."

    isModal: true
    forceModality: true
    //Title
    Item{
        anchors.centerIn:parent
        width: firHelpDialog.insideWidth
        height:firHelpDialog.insideHeight

        //Main Area
        QIconItem{
            id:infIcon

            anchors.verticalCenter: parent.verticalCenter
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
            anchors.top: infIcon.top
            //color:"#ffffff"
            color:defColor
            text:i18n("It is the first time you use the application,<br/>Do you want to watch a Help Tour?")

            font.family:theme.defaultFont.family
            //font.pixelSize: (0.14+mainView.defFontRelStep)*parent.height
            font.pointSize: theme.defaultFontSize
            font.bold:true
            horizontalAlignment: Text.AlignHCenter

        }
        Text{
            id:mainTextInf2

            text:i18n("-This option is always available from the About Dialog-")

            anchors.horizontalCenter: placementMeter.horizontalCenter
            anchors.top:mainTextInf.bottom
            anchors.topMargin:5
            color:defColor
            opacity:0.6
            font.family:theme.defaultFont.family
            //font.pixelSize: (0.14+mainView.defFontRelStep)*parent.height
            font.pointSize: theme.defaultFontSize
            font.italic: true

        }

    }

    Connections {
        target: firHelpDialog
        onClickedOk:{
            completed();
            mainView.getDynLib().showLiveTourDialog();
        }

        onClickedCancel:{
            completed();
        }
    }
}

