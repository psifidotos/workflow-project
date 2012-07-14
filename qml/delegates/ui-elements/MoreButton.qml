// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item{
    id:moreMainItem

    state:"simple"

    WindowButton{
        id: moreWinBtn
        isCircle:false
        width:parent.width
        height:parent.height

        mainIconWidth:0.5*width
        mainIconHeight:0.3*mainIconWidth

    }

    states: [
        State {
            name: "simple"
            PropertyChanges {
                target: moreWinBtn
                imgShadow:"../../Images/buttons/plasma_ui/greyRectShadow.png"
                imgShadowHov: "../../Images/buttons/plasma_ui/blueRectShadow.png"


                imgIcon:"../../Images/buttons/plasma_ui/moreGrey.png"
                imgIconHov:"../../Images/buttons/plasma_ui/moreBlue.png"

                borderColorC: "#00550000"
                borderColorPreC: "#00880000"
                borderColorHovC: "#00880000"

            }
        },
        State {
            name: "more"
            PropertyChanges {
                target: moreWinBtn
                imgShadow:"../../Images/buttons/plasma_ui/redRectShadow.png"
                imgShadowHov: "../../Images/buttons/plasma_ui/blueRectShadow.png"

                imgIcon:"../../Images/buttons/plasma_ui/moreRed.png"
                imgIconHov:"../../Images/buttons/plasma_ui/moreBlue.png"

                borderColorC: "#00550000"
                borderColorPreC: "#00880000"
                borderColorHovC: "#00880000"
            }
        }

    ]

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onEntered: {
            moreMainItem.onEntered();
        }

        onExited: {
           moreMainItem.onExited();
        }

        onClicked: {
           moreMainItem.onClicked();
        }

        onReleased: {
           moreMainItem.onReleased();
        }

        onPressed: {
           moreMainItem.onPressed();
        }


    }


    function onEntered(){
        moreWinBtn.onEntered();
    }

    function onExited(){
        moreWinBtn.onExited();
    }

    function onPressed(){
        moreWinBtn.onPressed();
    }

    function onClicked(){
        moreWinBtn.onClicked();
    }

    function onReleased(){
        moreWinBtn.onReleased();
    }

}

