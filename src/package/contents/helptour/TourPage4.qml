// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import "uielements"
import org.kde.qtextracomponents 0.1


TourPage{
    id:trPage4
    pageTitle: "Full Interface"

    HeadingB{
        id:titleExplaination
        text:i18n("The Complete Interface")
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

        text:i18n("Lets use our previous example of Activities and Workareas, but this time with Windows enabled.<br/> You can observe if you want the three Window states in the following example.<br/><br/>The Okular and Dolphin windows are in <font color=\"#ea7b7b\"><i>\"Single\"</i></font> state.<br/>The Words window is in <font color=\"#ea7b7b\"><i>\"All Workareas\"</i></font> state. <br/>The Amarok window is in <font color=\"#ea7b7b\"><i>\"Everywhere\"</i></font> state.")
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



    /////////////////////////Full Interface//////////////////////////
    AnimatedLine{
        id:separationLine2

        x:actWorkTitle1.x-0.05*insideWidth
        y:actWorkTitle1.y+actWorkTitle1.height+3

        width:2
        lengthEnd:0.5*insideWidth
        isVertical:true
        color:defColor
        startRotation: 0
        endRotation: -90
        transformOrigin:Item.Top
        opacity:0.8

    }

    AnimatedLine{
        id:separationLine3

        x:actWorkTitle1.x-0.1*insideWidth+(separationLine2.lengthEnd-lengthEnd)
        y:actWorkTitle1.y-0.05*insideHeight

        height:2
        lengthEnd:0.4*insideHeight
        isVertical:false
        color:defColor
        startRotation: 0
        endRotation: -90
        transformOrigin:Item.TopRight
        opacity:0.8

    }

    QIconItem{
        icon:QIcon("plasma")
        height:0.05*insideHeight
        width:height
        enabled:false
        opacity:0.4
        anchors.right: actWorkTitle3.right
        anchors.bottom: actWorkTitle3.top
        anchors.bottomMargin: 2
    }

    TextB{
        id:actWorkTitle3
        x:separationLine3.x+separationLine3.lengthEnd+3
        y:separationLine2.y+0.08*insideHeight
        font.bold: true
        font.italic: true
        font.letterSpacing: 1

        font.pixelSize: mediumFont
        text:i18n("Chess Hobby");

    }

    //Running Activities


    property real ratio:1.4

    QIconItem{
        icon:QIcon("plasma")
        height:0.05*insideHeight
        width:height
       // enabled:false
        opacity:0.9
        anchors.right: actWorkTitle1.left
        anchors.rightMargin: 2
        anchors.bottom: actWorkTitle1.bottom
    }

    TextB{
        id:actWorkTitle1

        property int margY:0.1*insideHeight
        property int margX:0.3*parent.width

        y: separationLine1.y+margY
        x: margX


        font.bold: true
        font.italic: true
        font.letterSpacing: 1

        font.pixelSize: mediumFont
        text:i18n("Vacation Planning");
    }


    ColumnB{
        id:workareasImages
        anchors.horizontalCenter: actWorkTitle1.horizontalCenter
        anchors.top: actWorkTitle1.bottom
        anchors.topMargin: 20

        spacing:0.04*parent.height

        Image{
            height:0.10*trPage4.height
            width:ratio*height
            source:"../Images/backgrounds/emptydesk2.png"
            Rectangle{
                border.color: defColor
                border.width: 1
                color:"#00000000"
                width:parent.width
                height:parent.height
            }

            Rectangle{
                anchors.top:parent.top
                anchors.topMargin:5
                color:"#ccffffff"
                width:parent.width
                height:0.2*parent.height
                radius:height/3

                TextB{
                    text:"Words - Various Notes"
                    width:parent.width

                    font.pixelSize: 0.8*parent.height
                    font.bold:true

                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: parent.radius

                    elide:Text.ElideRight

                    color:"#333333"
                }
            }

            TextB{
                anchors.top:parent.bottom
                font.bold: true
                font.italic:true
                elide:Text.ElideRight
                font.pixelSize: smallFont
                text:i18n("Sightseeing Information");
            }
        }

        Image{
            height:0.10*trPage4.height
            width:ratio*height
            source:"../Images/backgrounds/emptydesk2.png"
            Rectangle{
                border.color: defColor
                border.width: 1
                color:"#00000000"
                width:parent.width
                height:parent.height
            }

            Rectangle{
                id:secWind
                anchors.top:parent.top
                anchors.topMargin:5
                color:"#aa333333"
                width:parent.width
                height:0.2*parent.height
                radius:height/3

                TextB{
                    text:"Dolphin - /home/"
                    width:parent.width

                    font.pixelSize: 0.8*parent.height
                    font.bold:true

                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: parent.radius

                    elide:Text.ElideRight

                    color:"#f1f1f1"
                }
            }

            Rectangle{
                anchors.top:secWind.bottom
                anchors.topMargin:5
                color:"#ccffffff"
                width:parent.width
                height:0.2*parent.height
                radius:height/3

                TextB{
                    text:"Words - Various Notes"
                    width:parent.width

                    font.pixelSize: 0.8*parent.height
                    font.bold:true

                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: parent.radius

                    elide:Text.ElideRight

                    color:"#333333"
                }
            }

            TextB{
                anchors.top:parent.bottom
                font.bold: true
                font.italic:true
                elide:Text.ElideRight
                font.pixelSize: smallFont
                text:i18n("Hotels");
            }
        }

        Image{
            height:0.10*trPage4.height
            width:ratio*height
            source:"../Images/backgrounds/emptydesk2.png"
            Rectangle{
                border.color: defColor
                border.width: 1
                color:"#00000000"
                width:parent.width
                height:parent.height
            }

            Rectangle{
                anchors.top:parent.top
                anchors.topMargin:5
                color:"#ccffffff"
                width:parent.width
                height:0.2*parent.height
                radius:height/3

                TextB{
                    text:"Words - Various Notes"
                    width:parent.width

                    font.pixelSize: 0.8*parent.height
                    font.bold:true

                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: parent.radius

                    elide:Text.ElideRight

                    color:"#333333"
                }
            }
            TextB{
                anchors.top:parent.bottom
                font.bold: true
                font.italic:true
                elide:Text.ElideRight
                font.pixelSize: smallFont
                text:i18n("Restaurants");
            }
        }
    }


    //Second Active Activity

    QIconItem{
        icon:QIcon("plasma")
        height:0.05*insideHeight
        width:height
      //  enabled:false
        opacity:0.9
        anchors.right: actWorkTitle2.left
        anchors.rightMargin: 2
        anchors.bottom: actWorkTitle2.bottom
    }

    TextB{
        id:actWorkTitle2

        property int margX:0.08*parent.width

        anchors.top:actWorkTitle1.top
        anchors.left: actWorkTitle1.right
        anchors.leftMargin: margX


        font.bold: true
        font.italic: true
        font.letterSpacing: 1

        font.pixelSize: mediumFont
        text:i18n("University Studies");
    }


    ColumnB{
        id:workareasImages2
        anchors.horizontalCenter: actWorkTitle2.horizontalCenter
        anchors.top: actWorkTitle2.bottom
        anchors.topMargin: 20

        spacing:0.04*parent.height

        Image{
            height:0.10*trPage4.height
            width:ratio*height
            source:"../Images/backgrounds/emptydesk1.png"
            Rectangle{
                border.color: defColor
                border.width: 1
                color:"#00000000"
                width:parent.width
                height:parent.height
            }

            Rectangle{
                id:firstWin
                anchors.top:parent.top
                anchors.topMargin:5
                color:"#aa333333"
                width:parent.width
                height:0.2*parent.height
                radius:height/3

                TextB{
                    text:"Okular - The Secrets of KDe"
                    width:parent.width

                    font.pixelSize: 0.8*parent.height
                    font.bold:true

                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: parent.radius

                    elide:Text.ElideRight

                    color:"#f1f1f1"
                }


            }

            Rectangle{
                anchors.top:firstWin.bottom
                anchors.topMargin:5
                color:"#aa333333"
                width:parent.width
                height:0.2*parent.height
                radius:height/3

                TextB{
                    text:"Dolphin - Best pdfs"
                    width:parent.width

                    font.pixelSize: 0.8*parent.height
                    font.bold:true

                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: parent.radius

                    elide:Text.ElideRight

                    color:"#f1f1f1"
                }

            }


            TextB{
                anchors.top:parent.bottom
                font.bold: true
                font.italic:true
                elide:Text.ElideRight
                font.pixelSize: smallFont
                text:i18n("Computer Science");
            }
        }

        Image{
            height:0.10*trPage4.height
            width:ratio*height
            source:"../Images/backgrounds/emptydesk1.png"
            Rectangle{
                border.color: defColor
                border.width: 1
                color:"#00000000"
                width:parent.width
                height:parent.height
            }
            TextB{
                anchors.top:parent.bottom
                font.bold: true
                font.italic:true
                elide:Text.ElideRight
                font.pixelSize: smallFont
                text:i18n("Mathematics I");
            }
        }

    }

    QIconItem{
        id:amarokIcon
        icon:QIcon("amarok")
        height:0.05*insideHeight
        width:height
        opacity:0.9
        anchors.right: workareasImages.left
        anchors.top: workareasImages.bottom
        anchors.topMargin:0.05*insideHeight
    }

    TextB{
        id:amarokText
        anchors.top:amarokIcon.bottom
        anchors.horizontalCenter: amarokIcon.horizontalCenter
        font.bold: true
        font.italic:true
        font.pixelSize: mediumFont
        text:i18n("Amarok - Sounds of KDe");
    }

    Rectangle{
        x:amarokText.x
        anchors.top:amarokText.bottom
        anchors.topMargin:2
        color:defColor
        width:0.2*insideWidth
        height:2
    }
}
