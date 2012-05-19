// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import "delegates"
import "instances"

import "ui"

Rectangle {
    width: 1024;  height: 700

    color: "#dcdcdc"
    id:mainView
    //  z:0
    clip:true
    anchors.fill: parent

    property int currentColumn:-1
    property int currentRow:-1

    property int scaleMeter:zoomSlider.value

    property real zoomingHeightFactor: ((zoomSlider.value-zoomSlider.minimum)/(zoomSlider.maximum-zoomSlider.minimum))*0.6
    property int workareaHeight:(3.6 - zoomingHeightFactor)*scaleMeter
    property int workareaY:2*scaleMeter

    property int workareaWidth: 70+(2.8*mainView.scaleMeter) + (mainView.scaleMeter-5)/3;

    property bool showWinds: true
    property bool lockActivities: false

    Behavior on scaleMeter{
        NumberAnimation {
            duration: 100;
            easing.type: Easing.InOutQuad;
        }
    }

    SharedActivitiesList{
        id:instanceOfActivitiesList
    }

    SharedWorkareasList{
        id:instanceOfWorkAreasList
    }

    SharedTasksList{
        id:instanceOfTasksList
    }

    ActivityAnimationMainView{
        id:activityAnimate
    }

    BtnIconAnimatMainView{
        id:btnIconAnimate
    }

    WorkAreasAllLists{
        id: allWorkareas
    }


    StoppedActivitiesPanel{
        id:stoppedPanel
    }


    MainAddActivityButton{
        id: mAddActivityBtn
    }

    TitleMainView{
        id:oxygenT
    }


    AllActivitiesTasks{
        id:allActT
    }

    Slider {
        id:zoomSlider
        anchors.bottom: mainView.bottom
        anchors.bottomMargin: 5
        anchors.right: stoppedPanel.left
        anchors.rightMargin: 5
        maximum: 65
        minimum: 35
        value: 50
        width:125

    }

}




