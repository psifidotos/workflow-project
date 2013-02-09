// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.qtextracomponents 0.1

DialogTemplate2{
    id:rmvDialog
    anchors.centerIn: mainView
    property string activityCode
    property string activityName

    insideWidth: mainTextInf.width+100
    insideHeight: infIcon.height+40
    dialogTitle: i18n("Remove Activity")+"..."
    isModal: true

    //Title
    Item{
        anchors.centerIn:parent
        width: rmvDialog.insideWidth
        height:rmvDialog.insideHeight

        //Main Area
        QIconItem{
            id:infIcon

            anchors.verticalCenter: parent.verticalCenter
            icon: "emblem-important"
            width:70
            height:70
        }

        Text{
            id:mainTextInf
            anchors.left: infIcon.right
            anchors.verticalCenter: infIcon.verticalCenter
            //color:"#ffffff"
            color:defColor
            text:i18n("Are you sure you want to remove activity")+" <b>"+rmvDialog.activityName+"</b> "+i18n("?")

            font.family:theme.defaultFont.family
            //font.pixelSize: (0.14+mainView.defFontRelStep)*parent.height
            font.pointSize: theme.defaultFontSize
        }

    }

    Connections {
        target: rmvDialog
        onClickedOk:{
            workflowManager.activityManager().remove(activityCode);;
            completed();
        }

        onClickedCancel:{
            completed();
        }
    }
}
