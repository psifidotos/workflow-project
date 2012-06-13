// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import ".."

import ".."

Component{
    Item{
        id: workList

        property string tCState : CState

        property string neededState:"Running"
        property string ccode:code

        property string eelemImg : elemImg

        property int addedHeight:taskOrFTitle.height + taskOrFTitleL.height + orphansList.rHeight

        property bool showWindowsSection:(orphansList.shownOrphanWindows > 0) && (mainView.showWinds === true)

        property string typeId : "workareasActItem"

        state: tCState === neededState ? "show" : "hide"

        onHeightChanged: allareas.changedChildHeight();

        property int bWidth: 1.4 * mainView.workareaHeight
        property int bHeight:  mainView.workareaHeight*workalist.model.count+(workalist.model.count-1)*workalist.spacing

        onAddedHeightChanged:{
            allareas.changedChildHeight();
        }


        ListView {
            id:workalist

            height:workList.bHeight
            width: workList.CState === "Running" ? workList.bWidth : 0
            property string typeId : "workalistForActivity"

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

            property string typeId : "addWorkArea"

            anchors.top: workalist.bottom
            anchors.topMargin: mainView.workareaHeight/5
            anchors.horizontalCenter: workalist.horizontalCenter

            opacity: workList.tCState === workList.neededState ? 1 : 0

            MouseArea {
                anchors.fill: parent

                onClicked:{
                    instanceOfWorkAreasList.addWorkarea(code);
                }
            }

        }

        Text{
            id:taskOrFTitle
            anchors.topMargin: mainView.scaleMeter/5
            anchors.top:addWorkArea.bottom
            anchors.left: addWorkArea.left

            width:parent.width
            opacity: workList.showWindowsSection === true ? 1:0
            height: workList.showWindowsSection === true ? 2.6*font.pointSize:0

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

            opacity: workList.showWindowsSection === true ? 1:0
            height: workList.showWindowsSection === true ? 2:0
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

            width: tCState === "Running" ? workList.bWidth : 0

            anchors.topMargin: windsHeight/3
            //y: taskOrFTitleL.height+taskOrFTitle.height

            anchors.top : taskOrFTitleL.bottom
            anchors.left: taskOrFTitleL.left

            property int fontSiz: 4+ mainView.scaleMeter / 12
            property int windsHeight:3 * fontSiz

            //for scrolling in vertical
            opacity: workList.showWindowsSection === true ? 1 : 0
            property int rHeight: workList.showWindowsSection === true ? (shownOrphanWindows+2) * windsHeight : 0

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

/*
        ListView.onAdd: ParallelAnimation {
            PropertyAction { target: workList; property: "state"; value: "show" }
        }

        ListView.onRemove: SequentialAnimation {
            PropertyAction { target: workList; property: "ListView.delayRemove"; value: true }

            ParallelAnimation{
                    PropertyAction { target: workList; property: "state"; value: "hide" }
            }
            // Make sure delayRemove is set back to false so that the item can be destroyed
            PropertyAction { target: workList; property: "ListView.delayRemove"; value: false }
        }*/


/*
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
        }*/

        states: [
            State {
                name: "show"
                PropertyChanges {
                    target: workList

                    opacity: 1
                    width: 1.4 * mainView.workareaHeight
                    height: workalist.height + workalist.spacing + addWorkArea.height + mainView.workareaHeight/5
                }
            },
           State {
               name: "hide"
               PropertyChanges {
                   target: workList

                   opacity: 0
                   width: 0
                  // height: 0
               }
            }
        ]

        transitions: [

            Transition {
                from:"hide"; to:"show"
                reversible: true
                ParallelAnimation{
                        NumberAnimation {
                            target: workList;
                            property: "opacity";
                            duration: 700;
                            easing.type: Easing.InOutQuad;
                        }
                        NumberAnimation {
                            target: workList;
                            property: "width";
                            duration: 700;
                            easing.type: Easing.InOutQuad;
                        }
                    }
                }
        ]

        function getOrphanList(){
            return orphansList;
        }

        function getWorkarea(war){
            return workalist.children[0].children[war];
        }

        function getWorkareaSize(){
            return workalist.model.count;
        }


    }

}
