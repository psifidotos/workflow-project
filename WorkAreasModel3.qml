import QtQuick 1.0

ListModel {
    ListElement {
        gridRow:0
        gridColumn:2
        elemTitle:"School"
        elemImg:"Images/screens/dev1.png"
        elemShowAdd: false
        elemTempOnDragging: false

    }

    ListElement {
        gridRow:1
        gridColumn:2
        elemTitle: "Lyrics"
        elemImg:"Images/screens/dev2.png"
        elemShowAdd: false
        elemTempOnDragging: false
    }

    ListElement {
        gridRow:2
        gridColumn:2
        elemTitle: "Cyclos"
        elemImg:"Images/screens/dev3.png"
        elemShowAdd: false
        elemTempOnDragging: false
    }

    ListElement {
        gridRow:3
        gridColumn:2
        elemTitle: "Bash"
        elemImg:"Images/screens/dev4.png"
        elemShowAdd: false
        elemTempOnDragging: false
    }

    ListElement {
        gridRow:4
        gridColumn:2
        elemTitle: "Bash"
        elemImg:"Images/screens/dev4.png"
        elemShowAdd: true
        elemTempOnDragging: false
    }

}
