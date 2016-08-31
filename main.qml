import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
//import "examples/animatedbackground" as Animbg
//import "examples/customtransition" as Custtrans
//import "examples/notes" as Notes
//import "examples/tutorial" as Tut

ApplicationWindow {
    id:theAppWnd
    title: qsTr("Presentation")
    width: 1200
    height: 768
    visible: true
    //visibility: "FullScreen"
    visibility: "Windowed"

    PresentationsInQmlSlideDeck {
        anchors.fill: parent
    }
}
