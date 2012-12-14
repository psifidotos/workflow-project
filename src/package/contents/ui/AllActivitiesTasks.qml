// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import "delegates"

Item{

    id:allActTasksPanel

    //anchors.bottom: mainView.bottom
    y:mainView.height-height
    width:allActTaskL.shownTasks * allActRect.taskWidth+50
    height:allActRectShad.height+allActRect.height

    x: storedParameters.showWindows && (allActTaskL.shownTasks>0) ? 0 : -width

    property string typeId:"allActivitiesTasks"

    Behavior on x{
        NumberAnimation {
            duration: 3*storedParameters.animationsStep;
            easing.type: Easing.InOutQuad;
        }
    }

    Behavior on width{
        NumberAnimation {
            duration: 3*storedParameters.animationsStep;
            easing.type: Easing.InOutQuad;
        }
    }

    Rectangle{
        id:allActRectShad

        width: allActRect.width+height
        height: workareaY/16
        //y:-3*height/4
        radius:height
        opacity:0.5

        gradient: Gradient {
            GradientStop { position: 0.0; color: "#00797979" }
            GradientStop { position: 1.0; color: "#aa0f0f0f" }
        }
    }

    Rectangle{
        id:allActRectShadR

        rotation: 90
        width: allActRect.height+height
        height: workareaY/16
        opacity:0.6
        x:allActRect.width+height
        y:height
        //radius:height

        transformOrigin:Item.TopLeft

        gradient: Gradient {
            GradientStop { position: 0.0; color: "#00797979" }
            GradientStop { position: 1.0; color: "#aa0f0f0f" }
        }

    }

    Rectangle{
        id:allActRect

        anchors.top: allActRectShad.bottom
        //y:allActRectShad.height/2
        width:parent.width
        height:0.4*workareaY
        color:"#ebebeb"

        //property int taskWidth: 0.75 * mainView.workareaWidth
        property int taskWidth: mainView.workareaWidth

        ListView{
            id:allActTaskL

            anchors.bottom: allActRect.bottom
            anchors.left: allActRect.left

            //width:model.count * allActRect.taskWidth
            //width:(shownTasks+1) * allActRect.taskWidth
            width:allActRect.width
            height:mainView.workareaHeight / 2

            model:instanceOfTasksList.model

            orientation: ListView.Horizontal
            interactive:false

            property int shownTasks:0
            spacing:5

            //Not Used//
            property int contentY // just to skip the warnings
            property int delegHeight
            property bool onlyState1: false
            property string selectedWin:""
            //Not Used//

            delegate: TaskPreviewDeleg{
                showAllActivities: true
                dialogType: allActTasksPanel.typeId

                rWidth: allActRect.taskWidth
                rHeight: allActTaskL.height

                defWidth:(3* allActTaskL.height / 5)
                defPreviewWidth:2.8*defWidth
                defHovPreviewWidth:6*defWidth

                taskTitleTextDef: "#333333"
                taskTitleTextHov: "#333333"

                //Not Used//
                scrollingView: allActTaskL // just to skip the warnings
                centralListView: allActTaskL // just to skip the warnings
                //Not Used//
            }
        }

        Component.onCompleted: allActTasksPanel.changedChildState()

    }

    function changedChildState(){
        var counter = 0;

        for (var i=0; i<allActTaskL.model.count; ++i)
        {
            var elem = allActTaskL.model.get(i);

            if (elem.onAllActivities === true)
//                &&(elem.onAllDesktops === true))
                counter++;
        }

        allActTaskL.shownTasks = counter;
    }

    function getList(){
        return allActTaskL;
    }

    function getTasksList(){
        return allActTaskL;
    }

    function forceState1(){
        allActTaskL.onlyState1 = true;
/*        for(var i=0; i<allActTaskL.children[0].children.length; i++){
            var ch = allActTaskL.children[0].children[i];

            if (ch.mustBeShown===true){
                ch.forceState1 = true;
            }
        }*/

    }

    function unForceState1(){
        allActTaskL.onlyState1 = false;
/*        for(var i=0; i<allActTaskL.children[0].children.length; i++){
            var ch = allActTaskL.children[0].children[i];

            if (ch.mustBeShown===true){
                ch.forceState1 = false;
            }
        }*/

    }

}
