// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item{

   //Signals that are needed from taskManager in order to update
   //whatever is needed

    Connections{
        target: plasmoidWrapper
        onHideDashboard: taskManager.hideDashboard();
        onShowDashboard: taskManager.showDashboard();
    }

    Connections{
        target: taskManager
        onHidePopup: plasmoidWrapper.hidePopupDialogSlot();
    }

}
