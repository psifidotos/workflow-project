// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

ParallelAnimation{
    NumberAnimation {
        target: taskDeleg2;
        property: "width"
        duration: storedParameters.animationsStep;
        easing.type: Easing.InOutQuad;
    }
    NumberAnimation {
        target: taskDeleg2;
        property: "height"
        duration: storedParameters.animationsStep;
        easing.type: Easing.InOutQuad;
    }
    NumberAnimation {
        target: taskDeleg2;
        property: "y"
        duration: storedParameters.animationsStep;
        easing.type: Easing.InOutQuad;
    }
    NumberAnimation {
        target: taskDeleg2;
        property: "x"
        duration: storedParameters.animationsStep;
        easing.type: Easing.InOutQuad;
    }


    NumberAnimation {
        target: imageTask2;
        property: "width"
        duration: storedParameters.animationsStep;
        easing.type: Easing.InOutQuad;
    }
    NumberAnimation {
        target: imageTask2;
        property: "x"
        duration: storedParameters.animationsStep;
        easing.type: Easing.InOutQuad;
    }
    NumberAnimation {
        target: imageTask2;
        property: "y"
        duration: storedParameters.animationsStep;
        easing.type: Easing.InOutQuad;
    }


    NumberAnimation {
        target: taskTitleRec;
        property: "x"
        duration: storedParameters.animationsStep;
        easing.type: Easing.InOutQuad;
    }
    NumberAnimation {
        target: taskTitleRec;
        property: "y"
        duration: storedParameters.animationsStep;
        easing.type: Easing.InOutQuad;
    }
    NumberAnimation {
        target: taskTitleRec;
        property: "opacity"
        duration: storedParameters.animationsStep;
        easing.type: Easing.InOutQuad;
    }
    NumberAnimation {
        target: taskTitleRec;
        property: "width"
        duration: storedParameters.animationsStep;
        easing.type: Easing.InOutQuad;
    }

    NumberAnimation {
        target: previewRect;
        property: "width"
        duration: storedParameters.animationsStep;
        easing.type: Easing.InOutQuad;
    }
    NumberAnimation {
        target: previewRect;
        property: "height"
        duration: storedParameters.animationsStep;
        easing.type: Easing.InOutQuad;
    }
    NumberAnimation {
        target: previewRect;
        property: "y"
        duration: storedParameters.animationsStep;
        easing.type: Easing.InOutQuad;
    }
    NumberAnimation {
        target: previewRect;
        property: "x"
        duration: storedParameters.animationsStep;
        easing.type: Easing.InOutQuad;
    }

    NumberAnimation {
        target: taskHoverRect;
        property: "opacity"
        duration: storedParameters.animationsStep;
        easing.type: Easing.InOutQuad;
    }

    NumberAnimation {
        target: allTasksBtns;
        property: "opacity"
        duration: storedParameters.animationsStep;
        easing.type: Easing.InOutQuad;
    }
    NumberAnimation {
        target: allTasksBtns;
        property: "width"
        duration: storedParameters.animationsStep;
        easing.type: Easing.InOutQuad;
    }
    NumberAnimation {
        target: allTasksBtns;
        property: "x"
        duration: storedParameters.animationsStep;
        easing.type: Easing.InOutQuad;
    }
    NumberAnimation {
        target: allTasksBtns;
        property: "y"
        duration: storedParameters.animationsStep;
        easing.type: Easing.InOutQuad;
    }


}
