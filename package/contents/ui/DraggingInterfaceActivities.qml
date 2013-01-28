// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.qtextracomponents 0.1
import "../code/settings.js" as Settings

Rectangle{
    id:container
    anchors.fill: mainView
    color:"#05000000"
    opacity:0
    z:-1

    property string activityId: ""
    property string activityStatus: ""

    property int intX1
    property int intY1


    property string drActiv: ""
    property int drDesktop: -1

    //0 - over a Workarea
    //1 - over an AddWorkarea button
    //2 - over everywhere tasks
    property int lastSelection

    property bool firsttime:true

    QIconItem{
        id:iconImg
        width:mainView.scaleMeter
        height:width
        opacity:0.8
        smooth:true
    }

    //Testing Purposes
    Rectangle{
        id:testRec
        x:150
        y:320
        width:10
        height:width
        color:"blue"

        visible:false
    }

    function enableDragging(mouse,coords, activity, status, icon){
        allWorkareas.flickableV = false;
        stoppedPanel.flickableV = false;

        container.opacity = 1;
        container.z = 100;

        iconImg.icon = icon;
        iconImg.enabled = true;

        container.activityId = activity;
        container.activityStatus = status;

        container.intX1 = coords.x;
        container.intY1 = coords.y;

        container.lastSelection = -1;

        container.firsttime = true;

        iconImg.x = coords.x + 1;
        iconImg.y = coords.y + 1;
//        onPstChanged(ms);
    }

    function disableDragging(){
        container.activityId = "";
        container.activityStatus = "";

        container.opacity = 0;
        container.enabled = false;
        container.z = -1;
        allWorkareas.flickableV = true;
        stoppedPanel.flickableV = true;


        container.lastSelection = -1;

        //It creates a confusion when releasing
        //must be fixed with a flag initialiazing properly
        //    mainDraggingItem.drActiv = "";
        //    mainDraggingItem.drDesktop = -1;
    }

    function onMReleased(mouse, viewXY){
        var iX1 = iconImg.x;
        var iY1 = iconImg.y;

        disableDragging();
    }

    function onPstChanged(mouse){

        iconImg.x = mouse.x + 1;
        iconImg.y = mouse.y + 1;


    }


}

