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
        }
    }

    //model: ActivitiesModel1{}

    model: PlasmaCore.DataModel {
      dataSource: activitySource
  //	keyRoleFilter: ".*"
    }

    property int newActivityCounter:0

    function setCState(cod, val){
        var ind = getIndexFor(cod);
        model.setProperty(ind,"cState",val);

        instanceOfWorkAreasList.setCState(cod,val);

    }

    function stopActivity(cod){
        var activityId = cod;
        var service = activitySource.serviceForSource(activityId);
        var operation = service.operationDescription("stop");
        service.startOperationCall(operation);

        allWorkareas.updateShowActivities();
    }

    function startActivity(cod){
        var activityId = cod;
        var service = activitySource.serviceForSource(activityId);
        var operation = service.operationDescription("start");
        service.startOperationCall(operation);

        allWorkareas.updateShowActivities();
    }

    function getCState(cod){
        var ind = getIndexFor(cod);

        return model.get(ind).CState;
    }

    function setCurrent(cod){

        for(var i=0; i<model.count; ++i){
            model.setProperty(i,"Current",false);
        }

        var ind = getIndexFor(cod);
        model.setProperty(ind,"Current",true);

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
        var n = getIndexFor(cod);
        model.remove(n);
        instanceOfWorkAreasList.removeActivity(cod);
        allWorkareas.updateShowActivities();
    }

    function addNewActivity(){
        var nId = getNextId();

        model.append( {  "code": nId,
                         "Current":false,
                         "Name":"New Activity",
                         "Icon":"Images/icons/plasma.png",
                         "cState":"Running"} );


        instanceOfWorkAreasList.addNewActivity(nId);
        allWorkareas.updateShowActivities();
    }

    function getNextId(){
        newActivityCounter++;
        return "dY"+newActivityCounter;

    }

}
