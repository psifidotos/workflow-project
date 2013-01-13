// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.qtextracomponents 0.1

import "ui-elements"
import "../tooltips"
import "../components"

Item{
    id: stpActivity

    property string neededState: "Stopped"
    property string ccode: code
    property string cState: CState

    property bool shown: CState === neededState

    opacity: shown ? 1 : 0

    width: stoppedActivitiesList.width
    height: shown ? basicHeight : 0

    property real basicHeight:0.62*mainView.workareaHeight
    property int buttonsSize:0.5 * mainView.scaleMeter

    property real defOpacity  : 0.6

    property bool containsMouse: (deleteActivityBtn.containsMouse) ||
                                 (mouseArea.containsMouse)

    /*
        onCStateChanged:{
            //stoppedPanel.changedChildState();
        }*/


    Behavior on opacity{
        NumberAnimation {
            duration: 2*storedParameters.animationsStep;
            easing.type: Easing.InOutQuad;
        }
    }

    Behavior on width{
        NumberAnimation {
            duration: 2*storedParameters.animationsStep;
            easing.type: Easing.InOutQuad;
        }
    }

    Item{
        ///Ghost Element in order for the activityIcon to be the
        ///second children
    }


    QIconItem{
        id:activityIcon
        rotation:-20
        opacity:stpActivity.containsMouse ? 1 : parent.defOpacity
        smooth:true

        icon: Icon == "" ? QIcon("plasma") : QIcon(Icon)
        enabled:stpActivity.containsMouse ? true : false

        x:stpActivity.width/2
        width:5+0.9*mainView.scaleMeter
        height:width
        anchors.top:parent.top
        anchors.topMargin:10
        anchors.right: parent.right
        anchors.rightMargin: 10


        //for the animation to be precise
        property int toRX:stopActBack.shownActivities > 0 ? x - width:x - width- stopActBack.width
        property int toRY:stopActBack.shownActivities > 0 ? y : -height


        Behavior on rotation{
            NumberAnimation {
                duration: 2*storedParameters.animationsStep;
                easing.type: Easing.InOutQuad;
            }
        }

        Behavior on opacity{
            NumberAnimation {
                duration: 2*storedParameters.animationsStep;
                easing.type: Easing.InOutQuad;
            }
        }

    }

    Text{
        id:stpActivityName
        text:Name

        width:0.99*stoppedActivitiesList.width-5
        wrapMode: TextEdit.Wrap

        font.family: mainView.defaultFont.family
        font.bold: true
        font.italic: true

        font.pixelSize: (0.13+mainView.defFontRelStep)*parent.height

        opacity:stpActivity.containsMouse ? 1 : stpActivity.defOpacity

        color:"#4d4b4b"

        anchors.top: activityIcon.bottom
        anchors.topMargin: activityIcon.height/8
        anchors.right: parent.right
        anchors.rightMargin: 5



        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignBottom
        maximumLineCount:2
        elide: Text.ElideRight

        Behavior on opacity{
            NumberAnimation {
                duration: 2*storedParameters.animationsStep;
                easing.type: Easing.InOutQuad;
            }
        }
    }

    Rectangle{
        id:stpActivitySeparator

        anchors.horizontalCenter: stpActivity.horizontalCenter

        y:parent.basicHeight-height

        width:0.8 * stopActBack.width
        height:2
        color:"#d7d7d7"
    }


    QIconItem{
        id:playActivity
        opacity:stpActivity.containsMouse ? 1 : 0
        icon: QIcon(instanceOfThemeList.icons.RunActivity)

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        width: stpActivity.width/2
        height: width

        Behavior on opacity{
            NumberAnimation {
                duration: 2*storedParameters.animationsStep;
                easing.type: Easing.InOutQuad;
            }
        }

    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            workflowManager.activityManager().start(ccode);

            if(storedParameters.animationsStep2!==0){
                var x1 = activityIcon.x;
                var y1 = activityIcon.y;

                //activityAnimate.animateStoppedToActive(ccode,activityIcon.mapToItem(mainView,x1, y1));
                mainView.getDynLib().animateStoppedToActive(ccode,activityIcon.mapToItem(mainView,x1, y1));
            }
        }
    }

    IconButton {
        id:deleteActivityBtn
        icon: instanceOfThemeList.icons.DeleteActivity
        anchors.right:parent.right
        anchors.top:parent.top
        width: buttonsSize
        height: buttonsSize
        opacity: (stpActivity.containsMouse && !storedParameters.lockActivities) ? 1 : 0
        onClicked: {
            mainView.getDynLib().showRemoveDialog(ccode,workflowManager.activityManager().name(ccode));
        }

        tooltipTitle: i18n("Delete Activity")
        tooltipText: i18n("You can delete an Activity. Be careful, this action can not be undone.")

        Behavior on opacity{
            NumberAnimation {
                duration: 2*storedParameters.animationsStep;
                easing.type: Easing.InOutQuad;
            }
        }
    }

    DToolTip {
        target: mouseArea
        title: i18n("Restore Activity")
        mainText: i18n("You can restore an Activity in order to continue your work from where you had stopped.")
        icon: instanceOfThemeList.icons.RunActivity
    }

    function getIcon(){
        return activityIcon;
    }


}

