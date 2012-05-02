// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.0

ListModel {
    ListElement {
        code:"235"
        CState:"Running"
        workareas: [
                ListElement {
                    gridRow:0
                    gridColumn:0
                    elemTitle:"Movies"
                    elemImg:"Images/backgrounds/background1.jpg"
                    elemShowAdd: false
                    elemTempOnDragging: false
                },

                ListElement {
                    gridRow:1
                    gridColumn:0
                    elemTitle: "KDe"
                    elemImg:"Images/backgrounds/background1.jpg"
                    elemShowAdd: false
                    elemTempOnDragging: false
                }

        ]
    }

    ListElement {
        code:"234"
        CState:"Stopped"
        workareas: [
            ListElement {
                gridRow:0
                gridColumn:1
                elemTitle:"Programming"
                elemImg:"Images/backgrounds/background2.jpg"
                elemShowAdd: false
                elemTempOnDragging: false
            },

            ListElement {
                gridRow:1
                gridColumn:1
                elemTitle: "Image Editing"
                elemImg: "Images/backgrounds/background2.jpg"
                elemShowAdd: false
                elemTempOnDragging: false
            },

            ListElement {
                gridRow:2
                gridColumn:1
                elemTitle: "All Lessons"
                elemImg:"Images/backgrounds/background2.jpg"
                elemShowAdd: false
                elemTempOnDragging: false
            }

        ]
    }

    ListElement {
        code:"202"
        CState:"Running"
        workareas: [
            ListElement {
                gridRow:0
                gridColumn:2
                elemTitle:"School"
                elemImg:"Images/backgrounds/background3.jpg"
                elemShowAdd: false
                elemTempOnDragging: false

            },

            ListElement {
                gridRow:1
                gridColumn:2
                elemTitle: "Lyrics"
                elemImg:"Images/backgrounds/background3.jpg"
                elemShowAdd: false
                elemTempOnDragging: false
            },

            ListElement {
                gridRow:2
                gridColumn:2
                elemTitle: "Cyclos"
                elemImg:"Images/backgrounds/background3.jpg"
                elemShowAdd: false
                elemTempOnDragging: false
            },

            ListElement {
                gridRow:3
                gridColumn:2
                elemTitle: "Bash"
                elemImg:"Images/backgrounds/background3.jpg"
                elemShowAdd: false
                elemTempOnDragging: false
            }
        ]
    }


    ListElement {
        code:"3423"
        CState:"Running"
        workareas: [
            ListElement {
                gridRow:0
                gridColumn:3
                elemTitle:"OpenSuse"
                elemImg:"Images/backgrounds/background4.jpg"
                elemShowAdd: false
                elemTempOnDragging: false
            },

            ListElement {
                gridRow:1
                gridColumn:3
                elemTitle: "Mint"
                elemImg:"Images/backgrounds/background4.jpg"
                elemShowAdd: false
                elemTempOnDragging: false
            }

        ]
    }

}
