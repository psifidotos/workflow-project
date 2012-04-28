// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Component{

    Item{
        id:mainActivity

        width:mainView.workareaWidth
        height:width/2
        Image{
          id:activityIcon
          rotation:-20
          opacity:1
          source: Icon
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
            source: "Images/buttons/activityIconFade.png"
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

    }


}
