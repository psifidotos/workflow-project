// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import ".."
import "../delegates"

import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.qtextracomponents 0.1

DialogTemplate{
    id:deskDialog
    anchors.centerIn: mainView

    property string activityCode:""
    property int desktop:-1

    insideWidth: columns*cWidth
    insideHeight: (shownRows)*cHeight

    isModal: true
    showButtons:false

    property int shownRows:0
    property int realRows:0
    property int columns:0

    property int cWidth: 0
    property int cHeight: 0

    property bool disablePreviewsWasForced:false
    property alias disablePreviews:desksTasksList.onlyState1

    Connections{
        target:instanceOfTasksDesktopList
        onSizeWasChanged:{
            deskDialog.initInterface();
        }
    }


    Image{
        id:disablePreviewsBtn
        smooth:true
        source:"../Images/buttons/tools_wizard.png"
        width:15
        height:width
        x:deskDialog.insideX + 20
        y:deskDialog.insideY - 28

        opacity:disablePreviews === true ? 0.5 : 1

        visible: mainView.enablePreviews

        MouseArea{
            anchors.fill: parent
            hoverEnabled: true
            onEntered: {
                hoveredIcon.opacity = 1;
            }

            onExited: {
                hoveredIcon.opacity = 0;
            }
            onClicked: {
                deskDialog.disablePreviews = !deskDialog.disablePreviews

                if (deskDialog.disablePreviews===true)
                    desktopView.forceState1();
                else
                    desktopView.unForceState1();

                initInterface();
            }
        }
    }

    Rectangle{
        id:hoveredIcon
        opacity:0

        y:disablePreviewsBtn.y+disablePreviewsBtn.height+1
        x:disablePreviewsBtn.x - height/4

        width:2
        height:2*disablePreviewsBtn.width

        rotation: -90
        transformOrigin: Item.TopLeft

        gradient: Gradient {
            GradientStop { position: 0.0; color: "#00f1f1f1" }
            GradientStop { position: 0.2; color: "#aaf1f1f1" }
            GradientStop { position: 0.8; color: "#aaf1f1f1" }
            GradientStop { position: 1.0; color: "#00f1f1f1" }

        }
    }

    Flickable{
        id: desktopView

        x:deskDialog.insideX
        y:deskDialog.insideY

        width:insideWidth
        height:insideHeight

        contentWidth: desksTasksList.width-40
        contentHeight: desksTasksList.height

        boundsBehavior: Flickable.StopAtBounds
        clip:true

        Row{
            //width:parent.width
            //height:parent.height
            Repeater{
                model:deskDialog.columns-1
                delegate:Item{
                    width:deskDialog.cWidth-1
                    height:deskDialog.shownRows*deskDialog.cHeight
                    Rectangle{
                        width:1
                        height:parent.height
                        anchors.right: parent.right

                        gradient: Gradient {
                            GradientStop { position: 0.0; color: "#00f1f1f1" }
                            GradientStop { position: 0.2; color: "#aaf1f1f1" }
                            GradientStop { position: 0.8; color: "#aaf1f1f1" }
                            GradientStop { position: 1.0; color: "#00f1f1f1" }

                        }
                    }
                }
            }
        }

        GridView{
            id:desksTasksList
            model:instanceOfTasksDesktopList.model

            width: columns*cellWidth
            height: realRows*cellHeight

            cellWidth:deskDialog.cWidth
            cellHeight:deskDialog.cHeight

            interactive:false

            property int delegHeight:150


            property bool onlyState1: false
            property string selectedWin:""

            property alias desktopInd: deskDialog.desktop

            delegate: TaskPreviewDeleg{
                showAllActivities: false

                rWidth: desksTasksList.cellWidth
                rHeight: desksTasksList.cellHeight

                defWidth: 0.7*mainView.scaleMeter

                defPreviewWidth: 0.8*desksTasksList.cellHeight
                defHovPreviewWidth: 1.4*defPreviewWidth

                taskTitleTextDef: "#ffffff"
                taskTitleTextHov: "#ffffff"

                scrollingView: desktopView
                centralListView: desksTasksList
            }


        }

        function forceState1(){
            if(deskDialog.disablePreviews === false){
                deskDialog.disablePreviews = true;
                deskDialog.disablePreviewsWasForced = true;
            }
            else{
                deskDialog.disablePreviewsWasForced = false;
            }

        }

        function unForceState1(){
            if(deskDialog.disablePreviewsWasForced === true){
                deskDialog.disablePreviews = false;
            }
        }

        states: State {
            name: "ShowBars"
            when: desktopView.contentHeight > desktopView.height
            PropertyChanges { target: desktopVerticalScrollBar; opacity: 0.7 }
        }

        transitions: Transition {
            NumberAnimation { properties: "opacity"; duration: 2*mainView.animationsStep }
        }
    }

    ScrollBar {
        id: desktopVerticalScrollBar
        width: 9; height: desktopView.height
        anchors.top: desktopView.top
        anchors.left: desktopView.right
        opacity: 0
        orientation: Qt.Vertical
        position: desktopView.visibleArea.yPosition
        pageSize: desktopView.visibleArea.heightRatio
    }

    /*PlasmaComponents.ScrollBar {
        id: desktopVerticalScrollBar
        width: 12;
      //  height: desktopView.insideHeight
        anchors.right: desktopView.right
        opacity: 0
        orientation: Qt.Vertical
        flickableItem: desktopView
    }*/

    function initInterface(){
        var counter = desksTasksList.model.count


        if (counter === 0){
            deskDialog.close();
        }
        else{
            //Count the rows and columns//
            //Count the cellWidth and cellHeight//
            if ( (mainView.enablePreviews === false) ||
                    (deskDialog.disablePreviews===true) ){
                if (counter<=5){
                    deskDialog.shownRows=counter;
                    deskDialog.realRows=counter;
                    deskDialog.columns=1;
                }
                else{
                    deskDialog.realRows=Math.floor( (counter+1)/2 );
                    deskDialog.shownRows=Math.min(deskDialog.realRows,5);
                    deskDialog.columns = 2;
                }

                if (deskDialog.columns === 1){
                    deskDialog.cWidth = 0.6 * deskDialog.width
                    deskDialog.cHeight = 0.08 * deskDialog.height
                }
                else{
                    deskDialog.cWidth = 0.33 * deskDialog.width
                    deskDialog.cHeight = 0.08 * deskDialog.height
                }

            }
            else{
                deskDialog.columns = Math.min(Math.floor( (counter+1)/2 ), 3);
                if (deskDialog.columns > 1)
                    deskDialog.shownRows = Math.min(Math.floor( (counter+1)/deskDialog.columns),3);
                else
                    deskDialog.shownRows = Math.min(counter,3);

                if (counter === 7)
                    deskDialog.shownRows = 3

                if (counter>9)
                    deskDialog.realRows = Math.floor( (counter+2)/3 );
                else
                    deskDialog.realRows = deskDialog.shownRows


                if(deskDialog.columns === 1){
                    deskDialog.cWidth = 0.5 * deskDialog.width
                }
                else if(deskDialog.columns === 2){
                    deskDialog.cWidth = 0.4 * deskDialog.width
                }
                else if(deskDialog.columns === 3){
                    deskDialog.cWidth = 0.3 * deskDialog.width
                }

                if(deskDialog.shownRows === 1){
                    //deskDialog.cHeight = 4*mainView.scaleMeter
                    deskDialog.cHeight = 0.45*deskDialog.height
                }
                else if(deskDialog.shownRows === 2){
                    deskDialog.cHeight = 0.27*deskDialog.height
                }
                else if(deskDialog.shownRows === 3){
                    deskDialog.cHeight = 0.27*deskDialog.height
                }
            }
        }

    }

    function closeD(){
        allWorkareas.flickableV = true;
        deskDialog.close();

        activityCode = "";
        desktop = -1;
    }

    function emptyDialog(){
        instanceOfTasksDesktopList.emptyList();
        allActT.unForceState1();

        activityCode = "";
        desktop = -1;
    }

    function openD(act,desk){
        activityCode = act;
        desktop = desk;

        deskDialog.dialogTitle = instanceOfActivitiesList.getActivityName(act) + " - "+
                instanceOfWorkAreasList.getWorkareaName(act,desk);

        instanceOfTasksDesktopList.loadDesktop(act,desk);

        initInterface();

        if (deskDialog.disablePreviews===true)
            desktopView.forceState1();
        else
            desktopView.unForceState1();

        deskDialog.open();
        allWorkareas.flickableV = false;

        allActT.forceState1();

    }


    function getDeskView(){
        return desktopView;
    }

    function getTasksList(){
        return desksTasksList;
    }

    function clearList(){
        instanceOfTasksDesktopList.emptyList();
    }

    Connections {
        target: deskDialog
        onClickedOk:{
            /*
            */
        }

        onClickedCancel:{
            deskDialog.emptyDialog();
            //instanceOfTasksDesktopList.emptyList();
            //allActT.unForceState1();
            ///
        }
    }
}
