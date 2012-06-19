// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.qtextracomponents 0.1


import ".."

Component{

    Item{
        id: stpActivity

        property string neededState: "Stopped"
        property string ccode: code
        property string cState: CState


        opacity: CState === neededState ? 1 : 0

        width: stoppedActivitiesList.width
        height: CState === neededState ? basicHeight : 0

        property real basicHeight:0.66*mainView.workareaHeight
        property real defOpacity :0.5

        onCStateChanged:{
            //stoppedPanel.changedChildState();
        }


        Behavior on opacity{
            NumberAnimation {
                duration: 400;
                easing.type: Easing.InOutQuad;
            }
        }

        Behavior on width{
            NumberAnimation {
                duration: 400;
                easing.type: Easing.InOutQuad;
            }
        }


        QIconItem{
            id:activityIcon
            rotation:-20
            opacity:parent.defOpacity
            //source: "../" + Icon
            icon: Icon == "" ? QIcon("plasma") : QIcon(Icon)
            //  x:25
            //  anchors.right: stpActivity.right
            x:stpActivity.width/2
            width:5+mainView.scaleMeter
            height:width
            smooth:true

            //for the animation to be precise
            property int toRX:stopActBack.shownActivities > 0 ? x - width:x - width- stopActBack.width
            property int toRY:stopActBack.shownActivities > 0 ? y : -height


            Behavior on rotation{
                NumberAnimation {
                    duration: 400;
                    easing.type: Easing.InOutQuad;
                }
            }

            Behavior on opacity{
                NumberAnimation {
                    duration: 400;
                    easing.type: Easing.InOutQuad;
                }
            }

        }

        Text{
            id:stpActivityName
            text:Name

            width:0.9*stoppedActivitiesList.width
            wrapMode: TextEdit.Wrap

            font.family: "Helvetica"
            font.bold: true
            font.italic: true
            font.pointSize: 3+(mainView.scaleMeter/10)

            color:"#4d4b4b"
            opacity:parent.defOpacity

            anchors.top: activityIcon.bottom

            horizontalAlignment: Text.AlignRight

            Behavior on opacity{
                NumberAnimation {
                    duration: 400;
                    easing.type: Easing.InOutQuad;
                }
            }
        }

        Rectangle{

            anchors.horizontalCenter: stpActivity.horizontalCenter
            anchors.top:stpActivityName.bottom
            anchors.topMargin: 15

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
                    duration: 400;
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

                var x1 = activityIcon.x;
                var y1 = activityIcon.y;

                //activityAnimate.animateStoppedToActive(ccode,activityIcon.mapToItem(mainView,x1, y1));
                mainView.getDynLib().animateStoppedToActive(ccode,activityIcon.mapToItem(mainView,x1, y1));

                //instanceOfActivitiesList.setCState(ccode,"Running");

            }
        }


    }
}
