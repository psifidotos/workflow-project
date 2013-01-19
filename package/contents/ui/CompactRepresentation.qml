import QtQuick 1.1

import org.kde.qtextracomponents 0.1
import "../code/settings.js" as Settings

Item{
    QIconItem{
        width:parent.width
        height:parent.height
        rotation:-20
        icon: QIcon(iconPath)
        smooth:true

        property string iconPath: Settings.global.useCurrentActivityIcon ? sessionParameters.currentActivityIcon:
                                                                           "preferences-activities"
        QIconItem{
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.top

            width:parent.width/2
            height:parent.height/2
            rotation:20
            icon: QIcon("preferences-activities")
            smooth:true
            visible: Settings.global.useCurrentActivityIcon
        }
    }

    MouseEventListener {
        anchors.fill:parent

        onWheelMoved:{
            if(wheel.delta < 0)
                workflowManager.activityManager().setCurrentNextActivity();
            else
                workflowManager.activityManager().setCurrentPreviousActivity();
        }

        MouseArea{
            anchors.fill:parent
            onClicked:{
                if (plasmoidWrapper.isPopupShowing())
                    plasmoid.hidePopup();
                else
                    plasmoid.showPopup();
            }
        }


    }
}
