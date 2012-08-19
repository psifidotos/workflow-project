// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

ListModel {
    ListElement{
        name:"Oxygen"
        icons:[
            ListElement{
                AddWidget:"list-add"
                PauseActivity:"media-playback-pause"
                CloneActivity:"tab-duplicate"
                DeleteActivity:"edit-delete"
                RunActivity:"media-playback-start"
                DialogImportant:"emblem-important"
                DialogInformation:"dialog-information"
                DialogAccept:"dialog-ok-apply"
                DialogCancel:"dialog-cancel"
                AddValue:"list-add"
                MinusValue:"list-remove"
                Previous:"go-previous"
                Next:"go-next"
                Exit:"dialog-close"
            }
        ]
    }
    ListElement{
        name:"Rosa"
        icons:[
            ListElement{
                AddWidget:"list-add"
                PauseActivity:"media-playback-pause"
                CloneActivity:"tab-duplicate"
                DeleteActivity:"edit-delete"
                RunActivity:"media-playback-start"
                DialogImportant:"emblem-important"
                DialogInformation:"dialog-information"
                DialogAccept:"dialog-ok-apply"
                DialogCancel:"editdelete"
                AddValue:"list-add"
                MinusValue:"kt-remove"
                Previous:"go-previous"
                Next:"go-next"
                Exit:"dialog-close"
            }


        ]
    }
    ListElement{
        name:"Faenza"
        icons:[
            ListElement{
                AddWidget:"add"
                PauseActivity:"media-playback-pause"
                CloneActivity:"tab-duplicate"
                DeleteActivity:"application-exit"
                RunActivity:"media-playback-start"
                DialogImportant:"emblem-important"
                DialogInformation:"dialog-information"
                DialogAccept:"dialog-ok-apply"
                DialogCancel:"dialog-cancel"
                AddValue:"media-skip-forward"
                MinusValue:"media-skip-backward"
                Previous:"go-previous"
                Next:"go-next"
                Exit:"dialog-close"
            }
        ]
    }

}
