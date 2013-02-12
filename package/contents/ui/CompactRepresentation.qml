import QtQuick 1.1

import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.qtextracomponents 0.1
import "../code/settings.js" as Settings

Item{
    QIconItem{
        id:mainIcon
        width:parent.width
        height:parent.height
        icon: QIcon(iconPath)
        smooth:true

        property string iconPath: Settings.global.useCurrentActivityIcon ? sessionParameters.currentActivityIcon:
                                                                           "preferences-activities"
        QIconItem{
            anchors.right: parent.horizontalCenter
            anchors.bottom: parent.verticalCenter

            width:parent.width/2
            height:parent.height/2
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
            id:mouseAreaContainer
            anchors.fill:parent
            onClicked:{
                if (plasmoidWrapper.isPopupShowing())
                    plasmoid.hidePopup();
                else
                    plasmoid.showPopup();
            }
        }

        PlasmaCore.ToolTip{
            target:mouseAreaContainer
            mainText: i18n("WorkFlow Plasmoid");
            subText: i18n("Activities, Workareas, Windows, organize your \n full workflow through the KDE technologies")
            image: mainIcon.iconPath
        }
    }
}
