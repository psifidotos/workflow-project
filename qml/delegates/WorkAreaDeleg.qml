import QtQuick 1.0
import ".."
import "ui-elements"

//Component{

    Item{
        id: mainWorkArea

        property alias workAreaName_visible: workAreaName.visible
        property alias areaButtons_visible: workAreaButtons.visible

        width:mainView.workareaWidth - 0.2*mainView.scaleMeter
        height: workList.workAreaImageHeight+workList.realWorkAreaNameHeight
        x:0.1*mainView.scaleMeter


        property string typeId : "workareaDeleg"

        property string actCode: workList.ccode
        property int desktop: gridRow

        property int imagex:14
        property int imagey:15

        property int imagewidth:width - 2*imagex
        property int imageheight:height - 2*imagey

        Item{
            id:normalWorkArea

            width: mainWorkArea.width
            height: workList.workAreaImageHeight

            WorkAreaImage{
                id:borderRectangle
                width:parent.width
                height:parent.height

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true

                    onEntered: {
                        mainWorkArea.showButtons();
                    }

                    onExited: {
                        mainWorkArea.hideButtons();
                    }

                    onClicked: {
                        mainWorkArea.clickedWorkarea();
                    }



                }//image mousearea

                Image{
                    id:cornerImage
                    source:"../Images/buttons/brownCorner.png"

                    height:0.3*parent.height
                    width:height

                    property int offset: mainView.scaleMeter<65 ? 1 : 0
                    y:parent.height-height-2-offset
                    x:3+offset

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true

                        onEntered: {
                            cornerImage.source = "../Images/buttons/blueCorner.png"
                        }

                        onExited: {
                           cornerImage.source = "../Images/buttons/brownCorner.png"
                        }

                        onClicked: {
//                            mainWorkArea.clickedWorkarea();
                        }
                    }
                }
            }


            ListView{

                id:tasksSList

                x:mainWorkArea.imagex
                y:mainWorkArea.imagey
                width:mainWorkArea.imagewidth
                height:mainView.showWinds ? workList.workAreaImageHeight-2*mainWorkArea.imagey : 0
                opacity:mainView.showWinds ? 1 : 0

                clip:true
                spacing:0
                interactive:false

                property bool hasChildren:childrenRect.height > 1
                property bool isClipped:childrenRect.height > height

                model:instanceOfTasksList.model

                delegate:WorkAreaTaskDeleg{
                }

                Behavior on opacity{
                    NumberAnimation {
                        duration: 3*mainView.animationsStep
                        easing.type: Easing.InOutQuad;
                    }
                }

                Behavior on height{
                    NumberAnimation {
                        duration: 3*mainView.animationsStep
                        easing.type: Easing.InOutQuad;
                    }
                }
            }

            WorkAreaBtns{
                id:workAreaButtons

                x:borderRectangle.width+borderRectangle.x - 0.85*width
                y:-0.25*height
                opacity: mainWorkArea.ListView.view.model.count>1 ? 1 : 0
            }


            DTextLine{
                id:workAreaName

                y: borderRectangle.height-5
                width: mainWorkArea.width
                height: workList.workAreaNameHeight
                text: elemTitle
            }

            MoreButton{
                id:workAreaMoreBtn
                state:tasksSList.isClipped === true ? "more" : "simple"

                width:0.2*borderRectangle.width
                height:0.5*width

                x:(0.5*borderRectangle.width)+borderRectangle.x - 0.5*width
                y:borderRectangle.y+borderRectangle.height-height
                opacity:0

                visible:(tasksSList.hasChildren === true)&&(mainWorkArea.ListView.delayRemove===false)


                Behavior on opacity{
                    NumberAnimation {
                        duration: 3*mainView.animationsStep
                        easing.type: Easing.InOutQuad;
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true

                    onClicked: {
                        workAreaMoreBtn.onClicked();

                        //mainView.getDynLib().showDesktopDialog(actCode,desktop);
                        desktopDialog.openD(actCode,desktop);
                    }

                    onEntered: {
                        workAreaMoreBtn.onEntered();
                        mainWorkArea.showButtons();
                    }

                    onExited: {
                        workAreaMoreBtn.onExited();
                        mainWorkArea.hideButtons();
                    }

                    onReleased: {
                        workAreaMoreBtn.onReleased();
                    }

                    onPressed: {
                        workAreaMoreBtn.onPressed();
                    }

                }

            }

        } //normalWorkArea Item

        ListView.onAdd: ParallelAnimation {
            PropertyAction { target: mainWorkArea; property: "height"; value: 0 }
            PropertyAction { target: borderRectangle; property: "height"; value: 0 }
            PropertyAction { target: mainWorkArea; property: "opacity"; value: 0 }

            NumberAnimation { target: mainWorkArea; property: "height"; to: mainView.workareaHeight; duration: 400; easing.type: Easing.InOutQuad }
            NumberAnimation { target: borderRectangle; property: "height"; to: mainView.workareaHeight; duration: 500; easing.type: Easing.InOutQuad }
            NumberAnimation { target: mainWorkArea; property: "opacity"; to: 1; duration: 500; easing.type: Easing.InOutQuad }
        }

        ListView.onRemove: SequentialAnimation {
            PropertyAction { target: mainWorkArea; property: "ListView.delayRemove"; value: true }
            PropertyAction { target: workAreaButtons; property: "visible"; value: false }
            PropertyAction { target: workAreaMoreBtn; property: "visible"; value: false }
            PropertyAction { target: tasksSList; property: "visible"; value: false }

            ParallelAnimation{
                NumberAnimation { target: mainWorkArea; property: "height"; to: 0; duration: 500; easing.type: Easing.InOutQuad }
                NumberAnimation { target: borderRectangle; property: "height"; to: 0; duration: 500; easing.type: Easing.InOutQuad }
                NumberAnimation { target: borderRectangle; property: "opacity"; to: 0; duration: 500; easing.type: Easing.InOutQuad }
                //NumberAnimation { target: workAreaButtons; property: "opacity"; to: 0; duration: 0; easing.type: Easing.InOutQuad }
                //NumberAnimation { target: workAreaMoreBtn; property: "opacity"; to: 0; duration: 0; easing.type: Easing.InOutQuad }
                NumberAnimation { target: workAreaName; property: "opacity"; to: 0; duration: 500; easing.type: Easing.InOutQuad }
                //NumberAnimation { target: tasksSList; property: "height"; to: 0; duration: 0; easing.type: Easing.InOutQuad }
                //NumberAnimation { target: tasksSList; property: "opacity"; to: 0; duration: 0; easing.type: Easing.InOutQuad }
            }


            // Make sure delayRemove is set back to false so that the item can be destroyed
            PropertyAction { target: mainWorkArea; property: "ListView.delayRemove"; value: false }
        }

        function getTasksList(){
            return tasksSList;
        }

        function clickedWorkarea(){

            instanceOfActivitiesList.setCurrentActivityAndDesktop(mainWorkArea.actCode,mainWorkArea.desktop);

        }


        function getBorderRectangle(){
            return borderRectangle;
        }

        function showButtons(){
            workAreaButtons.state="show";
            workAreaMoreBtn.opacity = 1;
            workareasSignals.calledWorkArea(actCode,desktop);
        }

        function hideButtons(){
            workAreaButtons.state="hide";
            workAreaMoreBtn.opacity = 0;
        }

        Connections{
            target:workareasSignals;
            onEnteredWorkArea:{
                if(workList.tCState === workList.neededState){
                    if ((actCode !== a1)&&(desktop!== d1))
                        hideButtons();
                }
            }
        }


    }//Item

//}//Component




