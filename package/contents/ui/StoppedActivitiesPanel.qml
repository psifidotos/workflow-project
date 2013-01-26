// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import "delegates"
import "tooltips"
import "../code/settings.js" as Settings

import org.kde.plasma.components 0.1 as PlasmaComponents

Rectangle {
    id: stopActBack
    property alias flickableV : stopActivitiesView.interactive

    property alias shownActivities:stoppedActivitiesList.shownActivities

    x:((stoppedActivitiesList.shownActivities > 0)&&(doNotShow === false)) ?
          mainView.width - width : mainView.width - 2
    y:oxygenT.height
    width: 0.5*mainView.workareaWidth
    height: mainView.height - y

    color: "#ebebeb"
    border.color: "#d9808080"
    border.width:1

    property bool doNotShow: !Settings.global.showStoppedPanel

    Behavior on x{
        NumberAnimation {
            duration: 2*Settings.global.animationStep2;
            easing.type: Easing.InOutQuad;
        }
    }

    ///Left Shadow for Stopped Activiies Panel
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
            id:showHideStoppedMouseArea
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

                if (Settings.global.animationStep2 !== 0){
                    var x1 = stopMoreButton.x;
                    var y1 = stopMoreButton.y;

                    var crd = stopMoreButton.mapToItem(mainView,x1, y1);

                    mainView.getDynLib().animateIcon(stopMoreButton.source,
                                                     stopMoreButton.height/stopMoreButton.width,
                                                     stopMoreButton.width,
                                                     crd);

                }

                Settings.global.showStoppedPanel = !Settings.global.showStoppedPanel;

            }
        }

    }

    DToolTip{
        title:i18n("Show/Hide Stopped Activities")
        mainText: i18n("Show or Hide the Stopped Activities in order to enhance your workflow.")
        target:showHideStoppedMouseArea
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
            height:4.03*width
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

    Flickable{
        id: stopActivitiesView

        width: stopActBack.width
        height: stopActBack.height - y

        property int stoppedActivityHeight: 0.62*mainView.workareaHeight

        contentWidth: stoppedActivitiesList.width
        //contentHeight: stoppedActivitiesList.shownActivities*stoppedActivityHeight
        contentHeight:stoppedActivitiesList.height

        boundsBehavior: Flickable.StopAtBounds

        anchors.right: stopActBack.right

        //y:mainView.lockActivities === false ? 1.2*allWorkareas.actImagHeight : 0.3*allWorkareas.actImagHeight
        y:Settings.global.lockActivities === false ? mAddActivityBtn.height : 0

        ListView {
            id: stoppedActivitiesList
            orientation: ListView.Vertical
            // height: shownActivities !==0 ? shownActivities * ((0.66*workareaHeight)+spacing) : workareaHeight
            height: shownActivities * ((0.62*mainView.workareaHeight)+spacing) + 30
            width: stopActBack.width - spacing

            anchors.right: parent.right

            property int shownActivities: 0

            interactive:false
            model: workflowManager.model()

            delegate: ActivityStoppedDeleg{
                onShownChanged:stoppedActivitiesList.countActivities()
            }

            Behavior on height{
                NumberAnimation {
                    duration: 2*Settings.global.animationStep2;
                    easing.type: Easing.InOutQuad;
                }
            }

            Behavior on y{
                NumberAnimation {
                    duration: 2*Settings.global.animationStep2;
                    easing.type: Easing.InOutQuad;
                }
            }

            function countActivities(){
                var counter = 0;

                var slist = stoppedActivitiesList.children[0];

                for(var i=0; i < slist.children.length; ++i)
                    if (slist.children[i].shown === true)
                        counter++;

                shownActivities = counter;
            }

        }

        states: State {
            name: "ShowBars"
            when: stopActivitiesView.movingVertically
            PropertyChanges { target: stopVerticalScrollBar; opacity: 1 }
        }

        transitions: Transition {
            NumberAnimation { properties: "opacity"; duration: 2*Settings.global.animationStep }
        }
    }

    ScrollBar {
        id: stopVerticalScrollBar;
        width: 11;
        height: stopActivitiesView.height
        anchors.top:stopActivitiesView.top
        anchors.right: stopActivitiesView.right
        opacity: 0
        orientation: Qt.Vertical
        position: stopActivitiesView.visibleArea.yPosition
        pageSize: stopActivitiesView.visibleArea.heightRatio
    }

    /*
    PlasmaComponents.ScrollBar {
        id: stopVerticalScrollBar
        width: 12;
        //height: view.height-16
        anchors.right: stopActivitiesView.right
        opacity: 0
        orientation: Qt.Vertical
        flickableItem:stopActivitiesView
    }*/

    ///////Scrolling Indicators////////////
    ///////////////////////////////////////

    Rectangle{
        id:stpActRedShadTop
        anchors.top:stopActivitiesView.top

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
                duration: 2*Settings.global.animationStep;
                easing.type: Easing.InOutQuad;
            }
        }
    }

    Rectangle{
        id:stpActRedShadBottom
        height: workareaWidth/10
        width: stopActBack.width
        anchors.bottom: stopActivitiesView.bottom

        opacity: stopActivitiesView.atYEnd === true ?
                     0 : 0.35

        gradient: Gradient {
            GradientStop { position: 0.0; color: "#00ffffff" }
            GradientStop { position: 1.0; color: "#ff9c0000" }
        }

        Behavior on opacity{
            NumberAnimation {
                duration: 2*Settings.global.animationStep;
                easing.type: Easing.InOutQuad;
            }
        }
    }


    //return stopped activities listview
    function getList(){
        return stoppedActivitiesList;
    }

}

