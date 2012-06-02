// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import ".."
import "../models"

ListView{
    model: ActivitiesModel1{}

    property int newActivityCounter:0

    function setCState(cod, val){
        var ind = getIndexFor(cod);
        model.setProperty(ind,"CState",val);

        instanceOfWorkAreasList.setCState(cod,val);

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
            if (obj.code === cod)
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
                         "CState":"Running"} );


        instanceOfWorkAreasList.addNewActivity(nId);
        allWorkareas.updateShowActivities();
    }

    function getNextId(){
        newActivityCounter++;
        return "dY"+newActivityCounter;

    }

}
