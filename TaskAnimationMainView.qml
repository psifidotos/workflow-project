// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Image{
    id:taskAnimation
    opacity:1

    width:5+mainView.scaleMeter
    height:width
    rotation:10

    z:40

    property int toX:0
    property int toY:0

    function animateDesktopToEverywhere(cid, coord){
        //ListView of running activities
        animateTask(cid,coord,allActT.getList());
    }

    function animateEverywhereToActivity(cid, coord){
        //ListView of stopped activities
        //animateActivity(cod,coord,stoppedPanel.getList());
        var pos = instanceOfTasksList.getIndexFor(cid);
        if (pos>=0){
            taskAnimation.x = coord.x
            taskAnimation.y = coord.y

            var elem = instanceOfTasksList.model.get(pos);
            taskAnimation.source = elem.icon;

            var activityCode = elem.activities;
            var desktopPos = elem.desktop + 1;//desktops count from 0?

            var actCState = instanceOfActivitiesList.getCState(activityCode);

            if (actCState == "Stopped"){

                var toCoord = mainView.getDynLib().getActivityCoord(activityCode,stoppedPanel.getList());

                taskAnimation.toX = toCoord.x;
                taskAnimation.toY = toCoord.y;

                playTaskAnimation.start();
            }
            else if (desktopPos > instanceOfWorkAreasList.getActivitySize(activityCode) ) {

                var col = allWorkareas.getActivityColumn(activityCode);

                animateTask(cid,coord,col.getOrphanList());

            }
            else{
                var col2 = allWorkareas.getActivityColumn(activityCode);
                var work = col2.getWorkarea(desktopPos);

                animateTask(cid,coord,work.getTasksList());
            }

        }
    }

    function animateTask(cid,coord,lst){
        var pos = instanceOfTasksList.getIndexFor(cid);

        if (pos>=0){
            taskAnimation.x = coord.x
            taskAnimation.y = coord.y

            var elem = instanceOfTasksList.model.get(pos);
            taskAnimation.source = elem.icon

            var newPosElem=lst; // if no child found

            var rchild = lst.children[0];

            for(var i=0; i < rchild.children.length; ++i){
          //      console.debug(cod+"-"+rchild.children[i].ccode);
            //    console.log(rchild.children[i]);
                if (rchild.children[i].ccode === cid)
                {
            //        console.debug("found");

                    newPosElem = rchild.children[i].children[0]; //the icon position
             //       console.debug("coords:"+newPosElem.x+"-"+newPosElem.y);
                }
            }

            var fixPosElem = newPosElem.mapToItem(mainView,newPosElem.toRX,newPosElem.toRY);

        /*    if (fixPosElem.x>mainView.width) //fix wrong computations with stopped activities
                taskAnimation.toX = mainView.width;
            else if (fixPosElem.x<0)
                taskAnimation.toX = 0;
            else*/
                taskAnimation.toX = fixPosElem.x;

/*            if (fixPosElem.y>mainView.height) //fix wrong computations with stopped activities
                taskAnimation.toY = mainView.height;
            else if (fixPosElem.y<0)
                taskAnimation.toY = 0;
            else */
                taskAnimation.toY = fixPosElem.y;

            playTaskAnimation.start();

            //console.debug("-----------------");
        }
    }

    ParallelAnimation{
        id:playTaskAnimation
        property int animationDur:900

        SequentialAnimation{
            NumberAnimation {
                target: taskAnimation;
                property: "opacity";
                duration: playTaskAnimation.animationDur/2;
                easing.type: Easing.InOutQuad;
                to: 0.6
            }
            NumberAnimation {
                target: taskAnimation;
                property: "opacity";
                duration: playTaskAnimation.animationDur/2;
                easing.type: Easing.InOutQuad;
                to: 0
            }
        }

        SequentialAnimation{
            NumberAnimation {
                target: taskAnimation;
                property: "scale";
                duration: playTaskAnimation.animationDur/2;
                easing.type: Easing.InOutQuad;
                to: 1.5
            }
            NumberAnimation {
                target: taskAnimation;
                property: "scale";
                duration: playTaskAnimation.animationDur/2;
                easing.type: Easing.InOutQuad;
                to: 0.8
            }
        }

        PropertyAnimation{
            target:taskAnimation
            duration: playTaskAnimation.animationDur
            property: "x"
            to:taskAnimation.toX
            easing.type: Easing.InOutQuad;
        }

        PropertyAnimation{
            target:taskAnimation
            duration: playTaskAnimation.animationDur
            property: "y"
            to:taskAnimation.toY
            easing.type: Easing.InOutQuad;
        }

    }

}

