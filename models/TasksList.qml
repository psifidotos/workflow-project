// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

ListModel {

    ListElement {
        code:0
        onAllDesktops:false
        onAllActivities:false
        classClass: "Firefox"
        name:"Αρχική Σελίδα..."
        icon:"../Images/icons/activity3.png"
        shaded:false
        desktop:2
        activities:2
    }

    ListElement {
        code:2
        onAllDesktops:false
        onAllActivities:false
        classClass: "Dolphin"
        name:"Home Folder..."
        icon:"../Images/icons/file_manager.png"
        shaded:false
        desktop:1
        activities:3
    }

    ListElement {
        code:3
        onAllDesktops:false
        onAllActivities:false
        classClass: "Dolphin"
        name:"My Documents"
        icon:"../Images/icons/file_manager.png"
        shaded:false
        desktop:1
        activities:1
    }

    ListElement {
        code:5
        onAllDesktops:false
        onAllActivities:false
        classClass: "LibreOffice"
        name:"New Document..."
        icon:"../Images/icons/dolphin.png"
        shaded:false
        desktop:1
        activities:2
    }

    ListElement {
        code:5
        onAllDesktops:false
        onAllActivities:false
        classClass: "LibreOffice"
        name:"New Document<2> - Various Text"
        icon:"../Images/icons/dolphin.png"
        shaded:false
        desktop:1
        activities:2
    }

    ListElement {
        code:6
        onAllDesktops:false
        onAllActivities:true
        classClass: "LibreOffice"
        name:"New Document<4> - Around"
        icon:"../Images/icons/dolphin.png"
        shaded:false
        desktop:1
        activities:2
    }

    ListElement {
        code:7
        onAllDesktops:false
        onAllActivities:true
        classClass: "Firefox"
        name:"www.in.gr"
        icon:"../Images/icons/activity3.png"
        shaded:false
        desktop:1
        activities:1
    }



}
