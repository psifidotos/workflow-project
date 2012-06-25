// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

ListModel {
    //This is a ghost element in order to fix bug
    //when removing the first element or when
    //removing the first and only element....
    ListElement {
        code:"DontShow"
        Current:false
        Name:"DontShow"
        Icon:"DontShow"
        CState:"DontShow"
    }

}
