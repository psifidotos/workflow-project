// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle{
    id:mainDraggingItem
    anchors.fill: mainView

    color:"#05000000"
    opacity:0

    property string drActiv: ""
    property int drDesktop: -1

    Rectangle{
        id:selectionRect

        color:"#55ffffff"
        border.width: 1
        border.color: "#aaaaaa"

        opacity:0;
        radius:8;

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
    }

    Image{
        id:iconImg
        width:mainView.scaleMeter
        height:width
        opacity:0.8
    }

    MouseArea {
        id:mouseDraggingArea
        anchors.fill: parent
        hoverEnabled: true

        enabled:false

        onPositionChanged:{
            mainDraggingItem.onPstChanged(mouse);
        }


        onReleased:{
            mainDraggingItem.disableDragging();
            console.debug("Released...");
        }

    }

    function enableDragging(ms,src){
        mainDraggingItem.opacity = 1;
        mouseDraggingArea.enabled = true;
        mainDraggingItem.z = 100;
        allWorkareas.flickableV = false;
        iconImg.source = src;
        onPstChanged(ms);
    }

    function disableDragging(){
        mainDraggingItem.opacity = 0;
        mainDraggingItem.drActiv = -1;
        mainDraggingItem.drDesktop = -1;
        mouseDraggingArea.enabled = false;
        mainDraggingItem.z = 1;
        allWorkareas.flickableV = true;
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
                                        (mainDraggingItem.drDesktop!==workAreaD.desktop)){

                                    var bordRect = workAreaD.getBorderRectangle();
                                    var fixBCoord = bordRect.mapToItem(mainDraggingItem,bordRect.x, bordRect.y);


                                    selectionRect.x = fixBCoord.x-4;
                                    selectionRect.y = fixBCoord.y-4;

                                    selectionRect.width = workAreaD.width;
                                    selectionRect.height = 1.1 * workAreaD.height;
                                    selectionRect.opacity = 1;

                                    mainDraggingItem.drActiv = workAreaD.actCode;
                                    mainDraggingItem.drDesktop = workAreaD.desktop;
                                }


                            }
                        }//workalistForActivity
                        else if (mainDraggingItem.checkTypeId(listViewTot.childAt(fixC4.x,fixC4.y),"addWorkArea")){
                            var addArea = listViewTot.childAt(fixC4.x,fixC4.y).children[1];

                            if((mainDraggingItem.drActiv!== activityCode)||
                                    (mainDraggingItem.drDesktop!==desktopsNum)){


                                var fixBCoord2 = addArea.mapToItem(mainDraggingItem,addArea.x, addArea.y);

                                selectionRect.x = fixBCoord2.x;
                                selectionRect.y = fixBCoord2.y;

                                selectionRect.width = addArea.width;
                                selectionRect.height = 1.1 * addArea.height;
                                selectionRect.opacity = 1;

                                mainDraggingItem.drActiv = activityCode;
                                mainDraggingItem.drDesktop = desktopsNum;
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

            selectionRect.x = fixBCoord3.x;
            selectionRect.y = fixBCoord3.y;

            selectionRect.width = allTaskP.width;
            selectionRect.height = 1.1 * allTaskPO.height;
            selectionRect.opacity = 1;

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
