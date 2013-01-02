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

    function getIndexFor(cod){
        for(var i=0; i<model.count; ++i){
            var obj = model.get(i);
            if (obj.code === cod)
                return i;
        }
        return -1;
    }

    function getWorkareaName(cod,desk){
        var workMod = model.workareas(cod);
        if(desk <= workMod.count)
            return workMod.get(desk-1).title;

        return "";
    }

    function getActivitySize(cod){
        return model.workareas(cod).count;
    }

//    function copyWorkareas(from, to){
  //          workareasManager.cloneWorkareas(from,to);
   // }


    function removeWorkArea(actCode,desktop)
    {
        workareasManager.removeWorkarea(actCode,desktop);

        //Not in cloning
        //if((instanceOfActivitiesList.fromCloneActivity === "") &&
        //       (instanceOfActivitiesList.toCloneActivity === "")){
        if((maxWorkareas() < sessionParameters.numberOfDesktops) &&
           (sessionParameters.numberOfDesktops > 2))
            taskManager.slotRemoveDesktop();
    }

    function maxWorkareas()
    {
        var max = 0;
        for (var i=0; i<model.count; i++)
        {
            var workMod = model.get(i);
            var actId = model.get(i).code;
            if (model.workareas(actId).count>max)
                max = model.workareas(actId).count;
        }

        return max;
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
/*
    function cloneActivity(cod,ncod){
        var ind = getIndexFor(cod);
        if(ind>-1){
            var ob = model.get(ind);

            model.insert(ind+1, {"code": ncod,
                             "CState":"Running",
                             "background":ob.background,
                             "workareas":[{"title":"New Workarea"}]
                         }
                         );
        }

    }*/


    function addNewActivity(cod){
        var ind = getIndexFor(cod);

        if(ind>-1)
            model.setProperty(ind,"background",getNextDefWallpaper());

        workareasManager.addEmptyActivity(cod);
    }

    function addWorkareaOnLoading(actCode, title){

        var workMod = model.workareas(actCode);

        if(workMod.count === sessionParameters.numberOfDesktops)
            taskManager.slotAddDesktop();

        workareasManager.addWorkareaInLoading(actCode, title);

    }

    function addActivityOnLoading(cod){
        var names = workareasManager.getWorkAreaNames(cod);

        var ind = getIndexFor(cod);

        if(ind>-1)
            model.setProperty(ind,"background",getNextDefWallpaper());


        for(var j=0; j<names.length; j++)
            addWorkareaOnLoading(cod,names[j]);
    }

    function getNextDefWallpaper(){
        var newwall;
        if (addednew % 4 === 0)
            newwall = "../../Images/backgrounds/emptydesk1.png";
        else if (addednew % 4 === 1)
            newwall = "../../Images/backgrounds/emptydesk2.png";
        else if (addednew % 4 === 2)
            newwall = "../../Images/backgrounds/emptydesk3.png";
        else if (addednew % 4 === 3)
            newwall = "../../Images/backgrounds/emptydesk4.png";

        addednew++;

        return newwall;
    }


}
