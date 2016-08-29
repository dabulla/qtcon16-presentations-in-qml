import QtQuick 2.4
import Qt.labs.presentation 1.0

Item {
    anchors.fill: parent
    property var presentation
    property bool textUnderIndicator
    SlideCounter {
        numberOfSlides: presentation.slides.length
        currentSlide: presentation.currentSlide
        startText: ""
    }
    //Clock {}
    ProgressIndicator {
        id: progInd
        width: parent.width * 0.2
        height: parent.height * 0.04
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: parent.width*0.01
        opacity: presentation.currentSlide > 0 && presentation.currentSlide !== presentation.slides.length-1
        sections: presentation.sections
        sectionHeaders: presentation.sectionHeaders
        slides: presentation.slides
        currentSlide: presentation.currentSlide
        showText: parent.textUnderIndicator
    }

    Rectangle {
        transform: Rotation { origin.x: 0; origin.y: 0; axis { x: 0; y: 0; z: 1 } angle: -90 }
        gradient: Gradient {
            GradientStop { position: 0; color: "#5caa15" }
            GradientStop { position: 1; color: "white" }
        }
        y: parent.height * 0.15
        x: 0
        height: parent.width
        width: parent.height / 250
        Behavior on y {
            NumberAnimation {
                duration: 1000
                easing.type: Easing.InOutQuad
            }
        }
    }

    Rectangle {
        transform: Rotation { origin.x: 0; origin.y: 0; axis { x: 0; y: 0; z: 1 } angle: -90 }
        gradient: Gradient {
            GradientStop { position: 0; color: "#5caa15" }
            GradientStop { position: 1; color: "white" }
        }
        y: parent.height * 0.91
        x: 0
        height: parent.width
        width: parent.height / 250
    }

}
