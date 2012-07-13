// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.qtextracomponents 0.1


import "delegates"
import "instances"

import "ui"

import "DynamicAnimations.js" as DynamAnim

Rectangle {
    id:mainView
    objectName: "instMainView"


    color: "#dcdcdc"

    //  z:0
    clip:true
    anchors.fill: parent

    property int scaleMeter:zoomSlider.value

    property real zoomingHeightFactor: ((zoomSlider.value-zoomSlider.minimum)/(zoomSlider.maximum-zoomSlider.minimum))*0.6
    property int workareaHeight:(3.6 - zoomingHeightFactor)*scaleMeter
    property int workareaY:2*scaleMeter

    property int workareaWidth: 70+(2.8*mainView.scaleMeter) + (mainView.scaleMeter-5)/3;

    property bool showWinds: true
    property bool lockActivities: false

    onShowWindsChanged: workflowManager.setShowWindows(showWinds);
    onLockActivitiesChanged: workflowManager.setLockActivities(lockActivities);

    signal minimumWidthChanged;
    signal minimumHeightChanged;

    property string currentActivity
    property int currentDesktop
    property int maxDesktops
    property bool isOnDashBoard:true //development purposes,must be changed to false in the official release

    property bool enablePreviews:false

    Behavior on scaleMeter{
        NumberAnimation {
            duration: 100;
            easing.type: Easing.InOutQuad;
        }
    }

    SharedActivitiesList{
        id:instanceOfActivitiesList
        objectName: "instActivitiesEngine"
    }

    SharedWorkareasList{
        id:instanceOfWorkAreasList
    }

    SharedTasksList{
        id:instanceOfTasksList
        objectName: "instTasksEngine"
    }

    Item{
        id:centralArea
        x: 0
        y:0
        width:mainView.width
        height:mainView.height

        property string typeId: "centralArea"
        BorderImage {
            id:selectionImage
            source: "Images/buttons/selectedBlue.png"

            // property int tempMeter: mainView.scaleMeter/5;

            border.left: 50; border.top: 50;
            border.right: 60; border.bottom: 50;
            horizontalTileMode: BorderImage.Repeat
            verticalTileMode: BorderImage.Repeat

            z:5

            opacity:0

            Behavior on opacity{
                NumberAnimation {
                    duration: 500;
                    easing.type: Easing.InOutQuad;
                }
            }

            function setLocation(x1,y1,w1,h1){
                x= x1-25;
                y= y1-25;
                width=w1+55;
                height=h1+50;
            }
        }


        WorkAreasAllLists{
            id: allWorkareas
            z:4
        }


        StoppedActivitiesPanel{
            id:stoppedPanel
            z:4
        }


        MainAddActivityButton{
            id: mAddActivityBtn
            z:7
        }

        TitleMainView{
            id:oxygenT
            z:8
        }


        AllActivitiesTasks{
            id:allActT
            z:7
        }


        Slider {
            id:zoomSlider
            y:mainView.height - height - 5
            x:stoppedPanel.x - width - 5
            maximum: 65
            minimum: 32
            value:50
            width:125
            z:10

            onValueChanged: workflowManager.setZoomFactor(value);

            Image{
                x:-0.4*width
                y:-0.3*height
                width:30
                height:1.5*width
                source:"Images/buttons/magnifyingglass.png"
            }

        }
/*
        PlasmaComponents.Slider {
            id:zoomSlider
            y:mainView.height - height - 5
            x:stoppedPanel.x - width - 5
            maximumValue: 65
            minimumValue: 32
            value:50
            width:125
            z:10
            enabled:true

            onValueChanged: workflowManager.setZoomFactor(value);

        //    property bool updateValueWhileDragging:true
        //    property real handleSize:20

            Image{
                x:-0.4*width
                y:-0.2*height
                width:30
                height:1.5*width
                source:"Images/buttons/magnifyingglass.png"
            }

        }*/

        WorkAreaFull{
            id:wkFull
            z:11
        }

    }

    DraggingInterface{
        id:mDragInt
    }


    Component.onCompleted:{
        DynamAnim.createComponents();
    }

    function getDynLib(){
        return DynamAnim;
    }
    /*-------------------Loading values-------------------*/
    function setShowWindows(v){
        mainView.showWinds = v;
  //      console.debug("ShowW:"+v);
    }
    function setLockActivities(v){
        mainView.lockActivities = v;
   //     console.debug("LockA:"+ v);
    }
    function setZoomSlider(v){
        zoomSlider.value = v;
    //    console.debug("Zoom:"+v);
    }

    function setAnimations(v){
        //
    }

    function setIsOnDashboard(v){
       // should be enabled in the official release...
        mainView.isOnDashBoard = v;
    }

/*
    Rectangle {
        width: 20; height: 20; z:75; x:0; y:0
        color:"#ffffff"
        visible: mainView.isOnDashBoard

        MouseArea {
            anchors.fill: parent;
            onClicked: {
                mainView.enablePreviews = !mainView.enablePreviews

                if(mainView.enablePreviews === true){
              //      var mId = instanceOfTasksList.getIndexForWorkflowWindow();
                  //  console.debug(mId);
                //    taskManager.setMainWindowId(mId);
                    taskManager.showWindowsPreviews();
                }
            }
        }
    }

    Rectangle{
        id:testerRec
        color:"blue"
        width:10
        height:10
    }


    onMinimumWidthChanged:{
        if(mainView.minimumWidth>mainView.width)
            mainView.width = mainView.minimumWidth
    }

    onMinimumHeightChanged:{
        if(mainView.minimumHeight>mainView.height)
            mainView.height = mainView.minimumHeight
    }*/

    /*--------------------Dialogs ---------------- */
    BorderImage {
        id:removeDialog
        source: "Images/buttons/selectedGrey.png"

        // property int tempMeter: mainView.scaleMeter/5;

        border.left: 70; border.top: 70;
        border.right: 80; border.bottom: 70;
        horizontalTileMode: BorderImage.Repeat
        verticalTileMode: BorderImage.Repeat

        visible:false

        anchors.centerIn: mainView

        property string activityCode
        property string activityName

        width:dialogInsideRect.width+105
        height:dialogInsideRect.height+105

        Rectangle{
            id:dialogInsideRect
            //     visualParent:mainView


           // x:65
        //    y:60
            anchors.centerIn: parent

            property real defOpacity:0.5

            color:"#d5333333"
            border.color: "#aaaaaa"
            border.width: 2
            radius:15

            width:mainTextInf.width+100
            height:infIcon.height+90

            //Title
            Text{
                id:titleMesg
                color:"#ffffff"
                text: i18n("Remove Activity")+"..."
                width:parent.width
                horizontalAlignment:Text.AlignHCenter
                anchors.top:parent.top
                anchors.topMargin: 5
            }

            Rectangle{
                anchors.top:titleMesg.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                width:0.93*parent.width
                color:"#ffffff"
                opacity:0.3
                height:1
                /*                gradient: Gradient {
                GradientStop {position: 0; color: "#00ffffff"}
                GradientStop {position: 0.5; color: "#ffffffff"}
                GradientStop {position: 1; color: "#00ffffff"}
            }*/
            }

            //Main Area
            QIconItem{
                id:infIcon
                anchors.top:titleMesg.bottom
                anchors.topMargin:10
                icon:QIcon("messagebox_info")
                width:70
                height:70
            }
            Text{
                id:mainTextInf
                anchors.left: infIcon.right
                anchors.verticalCenter: infIcon.verticalCenter
                color:"#ffffff"
                text:"Are you sure you want to remove activity <b>"+removeDialog.activityName+"</b> ?"
            }

            //Buttons

            Item{
                anchors.top: infIcon.bottom
                anchors.topMargin:10
                anchors.right: parent.right
                anchors.rightMargin: 10
                height:30
                width:parent.width
                PlasmaComponents.Button{
                    id:button1
                    anchors.right: button2.left
                    anchors.rightMargin: 10
                    anchors.bottom: parent.bottom
                    width:100
                    text:i18n("Yes")
                    iconSource:"dialog-apply"

                    onClicked:{
                        activityManager.remove(removeDialog.activityCode);
                        instanceOfActivitiesList.activityRemovedIn(removeDialog.activityCode);
                        removeDialog.close();
                    }
                }
                PlasmaComponents.Button{
                    id:button2
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    width:100
                    text:i18n("No")
                    iconSource:"editdelete"

                    onClicked:{
                        removeDialog.close();
                    }
                }
            }


        }
        function open(){
            removeDialog.visible = true;
        }
        function close(){
            removeDialog.visible = false;
        }
    }
}




