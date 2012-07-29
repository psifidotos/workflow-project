// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import "delegates"

import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.qtextracomponents 0.1

Item{

    id: allwlists

    property alias actImagHeight: actImag1.height
    property color actImagBordColor: "#77ffffff"

    property alias activitiesShown:activitiesList.shownActivities
    property alias flickableV:view.interactive

    width:mainView.width
    height:mainView.height

    property string typeId : "workareasMainView"


    Flickable{
        id: view

        width:stoppedPanel.x
        height:mainView.height

        //anchors.fill: parent
        contentWidth: allareas.width
        contentHeight: allareas.height + allActT.height

        boundsBehavior: Flickable.StopAtBounds

        property string typeId : "workareasFlick"

        Image{
            width:mainView.width<allareas.width ? allareas.width : mainView.width
            height:mainView.height<allareas.height ? allareas.height : mainView.height
            source:"Images/greyBackground.png"
            fillMode: Image.Tile
            property string typeId : "workareasFlickImage1"
        }


        ListView{
            id:allareas

            y:1.4 * mainView.workareaY

            width: activitiesList.shownActivities *  mainView.workareaWidth
            height: maxWorkAreasHeight + actImag1.height + actImag1Shad.height + scrollingMargin


            orientation: ListView.Horizontal

            anchors.left: parent.left
            interactive:false
            property string typeId : "workareasFlickList1"

            property int maxWorkAreasHeight: 0
            property int scrollingMargin: ((mainView.enablePreviews)&&(mainView.showWinds))?150:40

            model:instanceOfWorkAreasList.model

            delegate: WorkAreaListDeleg{
            }

            function changedChildHeight(){
                var max=0;

                for (var i=0; i<allareas.children[0].children.length; ++i)
                {
                    var childList = allareas.children[0].children[i];

                    if (childList.state === "show"){
                        var tempH = childList.height +  childList.addedHeight;
                        //console.debug(tempL);
                        if (tempH>max)
                            max = tempH;
                    }
                }

                allareas.maxWorkAreasHeight = max;
            }

        }


        //Top Activities Banner

        Rectangle{
            id:actImag1Shad
            anchors.top: actImag1.bottom

            width: mainView.width<allareas.width ? allareas.width : mainView.width
            height: workareaY/6
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#aa0f0f0f" }
                GradientStop { position: 1.0; color: "#00797979" }
            }
        }

        Rectangle {
            id: actImag1
            y:oxygenT.height
            width: mainView.width<allareas.width ? allareas.width : mainView.width

            height: 0.9*workareaY
            color: "#646464"
            border.color: allwlists.actImagBordColor
            border.width:1


            ListView {
                id: activitiesList

                orientation: ListView.Horizontal
                height:actImag1.height
                //height: 1.2*workareaY

                width: mainView.width<allareas.width ? allareas.width : mainView.width

                y: workareaY / 12

                interactive:false

                model: instanceOfActivitiesList.model
                delegate: ActivityDeleg{
                }

                property int shownActivities;

                Component.onCompleted: {
                    allwlists.updateShowActivities();
                }
            }

        }

        states: State {
            name: "ShowBars"
            when: view.movingVertically || view.movingHorizontally
            PropertyChanges { target: verticalScrollBar; opacity: 1 }
            PropertyChanges { target: horizontalScrollBar; opacity: 1 }
        }

        transitions: Transition {
            NumberAnimation { properties: "opacity"; duration: 2*mainView.animationsStep }
        }

    }//Flickable scrolling

    //Scrollbars
    // Attach scrollbars to the right and bottom edges of the view.
    /*
    ScrollBar {
        id: verticalScrollBar
        width: 12; height: view.height-12
        anchors.right: view.right
        opacity: 0
        orientation: Qt.Vertical
        position: view.visibleArea.yPosition
        pageSize: view.visibleArea.heightRatio
    }

    ScrollBar {
        id: horizontalScrollBar
        width: view.width-12; height: 12
        anchors.bottom: view.bottom
        opacity: 0
        orientation: Qt.Horizontal
        position: view.visibleArea.xPosition
        pageSize: view.visibleArea.widthRatio
    }*/

    PlasmaComponents.ScrollBar {
        id: verticalScrollBar
        width: 12;
        anchors.right: view.right
        opacity: 0
        orientation: Qt.Vertical
        flickableItem:view
    }

    PlasmaComponents.ScrollBar {
        id: horizontalScrollBar
        height: 12
        anchors.bottom: view.bottom
        opacity: 0
        orientation: Qt.Horizontal
        flickableItem:view
    }

    //return activities listview
    function getList(){
        return activitiesList;
    }

    function updateShowActivities(){
        var counter = 0;

        for (var i=0; i<activitiesList.model.count; ++i)
        {
            var elem = activitiesList.model.get(i);

            if (elem.CState === "Running")
                counter++;
        }
        activitiesList.shownActivities = counter+1;

        //console.debug("Get in:"+counter);
        //activitiesList.shownActivities = 8;
    }

    function getActivityColumn(cd){

        for (var i=0; i<allareas.children[0].children.length; ++i)
        {
            var elem = allareas.children[0].children[i];

            if (elem.ccode === cd)
                return elem;
        }

    }
}
