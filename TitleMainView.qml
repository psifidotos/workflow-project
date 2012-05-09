// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1


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


    Rectangle{
        anchors.top: oxygenTitle.bottom
        width:oxygenTitle.width
        height:3*oxygenTitle.height/6
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#aa0f0f0f" }
            GradientStop { position: 1.0; color: "#00797979" }
        }
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
