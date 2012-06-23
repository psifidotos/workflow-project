// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

ListModel {

    //This is a ghost element in order to fix bug
    //when removing the first element or when
    //removing the first and only element....
    ListElement {
        code:"DontShow"
        onAllDesktops:false
        onAllActivities:false
        classClass: "DontShow"
        name:"DontShow"
        Icon:"DontShow"
        inDragging:false
        desktop:1
        activities:"DontShow"
    }
    /*
    ListElement {
        code:"234"
        onAllDesktops:true
        onAllActivities:false
        classClass: "Dolphin"
        name:"Home Folder..."
        Icon:"Images/icons/file_manager.png"
        inDragging:false
        desktop:1
        activities:"d0d"
    }
    ListElement {
        code:"124"
        onAllDesktops:false
        onAllActivities:false
        classClass: "Dolphin"
        name:"My Documents"
        Icon:"Images/icons/file_manager.png"
        inDragging:false
        desktop:1
        activities:"a0a"
    }
    ListElement {
        code:"127"
        onAllDesktops:false
        onAllActivities:false
        classClass: "LibreOffice"
        name:"New Document..."
        Icon:"Images/icons/dolphin.png"
        inDragging:false
        desktop:1
        activities:"c0c"
    }
    ListElement {
        code:"132"
        onAllDesktops:false
        onAllActivities:false
        classClass: "LibreOffice"
        name:"New Document<2> - Various Text"
        Icon:"Images/icons/dolphin.png"
        inDragging:false
        desktop:1
        activities:"c0c"
    }
    ListElement {
        code:"136"
        onAllDesktops:true
        onAllActivities:true
        classClass: "LibreOffice"
        name:"New Document<4> - Around"
        Icon:"Images/icons/dolphin.png"
        inDragging:false
        desktop:1
        activities:"c0c"
    }
    ListElement {
        code:"143"
        onAllDesktops:true
        onAllActivities:true
        classClass: "Firefox"
        name:"www.in.gr"
        Icon:"Images/icons/activity3.png"
        inDragging:false
        desktop:1
        activities:"c0c"
    }*/
}
