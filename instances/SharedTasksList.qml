// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import "../models"

ListView{
    model: TasksList{}

    function setTaskState(cod, val){
        var ind = getCurrentIndex(cod);
    //    console.debug(cod+"-"+ind+"-"+val);
        if (val === "oneDesktop"){
           model.setProperty(ind,"onAllDesktops",false);
           model.setProperty(ind,"onAllActivities",false);
        }
        else if (val === "allDesktops"){
            model.setProperty(ind,"onAllDesktops",true);
            model.setProperty(ind,"onAllActivities",false);
        }
        else if (val === "allActivities"){
            model.setProperty(ind,"onAllDesktops",true);
            model.setProperty(ind,"onAllActivities",true);
        }

        allActT.changedChildState();
    }

    function getCurrentIndex(cod){

        for(var i=0; model.count; ++i){
            var obj = model.get(i);
            if (obj.code === cod)
                return i;
        }

        return -1;
    }

    function removeTask(cod){
        var n = getCurrentIndex(cod);
        model.remove(n);
        //instanceOfTasksList.removeTask(cod);
        //instanceOfWorkAreasList.removeActivity(cod);
        //allWorkareas.updateShowActivities();
    }

}
