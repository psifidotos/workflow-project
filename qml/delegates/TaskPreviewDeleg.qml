// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import ".."
import "ui-elements"
import "../ui"

import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.qtextracomponents 0.1

//Component{

Item{
    id: taskDeleg2

    //This delegate is used in two situations, 1.onAllActivities where the
    //ListView contains all the tasks so the delegate must be shown for only
    //the allActivities tasks,
    //2.for tasks in spesific desktop and activity
    property bool showAllActivities:true

    property bool forceState1:false
    property bool forcedState1InDialog:false

    property bool inShownArea:true

    property bool mustBeShown: showAllActivities === true ?
                                   ( (onAllActivities === true )&&(isPressed === false) ):
                                   (code !== 'DontShow')&&(isPressed === false)

    property bool showPreviews: ((mainView.enablePreviews === true)&&
                                 (mustBeShown === true)&&
                                 (forceState1 === false))


    //     property bool showPreviewsFound: ((showPreviews === true) &&
    //                                       (previewRect.ratio > 0))

    property bool showPreviewsFound: (showPreviews === true)

    property int rWidth:100
    property int rHeight:100

    width: mustBeShown === true ? rWidth-2 : 0
    height: mustBeShown === true ? rHeight : 0

    opacity: mustBeShown === true ? 1 : 0

    property string ccode: code
    property string cActCode: activities === undefined ? mainView.currentActivity : activities
    property int cDesktop:desktop === undefined ? mainView.currentDesktop : desktop
    property bool isPressed:false

    property string currentNoHovered: showPreviewsFound === true ? state2 : state1

    property color taskTitleTextDef
    property color taskTitleTextHov

    property int defWidth:100
    property int defPreviewWidth:100
    property int defHovPreviewWidth:100

    property int iconWidth:80


    property string state1: showAllActivities === true ? "nohovered1" : "listnohovered1"
    property string state2: showAllActivities === true ? "nohovered2" : "listnohovered2"
    property string stateHov1: showAllActivities === true ? "hovered1" : "listhovered1"

    property variant scrollingView
    property variant centralListView

    property variant oldParent

    state: state1

    onShowPreviewsChanged:{

        if (showPreviews === true){
            taskDeleg2.state = taskDeleg2.state2;
            //          taskDeleg2.updatePreview();
        }
        else{
            taskDeleg2.state = taskDeleg2.state1;
            //            taskManager.removeWindowPreview(taskDeleg2.ccode);
        }
        taskDeleg2.updatePreview();
    }


    onInShownAreaChanged:{

        taskDeleg2.updatePreview();

    }

    /*

    onShowPreviewsFoundChanged:{
        if (showPreviewsFound === true){
            taskDeleg2.state = taskDeleg2.state2;
            taskDeleg2.updatePreview();
        }
        else{
            taskDeleg2.state = taskDeleg2.state1;
            taskManager.removeWindowPreview(taskDeleg2.ccode);
        }
    }*/

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
            var previewRelX = previewRect.mapToItem(centralListView,0,0).x;
            var previewRelY = previewRect.mapToItem(centralListView,0,0).y;

            var fixY = previewRelY - scrollingView.contentY;

            if ((fixY>=0) &&
                    ((fixY+previewRect.height) <= scrollingView.height))
                taskDeleg2.inShownArea = true;
            else
                taskDeleg2.inShownArea = false;

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


    /*ListView.onAdd: {
        taskDeleg2.forceState1 = centralListView.onlyState1;
        if (showPreviews === true)
            taskDeleg2.updatePreview();
    }*/


    ListView.onRemove:{
        taskManager.removeWindowPreview(taskDeleg2.ccode);
    }


    GridView.onRemove:{
        taskManager.removeWindowPreview(taskDeleg2.ccode);
    }




    Behavior on height{
        NumberAnimation {
            duration: 2*mainView.animationsStep;
            easing.type: Easing.InOutQuad;
        }
    }

    Behavior on width{
        NumberAnimation {
            duration: 2*mainView.animationsStep;
            easing.type: Easing.InOutQuad;
        }
    }

    Behavior on opacity{
        NumberAnimation {
            duration: 2*mainView.animationsStep;
            easing.type: Easing.InOutQuad;
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

        MouseArea {
            id:hoverRectMouseArea
            anchors.fill: parent
            hoverEnabled: true

            onEntered: {
                taskDeleg2.onEntered();
            }

            onExited: {
                taskDeleg2.onExited();
            }

            onClicked: {
                taskDeleg2.onClicked(mouse);
            }

            onPressAndHold:{
                taskDeleg2.onPressAndHold(mouse, hoverRectMouseArea);
            }

            onPositionChanged: {
                taskDeleg2.onPositionChanged(mouse, hoverRectMouseArea);
            }

            onReleased:{
                taskDeleg2.onReleased(mouse);
            }
        }
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

        MouseArea {
            id:imageMouseArea2
            anchors.fill: parent
            hoverEnabled: true

            onEntered: {
                taskDeleg2.onEntered();
            }

            onExited: {
                taskDeleg2.onExited();
            }

            onClicked: {
                taskDeleg2.onClicked(mouse);
            }

            onPressAndHold:{
                taskDeleg2.onPressAndHold(mouse, imageMouseArea2);
            }

            onPositionChanged: {
                taskDeleg2.onPositionChanged(mouse, imageMouseArea2);
            }

            onReleased:{
                taskDeleg2.onReleased(mouse);
            }
        }

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

            opacity:parent.opacity === 0 ? 0:0.3

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


        MouseArea {
            id:imageMouseArea3
            anchors.fill: parent
            hoverEnabled: true

            onEntered: {
                taskDeleg2.onEntered();
            }

            onExited: {
                taskDeleg2.onExited();
            }

            onClicked: {
                taskDeleg2.onClicked(mouse);
            }

            onPressAndHold:{
                taskDeleg2.onPressAndHold(mouse, imageMouseArea3);
            }

            onPositionChanged: {
                taskDeleg2.onPositionChanged(mouse, imageMouseArea3);
            }

            onReleased:{
                taskDeleg2.onReleased(mouse);
            }
        }
    }


    onXChanged: {
        taskDeleg2.updatePreview();
    }
    ////Preview State///////////



    Rectangle{
        id: taskTitleRec

        //   anchors.horizontalCenter: parent.horizontalCenter

        //   width:taskDeleg2.width
        height:taskTitle2.height
        color:"#00e2e2e2"



        Text{
            id:taskTitle2

            anchors.horizontalCenter: parent.horizontalCenter


            text:name === undefined ? "" : name
            font.family: mainView.defaultFont.family
            font.italic: false
            font.bold: true
            font.pointSize: mainView.fixedFontSize+(mainView.scaleMeter/18)-2
            color:taskDeleg2.taskTitleTextDef

            elide:Text.ElideRight
            width:parent.width
        }

        MouseArea {
            id:textTaskMouseArea
            anchors.fill: parent
            hoverEnabled: true

            onEntered: {
                taskDeleg2.onEntered();
            }

            onExited: {
                taskDeleg2.onExited();
            }

            onClicked: {
                taskDeleg2.onClicked(mouse);
            }

            onPressAndHold:{
                taskDeleg2.onPressAndHold(mouse, textTaskMouseArea);
            }

            onPositionChanged: {
                taskDeleg2.onPositionChanged(mouse, textTaskMouseArea);
            }

            onReleased:{
                taskDeleg2.onReleased(mouse);
            }
        }
    }

    TaskPreviewButtons{
        id:allTasksBtns

        property real offsety:0
        property real offsetx:0


    }

    Connections {
        target: allTasksBtns
        onChangedStatus:{
            if (allTasksBtns.status === "hover"){
                taskDeleg2.onEntered();
                //taskDeleg2.state = "hovered";
            }
            else{
                //   taskDeleg2.state =  taskDeleg2.currentNoHovered;
                taskDeleg2.onExited();
            }
        }
    }


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
                opacity:0.3
                width:taskDeleg2.width
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
            }

            PropertyChanges{
                target:taskTitleRec
                y:showPreviewsFound===false ? 1.03*(imageTask2.y+imageTask2.height) : 1.03*(imageTask2.y+imageTask2.height)

                width:taskDeleg2.width
                opacity:1
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
            }
            PropertyChanges{
                target:imageTask2
                width: taskDeleg2.defWidth
                x:10
                y:(taskDeleg2.height - height) / 2
            }
            PropertyChanges{
                target:taskTitleRec
                y: (((taskDeleg2.height - imageTask2.height) / 2)+imageTask2.height-height)
                x: (imageTask2.x+imageTask2.width)
                width: taskDeleg2.width - imageTask2.width - 10
                opacity:0.7
            }
            PropertyChanges{
                target:taskHoverRect
                opacity:0
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

                opacity:1

                width:taskDeleg2.defPreviewWidth
                height:taskDeleg2.defPreviewWidth

               // y:(taskDeleg2.defPreviewWidth - height)
                y:0
                x:(taskDeleg2.width - taskDeleg2.defPreviewWidth)/2

                color: previewRect.lightColor
                border.color: previewRect.lightBorder

            }
            PropertyChanges{
                target:imageTask2
                width: 1.4*taskTitleRec.height
                x:0
           //     y: previewRect.y+previewRect.height-height
                y:taskTitleRec.y-height
                opacity:0.8
            }
            PropertyChanges{
                target:taskTitleRec
                y: previewRect.y+previewRect.height
                opacity:0.7
                width:taskDeleg2.width
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

                color: lightColor
                border.color: lightBorder

                opacity:showPreviewsFound===false ? 0 : 1
            }
            PropertyChanges{
                target:imageTask2
                width: showPreviewsFound===false ? 1.4*taskDeleg2.defWidth : 1.4*taskTitleRec.height
                x:showPreviewsFound===false ? 10 : 0
                y:showPreviewsFound===false ? (taskDeleg2.height - height) / 2 : taskTitleRec.y-height
                opacity: 0.8
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

    function onEntered() {
        if (taskDeleg2.isPressed === false){
            taskDeleg2.state = taskDeleg2.stateHov1;

            //This is a way to change position to allTasksBtns
            //according to window previews size
            if (showPreviewsFound ===  true){
                var ratioWin = taskManager.getWindowRatio(taskDeleg2.ccode);

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


            allTasksBtns.state = "show";
        }
    }

    function onExited() {
        taskDeleg2.state =  taskDeleg2.currentNoHovered;
        allTasksBtns.state = "hide";
    }

    function onClicked(mouse) {
        instanceOfTasksList.setCurrentTask(taskDeleg2.ccode);
    }

    function onPressAndHold(mouse,obj) {
        taskDeleg2.isPressed = true;
        taskDeleg2.state =  taskDeleg2.currentNoHovered;

        if (taskDeleg2.showAllActivities === false){

            var nC = taskDeleg2.mapToItem(mainView,0,0);

            taskDeleg2.parent=mainView;
            taskDeleg2.x = nC.x;
            taskDeleg2.y = nC.y;
        }

        allTasksBtns.state = "hide";

        var nCor = obj.mapToItem(mainView,mouse.x,mouse.y);

        var coord1 = imageTask2.mapToItem(mainView,imageTask2.x, imageTask2.y);

        mDragInt.enableDragging(nCor,
                                imageTask2.icon,
                                taskDeleg2.ccode,
                                taskDeleg2.cActCode,
                                taskDeleg2.cDesktop,
                                coord1,
                                true,
                                inDragging);

        if(scrollingView === desktopDialog.getDeskView()){
                desktopView.forceState1();
                taskDeleg2.forcedState1InDialog = true;
        }

        instanceOfTasksList.setTaskInDragging(taskDeleg2.ccode,true);

    }

    function onPositionChanged(mouse,obj) {
        if (taskDeleg2.isPressed === true){
            var nCor = obj.mapToItem(mainView,mouse.x,mouse.y);
            mDragInt.onPstChanged(nCor);
        }
    }

    function onReleased(mouse) {
        if (taskDeleg2.isPressed === true){
            mDragInt.onMReleased(mouse);

            if(desktopDialog.getDeskList() === centralListView){
                desktopDialog.emptyDialog();
                if (taskDeleg2.forcedState1InDialog === true){
                    desktopView.unForceState1();
                    taskDeleg2.forcedState1InDialog=false;
                }
            }


            instanceOfTasksList.setTaskInDragging(taskDeleg2.ccode,false);
            taskDeleg2.isPressed = false;

        }
    }

    function updatePreview(){
        if((taskDeleg2.showPreviews === true)&&
                (taskDeleg2.inShownArea === true))  {
            var x1 = 0;
            var y1 = 0;
            var obj = previewRect.mapToItem(mainView,x1,y1);

            taskManager.setWindowPreview(taskDeleg2.ccode,
                                         obj.x+mainView.previewsOffsetX,
                                         obj.y+mainView.previewsOffsetY,
                                         previewRect.width-(2*previewRect.border.width),
                                         previewRect.height-(2*previewRect.border.width));
        }

        if((taskDeleg2.inShownArea === false)||
                (taskDeleg2.showPreviews===false))
            taskManager.removeWindowPreview(taskDeleg2.ccode);
    }


    function getIcon(){
        return imageTask2;
    }

}

//}
