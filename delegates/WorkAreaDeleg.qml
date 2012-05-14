import QtQuick 1.0
import ".."

Component{

 Item{
     id: mainWorkArea

     property alias normalStateArea_visible: normalStateWorkArea.visible
     property alias workAreaName_visible: workAreaName.visible
     property alias areaButtons_visible: workAreaButtons.visible

     width: 1.4 * mainView.workareaHeight
     height:mainView.workareaHeight

     property int actCode: code

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
                            workAreaButtons.state="show"
                        }

                        onExited: {
                            workAreaButtons.state="hide"
                        }


                    }//image mousearea
                }

                WorkAreaBtns{
                    id:workAreaButtons
                    height: normalWorkArea.height -  (4*mainView.scaleMeter/5)

                    opacity: mainWorkArea.ListView.view.model.count>1 ? 1 : 0

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true

                        onEntered: {
                            workAreaButtons.state="show"
                        }

                        onExited: {
                            workAreaButtons.state="hide"
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

            DTextLine{
                id:workAreaName
                y: normalStateWorkArea.height-7
                width: 50 + 3.3*mainView.scaleMeter
                height: 20 + mainView.scaleMeter/2
                text: elemTitle
               // acceptedText: elemTitle
            }

            states: [
                State {
                    name: "s1"
                    PropertyChanges {
                        target: mainWorkArea
                        normalStateArea_visible: true
                        workAreaName_visible:true
                    }
                },
                State {
                    name:"hidden"
                    when: (!elemVisible)
                    PropertyChanges {
                        target: mainWorkArea
                        normalStateArea_visible: false
                        workAreaName_visible:false
                        areaButtons_visible:false
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

            ParallelAnimation{
                  NumberAnimation { target: mainWorkArea; property: "height"; to: 0; duration: 500; easing.type: Easing.InOutQuad }
                  NumberAnimation { target: borderRectangle; property: "height"; to: 0; duration: 500; easing.type: Easing.InOutQuad }
                  NumberAnimation { target: borderRectangle; property: "opacity"; to: 0; duration: 500; easing.type: Easing.InOutQuad }
                  NumberAnimation { target: workAreaButtons; property: "opacity"; to: 0; duration: 500; easing.type: Easing.InOutQuad }
                  NumberAnimation { target: workAreaName; property: "opacity"; to: 0; duration: 500; easing.type: Easing.InOutQuad }
            }


            // Make sure delayRemove is set back to false so that the item can be destroyed
            PropertyAction { target: mainWorkArea; property: "ListView.delayRemove"; value: false }
        }


    }//Item

}//Component




