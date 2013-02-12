// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.qtextracomponents 0.1

import "../code/settings.js" as Settings
import "components"

PlasmaComponents.TextField{
    id: container
    anchors.horizontalCenter : parent.horizontalCenter
    clearButtonShown: true
    y: keyNavigation.filterCalled ? -3 : -height
    placeholderText: i18n("Please enter your windows filter...")

    focus:true

    onAccepted:{
        keyNavigation.filterCalled = false;
        text="";
        mainView.forceActiveFocus();
    }

    Keys.onUpPressed: { }
    Keys.onDownPressed: { }
    Keys.onEscapePressed: hideFilter();

    Behavior on y{
        NumberAnimation {
            duration: 2*Settings.global.animationStep;
            easing.type: Easing.InOutQuad;
        }
    }

    IconButton {
        icon: "edit-delete"
        width: 0.65*parent.height
        height: width
        anchors {left: parent.right; leftMargin:5; verticalCenter: parent.verticalCenter}
        opacityAnimation: true

        onClicked: hideFilter();

        tooltipTitle: i18n("Hide Search Filter")
        tooltipText: i18n("Hide the search filter.")
    }

    function hideFilter(){
        keyNavigation.filterCalled = false;
        text="";
        mainView.forceActiveFocus();
    }
}
