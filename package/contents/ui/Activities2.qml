// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import org.kde.workflow.components 0.1 as WorkFlowComponents
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.plasma.extras 0.1 as PlasmaExtras
import org.kde.qtextracomponents 0.1

import "delegates"
import "delegates/ui-elements"
import "helptour"
import "connections"
import "components"
import "interfaces"
import "ui"

import "DynamicAnimations.js" as DynamAnim

import "../code/settings.js" as Settings

Rectangle {
    id:mainView
    objectName: "instMainView"
    focus:true

    property int minimumWidth: plasmoidWrapper.isInPanel? 400 : 500
    property int minimumHeight: plasmoidWrapper.isInPanel? 300 : 350
    //  property int maximumWidth: plasmoidWrapper.isInPanel? minimumWidth : 0
    //   property int maximumHeight: plasmoidWrapper.isInPanel? minimumHeight : 0
    property int preferredWidth: 500
    property int preferredHeight: 350

    property Component compactRepresentationEmpty: undefined
    property Component compactRepresentationPanel: Component{ CompactRepresentation{} }

    property Component compactRepresentation: (plasmoidWrapper.isInPanel && (!Settings.global.disableCompactRepresentation)) ?
                                                  compactRepresentationPanel :
                                                  compactRepresentationEmpty

    //property Component compactRepresentation:  compactRepresentationEmpty


    Settings {
        id: settings
        setAsGlobal: true
    }

    //   color:"#000000ff"
    color:  Settings.global.disableBackground ? "#00dcdcdc": "#dcdcdc"

    clip:true
    anchors.fill: parent

    property int scaleMeter: zoomSlider.value

    property real zoomingHeightFactor: ((zoomSlider.value-zoomSlider.minimumValue)/(zoomSlider.maximumValue-zoomSlider.minimumValue))*0.6

    property int workareaWidth: 70+(2.8*mainView.scaleMeter) + (mainView.scaleMeter-5)/3;
    property int workareaHeight:(3.6 - zoomingHeightFactor)*scaleMeter
    property int workareaY:2*scaleMeter

    //Applications properties/////
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

    WorkFlowComponents.PlasmoidWrapper {
        id: plasmoidWrapper

        onIsInPanelChanged:{
            if (!isInPanel && mainLoader.status == Loader.Null)
                mainLoader.source = "views/View1.qml";
        }
    }

    WorkFlowComponents.TaskManager {
        id: taskManager
    }

    WorkFlowComponents.PreviewsManager {
        id: previewManager
    }

    QMLPluginsConnections{}

    Loader{
        id:mainLoader
        anchors.fill:parent
    }

    ZoomSliderItem{
        id:zoomSlider
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        z:10

        onValueChanged: Settings.global.scale = value;

        Component.onCompleted: value = Settings.global.scale;
    }

    FilterWindows{
        id:filterWindows
        width:Math.max(0.3*parent.width,250)
    }

    DraggingInterfaceTasks{
        id:mDragInt
    }

    DraggingInterfaceActivities{
        id:draggingActivities
    }

    KeyNavigation{
        id:keyNavigation
    }

    Keys.forwardTo: [keyNavigation]

    MouseEventListener {
        id:zoomAreaListener
        anchors.fill:parent
        z:keyNavigation.ctrlActive ? 40 : -1
        //enabled: keyNavigation.ctrlActive
        visible: keyNavigation.ctrlActive

        onWheelMoved:{
            if(wheel.delta < 0)
                zoomSlider.value=zoomSlider.value-2;
            else
                zoomSlider.value=zoomSlider.value+2;
        }
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
        //plasmoid.aspectRatioMode = "ConstrainedSquare"

        plasmoid.addEventListener("ConfigChanged", Settings.global.configChanged);
        plasmoid.popupEvent.connect(popupEventSlot);

        plasmoid.passivePopup = !Settings.global.hideOnClick;
        mainView.forceActiveFocus();

        taskManager.initSignals();
    }

    function popupEventSlot(show){
        if(show){
            if((mainLoader.status == Loader.Null)&&(!Settings.global.triggerKWinScript))
                mainLoader.source = "views/View1.qml";

            mainView.forceActiveFocus();
        }
        else
            plasmoidWrapper.popupEventSlot(show);
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


    UIConnections{
        id:uiConnect
    }
    // CalibrationDialogTmpl{}
    //      TourDialog{
    //  }

}

