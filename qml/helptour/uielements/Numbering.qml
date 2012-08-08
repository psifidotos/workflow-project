// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    property int num

    color:"#f6f6f6"
    radius: width/2

    height:width

    Text{

        color:"#111111"
        text:parent.num

        font.bold: true
        font.pixelSize: 0.8*parent.height
        font.family: "Helvetica"

        anchors.centerIn:parent

    }
}
