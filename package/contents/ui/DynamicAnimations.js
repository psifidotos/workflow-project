var activityAnimComp;
var taskAnimComp;
var btnAnimComp;

function createComponents(){
    activityAnimComp = Qt.createComponent("ActivityAnimationMainView.qml");
    taskAnimComp = Qt.createComponent("TaskAnimationMainView.qml");
    btnAnimComp = Qt.createComponent("BtnIconAnimatMainView.qml");
}

//Dialogs

///////////////Remove Dialog/////////////////
function showRemoveDialog(actId,actName){
    var rmvDialog = Qt.createComponent("ui/RemoveDialogTmpl.qml");

    uiConnect.removeDialog = rmvDialog.createObject(uiConnect);

    uiConnect.removeDialog.activityCode = actId;
    uiConnect.removeDialog.activityName = actName;
    uiConnect.removeDialog.defColor = theme.textColor;

    uiConnect.removeDialog.open();
}

function deleteRemoveDialog(){
    uiConnect.removeDialog.destroy();
}

///////////////Clone Dialog/////////////////
function showCloneDialog(actId,actName){
    var clnDialog = Qt.createComponent("ui/CloningDialogTmpl.qml");

    uiConnect.cloningDialog = clnDialog.createObject(uiConnect);

    uiConnect.cloningDialog.activityCode = actId;
    uiConnect.cloningDialog.activityName = actName;
    uiConnect.cloningDialog.defColor = theme.textColor;

    uiConnect.cloningDialog.open();

}

function deleteCloneDialog(){
    uiConnect.cloningDialog.destroy();
}

///////////////Calibration Dialog/////////////////
function showCalibrationDialog(){
    var clbDialog = Qt.createComponent("ui/CalibrationDialogTmpl.qml");

    uiConnect.calibrationDialog = clbDialog.createObject(uiConnect);
    uiConnect.calibrationDialog.defColor = theme.textColor;

    uiConnect.calibrationDialog.openD();
}

function deleteCalibrationDialog(){
    uiConnect.calibrationDialog.destroy();
}

///////////////Desktop Dialog/////////////////
function showDesktopDialog(actId,desk){
    var dskDialog = Qt.createComponent("ui/DesktopDialogTmpl.qml");

    uiConnect.desktopDialog = dskDialog.createObject(uiConnect);
    uiConnect.desktopDialog.disablePreviews = mainView.disablePreviewsWasForcedInDesktopDialog;
    uiConnect.desktopDialog.defColor = theme.textColor;

    uiConnect.desktopDialog.openD(actId,desk);
}

function deleteDesktopDialog(){
    uiConnect.desktopDialog.destroy();
}

///////////////BusyIndicator Dialog/////////////////
function showBusyIndicatorDialog(){
    var bsDialog = Qt.createComponent("ui/BusyIndicatorDialogTmpl.qml");

    uiConnect.busyIndicatorDialog = bsDialog.createObject(uiConnect);

    uiConnect.busyIndicatorDialog.startAnimation();
}

function deleteBusyIndicatorDialog(){
    uiConnect.busyIndicatorDialog.destroy();
}

///////////////LiveTour Dialog/////////////////
function showLiveTourDialog(){
    var lvDialog = Qt.createComponent("helptour/TourDialog.qml");

    uiConnect.liveTourDialog = lvDialog.createObject(uiConnect);
    uiConnect.liveTourDialog.defColor = theme.textColor;

    uiConnect.liveTourDialog.openD();

    allActT.forceState1();
}

function deleteLiveTourDialog(){
    uiConnect.liveTourDialog.destroy();
    allActT.unForceState1();
}

/////////////About Dialog//////////////////////
function showAboutDialog(){
    var abDialog = Qt.createComponent("ui/AboutDialogTmpl.qml");

    uiConnect.aboutDialog = abDialog.createObject(uiConnect);
    uiConnect.aboutDialog.defColor = theme.textColor;

    uiConnect.aboutDialog.openD();
    allActT.forceState1();
}

function deleteAboutDialog(){
    allActT.unForceState1();
    uiConnect.aboutDialog.destroy();
}

/////////////First Run Help Tour Dialog//////////////////////
function showFirstHelpTourDialog(){
    var dialog = Qt.createComponent("ui/FirstRunHelpTourTmpl.qml");

    uiConnect.firstHelpTourDialog = dialog.createObject(uiConnect);
    uiConnect.firstHelpTourDialog.defColor = theme.textColor;

    uiConnect.firstHelpTourDialog.open();
}

function deleteFirstHelpTourDialog(){
    uiConnect.firstHelpTourDialog.destroy();
}

/////////////First Run Calibration Dialog//////////////////////
function showFirstCalibrationDialog(){
    var dialog = Qt.createComponent("ui/FirstRunCalibrationTmpl.qml");

    uiConnect.firstCalibrationDialog = dialog.createObject(uiConnect);
    uiConnect.firstCalibrationDialog.defColor = theme.textColor;

    uiConnect.firstCalibrationDialog.open();
}

function deleteFirstCalibrationDialog(){
    uiConnect.firstCalibrationDialog.destroy();
}

////////////////////////////////////
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

