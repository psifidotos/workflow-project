import QtQuick 1.1
import org.kde.qtextracomponents 0.1

import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents

Item {
    id: workflow

    property int minimumWidth: 400
    property int minimumHeight: 300

    function popupEventSlot(shown) {
        if(shown)
            centralArea.forceActiveFocus();
    }

    Component.onCompleted: {
        plasmoid.popupIcon = "properties-activities";
        plasmoid.aspectRatioMode = IgnoreAspectRatio;
        plasmoid.popupEvent.connect('popupEvent', popupEventSlot);
    }

    Item {
        id: centralArea
        anchors.fill: parent

        ToolBar {
            id: toolBar
            z: 8
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 42
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
}


