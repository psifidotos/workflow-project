// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import "uielements"

Rectangle {


    width:mainView.width
    height:mainView.height

    color: "#aa333333"

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

    TourPage{
        anchors.left: titlesColumn.right
        width:0.9*mainView.width
        height: mainView.height
        pageTitle: "Introduction"

        Text{
            text:"Helllo world!.........."
            color:"#ffffff"
        }
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
                }
            }
        }
    }


    /*
    NumberedList{
        id:nmList
        x:250
        y:200
        width:150
        texts:["asdfasdf","asdfasdf232323asdf","asdfasdf234","asdfasdf2323"]
    }

    AnimatedLine{
        height:3
        width:1

        x:100
        y:300


        lengthEnd:150

        transformOrigin: Item.BottomLeft

        moveForward: true

        startRotation:90
        endRotation: 0


        z:35

        onMoveForwardChanged: {
            if (moveForward === true){
                nmList.startAnimation();
            }
            else{
                nmList.resetAnimation();

            }

        }
    }*/
    /*
    Rectangle{
        color:"blue"
        x:10
        y:10
        width:40
        height:width

        MouseArea{
            anchors.fill: parent
            onClicked:{
                animP1.startAnimation();
                animP2.startAnimation();
                animP3.startAnimation();
                animP4.startAnimation();
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
                animP1.resetAnimation();
                animP2.resetAnimation();
                animP3.resetAnimation();
                animP4.resetAnimation();
            }
        }
    }
    AnimatedParagraph{
        id:animP1
        x:100
        y:300

        width:300

        linePlace:"LEFT"
        lineForward:true

        fullText:"<b>Activities</b><br/>Activities are believed that according to researchers there is a situation in which you dont know when..."
        texts:["Hello World 1 ...",
            "This is second line...",
            "Fantastic state..."
        ]

    }

    AnimatedParagraph{
        id:animP2
        x:200
        y:300

        width:300

        linePlace:"TOP"
        lineForward:true

        fullText:"<b>Activities</b><br/>Activities are believed that according to researchers there is a situation in which you dont know when..."
        texts:["Hello World 1 ...",
            "This is second line...",
            "Fantastic state..."
        ]

    }

    AnimatedParagraph{
        id:animP3
        x:300
        y:300

        width:300

        linePlace:"BOTTOM"
        lineForward:true

        fullText:"<b>Activities</b><br/>Activities are believed that according to researchers there is a situation in which you dont know when..."
        texts:["Hello World 1 ...",
            "This is second line...",
            "Fantastic state..."
        ]

    }

    AnimatedParagraph{
        id:animP4
        x:400
        y:300

        width:300

        linePlace:"RIGHT"
        lineForward:true

        fullText:"<b>Activities</b><bt/>Activities are believed that according to researchers there is a situation in which you dont know when..."
        texts:["Hello World 1 ...",
            "This is second line...",
            "Fantastic state..."
        ]

    }*/
}
