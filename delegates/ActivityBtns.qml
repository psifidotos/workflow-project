// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item{
    id: activityButtons

    property int buttonsSize:mainView.scaleMeter / 2
    property int buttonsSpace:mainView.scaleMeter / 10
    property int buttonsX:mainView.scaleMeter / 3.5
    property int buttonsY:mainView.scaleMeter / 10

    property alias opacityDel : deleteActivityBtn.opacity
    property alias opacityDup : duplicateActivityBtn.opacity
    property alias opacityStop : stopActivityBtn.opacity

    property alias xDel : deleteActivityBtn.x
    property alias xDup : duplicateActivityBtn.x
    property alias xStop : stopActivityBtn.x

    state: "hide"

    property real curBtnScale:1.4

    Image{
        id:stopActivityBtn
        source: "../Images/buttons/player_stop.png"
        width: buttonsSize
        height: buttonsSize
        x:buttonsX
        y:buttonsY
        opacity:0
        z:10
        smooth:true

        Behavior on scale{
            NumberAnimation {
                duration: 200;
                easing.type: Easing.InOutQuad;
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onEntered: {
                activityButtons.state = "show";
                stopActivityBtn.scale = curBtnScale;
            }

            onExited: {
                activityButtons.state = "hide";
                stopActivityBtn.scale = 1;
            }

            onClicked: {
                activityButtons.clickedStopped();
            }

        }
    }

    Image{
        id:duplicateActivityBtn
        source: "../Images/buttons/cloneActivity.png"
        width: buttonsSize
        height: buttonsSize
        x:buttonsSize+buttonsSpace+buttonsX
        y:buttonsY
        opacity:0
        smooth:true

        z:11

        Behavior on scale{
            NumberAnimation {
                duration: 200;
                easing.type: Easing.InOutQuad;
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onEntered: {
                activityButtons.state = "show";
                duplicateActivityBtn.scale = curBtnScale;
            }

            onExited: {
                activityButtons.state = "hide";
                duplicateActivityBtn.scale = 1;
            }

            onClicked: {
                instanceOfActivitiesList.cloneActivity(code);
            }


        }
    }

    Image{
        id:deleteActivityBtn
        source: "../Images/buttons/mail_delete.png"
        width: buttonsSize
        height: buttonsSize
        x:2*buttonsSize+2*buttonsSpace+buttonsX
        y:buttonsY
        opacity:0
        z:12
        smooth:true

        Behavior on scale{
            NumberAnimation {
                duration: 200;
                easing.type: Easing.InOutQuad;
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onEntered: {
                activityButtons.state = "show";
                deleteActivityBtn.scale = curBtnScale;
            }

            onExited: {
                activityButtons.state = "hide";
                deleteActivityBtn.scale = 1;
            }

            onClicked: {
                instanceOfActivitiesList.removeActivity(code);
            }

        }

    }

    states: [
        State {
            name: "show"

            PropertyChanges {
                target: activityButtons

                opacityDel: allwlists.activitiesShown > 1 ? 1 : 0
                opacityDup: 1
                opacityStop: allwlists.activitiesShown > 1 ? 1 : 0

                xDel:parent.width - buttonsSize - buttonsSpace - buttonsX - 43
                xDup:parent.width - 2*buttonsSize - 2*buttonsSpace - buttonsX - 43
                xStop:parent.width - 3*buttonsSize - 3*buttonsSpace - buttonsX - 43
            }
        },
       State {
           name: "hide"
           PropertyChanges {
                  target: activityButtons

                  opacityDel: 0
                  opacityDup: 0
                  opacityStop: 0

                  xDel:0
                  xDup:0
                  xStop:0
           }
        }
    ]

    transitions: [

        Transition {
            from:"hide"; to:"show"
            reversible: true
            SequentialAnimation{
                ParallelAnimation{
                    NumberAnimation {
                        target: activityButtons;
                        property: "xDel";
                        duration: 200;
                        easing.type: Easing.InOutQuad;
                    }
                    NumberAnimation {
                        target: activityButtons;
                        property: "opacityDel";
                        duration: 200;
                        easing.type: Easing.InOutQuad;
                    }
                }

                ParallelAnimation{
                    NumberAnimation {
                        target: activityButtons;
                        property: "xDup";
                        duration: 200;
                        easing.type: Easing.InOutQuad;
                    }
                    NumberAnimation {
                        target: activityButtons;
                        property: "opacityDup";
                        duration: 200;
                        easing.type: Easing.InOutQuad;
                    }
                }

                ParallelAnimation{
                    NumberAnimation {
                        target: activityButtons;
                        property: "xStop";
                        duration: 200;
                        easing.type: Easing.InOutQuad;
                    }
                    NumberAnimation {
                        target: activityButtons;
                        property: "opacityStop";
                        duration: 200;
                        easing.type: Easing.InOutQuad;
                    }
                }
            }
        }
    ]


    function clickedStopped(){
        instanceOfActivitiesList.setCState(code,"Stopped");

        stoppedPanel.changedChildState();

        var x1 = activityIcon.x;
        var y1 = activityIcon.y;

        activityAnimate.animateActiveToStop(code,activityIcon.mapToItem(mainView,x1, y1));

    }
}

