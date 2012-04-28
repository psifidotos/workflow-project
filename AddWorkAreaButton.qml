import QtQuick 1.0

Rectangle{

    width:mainWorkArea.width - workAreaButtons.width

    height:40
    color: fromColor
    property color fromColor:"#00c9c9c9"
    property color toColor:"#ffc9c9c9"
    property color borderFromColor:"#00686868"
    property color borderToColor:"#ff686868"

    border.color: borderFromColor
    border.width: 1
    radius: 6
    z:6

    Rectangle{
        width:20
        height:20
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        color:"transparent"

        Image {
            id:addButtonImage
            source:"Images/addWorkAreaBtn.png"
            width:parent.width
            height:parent.height

        }

    }

    Behavior on color{
        ColorAnimation { from: addWorkArea.color; duration: 500 }
    }
    Behavior on border.color{
        ColorAnimation { from: addWorkArea.border.color; duration: 500 }
    }


    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onEntered: {

            addWorkArea.color = addWorkArea.toColor;
            addWorkArea.border.color = addWorkArea.borderToColor;
        }

        onExited: {
            addWorkArea.color = addWorkArea.fromColor;
            addWorkArea.border.color = addWorkArea.borderFromColor;
        }

        onClicked:{
            var counts = mainWorkArea.ListView.view.model.count;
            console.debug(counts);
            var lastobj = mainWorkArea.ListView.view.model.get(counts-1);

             mainWorkArea.ListView.view.model.insert(counts-1, {
                                                        "elemTitle": "Dynamic",
                                                        "elemImg":lastobj.elemImg,
                                                        "elemShowAdd":false,
                                                        "gridRow":lastobj.gridRow,
                                                        "gridColumn":lastobj.gridColumn,
                                                        "elemTempOnDragging":false});

              mainWorkArea.ListView.view.model.setProperty(counts ,"gridRow",gridRow+1);
        /*    console.debug(mainWorkArea.gridRow+"-"+mainWorkArea.gridColumn);*/
        }

    }
}
