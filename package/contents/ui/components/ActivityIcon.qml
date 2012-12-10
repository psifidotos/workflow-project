import QtQuick 1.1
import org.kde.workflow.components 0.1
import org.kde.qtextracomponents 0.1

Item {
    id: container
    property alias containsMouse: mouseArea.containsMouse
    property int size: 55
    width: size
    height: size
    property alias icon: icon.icon

    // TODO use the settings value
    property bool locked: true

    QIconItem {
        id: icon
        rotation: mouseArea.containsMouse && !locked ? -10 : 0

        anchors.fill: parent
        smooth: true

        Behavior on rotation{
            NumberAnimation {
                // TODO Use the settings value
                duration: 300
                easing.type: Easing.InOutQuad;
            }
        }
    }
    IconDialog { id: iconDialog}

    MouseArea {
        id: mouseArea
        enabled: !locked
        opacity: locked ? 0 : 1
        anchors.fill: parent
        hoverEnabled: true

        onClicked: {
            var icon = iconDialog.getIcon()

            if (icon != "") {
                var service = activitySource.serviceForSource(model["DataEngineSource"])
                var operation = service.operationDescription("setIcon")
                operation.Icon = icon
                var job = service.startOperationCall(operation)
            }
        }
    }

}
