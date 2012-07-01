// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import ".."
import "ui-elements"

import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.qtextracomponents 0.1

Component{

    Item{
        id: taskDeleg2

        property bool mustBeShown: ( (onAllActivities === true )
                                    //               &&(onAllDesktops === true)
                                    && (isPressed === false) )

        property bool showPreviews: ((mainView.enablePreviews === true)&&
                                     (mustBeShown === true))

        //     property bool showPreviewsFound: ((showPreviews === true) &&
        //                                       (previewRect.ratio > 0))

        property bool showPreviewsFound: (showPreviews === true)


        width: mustBeShown === true ? allActRect.taskWidth+spacing : 0
        height: mustBeShown === true ? imageTask2.height+taskTitle2.height : 0

        //   y:-height/3

        opacity: mustBeShown === true ? 1 : 0

        property int spacing: 20
        property string ccode: code
        property string cActCode: activities === undefined ? mainView.currentActivity : activities
        property int cDesktop:desktop === undefined ? mainView.currentDesktop : desktop
        property bool isPressed:false


        property int defWidth:(3* allActTaskL.height / 5)
        property string currentNoHovered: showPreviewsFound === true ? "nohovered2":"nohovered1"

        property int defPreviewWidth:2.8*defWidth
        property int defHovPreviewWidth:4.4*defWidth

        state: "nohovered1"

        onShowPreviewsChanged:{

            if (showPreviews === true){
                //   previewTimer.repeat = true;
                //   previewTimer.start();
                taskDeleg2.state = "nohovered2";
                taskDeleg2.updatePreview();
            }
            else{
                //   previewTimer.repeat = false;
                //  previewTimer.stop();
                taskDeleg2.state = "nohovered1";
                taskManager.removeWindowPreview(taskDeleg2.ccode);
            }
        }

        onShowPreviewsFoundChanged:{
            if (showPreviewsFound === true){
                taskDeleg2.state = "nohovered2";
            }
            else{
                taskDeleg2.state = "nohovered1";
            }
        }

        Behavior on width{
            NumberAnimation {
                duration: 400;
                easing.type: Easing.InOutQuad;
            }
        }

        Behavior on opacity{
            NumberAnimation {
                duration: 400;
                easing.type: Easing.InOutQuad;
            }
        }

        QIconItem{
            id:imageTask2

            smooth:true
            icon: Icon

            height:width

            //correcting the animation
            property int toRX:x + (allActRect.taskWidth+spacing)/2
            property int toRY:y


            //  width:taskDeleg2.defWidth

            MouseArea {
                id:imageMouseArea2
                anchors.fill: parent
                hoverEnabled: true

                onEntered: {
                    taskDeleg2.onEntered();
                }

                onExited: {
                    taskDeleg2.onExited();
                }

                onClicked: {
                    taskDeleg2.onClicked(mouse);
                }

                onPressAndHold:{
                    taskDeleg2.onPressAndHold(mouse, imageMouseArea2);
                }

                onPositionChanged: {
                    taskDeleg2.onPositionChanged(mouse, imageMouseArea2);
                }

                onReleased:{
                    taskDeleg2.onReleased(mouse);
                }
            }

        }

        QIconItem{
            id:imageTask2Ref
            icon: Icon

            width:imageTask2.width
            height:imageTask2.height

            anchors.horizontalCenter: imageTask2.horizontalCenter
            anchors.top:imageTask2.bottom

            transform: Rotation { origin.x: 0; origin.y: height/3; axis { x: 1; y: 0; z: 0 } angle: 180 }

            opacity:0.15
            visible: !showPreviewsFound

        }


        ////Preview State///////////
        Timer {
            id:previewTimer
            property string cd
            interval: allActTaskL.shownTasks*2000; running: false; repeat:false

            onTriggered: {
                if (taskDeleg2.showPreviews === true){
                    previewRect.ratio = taskManager.windowScreenshotRatio(taskDeleg2.ccode);

                    var img = taskManager.windowScreenshot(taskDeleg2.ccode,imageTask2.height);

                    //                    console.debug(previewRect.ratio);

                    if (previewRect.ratio>0){
                        previewPix.pixmap = img;
                    }
                }
                else
                    previewTimer.stop();
            }
        }

        Rectangle{
            id:previewRect
            color:"#05666666"

           // anchors.horizontalCenter: parent.horizontalCenter

            //should be 0 but I use 1 for the live previews
            property real ratio:1
            property real revRatio: ratio > 0 ? 1/ratio : 0

            QPixmapItem{
                id:previewPix

                smooth:true
                anchors.centerIn: parent

                width:parent.width-2*bordSize
                height:parent.height-2*bordSize

                property int bordSize:2

                visible:parent.opacity === 0 ? false:true

            }


            onWidthChanged: {
                taskDeleg2.updatePreview();
            }
            onHeightChanged: {
                taskDeleg2.updatePreview();
            }
            onXChanged: {
                taskDeleg2.updatePreview();
            }

            MouseArea {
                id:imageMouseArea3
                anchors.fill: parent
                hoverEnabled: true

                onEntered: {
                    taskDeleg2.onEntered();
                }

                onExited: {
                    taskDeleg2.onExited();
                }

                onClicked: {
                    taskDeleg2.onClicked(mouse);
                }

                onPressAndHold:{
                    taskDeleg2.onPressAndHold(mouse, imageMouseArea3);
                }

                onPositionChanged: {
                    taskDeleg2.onPositionChanged(mouse, imageMouseArea3);
                }

                onReleased:{
                    taskDeleg2.onReleased(mouse);
                }
            }
        }


        onXChanged: {
            taskDeleg2.updatePreview();
        }
        ////Preview State///////////



        Rectangle{
            id: taskTitleRec

            anchors.horizontalCenter: parent.horizontalCenter

            width:taskDeleg2.width - taskDeleg2.spacing
            height:taskTitle2.height
            color:"#00e2e2e2"



            Text{
                id:taskTitle2

                anchors.horizontalCenter: parent.horizontalCenter


                text:name === undefined ? "" : name
                font.family: "Helvetica"
                font.italic: false
                font.bold: true
                font.pointSize: 6+(mainView.scaleMeter/18)
                color:"#333333"

                elide:Text.ElideRight
                width:parent.width
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onEntered: {
                    taskDeleg2.state = "hovered";
                    allTasksBtns.state = "show";
                }

                onExited: {
                    taskDeleg2.state = taskDeleg2.currentNoHovered;
                    allTasksBtns.state = "hide";
                }
            }
        }

        AllTaskDelegButtons{
            id:allTasksBtns

            x:showPreviewsFound===false ? imageTask2.x+0.9*imageTask2.width : previewRect.x + 1.02*previewRect.width
            y:showPreviewsFound===false ? imageTask2.y-0.6*buttonsSize : previewRect.y - 0.5*buttonsSize
            buttonsSize:0.8*taskDeleg2.defWidth
        }

        Connections {
            target: allTasksBtns
            onChangedStatus:{
                if (allTasksBtns.status == "hover")
                    taskDeleg2.state = "hovered";
                else
                    taskDeleg2.state =  taskDeleg2.currentNoHovered;
            }
        }


        states: [
            State {
                name: "nohovered1"
                PropertyChanges{
                    target:previewRect
                    //   visible:false
                    opacity:0
                    width:5
                    height:5
                }
                PropertyChanges{
                    target:imageTask2
                    width: 1.4*taskDeleg2.defWidth
                    x:taskDeleg2.width/2 - width/2
                }
                PropertyChanges{
                    target:taskDeleg2
                    y:-0.2*imageTask2.height
                }
                PropertyChanges{
                    target:taskTitleRec
                    y: 1.03*(imageTask2.y+imageTask2.height)
                    opacity:0.3
                }
            },
            State {
                name: "nohovered2"
                PropertyChanges{
                    target:previewRect
                    //  visible:true
                    opacity:1
                    width:previewRect.ratio>=1 ? taskDeleg2.defPreviewWidth : previewRect.ratio*taskDeleg2.defPreviewWidth
                    height:previewRect.ratio<1 ? taskDeleg2.defPreviewWidth : previewRect.revRatio*taskDeleg2.defPreviewWidth
                    //y:-2.3*taskDeleg2.defWidth / 2
                    y:(taskDeleg2.defPreviewWidth - height)
                    x:(taskDeleg2.width - taskDeleg2.defPreviewWidth)/2
                }
                PropertyChanges{
                    target:imageTask2
                    width: 1.4*taskTitleRec.height
                    x:0
                    y: 0.8*taskTitleRec.y
                    opacity:0.8
                }
                PropertyChanges{
                    target:taskDeleg2
                    y:-0.6*taskDeleg2.defPreviewWidth
                }
                PropertyChanges{
                    target:taskTitleRec
                    y: 1.03*(taskDeleg2.defPreviewWidth)
                    opacity:0.3
                }
            },
            State {
                name: "hovered"
                PropertyChanges {
                    target: taskDeleg2
                    y:showPreviewsFound===false ? -0.4*imageTask2.height : -0.6*taskDeleg2.defPreviewWidth
                }

                PropertyChanges{
                    target:taskTitleRec
                    y:showPreviewsFound===false ? 0.95*(imageTask2.y+imageTask2.height) : 1.03*(taskDeleg2.defPreviewWidth)
                    opacity:1
                }
                PropertyChanges{
                    target:imageTask2
                    width: showPreviewsFound===false ? 2.1 * taskDeleg2.defWidth : 1.4*taskTitleRec.height
                    opacity: 1
                    x: showPreviewsFound===false ? taskDeleg2.width/2 - width/2 : 0
                    y: showPreviewsFound===false ? 0 : 0.8*taskTitleRec.y
                }
                PropertyChanges{
                    target:previewRect
                    //  visible:showPreviewsFound===false ? false:true
                    opacity:showPreviewsFound===false ? 0:1
                    width:previewRect.ratio>=1 ? taskDeleg2.defHovPreviewWidth : previewRect.ratio*taskDeleg2.defHovPreviewWidth
                    height:previewRect.ratio<1 ? taskDeleg2.defHovPreviewWidth : previewRect.revRatio*taskDeleg2.defHovPreviewWidth
                    y: showPreviewsFound===false ? 0 : (0.6*taskDeleg2.defHovPreviewWidth - height)
                    x: showPreviewsFound===false ? 0 : (taskDeleg2.width - taskDeleg2.defHovPreviewWidth)/2
                }

            }

        ]

        transitions: [

            Transition {
                from:"nohovered1"; to:"hovered"
                reversible: true

                ParallelAnimation{
                    NumberAnimation {
                        target: imageTask2;
                        property: "width"
                        duration: 500;
                        easing.type: Easing.InOutQuad;
                    }
                    NumberAnimation {
                        target: imageTask2;
                        property: "x"
                        duration: 500;
                        easing.type: Easing.InOutQuad;
                    }
                    NumberAnimation {
                        target: imageTask2;
                        property: "y"
                        duration: 500;
                        easing.type: Easing.InOutQuad;
                    }
                    NumberAnimation {
                        target: taskDeleg2;
                        property: "y"
                        duration: 500;
                        easing.type: Easing.InOutQuad;
                    }
                    NumberAnimation {
                        target: taskTitleRec;
                        property: "y"
                        duration: 500;
                        easing.type: Easing.InOutQuad;
                    }
                    NumberAnimation {
                        target: taskTitleRec;
                        property: "opacity"
                        duration: 500;
                        easing.type: Easing.InOutQuad;
                    }
                    NumberAnimation {
                        target: previewRect;
                        property: "width"
                        duration: 500;
                        easing.type: Easing.InOutQuad;
                    }
                    NumberAnimation {
                        target: previewRect;
                        property: "height"
                        duration: 500;
                        easing.type: Easing.InOutQuad;
                    }
                    NumberAnimation {
                        target: previewRect;
                        property: "y"
                        duration: 500;
                        easing.type: Easing.InOutQuad;
                    }
                    NumberAnimation {
                        target: previewRect;
                        property: "x"
                        duration: 500;
                        easing.type: Easing.InOutQuad;
                    }
                }

            },
            Transition {
                from:"nohovered2"; to:"hovered"
                reversible: true

                ParallelAnimation{
                    NumberAnimation {
                        target: imageTask2;
                        property: "width"
                        duration: 500;
                        easing.type: Easing.InOutQuad;
                    }
                    NumberAnimation {
                        target: imageTask2;
                        property: "x"
                        duration: 500;
                        easing.type: Easing.InOutQuad;
                    }
                    NumberAnimation {
                        target: imageTask2;
                        property: "y"
                        duration: 500;
                        easing.type: Easing.InOutQuad;
                    }
                    NumberAnimation {
                        target: taskDeleg2;
                        property: "y"
                        duration: 500;
                        easing.type: Easing.InOutQuad;
                    }
                    NumberAnimation {
                        target: taskTitleRec;
                        property: "y"
                        duration: 500;
                        easing.type: Easing.InOutQuad;
                    }
                    NumberAnimation {
                        target: taskTitleRec;
                        property: "opacity"
                        duration: 500;
                        easing.type: Easing.InOutQuad;
                    }
                    NumberAnimation {
                        target: previewRect;
                        property: "width"
                        duration: 500;
                        easing.type: Easing.InOutQuad;
                    }
                    NumberAnimation {
                        target: previewRect;
                        property: "height"
                        duration: 500;
                        easing.type: Easing.InOutQuad;
                    }
                    NumberAnimation {
                        target: previewRect;
                        property: "y"
                        duration: 500;
                        easing.type: Easing.InOutQuad;
                    }
                    NumberAnimation {
                        target: previewRect;
                        property: "x"
                        duration: 500;
                        easing.type: Easing.InOutQuad;
                    }

                }

            },
            Transition {
                from:"nohovered1"; to:"nohovered2"
                reversible: true

                ParallelAnimation{
                    NumberAnimation {
                        target: imageTask2;
                        property: "width"
                        duration: 500;
                        easing.type: Easing.InOutQuad;
                    }
                    NumberAnimation {
                        target: imageTask2;
                        property: "x"
                        duration: 500;
                        easing.type: Easing.InOutQuad;
                    }
                    NumberAnimation {
                        target: imageTask2;
                        property: "y"
                        duration: 500;
                        easing.type: Easing.InOutQuad;
                    }
                    NumberAnimation {
                        target: taskDeleg2;
                        property: "y"
                        duration: 500;
                        easing.type: Easing.InOutQuad;
                    }
                    NumberAnimation {
                        target: taskTitleRec;
                        property: "y"
                        duration: 500;
                        easing.type: Easing.InOutQuad;
                    }
                    NumberAnimation {
                        target: taskTitleRec;
                        property: "opacity"
                        duration: 500;
                        easing.type: Easing.InOutQuad;
                    }
                    NumberAnimation {
                        target: previewRect;
                        property: "width"
                        duration: 500;
                        easing.type: Easing.InOutQuad;
                    }
                    NumberAnimation {
                        target: previewRect;
                        property: "height"
                        duration: 500;
                        easing.type: Easing.InOutQuad;
                    }
                    NumberAnimation {
                        target: previewRect;
                        property: "y"
                        duration: 500;
                        easing.type: Easing.InOutQuad;
                    }
                    NumberAnimation {
                        target: previewRect;
                        property: "x"
                        duration: 500;
                        easing.type: Easing.InOutQuad;
                    }

                }

            }
        ]

        function onEntered() {
            if (taskDeleg2.isPressed === false){
                taskDeleg2.state = "hovered";
                allTasksBtns.state = "show";
            }
        }

        function onExited() {
            taskDeleg2.state =  taskDeleg2.currentNoHovered;
            allTasksBtns.state = "hide";
        }

        function onClicked(mouse) {
            instanceOfTasksList.setCurrentTask(taskDeleg2.ccode);
        }

        function onPressAndHold(mouse,obj) {
            taskDeleg2.isPressed = true;
            taskDeleg2.state =  taskDeleg2.currentNoHovered;
            allTasksBtns.state = "hide";

            var nCor = obj.mapToItem(mainView,mouse.x,mouse.y);

            var coord1 = imageTask2.mapToItem(mainView,imageTask2.x, imageTask2.y);

            mDragInt.enableDragging(nCor,
                                    imageTask2.icon,
                                    taskDeleg2.ccode,
                                    taskDeleg2.cActCode,
                                    taskDeleg2.cDesktop,
                                    coord1,
                                    true,
                                    inDragging);
        }

        function onPositionChanged(mouse,obj) {
            if (taskDeleg2.isPressed === true){
                var nCor = obj.mapToItem(mainView,mouse.x,mouse.y);
                mDragInt.onPstChanged(nCor);
            }
        }

        function onReleased(mouse) {
            if (taskDeleg2.isPressed === true)
                mDragInt.onMReleased(mouse);
            taskDeleg2.isPressed = false;
        }

        function updatePreview(){
            if(taskDeleg2.showPreviews === true){
                var x1 = 0;
                var y1 = 0;
                var obj = previewRect.mapToItem(mainView,x1,y1);
                taskManager.setWindowPreview(taskDeleg2.ccode,
                                             obj.x,
                                             obj.y,
                                             previewRect.width,
                                             previewRect.height);

          //      testerRec.x = obj.x;
          //      testerRec.y = obj.y;
            }
        }

    }

}
