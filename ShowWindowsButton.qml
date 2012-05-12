// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item {
    id:showWindowsMain
    width: height+height/3
    height: 0.8*oxygenTitle.height

    Behavior on scale{
        NumberAnimation {
            duration: 500;
            easing.type: Easing.InOutQuad;
        }
    }

    Image{
        id:mainStateImg
        width: 1.15 * parent.height
        height: parent.height
        source: mainView.showWinds ? "Images/buttons/withwindowsicon.png" : "Images/buttons/nowindowsicon.png"

    }

    Image{
       id:stateImg
       width:mainStateImg.width / 3
       height:mainView.showWinds ? width/2 : width
       x:mainStateImg.width
       y:0

       source: mainView.showWinds ?  "Images/buttons/withwindowsminus.png" : "Images/buttons/nowindowsadd.png"

    }

    MouseArea{
        anchors.fill: parent
        hoverEnabled: true

        onEntered: {
            showWindowsMain.scale=1.3;
        }

        onExited: {
            showWindowsMain.scale=1;
        }

        onClicked: {
            if (mainView.showWinds)
                mainView.showWinds = false;
            else
                mainView.showWinds = true;
        }
    }


}
