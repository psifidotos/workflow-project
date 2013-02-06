// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import "../../code/settings.js" as Settings
import ".."
Item{
    id:container

    property string selectedActivity: ""
    property int selectedWorkarea: 0
    property bool inRunning: true

    property bool isActive: false

    //this is used to show the windows filter frame
    property bool filterCalled:false

    //
    property bool ctrlActive: false

    focus: true

    signal actionActivated(string key);

    Component.onCompleted: {
        selectedActivity = sessionParameters.currentActivity;
        selectedWorkarea = sessionParameters.currentDesktop;
        filterCalled = false;
        CtrlActive = false;
    }


    Keys.onLeftPressed: {leftPressed(); }
    Keys.onRightPressed: {rightPressed(); }
    Keys.onUpPressed: {upPressed(); }
    Keys.onDownPressed: {downPressed(); }
    Keys.onReturnPressed: returnPressed();
    Keys.onEnterPressed: returnPressed();
    Keys.onEscapePressed: {isActive = false; filterCalled = false;}
    Keys.onPressed: {
        if(event.key === Qt.Key_H)
            leftPressed();
        else if(event.key === Qt.Key_J)
            downPressed();
        else if(event.key === Qt.Key_K)
            upPressed();
        else if(event.key === Qt.Key_L)
            rightPressed();
        else if(event.key === Qt.Key_Pause){
            if(isActive){
                container.actionActivated("Pause");
                inRunning = false;
            }
        }
        else if(event.key === Qt.Key_Slash){
            filterCalled = true;
            filterWindows.forceActiveFocus();
        }
        else if(event.key === Qt.Key_F){
            if(ctrlActive){
                filterCalled = true;
                filterWindows.forceActiveFocus();
            }
        }
        else if(event.key === Qt.Key_Control){
            console.log("true");
            ctrlActive = true;
        }
    }
    Keys.onReleased: {
        if(event.key === Qt.Key_Control){
            console.log("false");
            ctrlActive = false;
        }
    }

    //"h" = "left", "j" = "downwards", "k" = "upwards", "l" = "right" (where the latter one is an "L")

    Timer {
        id:timer
        interval: 3500; running: false; repeat: false
        onTriggered: container.isActive = false;
    }


    function leftPressed(){
        timer.start();
        if(isActive){
            var index = getRunningIndexFor(selectedActivity);
            if ((index > 0) &&
                    ( index <= runningActivitiesModel.count - 1) &&
                    (inRunning)){
                var obj = runningActivitiesModel.get(index-1);
                selectedActivity = obj.code;
                checkWorkareaPosition();
            }
            else if(!inRunning){
                var runObj = runningActivitiesModel.get(runningActivitiesModel.count - 1);
                selectedActivity = runObj.code;
                inRunning = true;
                checkWorkareaPosition();
            }
        }
        else
            isActive = true;

        timer.start();
        //    console.log(selectedActivity+" - " +selectedWorkarea);
    }


    function rightPressed(){
        if(isActive){
            var index = getRunningIndexFor(selectedActivity);
            if ((index < runningActivitiesModel.count - 1)&&
                    (index >=0)){
                var obj = runningActivitiesModel.get(index+1);
                selectedActivity = obj.code;
                checkWorkareaPosition();
            }
            else if ((index === runningActivitiesModel.count - 1) &&
                     (stoppedActivitiesModel.count > 0) &&
                     (inRunning)){
                inRunning = false;
                var stpObj = stoppedActivitiesModel.get(0);
                selectedActivity = stpObj.code;
            }
        }
        else
            isActive = true;

        timer.start();
        //    console.log(selectedActivity+" - " +selectedWorkarea);
    }

    function upPressed(){
        if(isActive){
            if(inRunning){
                var maxWorkareas = workflowManager.model().workareas(selectedActivity).count;

                if(selectedWorkarea > 1)
                    selectedWorkarea--;
            }
            else{
                var index = getStoppedIndexFor(selectedActivity);
                if ((index <= stoppedActivitiesModel.count - 1)&&
                        (index > 0)){
                    var obj = stoppedActivitiesModel.get(index-1);
                    selectedActivity = obj.code;
                }
            }

        }
        else
            isActive = true;

        timer.start();
        //    console.log(selectedActivity+" - " +selectedWorkarea);
    }


    function downPressed(){
        if(isActive){
            if(inRunning){
                var maxWorkareas = workflowManager.model().workareas(selectedActivity).count;

                if(selectedWorkarea<=maxWorkareas)
                    selectedWorkarea++;
            }
            else{
                var index = getStoppedIndexFor(selectedActivity);
                if ((index < stoppedActivitiesModel.count - 1)&&
                        (index >=0)){
                    var obj = stoppedActivitiesModel.get(index+1);
                    selectedActivity = obj.code;
                }
            }

        }
        else
            isActive = true;

        timer.start();
        //    console.log(selectedActivity+" - " +selectedWorkarea);
    }

    function returnPressed(){
        if(isActive){
            container.actionActivated("");
            isActive=false;
        }
    }


    function checkWorkareaPosition(){
        var maxWorkareas = workflowManager.model().workareas(selectedActivity).count;
        if(selectedWorkarea > maxWorkareas)
            selectedWorkarea = maxWorkareas;
    }


    /************************************/

    function getRunningIndexFor(activity){
        var res = -1;
        for(var i=0; i<runningActivitiesModel.count; ++i){
            var obj = runningActivitiesModel.get(i);
            if(obj.code === activity)
                return i;
        }

        return res;
    }

    function getStoppedIndexFor(activity){
        var res = -1;
        for(var i=0; i<stoppedActivitiesModel.count; ++i){
            var obj = stoppedActivitiesModel.get(i);
            if(obj.code === activity)
                return i;
        }

        return res;
    }
}

