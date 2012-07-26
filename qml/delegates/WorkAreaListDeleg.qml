// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import ".."
import "ui-elements"

Component{
    Item{
        id: workList

        property string tCState : CState
        property string ccode:code
        property string neededState:"Running"


        property string eelemImg : elemImg

        property int addedHeight:addWorkArea.height + taskOrFTitle.height + taskOrFTitleL.height + orphansList.rHeight

        property bool showWindowsSection:(orphansList.shownOrphanWindows > 0) && (mainView.showWinds === true)

        property string typeId : "workareasActItem"

        state: tCState === neededState ? "show" : "hide"


        property int workAreaImageHeight: mainView.screenRatio*bWidth
        property int workAreaNameHeight:20 + mainView.scaleMeter/2
        property int realWorkAreaNameHeight: 0.8*workAreaNameHeight

        property int bWidth: mainView.workareaWidth
        property int bHeight: (workAreaImageHeight+realWorkAreaNameHeight)*workalist.model.count


        width: bWidth
        height: bHeight+addedHeight


        onHeightChanged: allareas.changedChildHeight();

        onAddedHeightChanged:{
            allareas.changedChildHeight();
        }


        ListView {
            id:workalist

            height:workList.bHeight
            width: workList.tCState === workList.neededState ? workList.bWidth : 0
            property string typeId : "workalistForActivity"

            z:5

            interactive:false

            model:workareas

            orientation:ListView.Vertical

            delegate:WorkAreaDeleg{
            }

            Behavior on height{
                NumberAnimation{
                    duration: 3*mainView.animationsStep2;
                    easing.type: Easing.InOutQuad;
                }
            }

        }

        AddWorkAreaButton{
            id:addWorkArea

            property string typeId : "addWorkArea"

            anchors.top: workalist.bottom
          //  anchors.topMargin: workList.workAreaImageHeight
            anchors.horizontalCenter: workalist.horizontalCenter

            width:0.9*parent.width

            //y: workalist.height+mainView.workareaHeight/5
            //x:0.35 * mainView.scaleMeter

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
           // height: workList.showWindowsSection === true ? 2.6*font.pointSize:0

            //clip:true

            text:i18n("Orphaned Windows")
            font.family: mainView.defaultFont.family
            font.italic: true
            font.bold: true
            font.pointSize: mainView.fixedFontSize+mainView.scaleMeter/9 - 4
            color: "#80808c";

            Behavior on height{
                NumberAnimation{
                    duration: 3*mainView.animationsStep2;
                    easing.type: Easing.InOutQuad;
                }
            }
            Behavior on opacity{
                NumberAnimation{
                    duration: 3*mainView.animationsStep2;
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
                    duration: 3*mainView.animationsStep2;
                    easing.type: Easing.InOutQuad;
                }
            }
            Behavior on opacity{
                NumberAnimation{
                    duration: 3*mainView.animationsStep2;
                    easing.type: Easing.InOutQuad;
                }
            }
        }

        ListView {
            id:orphansList

            width: workList.tCState === workList.neededState ? workList.bWidth : 0

            anchors.topMargin: windsHeight/3
            //y: taskOrFTitleL.height+taskOrFTitle.height

            anchors.top : taskOrFTitleL.bottom
            anchors.left: taskOrFTitleL.left

            property int fontSize: mainView.fixedFontSize+ mainView.scaleMeter/9 - 4
            property int windsHeight:2 * fontSize

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
                    duration: 3*mainView.animationsStep2;
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
            //x: 1 * parent.width
            anchors.right:workalist.right
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
        }
*/

/*
        ListView.onAdd: ParallelAnimation {
         //   PropertyAction { target: workList; property: "width"; value: 0 }
         //   PropertyAction { target: workList; property: "opacity"; value: 0 }

            NumberAnimation { target: workList; property: "width"; to: workList.bWidth; duration: 500; easing.type: Easing.InOutQuad }
            NumberAnimation { target: workList; property: "opacity"; to: 1; duration: 500; easing.type: Easing.InOutQuad }
        }*/

        ListView.onRemove: SequentialAnimation {
            PropertyAction { target: workList; property: "ListView.delayRemove"; value: true }

            ParallelAnimation{
                NumberAnimation { target: workList; property: "width"; to: 0; duration: 500; easing.type: Easing.InOutQuad }
                NumberAnimation { target: workList; property: "opacity"; to: 0; duration: 500; easing.type: Easing.InOutQuad }
            }


            // Make sure delayRemove is set back to false so that the item can be destroyed
            PropertyAction { target: workList; property: "ListView.delayRemove"; value: false }
        }

        states: [
            State {
                name: "show"
                PropertyChanges {
                    target: workList

                    opacity: 1
                    width: bWidth
                //    height: workalist.height + workalist.spacing + addWorkArea.height + mainView.workareaHeight/5
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
                reversible: false
                ParallelAnimation{
                        NumberAnimation {
                            target: workList;
                            property: "opacity";
                            duration: 4*mainView.animationsStep2;
                            easing.type: Easing.InOutQuad;
                        }
                        NumberAnimation {
                            target: workList;
                            property: "width";
                            duration: 4*mainView.animationsStep2;
                            easing.type: Easing.InOutQuad;
                        }
                    }
                },
            Transition {
                from:"show"; to:"hide"
                reversible: false
                ParallelAnimation{
                        NumberAnimation {
                            target: workList;
                            property: "opacity";
                            duration: 4*mainView.animationsStep2;
                            easing.type: Easing.InOutQuad;
                        }
                        NumberAnimation {
                            target: workList;
                            property: "width";
                            duration: 4*mainView.animationsStep2;
                            easing.type: Easing.InOutQuad;
                        }
                    }
                }
        ]

        function getOrphanList(){
            return orphansList;
        }

        function getWorkarea(war){ //desktop counts from 1
            return workalist.children[0].children[war+1];
        }

        function getWorkareaSize(){
            return workalist.model.count;
        }


    }

}
