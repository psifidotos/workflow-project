// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.qtextracomponents 0.1


import "delegates"
import "delegates/ui-elements"
import "instances"

import "ui"

import "DynamicAnimations.js" as DynamAnim

Rectangle {
    id:mainView
    objectName: "instMainView"


    color: "#dcdcdc"

    clip:true
    anchors.fill: parent

    property int scaleMeter: zoomSlider.value

    //property real zoomingHeightFactor: ((zoomSlider.value-zoomSlider.minimum)/(zoomSlider.maximum-zoomSlider.minimum))*0.6
    property real zoomingHeightFactor: ((zoomSlider.value-zoomSlider.minimumValue)/(zoomSlider.maximumValue-zoomSlider.minimumValue))*0.6

    property int workareaWidth: 70+(2.8*mainView.scaleMeter) + (mainView.scaleMeter-5)/3;
    property int workareaHeight:(3.6 - zoomingHeightFactor)*scaleMeter
    property int workareaY:2*scaleMeter



    //Applications properties/////
    property bool lockActivities: false
    property bool showWinds: true
    property bool enablePreviews: false

    property bool effectsSystemEnabled: true

    property int  showAnimations: 0
    property int  animationsStep: showAnimations >= 1 ? 200:0
    property int  animationsStep2: showAnimations >= 2 ? 200:0

    property variant defaultFont: theme.defaultFont

    property real defaultFontSize:theme.defaultFont.pointSize
    property real defaultFontRelativeness: 0
    property real fixedFontSize: defaultFontSize + defaultFontRelativeness

    //With using KWindowSystem workarea
    property real screenRatio:0.75


    onShowWindsChanged: workflowManager.setShowWindows(showWinds);
    onLockActivitiesChanged: {
        workflowManager.setLockActivities(lockActivities);
        activitiesSignals.showActivitiesButtons();
    }

    signal minimumWidthChanged;
    signal minimumHeightChanged;


    //Local properties//
    property string currentActivity
    property int currentDesktop
    property int maxDesktops
    property bool isOnDashBoard:true //development purposes,must be changed to false in the official release


    /*
    Behavior on scaleMeter{
        NumberAnimation {
            duration: 150;
            easing.type: Easing.InOutQuad;
        }
    }*/

    SharedActivitiesList{
        id:instanceOfActivitiesList
        objectName: "instActivitiesEngine"
    }

    SharedWorkareasList{
        id:instanceOfWorkAreasList
    }

    SharedTasksList{
        id:instanceOfTasksList
        objectName: "instTasksEngine"
    }

    Item{
        id:centralArea
        x: 0
        y:0
        width:mainView.width
        height:mainView.height

        property string typeId: "centralArea"
        BorderImage {
            id:selectionImage
            source: "Images/buttons/selectedBlue.png"

            border.left: 50; border.top: 50;
            border.right: 60; border.bottom: 50;
            horizontalTileMode: BorderImage.Repeat
            verticalTileMode: BorderImage.Repeat

            z:5

            opacity:0

            Behavior on opacity{
                NumberAnimation {
                    duration: 500;
                    easing.type: Easing.InOutQuad;
                }
            }

            function setLocation(x1,y1,w1,h1){
                x= x1-25;
                y= y1-25;
                width=w1+55;
                height=h1+50;
            }
        }


        WorkAreasAllLists{
            id: allWorkareas
            z:4
        }


        StoppedActivitiesPanel{
            id:stoppedPanel
            z:6
        }


        MainAddActivityButton{
            id: mAddActivityBtn
            z:7
        }

        TitleMainView{
            id:oxygenT
            z:8
        }


        AllActivitiesTasks{
            id:allActT
            z:7
        }


        ZoomSliderItem{
            id:zoomSlider
        }

        WorkAreaFull{
            id:wkFull
            z:11
        }

    }


    DraggingInterface{
        id:mDragInt
    }


    Component.onCompleted:{

        DynamAnim.createComponents();

        oxygenT.lockerChecked = mainView.lockActivities
        oxygenT.windowsChecked = mainView.showWinds
        oxygenT.effectsChecked = mainView.enablePreviews
    }

    function getDynLib(){
        return DynamAnim;
    }
    /*-------------------Loading values-------------------*/
    function setShowWindows(v){
        mainView.showWinds = v;
        oxygenT.windowsChecked = v;
        //      console.debug("ShowW:"+v);
    }
    function setLockActivities(v){
        mainView.lockActivities = v;
        oxygenT.lockerChecked = v;
       //     console.debug("LockA:"+ v);
    }
    function setZoomSlider(v){
        zoomSlider.value = v;
        //    console.debug("Zoom:"+v);
    }

    function setAnimations(v){
        //
    }

    function setIsOnDashboard(v){
        // BE CAREFUL:: should be enabled in the official release...

        // mainView.isOnDashBoard = v;
    }



    /*
    onMinimumWidthChanged:{
        if(mainView.minimumWidth>mainView.width)
            main{View.width = mainView.minimumWidth
    }

    onMinimumHeightChanged:{
        if(mainView.minimumHeight>mainView.height)
            mainView.height = mainView.minimumHeight
    }*/

    /*---------- Central Controllers For Signals **********/

    Item{
        id:workareasSignals
        signal enteredWorkArea(string a1,int d1);

        property string act1: ""
        property string desk1: ""

        function calledWorkArea(a1, d1){
            if ((act1 !== a1) || (d1 !== desk1)){
                act1 = a1;
                desk1 = d1;
                enteredWorkArea(a1, d1);
            }
        }
    }

    Item{
        id:activitiesSignals
        signal showButtons
        signal hideButtons

        Timer{
            id:activitiesTimer
            interval:3*mainView.animationsStep
            repeat:false
            onTriggered: {
                activitiesSignals.hideButtons();
            }
        }

        function showActivitiesButtons(){
            showButtons();
            activitiesTimer.start();
        }
    }


    /*--------------------Dialogs ---------------- */
    RemoveDialogTmpl{
        id:removeDialog
    }

}





