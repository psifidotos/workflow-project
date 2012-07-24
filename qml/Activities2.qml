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

    //  z:0
    clip:true
    anchors.fill: parent

    property int scaleMeter: zoomSlider.value

    //property real zoomingHeightFactor: ((zoomSlider.value-zoomSlider.minimum)/(zoomSlider.maximum-zoomSlider.minimum))*0.6
    property real zoomingHeightFactor: ((zoomSlider.value-zoomSlider.minimumValue)/(zoomSlider.maximumValue-zoomSlider.minimumValue))*0.6

    property int workareaHeight:(3.6 - zoomingHeightFactor)*scaleMeter
    property int workareaY:2*scaleMeter

    property int workareaWidth: 70+(2.8*mainView.scaleMeter) + (mainView.scaleMeter-5)/3;



    property bool showWinds: true
    property bool lockActivities: false
    property bool showAnimations: false
    property int  animationsStep: showAnimations === true? 200:0
    property int  animationsStep2: showAnimations === true? 200:0

    property bool enablePreviews:false

    onShowWindsChanged: workflowManager.setShowWindows(showWinds);
    onLockActivitiesChanged: {
        workflowManager.setLockActivities(lockActivities);
        activitiesSignals.showActivitiesButtons();
    }

    signal minimumWidthChanged;
    signal minimumHeightChanged;

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

            // property int tempMeter: mainView.scaleMeter/5;

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
            z:4
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

        /*
        Slider {
            id:zoomSlider
            y:mainView.height - height - 5
            x:stoppedPanel.x - width - 5
            maximum: 65
            minimum: 32
            value:50
            width:125
            z:10

            onValueChanged: workflowManager.setZoomFactor(value);

            Image{
                x:-0.4*width
                y:-0.3*height
                width:30
                height:1.5*width
                source:"Images/buttons/magnifyingglass.png"
            }

        }*/

        PlasmaComponents.Slider {
            id:zoomSlider
            y:mainView.height - height
            x:stoppedPanel.x - width - 20
            maximumValue: 75
            minimumValue: 30
            value:50

            width:125
            z:10

            property bool firsttime:true

            onValueChanged: firsttime === false ? workflowManager.setZoomFactor(value) : notFirstTime()

            property bool updateValueWhileDragging:true

            function notFirstTime(){
                firsttime = false;
            }

            /*
            Image{
                id:magnifyingMainIcon
                x:-0.6*width
                //y: -0.2*height
                width:22
                height:1.5*width
                source:"Images/buttons/magnifyingglass.png"
                MouseArea{
                    anchors.fill: parent

                    onClicked:{
                        zoomSlider.value=50;
                    }
                }

            }*/
            //QIconItem{
            Image{
                id:minusSliderImage
                //x:magnifyingMainIcon.width / 2
                x:-width/1.5
                width:30
                height:width
                y:-5

                //icon:QIcon("zoom_out")
                source:"Images/buttons/zoom_out.png"
                smooth:true
                fillMode:Image.PreserveAspectFit

                MouseArea{
                    anchors.fill: parent

                    onClicked:{
                        zoomSlider.value--;
                    }
                }
            }

            //QIconItem{
            Image{
                id:plusSliderImage

                x:zoomSlider.width-width/2
                width:30
                height:width
                y:-5
                //icon:QIcon("zoom_in")
                source:"Images/buttons/zoom_in.png"
                smooth:true
                fillMode:Image.PreserveAspectFit

                MouseArea{
                    anchors.fill: parent

                    onClicked:{
                        zoomSlider.value++;
                    }
                }
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


    Component.onCompleted:{
        DynamAnim.createComponents();
    }

    function getDynLib(){
        return DynamAnim;
    }
    /*-------------------Loading values-------------------*/
    function setShowWindows(v){
        mainView.showWinds = v;
        //      console.debug("ShowW:"+v);
    }
    function setLockActivities(v){
        mainView.lockActivities = v;
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
    Rectangle {
        width: 20; height: 20; z:75; x:0; y:0
        color:"#ffffff"
        visible: mainView.isOnDashBoard

        MouseArea {
            anchors.fill: parent;
            onClicked: {
                mainView.enablePreviews = !mainView.enablePreviews

                if(mainView.enablePreviews === true){
              //      var mId = instanceOfTasksList.getIndexForWorkflowWindow();
                  //  console.debug(mId);
                //    taskManager.setMainWindowId(mId);
                    taskManager.showWindowsPreviews();
                }
            }
        }
    }

    Rectangle{
        id:testerRec
        color:"blue"
        width:10
        height:10
    }


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
            interval:400
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





