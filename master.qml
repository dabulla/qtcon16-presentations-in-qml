import QtQuick 2.4
import Qt.labs.presentation 1.0

Item {
    anchors.fill: parent
    property var presentation
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
    }
}
