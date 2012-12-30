// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import ".."
import "../models"

Item{

    property variant model: WorkAreasCompleteModel{}

    property int addednew:0

    property string activitysNewWorkAreaName:""

    property bool inCloning:false

    function setCState(cod, val){
        var ind = getIndexFor(cod);
        if(ind>-1)
            model.setProperty(ind,"CState",val);
    }


    function setWorkareaTitle(actCode, desktop, title){
        var ind = getIndexFor(actCode);
        if(ind>-1){
            var actOb = model.get(ind);
            var workMod = actOb.workareas;

            workMod.setProperty(desktop-1,"title",title);
            workareasManager.renameWorkarea(actCode,desktop,title);
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

    function getWorkareaName(cod,desk){
        var ind=getIndexFor(cod);
        if (ind>-1){
            var workMod = model.get(ind).workareas;
            if(desk <= workMod.count)
             return workMod.get(desk-1).modelData;
           // return workMod.get(desk-1).elemTitle;
        }

        return "";
    }

    function getActivitySize(cod){
        for(var i=0; i<model.count; ++i){
            var obj = model.get(i);
            if (obj.code === cod)
                return obj.workareas.count;
        }

        return -1;
    }

    function copyWorkareas(from, to){

        var p1 = getIndexFor(to);
        var p2 = getIndexFor(from);

        if((p1>-1)&&(p2>-1)){

            inCloning = true;

            var sz1 = model.get(p1).workareas.count;
            //for(var i=0; i<sz1-1; i++)
            //   removeWorkArea(to,1);

            //in order ot stay the computations without
            //issues
            var sz2 = model.get(p2).workareas.count;
            for(var j=0; j<sz2; j++){
                var ob2 = model.get(p2).workareas.get(j);
                addWorkareaWithName(to,ob2.modelData);
                if(j<sz1)
                    removeWorkArea(to,1);
            }

            for(var i=sz2; i<sz1; i++)
                removeWorkArea(to,1);

            inCloning = false;
        }
    }

    function removeActivity(cod){
        var ind = getIndexFor(cod);

        if (ind>-1){
            //Be careful there is probably a bug in removing the first element in ListModel, crashed KDE
            model.remove(ind);
        }

    }

    function removeWorkArea(actCode,desktop)
    {
        var ind = getIndexFor(actCode);
        if(ind>-1){
            var actOb = model.get(ind);
            var workMod = actOb.workareas;

            workMod.remove(desktop-1);

            workareasManager.removeWorkarea(actCode,desktop);


            //Not in cloning
            //if((instanceOfActivitiesList.fromCloneActivity === "") &&
            //       (instanceOfActivitiesList.toCloneActivity === "")){
            if((inCloning === false)&&
                    (maxWorkareas() < sessionParameters.numberOfDesktops) &&
                    (sessionParameters.numberOfDesktops > 2))
                taskManager.slotRemoveDesktop();

        }
    }



    function maxWorkareas()
    {
        var max = 0;
        for (var i=0; i<model.count; i++)
        {
            var workMod = model.get(i);
            if (workMod.workareas.count>max)
                max = workMod.workareas.count;
        }

        return max;
    }

    function addWorkareaWithName(actCode, val){
        var ind = getIndexFor(actCode);
        if(ind>-1){
            var workMod = model.get(ind).workareas;

            var counts = workMod.count;


            //Not in cloning
            //This is used to trace a VDs name which is in greater length
            //than the current VDs count
            if((inCloning === false)&&
                    (counts === sessionParameters.numberOfDesktops)){
                activitysNewWorkAreaName = actCode;
                taskManager.slotAddDesktop();
            }

            console.debug(counts);

            workMod.append({"title": val});

            workareasManager.addWorkArea(actCode,val);
        }

    }

    function addWorkarea(actCode){
        var ind = getIndexFor(actCode);
        if(ind>-1){
            var workMod = model.get(ind).workareas;

            var counts = workMod.count;
            var ndesk = taskManager.getDesktopName(counts+1);

            addWorkareaWithName(actCode,ndesk);
        }
    }



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

    }

    function setWallpaper(cod,path){
        var ind = getIndexFor(cod);
        if(ind>-1)
            model.setProperty(ind,"background",path);
    }

    function addNewActivityF(cod, stat){
        addNewActivity(cod, stat);

        setCState(cod,stat);
    }

    function addNewActivity(cod, stat){

        var deskone = taskManager.getDesktopName(1);

        model.append( {  "code": cod,
                         "CState":stat,
                         "background":getNextDefWallpaper(),
                         "workareas":[{"title":deskone}]
                       }
                     );

        workareasManager.addEmptyActivity(cod);
        workareasManager.addWorkArea(cod,deskone);

    }

    function addWorkareaOnLoading(actCode, title){
        var ind = getIndexFor(actCode);
        if(ind>-1){
            var actOb = model.get(ind);
            var workMod = actOb.workareas;

            var counts = workMod.count;

            if(counts === sessionParameters.numberOfDesktops)
                taskManager.slotAddDesktop();

            var lastobj = workMod.get(counts-1);

            workMod.append({"title": title });
        }
    }

    function addActivityOnLoading(cod, stat){

        var names = workareasManager.getWorkAreaNames(cod);

        model.append( {  "code": cod,
                         "CState":stat,
                         "background":getNextDefWallpaper(),
                         "workareas":[{"title":names[0]}]
                       }
                     );


        for(var j=1; j<names.length; j++)
            addWorkareaOnLoading(cod,names[j]);

        setCState(cod,stat);

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
