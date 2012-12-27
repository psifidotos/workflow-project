// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1


import ".."
import "../models"

Item{
    id:stasksDesktopList

    property variant model: TasksDesktopList{}

    function loadDesktop(activ,desk){
        model.clear();

        for(var i=0; i<instanceOfTasksList.model.count; i++){
            var obj = instanceOfTasksList.model.get(i);
            if (obj.activities !== undefined){
                if (obj.activities === activ){
                    if (((obj.desktop === desk) ||
                            (obj.onAllDesktops === true))&&
                            (obj.onAllActivities === false))
                        copyTaskFromMainList(i);
                }
            }

        }

    }

    function copyTaskFromMainList(ind){


        var obj = instanceOfTasksList.model.get(ind);

        model.append( {  "code": obj.code,
                         "onAllDesktops": obj.onAllDesktops,
                         "onAllActivities": obj.onAllActivities,
                         "classClass": obj.classClass,
                         "name": obj.name,
                         "Icon": obj.Icon,
                      //   "inDragging": obj.inDragging,
                         "desktop": obj.desktop,
                         "activities": obj.activities} );

    }

    function emptyList(){
        model.clear();
    }

    function removeTask(cod){
        var ind = getIndexFor(cod);
        if (ind>-1)
            model.remove(ind);

    }

    function getIndexFor(cod){
        for(var i=0; i<model.count; i++){
            var obj = model.get(i);
            if (obj.code === cod)
                return i;
        }
        return -1;
    }
}
