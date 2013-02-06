var activityAnimComp;
var taskAnimComp;
var btnAnimComp;

function createComponents(){
    activityAnimComp = Qt.createComponent("ActivityAnimationMainView.qml");
    taskAnimComp = Qt.createComponent("TaskAnimationMainView.qml");
    btnAnimComp = Qt.createComponent("BtnIconAnimatMainView.qml");
  //  deskDialog = Qt.createComponent("ui/DesktopDialogTmpl.qml");

  //  rmvDialog = Qt.createComponent("ui/RemoveDialogTmpl.qml");
}

//Dialogs

///////////////Remove Dialog/////////////////
function showRemoveDialog(actId,actName){
    var rmvDialog = Qt.createComponent("ui/RemoveDialogTmpl.qml");

    mainView.removeDialog = rmvDialog.createObject(mainView);

    mainView.removeDialog.activityCode = actId;
    mainView.removeDialog.activityName = actName;
    mainView.removeDialog.defColor = mainView.defaultFontColor;

    mainView.removeDialog.open();
}

function deleteRemoveDialog(){
    mainView.removeDialog.destroy();
}

///////////////Clone Dialog/////////////////
function showCloneDialog(actId,actName){
    var clnDialog = Qt.createComponent("ui/CloningDialogTmpl.qml");

    mainView.cloningDialog = clnDialog.createObject(mainView);

    mainView.cloningDialog.activityCode = actId;
    mainView.cloningDialog.activityName = actName;
    mainView.cloningDialog.defColor = mainView.defaultFontColor;

    mainView.cloningDialog.open();

}

function deleteCloneDialog(){
    mainView.cloningDialog.destroy();
}

///////////////Calibration Dialog/////////////////
function showCalibrationDialog(){
    var clbDialog = Qt.createComponent("ui/CalibrationDialogTmpl.qml");

    mainView.calibrationDialog = clbDialog.createObject(mainView);
    mainView.calibrationDialog.defColor = theme.textColor;

    mainView.calibrationDialog.openD();
}

function deleteCalibrationDialog(){
    mainView.calibrationDialog.destroy();
}

///////////////Desktop Dialog/////////////////
function showDesktopDialog(actId,desk){
    var dskDialog = Qt.createComponent("ui/DesktopDialogTmpl.qml");

    mainView.desktopDialog = dskDialog.createObject(mainView);
    mainView.desktopDialog.disablePreviews = mainView.disablePreviewsWasForcedInDesktopDialog;
    mainView.desktopDialog.defColor = mainView.defaultFontColor;

    mainView.desktopDialog.openD(actId,desk);

}

function deleteDesktopDialog(){
    mainView.desktopDialog.destroy();
}

///////////////BusyIndicator Dialog/////////////////
function showBusyIndicatorDialog(){
    var bsDialog = Qt.createComponent("ui/BusyIndicatorDialogTmpl.qml");

    mainView.busyIndicatorDialog = bsDialog.createObject(mainView);

    mainView.busyIndicatorDialog.startAnimation();
}

function deleteBusyIndicatorDialog(){
    mainView.busyIndicatorDialog.destroy();
}

///////////////LiveTour Dialog/////////////////
function showLiveTourDialog(){
    var lvDialog = Qt.createComponent("helptour/TourDialog.qml");

    mainView.liveTourDialog = lvDialog.createObject(mainView);
    mainView.liveTourDialog.defColor = mainView.defaultFontColor;

    mainView.liveTourDialog.openD();

    allActT.forceState1();
}

function deleteLiveTourDialog(){
    mainView.liveTourDialog.destroy();
    allActT.unForceState1();
}

/////////////About Dialog//////////////////////
function showAboutDialog(){
    var abDialog = Qt.createComponent("ui/AboutDialogTmpl.qml");

    mainView.aboutDialog = abDialog.createObject(mainView);
    mainView.aboutDialog.defColor = mainView.defaultFontColor;

    mainView.aboutDialog.openD();
    allActT.forceState1();
}

function deleteAboutDialog(){
    allActT.unForceState1();
    mainView.aboutDialog.destroy();
}

/////////////First Run Help Tour Dialog//////////////////////
function showFirstHelpTourDialog(){
    var dialog = Qt.createComponent("ui/FirstRunHelpTourTmpl.qml");

    mainView.firstHelpTourDialog = dialog.createObject(mainView);
    mainView.firstHelpTourDialog.defColor = mainView.defaultFontColor;

    mainView.firstHelpTourDialog.open();
}

function deleteFirstHelpTourDialog(){
    mainView.firstHelpTourDialog.destroy();
}

/////////////First Run Calibration Dialog//////////////////////
function showFirstCalibrationDialog(){
    var dialog = Qt.createComponent("ui/FirstRunCalibrationTmpl.qml");

    mainView.firstCalibrationDialog = dialog.createObject(mainView);
    mainView.firstCalibrationDialog.defColor = mainView.defaultFontColor;

    mainView.firstCalibrationDialog.open();
}

function deleteFirstCalibrationDialog(){
    mainView.firstCalibrationDialog.destroy();
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

