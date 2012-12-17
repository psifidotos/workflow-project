// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1


import ".."
import "../models"

Item{

    property variant model: ActivitiesModel1{}

    property int newActivityCounter:0

    property int vbYes:3

    //variable to use in asychronous change an activity,
    //first go to an activity and then change desktop
    property int goToDesktop:-1

    property string fromCloneActivity:""
    property string toCloneActivity:""
    property bool fromActivityWasCurrent:false
    property bool previewsWereEnabled:false
    property bool widgetsExplorerAwaitingActivity:false

    //When we add a new activity a series of signal must be generated in order
    //to have a success creation
    property string previousActiveActivity:""
    property string mustActivateActivity:""


    function printModel(){
        console.debug("---- Activities Model -----");
        for(var i=0; i<model.count; ++i){
            var obj = model.get(i);
            console.debug(obj.code + " - " + obj.Name + " - " +obj.Icon + " - " +obj.Current + " - " +obj.CState);
        }
        console.debug("----  -----");
    }

    function initPhase02Completed(){
        startActivity(fromCloneActivity);
    }

    function initPhase04Completed(){
        updateWallpaper(toCloneActivity);
        startActivity(toCloneActivity);

        if(fromActivityWasCurrent === true){
            setCurrentActivityAndDesktop(fromCloneActivity,sessionParameters.currentDesktop);
            fromActivityWasCurrent = false;
        }

        fromCloneActivity = "";
        toCloneActivity = "";
        //busyIndicatorDialog.resetAnimation();
        mainView.getDynLib().deleteBusyIndicatorDialog();

        if(previewsWereEnabled === true)
            storedParameters.windowsPreviews = true;
        else
            storedParameters.windowsPreviews = false;

    }


    function setCState(cod, val){
        var ind = getIndexFor(cod);
        if (ind>-1){

            if( (fromCloneActivity === "") &&
                    (toCloneActivity === "")){

                model.setProperty(ind,"CState",val);

                instanceOfWorkAreasList.setCState(cod,val);


                allWorkareas.updateShowActivities();
                stoppedPanel.changedChildState();
            }


            //This is Phase02 of Cloning
            if( (cod === fromCloneActivity) &&
                    (val === "Stopped")){
                activityManager.initCloningPhase02(cod);
            }

            //This is Phase03 of Cloning
            if( (cod === fromCloneActivity) &&
                    (val === "Running"))
                stopActivity(toCloneActivity);

            //This is Phase04 of Cloning
            if( (cod === toCloneActivity) &&
                    (val === "Stopped"))
                activityManager.initCloningPhase04(cod);



            //Phase 05 of loading Wallpaper of New Activity
            if( (cod === mustActivateActivity) &&
                    (val === "Stopped")&&
                    (toCloneActivity === "")){
                var act = mustActivateActivity;
                var oldAct = previousActiveActivity;

                mustActivateActivity = "";
                previousActiveActivity = "";

                console.debug("OK the end:"+mustActivateActivity+"-"+previousActiveActivity);
                startActivity(act);

            }

        }
    }

    function activityAddedIn(source,title,icon,stat,cur)
    {
        if (stat === "")
            stat = "Running";

        model.append( {  "code": source,
                         "Current":cur,
                         "Name":title,
                         "Icon":icon,
                         "CState":stat} );

        if(workflowManager.activityExists(source)){
            var nms = workflowManager.getWorkAreaNames(source);

            instanceOfWorkAreasList.addActivityOnLoading(source,stat,cur,nms);
        }
        else{
            instanceOfWorkAreasList.addNewActivityF(source, stat, cur);

            for(var j=1; j<sessionParameters.numberOfDesktops; ++j){
                instanceOfWorkAreasList.addWorkarea(source);
            }

        }

        //////

        setCState(source,stat);

        updateWallpaper(source);

        //Phase-01 Of Cloning
        if(fromCloneActivity !== ""){
            toCloneActivity = source;
            copyActivityBasicSettings(fromCloneActivity,toCloneActivity);
            setCurrentActivityAndDesktop(source,sessionParameters.currentDesktop);
            stopActivity(fromCloneActivity);
        }


        //Phase 02 of loading Wallpaper of New Activity

        if( (source === mustActivateActivity) &&
                (fromCloneActivity === "") )
            setCurrentActivityAndDesktop(source,sessionParameters.currentDesktop);
    }

    function setIcon(cod, val){
        activityManager.setIcon(cod, val);
    }


    function chooseIcon(cod){
        activityManager.chooseIcon(cod);
    }

    function activityUpdatedIn(source,title,icon,stat,cur)
    {
        if (stat === "")
            stat = "Running";

        var ind = getIndexFor(source);
        if(ind>-1){
            model.setProperty(ind,"Name",title);
            model.setProperty(ind,"Icon",icon);
            setCState(source,stat);
         //   setCurrentIns(source,cur);
        }

    }

    function activityRemovedIn(cod){
        var p = getIndexFor(cod);
        if (p>-1){

            //Be careful there is probably a bug in removing the first element in ListModel, crashed KDE
            model.remove(p);

            workflowManager.removeActivity(cod);

            instanceOfWorkAreasList.removeActivity(cod);
            allWorkareas.updateShowActivities();
        }

    }

    //It is used from the cloning process in order to copy
    //Name and Icon
    function copyActivityBasicSettings(from,to){
        var p = getIndexFor(from);
        if (p>-1){
            var nm = model.get(p).Name;
            var ic = model.get(p).Icon;

            setName(to,i18n("Copy of")+" "+nm);
            setIcon(to,ic);

            instanceOfWorkAreasList.copyWorkareas(from,to);
        }
    }

    function stopActivity(cod){

        if(cod=== sessionParameters.currentActivity){
            var nId = getFirstRunningIdAfter(cod);

            var nextDesk = sessionParameters.currentDesktop;

            setCurrentActivityAndDesktop(nId,nextDesk);
        }

        activityManager.stop(cod);

    }


    function updateWallpaper(cod){
        var pt = activityManager.getWallpaper(cod);

        if (pt !== "")
            instanceOfWorkAreasList.setWallpaper(cod,pt);
    }


    function startActivity(cod){

        activityManager.start(cod);

        updateWallpaper(cod);
    }

    function setName(cod,title){
        activityManager.setName(cod,title);
    }

    function getFirstRunningActivityId(){
        for(var i=0; i<model.count; ++i){
            var obj = model.get(i);
            if (obj.CState === "Running")
                return obj.code;
        }

        return "";
    }

    function getFirstRunningIdAfter(cd){
        var ind = getIndexFor(cd);
        if(ind>-1){
            for(var i=ind+1; i<model.count; ++i){
                var obj = model.get(i);
                if (obj.CState === "Running")
                    return obj.code;
            }
            for(var j=0; j<ind; ++j){
                var obj2 = model.get(j);
                if (obj2.CState === "Running")
                    return obj2.code;
            }
        }

        return "";
    }

    function getFirstRunningIdBefore(cd){
        var ind = getIndexFor(cd);
        if(ind>-1){
            for(var i=ind-1; i>=0; i--){
                var obj = model.get(i);
                if (obj.CState === "Running")
                    return obj.code;
            }
            for(var j=model.count-1; j>ind; j--){
                var obj2 = model.get(j);
                if (obj2.CState === "Running")
                    return obj2.code;
            }
        }

        return "";
    }

    function slotSetCurrentNextActivity(){
        var nId = getFirstRunningIdAfter(sessionParameters.currentActivity);

        if(nId !== "")
            setCurrent(nId);
    }

    function slotSetCurrentPreviousActivity(){
        var nId = getFirstRunningIdBefore(sessionParameters.currentActivity);

        if(nId !== "")
            setCurrent(nId);
    }

    function getCState(cod){
        var ind = getIndexFor(cod);

        if(ind>-1)
            return model.get(ind).CState;
        else
            return "";
    }

    function setCurrentSignal(cod){
        var ind = getIndexFor(cod);
        if(ind>-1){
            for(var i=0; i<model.count; ++i){
                model.setProperty(i,"Current",false);
            }


            model.setProperty(ind,"Current",true);

            instanceOfWorkAreasList.setCurrent(cod);

            updateWallpaper(cod);


            if(widgetsExplorerAwaitingActivity){
                activityManager.showWidgetsExplorer(cod);
                widgetsExplorerAwaitingActivity = false;

                //Hide it after showing the widgets
                if(!mainView.isOnDashBoard)
                    workflowManager.hidePopupDialog();
            }

            //Phase 03 Of updating the wallpaper of new activity
            if((cod === mustActivateActivity)&&
                    (fromCloneActivity === ""))
                setCurrentActivityAndDesktop(previousActiveActivity,sessionParameters.currentDesktop);

            //Phase 04 Of updating the wallpaper of new activity
            if((cod === previousActiveActivity)&&
                    (fromCloneActivity === ""))
                stopActivity(mustActivateActivity);

        }
    }

    function setCurrent(cod){
        if(sessionParameters.currentActivity === cod)
            updateWallpaper(cod);

        activityManager.setCurrent(cod);
    }

    function setCurrentActivityAndDesktop(activit, desk)
    {

        setCurrent(activit);

        var nextDesk = desk;

        var actSize = instanceOfWorkAreasList.getActivitySize(activit);

        // console.debug(nextDesk+"-"+actSize);

        if(desk>instanceOfWorkAreasList.getActivitySize(activit))
            nextDesk = actSize;

        instanceOfTasksList.setCurrentDesktop(nextDesk);



        return nextDesk;

    }

    //This is only for Dashboard and on current Activity
    Timer{
        id:showWidgetsExplorerTimer
        interval: 200
        repeat: false

        property string actCode:""
        onTriggered: {
            activityManager.showWidgetsExplorer(actCode);
        }
    }

    function showWidgetsExplorer(act){
        activityManager.showWidgetsExplorer(act);
    }

    function getIndexFor(cod){
        for(var i=0; i<model.count; ++i){
            var obj = model.get(i);
            if (obj.code === cod)
                return i;
        }

        return -1;
    }

    function getActivityName(cod){
        var ind=getIndexFor(cod);
        if (ind>-1)
            return model.get(ind).Name;

        return "";
    }

    function cloneActivity(cod){

        fromCloneActivity = cod;

        if(fromCloneActivity === sessionParameters.currentActivity)
            fromActivityWasCurrent = true;

        if(storedParameters.windowsPreviews === true){
            previewsWereEnabled = true;
            storedParameters.windowsPreviews = false;
        }
        else
            previewsWereEnabled = false;

        mainView.getDynLib().showBusyIndicatorDialog();

        addNewActivity();

    }

    function cloneActivityDialog(cod){
        var p = getIndexFor(cod);
        if(p>-1){
            var ob = model.get(p);

            mainView.getDynLib().showCloneDialog(cod,ob.Name);
        }
    }


    function removeActivity(cod){
        activityManager.remove(cod);
    }

    function removeActivityDialog(cod){


        var p = getIndexFor(cod);
        if(p>-1){
            var ob = model.get(p);

            mainView.getDynLib().showRemoveDialog(cod,ob.Name);
        }
    }


    function addNewActivity(){
        if(fromCloneActivity === "")
            previousActiveActivity = sessionParameters.currentActivity;

        var res = activityManager.add(i18n("New Activity"));

        if(fromCloneActivity === "")
            mustActivateActivity = res;

        return res;


        ////////SOS, DO NOT DELETE, IT CAN NOT CLONE THE EMPTY ACTIVITY(NEW ACTIVITY)
        ///////IT CREATES AN ENTERNAL LOOP...................//////

        //      setCurrentActivityAndDesktop(res,mainView.currentDesktop);
        //       setCurrentActivityAndDesktop(previousActiveActivity,mainView.currentDesktop);

        ///////////////////////////
        ////////SOS, DO NOT DELETE, IT CAN NOT CLONE THE EMPTY ACTIVITY(NEW ACTIVITY)

       //   previousActiveActivity = "";
        //   mustActivateActivity = "";


    }



}
