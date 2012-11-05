// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import org.kde.plasma.components 0.1 as PlasmaComponents

import "../helptour/uielements"
import "../helptour"

DialogTemplate2{
    id:aboutDialogT
    anchors.centerIn: mainView

    insideWidth: page1.width
    insideHeight: page1.height

    dialogTitle: i18n("About Dialog")+"..."
    isModal: true
    forceModality: true
    showButtons:false

    property int smallFont:0.03*insideHeight
    property int mediumFont:1.25*smallFont

    TourPage{
        id:page1

        anchors.left: parent.left
        anchors.leftMargin: parent.margins.left
        anchors.top:parent.top
        anchors.topMargin:parent.margins.top+10

        width:0.7*mainView.width
        height:0.6*mainView.height

        Rectangle{
            id:logoBanner

            radius:5
            color:"#909090"

            width:0.9*parent.width
            height:0.15*parent.height

            anchors.top:parent.top
            anchors.topMargin:25
            anchors.horizontalCenter: parent.horizontalCenter
            Image{
                source:"../Images/Logo.png"
                height:0.9*parent.height
                width:5.42*height
                anchors.centerIn: parent
            }

            Image{
                source:"../Images/CircleLight.png"
                anchors.top:parent.top
                anchors.right: parent.right
                height:0.8*parent.height
                width:height
            }
        }



        AnimatedText{
            id:versionText
            fullText:i18n("Plasmoid Version:")+" <i>"+mainView.version+"</i>"

            font.pixelSize: smallFont
            font.bold: true

            color:defColor

            width:parent.width
            horizontalAlignment: Text.AlignRight

            anchors.top:logoBanner.bottom
            anchors.topMargin:5
            anchors.right: logoBanner.right

        }

        property int defTextSize:0.6*width

        AnimatedText{
            id:authorsTitleTxt
            fullText:i18n("Author(s):")

            font.pixelSize: mediumFont

            color:defColor

            width:parent.defTextSize

            y:0.3*parent.height

            anchors.left: parent.left
            anchors.leftMargin: 0.025*parent.width

        }

        AnimatedText{
            id:authorsTxt
            fullText: "Michail Vourlakos"

            font.pixelSize: mediumFont
            font.italic: true

            color:defColor

            width:parent.defTextSize

            anchors.left: authorsTitleTxt.left
            anchors.leftMargin: 0.04*parent.width
            anchors.top: authorsTitleTxt.bottom
            anchors.topMargin: 2

        }


        AnimatedText{
            id:webTitleTxt
            fullText:i18n("Project Website:")

            font.pixelSize: mediumFont

            color:defColor

            width:parent.defTextSize

            anchors.top:authorsTxt.bottom
            anchors.topMargin: 0.025*parent.width

            anchors.left: authorsTitleTxt.left
        }

        AnimatedText{
            id:webTxt
            fullText: "http://workflow.opentoolsandspace.org/"

            font.pixelSize: mediumFont
            font.italic: true

            color:defColor

            width:parent.defTextSize

            anchors.left: webTitleTxt.left
            anchors.leftMargin: 0.04*parent.width
            anchors.top: webTitleTxt.bottom
            anchors.topMargin: 2

            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                onClicked:{
                    Qt.openUrlExternally(webTxt.fullText);
                }
                onEntered:{
                    webTxt.font.underline = true
                }
                onExited:{
                    webTxt.font.underline = false
                }
            }

        }

        AnimatedText{
            id:licenseTitleTxt

            fullText:i18n("License:")
            font.pixelSize: mediumFont

            color:defColor

            width:parent.defTextSize

            anchors.top:webTxt.bottom
            anchors.topMargin: 0.025*parent.width

            anchors.left: webTitleTxt.left
        }

        AnimatedText{
            id:licenseTxt
            fullText: "GNU General Public License,<br/>ver.2.0 (GPL-2.0)"

            font.pixelSize: mediumFont
            font.italic: true

            color:defColor

            width:parent.defTextSize

            anchors.left: licenseTitleTxt.left
            anchors.leftMargin: 0.04*parent.width
            anchors.top: licenseTitleTxt.bottom
            anchors.topMargin: 2

            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                onClicked:{
                    Qt.openUrlExternally("http://opensource.org/licenses/gpl-2.0.php");
                }
                onEntered:{
                    licenseTxt.font.underline = true
                }
                onExited:{
                    licenseTxt.font.underline = false
                }
            }

        }


        AnimatedLine{
            id:line1

            height:1
            color:defColor
            opacity:0.7

            y:authorsTitleTxt.y+authorsTitleTxt.height
            x:0.65*parent.width - lengthEnd

            isVertical: false
            lengthEnd: 0.4*parent.height

            startRotation: 0
            endRotation: -90

            transformOrigin: Item.TopRight
        }

        AnimatedText{
            id:translatorsTitleTxt
            fullText:i18n("Translator(s):")

            font.pixelSize: smallFont

            color:defColor

            width:0.3*parent.width

            x:line1.x+line1.lengthEnd+authorsTitleTxt.height
            anchors.top:authorsTitleTxt.top

        }

        AnimatedText{
            id:translatorsTxt
            fullText: "Michail Vourlakos(Greek)\nOpen Source Community(Spanish)\nOpen Source Community(German)"

            font.pixelSize: smallFont
            font.italic: true

            color:defColor

            width:0.3*parent.width

            anchors.left: translatorsTitleTxt.left
            anchors.leftMargin: 0.025*parent.width
            anchors.top: translatorsTitleTxt.bottom
            anchors.topMargin: 2

        }
    }



    PlasmaComponents.Button{
        id:exitBtn
        anchors.left: parent.left
        anchors.leftMargin: parent.margins.left
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.margins.bottom+10
        text:i18n("Close")
        iconSource:instanceOfThemeList.icons.Exit

        onClicked:{
            completed();
        }
    }


    PlasmaComponents.Button{
        id:bugsAndFeaturesBtn
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.margins.bottom+10
        text:i18n("Report Bug<br/>Request Feature")
        iconSource:instanceOfThemeList.icons.Bugs

        onClicked:{
            Qt.openUrlExternally("https://github.com/psifidotos/workflow-project/issues");
        }
    }

    PlasmaComponents.Button{
        id:helpTourBtn
        anchors.right: parent.right
        anchors.rightMargin: parent.margins.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.margins.bottom+10

        text:i18n("Help Tour")
        iconSource:instanceOfThemeList.icons.HelpTour

        onClicked:{
            completed();
            mainView.getDynLib().showLiveTourDialog();
        }
    }


    function openD(){
        open();
        page1.startAnimation();
    }


    Connections {
        target: aboutDialogT
        onClickedOk:{
            completed();
        }

        onClickedCancel:{
            completed();
        }
    }
}
