// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import org.kde.qtextracomponents 0.1

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
            plasmoid.popupIcon = QIcon(sessionParameters.currentActivityIcon);
        }
    }
}
