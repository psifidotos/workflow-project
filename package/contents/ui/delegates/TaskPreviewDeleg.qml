// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import ".."
import "../components"
import "../ui"
import "ui-elements"
import "../../code/settings.js" as Settings

import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.qtextracomponents 0.1

Item{
    id: taskDeleg2

    width: mustBeShown === true ? rWidth-2 : 0
    height: mustBeShown === true ? rHeight : 0
    opacity: mustBeShown === true ? 1 : 0

    property bool showOnlyAllActivities:true
    property bool forceState1:false

    property bool mustBeShown: showOnlyAllActivities === true ?
                                   ( onAllActivities &&
                                    onAllDesktops &&
                                    !inDragging ):
                                   (!inDragging)

    property bool showPreviews: ((Settings.global.showWindows === true)&&
                                 (Settings.global.windowPreviews === true)&&
                                 (sessionParameters.effectsSystemEnabled)&&
                                 (mustBeShown === true)&&
                                 (forceState1 === false))

    property bool showPreviewsFound: (showPreviews === true)

    property int rWidth:100
    property int rHeight:100

    property string ccode: code
    property string cActCode: ((activities === undefined) || (activities[0] === undefined) ) ?
                                  sessionParameters.currentActivity : activities[0]
    property int cDesktop:desktop === undefined ? sessionParameters.currentDesktop : desktop

    property bool inDragging: mDragInt.intTaskId === ccode

    property color taskTitleTextDef
    property color taskTitleTextHov
    property color taskTitleTextSel:"#afc6ff"

    property int defWidth:100
    property int defPreviewWidth:100
    property int defHovPreviewWidth:100

    property int iconWidth:80

    property string state1: "nohovered1"
    property string state2: "nohovered2"
    property string stateHov1: "hovered1"
    property string currentNoHovered: showPreviewsFound === true ? state2 : state1

    state: containsMouse ? stateHov1 : currentNoHovered

    property bool containsMouse: ((hoverArea.containsMouse ||
                                   previewMouseArea.containsMouse ||
                                   allTasksBtns.containsMouse) && (!inDragging))

    //This is used from ScrolledTaskPreviewDeleg in order to differentiate
    //its behavior a bit
    property bool overrideUpdatePreview: false;
    property bool overrideDraggingSupport: false;
    property bool overrideInformStateSignal: false;

    /*Aliases*/
    property alias previewRectAlias : previewRect
    property alias imageTask2Alias : imageTask2
    property alias taskTitleRecAlias : taskTitleRec
    property alias taskTitle2Alias : taskTitle2
    property alias allTasksBtnsAlias : allTasksBtns

    //just for smooth animation of showing hovered task rectangle
    property Item taskHoverRect


    //Signals
    signal updatePreviewSignal();
    signal draggingStartedSignal(variant mouse, variant obj);
    signal draggingEndedSignal(variant mouse);
    signal clickedSignal(variant mouse);
    signal informStateSignal(string nextstate);

    onShowPreviewsChanged:{
        updatePreview();
    }

    onWidthChanged: {
        if(state === state2)
            updatePreview();
    }

    onHeightChanged: {
        if(state === state2)
            updatePreview();
    }

    Component.onCompleted: {
        taskDeleg2.updatePreview();
    }

    ListView.onAdd: {
        if (showPreviews === true)
            taskDeleg2.updatePreview();
    }

    ListView.onRemove:{
        previewManager.removeWindowPreview(taskDeleg2.ccode);
    }

    Behavior on height{
        NumberAnimation {
            duration: 2*Settings.global.animationStep;
            easing.type: Easing.InOutQuad;
        }
    }

    Behavior on width{
        NumberAnimation {
            duration: 2*Settings.global.animationStep;
            easing.type: Easing.InOutQuad;
        }
    }

    Behavior on opacity{
        NumberAnimation {
            duration: 2*Settings.global.animationStep;
            easing.type: Easing.InOutQuad;
        }
    }

    DraggingMouseArea{
        id:hoverArea
        anchors.fill: parent
        draggingInterface: mDragInt

        onClickedOverrideSignal:{
            taskDeleg2.onClicked(mouse);
        }

        onDraggingStarted:{
            taskDeleg2.onDraggingStarted(mouse, hoverArea);
        }

        onDraggingEnded: taskDeleg2.draggingEndedSignal(mouse);
    }

    ////////////////////////////Main Elements//////////////////////////////
    ///////////////////////////////////////////////////////////////////////

    QIconItem{
        id:imageTask2
        smooth:true
        icon: Icon
        height:width

        //correcting the animation
        property int toRX:taskDeleg2.rWidth/2
        property int toRY:y
    }

    QIconItem{
        id:imageTask2Ref
        icon: Icon

        width:imageTask2.width
        height:imageTask2.height
        x:imageTask2.x
        y:imageTask2.y+2*imageTask2.height

        transform: Rotation {  axis { x: 1; y: 0; z: 0 } angle: 180 }

        opacity:0.15
        visible: !showPreviewsFound
    }

    Rectangle{
        id:previewRect
        border.width: 1

        property color darkColor:"#05666666"
        property color darkBorder:"#15555555"
        property color lightColor:"#15f4f4f4"
        property color lightBorder:"#85ffffff"

        //should be 0 but I use 1 for the live previews
        property real ratio:1
        property real revRatio: ratio > 0 ? 1/ratio : 0

        //QPixmapItem{
        QIconItem{
            id:previewPix
            smooth:true
            icon: Icon
            enabled: false

            anchors.centerIn: parent

            width:(parent.width) / 2
            height:(parent.height) / 2

            opacity: 0.6
        }

        onWidthChanged: {
            taskDeleg2.updatePreview();
        }
        onHeightChanged: {
            taskDeleg2.updatePreview();
        }
        onXChanged: {
            taskDeleg2.updatePreview();
        }
        onYChanged: {
            taskDeleg2.updatePreview();
        }

        DraggingMouseArea {
            id:previewMouseArea
            anchors.fill: parent
            draggingInterface: mDragInt

            onClickedOverrideSignal: {
                taskDeleg2.onClicked(mouse);
            }

            onDraggingStarted:{
                taskDeleg2.onDraggingStarted(mouse, hoverArea);
            }

            onDraggingEnded: taskDeleg2.draggingEndedSignal(mouse);
        }
    }

    onXChanged: {
        taskDeleg2.updatePreview();
    }

    ////Preview State///////////

    Rectangle{
        id: taskTitleRec

        height:taskTitle2.height
        color:"#00e2e2e2"

        Text{
            id:taskTitle2
            anchors.horizontalCenter: parent.horizontalCenter

            text:name === undefined ? "" : name
            font.family: theme.defaultFont.family
            font.bold: true

            elide:Text.ElideRight
            width:parent.width
        }
    }

    TaskPreviewButtons{
        id:allTasksBtns

        property real offsety:0
        property real offsetx:0

        z:5
        state: (taskDeleg2.containsMouse) ? "show" : "hide"

        onStateChanged:{
            if (allTasksBtns.state === "show"){
                //This is a way to change position to allTasksBtns
                //according to window previews size
                taskDeleg2.computeButtonsPosition();
            }
        }

        onInformStateClicked: {
            if(!overrideInformStateSignal)
                taskManager.setTaskState(taskDeleg2.ccode, windowState);
            else
                informStateSignal(windowState);
        }
    }

    /////////////////////////////////////////The various states for appearance///////////////////////////////////////
    states: [
        State {
            name: "nohovered1"
            PropertyChanges{
                target:previewRect
                //   visible:false
                opacity:0
                width:5
                height:5
            }
            PropertyChanges{
                target:imageTask2
                width: 1.4*taskDeleg2.defWidth
                x:taskDeleg2.width/2 - width/2
            }
            PropertyChanges{
                target:taskDeleg2
                y:-0.2*imageTask2.height
            }
            PropertyChanges{
                target:taskTitleRec
                y: 1.03*(imageTask2.y+imageTask2.height)
                opacity: 0.35
                width:taskDeleg2.width
            }
            PropertyChanges{
                target:taskTitle2
                color:taskDeleg2.taskTitleTextDef
                font.pixelSize: Math.max((0.17+0.01)*taskDeleg2.rHeight,14)
            }
            PropertyChanges{
                target:allTasksBtns
                x:imageTask2.x+0.9*imageTask2.width
                y:imageTask2.y-0.6*buttonsSize
                buttonsSize:0.8*taskDeleg2.defWidth
            }
        },
        State {
            name: "nohovered2"

            PropertyChanges{
                target:previewRect
                //  visible:true
                opacity:1
                width:previewRect.ratio>=1 ? taskDeleg2.defPreviewWidth : previewRect.ratio*taskDeleg2.defPreviewWidth
                height:previewRect.ratio<1 ? taskDeleg2.defPreviewWidth : previewRect.revRatio*taskDeleg2.defPreviewWidth
                //     y:-2.3*taskDeleg2.defWidth / 2
                y:(taskDeleg2.defPreviewWidth - height)
                x:(taskDeleg2.width - taskDeleg2.defPreviewWidth)/2
                color: previewRect.darkColor
                border.color: previewRect.darkBorder
            }
            PropertyChanges{
                target:imageTask2
                width: 1.4*taskTitleRec.height
                x:0
                y:0.8*taskTitleRec.y
                opacity:0.8
            }

            PropertyChanges{
                target:taskDeleg2
                y:-0.6*taskDeleg2.defPreviewWidth
            }
            PropertyChanges{
                target:taskTitleRec
                y: 1.03*(taskDeleg2.defPreviewWidth)
                opacity:0.35
                width:taskDeleg2.width
            }
            PropertyChanges{
                target:taskTitle2
                color:taskDeleg2.taskTitleTextDef
                font.pixelSize: Math.max((0.17+0.01)*taskDeleg2.rHeight,14)
            }
            PropertyChanges{
                target:allTasksBtns
                x:previewRect.x + previewRect.width - (offsetx*previewRect.width)
                y:previewRect.y - 0.5*buttonsSize + (offsety*previewRect.height)
                buttonsSize:0.8*taskDeleg2.defWidth
            }
        },
        State {
            name: "hovered1"
            PropertyChanges {
                target: taskDeleg2
                y:showPreviewsFound===false ? -0.4*imageTask2.height : -0.6*taskDeleg2.defPreviewWidth

                height:showPreviewsFound===false ?taskDeleg2.rHeight+0.4*imageTask2.height:
                                                   taskDeleg2.rHeight+0.6*taskDeleg2.defPreviewWidth

            }

            PropertyChanges{
                target:taskTitleRec
                y:showPreviewsFound===false ? 1.03*(imageTask2.y+imageTask2.height) : 1.03*(imageTask2.y+imageTask2.height)

                width:taskDeleg2.width
                opacity:1
            }
            PropertyChanges{
                target:taskTitle2
                color:taskDeleg2.taskTitleTextHov
                font.pixelSize: Math.max((0.17+0.01)*taskDeleg2.rHeight,14)
            }
            PropertyChanges{
                target:imageTask2
                width: showPreviewsFound===false ? 2.1 * taskDeleg2.defWidth : 1.4*taskTitleRec.height
                opacity: 1
                x: showPreviewsFound===false ? taskDeleg2.width/2 - width/2 : 0
                y: showPreviewsFound===false ? 0 : (taskDeleg2.defPreviewWidth)-height
            }
            PropertyChanges{
                target:previewRect
                //  visible:showPreviewsFound===false ? false:true
                opacity:showPreviewsFound===false ? 0:1
                width:previewRect.ratio>=1 ? taskDeleg2.defHovPreviewWidth : previewRect.ratio*taskDeleg2.defHovPreviewWidth
                height:previewRect.ratio<1 ? taskDeleg2.defHovPreviewWidth : previewRect.revRatio*taskDeleg2.defHovPreviewWidth
                y: showPreviewsFound===false ? 0 : (0.5*taskDeleg2.defHovPreviewWidth - height)
                x: showPreviewsFound===false ? 0 : (taskDeleg2.width - taskDeleg2.defHovPreviewWidth)/2
                color: previewRect.darkColor
                border.color: previewRect.darkBorder
            }
            PropertyChanges{
                target:allTasksBtns
                x:showPreviewsFound===false ? imageTask2.x+0.9*imageTask2.width : previewRect.x + previewRect.width - (offsetx*previewRect.width)
                y:showPreviewsFound===false ? imageTask2.y-0.6*buttonsSize : previewRect.y - 0.5*buttonsSize + (offsety*previewRect.height)
                buttonsSize:0.8*taskDeleg2.defWidth
            }
        }

    ]

    transitions: [

        Transition {
            from:taskDeleg2.state1; to:taskDeleg2.stateHov1
            reversible: false
            TaskPreviewDelegAnimations{
            }
        },
        Transition {
            from:taskDeleg2.state2; to:taskDeleg2.stateHov1
            reversible: false

            TaskPreviewDelegAnimations{
            }
        },
        Transition {
            from:taskDeleg2.stateHov1; to:taskDeleg2.state1
            reversible: false
            TaskPreviewDelegAnimations{
            }
        },
        Transition {
            from:taskDeleg2.stateHov1; to:taskDeleg2.state2
            reversible: false

            TaskPreviewDelegAnimations{
            }
        },
        Transition {
            from:taskDeleg2.state1; to:taskDeleg2.state2
            reversible: false

            TaskPreviewDelegAnimations{
            }
        },
        Transition {
            from:taskDeleg2.state2; to:taskDeleg2.state1
            reversible: false

            TaskPreviewDelegAnimations{
            }
        }
    ]

    function onClicked(mouse) {
        taskManager.activateTask(taskDeleg2.ccode);
    }

    ////////////////////// Dragging support///////////////////////////////////

    function onDraggingStarted(mouse, obj) {
        draggingStartedSignal(mouse,obj);
        if(!overrideDraggingSupport){
            var nCor = obj.mapToItem(mainView,mouse.x,mouse.y);

            var coord1 = imageTask2.mapToItem(mainView,imageTask2.x, imageTask2.y);

            mDragInt.enableDragging(nCor,
                                    imageTask2.icon,
                                    taskDeleg2.ccode,
                                    taskDeleg2.cActCode,
                                    taskDeleg2.cDesktop,
                                    coord1,
                                    true);
        }
    }

    ////////////////////////// Functions that provide important functionality/////////////////

    function updatePreview(){
        updatePreviewSignal();
        if(!overrideUpdatePreview){

            if(taskDeleg2.showPreviews)  {
                var x1 = 0;
                var y1 = 0;
                var obj = previewRect.mapToItem(mainView,x1,y1);

                previewManager.setWindowPreview(taskDeleg2.ccode,
                                                obj.x+Settings.global.windowPreviewsOffsetX,
                                                obj.y+Settings.global.windowPreviewsOffsetY,
                                                previewRect.width-(2*previewRect.border.width),
                                                previewRect.height-(2*previewRect.border.width));
            }
            else
                previewManager.removeWindowPreview(taskDeleg2.ccode);
        }
    }


    function computeButtonsPosition(){
        if (showPreviewsFound ===  true){
            var ratioWin = previewManager.getWindowRatio(taskDeleg2.ccode);

            if (ratioWin<1){
                var offY = (1 - ratioWin)/2

                allTasksBtns.offsety = offY;
                allTasksBtns.offsetx = 0;
            }
            else if(ratioWin>1){
                var offX = (1-(1/ratioWin))/2;

                allTasksBtns.offsety = 0;
                allTasksBtns.offsetx = offX;
            }
            else{
                allTasksBtns.offsety = 0;
                allTasksBtns.offsetx = 0;
            }

        }
    }

    function getIcon(){
        return imageTask2;
    }
}

