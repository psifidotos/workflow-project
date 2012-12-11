// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Row {
    Behavior on opacity{
        NumberAnimation {
            duration: 2*parametersManager.animationsStep;
            easing.type: Easing.InOutQuad;
        }
    }
}
