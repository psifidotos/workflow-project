// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.qtextracomponents 0.1

import "components"

Item {
    id: container
    property alias value: zoomSliderIt.value
    property alias minimumValue: zoomSliderIt.minimumValue
    property alias maximumValue: zoomSliderIt.maximumValue
    height: 30
    width: 200

    Row {
        anchors.fill: parent

        IconButton {
            id: zoomOutButton
            width: parent.height
            height: width
            icon: "zoom-out"
            smooth: true

            onClicked: { zoomSliderIt.value--; }

            tooltipTitle: i18n("Zoom Out")
            tooltipText: i18n("Zoom out your interface to gain more space.")
        }

        PlasmaComponents.Slider {
            id: zoomSliderIt
            minimumValue: 30
            maximumValue: 75
            value: 50
            width: container.width - zoomOutButton.width * 2
            anchors.verticalCenter: parent.verticalCenter
            onValueChanged:mainView.forceActiveFocus();
        }

        IconButton {
            id: zoomInButton
            width: zoomOutButton.width
            height: width
            icon: "zoom-in"
            smooth: true

            onClicked: { zoomSliderIt.value++; }
            tooltipTitle: i18n("Zoom In")
            tooltipText: i18n("Zoom in your interface to focus more on items.")
        }
    }
}
