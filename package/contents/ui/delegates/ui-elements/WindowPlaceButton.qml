// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item{
    id:winStateItem

    height:width


    property bool allDesks
    property bool allActiv

    property alias enabled:mouseAr.enabled
    WindowButton{
        id:winStateBtn

        width:parent.width
        isCircle:true

        imgShadow:"../../Images/buttons/plasma_ui/greyShadow.png"
        imgShadowHov: "../../Images/buttons/plasma_ui/blueShadow.png"

    }

    state:"one"

    states: [
        State {
            name: "one"
            when:(!allDesks) && (!allActiv)
            PropertyChanges {
                target: winStateBtn
                imgIcon:"../../Images/buttons/plasma_ui/allDesktops.png"
                imgIconHov:"../../Images/buttons/plasma_ui/allDesktopsHov.png"
                mainIconWidth: 0.15 * winStateItem.width
                mainIconHeight: 3.4 * mainIconWidth
            }
        },
        State {
            name: "everywhere"
            when: allActiv
            PropertyChanges {
                target: winStateBtn
                imgIcon:"../../Images/buttons/plasma_ui/oneDesktop.png"
                imgIconHov:"../../Images/buttons/plasma_ui/oneDesktopHov.png"
                mainIconWidth: 0.45 * winStateItem.width
                mainIconHeight: 0.85 * mainIconWidth
            }
        },
        State {
            name: "allDesktops"
            when: allDesks
            PropertyChanges {
                target: winStateBtn
                imgIcon:"../../Images/buttons/plasma_ui/everywhereW.png"
                imgIconHov:"../../Images/buttons/plasma_ui/everywhereWHov.png"
                mainIconWidth: 0.35 * winStateItem.width
                mainIconHeight: 1.55 * mainIconWidth
            }
        }

    ]

    MouseArea {
        id:mouseAr
        anchors.fill: parent
        hoverEnabled: true
        enabled: true

        onEntered: {
            winStateItem.onEntered();
        }

        onExited: {
            winStateItem.onExited();
        }

        onClicked: {
            winStateItem.onClicked();
            winStateItem.nextState();
        }

        onReleased: {
            winStateItem.onReleased();
        }

        onPressed: {
            winStateItem.onPressed();
        }


    }

    function nextState(){
        if (winStateItem.state === "one")
            winStateItem.state = "allDesktops";
        else if (winStateItem.state === "allDesktops")
     //       winStateItem.state = "one";
            winStateItem.state = "everywhere";
        else if (winStateItem.state === "everywhere")
            winStateItem.state = "one";
    }

    function previousState(){
        if (winStateItem.state === "one")
            winStateItem.state = "everywhere";
        else if (winStateItem.state === "allDesktops")
            winStateItem.state = "one";
        else if (winStateItem.state === "everywhere")
            winStateItem.state = "allDesktops";
    }

    function onEntered(){
        winStateBtn.onEntered();
    }

    function onExited(){
        winStateBtn.onExited();
    }

    function onPressed(){
        winStateBtn.onPressed();
    }

    function onClicked(){
        winStateBtn.onClicked();
    }

    function onReleased(){
        winStateBtn.onReleased();
    }

}
