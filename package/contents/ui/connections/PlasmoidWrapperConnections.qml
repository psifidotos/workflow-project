// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import "../../code/settings.js" as Settings

Item{   
    Component.onCompleted: plasmoidWrapper.setApplet(plasmoid.extender());

    Connections{
        target:plasmoidWrapper
        onWorkareaWasClicked:{
            if( Settings.global.hideOnClick )
                plasmoid.hidePopup();

            if( !plasmoidWrapper.isInPanel )
                taskManager.hideDashboard();
        }
    }
}
