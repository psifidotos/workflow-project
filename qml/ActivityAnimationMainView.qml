// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.qtextracomponents 0.1

QIconItem{
    id:activityAnimation
    opacity:0

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
        var pos = instanceOfActivitiesList.getIndexFor(cod);
        if (pos>=0){
            activityAnimation.x = coord.x
            activityAnimation.y = coord.y

            var elem=instanceOfActivitiesList.model.get(pos);

            if (elem.Icon == "")
                activityAnimation.icon = QIcon("plasma");
            else
                activityAnimation.icon = QIcon(elem.Icon);
            //activityAnimation.source = elem.Icon

            var toCoord = activityAnimation.getActivityCoord(cod,lst);

            activityAnimation.toX = toCoord.x;
            activityAnimation.toY = toCoord.y;

            playActAnimation.start();

            //console.debug("-----------------");
        }
    }

    function getActivityCoord(cod,lst){
        var pos = instanceOfActivitiesList.getIndexFor(cod);
        var fixPosElem;
        if (pos>=0){

            var elem=instanceOfActivitiesList.model.get(pos);

            var newPosElem=lst; // if no child found

            var rchild = lst.children[0];

            for(var i=0; i < rchild.children.length; ++i){
                if (rchild.children[i].ccode === cod)
                {
                    newPosElem = rchild.children[i].children[0]; //the icon position
                }
            }

            fixPosElem = newPosElem.mapToItem(mainView,newPosElem.toRX,newPosElem.toRY);


            fixPosElem.toX = fixPosElem.x;

            fixPosElem.toY = fixPosElem.y;

        }

        return fixPosElem;

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

