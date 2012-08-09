// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item {

    //height:childrenRect.height

    property string objectNameType:"AnimatedParagraph"
    //TOP
    //BOTTOM
    //LEFT
    //RIGHT
    property string linePlace
    property bool lineForward:true

    property alias fullText: mainPar.fullText
    property alias texts: numbPar.texts

    property int lineSpace: 5

    AnimatedLine{
        id:lineAnim
        width:0
        height:0
        lengthEnd:1.1*parent.width
        startRotation: 0
    }

    AnimatedText{
        id:mainPar
        width:parent.width-4
    }

    NumberedList{
        id:numbPar
        anchors.top: mainPar.bottom
        anchors.topMargin: 5
    }

    Component.onCompleted: {

        if(linePlace==="LEFT"){
            lineAnim.x=-lineSpace;
            lineAnim.y=-lineSpace;
        }
        else if(linePlace==="RIGHT"){
            lineAnim.x=width+lineSpace;
            lineAnim.y=-lineSpace;
        }
        else if(linePlace==="TOP"){
            lineAnim.x=-lineSpace;
            lineAnim.y=-lineSpace;
        }
        else if(linePlace==="BOTTOM"){
            lineAnim.x=-lineSpace;
            lineAnim.y=width+lineSpace;
        }


        if((linePlace==="LEFT")||(linePlace==="RIGHT")){
            lineAnim.width = 1;
            lineAnim.isVertical = true;
        }
        else if((linePlace==="TOP")||(linePlace==="BOTTOM")){
            lineAnim.height = 1;
            lineAnim.isVertical = false;
        }

        if(lineForward===true){

            if(linePlace==="LEFT")
                lineAnim.transformOrigin = Item.BottomLeft;
            else if(linePlace==="RIGHT")
                lineAnim.transformOrigin = Item.TopLeft;
            else if(linePlace==="TOP")
                lineAnim.transformOrigin = Item.TopLeft;
            else if(linePlace==="BOTTOM")
                lineAnim.transformOrigin = Item.BottomRight;

            lineAnim.endRotation = 90;

        }
        else{
            if(linePlace==="LEFT")
                lineAnim.transformOrigin = Item.TopLeft;
            else if(linePlace==="RIGHT")
                lineAnim.transformOrigin = Item.BottomLeft;
            else if(linePlace==="TOP")
                lineAnim.transformOrigin = Item.BottomRightT;
            else if(linePlace==="BOTTOM")
                lineAnim.transformOrigin = Item.TopLeft;

            lineAnim.endRotation = -90;
        }
    }

    function startAnimation(){
        lineAnim.startAnimation();
        mainPar.startAnimation();
        numbPar.startAnimation();

    }

    function resetAnimation(){
        lineAnim.resetAnimation();
        mainPar.resetAnimation();
        numbPar.resetAnimation();
    }
}
