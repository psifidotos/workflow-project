// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Column {
    Behavior on opacity{
        NumberAnimation {
            duration: 2*storedParameters.animationsStep;
            easing.type: Easing.InOutQuad;
        }
    }
}
