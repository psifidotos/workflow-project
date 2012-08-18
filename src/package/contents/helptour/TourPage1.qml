// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import "uielements"

TourPage{

    id:trPage1
    pageTitle: "Introduction"

    TextB{
        id:welcomeText1
        text:i18n("Welcome to")
        width:parent.width
        font.pixelSize: bigFont
        font.bold: true
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top:parent.top
        anchors.topMargin:5
    }
    TextB{
        id:welcomeText2
        text:"WorkFlow Project"
        width:parent.width
        font.pixelSize: largeFont
        font.bold: true
        font.italic: true
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top:welcomeText1.bottom
        anchors.topMargin:5
    }

    /*
    TextB{
        id:welcomeText3
        text:i18n("Plasmoid Version: ")+"<i>"+mainView.version+"</i>"
        width:parent.width
        font.pixelSize: bigFont
        horizontalAlignment: Text.AlignHCenter

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top:welcomeText2.bottom
        anchors.topMargin:5
    }*/


    RectangleB{
        id:sepLine1
        y:0.15*parent.height
        color:"#f7f7f7"
        height:2
        width:0.8*parent.width
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top:welcomeText2.bottom
        anchors.topMargin:10
    }

    AnimatedText{
        id:animText1
        width:0.8*parent.width
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top:sepLine1.bottom
        anchors.topMargin:10

        font.pixelSize: mediumFont
        font.bold: true
        fullText:i18n("The WorkFlow Project is an effort which tries to experiment with new technologies of KDE in answering the following question:")
    }
    AnimatedText{
        id:animText2
        width:0.8*parent.width
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top:animText1.bottom
        anchors.topMargin:15
        font.pixelSize: bigFont
        font.bold: true
        font.italic:true
        horizontalAlignment: Text.AlignHCenter
        fullText:i18n("\"What is the most efficient way to use my computer?\"")
    }

    AnimatedText{
        id:animText3
        width:0.8*parent.width
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top:animText2.bottom
        anchors.topMargin:15
        font.pixelSize: mediumFont
        font.bold: true
        fullText:i18n("The most recent answer from the KDE community is by using <b><i><big>Activities</big></i></b>...")
    }

    TextB{
        id:activitiesSpec
        width:0.3*parent.width

        anchors.top:animText3.bottom
        anchors.topMargin:0.05*parent.height
        anchors.right: parent.horizontalCenter
        anchors.rightMargin: 5

        font.pixelSize: mediumFont
        font.bold: true
        horizontalAlignment: Text.AlignRight

        text:i18n("<big><u>Activity</u></big><br/><br/>Is a way to separate your work in different areas. Each activity can have different tools(plasmoids), windows, documents. In that way you can have a different Activity for your <i>"+i18n("Vacation Planning")+"</i>, your <i>"+i18n("University Studies")+"</i>, your <i>"+i18n("Chess Hobby")+"</i> etc.")
    }

    AnimatedParagraph{
        id:workareasSpec
        anchors.top:animText3.bottom
        anchors.topMargin:0.05*parent.height
        anchors.left: activitiesSpec.right
        anchors.leftMargin: 10
        width:0.3*parent.width

        linePlace:"TOP"
        lineForward:true
        lineLength: 0.35*parent.height

        fontBold:true
        fontPixelSize: mediumFont

        textOnlyOpacity:true

        fullText:"<big><u>Workareas(Virtual Desktops)</u></big><br/><br/>Is a way to sub-organize an Activity. For example your <i>Vacation Planning</i> can be separated in <i>"+i18n("Sightseeing information")+"</i>, <i>"+i18n("Hotels")+"</i>, <i>"+i18n("Restaurants")+"</i> etc."
    }

    RowB{
        id:activitiesTitles
        anchors.top: activitiesSpec.bottom
        anchors.topMargin:0.06*parent.height
        anchors.right: activitiesSpec.right

        spacing:0.02*parent.width

        TextB{
            width:activity1Image.width
            font.bold: true
            font.italic:true
            elide:Text.ElideRight
            font.pixelSize: smallFont
            text:i18n("Vacation Planning");
            horizontalAlignment: Text.AlignHCenter
        }

        TextB{
            width:activity1Image.width
            font.bold: true
            font.italic:true
            elide:Text.ElideRight
            font.pixelSize: smallFont
            text:i18n("University Studies");
            horizontalAlignment: Text.AlignHCenter
        }

        TextB{
            width:activity1Image.width
            font.bold: true
            font.italic:true
            elide:Text.ElideRight
            font.pixelSize: smallFont
            text:i18n("Chess Hobby");
            horizontalAlignment: Text.AlignHCenter
        }

    }


    property real ratio:1.4

    RowB{
        anchors.top: activitiesTitles.bottom
        anchors.topMargin:2
        anchors.right: activitiesTitles.right

        spacing:0.02*parent.width

        Image{
            id:activity1Image
            height:0.12*trPage1.height
            width:ratio*height
            source:"../Images/backgrounds/emptydesk2.png"
        }

        Image{
            height:0.12*trPage1.height
            width:ratio*height
            source:"../Images/backgrounds/emptydesk1.png"
        }

        Image{
            height:0.12*trPage1.height
            width:ratio*height
            source:"../Images/backgrounds/emptydesk3.png"
        }

    }
    TextB{
        id:actWorkTitle
        anchors.horizontalCenter: workareasImages.horizontalCenter
        anchors.bottom: workareasImages.top
        anchors.bottomMargin:5
        width:0.3*parent.width

        horizontalAlignment: Text.AlignHCenter

        font.bold: true
        font.italic: true
        font.letterSpacing: 1

        font.pixelSize: smallFont
        text:i18n("Vacation Planning");
    }


    ColumnB{
        id:workareasImages
        anchors.left: workareasSpec.right
        anchors.leftMargin: 0.03*parent.width
        anchors.top: workareasSpec.top
        anchors.topMargin: 0.1*trPage1.height

        spacing:0.02*parent.height

        Image{
            height:0.10*trPage1.height
            width:ratio*height
            source:"../Images/backgrounds/emptydesk2.png"

            TextB{
                anchors.top:parent.bottom
                width:parent.width
                font.bold: true
                font.italic:true
                elide:Text.ElideRight
                font.pixelSize: 0.015*trPage1.height
                text:i18n("Sightseeing Information");
            }
        }

        Image{
            height:0.10*trPage1.height
            width:ratio*height
            source:"../Images/backgrounds/emptydesk2.png"
            TextB{
                anchors.top:parent.bottom
                width:parent.width
                font.bold: true
                font.italic:true
                elide:Text.ElideRight
                font.pixelSize: 0.015*trPage1.height
                text:i18n("Hotels");
            }
        }

        Image{
            height:0.10*trPage1.height
            width:ratio*height
            source:"../Images/backgrounds/emptydesk2.png"
            TextB{
                anchors.top:parent.bottom
                width:parent.width
                font.bold: true
                font.italic:true
                elide:Text.ElideRight
                font.pixelSize: 0.015*trPage1.height
                text:i18n("Restaurants");
            }
        }


    }


}
