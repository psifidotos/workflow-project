// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import "../models"
//import org.kde.plasma.core 0.1 as PlasmaCore

Item{
    id:sharedTasksListTempl

    property variant model: TasksList{}

    signal tasksChanged();

    function printModel(){
        console.debug("---- Tasks Model -----");
        for(var i=0; i<model.count; i++){
            var obj = model.get(i);
            console.debug(obj.code + " - " + obj.name + " - " +obj.Icon + " - " +obj.desktop + " - " +obj.activities);
        }
        console.debug("----  -----");
    }

    function setTaskState(cod, val){
        var ind = getIndexFor(cod);
        if(ind>-1){
            var obj = model.get(ind);

            var fActivity;

            if ((obj.activities === undefined)||
                    (obj.activities === ""))
                fActivity = sessionParameters.currentActivity;
            else
                fActivity = obj.activities;

            console.debug("setTaskState:"+cod+"-"+val);

            if (val === "oneDesktop"){
                //   if (obj.onAllDesktops !== false )


                if(obj.activities !== fActivity)
                    setTaskActivity(obj.code,fActivity);

                if (obj.onAllDesktops !== false)
                    taskManager.setOnAllDesktops(obj.code,false);
            }
            else if (val === "allDesktops"){
                taskManager.setOnlyOnActivity(obj.code,fActivity);

                taskManager.setOnAllDesktops(obj.code,true);
            }
            else if (val === "allActivities"){
                taskManager.setOnAllDesktops(obj.code,true);
                taskManager.setOnAllActivities(obj.code);

                instanceOfTasksDesktopList.removeTask(cod);
            }

            sharedTasksListTempl.tasksChanged();
        }
    }

    function setTaskActivity(cod, val){
        taskManager.setOnlyOnActivity(cod,val);
    }

    function setTaskActivityForAnimation(cod,val){
        var ind = getIndexFor(cod);
        if(ind>-1){
            var obj = model.get(ind);
                model.setProperty(ind,"activities",val);
                taskManager.setOnlyOnActivity(cod,val);

        }
    }


    function setTaskDesktop(cod, val){
        var ind = getIndexFor(cod);
        if(ind>-1){
            var obj = model.get(ind);
            taskManager.setOnDesktop(obj.code,val);
        }
    }

    function setTaskDesktopForAnimation(cod, val){
        var ind = getIndexFor(cod);
        if(ind>-1){
            var obj = model.get(ind);
                model.setProperty(ind,"desktop",val);
                taskManager.setOnDesktop(obj.code,val);
        }
    }

    function getIndexForWorkflowWindow(){
        for(var i=0; i<model.count; i++){
            var obj = model.get(i);
            if (obj.name === "Workflow")
                return obj.code;
        }
        return -1;
    }

    function getIndexFor(cod){
        for(var i=0; i<model.count; i++){
            var obj = model.get(i);
            if (obj.code === cod)
                return i;
        }
        return -1;
    }

    function getTasksIcon(cod){
        var ind = getIndexFor(cod);

        if( ind>-1 ){
            var obj = model.get(ind);
            return obj.Icon;
        }

    }


    function taskAddedIn(source,onalld,onalla,classc,nam, icn, desk, activit)
    {
        var fact;
        if (activit === undefined)
            fact=sessionParameters.currentActivity;
        else
            fact=activit[0];

        model.append( {  "code": source,
                         "onAllDesktops":onalld,
                         "onAllActivities":onalla,
                         "classClass":classc,
                         "name":nam,
                         "Icon":icn,
                         "desktop":desk,
                         "activities":fact} );

        if(onalla === true){
            taskManager.setOnAllDesktops(source,true);
        }

        sharedTasksListTempl.tasksChanged();
    }

    function taskRemovedIn(cod){
        var ind = getIndexFor(cod);
        if (ind>-1){
            //    printModel();
            model.remove(ind);  //Be Careful there is a bug when removing the first element (0), it crashed KDE
            instanceOfTasksDesktopList.removeTask(cod);
            sharedTasksListTempl.tasksChanged();
        }
    }

    function taskUpdatedIn(source,onalld,onalla,classc,nam, icn, desk, activit,mtype)
    {
        var fact;
        if (activit === undefined)
            fact="";
        else
            fact=activit[0];

        var ind = getIndexFor(source);

        if (ind>-1){

            model.setProperty(ind,"onAllDesktops",onalld);
            model.setProperty(ind,"onAllActivities",onalla);
            model.setProperty(ind,"classClass",classc);
            model.setProperty(ind,"name",nam);
            model.setProperty(ind,"Icon",icn);
            model.setProperty(ind,"desktop",desk);
            model.setProperty(ind,"activities",fact);

            if(onalla === true)
                if(onalld !== true)
                    taskManager.setOnAllDesktops(source,true);

        }
        sharedTasksListTempl.tasksChanged();
    }


    function removeTask(cod){
        taskManager.closeTask(cod);
    }

    function setCurrentDesktop(desk){
        taskManager.setCurrentDesktop(desk);
    }


    function setMaxDesktops(v){
        //it is called consequently for example to go from 2VDs to 4 VDs, it is going
        //2-3-4 from the relevant signals
        console.log(v + " - "+instanceOfWorkAreasList.maxWorkareas());
        var mxs = instanceOfWorkAreasList.maxWorkareas();
        if (mxs>v)
            taskManager.slotAddDesktop();
        else if(mxs<v)
            taskManager.slotRemoveDesktop();

        //It is used when adding a Workarea in bigger length than the VDs
        if(instanceOfWorkAreasList.activitysNewWorkAreaName !== ""){
            var ndesk = taskManager.getDesktopName(v);
            instanceOfWorkAreasList.setWorkareaTitle(instanceOfWorkAreasList.activitysNewWorkAreaName,v,ndesk);
            instanceOfWorkAreasList.activitysNewWorkAreaName = "";
        }

    }

    function minimizeWindowsIn(actId,desk){
        for(var i=0; i<model.count; i++){
            var obj = model.get(i);
            if( (obj.onAllActivities) ||
                    ((obj.activities === actId)&&(obj.onAllDesktops)) ||
                    ((obj.activities === actId)&&(obj.desktop === desk)) )
                taskManager.minimizeTask(obj.code);
        }
    }

    function setCurrentTask(cod){
        taskManager.activateTask(cod);
    }

    //in order to change to right workarea when a window is inAllDesktops
    function setCurrentTaskInWorkarea(activ,desk,cod)
    {
        //instanceOfActivitiesList.setCurrentActivityAndDesktop(activ,desk);
        activityManager.setCurrentActivityAndDesktop(activ,desk);
        setCurrentTask(cod);
    }


    function setScreenRatio(sc){
        mainView.setScreenRatio(sc);
    }
}
