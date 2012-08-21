// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import "uielements"

TourPage{
    id:trPage5
    pageTitle: i18n("Final Tips")

    HeadingB{
        id:titleExplaination
        text:i18n("Final Guidelines")
        width:parent.width-40
        pixelSize: bigFont
        bold: true
        horizontalAlignment: Text.AlignLeft
        anchors.left: parent.left
        anchors.top:parent.top
        anchors.topMargin:10
    }

    AnimatedText{
        id:mainExplaination
        anchors.top:titleExplaination.bottom
        anchors.topMargin:25

        width:0.9*parent.width

        font.bold:true
        font.italic: true
        font.pixelSize: bigFont

        fullText:i18n("I hope this tour helped you understand a bit the concept of Activities and Workareas. For information about the various actions which will help you represent your unique WorkFlow, you can always focus on the various tooltips around.<br/>Dont forget that the plasmoid has also a Configuration Dialog which may be of good use.")
    }


    AnimatedText{
        id:theEnd
        y:0.6*insideHeight
        anchors.right: parent.right
        anchors.rightMargin: 0.2*insideWidth

        font.bold:true
        font.italic: true
        font.pixelSize: bigFont
        horizontalAlignment: Text.AlignRight
        width:parent.width

        fullText:i18n("Let's be creative...<br><br/>- End Of Tour -")
    }


}
