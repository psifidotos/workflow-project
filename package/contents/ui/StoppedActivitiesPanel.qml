// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import "delegates"
import "../code/settings.js" as Settings

import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.plasma.core 0.1 as PlasmaCore

Rectangle {
    id: stopActBack
    property alias flickableV : stopActivitiesView.interactive

    property alias shownActivities:stoppedActivitiesList.shownActivities
    property string typeId : "StoppedActivitiesPanel"

    property bool hiddenList: ((shownActivities === 0) || (doNotShow))
    property bool showAddButton: !Settings.global.lockActivities

    x:((stoppedActivitiesList.shownActivities > 0)&&( !doNotShow)) ?
          mainView.width - width : mainView.width - 2
    //y:oxygenT.height

    y:((!Settings.global.lockActivities && !hiddenList) ||
       (Settings.global.disableBackground && !hiddenList && !Settings.global.lockActivities ) )?
          (mAddActivityBtn.height+oxygenT.height-border.width) : oxygenT.height+border.width

    width: 0.5*mainView.workareaWidth
    height: mainView.height - y

    color: "#00ebebeb"
    border.color: "#d9808080"
    border.width:1

    property bool doNotShow: !Settings.global.showStoppedPanel

    Behavior on x{
        NumberAnimation {
            duration: 2*Settings.global.animationStep2;
            easing.type: Easing.InOutQuad;
        }
    }

    Behavior on y{
        NumberAnimation {
            duration: 2*Settings.global.animationStep;
            easing.type: Easing.InOutQuad;
        }
    }

    ////////////Show/Hide Button////////////////
    Image{
        source: "Images/buttons/greyRectShadow2.png"
        opacity:0.75
        width:1.28*showStopPanelRec.width
        height:1.43*showStopPanelRec.height
        anchors.right: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -2

        MouseArea{
            id:showHideStoppedMouseArea
            anchors.fill: parent
            hoverEnabled: true

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

    Rectangle{
        id:showStopPanelRec
        width:22
        height:35

        color:"transparent"
       // radius:1
    //    border.width: 1

        x:-width+radius-1

        anchors.verticalCenter: parent.verticalCenter

        Rectangle{
            width:parent.width
            height:parent.height
            radius: 3
            opacity: Settings.global.disableBackground ? backgroundRectangle.opacity : 1
            color: backgroundRectangle.color
            border.color: "#d9808080"
            border.width: 1
        }

        Image{
            id: stopMoreButton
            source: hovered ? "Images/buttons/plasma_ui/moreBlueVer.png" : "Images/buttons/plasma_ui/moreGreyVer.png"
            width:7
            height:4.03*width
            smooth:true

            property alias hovered:showHideStoppedMouseArea.containsMouse

            opacity:(((stoppedActivitiesList.shownActivities>0)&&(stopActBack.doNotShow===true)) ||
                     (hovered===true)) ?
                        1 : 0.4
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            visible:!Settings.global.disableBackground
        }


        Item{
            visible:Settings.global.disableBackground
            width:7
            height:parent.height
            anchors.horizontalCenter: parent.horizontalCenter
            opacity: showHideStoppedMouseArea.containsMouse ? 0.8 : 0.2
            Column{
                spacing:3
                anchors.verticalCenter: parent.verticalCenter
                Repeater{
                    model:3
                    Rectangle{
                        width:6
                        height:width
                        radius:3
                        color: theme.textColor
                    }
                }
            }
        }
    }

    Rectangle{
        id:backgroundRectangle
        width: parent.width
        height: parent.height
        opacity: Settings.global.disableBackground ? 0.10 : 1
        color: Settings.global.disableBackground ?  theme.textColor : "#ebebeb"
    }

    ///Left Shadow for Stopped Activiies Panel
    Rectangle{
        id:stpActShad
        height: workareaWidth/50
        width: stopActBack.height
        //   anchors.right: stopActBack.left
        rotation: 90
        transformOrigin: Item.TopLeft
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#770f0f0f" }
            GradientStop { position: 1.0; color: "#00797979" }
        }
    }



    PlasmaCore.ToolTip{
        target:showHideStoppedMouseArea
        mainText:i18n("Show/Hide Stopped Activities List")
        subText: i18n("Show or Hide the Stopped Activities List to enhance your workflow.")
    }



    ////////////End of Show/Hide Button////////////////

    Flickable{
        id: stopActivitiesView
        property string typeId : "StoppedActivitiesFlickable"
        width: stopActBack.width
        height: stopActBack.height - y

        property int stoppedActivityHeight: 0.62*mainView.workareaHeight

        contentWidth: stoppedActivitiesList.width
        //contentHeight: stoppedActivitiesList.shownActivities*stoppedActivityHeight
        contentHeight:stoppedActivitiesList.height

        boundsBehavior: Flickable.StopAtBounds

        anchors.right: stopActBack.right
        clip:true

        //y:(!Settings.global.lockActivities) ? mAddActivityBtn.height : 0

        ListView {
            id: stoppedActivitiesList
            orientation: ListView.Vertical
            // height: shownActivities !==0 ? shownActivities * ((0.66*workareaHeight)+spacing) : workareaHeight
            height: shownActivities * ((0.62*mainView.workareaHeight)+spacing) + 30
            width: stopActBack.width - spacing
            property string typeId : "StoppedActivitiesList"
            anchors.right: parent.right

            property int shownActivities: model.count

            interactive:false
            model: stoppedActivitiesModel
            delegate: ActivityStoppedDeleg{
                id:activityInstance

                MouseArea{
                    id:draggingReceiver

                    property string typeId: "activityReceiver"

                    width: activityInstance.width
                    height:activityInstance.height-5
                    visible: ((draggingActivities.activityId !== "") &&
                              (draggingActivities.activityStatus === "Stopped"))

                    property string activityCode : ccode
                    property string activityName : Name

                    hoverEnabled: true
                    property int oldX
                    property int oldY

                    onVisibleChanged:{
                        if(visible){
                            oldX = x;
                            oldY = y;
                            var coord = mapToItem(draggingActivities, x, y);
                            parent = draggingActivities;
                            x = coord.x;
                            y = coord.y;
                        }
                        else{
                            parent = activityInstance;
                            x = oldX;
                            y = oldY;
                        }
                    }

                    //     //       Rectangle{
                    //         anchors.fill: parent
                    //          color:"#0000e3"
                    //    }

                }
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

