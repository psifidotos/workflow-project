// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import "uielements"
import "../delegates/ui-elements"

TourPage{
    id:trPage3
    pageTitle: i18n("Windows")

    HeadingB{
        id:titleExplaination
        text:i18n("Windows in Activities")
        width:parent.width-40
        pixelSize: bigFont
        bold: true
        horizontalAlignment: Text.AlignLeft
        anchors.left: parent.left
        anchors.top:parent.top
        anchors.topMargin:10
    }

    TextB{
        id:mainExplaination
        anchors.top:titleExplaination.bottom
        anchors.topMargin:25

        width:0.8*parent.width

        font.bold:true
        font.pixelSize: mediumFont

        text:i18n("Windows in Activities in order to correspond in a general and simple WorkFlow are enhanced and support three basic states.")
    }


    AnimatedLine{
        id:separationLine1

        anchors.top:mainExplaination.bottom
        anchors.topMargin:10

        width:1
        lengthEnd:0.6*parent.height
        isVertical:true
        color:defColor
        startRotation: 0
        endRotation: -90
        transformOrigin:Item.Top
        opacity:0.5
    }

    WindowPlaceButton{
        id:singleState
        allDesks:true
        allActiv:true
        width:0.15*insideHeight
        height:width
        y:0.32*insideHeight
        x:0.2*insideHeight
        enabled:false
    }

    WindowPlaceButton{
        id:allDesksState
        allActiv: false
        allDesks: false
        width:0.15*insideHeight
        height:width
        anchors.left: singleState.left
        anchors.top: singleState.top
        anchors.topMargin:height
        enabled:false
    }

    WindowPlaceButton{
        id:sameWorksState
        allActiv: false
        allDesks: true
        width:0.15*insideHeight
        height:width
        anchors.left: allDesksState.left
        anchors.top: allDesksState.top
        anchors.topMargin:height
        enabled:false
    }

    WindowPlaceButton{
        id:everywhereState
        allActiv: true
        allDesks: false
        width:0.15*insideHeight
        height:width
        anchors.left: sameWorksState.left
        anchors.top: sameWorksState.top
        anchors.topMargin:height
        enabled:false
    }


    AnimatedLine{
        id:separationLine2

        x:singleState.x+singleState.width+5

        y:singleState.y-10

        height:2
        lengthEnd:0.5*parent.height
        isVertical:false
        color:defColor
        startRotation: 0
        endRotation: 90
        transformOrigin:Item.TopLeft
        opacity:0.5
    }

    AnimatedText{
        id:singleExplaination
        x:separationLine2.x+20
        anchors.verticalCenter: singleState.verticalCenter

        width:0.6*parent.width

        font.bold:true
        font.pixelSize: mediumFont

        onlyOpacity: false

        fullText:i18n("1. In <font color=\"#ea7b7b\"><i>\"Single\"</i></font> state the window will be available only in one specific Workarea.")
    }

    AnimatedText{
        id:allDesksExplaination
        x:separationLine2.x+20
        anchors.verticalCenter: allDesksState.verticalCenter

        width:0.6*parent.width

        font.bold:true
        font.pixelSize: mediumFont

        onlyOpacity: false

        fullText:i18n("2. In <font color=\"#ea7b7b\"><i>\"All Workareas\"</i></font> state the window will be available in every Workarea for specific Activity.")
    }

    AnimatedText{
        id:sameWorksExplaination
        x:separationLine2.x+20
        anchors.verticalCenter: sameWorksState.verticalCenter

        width:0.6*parent.width

        font.bold:true
        font.pixelSize: mediumFont

        onlyOpacity: false

        fullText:i18n("3. In <font color=\"#ea7b7b\"><i>\"Same Workareas\"</i></font> state the window will be available in the same Workareas (position) in all Activities.")
    }

    AnimatedText{
        id:everyExplaination
        x:separationLine2.x+20
        anchors.verticalCenter: everywhereState.verticalCenter

        width:0.6*parent.width

        font.bold:true
        font.pixelSize: mediumFont

        onlyOpacity: false

        fullText:i18n("4. In <font color=\"#ea7b7b\"><i>\"Everywhere\"</i></font> state the window will be available in every Workarea and every Activity.")
    }

}
