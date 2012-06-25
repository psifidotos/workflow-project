// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import "delegates"


Rectangle {
    id: stopActBack

    property alias shownActivities:stoppedActivitiesList.shownActivities

    x:stoppedActivitiesList.shownActivities > 0 ? mainView.width - width : mainView.width - 2
    y:oxygenT.height
    width: 0.66*mainView.workareaWidth
    height: mainView.height - y

    color: "#ebebeb"
    border.color: "#d9808080"
    border.width:1

    Behavior on x{
        NumberAnimation {
            duration: 400;
            easing.type: Easing.InOutQuad;
        }
    }
/*
    Text{
        text:"Stopped Activities"
        width:stopActBack.width
        x:-stopActBack.width/2 + workareaWidth/10
        anchors.verticalCenter: stopActBack.verticalCenter
       // anchors.left: stopActBack.left
        rotation:-90

        color:"#bcbbbb"

        font.family: "Helvetica"
        font.bold: true
        font.pointSize: 6+(mainView.scaleMeter) /10
    }*/

    ListView {
        id: stoppedActivitiesList
        orientation: ListView.Vertical
       // height: shownActivities !==0 ? shownActivities * ((0.66*workareaHeight)+spacing) : workareaHeight
        height: model.count * ((0.66*workareaHeight)+spacing)
        width: stopActBack.width - spacing

        //y:shownActivities===0 ? stopActBack.height : stopActBack.height-height-5
        //y:stopActBack.height-height-5
       // y:stopActBack.height-(shownActivities*0.66*mainView.workareaHeight)
        y:mainView.lockActivities === false ? 1.2*allWorkareas.actImagHeight : 0.3*allWorkareas.actImagHeight

        //   anchors.top: stopActBack.top
        anchors.right: stopActBack.right
        anchors.rightMargin: spacing

       // spacing: workareaHeight/12

        property int shownActivities: 4

        //interactive:false
        model: instanceOfActivitiesList.model

        delegate: ActivityStoppedDeleg{
        }

        Behavior on height{
            NumberAnimation {
                duration: 400;
                easing.type: Easing.InOutQuad;
            }
        }

        Behavior on y{
            NumberAnimation {
                duration: 400;
                easing.type: Easing.InOutQuad;
            }
        }

    }

    Rectangle{
        id:stpActShad
        height: workareaWidth/30
        width: stopActBack.height
     //   anchors.right: stopActBack.left
        rotation: 90
        transformOrigin: Item.TopLeft
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#770f0f0f" }
            GradientStop { position: 1.0; color: "#00797979" }
        }
    }

    function changedChildState(){
        var counter = 0;

        for (var i=0; i<stoppedActivitiesList.model.count; ++i)
        {
            var elem = stoppedActivitiesList.model.get(i);

            if (elem.CState === "Stopped")
               counter++;
        }
      stoppedActivitiesList.shownActivities = counter;
    }

    //return stopped activities listview
    function getList(){
        return stoppedActivitiesList;
    }


}

