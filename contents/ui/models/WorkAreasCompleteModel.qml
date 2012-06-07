// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.0

ListModel {
    ListElement {
        code:"a0a"
        CState:"Running"
        Current:false
        elemImg:"../Images/backgrounds/background1.jpg"
        workareas: [
                ListElement {
                    gridRow:0
                    gridColumn:0
                    elemTitle:"Movies"
                    elemShowAdd: false
                    elemTempOnDragging: false
                },

                ListElement {
                    gridRow:1
                    gridColumn:0
                    elemTitle: "KDe"
                    elemShowAdd: false
                    elemTempOnDragging: false
                }

        ]
    }

    ListElement {
        code:"b0b"
        CState:"Stopped"
        Current:false
        elemImg:"../Images/backgrounds/background2.jpg"
        workareas: [
            ListElement {
                gridRow:0
                gridColumn:1
                elemTitle:"Programming"
                elemShowAdd: false
                elemTempOnDragging: false
            },

            ListElement {
                gridRow:1
                gridColumn:1
                elemTitle: "Image Editing"
                elemShowAdd: false
                elemTempOnDragging: false
            },

            ListElement {
                gridRow:2
                gridColumn:1
                elemTitle: "All Lessons"
                elemShowAdd: false
                elemTempOnDragging: false
            }

        ]
    }

    ListElement {
        code:"c0c"
        CState:"Running"
        Current:true
        elemImg:"../Images/backgrounds/background3.jpg"
        workareas: [
            ListElement {
                gridRow:0
                gridColumn:2
                elemTitle:"School"
                elemShowAdd: false
                elemTempOnDragging: false

            },

            ListElement {
                gridRow:1
                gridColumn:2
                elemTitle: "Lyrics"
                elemShowAdd: false
                elemTempOnDragging: false
            },

            ListElement {
                gridRow:2
                gridColumn:2
                elemTitle: "Cyclos"
                elemShowAdd: false
                elemTempOnDragging: false
            },

            ListElement {
                gridRow:3
                gridColumn:2
                elemTitle: "Bash"
                elemShowAdd: false
                elemTempOnDragging: false
            }
        ]
    }


    ListElement {
        code:"d0d"
        CState:"Running"
        Current:false
        elemImg:"../Images/backgrounds/background4.jpg"
        workareas: [
            ListElement {
                gridRow:0
                gridColumn:3
                elemTitle:"OpenSuse"
                elemShowAdd: false
                elemTempOnDragging: false
            },

            ListElement {
                gridRow:1
                gridColumn:3
                elemTitle: "Mint"
                elemShowAdd: false
                elemTempOnDragging: false
            }

        ]
    }

}
