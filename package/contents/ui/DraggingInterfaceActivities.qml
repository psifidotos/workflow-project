// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.qtextracomponents 0.1
import "../code/settings.js" as Settings
import "../code/dragginghelpers.js" as Helper

Rectangle{
    id:container
    anchors.fill: parent
    color:"#05000000"
    opacity:0
    z:-1

    property string activityId: ""
    property string activityStatus: ""
    property int intIndex: -1

    property string currentActivity: ""
    property int currentIndex: -1

    property int intX1
    property int intY1

    signal updateReceiversPlace();

    property Item movingActivity
    property Item secondActivity

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

    function enableDragging(mouse,coords, activity, status, icon){
        allWorkareas.flickableV = false;
        stoppedPanel.flickableV = false;

        container.opacity = 1;
        container.z = 100;

        iconImg.icon = icon;
        iconImg.enabled = true;

        container.activityId = activity;
        container.activityStatus = status;
        currentIndex = workflowManager.model().getIndexFor(activity)
        currentActivity = activity;
        intIndex = currentIndex;

        console.log("----- Dragging Starting Current Index: "+currentIndex);

        container.intX1 = coords.x;
        container.intY1 = coords.y;

        iconImg.x = coords.x + 1;
        iconImg.y = coords.y + 1;

        onPstChanged(mouse);
    }

    function disableDragging(){
        container.activityId = "";
        container.activityStatus = "";
        currentActivity = "";

        container.opacity = 0;
        container.enabled = false;
        container.z = -1;
        allWorkareas.flickableV = true;
        stoppedPanel.flickableV = true;

        //It creates a confusion when releasing
        //must be fixed with a flag initialiazing properly
        //    mainDraggingItem.drActiv = "";
        //    mainDraggingItem.drDesktop = -1;
    }

    //PATHS IN ORDER TO FIND ELEMENTS IN QML STRUCTURE
    //the number indicates the children, 0-no children, 1-first child, 2-second etc...
    property variant runningActivityPath:[
        "WorkareasMainView",0,
        "WorkareasMainViewFlickable",1,
        "RunningActivitiesFrame",0,
        "RunningActivitiesList",1,
        "RunningActivityDelegate",0]

    property variant runningActivityWorkListPath:[
        "WorkareasMainView",0,
        "WorkareasMainViewFlickable",1,
        "WorkareasColumnAppearance",1,
        "WorkareasColumnAppearanceDelegate",0]

    property variant stoppedActivitiesPath:[
        "StoppedActivitiesPanel",0,
        "StoppedActivitiesFlickable",1,
        "StoppedActivitiesList",1,
        "StoppedActivityDelegate",0]

    function swapActivities(){
        var x1 = secondActivity.x;
        var y1 = secondActivity.y;
        secondActivity.x = movingActivity.x;
        secondActivity.y = movingActivity.y;
        movingActivity.x = x1;
        movingActivity.y = y1;
    }

    function onPstChanged(mouse){

        iconImg.x = mouse.x + 1;
        iconImg.y = mouse.y + 1;

        var activity = childAt ( mouse.x, mouse.y);
        if((activity !== null)&&(activity.typeId === "activityReceiver")){
            if(activity.activityCode !== container.activityId){
                console.log("----- "+activity.activityCode + " - "+activity.activityName);
                var newIndex = workflowManager.model().getIndexFor(activity.activityCode);
                console.log("----- Current Index: "+currentIndex+" - New Index:"+newIndex);

               // if((currentIndex !== newIndex)&&(newIndex>=0)&&(activityStatus === "Running")){
                 if((currentIndex !== newIndex)&&(newIndex>=0)){
                    secondActivity = activity;
                    swapActivities();
                    currentActivity = activity.activityCode;
                    currentIndex = newIndex;
                    workflowManager.activityManager().moveActivityInModel(container.activityId, newIndex);
                    //if (activityStatus !== "Running")
                      // workflowManager.activityManager().setCurrentInModel(container.activityId, "Running");
                }
            }
            else
                movingActivity = activity

//            console.log(activity.activityCode);
        }



    /*    var runningActivity = Helper.followPath(centralArea, mouse, runningActivityPath, 0);
        if(runningActivity !== false)
            hoveringRunningActivity(runningActivity);
        else{
            var runningActivityWorkList = Helper.followPath(centralArea, mouse, runningActivityWorkListPath, 0);
            if(runningActivityWorkList !== false)
                hoveringRunningActivity(runningActivityWorkList);
            else{
                var stoppedActivity = Helper.followPath(centralArea, mouse, stoppedActivitiesPath, 0);
                if(stoppedActivity !== false)
                    hoveringStoppedActivity(stoppedActivity);
            }
        }*/

    }

    function hoveringRunningActivity(activity){

        if(activity.ccode !== container.activityId){
       //     console.log("----- "+activity.ccode + " - "+activity.activityName);
            var newIndex = workflowManager.model().getIndexFor(activity.ccode);
      //      console.log("----- Current Index: "+currentIndex+" - New Index:"+newIndex);

            if((currentIndex !== newIndex)&&(newIndex>0)&&(activityStatus === "Running")){
                currentIndex = newIndex;
                workflowManager.activityManager().moveActivityInModel(container.activityId, newIndex);
                //if (activityStatus !== "Running")
                  // workflowManager.activityManager().setCurrentInModel(container.activityId, "Running");
            }
        }
    }

    function hoveringStoppedActivity(activity){
        if(activity.ccode !== container.activityId){
       //     console.log("----- "+activity.ccode + " - "+activity.activityName);
            var newIndex = workflowManager.model().getIndexFor(activity.ccode);
        //    console.log("----- Current Index: "+currentIndex+" - New Index:"+newIndex);

            if((currentIndex !== newIndex)&&(newIndex>0)&&(activityStatus === "Stopped")){
                currentIndex = newIndex;
                workflowManager.activityManager().moveActivityInModel(container.activityId, newIndex);
                //if (activityStatus !== "Stopped")
                  //  workflowManager.activityManager().setCurrentInModel(container.activityId, "Stopped");
                container.updateReceiversPlace();
            }
        }
    }

    function onMReleased(mouse, viewXY){
        var iX1 = iconImg.x;
        var iY1 = iconImg.y;

        console.log("Data Engine Move - "+container.activityId + " - "+intIndex + " - " + currentIndex);
        if(intIndex !== currentIndex)
            workflowManager.workareaManager().moveActivity(container.activityId, currentIndex);

        disableDragging();
    }



}

