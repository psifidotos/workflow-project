// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.qtextracomponents 0.1

import ".."
import "../models"

ListView{

    model: ActivitiesModel1{}

    property int newActivityCounter:0

    property int vbYes:3

    PlasmaComponents.Dialog{
        id:removeDialog

        property string activityCode
        property string activityName

        buttons:[
            Item{
                anchors.right: parent.right
                height:30
                PlasmaComponents.Button{
                    id:button1
                    anchors.right: button2.left
                    anchors.rightMargin: 10
                    anchors.bottom: parent.bottom
                    width:100
                    text:i18n("Yes")
                    iconSource:"dialog-apply"

                    onClicked:{
                        activityManager.remove(removeDialog.activityCode);
                        instanceOfActivitiesList.activityRemovedIn(removeDialog.activityCode);
                        removeDialog.close();
                    }
                }
                PlasmaComponents.Button{
                    id:button2
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    width:100
                    text:i18n("No")
                    iconSource:"editdelete"

                    onClicked:{
                        removeDialog.close();
                    }
                }
            }
        ]
        title:[
            Text{
                id:titleMesg
                color:"#ffffff"
                text:"Remove Activity..."
                width:parent.width
                horizontalAlignment:Text.AlignHCenter
            },
            Rectangle{
                anchors.top:titleMesg.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                width:0.93*parent.width
                color:"#ffffff"
                opacity:0.3
                height:1
/*                gradient: Gradient {
                    GradientStop {position: 0; color: "#00ffffff"}
                    GradientStop {position: 0.5; color: "#ffffffff"}
                    GradientStop {position: 1; color: "#00ffffff"}
                }*/
            }

        ]
        content:[
            QIconItem{
                anchors.topMargin:10
                id:infIcon
                icon:QIcon("messagebox_info")
                width:70
                height:70
            },
            Text{
                anchors.left: infIcon.right
                anchors.verticalCenter: infIcon.verticalCenter
                color:"#ffffff"
                text:"Are you sure you want to remove activity <b>"+removeDialog.activityName+"</b> ?"
            }
        ]
    }

    function printModel(){
        console.debug("---- Activities Model -----");
        for(var i=0; i<model.count; ++i){
            var obj = model.get(i);
            console.debug(obj.code + " - " + obj.Name + " - " +obj.Icon + " - " +obj.Current + " - " +obj.CState);
        }
        console.debug("----  -----");
    }

    function setCState(cod, val){
        var ind = getIndexFor(cod);
        model.setProperty(ind,"CState",val);

        instanceOfWorkAreasList.setCState(cod,val);


        allWorkareas.updateShowActivities();
        stoppedPanel.changedChildState();

    }

    function activityAddedIn(source,title,icon,stat,cur)
    {
        if (stat === "")
            stat = "Running";

        model.append( {  "code": source,
                         "Current":cur,
                         "Name":title,
                         "Icon":icon,
                         "CState":stat} );

        instanceOfWorkAreasList.addNewActivityF(source, stat, cur);

        for(var j=0; j<3; ++j){
            instanceOfWorkAreasList.addWorkarea(source);
        }

        setCState(source,stat);

        // updateWallpaper(source,1000);
        // var pt = activityManager.getWallpaper(source);
        //      instanceOfWorkAreasList.setWallpaper(source,pt);
        updateWallpaper(source);
    }

    function setIcon(cod){
        activityManager.chooseIcon(cod);
    }

    function setCurrentIns(source,cur)
    {
        var ind = getIndexFor(source);
        model.setProperty(ind,"Current",cur);

        instanceOfWorkAreasList.setCurrentIns(source,cur);
    }

    function activityUpdatedIn(source,title,icon,stat,cur)
    {
        if (stat === "")
            stat = "Running";

        var ind = getIndexFor(source);
        if(ind>-1){
            model.setProperty(ind,"Name",title);
            model.setProperty(ind,"Icon",icon);
            setCState(source,stat);
            setCurrentIns(source,cur);
        }

    }

    function activityRemovedIn(cod){
        var p = getIndexFor(cod);
        if (p>-1){
            model.remove(p);

            instanceOfWorkAreasList.removeActivity(cod);
            allWorkareas.updateShowActivities();
        }

    }


    function stopActivity(cod){

        activityManager.stop(cod);

        setCState(cod,"Stopped");
        instanceOfWorkAreasList.setCState(cod,"Stopped");
    }

    Timer {
        id:wallPapTimer
        property string cd
        interval: 750; running: false; repeat: false
        onTriggered: {
            updateWallpaper(cd);
        }
    }

    function updateWallpaper(cod){
        var pt = activityManager.getWallpaper(cod);
        if (pt !== "")
            instanceOfWorkAreasList.setWallpaper(cod,pt);
    }

    function updateWallpaperInt(cod,inter){
        wallPapTimer.cd = cod;
        wallPapTimer.interval = inter;
        wallPapTimer.start();
    }

    function startActivity(cod){

        activityManager.start(cod);

        setCState(cod,"Running");
        instanceOfWorkAreasList.setCState(cod,"Running");

        updateWallpaperInt(cod,1000);

        //        var pt = activityManager.getWallpaper(cod);
        //       instanceOfWorkAreasList.setWallpaper(cod,pt);
    }

    function setName(cod,title){
        activityManager.setName(cod,title);

        //   var ind = getIndexFor(cod);
        //  model.setProperty(ind,"Name",title);
    }

    function getCState(cod){
        var ind = getIndexFor(cod);

        return model.get(ind).CState;
    }

    function setCurrent(cod){

        activityManager.setCurrent(cod);

        //  instanceOfWorkAreasList.setCurrent(cod);

    }

    function getIndexFor(cod){
        for(var i=0; i<model.count; ++i){
            var obj = model.get(i);
            if (obj.code === cod)
                return i;
        }

        return -1;
    }

    function cloneActivity(cod){

        var p = getIndexFor(cod);
        var ob = model.get(p);

        activityManager.clone(cod,"New Activity",ob.Icon);


        var nId = getNextId();

        model.insert(p+1,
                     {"code": nId,
                         "Current":false,
                         "Name":"New Activity",
                         "Icon":ob.Icon,
                         "CState":"Running"}
                     );
        instanceOfWorkAreasList.cloneActivity(cod,nId);

        allWorkareas.updateShowActivities();
    }

    function removeActivity(cod){
        var p = getIndexFor(cod);
        var ob = model.get(p);

        removeDialog.activityName = ob.Name;
        removeDialog.activityCode = cod;
        removeDialog.open();
    }


    function addNewActivity(){
        var nId = getNextId();
        var res = activityManager.add("---","New Activity");
    }

    function getNextId(){
        newActivityCounter++;
        return "dY"+newActivityCounter;
    }

}
