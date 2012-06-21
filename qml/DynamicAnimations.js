var activityAnimComp;
var taskAnimComp;
var btnAnimComp;
var wallTimer;


function createComponents(){
    activityAnimComp = Qt.createComponent("ActivityAnimationMainView.qml");
    taskAnimComp = Qt.createComponent("TaskAnimationMainView.qml");
    btnAnimComp = Qt.createComponent("BtnIconAnimatMainView.qml");
}


//Activities Animations

function animateStoppedToActive(cod, coord){

    var newObject = activityAnimComp.createObject(mainView);

    newObject.animateActivity(cod,coord,allWorkareas.getList());

    newObject.destroy(2000);
}

function animateActiveToStop(cod, coord){
    var newObject = activityAnimComp.createObject(mainView);

    newObject.animateActivity(cod,coord,stoppedPanel.getList());

    newObject.destroy(2000);
}

function getActivityCoord(cod,lst){
    var newObject = activityAnimComp.createObject(mainView);
    var res = newObject.getActivityCoord(cod,lst);
    newObject.destroy();

    return res;
}


//Tasks Animations

function animateDesktopToEverywhere(cid, coord, anim){
    var newObject = taskAnimComp.createObject(mainView);

    newObject.animateDesktopToEverywhere(cid, coord, anim);

    newObject.destroy(2000);
}

function animateEverywhereToActivity(cid, coord, anim){
    var newObject = taskAnimComp.createObject(mainView);

    newObject.animateEverywhereToActivity(cid, coord, anim);

    newObject.destroy(2000);
}

//General Animations
function animateEverywhereToXY(cid, coord1, coord2, anim){
    var newObject = taskAnimComp.createObject(mainView);

    newObject.animateEverywhereToXY(cid, coord1, coord2, anim);

    newObject.destroy(2000);
}

//Button Animations
function animateIcon(pth,rt,wdth,coord){
    var newObject = btnAnimComp.createObject(mainView);

    newObject.animateIcon(pth,rt,wdth,coord);

    newObject.destroy(2000);
}

