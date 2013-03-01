// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import "../../code/settings.js" as Settings

Item{
    /*--------------------Dialogs ---------------- */
    id: container

    anchors.fill: parent

    //Just to ignore the warnings
    signal completed;
    property bool disablePreviews;

    property variant removeDialog:container
    property variant cloningDialog:container
    property variant desktopDialog:container
    property variant calibrationDialog:container
    property variant busyIndicatorDialog:container

    property variant liveTourDialog:container
    property variant aboutDialog:container

    property variant firstHelpTourDialog:container
    property variant firstCalibrationDialog:container

    /************* Deleteing Dialogs  ***********************/
    Connections{
        target:removeDialog
        onCompleted:{
            //   console.debug("Delete Remove...");
            mainView.getDynLib().deleteRemoveDialog();
        }
    }

    Connections{
        target:cloningDialog
        onCompleted:{
            //    console.debug("Delete Cloning...");
            mainView.getDynLib().deleteCloneDialog();
        }
    }

    Connections{
        target:desktopDialog
        onCompleted:{
            //  console.debug("Delete Desktop Dialog...");
            mainView.getDynLib().deleteDesktopDialog();
        }

        onDisablePreviewsChanged:{
            mainView.disablePreviewsWasForcedInDesktopDialog = desktopDialog.disablePreviewsWasForced;
        }
    }

    Connections{
        target:calibrationDialog
        onCompleted:{
            //  console.debug("Delete Calibration Dialog...");
            mainView.getDynLib().deleteCalibrationDialog();
        }
    }

    Connections{
        target:liveTourDialog
        onCompleted:{
            // console.debug("Delete Livetour Dialog...");
            mainView.getDynLib().deleteLiveTourDialog();
        }
    }

    Connections{
        target:aboutDialog
        onCompleted:{
            mainView.getDynLib().deleteAboutDialog();
        }
    }

    Connections{
        target:firstHelpTourDialog
        onCompleted:{
            mainView.getDynLib().deleteFirstHelpTourDialog();
            if(Settings.global.firstRunLiveTour === false)
                Settings.global.firstRunLiveTour = true;
        }
    }

    Connections{
        target:firstCalibrationDialog
        onCompleted:{
            mainView.getDynLib().deleteFirstCalibrationDialog();
            if(Settings.global.firstRunCalibrationPreviews === false){
                Settings.global.firstRunCalibrationPreviews = true;
            }
        }
    }
}
