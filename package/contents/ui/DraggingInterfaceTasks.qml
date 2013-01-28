// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.qtextracomponents 0.1
import "../code/settings.js" as Settings
import "../code/dragginghelpers.js" as Helper

Rectangle{
    id:mainDraggingItem
    anchors.fill: mainView

    color:"#05000000"
    opacity:0
    z:-1

    property string intTaskId
    property string intActId
    property string intDesktop
    property int intX1
    property int intY1
    property bool intIsEverywhere

    property string drActiv: ""
    property int drDesktop: -1

    //0 - over a Workarea
    //1 - over an AddWorkarea button
    //2 - over everywhere tasks
    property int lastSelection

    property bool firsttime:true

    QIconItem{
        id:iconImg
        width:mainView.scaleMeter
        height:width
        opacity:0.8
        smooth:true
    }

    //Testing Purposes
    Rectangle{
        id:testRec
        x:150
        y:320
        width:10
        height:width
        color:"blue"

        visible:false
    }

    function enableDragging(ms,src,taskI,actI,deskI,coord1,everywhere){

        //if(desktopDialog !== mainView)
        //   desktopDialog.closeD();

        allWorkareas.flickableV = false;

        mainDraggingItem.opacity = 1;
        mainDraggingItem.z = 100;

        iconImg.icon = src;
        iconImg.enabled = true;

        mainDraggingItem.intTaskId = taskI;
        mainDraggingItem.intActId = actI;
        mainDraggingItem.intDesktop = deskI;
        mainDraggingItem.intX1 = coord1.x;
        mainDraggingItem.intY1 = coord1.y;
        mainDraggingItem.intIsEverywhere = everywhere;

        //  iconImg.icon = instanceOfTasksList.getTasksIcon(taskI);

        mainDraggingItem.lastSelection = -1;

        mainDraggingItem.firsttime = true;

        onPstChanged(ms);
    }

    function disableDragging(){
        mainDraggingItem.opacity = 0;
        mainDraggingItem.enabled = false;
        mainDraggingItem.z = -1;
        allWorkareas.flickableV = true;
        selectionImage.opacity = 0;

        selectionImage.setLocation(-1,-1,1,1);

        mainDraggingItem.lastSelection = -1;

        //It creates a confusion when releasing
        //must be fixed with a flag initialiazing properly
        //    mainDraggingItem.drActiv = "";
        //    mainDraggingItem.drDesktop = -1;
    }

    //PATHS IN ORDER TO FIND ELEMENTS IN QML STRUCTURE
    //the number indicates the children, 0-no children, 1-first child, 2-second etc...
    property variant workareaPath:[
        "WorkareasMainView",0,
        "WorkareasMainViewFlickable",1,
        "WorkareasColumnAppearance",1,
        "WorkareasColumnAppearanceDelegate",0,
        "WorkareasListView",1,
        "WorkareaDelegate",0]

    property variant addWorkareaPath:[
        "WorkareasMainView",0,
        "WorkareasMainViewFlickable",1,
        "WorkareasColumnAppearance",1,
        "WorkareasColumnAppearanceDelegate",0,
        "AddWorkareaButton",2]

    property variant workareasActPath:[
        "WorkareasMainView",0,
        "WorkareasMainViewFlickable",1,
        "WorkareasColumnAppearance",1,
        "WorkareasColumnAppearanceDelegate",0]

    property variant everywhereTasksPath:[
        "allActivitiesTasks", 3]

    function onPstChanged(mouse){

        iconImg.x = mouse.x + 1;
        iconImg.y = mouse.y + 1;

        var workarea = Helper.followPath(centralArea, mouse, workareaPath, 0);

        if(workarea !== false)
            hoveringWorkarea(workarea);
        else{
            var addWorkarea = Helper.followPath(centralArea, mouse, addWorkareaPath, 0);
            if(addWorkarea !== false)
                hoveringAddWorkarea(addWorkarea, mouse);
            else{
                var allTasks = Helper.followPath(centralArea, mouse, everywhereTasksPath, 0);
                if(allTasks !== false){
                    hoveringEverywhereTasks(allTasks);
                }
            }
        }
    }


    function hoveringWorkarea(workarea){
        if((mainDraggingItem.drActiv!==workarea.actCode)||
                (mainDraggingItem.drDesktop!==workarea.desktop) ||
                (mainDraggingItem.firsttime === true)){

            var bordRect = workarea.getBorderRectangle();
            var fixBCoord = bordRect.mapToItem(mainDraggingItem,bordRect.x, bordRect.y);

            selectionImage.setLocation(fixBCoord.x-2,fixBCoord.y-4,bordRect.width-2,bordRect.height+8);
            selectionImage.opacity = 1;

            mainDraggingItem.drActiv = workarea.actCode;
            mainDraggingItem.drDesktop = workarea.desktop;

            mainDraggingItem.lastSelection = 0;
            mainDraggingItem.firsttime = false;

        }
    }

    function hoveringAddWorkarea(addworkarea, mouse){
        var father = Helper.followPath(centralArea, mouse, workareasActPath, 0);
        var activityCode = "";
        var desktopsNum = 0;

        if(father !== false){
            activityCode = father.ccode;
            desktopsNum = father.getWorkareaSize();
        }

        if((mainDraggingItem.drActiv !== activityCode) ||
                (mainDraggingItem.drDesktop !== (desktopsNum+1) ) ||
                (mainDraggingItem.firsttime === true) ){

            var fixBCoord2 = addworkarea.mapToItem(mainDraggingItem,addworkarea.x, addworkarea.y);

            selectionImage.setLocation(fixBCoord2.x,fixBCoord2.y-5,addworkarea.width,1.3 * addworkarea.height);
            selectionImage.opacity = 1;

            mainDraggingItem.drActiv = activityCode;
            mainDraggingItem.drDesktop = desktopsNum+1;

            mainDraggingItem.lastSelection = 1;
            //          mainDraggingItem.firsttime = false;
        }

    }

    function hoveringEverywhereTasks(allTasks){
        var fixBCoord3 = allTasks.mapToItem(mainDraggingItem,allTasks.x, allTasks.y);

        var offX=13
        var offY=15

        selectionImage.setLocation(fixBCoord3.x-offX,fixBCoord3.y-offY, allTasks.width+1.4*offX, allTasks.height+1.8*offY);
        selectionImage.opacity = 1;

        mainDraggingItem.lastSelection = 2;
    }

    ///////////////////Releasing Section//////////////////
    function onMReleased(mouse, viewXY){
        var iX1 = iconImg.x;
        var iY1 = iconImg.y;

        if (mainDraggingItem.lastSelection === 0)
            releasedOnWorkarea();
        else if (mainDraggingItem.lastSelection === 1)
            releasedOnAddWorkarea(mouse, viewXY);
        else if (mainDraggingItem.lastSelection === 2)
            releasedOnEverywherePanel();

        disableDragging();
    }


    function releasedOnWorkarea(){
        if ( (mainDraggingItem.intActId !== mainDraggingItem.drActiv) ||
                (mainDraggingItem.intDesktop !== mainDraggingItem.drDesktop) ||
                (mainDraggingItem.intIsEverywhere === true)){

            taskManager.setTaskState( intTaskId, "oneDesktop", drActiv, drDesktop);

            taskManager.setTaskDesktopForAnimation( intTaskId, drDesktop);
            taskManager.setTaskActivityForAnimation( intTaskId, drActiv);

            if(Settings.global.animationStep2!==0){
                var co1 = mainView.mapToItem(mainView, iconImg.x, iconImg.y);
                mainView.getDynLib().animateEverywhereToActivity(mainDraggingItem.intTaskId,
                                                                 co1,
                                                                 2);
            }
        }
    }

    function releasedOnAddWorkarea(mouse, viewXY){
        workflowManager.workareaManager().addWorkArea(mainDraggingItem.drActiv, "");

        //var works = workflowManager.workareaManager().numberOfWorkareas( drActiv );

        taskManager.setTaskState(mainDraggingItem.intTaskId,"oneDesktop", drActiv, drDesktop);

        if(Settings.global.animationStep2!==0){
            var co14 = mainView.mapToItem(mainView, iconImg.x, iconImg.y);
            var toCol4 = mainView.mapToItem(mainView,mouse.x,mouse.y);

            viewXY.x = viewXY.x-30;

            mainView.getDynLib().animateEverywhereToXY(mainDraggingItem.intTaskId,
                                                       co14,
                                                       viewXY,
                                                       2);
        }
    }

    function releasedOnEverywherePanel(){
        taskManager.setTaskState(mainDraggingItem.intTaskId,"allActivities");

        if(Settings.global.animationStep2!==0){
            var co13 = mainView.mapToItem(mainView, iconImg.x, iconImg.y);
            mainView.getDynLib().animateDesktopToEverywhere(mainDraggingItem.intTaskId,
                                                            co13,
                                                            2);
        }
    }
}

