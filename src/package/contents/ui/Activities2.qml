// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.qtextracomponents 0.1

import "delegates"
import "delegates/ui-elements"
import "instances"
import "helptour"

//import "ui"

import "DynamicAnimations.js" as DynamAnim

Rectangle {
    id:mainView
    objectName: "instMainView"

    color: "#dcdcdc"

    clip:true
    anchors.fill: parent

    property string version:"v0.2.91"

    property int scaleMeter: zoomSlider.value

    //property real zoomingHeightFactor: ((zoomSlider.value-zoomSlider.minimum)/(zoomSlider.maximum-zoomSlider.minimum))*0.6
    property real zoomingHeightFactor: ((zoomSlider.value-zoomSlider.minimumValue)/(zoomSlider.maximumValue-zoomSlider.minimumValue))*0.6

    property int workareaWidth: 70+(2.8*mainView.scaleMeter) + (mainView.scaleMeter-5)/3;
    property int workareaHeight:(3.6 - zoomingHeightFactor)*scaleMeter
    property int workareaY:2*scaleMeter

    //Applications properties/////

   // property bool enablePreviews: false

    property bool effectsSystemEnabled: true

   // property int previewsOffsetX: 13
   // property int previewsOffsetY: 42

    //property alias hideStoppedPanel: stoppedPanel.doNotShow

    property variant defaultFont: theme.defaultFont

    property color defaultFontColor:theme.textColor
    property real defaultFontSize:theme.defaultFont.pointSize
    //property real defaultFontRelativeness: 0

    property real defFontRelStep: storedParameters.fontRelevance/20
    property real fixedFontSize: defaultFontSize + storedParameters.fontRelevance

    property bool disablePreviewsWasForcedInDesktopDialog:false //as a reference to DesktopDialog because it is dynamic from now one
    //With using KWindowSystem workarea
    property real screenRatio:0.75

    property bool firstRunTour:false
    property bool firstRunCalibration:false

    property int themePos:0

    property int toolTipsDelay:300
 //   property int pressAndHoldInterval:120

//    onShowWindsChanged: workflowManager.setShowWindows(showWinds);

  //  onLockActivitiesChanged: {
        //workflowManager.setLockActivities(lockActivities);
      //  activitiesSignals.showActivitiesButtons();
 //   }
  //  onShowAnimationsChanged: workflowManager.setAnimations(showAnimations);
 //   onEnablePreviewsChanged: workflowManager.setWindowsPreviews(enablePreviews);
 //   onPreviewsOffsetXChanged: workflowManager.setWindowsPreviewsOffsetX(previewsOffsetX);
 //   onPreviewsOffsetYChanged: workflowManager.setWindowsPreviewsOffsetY(previewsOffsetY);
 //   onDefaultFontRelativenessChanged: workflowManager.setFontRelevance(defaultFontRelativeness);
  //  onHideStoppedPanelChanged: workflowManager.setShowStoppedActivities(!hideStoppedPanel);
    onFirstRunTourChanged: workflowManager.setFirstRunLiveTour(firstRunTour);
    onFirstRunCalibrationChanged: workflowManager.setFirstRunCalibrationPreviews(firstRunCalibration);

    signal minimumWidthChanged;
    signal minimumHeightChanged;

    //Local properties//
    property string currentActivity
    property int currentDesktop
    property int maxDesktops
    property bool isOnDashBoard:true //development purposes,must be changed to false in the official release

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

    SharedTasksDesktopList{
        id:instanceOfTasksDesktopList
    }

    SharedThemeList{
        id:instanceOfThemeList
    }

    Item{
        id:centralArea
        anchors.fill: parent

        property string typeId: "centralArea"
        BorderImage {
            id:selectionImage
            source: "Images/buttons/selectedBlue.png"

            border.left: 50; border.top: 50;
            border.right: 60; border.bottom: 50;
            horizontalTileMode: BorderImage.Repeat
            verticalTileMode: BorderImage.Repeat

            x:0
            y:0
            width:0
            height:0

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

            /* Should use anchors, but they seem to break the flickable area */
            //anchors.top: oxygenT.bottom
            //anchors.bottom: mainView.bottom
            //anchors.left: mainView.left
            //anchors.right: mainView.right
            y:oxygenT.height
            width:mainView.width
            height:mainView.height - y
            verticalScrollBarLocation: stoppedPanel.x

            workareaWidth: mainView.workareaWidth
            workareaHeight: mainView.workareaHeight
            scale: mainView.scaleMeter
            animationsStep: storedParameters.animationsStep
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
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            z:10

          //  onValueChanged: workflowManager.setZoomFactor(value)
            onValueChanged: storedParameters.zoomFactor = value;
        }
    }

    DraggingInterface{
        id:mDragInt
    }

    Component.onCompleted:{

        DynamAnim.createComponents();

     //   oxygenT.lockerChecked = mainView.lockActivities
     //   oxygenT.windowsChecked = mainView.showWinds
    //    oxygenT.effectsChecked = mainView.enablePreviews
    }

    function getDynLib(){
        return DynamAnim;
    }
    /*-------------------Loading values-------------------*/
 /*   function setShowWindows(v){
        mainView.showWinds = v;
        oxygenT.windowsChecked = v;
    }*/
 /*   function setLockActivities(v){
    //    mainView.lockActivities = v;
    //    oxygenT.lockerChecked = v;
    }*/
  /*  function setZoomSlider(v){
        zoomSlider.value = v;
    }*/

 /*   function setAnimations(v){
        mainView.showAnimations = v;
    }*/

    function setIsOnDashboard(v){
        //
        // BE CAREFUL:: should be enabled in the official release...
        //

        mainView.isOnDashBoard = v;
    }

    /*
    function setWindowsPreviews(b){
        mainView.enablePreviews = b;
        oxygenT.effectsChecked = mainView.enablePreviews;
    }

    function setWindowsPreviewsOffsetX(x){
        mainView.previewsOffsetX = x;
    }

    function setWindowsPreviewsOffsetY(y){
        mainView.previewsOffsetY = y;
    }

    function setFontRelevance(fr){
        mainView.defaultFontRelativeness = fr;
    }

    function setShowStoppedActivities(s){
        mainView.hideStoppedPanel = !s;
    }*/

    function setFirstRunLiveTour(f){
        mainView.firstRunTour = f;
        if(f===false){
            getDynLib().showFirstHelpTourDialog();
        }
    }

    function setFirstRunCalibrationPreviews(cal){
        mainView.firstRunCalibration = cal;
    }

    function setEffectsSystem(ef){
        mainView.effectsSystemEnabled = ef;
    }

    function setScreenRatio(sc){
        mainView.screenRatio = sc;
    }

    function setCurrentTheme(th){
        mainView.themePos = instanceOfThemeList.getIndexFor(th);
    }

    function setToolTipsDelay(dl){
        mainView.toolTipsDelay = dl;
    }

    function loadThemes() {
        for(var i=0; i<instanceOfThemeList.model.count; ++i)
            workflowManager.addTheme(instanceOfThemeList.model.get(i).name);
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
            interval:200+storedParameters.animationsStep
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

    //Just to ignore the warnings
    signal completed;
    property bool disablePreviews;

    property variant removeDialog:mainView
    property variant cloningDialog:mainView
    property variant desktopDialog:mainView
    property variant calibrationDialog:mainView
    property variant busyIndicatorDialog:mainView

    property variant liveTourDialog:mainView
    property variant aboutDialog:mainView

    property variant firstHelpTourDialog:mainView
    property variant firstCalibrationDialog:mainView

  /************* Deleteing Dialogs  ***********************/
    Connections{
        target:removeDialog
        onCompleted:{
         //   console.debug("Delete Remove...");
            mainView.getDynLib().deleteRemoveDialog();
        }
    }

    Connections{
        target:cloningDialog
        onCompleted:{
        //    console.debug("Delete Cloning...");
            mainView.getDynLib().deleteCloneDialog();
        }
    }

    Connections{
        target:desktopDialog
        onCompleted:{
          //  console.debug("Delete Desktop Dialog...");
            mainView.getDynLib().deleteDesktopDialog();
        }

        onDisablePreviewsChanged:{
            mainView.disablePreviewsWasForcedInDesktopDialog = desktopDialog.disablePreviews;
        }
    }

    Connections{
        target:calibrationDialog
        onCompleted:{
          //  console.debug("Delete Calibration Dialog...");
            mainView.getDynLib().deleteCalibrationDialog();
        }
    }

    Connections{
        target:liveTourDialog
        onCompleted:{
           // console.debug("Delete Livetour Dialog...");
            mainView.getDynLib().deleteLiveTourDialog();
        }
    }

    Connections{
        target:aboutDialog
        onCompleted:{
            mainView.getDynLib().deleteAboutDialog();
        }
    }

    Connections{
        target:firstHelpTourDialog
        onCompleted:{
            mainView.getDynLib().deleteFirstHelpTourDialog();
            if(firstRunTour === false)
                workflowManager.setFirstRunLiveTour(true);
        }
    }

    Connections{
        target:firstCalibrationDialog
        onCompleted:{
            mainView.getDynLib().deleteFirstCalibrationDialog();
            if(firstRunCalibration === false){
                workflowManager.setFirstRunCalibrationPreviews(true);
                setFirstRunCalibrationPreviews(true);
            }
        }
    }

//    TourDialog{
    //}

}

