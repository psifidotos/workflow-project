// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import "../../../code/settings.js" as Settings

Item{

    id:dTextItem

    state: "inactive"
    property alias text : mainText.text

    property bool firstrun: true

    property bool enableEditing

    property string acceptedText : ""

    property string actCode: ""

    property int nHeight

    BorderImage{
        id:backImage

        opacity:0
        source:"../../Images/buttons/editBox2.png"

        y:3

        border.left: 15; border.top: 15;
        border.right: 40; border.bottom: 15;
        horizontalTileMode: BorderImage.Repeat
        verticalTileMode: BorderImage.Repeat

        width:parent.width
        height:parent.height

        property string initSource:"../../Images/buttons/editBox2.png"
        property string hoverSource:"../../Images/buttons/editBoxHover2.png"

        Behavior on opacity{
            NumberAnimation {
                duration: Settings.global.animationStep;
                easing.type: Easing.InOutQuad;
            }
        }

        Item{
            id:tickRectangle
            width: 40
            height: parent.height
            anchors.right: parent.right


            Image{
                id:tickImage;

                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                source: initTick
                width: parent.width - 15
                height: 0.75*width
                smooth:true

                property string initTick:"../../Images/buttons/darkTick.png"
                property string hoverTick:"../../Images/buttons/lightTick.png"
            }

            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                z:15

                onEntered:{
                    if(dTextItem.enableEditing === true){
                        backImage.source = backImage.hoverSource;
                        tickImage.source = tickImage.hoverTick;
                    }
                }
                onExited:{
                    if(dTextItem.enableEditing === true){
                        backImage.source = backImage.initSource;
                        tickImage.source = tickImage.initTick;
                    }
                }

                onClicked: {
                    if(dTextItem.enableEditing === true)
                        dTextItem.textAccepted();
                }
            }
        }
    }

    Text{
        id:mainTextLabel2

        text:mainText.text

        width: dTextItem.width-5
        height: dTextItem.nHeight
  //      height:mainText.height
  //      y:-mainText.space

        font.family: mainText.font.family
        font.bold: mainText.font.bold
        font.italic: mainText.font.italic

        font.pixelSize: (0.22+mainView.defFontRelStep)*actImag1.height
        color:mainText.color

        anchors.left: parent.left
        anchors.leftMargin: 8
        anchors.bottom: backImage.bottom
        anchors.bottomMargin: 8
        //anchors.verticalCenter: parent.verticalCenter
        verticalAlignment: mainText.verticalAlignment


        wrapMode: Text.Wrap
        maximumLineCount: 2
        elide:Text.ElideRight

    }

    TextEdit {
        id:mainText
        property int space:0;
        //property int spaceN:

     //   width:dTextItem.width - 30 - space;
        width:dTextItem.width - 36;

        height: dTextItem.nHeight - 30;
     //   height: dTextItem.height - space;

        wrapMode: TextEdit.Wrap

        font.family: mainView.defaultFont.family
        font.bold: true
        font.italic: true

        font.pixelSize: 0.9*mainTextLabel2.font.pixelSize

        color: origColor
        verticalAlignment: TextEdit.AlignBottom

        opacity:mainTextLabel2.opacity === 0 ? 1 : 0
        visible:mainTextLabel2.opacity === 0 ? 1 : 0

        anchors.left: parent.left
        anchors.leftMargin: 8
        anchors.bottom: backImage.bottom
        anchors.bottomMargin: 8


        focus:true
        readOnly: !dTextItem.enableEditing
        enabled: dTextItem.enableEditing


        property color origColor: "#f0f0f0"
        property color activColor: "#444444"

        Behavior on color{
            ColorAnimation {
                duration: 2*Settings.global.animationStep;
                easing.type: Easing.InOutQuad;
            }
        }

        Behavior on width{
            NumberAnimation {
                duration: 2*Settings.global.animationStep;
                easing.type: Easing.InOutQuad;
            }
        }

        Behavior on height{
            NumberAnimation {
                duration: 2*Settings.global.animationStep;
                easing.type: Easing.InOutQuad;
            }
        }

        //from: http://qt.gitorious.org/qt-components/qt-components/blobs/1be426261941ce4751dbda11b3a6c2b974646225/components/behaviors/TextEditMouseBehavior.qml
        function characterPositionAt(mouse) {
            var mappedMouse = mapToItem(mainText, mouse.x, mouse.y);

            return mainText.positionAt(mappedMouse.x, mappedMouse.y);
        }

        MouseArea{
            anchors.fill: parent
            hoverEnabled: true


            onEntered:{
                if(dTextItem.enableEditing === true)
                    dTextItem.entered();
            }
            onExited:{
                if(dTextItem.enableEditing === true)
                    dTextItem.exited();
            }

            onClicked: {
                if(dTextItem.enableEditing === true)
                    dTextItem.clicked(mouse);
            }
        }

        Keys.onPressed: {
            if ((event.key === Qt.Key_Enter)||(event.key === Qt.Key_Return)) {
                dTextItem.textAccepted();
                event.accepted = true;
            }
            else if (event.key === Qt.Key_Escape){
                mainView.forceActiveFocus();
            }
        }
    }

    Image{
        id:pencilImg
        anchors.right: dTextItem.right
        anchors.rightMargin: 10
        anchors.bottom: dTextItem.bottom
        anchors.bottomMargin: 3

        width:0.4*dTextItem.height
        height:dTextItem.height / 2
        source:"../../Images/buttons/listPencil.png"
        opacity: 0
        smooth:true

        Behavior on opacity{
            NumberAnimation {
                duration: 2*Settings.global.animationStep;
                easing.type: Easing.InOutQuad;
            }
        }
        MouseArea{
            anchors.fill: parent
            hoverEnabled: true


            onEntered:{
                if(dTextItem.enableEditing === true)
                    dTextItem.entered();
            }
            onExited:{
                if(dTextItem.enableEditing === true)
                    dTextItem.exited();
            }

            onClicked: {
                if(dTextItem.enableEditing  === true)
                    dTextItem.clicked(mouse);
            }
        }
    }


    states: [
        State {
            name: "active"
            when: ((mainText.activeFocus===true) &&
                   (dTextItem.enableEditing===true))
            PropertyChanges{
                target:backImage
                opacity:1
            }
            PropertyChanges{
                target:mainText
                space:21
                color:mainText.activColor
            }
            PropertyChanges{
                target:pencilImg
                opacity:0
            }

        },
        State{
            name: "inactive"
            when: mainText.activeFocus === false
            PropertyChanges{
                target:backImage
                opacity:0
            }
            PropertyChanges{
                target:mainText
                color:mainText.origColor
            }
            PropertyChanges{
                target:pencilImg
                opacity:0
            }
            StateChangeScript {
                name: "checkFirstRun"
                script: {
                    if (dTextItem.firstrun)
                        dTextItem.acceptedText = dTextItem.text
                    else
                        textNotAccepted();
                }
            }

        }

    ]

    function entered(){
        if(dTextItem.state==="inactive")
            pencilImg.opacity = 1;

    }

    function exited(){
        pencilImg.opacity = 0;
    }

    function clicked(mouse){
        dTextItem.firstrun = false;

        mainText.forceActiveFocus();
        var pos = mainText.characterPositionAt(mouse);
        mainText.cursorPosition = pos;

        pencilImg.opacity = 0;

        dTextItem.acceptedText = dTextItem.text
        mainTextLabel2.opacity = 0;
        activityBtnsI.state="hide";
    }

    function textAccepted(){
        dTextItem.acceptedText = dTextItem.text;
        dTextItem.state = "inactive";
        mainView.forceActiveFocus();
        workflowManager.activityManager().setName(dTextItem.actCode,dTextItem.acceptedText);
        mainTextLabel2.opacity = 1;
    }

    function textNotAccepted(){
        //dTextItem.acceptedText = dTextItem.text;
        dTextItem.text = dTextItem.acceptedText;
        dTextItem.state = "inactive";
        mainView.forceActiveFocus();
        mainTextLabel2.opacity = 1;
    }


}

