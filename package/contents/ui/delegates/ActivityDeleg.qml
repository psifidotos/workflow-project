// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.qtextracomponents 0.1

import ".."

Component{

    Item{
        id:mainActivity
        property string neededState:"Running"
        property string ccode: model["DataEngineSource"]
        property string cState: model["State"]

        opacity: cState === neededState ? 1 : 0

        property int defWidth:0.98*mainView.workareaWidth

        width: cState === neededState ? defWidth : 0
        height: cState === neededState ? width/2 : 0

        onCStateChanged:{
            allwlists.updateShowActivities();
        }

        Behavior on opacity{
            NumberAnimation {
                duration: 900;
                easing.type: Easing.InOutQuad;
            }
        }

        Behavior on width{
            NumberAnimation {
                duration: 900;
                easing.type: Easing.InOutQuad;
            }
        }

        QIconItem{
          id:activityIcon
          rotation:-20
          opacity:1
          //source: "../" + Icon
          icon: Icon == "" ? QIcon("plasma") : QIcon(Icon)
          smooth:true
          x:mainView.scaleMeter/10
          y:mainView.scaleMeter/3
          width:5+mainView.scaleMeter
          height:width

          //for the animation to be precise
          property int toRX:x - width/2
          property int toRY:y - height/2

          Behavior on rotation{
              NumberAnimation {
                  duration: 200;
                  easing.type: Easing.InOutQuad;
              }
          }

          MouseArea {
              anchors.fill: parent
              hoverEnabled: true

              onEntered: {
                  if (mainView.lockActivities === false){
                      activityBtnsI.state="show";
                      stopActLocked.state="hide";
                      fadeIcon.opacity = 0;
                      activityIcon.rotation = 0;
                  }
                  else
                      stopActLocked.state="show";

              }

              onExited: {
                  if (mainView.lockActivities === false){
                      activityBtnsI.state="hide";
                      stopActLocked.state="hide";
                      fadeIcon.opacity = 1;
                      activityIcon.rotation = -20;
                  }
                  else
                      stopActLocked.state="hide";

              }

              onClicked: {
               if (mainView.lockActivities === false){
                   activityManager.chooseIcon(ccode);
               }
              }

          }

        }

        Image{
            id:fadeIcon
            rotation:0
            opacity:1
            source: "../Images/buttons/activityIconFade.png"
            x:0
            y:0
            width:1.2*activityIcon.width
            height:activityIcon.height+activityIcon.y

            Behavior on opacity{
                NumberAnimation {
                    duration: 200;
                    easing.type: Easing.InOutQuad;
                }
            }
        }

        DTextEdit{
            id:activityName
            text: Name

            y: mainView.scaleMeter/15
            x: mainView.scaleMeter+10
            width:40+2.7*mainView.scaleMeter
            height:20+mainView.scaleMeter

            enableEditing: mainView.lockActivities === true ? false:true
            actCode: ccode

            Connections{
                target:mainView
                onLockActivitiesChanged:{
                    if (activityName.state === "active"){
                        activityName.textNotAccepted();
                    }
                }
            }

            MouseArea {
                anchors.left: parent.left
                height:parent.height
                width:parent.width - 40
                hoverEnabled: true

                onEntered: {
                    if (mainView.lockActivities === false){
                        activityBtnsI.state="show";
                        stopActLocked.state="hide";
                        activityName.entered();
                    }
                    else
                        stopActLocked.state="show";

                }

                onExited: {
                    if (mainView.lockActivities === false){
                        activityBtnsI.state="hide";
                        stopActLocked.state="hide";
                        activityName.exited();
                    }
                    else
                        stopActLocked.state="hide";
                }

                onClicked: {
                    if (mainView.lockActivities === false){
                        activityName.clicked(mouse);
                    }
                }

            }

        }

        ActivityBtns{
            id:activityBtnsI

            width:parent.width-(mainView.scaleMeter-10)
            x:mainView.scaleMeter-10
            height:mainView.scaleMeter - 15           
        }

        Image{
          id:stopActLocked
          opacity:1
          source: "../Images/buttons/player_stop.png"
          anchors.top: parent.top
          anchors.right: parent.right
         // x:mainView.scaleMeter/10
         // y:mainView.scaleMeter/3
          width:5+0.8*mainView.scaleMeter
          height:width
          state: "hide"

          Behavior on opacity{
              NumberAnimation {
                  duration: 400;
                  easing.type: Easing.InOutQuad;
              }
          }

          Behavior on scale{
              NumberAnimation {
                  duration: 400;
                  easing.type: Easing.InOutQuad;
              }
          }

          MouseArea {
              anchors.fill: parent
              hoverEnabled: true

              onEntered: {
                  stopActLocked.state="show";
                  stopActLocked.scale=1.2;
              }

              onExited: {
                  stopActLocked.state="hide";
                  stopActLocked.scale=1;
              }

              onClicked: {
                  activityBtnsI.clickedStopped();
              }

          }

          states: [
              State {
                  name: "show"
                  PropertyChanges {
                      target: stopActLocked
                      opacity: allwlists.activitiesShown > 1 ? 1 : 0
                  }
              },
              State {
                  name:"hide"
                  PropertyChanges {
                      target: stopActLocked
                      opacity:0
                  }

              }

          ]
        }


        ListView.onAdd: ParallelAnimation {
            PropertyAction { target: mainActivity; property: "width"; value: 0 }
            PropertyAction { target: mainActivity; property: "opacity"; value: 0 }

            NumberAnimation { target: mainActivity; property: "width"; to: mainActivity.defWidth; duration: 400; easing.type: Easing.InOutQuad }
            NumberAnimation { target: mainActivity; property: "opacity"; to: 1; duration: 500; easing.type: Easing.InOutQuad }
        }

        ListView.onRemove: SequentialAnimation {
            PropertyAction { target: mainActivity; property: "ListView.delayRemove"; value: true }

            ParallelAnimation{
                NumberAnimation { target: mainActivity; property: "width"; to: 0; duration: 400; easing.type: Easing.InOutQuad }
                NumberAnimation { target: mainActivity; property: "opacity"; to: 0; duration: 500; easing.type: Easing.InOutQuad }
            }


            // Make sure delayRemove is set back to false so that the item can be destroyed
            PropertyAction { target: mainActivity; property: "ListView.delayRemove"; value: false }
        }


        function getCurrentIndex(){
            for(var i=0; ListView.view.model.count; ++i){
                var obj = ListView.view.model.get(i);
                if (obj.model["DataEngineSource"] === ccode)
                    return i;
            }
            return -1;
        }

    }


}
