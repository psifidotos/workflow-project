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


    function printModel(){
        console.debug("---- Activities Model -----");
        for(var i=0; i<model.count; ++i){
            var obj = model.get(i);
            console.debug(obj.code + " - " + obj.Name + " - " +obj.Icon + " - " +obj.Current + " - " +obj.CState);
        }
        console.debug("----  -----");
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
                activityManager.loadCloneActivitySettings(fromCloneActivity);
                startActivity(fromCloneActivity);

            }

            //This is Phase03 of Cloning
            if( (cod === fromCloneActivity) &&
                    (val === "Running")){
                stopActivity(toCloneActivity);
            }


            //This is Phase04 of Cloning
            if( (cod === toCloneActivity) &&
                    (val === "Stopped")){

                activityManager.storeCloneActivitySettings(cod);
                updateWallpaper(cod);
                startActivity(cod);

                if(fromActivityWasCurrent === true){
                    setCurrentActivityAndDesktop(fromCloneActivity,mainView.currentDesktop);
                    fromActivityWasCurrent = false;
                }

                fromCloneActivity = "";
                toCloneActivity = "";
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

        if(mainView.maxDesktops === 0)
            mainView.maxDesktops = taskManager.getMaxDesktops();

        //workflowManager.addEmptyActivity(source);
        if(workflowManager.activityExists(source)){
            var nms = workflowManager.getWorkAreaNames(source);

            instanceOfWorkAreasList.addActivityOnLoading(source,stat,cur,nms);
        }
        else{
            instanceOfWorkAreasList.addNewActivityF(source, stat, cur);

            for(var j=1; j<mainView.maxDesktops; ++j){
                instanceOfWorkAreasList.addWorkarea(source);
            }

        }

        //////

        if (cur)
            mainView.currentActivity = source;

        setCState(source,stat);

        // updateWallpaper(source,1000);
        // var pt = activityManager.getWallpaper(source);
        //      instanceOfWorkAreasList.setWallpaper(source,pt);
        updateWallpaper(source);

        //Phase-01 Of Cloning
        if(fromCloneActivity !== ""){
            toCloneActivity = source;
            copyActivityBasicSettings(fromCloneActivity,toCloneActivity);
            setCurrentActivityAndDesktop(source,mainView.currentDesktop);
            stopActivity(fromCloneActivity);
        }
    }

    function setIcon(cod, val){
        activityManager.setIcon(cod, val);
    }


    function chooseIcon(cod){
        activityManager.chooseIcon(cod);
    }

    function setCurrentIns(source,cur)
    {
        var ind = getIndexFor(source);
        model.setProperty(ind,"Current",cur);

        if (cur)
            mainView.currentActivity = source;

        instanceOfWorkAreasList.setCurrentIns(source,cur);
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
            setCurrentIns(source,cur);
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

        if(cod=== mainView.currentActivity){
            var nId = getFirstRunningIdAfter(cod);

            var nextDesk = mainView.currentDesktop;

            //            var actSize = instanceOfWorkAreasList.getActivitySize(nId);

            //            console.debug(nextDesk+"-"+actSize);
            //          if(nextDesk>instanceOfWorkAreasList.getActivitySize(nId)){
            //            nextDesk = actSize;
            //      }

            setCurrentActivityAndDesktop(nId,nextDesk);
        }

        activityManager.stop(cod);

        //    setCState(cod,"Stopped");
        //    instanceOfWorkAreasList.setCState(cod,"Stopped");
    }


    function updateWallpaper(cod){
        var pt = activityManager.getWallpaper(cod);

        if (pt !== "")
            instanceOfWorkAreasList.setWallpaper(cod,pt);
    }


    function startActivity(cod){

        activityManager.start(cod);

        setCState(cod,"Running");
        instanceOfWorkAreasList.setCState(cod,"Running");

        //updateWallpaperInt(cod,1000);
        updateWallpaper(cod);

        //        var pt = activityManager.getWallpaper(cod);
        //       instanceOfWorkAreasList.setWallpaper(cod,pt);
    }

    function setName(cod,title){
        activityManager.setName(cod,title);

        //   var ind = getIndexFor(cod);
        //  model.setProperty(ind,"Name",title);
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

    function getCState(cod){
        var ind = getIndexFor(cod);

        if(ind>-1)
            return model.get(ind).CState;
        else
            return "";
    }

    function setCurrentSignal(cod){
        for(var i=0; i<model.count; ++i){
            model.setProperty(i,"Current",false);
        }

        var ind = getIndexFor(cod);
        model.setProperty(ind,"Current",true);

        mainView.currentActivity = cod;

        instanceOfWorkAreasList.setCurrent(cod);

        //  if(goToDesktop > -1){
        //    instanceOfTasksList.setCurrentDesktop(goToDesktop);
        //    goToDesktop = -1;
        //  }
    }

    function setCurrent(cod){
        activityManager.setCurrent(cod);

        instanceOfWorkAreasList.setCurrent(cod);
    }

    function setCurrentActivityAndDesktop(activit, desk)
    {
        updateWallpaper(activit);
        setCurrent(activit);

        var nextDesk = desk;

        var actSize = instanceOfWorkAreasList.getActivitySize(activit);

        // console.debug(nextDesk+"-"+actSize);

        if(desk>instanceOfWorkAreasList.getActivitySize(activit))
            nextDesk = actSize;

        instanceOfTasksList.setCurrentDesktop(nextDesk);

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

        if(fromCloneActivity === mainView.currentActivity)
            fromActivityWasCurrent = true;

        addNewActivity();

    }

    function removeActivity(cod){
        var p = getIndexFor(cod);
        var ob = model.get(p);

        removeDialog.activityName = ob.Name;
        removeDialog.activityCode = cod;
        removeDialog.open();
    }


    function addNewActivity(){
        var res = activityManager.add(i18n("New Activity"));
    }


}
