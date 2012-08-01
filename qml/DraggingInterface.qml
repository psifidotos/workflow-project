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

    property bool firsttime



    QIconItem{
        id:iconImg
        width:mainView.scaleMeter
        height:width
        opacity:0.8
        smooth:true
    }


    function enableDragging(ms,src,taskI,actI,deskI,coord1,everywhere,shaded){

        if(desktopDialog.visible === true)
            desktopDialog.closeD();

        mainDraggingItem.opacity = 1;
        mainDraggingItem.z = 100;
        allWorkareas.flickableV = false;

        iconImg.icon = src;
        iconImg.enabled = true;

        mainDraggingItem.intTaskId = taskI;
        mainDraggingItem.intActId = actI;
        mainDraggingItem.intDesktop = deskI;
        mainDraggingItem.intX1 = coord1.x;
        mainDraggingItem.intY1 = coord1.y;
        mainDraggingItem.intIsEverywhere = everywhere;
        mainDraggingItem.intIsShaded = shaded;

        //  iconImg.icon = instanceOfTasksList.getTasksIcon(taskI);

        mainDraggingItem.lastSelection = -1;
        //just for the first check
        mainDraggingItem.firsttime=true;

        onPstChanged(ms);
    }

    function disableDragging(){
        mainDraggingItem.opacity = 0;
        mainDraggingItem.enabled = false;
        mainDraggingItem.z = -1;
        allWorkareas.flickableV = true;
        selectionImage.opacity = 0;

        selectionImage.setLocation(-1,-1,1,1);

        mainDraggingItem.lastSelection = -1;

        //It creates a confusion when releasing
        //must be fixed with a flag initialiazing properly
        //    mainDraggingItem.drActiv = "";
        //    mainDraggingItem.drDesktop = -1;
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
                    instanceOfTasksList.setTaskInDragging(mainDraggingItem.intTaskId,false);
                }


                instanceOfTasksList.setTaskActivity(mainDraggingItem.intTaskId,mainDraggingItem.drActiv);
                instanceOfTasksList.setTaskDesktop(mainDraggingItem.intTaskId,mainDraggingItem.drDesktop);

                if(mainView.animationsStep2!==0){
                    var co1 = mainView.mapToItem(mainView,iX1,iY1);
                    mainView.getDynLib().animateEverywhereToActivity(mainDraggingItem.intTaskId,
                                                                     co1,
                                                                     2);
                }

            }
        }
        else if (mainDraggingItem.lastSelection === 1){
            instanceOfWorkAreasList.addWorkarea(mainDraggingItem.drActiv);

            var works=instanceOfWorkAreasList.getActivitySize(mainDraggingItem.drActiv);

            if(mainDraggingItem.intIsShaded === false)
                instanceOfTasksList.setTaskState(mainDraggingItem.intTaskId,"oneDesktop");
            else{
                instanceOfTasksList.setTaskState(mainDraggingItem.intTaskId,"allDesktops");
                instanceOfTasksList.setTaskInDragging(mainDraggingItem.intTaskId,false);
            }

            instanceOfTasksList.setTaskActivity(mainDraggingItem.intTaskId,mainDraggingItem.drActiv);
            instanceOfTasksList.setTaskDesktop(mainDraggingItem.intTaskId,works);

            if(mainView.animationsStep2!==0){
                var co14 = mainView.mapToItem(mainView,iX1,iY1);
                var toCol4 = mainView.mapToItem(mainView,mouse.x,mouse.y);

                viewXY.x = viewXY.x-30;

                mainView.getDynLib().animateEverywhereToXY(mainDraggingItem.intTaskId,
                                                           co14,
                                                           viewXY,
                                                           2);
            }

        }
        else if (mainDraggingItem.lastSelection === 2){

            instanceOfTasksList.setTaskState(mainDraggingItem.intTaskId,"allActivities");
            instanceOfTasksList.setTaskInDragging(mainDraggingItem.intTaskId,false);

            if(mainView.animationsStep2!==0){
                var co13 = mainView.mapToItem(mainView,iX1,iY1);
                mainView.getDynLib().animateDesktopToEverywhere(mainDraggingItem.intTaskId,
                                                                co13,
                                                                2);
            }
        }

        disableDragging();
    }

    function onPstChanged(mouse){

        iconImg.x = mouse.x + 1;
        iconImg.y = mouse.y + 1;

        var fixCC = mainView.mapToItem(centralArea,mouse.x,mouse.y);

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
                                        (mainDraggingItem.firsttime === true)){

                                    var bordRect = workAreaD.getBorderRectangle();
                                    var fixBCoord = bordRect.mapToItem(mainDraggingItem,bordRect.x, bordRect.y);

                                    //selectionImage.setLocation(fixBCoord.x-4,fixBCoord.y-4,0.95*workAreaD.width,0.98*workAreaD.height);
                                    //selectionImage.setLocation(fixBCoord.x,fixBCoord.y,workAreaD.width,workAreaD.height);
                                    selectionImage.setLocation(fixBCoord.x-2,fixBCoord.y-4,bordRect.width-2,bordRect.height+8);
                                    selectionImage.opacity = 1;

                                    mainDraggingItem.drActiv = workAreaD.actCode;
                                    mainDraggingItem.drDesktop = workAreaD.desktop;

                                    mainDraggingItem.lastSelection = 0;
                                    mainDraggingItem.firsttime = false;
                                }


                            }
                        }//workalistForActivity
                        else if (mainDraggingItem.checkTypeId(listViewTot.childAt(fixC4.x,fixC4.y),"addWorkArea")){
                            var addArea = listViewTot.childAt(fixC4.x,fixC4.y).children[1];


                            if((mainDraggingItem.drActiv!== activityCode) ||
                                    (mainDraggingItem.drDesktop!==desktopsNum+1) ||
                                    (mainDraggingItem.firsttime === true)){

                                var fixBCoord2 = addArea.mapToItem(mainDraggingItem,addArea.x, addArea.y);

                                selectionImage.setLocation(fixBCoord2.x,fixBCoord2.y-5,addArea.width,1.3 * addArea.height);
                                selectionImage.opacity = 1;


                                mainDraggingItem.drActiv = activityCode;
                                mainDraggingItem.drDesktop = desktopsNum+1;

                                mainDraggingItem.lastSelection = 1;
                                mainDraggingItem.firsttime = false;

                            }

                        }
                    }
                }

            }//Flickable area

        }
        else if(mainDraggingItem.checkTypeId(centralArea.childAt(fixCC.x,fixCC.y),"allActivitiesTasks")){
           // var allTaskPO = centralArea.childAt(fixCC.x,fixCC.y);
            var allTaskPO = centralArea.childAt(fixCC.x,fixCC.y).children[2];

            //var fixBCoord3 = allTaskP.mapToItem(mainDraggingItem,allTaskP.x, allTaskP.y);
            var fixBCoord3 = allTaskPO.mapToItem(mainDraggingItem,allTaskPO.x, allTaskPO.y);

            var offX=13
            var offY=15

            selectionImage.setLocation(fixBCoord3.x-offX,fixBCoord3.y-offY, allTaskPO.width+1.4*offX, allTaskPO.height+1.8*offY);
            selectionImage.opacity = 1;

            mainDraggingItem.lastSelection = 2;
            mainDraggingItem.firsttime = false;
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

