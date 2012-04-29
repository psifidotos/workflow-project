// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.0

ListModel {
    ListElement {
        code:"d3f"
        workareas: [
                ListElement {
                    gridRow:0
                    gridColumn:0
                    elemTitle:"Movies"
                    elemImg:"Images/screens/desk1.png"
                    elemShowAdd: false
                    elemTempOnDragging: false
                },

                ListElement {
                    gridRow:1
                    gridColumn:0
                    elemTitle: "KDe"
                    elemImg:"Images/screens/desk2.png"
                    elemShowAdd: false
                    elemTempOnDragging: false
                }

        ]
    }

    ListElement {
        code:"c2f"
        workareas: [
            ListElement {
                gridRow:0
                gridColumn:1
                elemTitle:"Programming"
                elemImg:"Images/screens/less1.png"
                elemShowAdd: false
                elemTempOnDragging: false
            },

            ListElement {
                gridRow:1
                gridColumn:1
                elemTitle: "Image Editing"
                elemImg:"Images/screens/less2.png"
                elemShowAdd: false
                elemTempOnDragging: false
            },

            ListElement {
                gridRow:2
                gridColumn:1
                elemTitle: "All Lessons"
                elemImg:"Images/screens/less3.png"
                elemShowAdd: false
                elemTempOnDragging: false
            }

        ]
    }

    ListElement {
        code:"e6f"
        workareas: [
            ListElement {
                gridRow:0
                gridColumn:2
                elemTitle:"School"
                elemImg:"Images/screens/dev1.png"
                elemShowAdd: false
                elemTempOnDragging: false

            },

            ListElement {
                gridRow:1
                gridColumn:2
                elemTitle: "Lyrics"
                elemImg:"Images/screens/dev2.png"
                elemShowAdd: false
                elemTempOnDragging: false
            },

            ListElement {
                gridRow:2
                gridColumn:2
                elemTitle: "Cyclos"
                elemImg:"Images/screens/dev3.png"
                elemShowAdd: false
                elemTempOnDragging: false
            },

            ListElement {
                gridRow:3
                gridColumn:2
                elemTitle: "Bash"
                elemImg:"Images/screens/dev4.png"
                elemShowAdd: false
                elemTempOnDragging: false
            }
        ]
    }


    ListElement {
        code:"e6f"
        workareas: [
            ListElement {
                gridRow:0
                gridColumn:3
                elemTitle:"OpenSuse"
                elemImg:"Images/screens/linux1.png"
                elemShowAdd: false
                elemTempOnDragging: false
            },

            ListElement {
                gridRow:1
                gridColumn:3
                elemTitle: "Mint"
                elemImg:"Images/screens/linux2.png"
                elemShowAdd: false
                elemTempOnDragging: false
            }

        ]
    }

}
