// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.qtextracomponents 0.1

import "delegates"
import "delegates/ui-elements"
import "instances"
import "helptour"

import "DynamicAnimations.js" as DynamAnim


Item {
    id: mainView
    clip:true
    /*property Component compactRepresentation: Component {
        Rectangle {
            anchors.fill: parent
            color: "blue"
        }
    }*/

    Item{
        id:centralArea
        anchors.fill: parent

        ToolBar {
            id: toolBar
            z: 8
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 32
            activitiesLocked: lockActivities
        }

        ActivitiesList {
            id: allWorkareas
            z:4

            anchors.top: toolBar.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            scale: mainView.scaleMeter
            animationsStep: mainView.animationsStep
            locked: lockActivities
        }

//        StoppedActivitiesPanel{
//            id:stoppedPanel
//            z:6
//        }
//
//        MainAddActivityButton{
//            id: mAddActivityBtn
//            z:7
//        }
//
//        AllActivitiesTasks{
//            id:allActT
//            z:7
//        }

        ZoomSliderItem{
            id:zoomSlider
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            z:10

            onValueChanged: workflowManager.setZoomFactor(value)
        }
    }

    Component.onCompleted:{
        plasmoid.popupIcon = "konqueror"
        console.log(plasmoid.popupIcon)
        plasmoid.setMinimumSize(200,200)
        DynamAnim.createComponents();
    }
}


