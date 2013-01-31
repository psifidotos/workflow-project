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

    function onPstChanged(mouse){

        iconImg.x = mouse.x + 1;
        iconImg.y = mouse.y + 1;

        var activity = childAt ( mouse.x, mouse.y);
        if((activity !== null)&&(activity.typeId === "activityReceiver")){
            currentActivity = activity.activityCode;
            var newIndex = workflowManager.model().getIndexFor(activity.activityCode);
            currentIndex = newIndex;
      //      console.log("----- "+activity.activityCode + " - "+activity.activityName);
          //  console.log("----- Current Index: "+currentIndex+" - New Index for "+activity.activityName+" :"+newIndex);
        }

    }

    function onMReleased(mouse, viewXY){
        var iX1 = iconImg.x;
        var iY1 = iconImg.y;

        console.log("Data Engine Move - "+container.activityId + " - "+intIndex + " - " + currentIndex);
        if(intIndex !== currentIndex){
            workflowManager.activityManager().moveActivityInModel(container.activityId, currentIndex);
            workflowManager.workareaManager().moveActivity(container.activityId, currentIndex);
        }

        disableDragging();
    }

}

