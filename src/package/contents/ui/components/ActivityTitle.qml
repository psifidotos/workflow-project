import QtQuick 1.1
import org.kde.plasma.components 0.1 as PlasmaComponents

Item {
    id: container
    property string text: ""
    property bool locked: true
    property alias containsMouse: mouseArea.containsMouse
    focus: true

    signal clicked

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        enabled: !locked
        opacity: locked ? 0 : 1
        onDoubleClicked: textField.forceActiveFocus()
        onClicked: container.clicked
    }

    Text{
        id: activityName
        text: container.text
        anchors.fill: parent
        verticalAlignment: Text.AlignBottom
        wrapMode: TextEdit.Wrap

        opacity: editor.opacity === 1 ? 0 : 1

        color: "white"
        font.family: mainView.defaultFont.family
        font.bold: true
        font.italic: true
        font.pixelSize: 0.2 * parent.height
    }

    FocusScope {
        id: editor
        opacity: textField.activeFocus ? 1 : 0
        anchors.fill: parent
        property alias font: textField.font

        Row {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            PlasmaComponents.TextField {
                id: textField
                width: parent.width - acceptIcon.width
                text: container.text
                focus: true
                onAccepted: {
                    container.text = text
                    container.forceActiveFocus()
                    var service = activitySource.serviceForSource(model["DataEngineSource"])
                    var operation = service.operationDescription("setName")
                    operation.Name = text
                    service.startOperationCall(operation)
                }
                onActiveFocusChanged: {
                    if (!activeFocus) {
                        textField.text = container.text
                    }
                }
                font: activityName.font
            }
            IconButton {
                id: acceptIcon
                anchors.verticalCenter: parent.verticalCenter
                icon: "dialog-ok-apply"
                width: 24
                height: 24
                onClicked: textField.accepted()
            }
            Keys.onPressed: {
                if (event.key === Qt.Key_Escape) {
                    container.forceActiveFocus()
                }
            }
        }
    }
}
