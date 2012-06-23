// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.qtextracomponents 0.1

import ".."
import "../models"

ListView{

    model: ActivitiesModel1{}

    property int newActivityCounter:0

    property int vbYes:3

    //variable to use in asychronous change an activity,
    //first go to an activity and then change desktop
    property int goToDesktop:-1


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
        model.setProperty(ind,"CState",val);

        instanceOfWorkAreasList.setCState(cod,val);


        allWorkareas.updateShowActivities();
        stoppedPanel.changedChildState();
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

        instanceOfWorkAreasList.addNewActivityF(source, stat, cur);

        if (cur)
            mainView.currentActivity = source;

        for(var j=0; j<3; ++j){
            instanceOfWorkAreasList.addWorkarea(source);
        }

        setCState(source,stat);

        // updateWallpaper(source,1000);
        // var pt = activityManager.getWallpaper(source);
        //      instanceOfWorkAreasList.setWallpaper(source,pt);
        updateWallpaper(source);
    }

    function setIcon(cod){
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

            if(goToDesktop > -1){
                instanceOfTasksList.setCurrentDesktop(goToDesktop);
                goToDesktop = -1;
            }
        }

    }

    function activityRemovedIn(cod){
        var p = getIndexFor(cod);
        if (p>-1){            

            //Be careful there is probably a bug in removing the first element in ListModel, crashed KDE
            model.remove(p);

            instanceOfWorkAreasList.removeActivity(cod);
            allWorkareas.updateShowActivities();
        }

    }


    function stopActivity(cod){

        activityManager.stop(cod);

        setCState(cod,"Stopped");
        instanceOfWorkAreasList.setCState(cod,"Stopped");
    }

    Timer {
        id:wallPapTimer
        property string cd
        interval: 750; running: false; repeat: false
        onTriggered: {
            updateWallpaper(cd);
        }
    }

    function updateWallpaper(cod){
        var pt = activityManager.getWallpaper(cod);
        if (pt !== "")
            instanceOfWorkAreasList.setWallpaper(cod,pt);
    }

    function updateWallpaperInt(cod,inter){
        wallPapTimer.cd = cod;
        wallPapTimer.interval = inter;
        wallPapTimer.start();
    }

    function startActivity(cod){

        activityManager.start(cod);

        setCState(cod,"Running");
        instanceOfWorkAreasList.setCState(cod,"Running");

        updateWallpaperInt(cod,1000);

        //        var pt = activityManager.getWallpaper(cod);
        //       instanceOfWorkAreasList.setWallpaper(cod,pt);
    }

    function setName(cod,title){
        activityManager.setName(cod,title);

        //   var ind = getIndexFor(cod);
        //  model.setProperty(ind,"Name",title);
    }

    function getCState(cod){
        var ind = getIndexFor(cod);

        if(ind>-1)
            return model.get(ind).CState;
        else
            return "";
    }

    function setCurrent(cod){
        activityManager.setCurrent(cod);

        instanceOfWorkAreasList.setCurrent(cod);
    }

    function setCurrentActivityAndDesktop(activit, desk)
    {
        if (activit !== mainView.currentActivity)
        {
            goToDesktop = desk;
            setCurrent(activit);
        }
        else
        {
            instanceOfTasksList.setCurrentDesktop(desk);
        }
    }

    function getIndexFor(cod){
        for(var i=0; i<model.count; ++i){
            var obj = model.get(i);
            if (obj.code === cod)
                return i;
        }

        return -1;
    }

    function cloneActivity(cod){

        var p = getIndexFor(cod);
        var ob = model.get(p);

        activityManager.clone(cod,"New Activity",ob.Icon);


        var nId = getNextId();

        model.insert(p+1,
                     {"code": nId,
                         "Current":false,
                         "Name":"New Activity",
                         "Icon":ob.Icon,
                         "CState":"Running"}
                     );
        instanceOfWorkAreasList.cloneActivity(cod,nId);

        allWorkareas.updateShowActivities();
    }

    function removeActivity(cod){
        var p = getIndexFor(cod);
        var ob = model.get(p);

        removeDialog.activityName = ob.Name;
        removeDialog.activityCode = cod;
        removeDialog.open();
    }


    function addNewActivity(){
        var nId = getNextId();
        var res = activityManager.add("---","New Activity");
    }

    function getNextId(){
        newActivityCounter++;
        return "dY"+newActivityCounter;
    }

}
