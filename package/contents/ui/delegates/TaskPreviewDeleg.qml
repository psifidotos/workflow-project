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

    // This delegate is used in two situations,
    //
    // 1.onAllActivities where the ListView contains all the tasks
    //  so the delegate must be shown for only the allActivities tasks,
    //
    // 2.for tasks in spesific desktop and activity

    property bool showOnlyAllActivities:true

    property variant dTypes:["allActivitiesTasks",
        "DesktopDialog"]

    property string dialogType

    //   property string dialogActivity: ""
    //   property int dialogDesktop: -1

    property bool forceState1:false
    property bool forcedState1InDialog:false

    property bool inShownArea:true

    property bool mustBeShown: showOnlyAllActivities === true ?
                                   ( onAllActivities &&
                                    onAllDesktops &&
                                    !isPressed ):
                                   (!isPressed)

    property bool showPreviews: ((Settings.global.showWindows === true)&&
                                 (Settings.global.windowPreviews === true)&&
                                 (sessionParameters.effectsSystemEnabled)&&
                                 (mustBeShown === true)&&
                                 (forceState1 === false))

    //     property bool showPreviewsFound: ((showPreviews === true) &&
    //                                       (previewRect.ratio > 0))

    property bool showPreviewsFound: (showPreviews === true)

    //  property bool containsMouse:

    property int rWidth:100
    property int rHeight:100

    width: mustBeShown === true ? rWidth-2 : 0
    height: mustBeShown === true ? rHeight : 0

    opacity: mustBeShown === true ? 1 : 0

    property string ccode: code
    property string cActCode: ((activities === undefined) || (activities[0] === undefined) ) ?
                                  sessionParameters.currentActivity : activities[0]
    property int cDesktop:desktop === undefined ? sessionParameters.currentDesktop : desktop

    property bool isPressed: hoverArea.isPressed || previewMouseArea.isPressed


    property color taskTitleTextDef
    property color taskTitleTextHov
    property color taskTitleTextSel:"#afc6ff"

    property int defWidth:100
    property int defPreviewWidth:100
    property int defHovPreviewWidth:100

    property int iconWidth:80

    property variant scrollingView
    property variant centralListView
    property variant oldParent

    property string state1: showOnlyAllActivities === true ? "nohovered1" : "listnohovered1"
    property string state2: showOnlyAllActivities === true ? "nohovered2" : "listnohovered2"
    property string stateHov1: showOnlyAllActivities === true ? "hovered1" : "listhovered1"
    property string currentNoHovered: showPreviewsFound === true ? state2 : state1

    state: containsMouse ? stateHov1 : currentNoHovered

    property bool containsMouse: ((hoverArea.containsMouse ||
                                   previewMouseArea.containsMouse ||
                                   allTasksBtns.containsMouse) && (!isPressed))

    /*Aliases*/
    property alias previewRect : previewRect
    property alias taskTitleRec : taskTitleRec
    property alias taskTitle2 : taskTitle2
    property alias taskHoverRect : taskHoverRect
    property alias allTasksBtns : allTasksBtns


    onShowPreviewsChanged:{
        updatePreview();
    }


    onInShownAreaChanged:{
        if(state == state2)
            updatePreview();
    }

    onWidthChanged: {
        if(state === state2)
            updatePreview();
    }

    onHeightChanged: {
        if(state === state2)
            updatePreview();


        if((centralListView !== undefined)&&
                (taskDeleg2.mustBeShown)){
            centralListView.delegHeight = height;
        }
    }

    //This is scrolling support in the dialogs
    Connections{
        target:scrollingView
        onContentYChanged:{
            countInScrollingArea();

            updatePreview();
        }


        onXChanged:{
            if(state === state2)
                updatePreview();
        }
        onYChanged:{
            if(state === state2)
                updatePreview();
        }
        onWidthChanged:{
            if(state === state2)
                updatePreview();
        }
        onHeightChanged:{
            if(state === state2)
                updatePreview();
        }

    }

    Connections{
        target:centralListView

        onOnlyState1Changed:{
            taskDeleg2.forceState1 = centralListView.onlyState1;
        }
    }


    Component.onCompleted: {
        taskDeleg2.forceState1 = centralListView.onlyState1;

        taskDeleg2.updatePreview();
    }


    ListView.onAdd: {
        if (showPreviews === true)
            taskDeleg2.updatePreview();
    }

    GridView.onAdd: {
        if (showPreviews === true)
            taskDeleg2.updatePreview();

    }


    ListView.onRemove:{
        previewManager.removeWindowPreview(taskDeleg2.ccode);
    }


    GridView.onRemove:{
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

        onClicked: {
            taskDeleg2.onClicked(mouse);
        }

        onDraggingStarted:{
            taskDeleg2.onDraggingStarted(mouse, hoverArea);
        }

        onDraggingMovement:{
            taskDeleg2.onDraggingMovement(mouse, hoverArea);
        }

        onDraggingEnded:{
            taskDeleg2.onDraggingEnded(mouse);
        }
    }

    ////////////////////////////Main Elements//////////////////////////////
    ///////////////////////////////////////////////////////////////////////


    Rectangle{
        id:taskHoverRect
        width:parent.width-2*border.width
        height:parent.height
        radius:5
        color:"#30ffffff"
        border.width: 1
        border.color: "#aaffffff"
    }


    QIconItem{
        id:imageTask2

        smooth:true
        icon: Icon

        height:width

        //correcting the animation
        property int toRX:taskDeleg2.rWidth/2
        property int toRY:y

        //  width:taskDeleg2.defWidth

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
        //color:"#05666666"
        border.width: 1
        //border.color: "#15555555"

        property color darkColor:"#05666666"
        property color darkBorder:"#15555555"
        property color lightColor:"#15f4f4f4"
        property color lightBorder:"#85ffffff"

        // anchors.horizontalCenter: parent.horizontalCenter

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

            //opacity:parent.opacity === 0 ? 0:0.6
            //      opacity:parent.opacity === 0 ? 0.6:0.6
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

            onClicked: {
                taskDeleg2.onClicked(mouse);
            }

            onDraggingStarted:{
                taskDeleg2.onDraggingStarted(mouse, hoverArea);
            }

            onDraggingMovement:{
                taskDeleg2.onDraggingMovement(mouse, hoverArea);
            }

            onDraggingEnded:{
                taskDeleg2.onDraggingEnded(mouse);
            }
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
            font.family: mainView.defaultFont.family
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

        state: (taskDeleg2.containsMouse && (dialogType !== dTypes[2])) ? "show" : "hide"

        onStateChanged:{
            if (allTasksBtns.state === "show"){
                //This is a way to change position to allTasksBtns
                //according to window previews size
                taskDeleg2.computeButtonsPosition();
            }
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
                opacity: 0.3
                width:taskDeleg2.width
            }
            PropertyChanges{
                target:taskTitle2
                color:taskDeleg2.taskTitleTextDef
                font.pixelSize: Math.max((0.17+mainView.defFontRelStep)*taskDeleg2.rHeight,14)
            }

            PropertyChanges{
                target:taskHoverRect
                opacity:0
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
                opacity:0.3
                width:taskDeleg2.width
            }
            PropertyChanges{
                target:taskTitle2
                color:taskDeleg2.taskTitleTextDef
                font.pixelSize: Math.max((0.17+mainView.defFontRelStep)*taskDeleg2.rHeight,14)
            }
            PropertyChanges{
                target:taskHoverRect
                opacity:0
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
                font.pixelSize: Math.max((0.17+mainView.defFontRelStep)*taskDeleg2.rHeight,14)
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
                target:taskHoverRect
                opacity:0
            }
            PropertyChanges{
                target:allTasksBtns
                x:showPreviewsFound===false ? imageTask2.x+0.9*imageTask2.width : previewRect.x + previewRect.width - (offsetx*previewRect.width)
                y:showPreviewsFound===false ? imageTask2.y-0.6*buttonsSize : previewRect.y - 0.5*buttonsSize + (offsety*previewRect.height)
                buttonsSize:0.8*taskDeleg2.defWidth
            }
        },///STATES FOR LISTS//////////////////////////////////////
        State {
            name: "listnohovered1"
            PropertyChanges{
                target:previewRect
                opacity:0
                width:5
                height:5
                x:taskDeleg2.width/2
                y:taskDeleg2.height/2
            }
            PropertyChanges{
                target:imageTask2
                width: taskDeleg2.defWidth
                x:10
                y:(taskDeleg2.height - height) / 2
                opacity:1
            }
            PropertyChanges{
                target:taskTitleRec
                y: (((taskDeleg2.height - imageTask2.height) / 2)+imageTask2.height-height)
                x: (imageTask2.x+imageTask2.width)
                width: taskDeleg2.width - imageTask2.width - 10
                opacity:taskDeleg2.isSelected === false ? 0.7 : 1
            }
            PropertyChanges{
                target:taskTitle2
                color:taskDeleg2.taskTitleTextDef
                font.pixelSize: Math.max((0.28+mainView.defFontRelStep)*taskDeleg2.height,15)
            }
            PropertyChanges{
                target:taskHoverRect
                opacity:0.001
            }
            PropertyChanges{
                target:allTasksBtns
                x:taskHoverRect.width - width-5
                y:0
                buttonsSize:0.5*taskDeleg2.height
            }
        },
        State {
            name: "listnohovered2"
            PropertyChanges{
                target:previewRect

                opacity:0.6

                width:taskDeleg2.defPreviewWidth
                height:taskDeleg2.defPreviewWidth

                // y:(taskDeleg2.defPreviewWidth - height)
                y:0
                x:(taskDeleg2.width - taskDeleg2.defPreviewWidth)/2

                // color: previewRect.lightColor
                // border.color: previewRect.lightBorder
                color:"#00000000"
                border.color:"#00000000"

            }
            PropertyChanges{
                target:imageTask2
                width: 1.4*taskTitleRec.height
                x:0
                //     y: previewRect.y+previewRect.height-height
                y:taskTitleRec.y-height
                opacity:1
            }
            PropertyChanges{
                target:taskTitleRec
                y: previewRect.y+previewRect.height
                opacity:0.7
                width:taskDeleg2.width
            }
            PropertyChanges{
                target:taskTitle2
                color:taskDeleg2.taskTitleTextDef
                font.pixelSize: Math.max((0.09+mainView.defFontRelStep)*taskDeleg2.height,15)
            }
            PropertyChanges{
                target:taskHoverRect
                opacity:0
            }
            PropertyChanges{
                target:allTasksBtns
                x:previewRect.x + previewRect.width - (offsetx*previewRect.width)
                y:previewRect.y - 0.5*buttonsSize + (offsety*previewRect.height)
                buttonsSize:0.2*taskDeleg2.defPreviewWidth
            }

        },
        State {
            name: "listhovered1"
            PropertyChanges{
                target:previewRect

                width:showPreviewsFound===false ? 5 : taskDeleg2.defHovPreviewWidth
                height:showPreviewsFound===false ? 5 : taskDeleg2.defHovPreviewWidth

                y:showPreviewsFound===false ? height/2:(taskDeleg2.height-height)/2
                x:showPreviewsFound===false ? width/2:(taskDeleg2.width-width)/2

                color: showPreviewsFound===false ? lightColor : "#00000000"
                border.color: showPreviewsFound===false ? lightBorder : "#00000000"

                opacity:showPreviewsFound===false ? 0 : 0.6
            }
            PropertyChanges{
                target:imageTask2
                width: showPreviewsFound===false ? 1.4*taskDeleg2.defWidth : 1.4*taskTitleRec.height
                x:showPreviewsFound===false ? 10 : 0
                y:showPreviewsFound===false ? (taskDeleg2.height - height) / 2 : taskTitleRec.y-height
                opacity: 1
            }

            PropertyChanges{
                target:taskTitleRec
                y: showPreviewsFound===false ? (((taskDeleg2.height - imageTask2.height) / 2)+imageTask2.height-height)
                                             : previewRect.y+previewRect.height
                x: showPreviewsFound===false ? (imageTask2.x+imageTask2.width) : 0
                width: showPreviewsFound===false ? taskDeleg2.width - imageTask2.width - 10 : taskDeleg2.width
                opacity: showPreviewsFound===false ? 1 : 1
            }
            PropertyChanges{
                target:taskTitle2
                color:taskDeleg2.taskTitleTextHov
                font.pixelSize: Math.max(showPreviewsFound===false ? (0.28+mainView.defFontRelStep)*taskDeleg2.height : (0.09+mainView.defFontRelStep)*taskDeleg2.height,15)
            }
            PropertyChanges{
                target:taskHoverRect
                opacity:showPreviewsFound===false ? 1 : 0.001
            }
            PropertyChanges{
                target:allTasksBtns
                x:showPreviewsFound===false ? taskHoverRect.width - width-5 : previewRect.x + previewRect.width - (offsetx*previewRect.width)

                buttonsSize: showPreviewsFound===false ? 0.5*taskDeleg2.height:0.2*taskDeleg2.defHovPreviewWidth
                y:showPreviewsFound===false ? 0 : previewRect.y -buttonsSize + previewRect.height/2
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

        if(dialogType === dTypes[1])
            desktopDialog.clickedCancel();
    }

    ////////////////////// Dragging support///////////////////////////////////

    function onDraggingStarted(mouse, obj) {
        taskDeleg2.isPressed = true;

        if (taskDeleg2.showOnlyAllActivities === false){
            var nC = taskDeleg2.mapToItem(mainView,0,0);

            taskDeleg2.parent=mainView;
            taskDeleg2.x = nC.x;
            taskDeleg2.y = nC.y;
        }

        var nCor = obj.mapToItem(mainView,mouse.x,mouse.y);

        var coord1 = imageTask2.mapToItem(mainView,imageTask2.x, imageTask2.y);

        mDragInt.enableDragging(nCor,
                                imageTask2.icon,
                                taskDeleg2.ccode,
                                taskDeleg2.cActCode,
                                taskDeleg2.cDesktop,
                                coord1,
                                true);

        if (dialogType === dTypes[1]){
            desktopView.forceState1();
            taskDeleg2.forcedState1InDialog = true;
            desktopDialog.closeD();
        }
    }

    function onDraggingMovement(mouse,obj) {
        if (taskDeleg2.isPressed === true){
            var nCor = obj.mapToItem(mainView,mouse.x,mouse.y);
            mDragInt.onPstChanged(nCor);
        }
    }

    function onDraggingEnded(mouse) {
        if (taskDeleg2.isPressed === true){
            mDragInt.onMReleased(mouse);

            if (dialogType === dTypes[1]){
                desktopDialog.emptyDialog();
                if (taskDeleg2.forcedState1InDialog === true){
                    desktopView.unForceState1();
                    taskDeleg2.forcedState1InDialog=false;
                }
                desktopDialog.completed();
            }
        }

        taskDeleg2.isPressed = false;
    }



    ////////////////////////// Functions that provide important functionality/////////////////

    function updatePreview(){
        countInScrollingArea();

        if((taskDeleg2.showPreviews === true)&&
                (taskDeleg2.inShownArea === true))  {
            var x1 = 0;
            var y1 = 0;
            var obj = previewRect.mapToItem(mainView,x1,y1);

            previewManager.setWindowPreview(taskDeleg2.ccode,
                                            obj.x+Settings.global.windowPreviewsOffsetX,
                                            obj.y+Settings.global.windowPreviewsOffsetY,
                                            previewRect.width-(2*previewRect.border.width),
                                            previewRect.height-(2*previewRect.border.width));
        }

        if((taskDeleg2.inShownArea === false)||
                (taskDeleg2.showPreviews===false)){
            previewManager.removeWindowPreview(taskDeleg2.ccode);
        }
    }


    function countInScrollingArea(){

        if((taskDeleg2.showPreviews === true)&&
                (previewRect.width===taskDeleg2.defPreviewWidth)&&
                (dialogType === dTypes[1])){

            var previewRelX = previewRect.mapToItem(centralListView,0,0).x;
            var previewRelY = previewRect.mapToItem(centralListView,0,0).y;

            var fixY = previewRelY - scrollingView.contentY;

            if ((fixY>=0) &&
                    ((fixY+previewRect.height) <= scrollingView.height))
                taskDeleg2.inShownArea = true;
            else
                taskDeleg2.inShownArea = false;
        }
        else
            taskDeleg2.inShownArea = true;

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

