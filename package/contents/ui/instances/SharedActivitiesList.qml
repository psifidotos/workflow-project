// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import org.kde.plasma.core 0.1 as PlasmaCore

import ".."
import "../models"

ListView{

    PlasmaCore.DataSource {
        id: activitySource
        engine: "org.kde.activities"
        onSourceAdded: {
            if (source != "Status") {
                connectSource(source)
            }
        }

        Component.onCompleted: {
            connectedSources = sources.filter(function(val) {
                return val !== "Status";
            })

            createWorkAreasModel();
        }
    }

    //model: ActivitiesModel1{}

    model: PlasmaCore.DataModel {
      dataSource: activitySource
  //	keyRoleFilter: ".*"
    }

    property int newActivityCounter:0
/*
    function setCState(cod, val){
        var ind = getIndexFor(cod);
        model.setProperty(ind,"cState",val);

        instanceOfWorkAreasList.setCState(cod,val);

    }*/

    function stopActivity(cod){
        /*var activityId = cod;
        var service = activitySource.serviceForSource(activityId);
        var operation = service.operationDescription("stop");
        service.startOperationCall(operation);

        allWorkareas.updateShowActivities();*/
        activityManager.stop(cod);
        instanceOfWorkAreasList.setCState(cod,"Stopped");
    }


    function createWorkAreasModel(){
        for(var i=0; i<model.count; ++i){
            var obj = model.get(i);

            instanceOfWorkAreasList.addNewActivity(obj.DataEngineSource,obj.State,obj.Current);

            for(var j=0; j<3; ++j){
                instanceOfWorkAreasList.addWorkarea(obj.DataEngineSource);
            }

//            if (obj.DataEngineSource === cod)
//                return i;
        }

        allWorkareas.updateShowActivities();
    }

    function startActivity(cod){
        /*var activityId = cod;
        var service = activitySource.serviceForSource(activityId);
        var operation = service.operationDescription("start");
        service.startOperationCall(operation);

        allWorkareas.updateShowActivities();*/
        activityManager.start(cod);
        instanceOfWorkAreasList.setCState(cod,"Running");
    }

    function setName(cod,title){
        activityManager.setName(cod,title);
    }
/*
    function getCState(cod){
        var ind = getIndexFor(cod);

        return model.get(ind).CState;
    }*/

    function setCurrent(cod){

        activityManager.setCurrent(cod);
/*
        for(var i=0; i<model.count; ++i){
            model.setProperty(i,"Current",false);
        }

        var ind = getIndexFor(cod);
        model.setProperty(ind,"Current",true);
*/
        instanceOfWorkAreasList.setCurrent(cod);

    }

    function getIndexFor(cod){
        for(var i=0; i<model.count; ++i){
            var obj = model.get(i);
            if (obj.DataEngineSource === cod)
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

/*
        model.append( {  "code": nId,
                         "Current":false,
                         "Name":"New Activity",
                         "Icon":"Images/icons/plasma.png",
                         "cState":"Running"} );

        instanceOfWorkAreasList.addNewActivity(nId);*/
        allWorkareas.updateShowActivities();
    }

    function getNextId(){
        newActivityCounter++;
        return "dY"+newActivityCounter;

    }

}