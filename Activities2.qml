// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1


Rectangle {
    width: 1024;  height: 700

    color: "#dcdcdc"
    id:mainView
    //  z:0
    anchors.fill: parent

    property int currentColumn:-1
    property int currentRow:-1

    property int scaleMeter:zoomSlider.value

    property real zoomingHeightFactor: ((zoomSlider.value-zoomSlider.minimum)/(zoomSlider.maximum-zoomSlider.minimum))*0.6
    property int workareaHeight:(3.6 - zoomingHeightFactor)*scaleMeter
    property int workareaY:2*scaleMeter

    property int workareaWidth: (60+3*mainView.scaleMeter) - (mainView.scaleMeter/5) + 10 + (mainView.scaleMeter-5)/3;

    Behavior on scaleMeter{
        NumberAnimation {
            duration: 100;
            easing.type: Easing.InOutQuad;
        }
    }

    ListView{
        id:instanceOfActivitiesList
        model: ActivitiesModel1{}

        function setCState(cod, val){
            var ind = getCurrentIndex(cod);
            model.setProperty(ind,"CState",val);
        }

        function getCurrentIndex(cod){
            for(var i=0; model.count; ++i){
                var obj = model.get(i);
                if (obj.code === cod)
                    return i;
            }
            return -1;
        }

    }


    Image{
        id:activityAnimation
        opacity:1

        width:5+mainView.scaleMeter
        height:width
        rotation:20

        z:40

        property int toX:0
        property int toY:0

        function animateStoppedToActive(cod, coord){
            animateActivity(cod,coord,activitiesList);
        }

        function animateActiveToStop(cod, coord){
            animateActivity(cod,coord,stoppedActivitiesList);
        }

        function animateActivity(cod,coord,lst){
            var pos = instanceOfActivitiesList.getCurrentIndex(cod);
            if (pos>=0){
                activityAnimation.x = coord.x
                activityAnimation.y = coord.y

                var elem=instanceOfActivitiesList.model.get(pos);
                activityAnimation.source = elem.Icon

                var newPosElem=lst; // if no child found

                var rchild = lst.children[0];

                for(var i=0; i < rchild.children.length; ++i){
                    // console.debug(cod+"-"+rchild.children[i].ccode);
                    if (rchild.children[i].ccode===cod)
                    {
                    //    console.debug("found");
                        newPosElem = rchild.children[i].children[0];
                      //  console.debug("coords:"+newPosElem.x+"-"+newPosElem.y);
                    }
                }

                var fixPosElem = newPosElem.mapToItem(mainView,newPosElem.x,newPosElem.y);

                if (fixPosElem.x>mainView.width) //fix wrong computations with stopped activities
                    activityAnimation.toX = mainView.width;
                else
                    activityAnimation.toX = fixPosElem.x;

                if (fixPosElem.y>mainView.height) //fix wrong computations with stopped activities
                    activityAnimation.toY = mainView.height;
                else
                    activityAnimation.toY = fixPosElem.y;

                playActAnimation.start();

                //console.debug("-----------------");
            }
        }

        ParallelAnimation{
            id:playActAnimation
            property int animationDur:1000

            SequentialAnimation{
                NumberAnimation {
                    target: activityAnimation;
                    property: "opacity";
                    duration: playActAnimation.animationDur/2;
                    easing.type: Easing.InOutQuad;
                    to: 0.6
                }
                NumberAnimation {
                    target: activityAnimation;
                    property: "opacity";
                    duration: playActAnimation.animationDur/2;
                    easing.type: Easing.InOutQuad;
                    to: 0
                }
            }

            SequentialAnimation{
                NumberAnimation {
                    target: activityAnimation;
                    property: "scale";
                    duration: playActAnimation.animationDur/2;
                    easing.type: Easing.InOutQuad;
                    to: 1.5
                }
                NumberAnimation {
                    target: activityAnimation;
                    property: "scale";
                    duration: playActAnimation.animationDur/2;
                    easing.type: Easing.InOutQuad;
                    to: 0.8
                }
            }

            PropertyAnimation{
                target:activityAnimation
                duration: playActAnimation.animationDur
                property: "x"
                to:activityAnimation.toX
                easing.type: Easing.InOutQuad;
            }

            PropertyAnimation{
                target:activityAnimation
                duration: playActAnimation.animationDur
                property: "y"
                to:activityAnimation.toY
                easing.type: Easing.InOutQuad;
            }

        }

    }

    Flickable{
        id: view

        width:stopActBack.x
        height:mainView.height

        //anchors.fill: parent
        contentWidth: allareas.width
        contentHeight: allareas.height

        boundsBehavior: Flickable.StopAtBounds

        Image{
            width:mainView.width<allareas.width ? allareas.width : mainView.width
            height:mainView.height<allareas.height ? allareas.height : mainView.height
            source:"Images/greyBackground.png"
            fillMode: Image.Tile
        }


        ListView{
            id:allareas

            y:workareaY+(workareaY/3)
            width:model.count*(workareaWidth)
            height: maxWorkAreasHeight + actImag1.height + actImag1Shad.height + scrollingMargin
            orientation: ListView.Horizontal
            spacing:60+3.5*mainView.scaleMeter
            interactive:false

            property int maxWorkAreasHeight: 0
            property int scrollingMargin: 30

            model:WorkAreasCompleteModel{}
            delegate: WorkAreaList{
            }

            function changedChildHeight(){
                var max=0;

                for (var i=0; i<allareas.children[0].children.length; ++i)
                {
                    var tempH = allareas.children[0].children[i].height;
                    //console.debug(tempL);
                    if (tempH>max)
                      max = tempH;
                }

                allareas.maxWorkAreasHeight = max;
            }

        }


        //Top Activities Banner

        Rectangle{
            id:actImag1Shad
            anchors.top: actImag1.bottom
            y:actImag1.height
            width: mainView.width<allareas.width ? allareas.width : mainView.width
            height: workareaY/6
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#aa0f0f0f" }
                GradientStop { position: 1.0; color: "#00797979" }
            }
        }

        Rectangle {
            id: actImag1
            //source: "Images/activitiesBack2.png"
            //fillMode: Image.TileHorizontally
            y:oxygenTitle.height
            width: mainView.width<allareas.width ? allareas.width : mainView.width
            height: workareaY-workareaY/10
            //smooth: true
            color: "#646464"
            border.color: "#77ffffff"
            border.width:1

            ListView {
                id: activitiesList

                orientation: ListView.Horizontal
                height: workareaY
                width: mainView.width<allareas.width ? allareas.width : mainView.width
                // anchors.top: parent.top
                //  anchors.left: parent.left
                y: workareaY / 12
                //   x: 10
                spacing: workareaY / 10
                interactive:false

                model: instanceOfActivitiesList.model
                delegate: Activity{

                }
            }

        }

        states: State {
            name: "ShowBars"
            when: view.movingVertically || view.movingHorizontally
            PropertyChanges { target: verticalScrollBar; opacity: 1 }
            PropertyChanges { target: horizontalScrollBar; opacity: 1 }
        }

        transitions: Transition {
            NumberAnimation { properties: "opacity"; duration: 400 }
        }

    }//Flickable scrolling

    //Scrollbars
    // Attach scrollbars to the right and bottom edges of the view.
    ScrollBar {
        id: verticalScrollBar
        width: 12; height: view.height-12
        anchors.right: view.right
        opacity: 0
        orientation: Qt.Vertical
        position: view.visibleArea.yPosition
        pageSize: view.visibleArea.heightRatio
    }

    ScrollBar {
        id: horizontalScrollBar
        width: view.width-12; height: 12
        anchors.bottom: view.bottom
        opacity: 0
        orientation: Qt.Horizontal
        position: view.visibleArea.xPosition
        pageSize: view.visibleArea.widthRatio
    }


    // Stopped Activities

    Rectangle {
        id: stopActBack

        x:stoppedActivitiesList.shownActivities > 0 ? mainView.width - width : mainView.width - 2
        y:oxygenTitle.height
        width: 2*mainView.workareaWidth/3
        height: mainView.height - y

        color: "#ebebeb"
        border.color: "#d9808080"
        border.width:1

        Behavior on x{
            NumberAnimation {
                duration: 400;
                easing.type: Easing.InOutQuad;
            }
        }

        ListView {
            id: stoppedActivitiesList
            orientation: ListView.Vertical
            height: shownActivities !==0 ? shownActivities * ((2*workareaHeight/3)+spacing) : workareaHeight
            //height: model.count * ((2*workareaHeight/3)+spacing)
            width: stopActBack.width - spacing

            //y:shownActivities===0 ? stopActBack.height : stopActBack.height-height-5
            y:stopActBack.height-height-5

            //   anchors.top: stopActBack.top
            anchors.right: stopActBack.right
            anchors.rightMargin: spacing

            spacing: workareaHeight/12

            property int shownActivities: 4

            interactive:false
            model: instanceOfActivitiesList.model

            delegate: ActivityStopped{
            }

            Behavior on height{
                NumberAnimation {
                    duration: 400;
                    easing.type: Easing.InOutQuad;
                }
            }
            function changedChildState(){
                var counter = 0;

                for (var i=0; i<stoppedActivitiesList.model.count; ++i)
                {
                    var elem = stoppedActivitiesList.model.get(i);

                    if (elem.CState === "Stopped")
                       counter++;
                }
                shownActivities = counter;
            //    if (shownActivities <2)
                //    shownActivities = 2;
            }
        }

        Rectangle{
            id:stpActShad
            height: workareaWidth/30
            width: stopActBack.height
         //   anchors.right: stopActBack.left
            rotation: 90
            transformOrigin: Item.TopLeft
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#770f0f0f" }
                GradientStop { position: 1.0; color: "#00797979" }
            }
        }

    }
    // Stopped Activities



    //ScrollBars


    Rectangle{
        id:oxygenTitle
        anchors.top:parent.top
        width:mainView.width
        color:"#dcdcdc"
        height: workareaY/3

        Image{
            source:"Images/buttons/titleLight.png"
            clip:true
            width:parent.width
            height:parent.height
            smooth:true
            fillMode:Image.PreserveAspectCrop
        }



        /*Image{
            source:"Images/buttons/titleShadow.png"
            anchors.top:oxygenTitle.bottom
            width:oxygenTitle.width
            height:3*oxygenTitle.height/5
            fillMode: Image.TileHorizontally
            smooth:true
        }*/

        Rectangle{
            anchors.top: oxygenTitle.bottom
            width:oxygenTitle.width
            height:3*oxygenTitle.height/6
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#aa0f0f0f" }
                GradientStop { position: 1.0; color: "#00797979" }
            }
        }

        Text{
            anchors.top:oxygenTitle.top
            anchors.horizontalCenter: oxygenTitle.horizontalCenter
            text:"Activities"
            font.family: "Helvetica"
            font.italic: true
            font.pointSize: 5+(mainView.scaleMeter) /10
            color:"#777777"
        }

    }



    Slider {
        id:zoomSlider
        anchors.bottom: mainView.bottom
        anchors.bottomMargin: 5
        anchors.right: stopActBack.left
        anchors.rightMargin: 5
        maximum: 65
        minimum: 35
        value: 50
        width:125

    }

}




