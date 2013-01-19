// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import ".."
import "../models"
import "../../code/settings.js" as Settings

Item{

    objectName: "instThemeList"

    property variant model: ThemesModel{}

    property variant icons: model.get(themePos).icons.get(0)

    property int themePos:0

    property string currentTheme: "Oxygen"

    onCurrentThemeChanged: themePos = getIndexFor(currentTheme);

/*
    function getIndexFor(nam){
        for(var i=0; i<model.count; ++i){
            var obj = model.get(i);
            if (obj.name === nam)
                return i;
        }

        return 0;
    }
*/

}
