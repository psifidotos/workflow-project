import QtQuick 1.0

import "../../tooltips"

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

    property real curBtnScale:1.3

    CloseWindowButton{
        id:deleteWorkareaBtn

        width: parent.buttonsSize
        height: width


        Behavior on scale{
            NumberAnimation {
                duration: parametersManager.animationsStep;
                easing.type: Easing.InOutQuad;
            }
        }

        MouseArea {
            id:deleteWorkareaBtnMouseArea
            anchors.fill: parent
            hoverEnabled: true

            onClicked: {
                deleteWorkareaBtn.onClicked();

                instanceOfWorkAreasList.removeWorkArea(mainWorkArea.actCode,mainWorkArea.desktop);                
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

        DToolTip{
            title:i18n("Delete Workarea")
            mainText: i18n("You can delete this WorkArea if you want to.")
            target:deleteWorkareaBtnMouseArea
            //icon:instanceOfThemeList.icons.RunActivity
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
                duration: parametersManager.animationsStep;
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
                opacityClone: 0
            }
        },
        State {
            name: "hide"
            PropertyChanges {
                target: workAreaButtons
                opacityDel: 0
                opacityClone: 0
            }
        }
    ]

    transitions: [

        Transition {
            from:"hide"; to:"show"
            reversible: false

            SequentialAnimation{
                ParallelAnimation{
                    NumberAnimation {
                        target: workAreaButtons;
                        property: "deleteY";
                        duration: parametersManager.animationsStep;
                        easing.type: Easing.InOutQuad;
                    }
                    NumberAnimation {
                        target: workAreaButtons;
                        property: "opacityDel";
                        duration: parametersManager.animationsStep;
                        easing.type: Easing.InOutQuad;
                    }
                }
                ParallelAnimation{
                    NumberAnimation {
                        target: workAreaButtons;
                        property: "duplicateY";
                        duration: parametersManager.animationsStep;
                        easing.type: Easing.InOutQuad;
                    }
                    NumberAnimation {
                        target: workAreaButtons;
                        property: "opacityClone";
                        duration: parametersManager.animationsStep;
                        easing.type: Easing.InOutQuad;
                    }
                }
            }
        },
        Transition {
            from:"show"; to:"hide"
            reversible: false

            SequentialAnimation{
                ParallelAnimation{
                    NumberAnimation {
                        target: workAreaButtons;
                        property: "deleteY";
                        duration: parametersManager.animationsStep;
                        easing.type: Easing.InOutQuad;
                    }
                    NumberAnimation {
                        target: workAreaButtons;
                        property: "opacityDel";
                        duration: parametersManager.animationsStep;
                        easing.type: Easing.InOutQuad;
                    }
                }
                ParallelAnimation{
                    NumberAnimation {
                        target: workAreaButtons;
                        property: "duplicateY";
                        duration: parametersManager.animationsStep;
                        easing.type: Easing.InOutQuad;
                    }
                    NumberAnimation {
                        target: workAreaButtons;
                        property: "opacityClone";
                        duration: parametersManager.animationsStep;
                        easing.type: Easing.InOutQuad;
                    }
                }
            }
        }
    ]

}

