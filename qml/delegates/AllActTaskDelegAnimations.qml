// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

ParallelAnimation{
    NumberAnimation {
        target: imageTask2;
        property: "width"
        duration: 3*mainView.animationsStep;
        easing.type: Easing.InOutQuad;
    }
    NumberAnimation {
        target: imageTask2;
        property: "x"
        duration: 3*mainView.animationsStep;
        easing.type: Easing.InOutQuad;
    }
    NumberAnimation {
        target: imageTask2;
        property: "y"
        duration: 3*mainView.animationsStep;
        easing.type: Easing.InOutQuad;
    }
    NumberAnimation {
        target: taskDeleg2;
        property: "y"
        duration: 3*mainView.animationsStep;
        easing.type: Easing.InOutQuad;
    }
    NumberAnimation {
        target: taskTitleRec;
        property: "y"
        duration: 3*mainView.animationsStep;
        easing.type: Easing.InOutQuad;
    }
    NumberAnimation {
        target: taskTitleRec;
        property: "opacity"
        duration: 3*mainView.animationsStep;
        easing.type: Easing.InOutQuad;
    }
    NumberAnimation {
        target: previewRect;
        property: "width"
        duration: 3*mainView.animationsStep;
        easing.type: Easing.InOutQuad;
    }
    NumberAnimation {
        target: previewRect;
        property: "height"
        duration: 3*mainView.animationsStep;
        easing.type: Easing.InOutQuad;
    }
    NumberAnimation {
        target: previewRect;
        property: "y"
        duration: 3*mainView.animationsStep;
        easing.type: Easing.InOutQuad;
    }
    NumberAnimation {
        target: previewRect;
        property: "x"
        duration: 3*mainView.animationsStep;
        easing.type: Easing.InOutQuad;
    }
}
