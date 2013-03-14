// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import org.kde.qtextracomponents 0.1

import "../../code/settings.js" as Settings
Item{
    //All the qml plugins Connections especially between
    //the PlasmoidWrapper and the plugins

    ActivityManagerConnections{}
    WorkareaManagerConnections{}
    TaskManagerConnections{}
    PreviewManagerConnections{}
    PlasmoidWrapperConnections{}

    Connections{
        target: sessionParameters

        onCurrentActivityIconChanged:{
            if(Settings.global.disableCompactRepresentation){
                if(Settings.global.useCurrentActivityIcon)
                    plasmoid.popupIcon = QIcon(sessionParameters.currentActivityIcon);
                else
                    plasmoid.popupIcon = QIcon("preferences-activities");
            }
        }
    }
}
