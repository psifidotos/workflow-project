// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import ".."
import "../models"

Item{

    //property variant model: ActivitiesModel1{}
    property variant model: activitiesModelNew

    //is used when cloning an activity to temporary
    //disable previews
    property bool previewsWereEnabled:false

    property bool isAddingNewActivity:false

    function printModel(){
        console.debug("---- Activities Model -----");
        for(var i=0; i<model.count; ++i){
            var obj = model.get(i);
            console.debug(obj.code + " - " + obj.Name + " - " +obj.Icon + " - " +obj.Current + " - " +obj.CState);
        }
        console.debug("----  -----");
    }


    //Cloning Signals for interaction with the interface
    Connections{
        target:activityManager
        onCloningStarted:{
            if(storedParameters.windowsPreviews === true){
                previewsWereEnabled = true;
                storedParameters.windowsPreviews = false;
            }
            else
                previewsWereEnabled = false;

            mainView.getDynLib().showBusyIndicatorDialog();
        }

        onCloningCopyWorkareas:workareasManager.cloneWorkareas(from,to);

        onCloningEnded:{
            mainView.getDynLib().deleteBusyIndicatorDialog();

            if(previewsWereEnabled === true)
                storedParameters.windowsPreviews = true;
            else
                storedParameters.windowsPreviews = false;
        }
    }



    function activityAddedIn(source,title,icon,stat,cur)
    {
        if (stat === "")
            stat = "Running";

        if((!isAddingNewActivity)&&(workareasManager.activityExists(source)))
            instanceOfWorkAreasList.addActivityOnLoading(source);
        else{

            instanceOfWorkAreasList.addNewActivity(source);

            isAddingNewActivity = false;

            for(var j=0; j<sessionParameters.numberOfDesktops; ++j){
                instanceOfWorkAreasList.addWorkarea(source);
            }

            isAddingNewActivity = false;

        }

    }

    function setIcon(cod, val){
        activityManager.setIcon(cod, val);
    }


    function chooseIcon(cod){
        activityManager.chooseIcon(cod);
    }

    function activityRemovedIn(cod){
        var p = getIndexFor(cod);
        if (p>-1){

            //Be careful there is probably a bug in removing the first element in ListModel, crashed KDE
            model.remove(p);

            workareasManager.removeActivity(cod);

            //instanceOfWorkAreasList.removeActivity(cod);
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


    function startActivity(cod){
        activityManager.start(cod);
    }

    function setName(cod,title){
        activityManager.setName(cod,title);
    }


    function getCState(cod){
        var ind = getIndexFor(cod);

        if(ind>-1)
            return model.get(ind).CState;
        else
            return "";
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
        isAddingNewActivity = true;
        activityManager.add(i18n("New Activity"));
    }



}
