// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import "../../code/settings.js" as Settings

Item{
    //is used when cloning an activity to temporary
    //disable previews
    property bool previewsWereEnabled:false

/*    Connections{

        target: workflowManager.activityManager()

        //Cloning Signals for interaction with the interface
        onCloningStarted:{
            if(Settings.global.windowPreviews === true){
                previewsWereEnabled = true;
                Settings.global.windowPreviews = false;
            }
            else
                previewsWereEnabled = false;

            mainView.getDynLib().showBusyIndicatorDialog();
        }

        onCloningEnded:{
            mainView.getDynLib().deleteBusyIndicatorDialog();

            if(previewsWereEnabled === true)
                Settings.global.windowPreviews = true;
            else
                Settings.global.windowPreviews = false;
        }

        //Update Wallpaper signal


    }*/

   /* Connections{
        target: plasmoidWrapper
        onSetCurrentNextActivity: workflowManager.activityManager().setCurrentNextActivity();
        onSetCurrentPreviousActivity: workflowManager.activityManager().setCurrentPreviousActivity();
    }*/

  /*  Component.onCompleted: {
        workflowManager.activityManager().updateAllWallpapers();
    }*/

}



