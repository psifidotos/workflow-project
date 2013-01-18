// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item{

   //Signals that are needed from previewManager in order to update
   //whatever is needed

/*    Connections{
        target: plasmoidWrapper
        onUpdateMarginForPreviews: previewManager.setTopXY(x,y);
        onUpdateWindowIDForPreviews: previewManager.setMainWindowId(win);
    }*/


    Connections{
        target: taskManager
        onTaskRemoved: previewManager.removeWindowPreview(win);
    }

 /*   Connections{
        target: previewManager
        onUpdatePopWindowWId: plasmoidWrapper.updatePopWindowWIdSlot();
    }*/
}
