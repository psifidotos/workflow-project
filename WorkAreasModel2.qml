import QtQuick 1.0

ListModel {
    ListElement {
        gridRow:0
        gridColumn:1
        elemTitle:"Programming"
        elemImg:"Images/screens/less1.png"
        elemShowAdd: false
        elemTempOnDragging: false
    }

    ListElement {
        gridRow:1
        gridColumn:1
        elemTitle: "Image Editing"
        elemImg:"Images/screens/less2.png"
        elemShowAdd: false
        elemTempOnDragging: false
    }

    ListElement {
        gridRow:2
        gridColumn:1
        elemTitle: "All Lessons"
        elemImg:"Images/screens/less3.png"
        elemShowAdd: false
        elemTempOnDragging: false
    }

    ListElement {
        gridRow:3
        gridColumn:1
        elemTitle: "All Lessons"
        elemImg:"Images/screens/less3.png"
        elemShowAdd: true
        elemTempOnDragging: false
    }


}
