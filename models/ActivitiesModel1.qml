// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

ListModel {

    ListElement {
        code:0
        Current:false
        Name:"Δομημένος Προγραμματισμός"
        Icon:"Images/icons/activity1.png"
        CState:"Running"
    }

    ListElement {
        code:1
        Current:true
        Name:"Chess"
        Icon:"Images/icons/activity2.png"
        CState:"Stopped"
    }

    ListElement {
        code:2
        Current:false
        Name:"Programming"
        Icon:"Images/icons/activity3.png"
        CState:"Running"
    }

    ListElement {
        code:3
        Current:false
        Name:"Designing"
        Icon:"Images/icons/activity4.png"
        CState:"Running"
    }

}