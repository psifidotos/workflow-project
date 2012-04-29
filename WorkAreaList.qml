// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Component{
    Item{
        //height:mainView.workareaHeight*workalist.model.count + 250
        ListView {
            id:workalist

            height:mainView.workareaHeight*model.count+(model.count-1)*spacing
            width:1.4 * mainView.workareaHeight

            x:10
            z:5

            spacing:3+workareaY / 5

            model:workareas
            delegate:WorkArea{
            }

            Behavior on height{
                NumberAnimation{
                    duration: 500;
                    easing.type: Easing.InOutQuad;
                }
            }
        }

        AddWorkAreaButton{
            id:addWorkArea

            z:3

            anchors.top:workalist.bottom
            anchors.topMargin: mainView.workareaHeight/4
            anchors.horizontalCenter: workalist.horizontalCenter

            MouseArea {
                anchors.fill: parent

                onClicked:{
                    var counts = workalist.model.count;
                    console.debug(counts);
                    var lastobj = workalist.model.get(counts-1);

                    workalist.model.append( {  "elemTitle": "Dynamic",
                                               "elemImg":lastobj.elemImg,
                                               "elemShowAdd":false,
                                               "gridRow":lastobj.gridRow+1,
                                               "gridColumn":lastobj.gridColumn,
                                               "elemTempOnDragging":false} );

                }


            }

        }
    }

}
