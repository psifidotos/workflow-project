import QtQuick 1.0
import ".."
import "ui-elements"

Component{

 Item{
     id: mainWorkArea

     property alias normalStateArea_visible: normalStateWorkArea.visible
     property alias workAreaName_visible: workAreaName.visible
     property alias areaButtons_visible: workAreaButtons.visible

     width: 1.4 * mainView.workareaHeight
     height:mainView.workareaHeight

     property string typeId : "workareaDeleg"

     property string actCode: workList.ccode
     property int desktop: gridRow

     property int imagex:14
     property int imagey:15
     property int imagewidth:borderRectangle.width-2*imagex
     property int imageheight:borderRectangle.height-2*imagey

        Item{
            id:normalWorkArea

            x:mainView.scaleMeter/10; y:x;
            width: mainWorkArea.width - (mainView.scaleMeter/5);
            height: mainWorkArea.height + (0.6*mainView.scaleMeter);

            Behavior on x { enabled: normalWorkArea.state!="dragging"; NumberAnimation { duration: 400; easing.type: Easing.OutBack } }
            Behavior on y { enabled: normalWorkArea.state!="dragging"; NumberAnimation { duration: 400; easing.type: Easing.OutBack } }

            state:"s1"


            Row{
                id:normalStateWorkArea
                spacing: 0

                WorkAreaImage{
                    id:borderRectangle
                    width: normalWorkArea.width
                    height: normalWorkArea.height -  (4*mainView.scaleMeter/5)

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
                }




            }//Row
            ListView{

                id:tasksSList

                x:mainWorkArea.imagex
                y:mainWorkArea.imagey
                width:mainWorkArea.imagewidth
                height:mainView.showWinds ? mainWorkArea.imageheight : 0
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
                        duration: 500
                        easing.type: Easing.InOutQuad;
                    }
                }

                Behavior on height{
                    NumberAnimation {
                        duration: 500
                        easing.type: Easing.InOutQuad;
                    }
                }
            }

            WorkAreaBtns{
                id:workAreaButtons
                //height: normalWorkArea.height -  (4*mainView.scaleMeter/5)

                x:borderRectangle.width+borderRectangle.x - 0.85*width
                y:-0.25*height
                opacity: mainWorkArea.ListView.view.model.count>1 ? 1 : 0
            }


            DTextLine{
                id:workAreaName
                y: normalStateWorkArea.height-7
                width: 50 + 3.3*mainView.scaleMeter
                height: 20 + mainView.scaleMeter/2
                text: elemTitle
               // acceptedText: elemTitle
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
                        duration: 500
                        easing.type: Easing.InOutQuad;
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true

                    onClicked: {
                        workAreaMoreBtn.onClicked();
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


            states: [
                State {
                    name: "s1"
                    PropertyChanges {
                        target: mainWorkArea
                        normalStateArea_visible: true
                        workAreaName_visible:true
                    }
                }
            ]

            transitions: Transition { NumberAnimation { property: "scale"; duration: 150} }

        } //Column

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
                if ((actCode !== a1)&&(desktop!== d1))
                    hideButtons();
            }
        }


    }//Item

}//Component




