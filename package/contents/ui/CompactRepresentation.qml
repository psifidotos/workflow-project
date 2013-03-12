import QtQuick 1.1

import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.plasma.extras 0.1 as PlasmaExtras
import org.kde.qtextracomponents 0.1
import "../code/settings.js" as Settings

Item{
    id:container
    anchors.centerIn: parent



    QIconItem{
        id:mainIcon
        anchors.centerIn: parent
        width:Math.min (parent.width,parent.height)-6
        height:Math.min (parent.width,parent.height)-6
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

        Rectangle{
            id:hoverCompactRect
            width:parent.width-5
            height:parent.height-5
            anchors.centerIn: parent
            //color:"#ffffff"
            opacity:0
            radius:10

            gradient: Gradient {
                GradientStop { position: 0.0; color: "#ffffffff" }
                GradientStop { position: 1.0; color: "#00666666" }
            }

            Behavior on opacity{
                NumberAnimation {
                    duration: 2*Settings.global.animationStep;
                    easing.type: Easing.InOutQuad;
                }
            }
        }
    }

    PlasmaExtras.PressedAnimation{
        id:pressedAnimation
        targetItem:mainIcon
    }
    PlasmaExtras.ReleasedAnimation{
        id:releasedAnimation
        targetItem:mainIcon
    }


    //this timer helps in order not to send too many signal
    //of changing current activity
    //(changing activities with not logical order fixed this way)
    Timer {
        id:timer
        interval: 150; running: false; repeat: false
        onTriggered: wheelListener.enabledTimer = false;
    }



    MouseEventListener {
        id:wheelListener
        anchors.fill:parent
        property bool enabledTimer:false

        onWheelMoved:{
            if(!enabledTimer){
                enabledTimer = true;
                timer.start();
                if(wheel.delta < 0)
                    workflowManager.workareaManager().setCurrentPreviousActivity();
                else
                    workflowManager.workareaManager().setCurrentNextActivity();


                //Probably not working...
                mainView.forceActiveFocus();
            }
        }

        MouseArea{
            id:mouseAreaContainer
            anchors.fill:parent
            hoverEnabled: true
            onClicked:{
                if(!Settings.global.triggerKWinScript){
                    if (plasmoidWrapper.isPopupShowing())
                        plasmoid.hidePopup();
                    else
                        plasmoid.showPopup();
                }
                else
                    sessionParameters.triggerKWinScript();
            }

            onEntered: hoverCompactRect.opacity = 0.6;
            onExited: hoverCompactRect.opacity = 0;
            onPressed: pressedAnimation.start();
            onReleased: releasedAnimation.start();
        }

        PlasmaCore.ToolTip{
            target:mouseAreaContainer
            mainText: i18n("WorkFlow Plasmoid");
            subText: i18n("Activities, Workareas, Windows, organize your \n full workflow through the KDE technologies")
            image: mainIcon.iconPath
        }
    }
}
