// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import ".."
import "../models"

Item{

    objectName: "instThemeList"

    property variant model: ThemesModel{}

    property variant icons: model.get(themePos).icons.get(0)

    property int themePos:0

    property string currentTheme:storedParameters.currentTheme

    onCurrentThemeChanged: themePos = getIndexFor(currentTheme);

   // function getIcons(){
    //    return model.get(mainView.themePos).icons.get(0);
   // }

    function getIndexFor(nam){
        for(var i=0; i<model.count; ++i){
            var obj = model.get(i);
            if (obj.name === nam)
                return i;
        }

        return 0;
    }

    function loadThemes() {
        for(var i=0; i<model.count; i++){
            storedParameters.addTheme(model.get(i).name);
        }
    }

    Component.onCompleted: loadThemes();
}
