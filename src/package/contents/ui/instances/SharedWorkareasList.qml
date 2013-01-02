// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import ".."
import "../models"

Item{

    //  property variant model: WorkAreasCompleteModel{}
    property variant model: activitiesModelNew

    //instanceOfWorkAreasList.model.workareas(code)

    property int addednew:0

    property string activitysNewWorkAreaName:""


    function setWorkareaTitle(actCode, desktop, title){
        workareasManager.renameWorkarea(actCode,desktop,title);
    }


    function getActivitySize(cod){
        return model.workareas(cod).count;
    }



    function removeWorkArea(actCode,desktop)
    {
        workareasManager.removeWorkarea(actCode,desktop);

        //Not in cloning
        //if((instanceOfActivitiesList.fromCloneActivity === "") &&
        //       (instanceOfActivitiesList.toCloneActivity === "")){
        if((workareasManager.maxWorkareas < sessionParameters.numberOfDesktops) &&
           (sessionParameters.numberOfDesktops > 2))
            taskManager.slotRemoveDesktop();
    }

    function addWorkareaWithName(actCode, val){

        var workMod = model.workareas(actCode);

        var counts = workMod.count;

        console.log(actCode+" - "+ counts + " - "+sessionParameters.numberOfDesktops);

        workareasManager.addWorkArea(actCode,val);
        //Not in cloning
        //This is used to trace a VDs name which is in greater length
        //than the current VDs count
        if(counts === sessionParameters.numberOfDesktops){
            activitysNewWorkAreaName = actCode;
            taskManager.slotAddDesktop();
        }
    }

    function addWorkarea(actCode){
        var workMod = model.workareas(actCode);

        var counts = workMod.count;
        var ndesk = taskManager.getDesktopName(counts+1);

        addWorkareaWithName(actCode,ndesk);

    }

}
