// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1


Rectangle {
    width: 1024;  height: 700

    color: "#dcdcdc"
    id:mainView
    //  z:0
    anchors.fill: parent

    property int currentColumn:-1
    property int currentRow:-1

    property int scaleMeter:zoomSlider.value

    property real zoomingHeightFactor: ((zoomSlider.value-zoomSlider.minimum)/(zoomSlider.maximum-zoomSlider.minimum))*0.6
    property int workareaHeight:(3.6 - zoomingHeightFactor)*scaleMeter
    property int workareaY:2*scaleMeter

    property int workareaWidth: (60+3*mainView.scaleMeter) - (mainView.scaleMeter/5) + 10 + (mainView.scaleMeter-5)/3;

    Behavior on scaleMeter{
        NumberAnimation {
            duration: 100;
            easing.type: Easing.InOutQuad;
        }
    }

    function addWorkArea(pos){

    }

    Flickable{
        id: view

        anchors.fill: parent
        contentWidth: allareas.width
        contentHeight: mainView.workareaHeight * 5 //improved in feature
        boundsBehavior: Flickable.StopAtBounds

        Image{
            width:mainView.width<allareas.width ? allareas.width : mainView.width
            height:parent.height
            source:"Images/greyBackground.png"
            fillMode: Image.Tile
        }

        //Item{
        //  id:lists

        ListView{
            id:allareas

            y:workareaY+(workareaY/3)
            width:model.count*(workareaWidth)
            //  width:mainView.width
            height:mainView.height
            orientation: ListView.Horizontal
            spacing:60+3.5*mainView.scaleMeter

            interactive:false

            model:WorkAreasCompleteModel{}
            delegate: WorkAreaList{
            }
        }

        //}

        //Top Activities Banner
        //    Row{
        Image{
            id:actImag1Shad
            source:"Images/activitiesBack2Shadow.png"
            fillMode: Image.TileHorizontally
            anchors.top: actImag1.bottom
            y:actImag1.height
            width: mainView.width<allareas.width ? allareas.width : mainView.width
            height: workareaY/4
            smooth: true
        }

        Image {
            id: actImag1
            source: "Images/activitiesBack2.png"
            fillMode: Image.TileHorizontally
            //   anchors.top: oxygenTitle.bottom
            y:oxygenTitle.height
            width: mainView.width<allareas.width ? allareas.width : mainView.width
            height: workareaY-workareaY/10
            smooth: true

            ListView {
                orientation: ListView.Horizontal
                height: workareaY
                width: mainView.width<allareas.width ? allareas.width : mainView.width
                // anchors.top: parent.top
                //  anchors.left: parent.left
                y: workareaY / 12
                //   x: 10
                spacing: workareaY / 10
                interactive:false

                id: activitiesList
                model: ActivitiesModel1{}
                delegate: Activity{

                }
            }

        }

        states: State {
            name: "ShowBars"
            when: view.movingVertically || view.movingHorizontally
            PropertyChanges { target: verticalScrollBar; opacity: 1 }
            PropertyChanges { target: horizontalScrollBar; opacity: 1 }
        }

        transitions: Transition {
            NumberAnimation { properties: "opacity"; duration: 400 }
        }

    }//Flickable scrolling

    //Scrollbars
    // Attach scrollbars to the right and bottom edges of the view.
    ScrollBar {
        id: verticalScrollBar
        width: 12; height: view.height-12
        anchors.right: view.right
        opacity: 0
        orientation: Qt.Vertical
        position: view.visibleArea.yPosition
        pageSize: view.visibleArea.heightRatio
    }

    ScrollBar {
        id: horizontalScrollBar
        width: view.width-12; height: 12
        anchors.bottom: view.bottom
        opacity: 0
        orientation: Qt.Horizontal
        position: view.visibleArea.xPosition
        pageSize: view.visibleArea.widthRatio
    }


    //ScrollBars


    Rectangle{
        id:oxygenTitle
        anchors.top:parent.top
        width:mainView.width
        color:"#dcdcdc"
        height: workareaY/3

        Image{
            source:"Images/buttons/titleLight.png"
            clip:true
            width:parent.width
            height:parent.height
            smooth:true
            fillMode:Image.PreserveAspectCrop
        }



        Image{
            source:"Images/buttons/titleShadow.png"
            anchors.top:oxygenTitle.bottom
            width:oxygenTitle.width
            height:oxygenTitle.height/2
            fillMode: Image.TileHorizontally
        }
        Text{
            anchors.top:oxygenTitle.top
            anchors.horizontalCenter: oxygenTitle.horizontalCenter
            text:"Activities"
            font.family: "Helvetica"
            font.italic: true
            font.pointSize: 5+(mainView.scaleMeter) /10
            color:"#777777"
        }

    }

    Slider {
        id:zoomSlider
        anchors.bottom: mainView.bottom
        anchors.right: mainView.right
        maximum: 65
        minimum: 35
        value: 50
        width:150

    }

}



