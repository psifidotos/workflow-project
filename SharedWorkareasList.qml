// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

ListView{

    model: WorkAreasCompleteModel{}

    function setCState(cod, val){
        var ind = getCurrentIndex(cod);
        model.setProperty(ind,"CState",val);

    }

    function getCurrentIndex(cod){
        for(var i=0; model.count; ++i){
            var obj = model.get(i);
            if (obj.code === cod)
                return i;
        }
        return -1;
    }

    function removeActivity(cod){
        var ind = getCurrentIndex(cod);

        model.remove(ind);
    }

    function cloneActivity(cod,ncod){
        var ind = getCurrentIndex(cod);
        var ob = model.get(ind);

        model.insert(ind+1, {"code": ncod,
                         "CState":"Running",
                         "elemImg":ob.elemImg,
                         "workareas":[{
                                          "gridRow":0,
                                          "gridColumn":0,
                                          "elemTitle":"New Workarea",
                                          "elemShowAdd":false,
                                          "elemTempOnDragging": false
                         }]
                     });

    }

    function addNewActivity(cod){

        model.append( {  "code": cod,
                         "CState":"Running",
                         "elemImg":"Images/backgrounds/background5.jpg",
                         "workareas":[{
                                          "gridRow":0,
                                          "gridColumn":0,
                                          "elemTitle":"New Workarea",
                                          "elemShowAdd":false,
                                          "elemTempOnDragging": false
                         }]
                     });

    }


}
