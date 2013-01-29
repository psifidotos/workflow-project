// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import org.kde.workflow.components 0.1 as WorkFlowComponents
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.qtextracomponents 0.1

import "delegates"
import "delegates/ui-elements"
import "instances"
import "helptour"
import "connections"

//import "ui"

import "DynamicAnimations.js" as DynamAnim

import "../code/settings.js" as Settings

Rectangle {
    id:mainView
    objectName: "instMainView"

    property int minimumWidth: 100
    property int minimumHeight: 100
    property int maximumWidth
    property int maximumHeight
    property int preferredWidth: 500
    property int preferredHeight: 350

    property Component compactRepresentationEmpty: undefined
    property Component compactRepresentationPanel: Component{ CompactRepresentation{} }

    property Component compactRepresentation: plasmoidWrapper.isInPanel ?
                                                  compactRepresentationPanel :
                                                  compactRepresentationEmpty

    Settings {
        id: settings
        setAsGlobal: true
    }

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


    property variant defaultFont: theme.defaultFont

    property color defaultFontColor:theme.textColor
    property real defaultFontSize:theme.defaultFont.pointSize
    //property real defaultFontRelativeness: 0

    property real defFontRelStep: Settings.global.fontRelevance/20
    property real fixedFontSize: defaultFontSize + Settings.global.fontRelevance

    property bool disablePreviewsWasForcedInDesktopDialog:false //as a reference to DesktopDialog because it is dynamic from now one

    //these signals remove the warnings when running the plasmoid
    signal minimumWidthChanged;
    signal minimumHeightChanged;
    signal maximumWidthChanged;
    signal maximumHeightChanged;
    signal preferredWidthChanged;
    signal preferredHeightChanged;


    WorkFlowComponents.SessionParameters {
        id: sessionParameters
        objectName:"sessionParameters"
    }

    WorkFlowComponents.WorkflowManager {
        id: workflowManager
    }

    WorkFlowComponents.TaskManager {
        id: taskManager
    }

    WorkFlowComponents.PreviewsManager {
        id: previewManager
    }

    WorkFlowComponents.EnvironmentManager {
        id: environmentManager
    }

    WorkFlowComponents.PlasmoidWrapper {
        id: plasmoidWrapper
    }

    QMLPluginsConnections{}


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
            animationsStep: Settings.global.animationStep
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

            onValueChanged: Settings.global.scale = value;

            Component.onCompleted: value = Settings.global.scale;
        }
    }

    DraggingInterfaceTasks{
        id:mDragInt
    }

    DraggingInterfaceActivities{
        id:draggingActivities
    }


    Connections{
        target:Settings.global
        onHideOnClickChanged: plasmoid.passivePopup = !Settings.global.hideOnClick;
    }

    Component.onCompleted:{
        DynamAnim.createComponents();

        if(Settings.global.firstRunLiveTour === false)
            getDynLib().showFirstHelpTourDialog();

        var toolTipData = new Object;
        toolTipData["image"] = "preferences-activities"; // same as in .desktop file
        toolTipData["mainText"] = i18n("WorkFlow Plasmoid"); // same as in .desktop file
        toolTipData["subText"] = i18n("Activities, Workareas, Windows organize your \n full workflow through the KDE technologies");
        plasmoid.popupIconToolTip = toolTipData;

        plasmoid.popupIcon = QIcon("preferences-activities");
        plasmoid.aspectRatioMode = IgnoreAspectRatio;

        plasmoid.addEventListener("ConfigChanged", Settings.global.configChanged);

        plasmoid.passivePopup = !Settings.global.hideOnClick;
    }

    function getDynLib(){
        return DynamAnim;
    }


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
            interval:200+Settings.global.animationStep
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
            mainView.disablePreviewsWasForcedInDesktopDialog = desktopDialog.disablePreviewsWasForced;
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
            if(Settings.global.firstRunLiveTour === false)
                Settings.global.firstRunLiveTour = true;
        }
    }

    Connections{
        target:firstCalibrationDialog
        onCompleted:{
            mainView.getDynLib().deleteFirstCalibrationDialog();
            if(Settings.global.firstRunCalibrationPreviews === false){
                Settings.global.firstRunCalibrationPreviews = true;
            }
        }
    }

    //DesktopDialogTmpl{}
    //    TourDialog{
    //}

}

