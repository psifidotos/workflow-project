// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import org.kde.plasma.core 0.1 as PlasmaCore

import ".."
import "../models"

ListView{

    model: ActivitiesModel1{}

    property int newActivityCounter:0

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

        for(var j=0; j<3; ++j){
            instanceOfWorkAreasList.addWorkarea(source);
        }

        setCState(source,stat);

    }

    function stopActivity(cod){

        activityManager.stop(cod);

        setCState(cod,"Stopped");
        instanceOfWorkAreasList.setCState(cod,"Stopped");
    }


    function startActivity(cod){

        activityManager.start(cod);

        setCState(cod,"Running");
        instanceOfWorkAreasList.setCState(cod,"Running");
    }

    function setName(cod,title){
        activityManager.setName(cod,title);

        var ind = getIndexFor(cod);
        model.setProperty(ind,"Name",title);
    }

    function getCState(cod){
        var ind = getIndexFor(cod);

        return model.get(ind).CState;
    }

    function setCurrent(cod){

        activityManager.setCurrent(cod);

        instanceOfWorkAreasList.setCurrent(cod);

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
        activityManager.remove(cod);

        var n = getIndexFor(cod);
        model.remove(n);

        instanceOfWorkAreasList.removeActivity(cod);
        allWorkareas.updateShowActivities();
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
