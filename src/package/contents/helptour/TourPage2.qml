// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import "uielements"
import org.kde.qtextracomponents 0.1


TourPage{
    id:trPage2
    pageTitle: i18n("Interface")

    HeadingB{
        id:titleExplaination
        text:i18n("Explaining the Interface")
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
        anchors.topMargin:15

        width:0.95*parent.width

        font.bold:true
        font.pixelSize: mediumFont

        onlyOpacity: true

        fullText:i18n("Let's see how the previous mentioned example could be represented in our WorkFlow.In the main area there are two running activities <font color=\"#a1b6f7\"><i>\"Vacation Planning\"</i></font> and <font color=\"#a1b6f7\"><i>\"University Studies\"</i></font>.<br/> On the stopped(paused) activities area you can find the third Activity <font color=\"#a1b6f7\"><i>\"Chess Hobby\"<i></font> which does not consume any resources but is always avaible to restore it.<br/><br/> The <font color=\"#a1b6f7\"><i>\"Vacation Planning\"</i></font> Activity is sub-organized into three <b>WorkAreas</b>:<br/>  <font color=\"#ea7b7b\"><i>\"Sightseeing information\"</i>, <i>\"Hotels\"</i>, <i>\"Restaurants\"</i> </font> <br/><br/> and on the other hand Activity <font color=\"#a1b6f7\"><i>\"University Studies\"</i></font> contains two WorkAreas:<br/> <font color=\"#ea7b7b\"><i>\"Computer Science\"</i></font> and <font color=\"#ea7b7b\"><i>\"Mathematics I\"</i></font>")
    }

    AnimatedLine{
        id:separationLine1

        y:mainExplaination.height+titleExplaination.height+40

        width:1
        lengthEnd:0.6*parent.height
        isVertical:true
        color:defColor
        startRotation: 0
        endRotation: -90
        transformOrigin:Item.Top
        opacity:0.5
    }

    AnimatedLine{
        id:separationLine2

        x:actWorkTitle1.x-0.05*insideWidth
        y:actWorkTitle1.y+actWorkTitle1.height+3

        width:2
      //  lengthEnd:0.5*insideWidth
        lengthEnd:actWorkTitle2.x+actWorkTitle2.width-actImag1.x+0.1*insideWidth
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
        //x:actWorkTitle1.x+0.1*insideWidth
        y:actWorkTitle1.y-0.05*insideHeight

        height:2
      //  lengthEnd:0.1.insideHeight+workareasImages.height
        //lengthEnd:actWorkTitle2.x+actWorkTitle2.width - (actWorkTitle1.x+actWorkTitle1.width/2) +
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
        id:actImag1
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

        property int margY:0.04*insideHeight
        property int margX:0.15*parent.width

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
            height:0.10*trPage2.height
            width:ratio*height
            source:"../Images/backgrounds/emptydesk2.png"
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
                text:i18n("Sightseeing Information");
            }
        }

        Image{
            height:0.10*trPage2.height
            width:ratio*height
            source:"../Images/backgrounds/emptydesk2.png"
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
                text:i18n("Hotels");
            }
        }

        Image{
            height:0.10*trPage2.height
            width:ratio*height
            source:"../Images/backgrounds/emptydesk2.png"
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
                text:i18n("Restaurants");
            }
        }
    }


    //Second Active Activity

    QIconItem{
        id:act2Icon
        icon:QIcon("plasma")
        height:0.05*insideHeight
        width:height

        property int margX:10
      //  enabled:false
        opacity:0.9
        anchors.left: actWorkTitle1.right
        anchors.leftMargin: margX
//        anchors.right: actWorkTitle2.left
 //       anchors.rightMargin: 2
        anchors.bottom: actWorkTitle2.bottom
    }

    TextB{
        id:actWorkTitle2

        property int margX:0.08*parent.width

        anchors.top:actWorkTitle1.top
        anchors.left: act2Icon.right
        anchors.leftMargin: 2


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
            height:0.10*trPage2.height
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
                text:i18n("Computer Science");
            }
        }

        Image{
            height:0.10*trPage2.height
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

}
