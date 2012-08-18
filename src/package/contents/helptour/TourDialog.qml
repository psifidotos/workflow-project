// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import "uielements"
import "../ui/"

DialogTemplate2 {

    id:mainTourWin

    //width:mainView.width
    //height:mainView.height

    //color: "#ca151515"
    anchors.centerIn: mainView


    insideWidth: mainView.width-2*margins.left-2*margins.right
    insideHeight: mainView.height-4*margins.top-3*margins.bottom

    property int smallFont:0.018*insideHeight
    property int mediumFont:0.02*insideHeight
    property int bigFont:0.04*insideHeight
    property int largeFont:0.07*insideHeight

  //  dialogTitle: i18n("Help Tour")+"..."

    isModal: true
    forceModality: false
    showButtons: false

    signal completed();

    Behavior on opacity{
        NumberAnimation {
            duration: 2*mainView.animationsStep;
            easing.type: Easing.InOutQuad;
        }
    }

/*
    MouseArea{
        anchors.fill: parent
        hoverEnabled: true
        onClicked:completed();
    }*/

    ListView{
        id:titlesColumn
        y:0.3*insideHeight
        width:0.1*insideWidth
        anchors.left:parent.left
        anchors.leftMargin:6
        model:ListModel{}

        delegate:TextB{
            width:0.1*insideWidth
            elide:Text.ElideRight
            //font.family: mainView.defaultFont.family
            font.pixelSize: mediumFont

            text:(index+1)+". "+Title;
            wrapMode: Text.WordWrap
            //color:defColor
        }

    }


    Rectangle{
        width:1
        height:0.5*insideHeight
        anchors.left: titlesColumn.right
        anchors.leftMargin: 5
        anchors.verticalCenter: parent.verticalCenter
        color:defColor
        opacity:0.7
    }



    Component.onCompleted: {
        if(children.length>0){
            //titlesRepeater.pagesNames = new Array();
            for(var i=0; i<children.length; i++){
                var chd = children[i];
                if(chd.objectNameType === "TourPage"){
                    titlesColumn.model.append(
                                {"Title": chd.pageTitle}
                                );

                    chd.resetAnimation();
                }
            }
        }
    }

    TourPage1{
        id:tourPage1

        anchors.left: titlesColumn.right
        anchors.top:parent.top
        anchors.topMargin:margins.top+10
        width:0.9*insideWidth
        height: insideHeight
    }





    Rectangle{
        color:"blue"
        x:10
        y:10
        width:40
        height:width

        MouseArea{
            anchors.fill: parent
            onClicked:{
                tourPage1.startAnimation();
            }
        }
    }

    Rectangle{
        color:"red"
        x:60
        y:10
        width:40
        height:width

        MouseArea{
            anchors.fill: parent
            onClicked:{
                tourPage1.resetAnimation();
            }
        }
    }

    function startAnimation(){
        opacity = 1;
    }

    function resetAnimation(){

    }

    function openD(){
        open();
        startAnimation();
    }

}
