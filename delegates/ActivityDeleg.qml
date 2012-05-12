// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import ".."

Component{

    Item{
        id:mainActivity
        property string neededState:"Running"
        property int ccode:code

        opacity: CState === neededState ? 1 : 0

        property int defWidth:mainView.workareaWidth

        width: CState === neededState ? defWidth : 0
        height: CState === neededState ? width/2 : 0

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


        Image{
          id:activityIcon
          rotation:-20
          opacity:1
          source: "../" + Icon
          x:mainView.scaleMeter/10
          y:mainView.scaleMeter/3
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
              hoverEnabled: true

              onEntered: {
                  activityBtnsI.state="show"
                  fadeIcon.opacity = 0;
                  activityIcon.rotation = 0;
              }

              onExited: {
                  activityBtnsI.state="hide"
                  fadeIcon.opacity = 1;
                  activityIcon.rotation = -20;
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

            MouseArea {
                anchors.left: parent.left
                height:parent.height
                width:parent.width - 40
                hoverEnabled: true

                onEntered: {
                    activityBtnsI.state="show";
                    activityName.entered();
                }

                onExited: {
                    activityBtnsI.state="hide";
                    activityName.exited();
                }

                onClicked: {
                    activityName.clicked(mouse);
                }

            }
        }

        ActivityBtns{
            id:activityBtnsI

            width:parent.width-(mainView.scaleMeter-10)
            x:mainView.scaleMeter-10
            height:mainView.scaleMeter - 15
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
                if (obj.code === code)
                    return i;
            }
            return -1;
        }

    }


}
