// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import ".."
import "../models"

Item{

    //is used when cloning an activity to temporary
    //disable previews
    property bool previewsWereEnabled:false

    //Cloning Signals for interaction with the interface
    Connections{
        target:activityManager
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
    }

}
