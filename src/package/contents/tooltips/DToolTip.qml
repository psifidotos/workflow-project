// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.qtextracomponents 0.1

import ".."

PlasmaCore.FrameSvgItem{

    id:toolTip

    parent:mainView

    imagePath:"widgets/tooltip"

    property variant target:tempMouseArea
    // property variant masterMouseArea:tempMouseArea //Could be removed when instanceof would be supported


    property int insideMargin:0.15*mainView.scaleMeter
    property int horSize:iconWidth+mainTxt.width+fullWidthMargins

    //property int maxHorSize : Math.max(6*mainView.scaleMeter,shadowTitleTxt.width+iconImg.width+localIconImg.width+margins.left+margins.right)
    property int maxHorSize : 8*mainView.scaleMeter
    property int maxHorSizeNoMargins : (maxHorSize) - margins.left - margins.right -2*insideMargin

    property string icon:""
    property string localIcon:""

    property int iconWidth: ((icon!=="")||(localIcon!=="")) ? maxHorSize/5 : 0


    width:horSize > maxHorSize ? maxHorSize : horSize

    property int fullWidthMargins:margins.left+margins.right+2*insideMargin
    property int fullHeightMargins:margins.top+margins.bottom+2*insideMargin
    height:Math.max(fullHeightMargins+titleTxt.height+5+mainTxt.height,iconWidth+fullHeightMargins)

    opacity:0

    property string title:""
    property string mainText:""

    Behavior on opacity{
        NumberAnimation {
            duration: 2*mainView.animationsStep;
            easing.type: Easing.InOutQuad;
        }
    }


    //  onTargetChanged: {
    //   if (target.icon !== undefined)
    //       parent.icon = target.icon;
    //        for(var i=0; i<toolTip.children.length; i++)
    //            if(toolTip.children[i] instanceof MouseArea)
    //                console.debug(toolTip.children[i]);
    //  }


    /////////////Elements///////////

    QIconItem{
        id:iconImg
        visible:parent.icon !== "" ? true:false
        icon:parent.icon !== "" ? QIcon(parent.icon) : QIcon()
        width:parent.iconWidth
        height:width
        anchors.top:parent.top
        anchors.topMargin:parent.margins.top+insideMargin
        anchors.left:parent.left
        anchors.leftMargin: parent.margins.left+insideMargin
    }

    Image{
        id:localIconImg
        visible:parent.localIcon !== "" ? true:false
        source:parent.localIcon
        width:parent.iconWidth
        height:width
        smooth:true
        anchors.top:parent.top
        anchors.topMargin:parent.margins.top
        anchors.left:parent.left
        anchors.leftMargin: parent.margins.left+insideMargin

    }

    Text{
        id:titleTxt

        anchors.top:parent.top
        anchors.topMargin:parent.margins.top+insideMargin
        anchors.left: iconImg.right
        anchors.leftMargin:3

        horizontalAlignment: Text.AlignLeft
        text:toolTip.title

        width:toolTip.width - parent.iconWidth - toolTip.margins.right-toolTip.margins.left
        elide:Text.ElideRight
        color:mainView.defaultFontColor
        font.family:mainView.defaultFont.family
        font.pixelSize: 0.34*mainView.scaleMeter
        font.bold: true
        font.italic: true

        wrapMode: Text.Wrap
        maximumLineCount: 2
    }

    Text{
        id:shadowTitleTxt
        opacity:0

        anchors.top:parent.top
        anchors.topMargin:parent.margins.top+insideMargin
        anchors.left: iconImg.right
        anchors.leftMargin:3

        horizontalAlignment: Text.AlignLeft
        text:toolTip.title

        color:mainView.defaultFontColor
        font.family:mainView.defaultFont.family
        font.pixelSize: 0.34*mainView.scaleMeter

        font.bold: true
        font.italic: true

        wrapMode: Text.Wrap
        maximumLineCount: 2
    }
    /*
    Rectangle{
        width:1
        height:toolTip.width

        y:titleTxt.height+parent.margins.top+2

        rotation: -90
        transformOrigin: Item.TopLeft

        gradient: Gradient {
            GradientStop { position: 0.0; color: "#00f1f1f1" }
            GradientStop { position: 0.2; color: "#aaf1f1f1" }
            GradientStop { position: 0.8; color: "#aaf1f1f1" }
            GradientStop { position: 1.0; color: "#00f1f1f1" }

        }
    }*/

    Text{
        id:mainTxt
        anchors.top:titleTxt.bottom
        anchors.left:titleTxt.left

        text:toolTip.mainText
        color:mainView.defaultFontColor
        font.family:mainView.defaultFont.family

        font.pixelSize: 0.32*mainView.scaleMeter

        property int findWidth: shadowMainTxt.width-parent.iconWidth-fullWidthMargins
//        width: Math.max(findWidth < parent.maxHorSizeNoMargins - parent.iconWidth - 3 ?
  //                          findWidth + parent.margins.left :
    //                        maxHorSizeNoMargins - parent.iconWidth - 3,
      //                      shadowTitleTxt.width+parent.iconWidth)
        width: findWidth < parent.maxHorSizeNoMargins - parent.iconWidth - 3 ?
                                  findWidth :
                                  maxHorSizeNoMargins - parent.iconWidth - 3

        wrapMode:Text.WordWrap

        // width:toolTip.width
    }

    Text{
        id:shadowMainTxt
        anchors.top:titleTxt.bottom
        anchors.left:titleTxt.left

        opacity:0
        text:toolTip.mainText
        color:mainView.defaultFontColor
        font.family:mainView.defaultFont.family

        font.pixelSize: 0.32*mainView.scaleMeter

        // width:toolTip.width
    }

    //for not appearing errors
    MouseArea{
        id:tempMouseArea
        anchors.fill: parent
        onEntered:{}
        onExited:{}
    }

    Component.onCompleted: {
        target.hoverEnabled = true;
    }

    Connections{
        target:toolTip.target
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
    }

    Timer{
        id:toolTipTimer
        interval: mainView.toolTipsDelay
        repeat: false

        onTriggered: {
            var newC = target.mapToItem(mainView,target.x+target.width,target.y+target.height);
            var newC2 = target.mapToItem(mainView,target.x,target.y);

            var maxX = (mainView.width)-toolTip.width;
            var maxY = (mainView.height)-toolTip.height;

            if (newC.x<maxX)
                toolTip.x = newC.x+3;
            else
                toolTip.x = newC2.x-3-toolTip.width;


            if (newC.y<maxY)
                if(newC.x<maxX)
                    toolTip.y = newC.y+3;
                else
                    toolTip.y = newC2.y+3;
            else
                toolTip.y = newC2.y-3-toolTip.height;

            toolTip.opacity = 1;
        }
    }

    function showToolTip(){
        if(mainView.toolTipsDelay>0){
            if ((target !== tempMouseArea)&&
                    (!toolTipTimer.running)){
                toolTipTimer.start();
            }
        }
    }

    function hideToolTip(){
        toolTipTimer.stop();
        toolTip.opacity = 0;
    }

}
