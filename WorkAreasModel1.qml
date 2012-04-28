import QtQuick 1.0

ListModel {
    ListElement {
        gridRow:0
        gridColumn:0
        elemTitle:"Movies"
        elemImg:"Images/screens/desk1.png"
        elemShowAdd: false
        elemTempOnDragging: false
    }

    ListElement {
        gridRow:1
        gridColumn:0
        elemTitle: "KDe"
        elemImg:"Images/screens/desk2.png"
        elemShowAdd: false
        elemTempOnDragging: false
    }

    ListElement {
        gridRow:2
        gridColumn:0
        elemTitle: "KDe"
        elemImg:"Images/screens/desk2.png"
        elemShowAdd: true
        elemTempOnDragging: false
    }

}
