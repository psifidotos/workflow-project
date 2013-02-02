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
    property bool isActive: false
    property bool onEverywhere: false

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

        mainDraggingItem.lastSelection = -1;

        mainDraggingItem.firsttime = true;
        isActive = true;
        onEverywhere = false;

        onPstChanged(ms);
    }

    function disableDragging(){
        mainDraggingItem.opacity = 0;
        mainDraggingItem.enabled = false;
        mainDraggingItem.z = -1;
        allWorkareas.flickableV = true;

        mainDraggingItem.lastSelection = -1;

        mainDraggingItem.intActId = "";
        mainDraggingItem.intDesktop = -1;
        mainDraggingItem.intTaskId = "";


        //It creates a confusion when releasing
        //must be fixed with a flag initialiazing properly
        mainDraggingItem.drActiv = "";
        mainDraggingItem.drDesktop = -1;
        isActive = false;
        onEverywhere = false;
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

            mainDraggingItem.drActiv = workarea.actCode;
            mainDraggingItem.drDesktop = workarea.desktop;
            mainDraggingItem.onEverywhere = false;

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
            mainDraggingItem.drActiv = activityCode;
            mainDraggingItem.drDesktop = desktopsNum+1;
            mainDraggingItem.onEverywhere = false;

            mainDraggingItem.lastSelection = 1;
            //          mainDraggingItem.firsttime = false;
        }

    }

    function hoveringEverywhereTasks(allTasks){
        mainDraggingItem.onEverywhere = true;
        mainDraggingItem.lastSelection = 2;
    }

    ///////////////////Releasing Section//////////////////
    function onMReleased(mouse){
        var iX1 = iconImg.x;
        var iY1 = iconImg.y;

        if (mainDraggingItem.lastSelection === 0)
            releasedOnWorkarea();
        else if (mainDraggingItem.lastSelection === 1)
            releasedOnAddWorkarea(mouse);
        else if (mainDraggingItem.lastSelection === 2)
            releasedOnEverywherePanel();

        disableDragging();
    }


    function releasedOnWorkarea(){
        if ( (mainDraggingItem.intActId !== mainDraggingItem.drActiv) ||
                (mainDraggingItem.intDesktop !== mainDraggingItem.drDesktop) ||
                (mainDraggingItem.intIsEverywhere === true)){

            var windowsState = taskManager.windowState(intTaskId);

            if (windowsState === "allDesktops"){
                taskManager.setOnlyOnActivity(intTaskId, drActiv);
                taskManager.setTaskActivityForAnimation( intTaskId, drActiv);
            }
            else if(windowsState === "sameDesktops"){
                taskManager.setOnDesktop(intTaskId, drDesktop);
                taskManager.setTaskDesktopForAnimation( intTaskId, drDesktop)
            }
            else{
                taskManager.setTaskState( intTaskId, "oneDesktop", drActiv, drDesktop);
                taskManager.setTaskDesktopForAnimation( intTaskId, drDesktop);
                taskManager.setTaskActivityForAnimation( intTaskId, drActiv);
            }

            if(Settings.global.animationStep2!==0){
                var co1 = mainView.mapToItem(mainView, iconImg.x, iconImg.y);
                mainView.getDynLib().animateEverywhereToActivity(mainDraggingItem.intTaskId,
                                                                 co1,
                                                                 2);
            }
        }
    }

    function releasedOnAddWorkarea(mouse){
        workflowManager.workareaManager().addWorkArea(mainDraggingItem.drActiv, "");

        //var works = workflowManager.workareaManager().numberOfWorkareas( drActiv );

        taskManager.setTaskState(mainDraggingItem.intTaskId,"oneDesktop", drActiv, drDesktop);

        if(Settings.global.animationStep2!==0){
            var co14 = mainView.mapToItem(mainView, iconImg.x, iconImg.y);
            var toCol4 = mainView.mapToItem(mainView,co14.x - 65,co14.y);

            mainView.getDynLib().animateEverywhereToXY(mainDraggingItem.intTaskId,
                                                       co14,
                                                       toCol4,
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

