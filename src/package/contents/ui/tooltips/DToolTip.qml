// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.qtextracomponents 0.1

import ".."

PlasmaCore.FrameSvgItem{

    id: container

    parent: mainView
    imagePath: "widgets/tooltip"
    width: horSize > maxHorSize ? maxHorSize : horSize
    height: Math.max(fullHeightMargins+titleTxt.height+5+mainTxt.height,iconWidth+fullHeightMargins)
    opacity: 0

    property variant target: tempMouseArea
    property int insideMargin: 0.15 * mainView.scaleMeter
    property int horSize: iconWidth + mainTxt.width + fullWidthMargins
    property int maxHorSize: 8 * mainView.scaleMeter
    property int minHorSize: 4 * mainView.scaleMeter
    property int maxHorSizeNoMargins: maxHorSize - margins.left - margins.right - 2 * insideMargin
    property string icon: ""
    property string localIcon: ""
    property int iconWidth: (icon !== "" || localIcon !== "") ? maxHorSize / 9 : 0
    property int fullWidthMargins: margins.left + margins.right + 2 * insideMargin
    property int fullHeightMargins: margins.top + margins.bottom + 2 * insideMargin
    property string title: ""
    property string mainText: ""

    Behavior on opacity{
        NumberAnimation {
            duration: 2 * storedParameters.animationsStep;
            easing.type: Easing.InOutQuad;
        }
    }

    QIconItem{
        id: iconImg
        visible: parent.icon !== "" ? true : false
        icon: parent.icon !== "" ? QIcon(parent.icon) : QIcon()
        width: parent.iconWidth
        height: width
        anchors.top: parent.top
        anchors.topMargin: parent.margins.top + insideMargin
        anchors.left: parent.left
        anchors.leftMargin: parent.margins.left + insideMargin
    }

    Image{
        id: localIconImg
        visible: parent.localIcon !== "" ? true : false
        source: parent.localIcon
        width: parent.iconWidth
        height: width
        smooth: true
        anchors.top: parent.top
        anchors.topMargin: parent.margins.top
        anchors.left: parent.left
        anchors.leftMargin: parent.margins.left + insideMargin

    }

    Text{
        id:titleTxt

        anchors.top: parent.top
        anchors.topMargin: parent.margins.top+insideMargin
        anchors.left: iconImg.right
        anchors.leftMargin: 3

        horizontalAlignment: Text.AlignLeft
        text: container.title

        width: container.width - parent.iconWidth - container.margins.right - container.margins.left
        elide: Text.ElideRight
        color: mainView.defaultFontColor
        font.family: mainView.defaultFont.family
        font.pixelSize: 0.34 * mainView.scaleMeter
        font.bold: true
        font.italic: true

        wrapMode: Text.Wrap
        maximumLineCount: 2
    }

    Text{
        id: shadowTitleTxt
        opacity: 0

        anchors.top: parent.top
        anchors.topMargin: parent.margins.top + insideMargin
        anchors.left: iconImg.right
        anchors.leftMargin: 3

        horizontalAlignment: Text.AlignLeft
        text: container.title

        color: mainView.defaultFontColor
        font.family: mainView.defaultFont.family
        font.pixelSize: 0.34 * mainView.scaleMeter

        font.bold: true
        font.italic: true

        wrapMode: Text.Wrap
        maximumLineCount: 2
    }

    Text{
        id: mainTxt
        anchors.top: titleTxt.bottom
        anchors.left: titleTxt.left

        text: container.mainText
        color: mainView.defaultFontColor
        font.family: mainView.defaultFont.family

        font.pixelSize: 0.32 * mainView.scaleMeter

        property int findWidth: shadowMainTxt.width - parent.iconWidth - fullWidthMargins
        width: findWidth < parent.maxHorSizeNoMargins - parent.iconWidth - 3 ?
                                  Math.max(findWidth, minHorSize) :
                                  maxHorSizeNoMargins - parent.iconWidth - 3

        wrapMode:Text.WordWrap
    }

    Text{
        id: shadowMainTxt
        anchors.top: titleTxt.bottom
        anchors.left: titleTxt.left

        opacity: 0
        text: container.mainText
        color: mainView.defaultFontColor
        font.family: mainView.defaultFont.family

        font.pixelSize: 0.32 * mainView.scaleMeter
    }

    //for not appearing errors
    MouseArea{
        id: tempMouseArea
        anchors.fill: parent
        onEntered:{}
        onExited:{}
    }

    Component.onCompleted: {
//        target.hoverEnabled = true;
    }

    Connections{
        target: container.target
        onEntered:{
            showToolTip();
        }
        onExited:{
            hideToolTip();
        }
        onClicked:{
            hideToolTip();
        }
        onPressAndHold:{
            hideToolTip();
        }
        onPressed:{
            hideToolTip();
        }
    }

    Timer{
        id: toolTipTimer
        interval: storedParameters.toolTipsDelay
        repeat: false

        onTriggered: {
            var newC = target.mapToItem(mainView, target.x + target.width, target.y + target.height);
            var newC2 = target.mapToItem(mainView, target.x, target.y);

            var maxX = mainView.width - container.width;
            var maxY = mainView.height - container.height;

            if (newC.x < maxX)
                container.x = newC.x + 3;
            else
                container.x = newC2.x - 3 - container.width;


            if (newC.y < maxY)
                if(newC.x < maxX)
                    container.y = newC.y + 3;
                else
                    container.y = newC2.y + 3;
            else
                container.y = newC2.y - 3 - container.height;

            container.opacity = 1;
        }
    }

    function showToolTip(){
        if(storedParameters.toolTipsDelay > 0){
            if (target !== tempMouseArea && !toolTipTimer.running){
                toolTipTimer.start();
            }
        }
    }

    function hideToolTip(){
        toolTipTimer.stop();
        container.opacity = 0;
    }

}
