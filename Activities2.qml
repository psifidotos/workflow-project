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

    property int workareaHeight:3*scaleMeter
    property int workareaY:2*scaleMeter

    property int workareaWidth: (60+3*mainView.scaleMeter) - (mainView.scaleMeter/5) + 10 + (mainView.scaleMeter-5)/3;

    Behavior on scaleMeter{
        NumberAnimation {
            duration: 200;
            easing.type: Easing.InOutQuad;
        }
    }

    function addWorkArea(pos){

    }

    Image{
        width:parent.width; height:parent.height
        source:"Images/greyBackground.png"
        fillMode: Image.Tile

    }

    Item{

        id:lists
        y:workareaY+(workareaY/3)
        height:mainView.height

        ListView {
            id:mod1
            height:workareaHeight*model.count

            x:5
            spacing:3+workareaY / 5

            model:WorkAreasModel1{}
            delegate:WorkArea{
            }

        }

        ListView {
            id:mod2

            height:workareaHeight*model.count

            x:10+mainView.workareaWidth
            spacing:3+workareaY / 5


            model:WorkAreasModel2{}
            delegate:WorkArea{

            }
        }

        ListView {
            id:mod3

            height:workareaHeight*model.count
            x:15+2*mainView.workareaWidth
            spacing:3+workareaY / 5

            model:WorkAreasModel3{}
            delegate:WorkArea{

            }
        }

        ListView {
            id:mod4

            height:workareaHeight*model.count
            x:20+3*mainView.workareaWidth
            spacing:3+workareaY / 5

            model:WorkAreasModel4{}
            delegate:WorkArea{

            }
        }
    }



    //Top Activities Banner
    //    Row{
    Image {
        id: actImag1
        source: "Images/activitiesBack.png"
        fillMode: Image.TileHorizontally
        anchors.top: oxygenTitle.bottom
        width: mainView.width
        height: workareaY
        smooth: true

        ListView {
            orientation: ListView.Horizontal
            height: workareaY
            width: mainView.width
            anchors.top: parent.top
            anchors.left: parent.left
            y: workareaY / 4
            //   x: 10
            spacing: workareaY / 10

            id: activitiesList
            model: ActivitiesModel1{}
            delegate: Activity{

            }
        }

    }
    //  }

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



