// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import ".."
import "../models"

Item{

    property variant model: ActivitiesModel1{}

    //is used when cloning an activity to temporary
    //disable previews
    property bool previewsWereEnabled:false

    function printModel(){
        console.debug("---- Activities Model -----");
        for(var i=0; i<model.count; ++i){
            var obj = model.get(i);
            console.debug(obj.code + " - " + obj.Name + " - " +obj.Icon + " - " +obj.Current + " - " +obj.CState);
        }
        console.debug("----  -----");
    }


    //Cloning Signals for interaction with the interface
    function copyWorkareasSlot(from, to){
        instanceOfWorkAreasList.copyWorkareas(from,to);
    }

    function cloningStartedSlot(){
        if(storedParameters.windowsPreviews === true){
            previewsWereEnabled = true;
            storedParameters.windowsPreviews = false;
        }
        else
            previewsWereEnabled = false;

        mainView.getDynLib().showBusyIndicatorDialog();
    }

    function cloningEndedSlot(){
        mainView.getDynLib().deleteBusyIndicatorDialog();

        if(previewsWereEnabled === true)
            storedParameters.windowsPreviews = true;
        else
            storedParameters.windowsPreviews = false;
    }
    /////////////////////////////////////////////


    function setCState(cod, val){
        var ind = getIndexFor(cod);
        if (ind>-1){

            model.setProperty(ind,"CState",val);

            instanceOfWorkAreasList.setCState(cod,val);

            allWorkareas.updateShowActivities();
            stoppedPanel.changedChildState();

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

        if(workareasManager.activityExists(source)){
            var nms = workareasManager.getWorkAreaNames(source);

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

            workareasManager.removeActivity(cod);

            instanceOfWorkAreasList.removeActivity(cod);
            allWorkareas.updateShowActivities();
        }

    }

    function stopActivity(cod){

        if(cod=== sessionParameters.currentActivity){
            var nId = getFirstRunningIdAfter(cod);

            var nextDesk = sessionParameters.currentDesktop;

            activityManager.setCurrentActivityAndDesktop(nId,nextDesk);
        }

        activityManager.stop(cod);

    }


    function updateWallpaper(cod){
        var pt = activityManager.getWallpaper(cod);

        if (pt !== "")
            instanceOfWorkAreasList.setWallpaper(cod,pt);
    }

    function updateWallpaperSlot(cod,pt){
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
            activityManager.setCurrent(nId);
    }

    function slotSetCurrentPreviousActivity(){
        var nId = getFirstRunningIdBefore(sessionParameters.currentActivity);

        if(nId !== "")
            activityManager.setCurrent(nId);
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
        activityManager.cloneActivity(cod);
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
        activityManager.add(i18n("New Activity"));
    }



}
