// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import "delegates"

import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.qtextracomponents 0.1

Item{
    id: allwlists
    property int scale: 50
    property alias actImagHeight: actImag1.height
    property color actImagBordColor: "#77ffffff"
    property alias activitiesShown:activitiesList.shownActivities
    property alias flickableV:view.interactive
    property string typeId : "workareasMainView"
    property int workareaWidth: 0
    property int workareaHeight: 0
    property int animationsStep: 0
    property int verticalScrollBarLocation: view.width

    Flickable{
        id: view

        anchors.fill: parent
        contentWidth: allareas.width
        contentHeight: allareas.height

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

            y: 2.8 * allwlists.scale
            //+1, for not creating a visual issue...
            width: (activitiesList.shownActivities + 1) * allwlists.workareaWidth
            height: maxWorkAreasHeight + actImag1.height + actImag1Shad.height

            orientation: ListView.Horizontal

            anchors.left: parent.left
            interactive:false
            property string typeId : "workareasFlickList1"

            property int maxWorkAreasHeight: 0

            model:instanceOfWorkAreasList.model

            delegate: WorkAreaListDeleg{}

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

            width: parent.width < allareas.width ? allareas.width : parent.width
            height: allwlists.scale / 3
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#aa0f0f0f" }
                GradientStop { position: 1.0; color: "#00797979" }
            }
        }

        Rectangle {
            id: actImag1
            width: allwlists.width < allareas.width ? allareas.width : allwlists.width

            height: 1.8 * allwlists.scale
            color: "#646464"
            border.color: allwlists.actImagBordColor
            border.width:1

            ListView {
                id: activitiesList

                orientation: ListView.Horizontal
                height:parent.height
                width: allareas.width
                interactive:false
                model: instanceOfActivitiesList.model
                delegate: ActivityDeleg{}
                property int shownActivities: 0

                Component.onCompleted: {
                    allwlists.updateShowActivities();
                }
            }
        }
    }//Flickable scrolling

    //Scrollbars
    // Attach scrollbars to the right and bottom edges of the view.
    ScrollBar {
        id: verticalScrollBar
        width: 11;
        anchors.top: view.top
        anchors.bottom: view.bottom
        x: allwlists.verticalScrollBarLocation - width
        opacity: 0
        orientation: Qt.Vertical
        position: view.visibleArea.yPosition
        pageSize: view.visibleArea.heightRatio

        states: State {
            name: "moving"
            when: view.movingVertically && view.height <= view.contentHeight
            PropertyChanges { target: verticalScrollBar; opacity: 1 }
        }
        transitions: Transition {
            NumberAnimation { properties: "opacity"; duration: 2 * allwlists.animationsStep }
        }
    }

    ScrollBar {
        id: horizontalScrollBar
        height: 11
        anchors.left: view.left
        width: allwlists.verticalScrollBarLocation
        anchors.bottom: view.bottom
        opacity: 0
        orientation: Qt.Horizontal
        position: view.visibleArea.xPosition
        pageSize: view.visibleArea.widthRatio
        states: State {
            name: "moving"
            when: view.movingHorizontally && view.width <= view.contentWidth
            PropertyChanges { target: horizontalScrollBar; opacity: 1 }
        }
        transitions: Transition {
            NumberAnimation { properties: "opacity"; duration: 2 * allwlists.animationsStep }
        }
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
        activitiesList.shownActivities = counter;
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
