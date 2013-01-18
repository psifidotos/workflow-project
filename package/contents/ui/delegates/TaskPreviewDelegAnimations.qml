// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import "../../code/settings.js" as Settings

ParallelAnimation{
    NumberAnimation {
        target: taskDeleg2;
        property: "width"
        duration: Settings.global.animationStep;
        easing.type: Easing.InOutQuad;
    }
    NumberAnimation {
        target: taskDeleg2;
        property: "height"
        duration: Settings.global.animationStep;
        easing.type: Easing.InOutQuad;
    }
    NumberAnimation {
        target: taskDeleg2;
        property: "y"
        duration: Settings.global.animationStep;
        easing.type: Easing.InOutQuad;
    }
    NumberAnimation {
        target: taskDeleg2;
        property: "x"
        duration: Settings.global.animationStep;
        easing.type: Easing.InOutQuad;
    }


    NumberAnimation {
        target: imageTask2;
        property: "width"
        duration: Settings.global.animationStep;
        easing.type: Easing.InOutQuad;
    }
    NumberAnimation {
        target: imageTask2;
        property: "x"
        duration: Settings.global.animationStep;
        easing.type: Easing.InOutQuad;
    }
    NumberAnimation {
        target: imageTask2;
        property: "y"
        duration: Settings.global.animationStep;
        easing.type: Easing.InOutQuad;
    }


    NumberAnimation {
        target: taskTitleRec;
        property: "x"
        duration: Settings.global.animationStep;
        easing.type: Easing.InOutQuad;
    }
    NumberAnimation {
        target: taskTitleRec;
        property: "y"
        duration: Settings.global.animationStep;
        easing.type: Easing.InOutQuad;
    }
    NumberAnimation {
        target: taskTitleRec;
        property: "opacity"
        duration: Settings.global.animationStep;
        easing.type: Easing.InOutQuad;
    }
    NumberAnimation {
        target: taskTitleRec;
        property: "width"
        duration: Settings.global.animationStep;
        easing.type: Easing.InOutQuad;
    }

    NumberAnimation {
        target: previewRect;
        property: "width"
        duration: Settings.global.animationStep;
        easing.type: Easing.InOutQuad;
    }
    NumberAnimation {
        target: previewRect;
        property: "height"
        duration: Settings.global.animationStep;
        easing.type: Easing.InOutQuad;
    }
    NumberAnimation {
        target: previewRect;
        property: "y"
        duration: Settings.global.animationStep;
        easing.type: Easing.InOutQuad;
    }
    NumberAnimation {
        target: previewRect;
        property: "x"
        duration: Settings.global.animationStep;
        easing.type: Easing.InOutQuad;
    }

    NumberAnimation {
        target: taskHoverRect;
        property: "opacity"
        duration: Settings.global.animationStep;
        easing.type: Easing.InOutQuad;
    }

    NumberAnimation {
        target: allTasksBtns;
        property: "opacity"
        duration: Settings.global.animationStep;
        easing.type: Easing.InOutQuad;
    }
    NumberAnimation {
        target: allTasksBtns;
        property: "width"
        duration: Settings.global.animationStep;
        easing.type: Easing.InOutQuad;
    }
    NumberAnimation {
        target: allTasksBtns;
        property: "x"
        duration: Settings.global.animationStep;
        easing.type: Easing.InOutQuad;
    }
    NumberAnimation {
        target: allTasksBtns;
        property: "y"
        duration: Settings.global.animationStep;
        easing.type: Easing.InOutQuad;
    }


}
