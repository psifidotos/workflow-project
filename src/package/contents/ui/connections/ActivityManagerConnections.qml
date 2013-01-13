// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item{
    //is used when cloning an activity to temporary
    //disable previews
    property bool previewsWereEnabled:false

    Connections{

        target: workflowManager.activityManager()

        onCurrentActivityInformationChanged: plasmoidWrapper.setActivityNameIconSlot(name, icon);
        onShowedIconDialog: plasmoidWrapper.showingIconsDialog();
        onAnsweredIconDialog: plasmoidWrapper.answeredIconDialog();
        onHidePopup: plasmoidWrapper.hidePopupDialogSlot();

        //Cloning Signals for interaction with the interface
        onCloningStarted:{
            if(storedParameters.windowsPreviews === true){
                previewsWereEnabled = true;
                storedParameters.windowsPreviews = false;
            }
            else
                previewsWereEnabled = false;

            mainView.getDynLib().showBusyIndicatorDialog();
        }

        onCloningEnded:{
            mainView.getDynLib().deleteBusyIndicatorDialog();

            if(previewsWereEnabled === true)
                storedParameters.windowsPreviews = true;
            else
                storedParameters.windowsPreviews = false;
        }

        //Update Wallpaper signal

        onUpdateWallpaper:{
            var wall = environmentManager.getWallpaper(activity);
            workflowManager.activityManager().setWallpaper(activity, wall);
        }

    }

    Connections{
        target: plasmoidWrapper
        onSetCurrentNextActivity: workflowManager.activityManager().setCurrentNextActivity();
        onSetCurrentPreviousActivity: workflowManager.activityManager().setCurrentPreviousActivity();
    }

    Component.onCompleted: {
        workflowManager.activityManager().updateAllWallpapers();
    }

}



