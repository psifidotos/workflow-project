// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Component{

    Item{
        id: stpActivity

        property string neededState:"Stopped"

        opacity: CState === neededState ? 1 : 0

        width: CState === neededState ? stoppedActivitiesList.width : 0
        height: CState === neededState ? 2*mainView.workareaHeight/3 : 0

        property string curState: CState

        onCurStateChanged:{
            stopActBack.changedChildState();
        }


        Behavior on opacity{
            NumberAnimation {
                duration: 300;
                easing.type: Easing.InOutQuad;
            }
        }

        Behavior on width{
            NumberAnimation {
                duration: 300;
                easing.type: Easing.InOutQuad;
            }
        }

        Behavior on height{
            NumberAnimation {
                duration: 300;
                easing.type: Easing.InOutQuad;
            }
        }

        property real defOpacity :0.5


        Image{
            id:activityIcon
            rotation:-20
            opacity:parent.defOpacity
            source: Icon

            anchors.right: stpActivity.right
            width:5+mainView.scaleMeter
            height:width

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

            width:stoppedActivitiesList.width
            wrapMode: TextEdit.Wrap

            font.family: "Helvetica"
            font.bold: true
            font.italic: true
            font.pointSize: 3+(mainView.scaleMeter) /10

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

            width:stopActBack.width -(2*(stopActBack.width/10))
            height:2
            color:"#d7d7d7"
        }

        Image{
            id:playActivity
            opacity:0
            source: "Images/buttons/player_play.png"

            anchors.horizontalCenter: stpActivity.horizontalCenter
            anchors.verticalCenter:  stpActivity.verticalCenter
            anchors.leftMargin: 20

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
                var ind = stpActivity.getCurrentIndex();
                stpActivity.ListView.view.model.setProperty(ind,"CState","Running");
                activitiesList.model.setProperty(ind,"CState","Running");

            }
        }

        function getCurrentIndex(){
            for(var i=0; ListView.view.model.count; ++i){
                var obj = ListView.view.model.get(i);
                if (obj.code === code)
                    return i;
            }
            return -1;
        }
    }
}
