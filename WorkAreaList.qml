// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Component{
    ListView {
        id:workalist

        height:mainView.workareaHeight*model.count

        //x:10+mainView.workareaWidth
        x:10
        spacing:3+workareaY / 5

        model:workareas
        delegate:WorkArea{

        }
    }
}
