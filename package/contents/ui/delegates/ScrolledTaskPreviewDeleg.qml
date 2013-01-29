// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1


Item{
    id: container

    property alias dialogType: task.dialogType
    property alias showOnlyAllActivities: task.showOnlyAllActivities

    property alias rWidth: task.rWidth
    property alias rHeight: task.rHeight
    property alias defWidth: task.defWidth

    property alias defPreviewWidth : task.defPreviewWidth
    property alias defHovPreviewWidth : task.defHovPreviewWidth

    property alias taskTitleTextDef: task.taskTitleTextDef
    property alias taskTitleTextHov: task.taskTitleTextHov

    property alias scrollingView: task.scrollingView
    property alias centralListView: task.centralListView

    width: task.width
    height: task.height

    TaskPreviewDeleg{
        id:task

        ccode: code
        cActCode: ((activities === undefined) || (activities[0] === undefined) ) ?
                        sessionParameters.currentActivity : activities[0]
        cDesktop:desktop === undefined ? sessionParameters.currentDesktop : desktop
    }


}

