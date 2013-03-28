import QtQuick 1.1

import org.kde.workflow.components 0.1 as WorkFlowComponents
import org.kde.plasma.core 0.1 as PlasmaCore

//import "../delegates"
//import "../delegates/ui-elements"
//import "../helptour"
//import "connections"
import ".."

import "../../code/settings.js" as Settings

Item{

    WorkFlowComponents.WorkflowManager {
        id: workflowManager
    }

    //This a temporary solution to fix the issue with filtering windows
    //in empty fitter text in many cases windows are not shown correctly
    //so i reset the filter text to something not found and then again
    //to show all windows
    Connections{
        target:filterWindows
        onTextChanged:{
            //   console.log(filterWindows.text);
            if(filterWindows.text === ""){
                filteredTasksModel.fixBugString = "'''";
                timerBug.start();
            }
        }
    }

    Timer {
        id:timerBug
        interval: 50; running: false; repeat: false
        onTriggered: filteredTasksModel.fixBugString = "";
    }

    ///end fix of bug

    PlasmaCore.SortFilterModel {
        id:filteredTasksModel
        filterRole: "name"
        filterRegExp:".*" + mergedString + ".*"
        sourceModel: taskManager.model()

        //for fix of bug
        property string mergedString: filterWindows.text.toLowerCase() + fixBugString
        property string fixBugString: ""
        //end of fix
    }

    PlasmaCore.SortFilterModel {
        id:stoppedActivitiesModel
        filterRole: "CState"
        filterRegExp: "Stopped"
        sourceModel: workflowManager.model()
    }

    PlasmaCore.SortFilterModel {
        id:runningActivitiesModel
        filterRole: "CState"
        filterRegExp: "Running"
        sourceModel: workflowManager.model()
    }

    Item{
        id:centralArea
        anchors.fill: parent

        property string typeId: "centralArea"

        WorkAreasAllLists{
            id: allWorkareas
            z:4

            /* Should use anchors, but they seem to break the flickable area */
            //anchors.top: oxygenT.bottom
            //anchors.bottom: mainView.bottom
            //anchors.left: mainView.left
            //anchors.right: mainView.right
            y:oxygenT.height
            width:(mAddActivityBtn.showRedCross) ? mainView.width-mAddActivityBtn.width : mainView.width
            height:mainView.height - y
            verticalScrollBarLocation: stoppedPanel.x
            clip:true

            workareaWidth: mainView.workareaWidth
            workareaHeight: mainView.workareaHeight
            scale: mainView.scaleMeter
            animationsStep: Settings.global.animationStep
        }

        StoppedActivitiesPanel{
            id:stoppedPanel
            z:6
        }

        MainAddActivityButton{
            id: mAddActivityBtn
            z:7
        }

        //Create a consistent look underTitleMainView
        Rectangle {
            id: actImagBackTitle
            width: oxygenT.width
            height: oxygenT.height
            color: "#646464"
            anchors.top:oxygenT.top
        }

        TitleMainView{
            id:oxygenT
            z:8
        }

        AllActivitiesTasks{
            id:allActT
            z:7
        }


    }
}
