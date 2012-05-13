// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import ".."
import "../models"

ListView{

    model: WorkAreasCompleteModel{}

    property int addednew:0

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
        var newwall;
        if (addednew % 4 === 0)
            newwall = "../Images/backgrounds/emptydesk1.png";
        else if (addednew % 4 === 1)
            newwall = "../Images/backgrounds/emptydesk2.png";
        else if (addednew % 4 === 2)
            newwall = "../Images/backgrounds/emptydesk3.png";
        else if (addednew % 4 === 3)
            newwall = "../Images/backgrounds/emptydesk4.png";



        addednew++;

        model.append( {  "code": cod,
                         "CState":"Running",
                         "elemImg":newwall,
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
