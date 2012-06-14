// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.qtextracomponents 0.1

Rectangle{
    id:mainDraggingItem
    anchors.fill: mainView

    color:"#05000000"
    opacity:0
    z:-1

    property string intTaskId
    property string intActId
    property string intDesktop
    property int intX1
    property int intY1
    property bool intIsEverywhere
    property bool intIsShaded //for allDesktops purposes and not Everywhere

    property string drActiv: ""
    property int drDesktop: -1


    //0 - over a Workarea
    //1 - over an AddWorkarea button
    //2 - over everywhere tasks
    property int lastSelection


    Rectangle{
        id:selectionRect

        color:"#00ffffff"
        border.width: 2
        border.color:redBorder

        opacity:0;
        radius:8;
        property int padding:2

        state:"blue"

        property color redBorder: "#ffc0bbbb"
        property color greenBorder: "#ffc0bbbb"
        property color blueBorder: "#ffc0bbbb"

        property string imageRed: "Images/textures/redTexture.png"
        property string imageGreen: "Images/textures/greenTexture.png"
        property string imageBlue: "Images/textures/blueTexture.png"

        property alias redImgOpac: redImage.opacity
        property alias greenImgOpac: greenImage.opacity
        property alias blueImgOpac: blueImage.opacity

        Image{
            id:redImage
            property int padding:2
            width: selectionRect.width - 2*selectionRect.padding
            height: selectionRect.height - 2*selectionRect.padding
            anchors.centerIn: parent
            source: selectionRect.imageRed
            fillMode: Image.Tile

            Behavior on opacity{
                NumberAnimation {
                    duration: 300;
                    easing.type: Easing.InOutQuad;
                }
            }
        }

        Image{
            id:greenImage

            width: selectionRect.width - 2*selectionRect.padding
            height: selectionRect.height - 2*selectionRect.padding
            anchors.centerIn: parent
            source: selectionRect.imageGreen
            fillMode: Image.Tile

            Behavior on opacity{
                NumberAnimation {
                    duration: 300;
                    easing.type: Easing.InOutQuad;
                }
            }
        }

        Image{
            id:blueImage
            property int padding:2
            width: selectionRect.width - 2*selectionRect.padding
            height: selectionRect.height - 2*selectionRect.padding
            anchors.centerIn: parent
            source: selectionRect.imageBlue
            fillMode: Image.Tile

            Behavior on opacity{
                NumberAnimation {
                    duration: 300;
                    easing.type: Easing.InOutQuad;
                }
            }
        }

        Behavior on x{
            NumberAnimation {
                duration: 300;
                easing.type: Easing.InOutQuad;
            }
        }

        Behavior on y{
            NumberAnimation {
                duration: 300;
                easing.type: Easing.InOutQuad;
            }
        }

        Behavior on width{
            NumberAnimation {
                duration: 300;
                easing.type: Easing.InOutQuad;
            }
        }

        Behavior on height{
            NumberAnimation {
                duration: 300;
                easing.type: Easing.InOutQuad;
            }
        }

        states: [
            State {
                name: "red"
                PropertyChanges {
                    target: selectionRect
                    redImgOpac: 1
                    greenImgOpac: 0
                    blueImgOpac: 0
                }
            },
            State {
                name:"green"
                PropertyChanges {
                    target: selectionRect
                    redImgOpac: 0
                    greenImgOpac: 1
                    blueImgOpac: 0
                }
            },
            State {
                name:"blue"
                PropertyChanges {
                    target: selectionRect
                    redImgOpac: 0
                    greenImgOpac: 0
                    blueImgOpac: 1
                }
            }
        ]
    }

    QIconItem{
        id:iconImg
        width:mainView.scaleMeter
        height:width
        opacity:0.8
        smooth:true
    }


    function enableDragging(ms,src,taskI,actI,deskI,coord1,everywhere,shaded){
        mainDraggingItem.opacity = 1;
        mainDraggingItem.z = 100;
        allWorkareas.flickableV = false;

        iconImg.icon = src;
        mainDraggingItem.intTaskId = taskI;
        mainDraggingItem.intActId = actI;
        mainDraggingItem.intDesktop = deskI;
        mainDraggingItem.intX1 = coord1.x;
        mainDraggingItem.intY1 = coord1.y;
        mainDraggingItem.intIsEverywhere = everywhere;
        mainDraggingItem.intIsShaded = shaded;

        onPstChanged(ms);
    }

    function disableDragging(){
        mainDraggingItem.opacity = 0;
        mainDraggingItem.enabled = false;
        mainDraggingItem.z = -1;
        allWorkareas.flickableV = true;
    }

    function onMReleased(mouse, viewXY){

        var iX1 = iconImg.x;
        var iY1 = iconImg.y;

        if (mainDraggingItem.lastSelection === 0){
            if ( (mainDraggingItem.intActId !== mainDraggingItem.drActiv) ||
                 (mainDraggingItem.intDesktop !== mainDraggingItem.drDesktop) ||
                 (mainDraggingItem.intIsEverywhere === true)){

                if(mainDraggingItem.intIsShaded === false)
                    instanceOfTasksList.setTaskState(mainDraggingItem.intTaskId,"oneDesktop");
                else{
                    instanceOfTasksList.setTaskState(mainDraggingItem.intTaskId,"allDesktops");
                    instanceOfTasksList.setTaskShaded(mainDraggingItem.intTaskId,false);
                }


                instanceOfTasksList.setTaskActivity(mainDraggingItem.intTaskId,mainDraggingItem.drActiv);
                instanceOfTasksList.setTaskDesktop(mainDraggingItem.intTaskId,mainDraggingItem.drDesktop);

                var co1 = mainView.mapToItem(mainView,iX1,iY1);
                mainView.getDynLib().animateEverywhereToActivity(mainDraggingItem.intTaskId,
                                                                 co1,
                                                                 2);

            }
        }
        else if (mainDraggingItem.lastSelection === 1){
            instanceOfWorkAreasList.addWorkarea(mainDraggingItem.drActiv);
            var works=instanceOfWorkAreasList.getActivitySize(mainDraggingItem.drActiv);

            if(mainDraggingItem.intIsShaded === false)
                instanceOfTasksList.setTaskState(mainDraggingItem.intTaskId,"oneDesktop");
            else{
                instanceOfTasksList.setTaskState(mainDraggingItem.intTaskId,"allDesktops");
                instanceOfTasksList.setTaskShaded(mainDraggingItem.intTaskId,false);
            }

            instanceOfTasksList.setTaskActivity(mainDraggingItem.intTaskId,mainDraggingItem.drActiv);
            instanceOfTasksList.setTaskDesktop(mainDraggingItem.intTaskId,works-1);

            var co14 = mainView.mapToItem(mainView,iX1,iY1);
            var toCol4 = mainView.mapToItem(mainView,mouse.x,mouse.y);

            viewXY.x = viewXY.x-30;

            mainView.getDynLib().animateEverywhereToXY(mainDraggingItem.intTaskId,
                                                             co14,
                                                             viewXY,
                                                             2);

        }
        else if (mainDraggingItem.lastSelection === 2){

            instanceOfTasksList.setTaskState(mainDraggingItem.intTaskId,"allActivities");

            var co13 = mainView.mapToItem(mainView,iX1,iY1);
            mainView.getDynLib().animateDesktopToEverywhere(mainDraggingItem.intTaskId,
                                                            co13,
                                                            2);
        }

        disableDragging();
    }

    function onPstChanged(mouse){

        iconImg.x = mouse.x + 1;
        iconImg.y = mouse.y + 1;

        var fixCC = mapToItem(centralArea,mouse.x,mouse.y);

        if(mainDraggingItem.checkTypeId(centralArea.childAt(fixCC.x,fixCC.y),"workareasMainView")){
            var mainCentralItem = centralArea.childAt(fixCC.x,fixCC.y);

            var fixCC2 = mapToItem(mainCentralItem,fixCC.x,fixCC.y);

            if(mainDraggingItem.checkTypeId(mainCentralItem.childAt(fixCC2.x,fixCC2.y),"workareasFlick")){

                var flickTrace = mainCentralItem.childAt(fixCC2.x,fixCC2.y).children[0];

                var fixC2 = mapToItem(flickTrace,mouse.x,mouse.y);

                if(mainDraggingItem.checkTypeId(flickTrace.childAt(fixC2.x,fixC2.y),"workareasFlickList1")){
                    var listViewAct = flickTrace.childAt(fixC2.x,fixC2.y).children[0];

                    var fixC3 = mapToItem(listViewAct,mouse.x,mouse.y);

                    if(mainDraggingItem.checkTypeId(listViewAct.childAt(fixC3.x,fixC3.y),"workareasActItem")){
                        var listViewTot = listViewAct.childAt(fixC3.x,fixC3.y);

                        var activityCode = listViewTot.ccode;
                        var desktopsNum = listViewTot.getWorkareaSize();

                        var fixC4 = mapToItem(listViewTot,mouse.x,mouse.y);


                        if(mainDraggingItem.checkTypeId(listViewTot.childAt(fixC4.x,fixC4.y),"workalistForActivity")){
                            var onlyWorkArList = listViewTot.childAt(fixC4.x,fixC4.y).children[0];

                            var fixC5 = mapToItem(onlyWorkArList,mouse.x,mouse.y);

                            if(mainDraggingItem.checkTypeId(onlyWorkArList.childAt(fixC5.x,fixC5.y),"workareaDeleg")){
                                var workAreaD = onlyWorkArList.childAt(fixC5.x,fixC5.y);

                                if((mainDraggingItem.drActiv!==workAreaD.actCode)||
                                   (mainDraggingItem.drDesktop!==workAreaD.desktop) ||
                                   (selectionRect.state !== "blue")){

                                    var bordRect = workAreaD.getBorderRectangle();
                                    var fixBCoord = bordRect.mapToItem(mainDraggingItem,bordRect.x, bordRect.y);

                                    selectionRect.state = "blue";

                                    selectionRect.x = fixBCoord.x-4;
                                    selectionRect.y = fixBCoord.y-4;

                                    selectionRect.width = workAreaD.width;
                                    selectionRect.height = 1.1 * workAreaD.height;
                                    selectionRect.opacity = 1;

                                    mainDraggingItem.drActiv = workAreaD.actCode;
                                    mainDraggingItem.drDesktop = workAreaD.desktop;

                                    mainDraggingItem.lastSelection = 0;
                                }


                            }
                        }//workalistForActivity
                        else if (mainDraggingItem.checkTypeId(listViewTot.childAt(fixC4.x,fixC4.y),"addWorkArea")){
                            var addArea = listViewTot.childAt(fixC4.x,fixC4.y).children[1];

                            if((mainDraggingItem.drActiv!== activityCode) ||
                               (mainDraggingItem.drDesktop!==desktopsNum) ||
                               (selectionRect.state = "red")){

                                var fixBCoord2 = addArea.mapToItem(mainDraggingItem,addArea.x, addArea.y);

                                selectionRect.state = "red";

                                selectionRect.x = fixBCoord2.x;
                                selectionRect.y = fixBCoord2.y;

                                selectionRect.width = addArea.width;
                                selectionRect.height = 1.1 * addArea.height;
                                selectionRect.opacity = 1;

                                mainDraggingItem.drActiv = activityCode;
                                mainDraggingItem.drDesktop = desktopsNum;
                                mainDraggingItem.lastSelection = 1;                               

                            }

                        }
                    }
                }

            }//Flickable area

        }
        else if(mainDraggingItem.checkTypeId(centralArea.childAt(fixCC.x,fixCC.y),"allActivitiesTasks")){
            var allTaskPO = centralArea.childAt(fixCC.x,fixCC.y);
            var allTaskP = centralArea.childAt(fixCC.x,fixCC.y).children[0];

            var fixBCoord3 = allTaskP.mapToItem(mainDraggingItem,allTaskP.x, allTaskP.y);

            selectionRect.state = "green";

            selectionRect.x = fixBCoord3.x;
            selectionRect.y = fixBCoord3.y;

            selectionRect.width = allTaskPO.width;
            selectionRect.height = 1.1 * allTaskPO.height;
            selectionRect.opacity = 1;

            mainDraggingItem.lastSelection = 2;
        }


    }

    function checkTypeId(obj,name){
        if (obj === null)
            return false;
        else if (obj.typeId === name)
            return true;
        else
            return false;
    }
}

