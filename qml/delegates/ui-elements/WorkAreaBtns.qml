import QtQuick 1.0

Item{
    id: workAreaButtons
    width:buttonsSize
    height:width

    state: "hide"
    property alias opacityDel : deleteWorkareaBtn.opacity
    property alias deleteY: deleteWorkareaBtn.y
    property alias opacityClone : duplicateWorkareaBtn.opacity
    property alias duplicateY: duplicateWorkareaBtn.y

    property int buttonsSize: 8+(0.6 * mainView.scaleMeter)
    property int buttonsSpace: mainView.scaleMeter/10
    property int buttonsX:0.3 * mainView.scaleMeter
    property int buttonsY: mainView.scaleMeter/10

    property real curBtnScale:1.4

    CloseWindowButton{
        id:deleteWorkareaBtn

        width: parent.buttonsSize
        height: width


        Behavior on scale{
            NumberAnimation {
                duration: 200;
                easing.type: Easing.InOutQuad;
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onClicked: {

                deleteWorkareaBtn.onClicked();

                instanceOfWorkAreasList.removeWorkArea(mainWorkArea.actCode,mainWorkArea.desktop);                
/*
                for (var i=gridRow+1; i<mainWorkArea.ListView.view.model.count;i++)
                {
                    var currentPos = mainWorkArea.ListView.view.model.get(i).gridRow;
                    mainWorkArea.ListView.view.model.setProperty(i ,"gridRow",currentPos-1);
                }

                mainWorkArea.ListView.view.model.remove(gridRow);*/
            }

            onEntered: {
                deleteWorkareaBtn.onEntered();

                mainWorkArea.showButtons();
                deleteWorkareaBtn.scale = workAreaButtons.curBtnScale;
            }

            onExited: {
                deleteWorkareaBtn.onExited();

                mainWorkArea.hideButtons();
                deleteWorkareaBtn.scale = 1;
            }

            onReleased: {
                deleteWorkareaBtn.onReleased();
            }

            onPressed: {
                deleteWorkareaBtn.onPressed();
            }

        }


    }


    Image{
        id:duplicateWorkareaBtn
        source: "../../Images/buttons/window_duplicate.png"
        width: buttonsSize
        height: buttonsSize
        x:0
        y:parent.height - buttonsSize
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
                workAreaButtons.state = "show";
                duplicateWorkareaBtn.scale = curBtnScale;
            }

            onExited: {
                workAreaButtons.state = "hide";
                duplicateWorkareaBtn.scale = 1;
            }

        }
    }

    states: [
        State {
            name: "show"
            when:loc.hoverCurrentId === gridRow
            PropertyChanges {
                target: workAreaButtons
                opacityDel: 1
            //    deleteY:buttonsSpace
                opacityClone: 0
                duplicateY: buttonsSize+2*buttonsSpace
            }
        },
        State {
            name: "hide"
            PropertyChanges {
                target: workAreaButtons
                opacityDel: 0
          //      deleteY:normalStateWorkArea.height
                opacityClone: 0
                duplicateY:normalStateWorkArea.height
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
                        target: workAreaButtons;
                        property: "deleteY";
                        duration: 200;
                        easing.type: Easing.InOutQuad;
                    }
                    NumberAnimation {
                        target: workAreaButtons;
                        property: "opacityDel";
                        duration: 200;
                        easing.type: Easing.InOutQuad;
                    }
                }
                ParallelAnimation{
                    NumberAnimation {
                        target: workAreaButtons;
                        property: "duplicateY";
                        duration: 200;
                        easing.type: Easing.InOutQuad;
                    }
                    NumberAnimation {
                        target: workAreaButtons;
                        property: "opacityClone";
                        duration: 200;
                        easing.type: Easing.InOutQuad;
                    }
                }
            }
        }
    ]

}

