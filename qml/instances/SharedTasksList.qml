// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import "../models"
import org.kde.plasma.core 0.1 as PlasmaCore

ListView{
    model: TasksList{}


    function setTaskState(cod, val){
        var ind = getIndexFor(cod);
        var obj = model.get(ind);

        if (val === "oneDesktop"){
            taskManager.setOnAllDesktops(obj.code,false);

            model.setProperty(ind,"onAllDesktops",false);
            model.setProperty(ind,"onAllActivities",false);
        }
        else if (val === "allDesktops"){
            taskManager.setOnAllDesktops(obj.code,true);
            model.setProperty(ind,"onAllDesktops",true);
            model.setProperty(ind,"onAllActivities",false);
        }
        else if (val === "allActivities"){
          //  taskManager.setOnAllDesktops(obj.code,true);
            model.setProperty(ind,"onAllDesktops",false);
            model.setProperty(ind,"onAllActivities",true);
        }

        allActT.changedChildState();
    }

    function setTaskActivity(cod, val){
        var ind = getIndexFor(cod);
        model.setProperty(ind,"activities",val);
    }


    function setTaskDesktop(cod, val){
        var ind = getIndexFor(cod);
        var obj = model.get(ind);
        model.setProperty(ind,"desktop",val);

        taskManager.setOnDesktop(obj.code,val);
    }

    function setTaskInDragging(cod, val){
        var ind = getIndexFor(cod);
        model.setProperty(ind,"inDragging",val);
    }


    function getIndexFor(cod){

        for(var i=0; i<model.count; ++i){
            var obj = model.get(i);
            if (obj.code === cod)
               return i;
        }
        return -1;
    }


    function taskAddedIn(source,onalld,onalla,classc,nam, icn, indrag, desk, activit)
    {
        var fact;
        if (activit === undefined)
            fact="";
        else
            fact=activit[0];

        model.append( {  "code": source,
                         "onAllDesktops":onalld,
                         "onAllActivities":onalla,
                         "classClass":classc,
                         "name":nam,
                         "Icon":icn,
                         "inDragging":indrag,
                         "desktop":desk,
                         "activities":fact} );

        allActT.changedChildState();
    }

    function taskRemovedIn(cod){
        var ind = getIndexFor(cod);
        if (ind>-1)
            model.remove(ind);
    }

    function taskUpdatedIn(source,onalld,onalla,classc,nam, icn, desk, activit)
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
        }

        allActT.changedChildState();
    }


    function removeTask(cod){
        taskRemovedIn(cod);
        taskManager.closeTask(cod);
    }

    function setCurrentDesktop(desk){
        taskManager.setCurrentDesktop(desk);
        mainView.currentDesktop = desk;
    }

    function currentDesktopChanged(v){
        mainView.currentDesktop = v;
    }

    function setMaxDesktops(v){
        mainView.maxDesktops = v;
    }

    function setCurrentTask(cod){
        taskManager.activateTask(cod);
        workflowManager.hidePopupDialog();
    }

}
