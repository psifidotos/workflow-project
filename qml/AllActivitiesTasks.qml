// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import "delegates"

Item{

    id:allActTasksPanel

    //anchors.bottom: mainView.bottom
    y:mainView.height-height
    width:allActTaskL.shownTasks * allActRect.taskWidth+50
    height:allActRectShad.height+allActRect.height

    x: mainView.showWinds && (allActTaskL.shownTasks>0) ? 0 : -width

    property string typeId:"allActivitiesTasks"

    Behavior on x{
        NumberAnimation {
            duration: 500;
            easing.type: Easing.InOutQuad;
        }
    }

    Behavior on width{
        NumberAnimation {
            duration: 500;
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
        height:50
        color:"#ebebeb"


        property int taskWidth: 0.75 * mainView.workareaWidth


        ListView{
            id:allActTaskL

            anchors.bottom: allActRect.bottom
            width:model.count * allActRect.taskWidth
            height:mainView.workareaHeight / 2

            model:instanceOfTasksList.model

            orientation: ListView.Horizontal
            interactive:false

            property int shownTasks:0

            delegate: AllActTaskDeleg{
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

}
