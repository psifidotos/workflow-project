// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import ".."
import "../models"

Item{

    property variant model: WorkAreasCompleteModel{}

    property int addednew:0

    function setCState(cod, val){
        var ind = getIndexFor(cod);
        model.setProperty(ind,"CState",val);
    }

    function setCurrent(cod){
        for(var i=0; i<model.count; ++i){
            model.setProperty(i,"Current",false);
        }

        var ind = getIndexFor(cod);
        model.setProperty(ind,"Current",true);

    }

    function setWorkareaTitle(actCode, desktop, title){
        var ind = getIndexFor(actCode);
        var actOb = model.get(ind);
        var workMod = actOb.workareas;

        workMod.setProperty(desktop-1,"elemTitle",title);
        workflowManager.renameWorkarea(actCode,desktop,title);
    }

    function setCurrentIns(cod,cur){

        var ind = getIndexFor(cod);
        model.setProperty(ind,"Current",cur);

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
            if(desk <= workMod.count);
            return workMod.get(desk-1).elemTitle;
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
            var sz1 = model.get(p1).workareas.count;
            //            for(var i=0; i<sz1-1; i++)
            //                removeWorkArea(to,1);

            var sz2 = model.get(p2).workareas.count;
            for(var j=0; j<sz2; j++){
                var ob2 = model.get(p2).workareas.get(j);
                addWorkareaWithName(to,ob2.elemTitle);
                if(j<sz1)
                    removeWorkArea(to,1);
            }

            for(var i=sz2; i<sz1; i++)
                removeWorkArea(to,1);
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
        var actOb = model.get(ind);
        var workMod = actOb.workareas;

        for (var i=desktop-1; i<workMod.count; i++)
        {
            workMod.setProperty(i ,"gridRow",i);
        }

        workMod.remove(desktop-1);

        workflowManager.removeWorkarea(actCode,desktop);

        if((maxWorkareas() < mainView.maxDesktops) &&
                (mainView.maxDesktops > 2))
            taskManager.slotRemoveDesktop();

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
        var workMod = model.get(ind).workareas;

        var counts = workMod.count;

        if(counts === mainView.maxDesktops)
            taskManager.slotAddDesktop();

        workMod.append( {  "elemTitle": val,
                           "gridRow":counts+1
                       } );

        workflowManager.addWorkArea(actCode,val);

    }

    function addWorkarea(actCode){
        var ind = getIndexFor(actCode);
        var workMod = model.get(ind).workareas;

        var counts = workMod.count;
        var ndesk = taskManager.getDesktopName(counts+1);

        addWorkareaWithName(actCode,ndesk);

        /*        var ind = getIndexFor(actCode);
        var actOb = model.get(ind);
        var workMod = actOb.workareas;

        var counts = workMod.count;

        if(counts === mainView.maxDesktops)
            taskManager.slotAddDesktop();

     //   var lastobj = workMod.get(counts-1);

        var ndesk = taskManager.getDesktopName(counts+1);

        workMod.append( {  "elemTitle": ndesk,
                           "gridRow":counts+1
       //                    "gridRow":lastobj.gridRow+1
                       } );

        workflowManager.addWorkArea(actCode,ndesk);
*/
    }



    function cloneActivity(cod,ncod){
        var ind = getIndexFor(cod);
        var ob = model.get(ind);

        model.insert(ind+1, {"code": ncod,
                         "CState":"Running",
                         "elemImg":ob.elemImg,
                         "workareas":[{
                                 "gridRow":1,
                                 "elemTitle":"New Workarea"
                             }]
                     });

    }

    function setWallpaper(cod,path){
        var ind = getIndexFor(cod);
        model.setProperty(ind,"elemImg",path);
    }

    function addNewActivityF(cod, stat, cur){
        addNewActivity(cod, stat);

        setCState(cod,stat);
    }

    function addNewActivity(cod, stat){

        var deskone = taskManager.getDesktopName(1);

        model.append( {  "code": cod,
                         "CState":stat,
                         "Current":false,
                         "elemImg":getNextDefWallpaper(),
                         "workareas":[{
                                 "gridRow":1,
                                 "elemTitle":deskone
                             }]
                     });

        workflowManager.addEmptyActivity(cod);
        workflowManager.addWorkArea(cod,deskone);

    }

    function addWorkareaOnLoading(actCode, title){
        var ind = getIndexFor(actCode);
        var actOb = model.get(ind);
        var workMod = actOb.workareas;

        var counts = workMod.count;

        if(counts === mainView.maxDesktops)
            taskManager.slotAddDesktop();

        var lastobj = workMod.get(counts-1);

        workMod.append( {  "elemTitle": title,
                           "gridRow":lastobj.gridRow+1
                       } );
    }

    function addActivityOnLoading(cod, stat, cur, names){

        //    var deskone = taskManager.getDesktopName(1);

        model.append( {  "code": cod,
                         "CState":stat,
                         "Current":false,
                         "elemImg":getNextDefWallpaper(),
                         "workareas":[{
                                 "gridRow":1,
                                 "elemTitle":names[0]
                             }]
                     });

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
