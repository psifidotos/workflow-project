// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.qtextracomponents 0.1

import "tooltips"
import "components"

PlasmaComponents.Slider {
    id: zoomSliderIt
    y: mainView.height - height
    x: mainView.width - width - 20
    maximumValue: 75
    minimumValue: 30
    value: 50
    width: 125
    z: 10

    property bool firsttime: true

    onValueChanged: firsttime === false ? workflowManager.setZoomFactor(value) : notFirstTime()

    //For hiding the Warnings in KDe4.8
    property bool updateValueWhileDragging: true
    property bool animated: true

    function notFirstTime(){
        firsttime = false;
    }

    IconButton {
        id: minusSliderImage
        x: -width / 1.5
        y: -5
        width: 30
        height: width

        icon: "zoom-out"
        smooth: true

        onClicked: {
            zoomSliderIt.value--;
        }

        tooltipTitle: i18n("Zoom Out")
        tooltipText: i18n("You can zoom out your interface in order to gain more space.")
    }

    IconButton {
        id: plusSliderImage
        x: zoomSliderIt.width - width/2
        y: -5
        width: 30
        height: width
        icon: "zoom-in"
        smooth: true

        onClicked: {
            zoomSliderIt.value++;
        }
        tooltipTitle: i18n("Zoom In")
        tooltipText: i18n("You can zoom in your interface in order to focus more on items.")
    }
}
