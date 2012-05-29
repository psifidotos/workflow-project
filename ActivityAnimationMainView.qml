// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

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
        //ListView of running activities
        animateActivity(cod,coord,allWorkareas.getList());
    }

    function animateActiveToStop(cod, coord){
        //ListView of stopped activities
        animateActivity(cod,coord,stoppedPanel.getList());
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
          //      console.debug(cod+"-"+rchild.children[i].ccode);
            //    console.log(rchild.children[i]);
                if (rchild.children[i].ccode === cod)
                {
            //        console.debug("found");
                    newPosElem = rchild.children[i].children[0]; //the icon position
               //     console.debug(newPosElem);
               //     console.debug("coords:"+newPosElem.x+"-"+newPosElem.y);
                }
            }

            var fixPosElem = newPosElem.mapToItem(mainView,newPosElem.toRX,newPosElem.toRY);

            if (fixPosElem.x>mainView.width) //fix wrong computations with stopped activities
                activityAnimation.toX = mainView.width;
            else if (fixPosElem.x<0)
                activityAnimation.toX = 0;
            else
                activityAnimation.toX = fixPosElem.x;

            if (fixPosElem.y>mainView.height) //fix wrong computations with stopped activities
                activityAnimation.toY = mainView.height;
            else if (fixPosElem.y<0)
                activityAnimation.toY = 0;
            else
                activityAnimation.toY = fixPosElem.y;

            playActAnimation.start();

            //console.debug("-----------------");
        }
    }

    ParallelAnimation{
        id:playActAnimation
        property int animationDur:1600

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

