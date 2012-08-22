// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import "uielements"
import "../ui/"

import org.kde.plasma.components 0.1 as PlasmaComponents

DialogTemplate2 {

    id:mainTourWin

    //width:mainView.width
    //height:mainView.height

    //color: "#ca151515"
    anchors.centerIn: mainView


    //insideWidth: mainView.width-5*margins.left-5*margins.right
    insideWidth: mainView.width-margins.left-margins.right-2*closeBtnSize
    insideHeight: mainView.height-margins.top-margins.bottom-3*closeBtnSize

    property int smallFont:0.019*insideHeight
    property int mediumFont:0.025*insideHeight
    property int bigFont:0.035*insideHeight
    property int largeFont:0.06*insideHeight

    //  dialogTitle: i18n("Help Tour")+"..."

    isModal: true
    forceModality: true
    showButtons: false
    showTitleLine: false

    signal completed();

    property int currentPage:0
    property int totalPages:0

    Behavior on opacity{
        NumberAnimation {
            duration: 2*mainView.animationsStep;
            easing.type: Easing.InOutQuad;
        }
    }

    Text{
        color:"#4c4c4c"
        text:i18n("WorkFlow Project - Tour Guide")
        font.pixelSize: 0
        font.bold: true
        font.italic: true
        anchors.bottom: parent.bottom
        anchors.bottomMargin:margins.bottom
        x:tourPage1.x+tourPage1.width/2-width/2
    }

    Rectangle{

        id:leftColumn
        y:0.35*insideHeight
        color:"#d7d7d7"
        width:0.12*insideWidth
        height:0.35*insideHeight
        anchors.left:parent.left
        anchors.leftMargin:10

        radius:5

        clip:true

        Rectangle{
            id:flashRect
            y:width

            height:parent.width
            width:0.05*parent.height

            rotation: -90
            transformOrigin: Item.TopLeft

            gradient: Gradient {
                GradientStop { position: 0.0; color:"#00ffffff" }
                GradientStop { position: 0.35; color: "#99ffffff" }
                GradientStop { position: 0.65; color: "#99ffffff" }
                GradientStop { position: 1.0; color: "#00ffffff" }
            }

        }
        Text{
            id:chaptersTxt
            text:i18n("Chapters")
            font.pixelSize: mediumFont
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
            y:flashRect.width+5
        }


        ListView{
            id:titlesColumn

            width:parent.width
            height:0.8*parent.height
            spacing:5

            anchors.top:chaptersTxt.bottom
            anchors.topMargin:0.05*parent.height

            model:ListModel{}

            delegate:Item{
                width:parent.width
                height:chapText.height+4

                Rectangle{
                    width:parent.width
                    height:(index!== currentPage) ? 1 : parent.height
                    color:(index!== currentPage) ? "#a1a1a1" : "#6c6c6c"
                    y:(index!== currentPage) ? parent.height - 1 : 0
                }

                TextB{
                    id:chapText

                    text:(index+1)+". "+Title;

                    width:(index!== currentPage) ? 0.95*parent.width:0.9*parent.width

                    color:(index!== currentPage) ? "#6c6c6c" : "#efefef"

                    anchors.left: parent.left
                    anchors.leftMargin:(index!== currentPage) ? 0.05*parent.width:0.1*parent.width
                    anchors.verticalCenter: parent.verticalCenter

                    elide:Text.ElideRight

                    font.pixelSize: smallFont
                    font.bold: (index!== currentPage) ? false:true
                    font.italic: (index!== currentPage) ? false:true

                    wrapMode: Text.WordWrap
                }
                MouseArea{
                    anchors.fill:parent
                    onClicked:{
                        showPage(index);
                    }
                }
            }

            Rectangle{
                width:parent.width
                height:1
                color:"#a1a1a1"
                anchors.top:parent.top
            }

        }
    }


    Rectangle{
        id:leftSepLine
        width:1
        height:0.5*insideHeight
        anchors.left: leftColumn.right
        anchors.leftMargin: 5
        anchors.verticalCenter: leftColumn.verticalCenter
        color:defColor
        opacity:0.7
    }



    Component.onCompleted: {
        if(children.length>0){
            //titlesRepeater.pagesNames = new Array();
            for(var i=0; i<children.length; i++){
                var chd = children[i];
                if(chd.objectNameType === "TourPage"){

                    totalPages++;
                    titlesColumn.model.append(
                                {"Title": chd.pageTitle}
                                );

                    chd.resetAnimation();
                }
            }
        }
    }

    function page(v){
        var counter = 0;
        for(var i=0; i<children.length; i++){
            var chd = children[i];
            if(chd.objectNameType === "TourPage"){

                if (counter===v)
                    return chd;

                counter++;
            }
        }
    }

    TourPage1{
        id:tourPage1

        anchors.left: leftSepLine.right
        anchors.leftMargin: 20
        anchors.top:parent.top
        anchors.topMargin:margins.top+10
        width:0.85*insideWidth
        height: insideHeight
    }

    TourPage2{
        id:tourPage2

        anchors.left: leftSepLine.right
        anchors.leftMargin: 20
        anchors.top:parent.top
        anchors.topMargin:margins.top+10
        width:0.85*insideWidth
        height: insideHeight
    }

    TourPage3{
        id:tourPage3

        anchors.left: leftSepLine.right
        anchors.leftMargin: 20
        anchors.top:parent.top
        anchors.topMargin:margins.top+10
        width:0.85*insideWidth
        height: insideHeight
    }

    TourPage4{
        id:tourPage4

        anchors.left: leftSepLine.right
        anchors.leftMargin: 20
        anchors.top:parent.top
        anchors.topMargin:margins.top+10
        width:0.85*insideWidth
        height: insideHeight
    }

    TourPage5{
        id:tourPage5

        anchors.left: leftSepLine.right
        anchors.leftMargin: 20
        anchors.top:parent.top
        anchors.topMargin:margins.top+10
        width:0.85*insideWidth
        height: insideHeight
    }

    PlasmaComponents.Button{
        id:previousBtn
        enabled:currentPage>0
        anchors.left: leftColumn.right
        anchors.leftMargin: 0.1*insideWidth
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.margins.bottom+10
        width:150
        text:i18n("Previous")
        iconSource:instanceOfThemeList.icons.Previous

        onClicked:{
            showPage(currentPage-1);
        }
    }

    PlasmaComponents.Button{
        id:nextBtn
        enabled:currentPage<totalPages-1
        anchors.right: parent.right
        anchors.rightMargin: 0.1*insideWidth
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.margins.bottom+10
        width:150
        text:i18n("Next")
        iconSource:instanceOfThemeList.icons.Next

        onClicked:{
            showPage(currentPage+1);
        }
    }

    PlasmaComponents.Button{
        id:exitBtn
        anchors.left: parent.left
        anchors.leftMargin: parent.margins.left
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.margins.bottom+10
        width:100
        text:i18n("Close")
        iconSource:instanceOfThemeList.icons.Exit

        onClicked:{
            completed();
        }
    }


    function showPage(v){
        if((v>-1)&&
                (v<totalPages)&&
                (v!==currentPage)){

            page(currentPage).resetAnimation();
            page(v).startAnimation();
            currentPage = v;
        }
    }


    function openD(){
        page(0).startAnimation();
        open();
    }

    Connections {
        target: mainTourWin
        onClickedOk:{
            completed();
        }

        onClickedCancel:{
            completed();
        }
    }

}
