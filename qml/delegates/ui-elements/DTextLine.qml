// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1


Item{

    id:dTextIItem

    state: "inactive"
    property alias text : mainIText.text

    property bool firstrun:true

    property string acceptedText : ""




    BorderImage{
        id:backIImage

        opacity:0
        source: initSource

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
                duration: mainView.animationsStep;
                easing.type: Easing.InOutQuad;
            }
        }

        Item{
            id:tickRectangleI
            width: 40
            height: parent.height
            anchors.right: parent.right

            Image{
                id:tickIImage;

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

                onEntered:{
                    backIImage.source = backIImage.hoverSource;
                    tickIImage.source = tickIImage.hoverTick

                }
                onExited:{
                    backIImage.source = backIImage.initSource;
                    tickIImage.source = tickIImage.initTick;
                }

                onClicked: {
                    dTextIItem.textAccepted();
                }
            }
        }
    }

    Text{
        id:mainTextLabel

        text:mainIText.text
        width:mainIText.width
        height:mainIText.height
        font.family: mainIText.font.family
        font.italic: mainIText.font.italic
        font.pointSize: mainIText.font.pointSize
        color:mainIText.color
        elide:Text.ElideRight
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
    }


    TextInput {
        id:mainIText

        width:dTextIItem.width-30-space;
        height: dTextIItem.height-space;

        property int space:0;

        //font.family: "Helvetica"
        font.family: mainView.defaultFont.family
        font.italic: true
        font.pointSize: mainView.fixedFontSize+((mainView.scaleMeter/12)-3)

        color: origColor

        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        //anchors.centerIn: parent
        focus:true
        opacity:mainTextLabel.opacity === 0 ? 1 : 0.001

        property color origColor: "#323232"
        property color activColor: "#444444"

        Behavior on color{
            ColorAnimation {
                duration: 2*mainView.animationsStep;
                easing.type: Easing.InOutQuad;
            }
        }

        Behavior on width{
            NumberAnimation {
                duration: 2*mainView.animationsStep;
                easing.type: Easing.InOutQuad;
            }
        }

        Behavior on height{
            NumberAnimation {
                duration: 2*mainView.animationsStep;
                easing.type: Easing.InOutQuad;
            }
        }


        //from: http://qt.gitorious.org/qt-components/qt-components/blobs/1be426261941ce4751dbda11b3a6c2b974646225/components/behaviors/TextEditMouseBehavior.qml
        function characterPositionAt(mouse) {
            var mappedMouse = mapToItem(mainIText, mouse.x, mouse.y);

            return mainIText.positionAt(mappedMouse.x, mappedMouse.y);
        }

        MouseArea{
            anchors.fill: parent
            hoverEnabled: true

            onEntered:{
                dTextIItem.entered();
            }
            onExited:{
                dTextIItem.exited();
            }

            onClicked: {
                dTextIItem.clicked(mouse);
            }
        }

        Keys.onPressed: {
            if ((event.key === Qt.Key_Enter)||(event.key === Qt.Key_Return)) {
                dTextIItem.textAccepted();
                event.accepted = true;
            }
            else if (event.key === Qt.Key_Escape){
                mainView.forceActiveFocus();
            }
        }

    }

    Image{
        id:pencilI
        anchors.right: dTextIItem.right
        width: 0.6 * dTextIItem.height
        height:0.66 * dTextIItem.height
        source:"../../Images/buttons/darkPencil.png"
        opacity: 0
        smooth:true

        Behavior on opacity{
            NumberAnimation {
                duration: 2*mainView.animationsStep;
                easing.type: Easing.InOutQuad;
            }
        }

        MouseArea{
            anchors.fill: parent
            hoverEnabled: true

            onEntered:{
                dTextIItem.entered();
            }
            onExited:{
                dTextIItem.exited();
            }

            onClicked: {
                dTextIItem.clicked(mouse);
            }
        }
    }



    states: [
        State {
            name: "active"
            when: mainIText.activeFocus
            PropertyChanges{
                target:backIImage
                opacity:1
            }
            PropertyChanges{
                target:mainIText
                color:mainIText.activColor
                space:17
            }
            PropertyChanges{
                target:pencilI
                opacity:0
            }

        },
        State{
            name: "inactive"
            when: !mainIText.activeFocus
            PropertyChanges{
                target:backIImage
                opacity:0
            }
            PropertyChanges{
                target:mainIText
                color:mainIText.origColor
            }
            PropertyChanges{
                target:pencilI
                opacity:0
            }
            StateChangeScript {
                name: "checkFirstRun"
                script: {
                    if (dTextIItem.firstrun)
                        dTextIItem.acceptedText = dTextIItem.text
                    else
                        dTextIItem.text = dTextIItem.acceptedText
                }
            }

        }

    ]

    function entered(){
        if(dTextIItem.state=="inactive")
            pencilI.opacity = 1;
    }

    function exited(){
        pencilI.opacity = 0;
    }

    function clicked(mouse){
        dTextIItem.firstrun = false;

        var pos = mainIText.characterPositionAt(mouse);
        mainIText.cursorPosition = pos;
        mainIText.forceActiveFocus();
        pencilI.opacity = 0;

        mainTextLabel.opacity = 0;

        dTextIItem.acceptedText = dTextIItem.text
    }

    function textAccepted(){
        dTextIItem.acceptedText = dTextIItem.text;
        dTextIItem.state = "inactive";

        instanceOfWorkAreasList.setWorkareaTitle(mainWorkArea.actCode,mainWorkArea.desktop,dTextIItem.acceptedText);

        mainView.forceActiveFocus();

        mainTextLabel.opacity = 1;
    }

}
