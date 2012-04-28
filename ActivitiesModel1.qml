// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

ListModel {
    ListElement {
        Current:false
        Name:"Δομημένος Προγραμματισμός"
        Icon:"Images/icons/activity1.png"
        State:"Running"
    }

    ListElement {
        Current:true
        Name:"Chess"
        Icon:"Images/icons/activity2.png"
        State:"Running"
    }

    ListElement {
        Current:false
        Name:"Programming"
        Icon:"Images/icons/activity3.png"
        State:"Running"
    }

    ListElement {
        Current:false
        Name:"Designing"
        Icon:"Images/icons/activity4.png"
        State:"Running"
    }

}
