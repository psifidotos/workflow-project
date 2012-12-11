// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle{

    id:busDialog

    width:mainView.width
    height:mainView.height

    color:"#aa222222"

    opacity:0
    visible:container.on

    Behavior on opacity{
        NumberAnimation {
            duration: 2*parametersManager.animationsStep;
            easing.type: Easing.InOutQuad;
        }
    }

    MouseArea{
        anchors.fill: parent
        hoverEnabled: true
    }


    Timer{
        id:busyIndTimer
        interval:container.animationTime/container.circlesNum
        repeat:true
        running:((container.on)&&(container.stepAnimation))


        onTriggered: {
            container.nextRotation()
        }
    }

    Item {

        id: container
        property bool on: false

        width:0.25*parent.height
        height:width
        anchors.centerIn: parent

        property int circlesNum:12
        property real fromOpacity:0.2

        property int animationTime:1000
        property bool stepAnimation:true

        property real rotationStep:360/circlesNum

        rotation:0


        Repeater{
            model:parent.circlesNum
            delegate:Item{
                width:parent.width
                height:parent.height

                rotation:container.rotationStep*index

                Rectangle{
                    color:"#00ffffff"
                    width:container.width/6
                    height:width
                    y:(container.height-height)/2
                    radius:width/2

                    //property real stepOpacity:(1-container.fromOpacity)/container.circlesNum
                   // opacity:container.fromOpacity+index*stepOpacity

                    Rectangle{
                        color:"#c4ff8c"
                      //  width:container.width/6
                        width:parent.width
                        height:parent.height
                     //   y:(container.height-height)/2

                        radius:width/2

                        property real stepOpacity:(1-container.fromOpacity)/container.circlesNum
                        opacity:container.fromOpacity+index*stepOpacity
                    }
                }
            }
        }

        function nextRotation(){
            var nrot = rotation + container.rotationStep;

            if (nrot>=360)
                rotation= 0;
            else
                rotation = nrot;

        }

        visible:container.on

        NumberAnimation on rotation {
            running: ((container.on)&&(container.stepAnimation==false));
            from: 0; to: 360;
            loops: Animation.Infinite;
            duration: 1000
        }

    }

    function startAnimation(){
        busDialog.opacity = 1;
        container.on=true;
    }

    function resetAnimation(){
        container.on=false;
        busDialog.opacity = 0;
    }

}
