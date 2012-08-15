// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.qtextracomponents 0.1

/*
Slider {
    id:zoomSlider
    y:mainView.height - height - 5
    x:stoppedPanel.x - width - 5
    maximum: 65
    minimum: 32
    value:50
    width:125
    z:10

    onValueChanged: workflowManager.setZoomFactor(value);

    Image{
        x:-0.4*width
        y:-0.3*height
        width:30
        height:1.5*width
        source:"Images/buttons/magnifyingglass.png"
    }

}*/

PlasmaComponents.Slider {
    id:zoomSliderIt
    y:mainView.height - height
    //x:stoppedPanel.x - width - 20
    x:mainView.width - width - 20
    maximumValue: 75
    minimumValue: 30
    value:50

    width:125
    z:10

    property bool firsttime:true

    onValueChanged: firsttime === false ? workflowManager.setZoomFactor(value) : notFirstTime()

    //For hiding the Warnings in KDe4.8
    property bool updateValueWhileDragging:true
    property bool animated:true

    function notFirstTime(){
        firsttime = false;
    }


    //QIconItem{
    Image{
        id:minusSliderImage
        //x:magnifyingMainIcon.width / 2
        x:-width/1.5
        width:30
        height:width
        y:-5

        //icon:QIcon("zoom_out")
        source:"Images/buttons/zoom_out.png"
        smooth:true
        fillMode:Image.PreserveAspectFit

        MouseArea{
            width:0.6*parent.width
            height:parent.height
            anchors.left: parent.left

            onClicked:{
                zoomSliderIt.value--;
            }
        }
    }

    //QIconItem{
    Image{
        id:plusSliderImage

        x:zoomSliderIt.width-width/2
        width:30
        height:width
        y:-5
        //icon:QIcon("zoom_in")
        source:"Images/buttons/zoom_in.png"
        smooth:true
        fillMode:Image.PreserveAspectFit

        MouseArea{
            width:0.8*parent.width
            height:parent.height
            anchors.right: parent.right

            onClicked:{
                zoomSliderIt.value++;
            }
        }
    }

}
