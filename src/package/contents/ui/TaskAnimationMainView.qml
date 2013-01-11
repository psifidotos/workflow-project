// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.qtextracomponents 0.1


QIconItem{
    id:taskAnimation
    opacity:1

    width:5+mainView.scaleMeter
    height:width
    rotation:10
    smooth:true

    z:40

    property int toX:0
    property int toY:0

    //animation 1: a jump
    //animation 2: a line

    function animateDesktopToEverywhere(cid, coord, anim){
        //ListView of running activities
        console.debug("animateDesktopToEverywhere:"+coord.x+"-"+coord.y);
        animateTask(cid,coord,allActT.getList(),anim );
    }

    function animateEverywhereToXY(cid, coord1, coord2, anim){
        var pos = taskManager.model().getIndexFor(cid);
        console.debug("animateEverywhereToXY:"+pos);

        taskAnimation.x = coord1.x
        taskAnimation.y = coord1.y

        taskAnimation.icon = taskManager.getTaskIcon(cid);

        taskAnimation.toX = coord2.x;
        taskAnimation.toY = coord2.y;

        if (anim===1)
            playTaskAnimation.start();
        else if (anim===2)
            playTaskAnimation2.start();

    }

    function animateEverywhereToActivity(cid, coord, anim){

        var pos = taskManager.model().getIndexFor(cid);
        console.debug("animateEverywhereToActivity:"+pos+"-"+coord.x+"-"+coord.y);

        taskAnimation.x = coord.x
        taskAnimation.y = coord.y


        var activities = taskManager.getTaskActivities(cid);
        var activityCode

        if((activities.length === 0) ||
                (activities[0] === "") )
            activityCode = sessionParameters.currentActivity;
        else
            activityCode = activities[0];

        var elem = taskManager.model().get(pos);
        var desktopPos = elem.desktop - 1;//desktops count from 0?

        console.debug("Element Desktop:"+elem.desktop+" Element activity:"+activities[0]);

        if (desktopPos < 0)
            desktopPos = sessionParameters.currentDesktop - 1;


        var col2 = allWorkareas.getActivityColumn(activityCode);

        console.debug("Desktop:"+desktopPos);

        var work = col2.getWorkarea(desktopPos);

        animateTask(cid,coord,work.getTasksList(),anim);

    }

    function animateTask(cid,coord,lst,anim){
        //var pos = taskManager.model().getIndexFor(cid);

        taskAnimation.x = coord.x
        taskAnimation.y = coord.y

        //  var elem = taskManager.model().get(pos);
        taskAnimation.icon = taskManager.getTaskIcon(cid);

        var newPosElem=lst; // if no child found

        var rchild = lst.children[0];

        for(var i=0; i < rchild.children.length; ++i){

            if (rchild.children[i].ccode === cid)
            {
                if (lst === allActT.getList())
                    newPosElem = rchild.children[i].getIcon();
                else
                    newPosElem = rchild.children[i].children[0]; //the icon position
            }
        }

        var fixPosElem = newPosElem.mapToItem(mainView,newPosElem.toRX,newPosElem.toRY);

        taskAnimation.toX = fixPosElem.x;
        taskAnimation.toY = fixPosElem.y;

        if (anim===1)
            playTaskAnimation.start();
        else if (anim===2)
            playTaskAnimation2.start();

    }

    ParallelAnimation{
        id:playTaskAnimation
        property int animationDur:1000

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
    //////////////////////////////////////////
    ParallelAnimation{
        id:playTaskAnimation2
        property int animationDur:750

        NumberAnimation {
            target: taskAnimation;
            property: "opacity";
            duration: playTaskAnimation2.animationDur;
            easing.type: Easing.InOutQuad;
            to: 0.6
        }
        NumberAnimation {
            target: taskAnimation;
            property: "opacity";
            duration: playTaskAnimation2.animationDur;
            easing.type: Easing.InOutQuad;
            to: 0
        }
        NumberAnimation {
            target: taskAnimation;
            property: "scale";
            duration: playTaskAnimation2.animationDur;
            easing.type: Easing.InOutQuad;
            to: 0.8
        }

        PropertyAnimation{
            target:taskAnimation
            duration: playTaskAnimation2.animationDur
            property: "x"
            to:taskAnimation.toX
            easing.type: Easing.InOutQuad;
        }

        PropertyAnimation{
            target:taskAnimation
            duration: playTaskAnimation2.animationDur
            property: "y"
            to:taskAnimation.toY
            easing.type: Easing.InOutQuad;
        }

    }

}

