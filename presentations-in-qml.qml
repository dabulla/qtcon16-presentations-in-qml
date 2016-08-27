/****************************************************************************
**
** Author: Daniel Bulla
** Contact: d.bulla@fh-aachen.de
**
****************************************************************************/

import Qt.labs.presentation 1.0
import QtQuick 2.2
import QtQuick.Controls 1.2

import "qml"

Presentation
{
    id: presentation

    width: 1280
    height: 720

    SlideCounter {
        numberOfSlides: presentation.slides.length
        currentSlide: presentation.currentSlide
        startText: ""
    }
    //Clock {}
    ProgressIndicator {
        id: progInd
        width: presentation.width * 0.2
        height: presentation.height * 0.04
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: presentation.width*0.01
        opacity: presentation.currentSlide > 0 && presentation.currentSlide !== presentation.slides.length-1
        sections: presentation.sections
        sectionHeaders: presentation.sectionHeaders
        slides: presentation.slides
        currentSlide: presentation.currentSlide
    }
    property var sections: [
        [ slideTitle ],
        [ slideAdvantages, slideObtain, slideWhat ],
        [ slideThreeUsecases, slideHeatmap, slideEfficient, slideComp1, slideMockUp ],
        [ slideVr, slideEnd ]
    ]

    property var sectionHeaders: [
        "Intro",
        "Basics",
        "Use Cases",
        "End",
    ]

    Slide {
        id: slideTitle
        title: "Title & Introduction"
        // I want to encourage everyone to try creating presentations in qml. How did I come to this?
        // One year ago I did my Masterthesis, I've just written all my text in LaTeX, finished it, printed it
        // still had two weeks to prepare my a presentation to show my work to my professor. For me the question arised, which technology I
        // wanted to use for it.
    }

    Slide {
        id: slideAdvantages
        title: "What I was looking for"
        content: [
            "Freedom to add whatever I want to the presentation",
            "Clean and professional look",
            "Clean and professional way of creating it (efficient)"]
        // It was obvious to use LaTex, but I was unhappy with that because my professor is a very visual kind of person.
        // She wants a video in every presentation, a lot of pictures and I wanted to have slick animations, which help me to
        // give everyone an understanding of the algorithms I implemented. I used Powerpoint for this and it always got a mess when zooming pictures
        // or something.
    }

    Slide {
        id: slideObtain
        title: "Where to obtain"
        // I found the qml presentation framework in the qt-labs folder last year, this is not the case anymore you can obtain it from github now.
        // I even have my own fork where I basically added some components for reuse. I will come to them later.
    }

    Slide {
        id: slideWhat
        title: "What you get"
        // What you basically get is the two classes "Presentation" and "Slide". "Slide" has implementation for 90% of the slides you will ever need.
        // You can show centered text, nested bullet points and even codeblocks with it.
        // Bulletpoints is just an array of text which will adapt it's size and wordwrapping automatically.
    }

//    Slide {
//        id: slideThreeUsecases
//        centeredText: "2 Usescases"
//        // This was how you get started.
//        // Now I want to quickly introduce basic 3 Use Cases for Qml presentation and a fourth one which might be important in the future
//    }
//    Slide {
//        id: slide3Usecases
//        content: ["Usage example of animations",
//                  "Efficiently create presentations with components",
//                  "Discuss Mockups in presentation"]
//    }

    Slide {
        id: slideHeatmap
        title: "Step-by-step animation example"
        // slick step animation. QML Animations
        // It was not that much effort because I could copy paste a lot of my shaders into the presentation.
        // If you want to present your qml application with this, this may also be the case for you. I heard about people
        // who put there complete application inside the presentation to discuss a prototype or mockup with their stakeholders.

    }

    Slide {
        id: slideEfficient
        title: "Gain efficiency by using components"
        // This first example was from my presentation of for masterthesis. It was okay for me to put a lot of effort into that.
        // But usually you want to create slides more efficient and create them a lot faster.
        // This is possible by reusing components.
    }
    Slide {
        id: slideComp1
        delayPoints: true
        showAllPoints: true
        title: "Reusable Components"
        content: [ "ImageStepCompare", "ProgressIndicator" ]
        ExecutionPath { id:ep }
        ImageStepCompare {
            id: imgCol
            anchors.fill: parent
            anchors.leftMargin: parent.width*0.5
            sources: [ ep.path + "images/surfel_circle2.png",
                       ep.path + "images/surfel_ellipse2.png",
                       ep.path + "images/surfel_raycast2.png" ]
            alignments: [Image.AlignLeft, Image.AlignHCenter, Image.AlignRight]
            // zoom out after every step by setting "step" to -1.
            // generates: -1,  0, -1,  1, -1,  2, ...
            step: slideComp1.currentStep%2 === 1 ? (slideComp1.currentStep-1)/2 : -1
        }
        function advanceStep() {
            return currentStep < imgCol.sources.length*2;
        }
    }
    Slide {
        id: slideCharts
        // And since Qt 5.7 Qt Charts are also available for open source users and can be used in qml
    }

    Slide {
        id: slideMockUp
        title: "QML Applications in Presentations"
//        ControlsGalleryApplication {
//            anchors.fill: parent
//            anchors.leftMargin: parent.width*0.6
//        }
//        TabView {
//            id: tabView

//            anchors.fill: parent
//            anchors.leftMargin: parent.width*0.6

//            Tab {
//                title: "Buttons"
//                ButtonPage {
//                    enabled: true// enabler.checked
//                }
//            }
//            Tab {
//                title: "Progress"
//                ProgressPage {
//                    enabled: true// enabler.checked
//                }
//            }
//            Tab {
//                title: "Input"
//                InputPage {
//                    enabled: true// enabler.checked
//                }
//            }
//        }
    }

    Slide {
        id: slideVr
        title: "Presentation in virtual spaces"
        content: ["Need for new Dataformat",
                  " Programmable",
                  " Still efficient, declarative" ]
    }

    Slide {
        id: slideEnd
        centeredText: "Thanks for your attention"
    }
}
