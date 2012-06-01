// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import "delegates"
import "instances"

import "ui"

import "DynamicAnimations.js" as DynamAnim

Rectangle {
    id:mainView
    width: 1024;  height: 700

    color: "#dcdcdc"

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

    property int currentDesktop: 2

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

    Item{
        id:centralArea
        x: 0
        y:0
        width:mainView.width
        height:mainView.height

        property string typeId: "centralArea"


        WorkAreasAllLists{
            id: allWorkareas
            z:4
        }


        StoppedActivitiesPanel{
            id:stoppedPanel
            z:4
        }


        MainAddActivityButton{
            id: mAddActivityBtn
            z:4
        }

        TitleMainView{
            id:oxygenT
            z:4
        }


        AllActivitiesTasks{
            id:allActT
            z:4
        }


        Slider {
            id:zoomSlider
            // anchors.bottom: mainView.bottom
            // anchors.bottomMargin: 5
            //  anchors.right: stoppedPanel.left
            //  anchors.rightMargin: 5
            y:mainView.height - height - 5
            x:stoppedPanel.x - width - 5
            maximum: 65
            minimum: 35
            value: 50
            width:125
            z:10

            Image{

                x:-0.4*width
                y:-0.3*height
                width:30
                height:1.5*width
                source:"Images/buttons/magnifyingglass.png"
            }

        }

        WorkAreaFull{
            id:wkFull
            z:11
        }

    }

    DraggingInterface{
        id:mDragInt
    }


    Component.onCompleted: DynamAnim.createComponents();

    function getDynLib(){
        return DynamAnim;
    }

}




