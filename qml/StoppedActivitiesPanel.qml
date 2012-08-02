// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import "delegates"

import org.kde.plasma.components 0.1 as PlasmaComponents

Rectangle {
    id: stopActBack

    property alias shownActivities:stoppedActivitiesList.shownActivities

    x:((stoppedActivitiesList.shownActivities > 0)&&(doNotShow === false)) ?
          mainView.width - width : mainView.width - 2
    y:oxygenT.height
    width: 0.5*mainView.workareaWidth
    height: mainView.height - y

    color: "#ebebeb"
    border.color: "#d9808080"
    border.width:1

    property bool doNotShow: false


    Behavior on x{
        NumberAnimation {
            duration: 2*mainView.animationsStep2;
            easing.type: Easing.InOutQuad;
        }
    }



    Flickable{
        id: stopActivitiesView

        width: stopActBack.width
        height: stopActBack.height

        property int stoppedActivityHeight: 0.66*mainView.workareaHeight

        contentWidth: stoppedActivitiesList.width
        contentHeight: stoppedActivitiesList.shownActivities*stoppedActivityHeight

        boundsBehavior: Flickable.StopAtBounds

        anchors.right: stopActBack.right


        ListView {
            id: stoppedActivitiesList
            orientation: ListView.Vertical
            // height: shownActivities !==0 ? shownActivities * ((0.66*workareaHeight)+spacing) : workareaHeight
            height: shownActivities * ((0.62*mainView.workareaHeight)+spacing)
            width: stopActBack.width - spacing

            //y:mainView.lockActivities === false ? 1.2*allWorkareas.actImagHeight : 0.3*allWorkareas.actImagHeight
            y:mainView.lockActivities === false ? 1.2*allWorkareas.actImagHeight : 10

            anchors.right: parent.right

            property int shownActivities: 1

            interactive:false
            model: instanceOfActivitiesList.model

            delegate: ActivityStoppedDeleg{
            }

            Behavior on height{
                NumberAnimation {
                    duration: 2*mainView.animationsStep2;
                    easing.type: Easing.InOutQuad;
                }
            }

            Behavior on y{
                NumberAnimation {
                    duration: 2*mainView.animationsStep2;
                    easing.type: Easing.InOutQuad;
                }
            }

        }

        states: State {
            name: "ShowBars"
            when: stopActivitiesView.movingVertically
            PropertyChanges { target: stopVerticalScrollBar; opacity: 1 }
        }

        transitions: Transition {
            NumberAnimation { properties: "opacity"; duration: 2*mainView.animationsStep }
        }
    }

    PlasmaComponents.ScrollBar {
        id: stopVerticalScrollBar
        width: 12;
        //height: view.height-16
        anchors.right: stopActivitiesView.right
        opacity: 0
        orientation: Qt.Vertical
        flickableItem:stopActivitiesView
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



    ///////Scrolling Indicators////////////
    ///////////////////////////////////////



    Rectangle{
        id:stpActRedShadTop
        height: workareaWidth/10
        width: stopActBack.width

        opacity: stopActivitiesView.atYBeginning === true ?
                 0 : 0.35

        gradient: Gradient {
            GradientStop { position: 0.0; color: "#ff9c0000" }
            GradientStop { position: 1.0; color: "#00ffffff" }
        }

        Behavior on opacity{
            NumberAnimation {
                duration: 2*mainView.animationsStep;
                easing.type: Easing.InOutQuad;
            }
        }
    }

    Rectangle{
        id:stpActRedShadBottom
        height: workareaWidth/10
        width: stopActBack.width
        anchors.bottom: stopActBack.bottom

        opacity: stopActivitiesView.atYEnd === true ?
                 0 : 0.35

        gradient: Gradient {
            GradientStop { position: 0.0; color: "#00ffffff" }
            GradientStop { position: 1.0; color: "#ff9c0000" }
        }

        Behavior on opacity{
            NumberAnimation {
                duration: 2*mainView.animationsStep;
                easing.type: Easing.InOutQuad;
            }
        }
    }


    ////////////Show/Hide Button////////////////
    Image{
        source: "Images/buttons/greyRectShadow2.png"
        opacity:0.8
        width:0.67*showStopPanelRec.width
        height:1.55*showStopPanelRec.height
        anchors.right: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -2

        MouseArea{
            anchors.fill: parent
            hoverEnabled: true
            onEntered:{
                stopMoreButton.source = "Images/buttons/plasma_ui/moreBlueVer.png"
                stopMoreButton.hovered = true
            }

            onExited: {
            //    if((stoppedActivitiesList.shownActivities>0)&&
            //            (stopActBack.doNotShow === true))
            //        stopMoreButton.source = "Images/buttons/plasma_ui/moreRedVer.png"
            //    else
                stopMoreButton.source = "Images/buttons/plasma_ui/moreGreyVer.png"
                stopMoreButton.hovered = false
            }

            onClicked:{

                if (mainView.animationsStep2 !== 0){
                    var x1 = stopMoreButton.x;
                    var y1 = stopMoreButton.y;

                    var crd = stopMoreButton.mapToItem(mainView,x1, y1);

                    mainView.getDynLib().animateIcon(stopMoreButton.source,
                                                     stopMoreButton.height/stopMoreButton.width,
                                                     stopMoreButton.width,
                                                     crd);

                }

                stopActBack.doNotShow = (!stopActBack.doNotShow);

            }
        }
    }

    Rectangle{
        id:showStopPanelRec
        width:40
        height:35
        color:parent.color
        radius:4


        anchors.horizontalCenter: parent.left
        anchors.verticalCenter: parent.verticalCenter

        Image{
            id: stopMoreButton
//            source: ((stoppedActivitiesList.shownActivities>0)&&(stopActBack.doNotShow===true)) ?
//                        "Images/buttons/plasma_ui/moreRedVer.png" : "Images/buttons/plasma_ui/moreGreyVer.png"
            source: "Images/buttons/plasma_ui/moreGreyVer.png"
            width:7
            height:3.7*width
            smooth:true

            property bool hovered:false

            opacity:(((stoppedActivitiesList.shownActivities>0)&&(stopActBack.doNotShow===true)) ||
                     (hovered===true)) ?
                    1 : 0.4
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.horizontalCenter
            anchors.rightMargin: 5

        }
    }

    ////////////End of Show/Hide Button////////////////


    function changedChildState(){
        var counter = 0;

        for (var i=0; i<stoppedActivitiesList.model.count; ++i)
        {
            var elem = stoppedActivitiesList.model.get(i);

            if (elem.CState === "Stopped")
                  counter++;
        }
        stoppedActivitiesList.shownActivities = counter;
        //console.debug("Stopped Activitis:"+counter);
    }

    //return stopped activities listview
    function getList(){
        return stoppedActivitiesList;
    }


}

