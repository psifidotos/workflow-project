// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import ".."
import "../models"

Item{

    property variant model: ThemesModel{}

    property variant icons: model.get(mainView.themePos).icons.get(0)


   // function getIcons(){
    //    return model.get(mainView.themePos).icons.get(0);
   // }
}
