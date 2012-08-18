// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item{
    property int number
    property string text1
    property int lineHeight

    Numbering{
        id:numCounter
        num:parent.number
        width:parent.lineHeight
    }

    Text{
        id:animText
        anchors.left: numCounter.right
        anchors.leftMargin: 2
        text:parent.text1

        font.family: "Helvetica"
        font.pixelSize: 0

        width:parent.width - numCounter.width - 2

        //color:"#f5f5f5"
        color:defColor
    }

}
