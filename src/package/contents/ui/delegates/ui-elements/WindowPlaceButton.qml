// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item{
    id:winStateItem

    height:width


    property bool allDesks
    property bool allActiv

    //property alias enabled:mouseAr.enabled

    property alias containsMouse: winStateBtn.containsMouse

    signal entered;
    signal clicked;
    signal exited;
    signal pressed;
    signal pressAndHold;
    signal released;

    property alias icon: winStateBtn.icon
    property alias tooltipText: winStateBtn.tooltipText
    property alias tooltipTitle: winStateBtn.tooltipTitle

    WindowButton{
        id:winStateBtn

        width:parent.width
        isCircle:true

        imgShadow:"../../Images/buttons/plasma_ui/greyShadow.png"
        imgShadowHov: "../../Images/buttons/plasma_ui/blueShadow.png"

        onEntered: winStateItem.entered();
        onExited: winStateItem.exited();

        onClicked: {
            winStateItem.clicked();
            winStateItem.nextState();
        }

        onReleased: winStateItem.released();
        onPressed: winStateItem.pressed();
        onPressAndHold: winStateItem.pressAndHold();
    }

    state:"oneDesktop"

    states: [
        State {
            name: "oneDesktop"
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
            name: "allDesktops"
            when: (allDesks) && (!allActiv)
            PropertyChanges {
                target: winStateBtn
                imgIcon:"../../Images/buttons/plasma_ui/sameDesktops.png"
                imgIconHov:"../../Images/buttons/plasma_ui/sameDesktopsHov.png"
                mainIconWidth: 0.55 * winStateItem.width
                mainIconHeight: 0.4 * mainIconWidth
            }
        },
        State {
            name: "sameDesktops"
            when: (!allDesks) && (allActiv)
            PropertyChanges {
                target: winStateBtn
                imgIcon:"../../Images/buttons/plasma_ui/everywhereW.png"
                imgIconHov:"../../Images/buttons/plasma_ui/everywhereWHov.png"
                mainIconWidth: 0.35 * winStateItem.width
                mainIconHeight: 1.55 * mainIconWidth
            }
        },

        State {
            name: "allActivities"
            when: (allDesks) && (allActiv)
            PropertyChanges {
                target: winStateBtn
                imgIcon:"../../Images/buttons/plasma_ui/oneDesktop.png"
                imgIconHov:"../../Images/buttons/plasma_ui/oneDesktopHov.png"
                mainIconWidth: 0.45 * winStateItem.width
                mainIconHeight: 0.85 * mainIconWidth
            }
        }

    ]

    function nextState(){
        if (winStateItem.state === "oneDesktop")
            winStateItem.state = "allDesktops";
        else if (winStateItem.state === "allDesktops")
            winStateItem.state = "sameDesktops";
        else if (winStateItem.state === "sameDesktops")
            winStateItem.state = "allActivities";
        else if (winStateItem.state === "allActivities")
            winStateItem.state = "oneDesktop";
    }

    function previousState(){
        if (winStateItem.state === "oneDesktop")
            winStateItem.state = "allActivities";
        else if (winStateItem.state === "allDesktops")
            winStateItem.state = "oneDesktop";
        else if (winStateItem.state === "sameDesktops")
            winStateItem.state = "allDesktops";
        else if (winStateItem.state === "allActivities")
            winStateItem.state = "sameDesktops";
    }

}
