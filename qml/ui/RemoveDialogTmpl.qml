// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.qtextracomponents 0.1

DialogTemplate{
    id:rmvDialog
    anchors.centerIn: mainView
    property string activityCode
    property string activityName

    insideWidth: mainTextInf.width+100
    insideHeight: infIcon.height+90
    dialogTitle: i18n("Remove Activity")+"..."

    //Title
    Item{
        anchors.centerIn:parent
        width: rmvDialog.insideWidth
        height:rmvDialog.insideHeight

        //Main Area
        QIconItem{
            id:infIcon

            anchors.verticalCenter: parent.verticalCenter
            icon:QIcon("messagebox_warning")
            width:70
            height:70
        }

        Text{
            id:mainTextInf
            anchors.left: infIcon.right
            anchors.verticalCenter: infIcon.verticalCenter
            color:"#ffffff"
            text:i18n("Are you sure you want to remove activity <b>")+rmvDialog.activityName+i18n("</b> ?")

            font.family:mainView.defaultFont.family
            font.pointSize: mainView.fixedFontSize + 1
        }

    }

    Connections {
        target: removeDialog
        onClickedOk:{
            activityManager.remove(rmvDialog.activityCode);
            instanceOfActivitiesList.activityRemovedIn(rmvDialog.activityCode);
        }

        onClickedCancel:{
            ///
        }
    }
}
