// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Component{

    Item{
        id: stpActivity
        width: stoppedActivitiesList.width
        height: 2*mainView.workareaHeight/3


        Image{
          id:activityIcon
          rotation:-20
          opacity:0.5
          source: Icon

          anchors.right: stpActivity.right
          width:5+mainView.scaleMeter
          height:width

          Behavior on rotation{
              NumberAnimation {
                  duration: 200;
                  easing.type: Easing.InOutQuad;
              }
          }

          MouseArea {
              anchors.fill: parent
            //  hoverEnabled: true

              onEntered: {
           //       activityBtnsI.state="show"
                 // fadeIcon.opacity = 0;
                //  activityIcon.rotation = 0;
              }

              onExited: {
              //    activityBtnsI.state="hide"
              //    fadeIcon.opacity = 1;
              //    activityIcon.rotation = -20;
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
            opacity:0.5

            anchors.top: activityIcon.bottom
            horizontalAlignment: Text.AlignRight
        }

        Rectangle{

            anchors.horizontalCenter: stpActivity.horizontalCenter
            anchors.top:stpActivityName.bottom
            anchors.topMargin: 15

            width:stopActBack.width -(2*(stopActBack.width/10))
            height:2
            color:"#d7d7d7"
        }
    }
}
