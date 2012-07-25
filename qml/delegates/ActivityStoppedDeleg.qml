// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.qtextracomponents 0.1


import ".."
import "ui-elements"

Component{

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

        property real defOpacity :0.65

        onCStateChanged:{
            //stoppedPanel.changedChildState();
        }


        Behavior on opacity{
            NumberAnimation {
                duration: 2*mainView.animationsStep;
                easing.type: Easing.InOutQuad;
            }
        }

        Behavior on width{
            NumberAnimation {
                duration: 2*mainView.animationsStep;
                easing.type: Easing.InOutQuad;
            }
        }

        // QPixmapItem{
        QIconItem{
            id:activityIcon
            rotation:-20
            opacity:parent.defOpacity
            smooth:true
            //pixmap: Icon == "" ? activityManager.disabledPixmapForIcon("plasma") : activityManager.disabledPixmapForIcon(Icon)
            icon: Icon == "" ? QIcon("plasma") : QIcon(Icon)
            enabled:false

            x:stpActivity.width/2
            width:5+0.9*mainView.scaleMeter
            height:width
            anchors.right: parent.right
            anchors.rightMargin: 10


            //for the animation to be precise
            property int toRX:stopActBack.shownActivities > 0 ? x - width:x - width- stopActBack.width
            property int toRY:stopActBack.shownActivities > 0 ? y : -height


            Behavior on rotation{
                NumberAnimation {
                    duration: 2*2*mainView.animationsStep;
                    easing.type: Easing.InOutQuad;
                }
            }

            Behavior on opacity{
                NumberAnimation {
                    duration: 2*mainView.animationsStep;
                    easing.type: Easing.InOutQuad;
                }
            }

        }

        Text{
            id:stpActivityName
            text:Name

            width:0.9*stoppedActivitiesList.width
            wrapMode: TextEdit.Wrap

            font.family: mainView.defaultFont.family
            font.bold: true
            font.italic: true
            font.pointSize: mainView.fixedFontSize+(mainView.scaleMeter/15-4)

            color:"#4d4b4b"
            opacity:parent.defOpacity

            anchors.top: activityIcon.bottom
            anchors.topMargin: activityIcon.height/4


            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignBottom
            maximumLineCount:2
            elide: Text.ElideRight

            Behavior on opacity{
                NumberAnimation {
                    duration: 2*mainView.animationsStep;
                    easing.type: Easing.InOutQuad;
                }
            }
        }

        Rectangle{
            id:stpActivitySeparator

            anchors.horizontalCenter: stpActivity.horizontalCenter
          //  anchors.top:stpActivityName.bottom
          //  anchors.topMargin: 5
            y:parent.basicHeight-height

            width:0.8 * stopActBack.width
            height:2
            color:"#d7d7d7"
        }


        QIconItem{
            id:playActivity
            opacity:0
            icon: QIcon("player_play")

            anchors.horizontalCenter: stpActivity.horizontalCenter
            anchors.top: stpActivity.top

            width: stpActivity.width/2
            height: width


            Behavior on opacity{
                NumberAnimation {
                    duration: 2*mainView.animationsStep;
                    easing.type: Easing.InOutQuad;
                }
            }
        }

        MouseArea{
            anchors.fill: parent
            hoverEnabled: true

            onEntered: {
                activityIcon.opacity = 1
                stpActivityName.opacity = 1
                playActivity.opacity = 1
            }

            onExited: {
                activityIcon.opacity = stpActivity.defOpacity
                stpActivityName.opacity = stpActivity.defOpacity
                playActivity.opacity = 0
            }

            onClicked: {

                instanceOfActivitiesList.startActivity(ccode);

                if(mainView.animationsStep2!==0){
                    var x1 = activityIcon.x;
                    var y1 = activityIcon.y;

                    //activityAnimate.animateStoppedToActive(ccode,activityIcon.mapToItem(mainView,x1, y1));
                    mainView.getDynLib().animateStoppedToActive(ccode,activityIcon.mapToItem(mainView,x1, y1));
                }
                //instanceOfActivitiesList.setCState(ccode,"Running");

            }
        }


    }
}
