// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.0

Item{

    id:dTextItem

    state: "inactive"
    property alias text : mainText.text

    property bool firstrun: true

    property string acceptedText : ""

    BorderImage{
        id:backImage

        opacity:0
        source:"Images/buttons/editBox2.png"

        border.left: 15; border.top: 15;
        border.right: 40; border.bottom: 15;
        horizontalTileMode: BorderImage.Repeat
        verticalTileMode: BorderImage.Repeat

        width:parent.width
        height:parent.height

        property string initSource:"Images/buttons/editBox2.png"
        property string hoverSource:"Images/buttons/editBoxHover2.png"

        Behavior on opacity{
            NumberAnimation {
                duration: 200;
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
                height: 3*width/4
                smooth:true

                property string initTick:"Images/buttons/darkTick.png"
                property string hoverTick:"Images/buttons/lightTick.png"
            }

            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                z:15

                onEntered:{
                    backImage.source = backImage.hoverSource;
                    tickImage.source = tickImage.hoverTick
                }
                onExited:{
                    backImage.source = backImage.initSource;
                    tickImage.source = tickImage.initTick;
                }

                onClicked: {
                    dTextItem.textAccepted();
                }
            }
        }
    }

    TextEdit {
        id:mainText
        property int space:0;

        width:dTextItem.width -30 - space;
        height: dTextItem.height - space;

        wrapMode: TextEdit.Wrap

        font.family: "Helvetica"
        font.bold: true
        font.italic: true
        font.pointSize: 5+(mainView.scaleMeter) /10

        color: origColor
        verticalAlignment: TextEdit.AlignBottom

        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        focus:true

        property color origColor: "#f0f0f0"
        property color activColor: "#444444"

        Behavior on color{
            ColorAnimation {
                duration: 200;
                easing.type: Easing.InOutQuad;
            }
        }

        Behavior on space{
            NumberAnimation {
                duration: 200;
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
                dTextItem.entered();
            }
            onExited:{
                dTextItem.exited();
            }

            onClicked: {
                dTextItem.clicked(mouse);
            }
        }

        Keys.onPressed: {
            if ((event.key === Qt.Key_Enter)||(event.key === Qt.Key_Return)) {
                dTextItem.textAccepted();
                event.accepted = true;
            }
        }
    }

    Image{
        id:pencilImg
        anchors.right: dTextItem.right
        anchors.rightMargin: 10
        anchors.bottom: dTextItem.bottom
        anchors.bottomMargin: 3

        width:2*dTextItem.height/5
        height:dTextItem.height / 2
        source:"Images/buttons/listPencil.png"
        opacity: 1
        smooth:true

        Behavior on opacity{
            NumberAnimation {
                duration: 400;
                easing.type: Easing.InOutQuad;
            }
        }
        MouseArea{
            anchors.fill: parent
            hoverEnabled: true


            onEntered:{
                dTextItem.entered();
            }
            onExited:{
                dTextItem.exited();
            }

            onClicked: {
                dTextItem.clicked(mouse);
            }
        }
    }


    states: [
        State {
            name: "active"
            when: mainText.activeFocus
            PropertyChanges{
                target:backImage
                opacity:1
            }
            PropertyChanges{
                target:mainText
                color:mainText.activColor
                space:21
            }
            PropertyChanges{
                target:pencilImg
                opacity:0
            }

        },
        State{
            name: "inactive"
            when: !mainText.activeFocus
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
                        dTextItem.text = dTextItem.acceptedText
                }
            }

        }

    ]


    function entered(){
        if(dTextItem.state=="inactive")
            pencilImg.opacity = 1;
    }

    function exited(){
        pencilImg.opacity = 0;
    }

    function clicked(mouse){
        dTextItem.firstrun = false;

        var pos = mainText.characterPositionAt(mouse);
        mainText.cursorPosition = pos;
        mainText.forceActiveFocus();
        pencilImg.opacity = 0;

        dTextItem.acceptedText = dTextItem.text
    }

    function textAccepted(){
        dTextItem.acceptedText = dTextItem.text;
        dTextItem.state = "inactive";
        mainView.forceActiveFocus();
    }

}

