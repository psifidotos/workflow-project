// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import ".."
import "../models"

ListView{

    model: WorkAreasCompleteModel{}

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

    function getIndexFor(cod){
        for(var i=0; i<model.count; ++i){
            var obj = model.get(i);
            if (obj.code === cod)
                return i;
        }
        return -1;
    }

    function getActivitySize(cod){
        for(var i=0; i<model.count; ++i){
            var obj = model.get(i);
            if (obj.code === cod)
                return obj.workareas.count;
        }
        return -1;
    }

    function removeActivity(cod){
        var ind = getIndexFor(cod);

        model.remove(ind);
    }

    function addWorkarea(actCode){
        var ind = getIndexFor(actCode);
        var actOb = model.get(ind);
        var workMod = actOb.workareas;

        var counts = workMod.count;
        var lastobj = workMod.get(counts-1);

        workMod.append( {  "elemTitle": "Dynamic",
                           "elemImg":lastobj.elemImg,
                           "elemShowAdd":false,
                           "gridRow":lastobj.gridRow+1,
                           "gridColumn":lastobj.gridColumn,
                           "elemTempOnDragging":false} );

    }

    function cloneActivity(cod,ncod){
        var ind = getIndexFor(cod);
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
