// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Component{
    Item{
        id: workList

        //height:mainView.workareaHeight*workalist.model.count + 250
      //  height:workalist.height + workalist.spacing + addWorkArea.height + mainView.workareaHeight/5
      //  width: 1.4 * mainView.workareaHeight
      //  width:0
        property string tCState : CState

        property string neededState:"Running"
        property string ccode:code

        opacity: CState === neededState ? 1 : 0

        width: CState === neededState ? 1.4 * mainView.workareaHeight : 0
        height: CState === neededState ? workalist.height + workalist.spacing + addWorkArea.height + mainView.workareaHeight/5 : 0

        onHeightChanged: allareas.changedChildHeight();

        Behavior on opacity{
            NumberAnimation {
                duration: 300;
                easing.type: Easing.InOutQuad;
            }
        }

        Behavior on width{
            NumberAnimation {
                duration: 300;
                easing.type: Easing.InOutQuad;
            }
        }

        ListView {
            id:workalist

            height:mainView.workareaHeight*model.count+(model.count-1)*spacing
            width: CState === "Running" ? 1.4 * mainView.workareaHeight : 0


            x:10
            z:5

            spacing:3+workareaY / 5

            interactive:false

            model:workareas
            delegate:WorkArea{
            }

            Behavior on height{
                NumberAnimation{
                    duration: 500;
                    easing.type: Easing.InOutQuad;
                }
            }

             //onHeightChanged: console.debug(height);
            //onHeightChanged: allareas.changedChildHeight()
        }

        AddWorkAreaButton{
            id:addWorkArea

            z:3

            anchors.top:workalist.bottom
            anchors.topMargin: mainView.workareaHeight/5
            anchors.horizontalCenter: workalist.horizontalCenter

            opacity: CState === neededState ? 1 : 0

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
