// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import ".."

Item{
    id:mainBtn

    height:isCircle === true ? width : 5

    state:"simple"

    property string imgShadow
    property string imgShadowHov

    property string imgIcon
    property string imgIconHov

    property alias backShadowSource: backShadow.source
    property alias mainIconSource: mainIcon.source

    property alias mainIconWidth: mainIcon.width
    property alias mainIconHeight: mainIcon.height

    property bool isCircle: true

    property alias borderColorC : mainBtnGrad.borderC
    property alias borderColorPreC : mainBtnGrad.borderCPre
    property alias borderColorHovC: mainBtnGrad.borderCHov


    Image{
        id:backShadow
        anchors.centerIn: parent
        width:parent.width
        height:mainBtn.isCircle === true  ? width : parent.height
        smooth:true
    }

    Rectangle {
        anchors.centerIn: parent

        id: mainBtnGrad

        width: mainBtn.isCircle === true ? 0.7 * parent.width : 0.8 * parent.width

        height: mainBtn.isCircle === true ? width : 0.75 * parent.height
        radius: mainBtn.isCircle === true ? width/2 : height/2
        //border.width: width/25 > 2 ? width/25:2
        border.width: 2



        //Normal State
        property real  gPos1: 0
        property real  gPos2: 0.4
        property real  gPos3: 0.65
        property real  gPos4: 1

        property color gColor1:"#e6e6e6"
        property color gColor2:"#e2e2e2"
        property color gColor3:"#c5c5c5"
        property color gColor4:"#6f6f6f"

        property color borderC:"#585858"

        //Pressed
        property real  gPos1Pre: 0
        property real  gPos2Pre: 0.35
        property real  gPos3Pre: 0.6
        property real  gPos4Pre: 1

        property color gColor1Pre:"#6f6f6f"
        property color gColor2Pre:"#c5c5c5"
        property color gColor3Pre:"#e2e2e2"
        property color gColor4Pre:"#e6e6e6"

        property color borderCPre:"#cecece"

        //Hovered

        property color borderCHov:"#00cecece"


        //Various alias

        property alias gstp1pos:gStop1.position
        property alias gstp2pos:gStop2.position
        property alias gstp3pos:gStop3.position
        property alias gstp4pos:gStop4.position

        property alias gstp1col:gStop1.color
        property alias gstp2col:gStop2.color
        property alias gstp3col:gStop3.color
        property alias gstp4col:gStop4.color

        smooth:true

        gradient: Gradient {
            GradientStop { id: gStop1; position: mainBtnGrad.gPos1; color: mainBtnGrad.gColor1}
            GradientStop { id: gStop2; position: mainBtnGrad.gPos2; color: mainBtnGrad.gColor2}
            GradientStop { id: gStop3; position: mainBtnGrad.gPos3; color: mainBtnGrad.gColor3}
            GradientStop { id: gStop4; position: mainBtnGrad.gPos4; color: mainBtnGrad.gColor4}
        }

        Image{
            id:mainIcon
            x:0
            y:0
            anchors.centerIn: parent
            width:mainBtn.isCircle === true ? 0.6 * parent.width : 10
            height:mainBtn.isCircle === true ? width : 10
            smooth:true
        }

    }

    states: [
        State {
            name: "simple"
            PropertyChanges {
                target: mainBtnGrad
                gstp1pos: mainBtnGrad.gPos1
                gstp2pos: mainBtnGrad.gPos2
                gstp3pos: mainBtnGrad.gPos3
                gstp4pos: mainBtnGrad.gPos4

                gstp1col: mainBtnGrad.gColor1
                gstp2col: mainBtnGrad.gColor2
                gstp3col: mainBtnGrad.gColor3
                gstp4col: mainBtnGrad.gColor4
                border.color: mainBtnGrad.borderC
            }
            PropertyChanges {
                target: mainBtn
                backShadowSource: mainBtn.imgShadow
                mainIconSource: mainBtn.imgIcon
            }
        },
        State {
            name: "hovered"
            PropertyChanges {
                target: mainBtnGrad

                border.color: mainBtnGrad.borderCHov
            }
            PropertyChanges {
                target: mainBtn
                backShadowSource: mainBtn.imgShadowHov
                mainIconSource: mainBtn.imgIconHov

            }
        },
        State {
            name: "pressed"
            PropertyChanges {
                target: mainBtnGrad
                gstp1pos: mainBtnGrad.gPos1Pre
                gstp2pos: mainBtnGrad.gPos2Pre
                gstp3pos: mainBtnGrad.gPos3Pre
                gstp4pos: mainBtnGrad.gPos4Pre

                gstp1col: mainBtnGrad.gColor1Pre
                gstp2col: mainBtnGrad.gColor2Pre
                gstp3col: mainBtnGrad.gColor3Pre
                gstp4col: mainBtnGrad.gColor4Pre

                border.color: mainBtnGrad.borderCPre
            }
            PropertyChanges {
                target: mainBtn
                backShadowSource: mainBtn.imgShadowHov
                mainIconSource: mainBtn.imgIconHov
            }
        }
    ]

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onEntered: {
            mainBtn.onEntered();
        }

        onExited: {
            mainBtn.onExited();
        }

        onPressed: {
            mainBtn.onPressed();
        }

        onReleased: {
            mainBtn.onReleased();
        }

        onClicked: {
            mainBtn.onClicked();
        }


    }

    function onEntered(){
        if(mainBtn.state !== "pressed")
            mainBtn.state="hovered"
    }

    function onExited(){
        if(mainBtn.state !== "pressed")
            mainBtn.state="simple";
    }

    function onPressed(){
        mainBtn.state="pressed"
    }

    function onReleased(){
        mainBtn.state="simple"
    }

    function onClicked(){

        mainBtn.state="pressed";


        if (storedParameters.animationsStep2 !== 0){
            var x1 = mainIcon.x;
            var y1 = mainIcon.y;

            var crd = mainIcon.mapToItem(mainView,x1, y1);

            mainView.getDynLib().animateIcon(mainIcon.source,
                                             mainIcon.height/mainIcon.width,
                                             mainIcon.width,
                                             crd);

        }
        mainBtn.state="hovered";

    }


}

