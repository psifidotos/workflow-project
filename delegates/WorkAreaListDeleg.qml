// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import ".."

import ".."

Component{
    Item{
        id: workList

        property string tCState : CState

        property string neededState:"Running"
        property int ccode:code

        property string eelemImg : elemImg

        property int addedHeight:taskOrFTitle.height + taskOrFTitleL.height + orphansList.rHeight



        opacity: CState === neededState ? 1 : 0

        width: CState === neededState ? 1.4 * mainView.workareaHeight : 0
        height: CState === neededState ? workalist.height + workalist.spacing + addWorkArea.height + mainView.workareaHeight/5 : 0

        onHeightChanged: allareas.changedChildHeight();

        property int bWidth: 1.4 * mainView.workareaHeight
        property int bHeight:  mainView.workareaHeight*workalist.model.count+(workalist.model.count-1)*workalist.spacing

        onAddedHeightChanged:{
            allareas.changedChildHeight();
        }

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

        ListView {
            id:workalist

            height:workList.bHeight
            width: CState === "Running" ? workList.bWidth : 0

            x:10
            z:5

            spacing:3+workareaY / 5

            interactive:false

            model:workareas



            delegate:WorkAreaDeleg{
            }

            Behavior on height{
                NumberAnimation{
                    duration: 500;
                    easing.type: Easing.InOutQuad;
                }
            }

        }

        AddWorkAreaButton{
            id:addWorkArea

            z:3

            anchors.top: workalist.bottom
            anchors.topMargin: mainView.workareaHeight/5
            anchors.horizontalCenter: workalist.horizontalCenter

            opacity:  CState === neededState ? 1 : 0

            MouseArea {
                anchors.fill: parent

                onClicked:{
                    var counts = workalist.model.count;
                //    console.debug(counts);
                    var lastobj = workalist.model.get(counts-1);

                    workalist.model.append( {  "elemTitle": "Dynamic",
                                               "elemImg":lastobj.elemImg,
                                               "elemShowAdd":false,
                                               "gridRow":lastobj.gridRow+1,
                                               "gridColumn":lastobj.gridColumn,
                                               "elemTempOnDragging":false} );
                }
            }

        }

        Text{
            id:taskOrFTitle
            anchors.topMargin: mainView.scaleMeter/5
            anchors.top:addWorkArea.bottom
            anchors.left: addWorkArea.left

            width:parent.width
            opacity:orphansList.shownOrphanWindows > 0 ? 1:0
            height:orphansList.shownOrphanWindows > 0 ? 2.6*font.pointSize:0

            //clip:true

            text:"Orphaned Windows"
            font.family: "Helvetica"
            font.italic: true
            font.pointSize: 4+(mainView.scaleMeter/10)
            color: "#80808c";

            Behavior on height{
                NumberAnimation{
                    duration: 500;
                    easing.type: Easing.InOutQuad;
                }
            }
            Behavior on opacity{
                NumberAnimation{
                    duration: 500;
                    easing.type: Easing.InOutQuad;
                }
            }
        }

        Rectangle{
            id:taskOrFTitleL
            width: 0.9 * workList.bWidth
            //y:taskOrFTitle.height
            anchors.top : taskOrFTitle.bottom
            anchors.left: taskOrFTitle.left

            opacity:orphansList.shownOrphanWindows > 0 ? 1:0
            height:orphansList.shownOrphanWindows > 0 ? 2:0
            color:taskOrFTitle.color;

            Behavior on height{
                NumberAnimation{
                    duration: 500;
                    easing.type: Easing.InOutQuad;
                }
            }
            Behavior on opacity{
                NumberAnimation{
                    duration: 500;
                    easing.type: Easing.InOutQuad;
                }
            }
        }

        ListView {
            id:orphansList

            width: CState === "Running" ? workList.bWidth : 0

            anchors.topMargin: windsHeight/3
            //y: taskOrFTitleL.height+taskOrFTitle.height

            anchors.top : taskOrFTitleL.bottom
            anchors.left: taskOrFTitleL.left

            property int fontSiz: 4+ mainView.scaleMeter / 12
            property int windsHeight:3 * fontSiz
            property int rHeight: (shownOrphanWindows+2) * windsHeight //for scrolling in vertical

            height: model.count * windsHeight


            property int shownOrphanWindows: 0

            interactive:false
           // clip:true

            model:instanceOfTasksList.model

            delegate:WorkAreaOrphanTaskDeleg{

            }

            Behavior on height{
                NumberAnimation{
                    duration: 500;
                    easing.type: Easing.InOutQuad;
                }
            }

            function changedOrphansWindows(){
                var counter = 0;                

                for (var i=0; i<orphansList.children[0].children.length; ++i)
                {
                    var chd = orphansList.children[0].children[i];

                    if (chd.shown === true)
                        counter++;
                }                

                orphansList.shownOrphanWindows = counter;

            }

        }

        Rectangle{

            x: 1.05 * parent.width
            width:1
            height:2*mainView.height
            color:"#25727272"
        }


        ListView.onAdd: ParallelAnimation {
            PropertyAction { target: workList; property: "width"; value: 0 }
            PropertyAction { target: workList; property: "opacity"; value: 0 }

            NumberAnimation { target: workList; property: "width"; to: workList.bWidth; duration: 400; easing.type: Easing.InOutQuad }
            NumberAnimation { target: workList; property: "opacity"; to: 1; duration: 500; easing.type: Easing.InOutQuad }
        }

        ListView.onRemove: SequentialAnimation {
            PropertyAction { target: workList; property: "ListView.delayRemove"; value: true }

            ParallelAnimation{
                NumberAnimation { target: workList; property: "width"; to: 0; duration: 400; easing.type: Easing.InOutQuad }
                NumberAnimation { target: workList; property: "opacity"; to: 0; duration: 500; easing.type: Easing.InOutQuad }
            }


            // Make sure delayRemove is set back to false so that the item can be destroyed
            PropertyAction { target: workList; property: "ListView.delayRemove"; value: false }
        }


    }

}
