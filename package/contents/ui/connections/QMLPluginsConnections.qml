// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item{
    //All the qml plugins Connections especially between
    //the PlasmoidWrapper and the plugins


    //    id:instanceOfActivitiesList
   //     objectName: "instActivitiesEngine"
   // }

    ActivityManagerConnections{}
    WorkareaManagerConnections{}
    TaskManagerConnections{}
    PreviewManagerConnections{}
}
