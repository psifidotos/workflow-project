import QtQuick 1.0

ListModel {
    ListElement {
        gridRow:0
        gridColumn:3
        elemTitle:"OpenSuse"
        elemImg:"Images/screens/linux1.png"
        elemShowAdd: false
        elemTempOnDragging: false
    }

    ListElement {
        gridRow:1
        gridColumn:3
        elemTitle: "Mint"
        elemImg:"Images/screens/linux2.png"
        elemShowAdd: false
        elemTempOnDragging: false
    }

    ListElement {
        gridRow:2
        gridColumn:3
        elemTitle: "Mint"
        elemImg:"Images/screens/linux2.png"
        elemShowAdd: true
        elemTempOnDragging: false
    }

}
