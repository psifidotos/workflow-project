// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {

    property alias bold:headText.font.bold
    property alias italic:headText.font.italic
    property alias horizontalAlignment: headText.horizontalAlignment
    property alias pixelSize: headText.font.pixelSize

    property alias text:headText.text

    color:"#cfcfcf"
    radius:0.05*height

    property int margins:0.5*pixelSize
    height:pixelSize+margins
    TextB{
        id:headText

        color:"#242424"
        width:parent.width-margins
        height:parent.height-margins
        anchors.centerIn: parent
    }
}
