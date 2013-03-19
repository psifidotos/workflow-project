// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.plasma.extras 0.1 as PlasmaExtras

import "../helptour/uielements"
import "../helptour"

DialogTemplate2{
    id:aboutDialogT

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

        width:0.85*mainView.width
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
            fullText:i18n("Plasmoid Version:")+" <i>"+plasmoidWrapper.version+"</i>"

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

        PlasmaComponents.Label{
            id:authorsTitleTxt
            text:i18n("Author(s):")
            y:0.3*parent.height

            anchors.left: parent.left
            anchors.leftMargin: 0.025*parent.width
            font.pointSize: theme.defaultFont.pointSize+2
            font.weight: Font.Bold
            font.italic: true
        }


        PlasmaComponents.Label{
            id:authorsTxt
            text: "Michail Vourlakos"

            width:parent.defTextSize

            anchors.left: authorsTitleTxt.left
            anchors.leftMargin: 0.04*parent.width
            anchors.top: authorsTitleTxt.bottom
            anchors.topMargin: 2

            font.pointSize: theme.defaultFont.pointSize+1
            font.italic: true
        }

        PlasmaComponents.Label{
            id:webTitleTxt
            text:i18n("Project Website:")

            anchors.top:authorsTxt.bottom
            anchors.topMargin: 0.025*parent.width
            anchors.left: authorsTitleTxt.left

            font.pointSize: theme.defaultFont.pointSize+2
            font.weight: Font.Bold
            font.italic: true
        }

        PlasmaComponents.Label{
            id:webTxt
            text: "http://workflow.opentoolsandspace.org/"

            anchors.left: webTitleTxt.left
            anchors.leftMargin: 0.04*parent.width
            anchors.top: webTitleTxt.bottom
            anchors.topMargin: 2

            font.pointSize: theme.defaultFont.pointSize+1
            font.italic: true

            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                onClicked:{
                    Qt.openUrlExternally(webTxt.text);
                }
                onEntered:{
                    webTxt.font.underline = true
                }
                onExited:{
                    webTxt.font.underline = false
                }
            }
        }


        PlasmaComponents.Label{
            id:licenseTitleTxt
            text:i18n("License:")

            anchors.top:webTxt.bottom
            anchors.topMargin: 0.025*parent.width
            anchors.left: webTitleTxt.left

            font.pointSize: theme.defaultFont.pointSize+2
            font.weight: Font.Bold
            font.italic: true
        }

        PlasmaComponents.Label{
            id:licenseTxt
            text: "GNU General Public License,<br/>ver.2.0 (GPL-2.0)"

            anchors.left: licenseTitleTxt.left
            anchors.leftMargin: 0.04*parent.width
            anchors.top: licenseTitleTxt.bottom
            anchors.topMargin: 2

            font.pointSize: theme.defaultFont.pointSize+1
            font.italic: true

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
            x:0.5*parent.width - lengthEnd

            isVertical: false
            lengthEnd: 0.4*parent.height

            startRotation: 0
            endRotation: -90

            transformOrigin: Item.TopRight
        }

        Item{
            id: navigation
            x:line1.x+line1.lengthEnd+authorsTitleTxt.height
            anchors.top:authorsTitleTxt.top
            width:0.45*parent.width
            height:0.6 * parent.height

            PlasmaComponents.TabBar {
                id: appTabBar
                anchors { left: parent.left; right: parent.right; top: parent.top}

                PlasmaComponents.TabButton {
                    id: contributorsBtn
                    tab: contribsPage
                    text: i18n("Contributors")
                    iconSource: "x-office-contact"
                }
                PlasmaComponents.TabButton {
                    id: translatorsBtn
                    tab: translatorsPage
                    text: i18n("Translators")
                    iconSource: "x-office-contact"
                }
            }

            PlasmaComponents.TabGroup {
                id: tabGroup
                anchors { left: parent.left; right: parent.right; top: appTabBar.bottom; topMargin: 5; bottom: parent.bottom }

                PlasmaComponents.Page{
                    id:contribsPage

                    Flickable{
                        id:flick2
                        anchors.fill: parent
                        width: navigation.width
                        height: navigation.height

                        contentWidth: paragraph2.width
                        contentHeight: paragraph2.height

                        clip: true

                        boundsBehavior: Flickable.StopAtBounds
                        PlasmaExtras.Paragraph {
                            id:paragraph2
                            width: tabGroup.width-20

                            text: "Michael Daffin\nBogdan Mihaila "
                        }
                    }

                    PlasmaComponents.ScrollBar{
                        flickableItem: flick1
                        orientation:Qt.Vertical
                        stepSize:3
                    }
                }

                PlasmaComponents.Page{
                    id:translatorsPage

                    Flickable{
                        id:flick1
                        anchors.fill: parent
                        width: navigation.width
                        height: navigation.height

                        contentWidth: paragraph1.width
                        contentHeight: paragraph1.height

                        clip: true

                        boundsBehavior: Flickable.StopAtBounds
                        PlasmaExtras.Paragraph {
                            id:paragraph1
                            width: tabGroup.width-20
                            horizontalAlignment: Text.AlignLeft

                            text: "\
Anthony David Atencio Moscote(Spanish)\n\
Rodrigo Emmanuel Santana Borges(Portuguese)\n\
Michail Vourlakos(Greek)\n\
Open Source Community(French)\n\
Open Source Community(German)\n"
                        }
                    }

                    PlasmaComponents.ScrollBar{
                        flickableItem: flick1
                        orientation:Qt.Vertical
                        stepSize:3
                    }
                }
            }

        }//Item
    }



    PlasmaComponents.Button{
        id:exitBtn
        anchors.left: parent.left
        anchors.leftMargin: parent.margins.left
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.margins.bottom+10
        text:i18n("Close")
        iconSource:"dialog-close"

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
        iconSource:"help-hint"

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
        iconSource:"help-contents"

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
