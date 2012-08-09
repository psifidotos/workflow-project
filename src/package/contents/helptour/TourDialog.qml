// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import "uielements"

Rectangle {

    id:mainTourWin

    width:mainView.width
    height:mainView.height

    color: "#b2333333"

    opacity:0

    Behavior on opacity{
        NumberAnimation {
            duration: 2*mainView.animationsStep;
            easing.type: Easing.InOutQuad;
        }
    }


    MouseArea{
        anchors.fill: parent
        hoverEnabled: true
        onClicked:parent.opacity = 0;
    }

    ListView{
        id:titlesColumn
        y:0.3*parent.height
        width:0.1*mainView.width
        model:ListModel{}

        delegate:Text{
            width:0.1*mainView.width
            elide:Text.ElideRight
            font.family: mainView.defaultFont.family
            font.pixelSize: 0.02*mainTourWin.height

            text:(index+1)+". "+Title;
            color:"#ffffff"
        }

    }


    Rectangle{
        width:1
        height:0.5*mainView.height
        anchors.left: titlesColumn.right
        anchors.leftMargin: 5
        anchors.verticalCenter: parent.verticalCenter
        color:"#88f7f7f7"
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
        width:0.9*mainView.width
        height: mainView.height
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

}
