/****************************************************************************
**
** Author: Daniel Bulla
** Contact: d.bulla@fh-aachen.de
**
****************************************************************************/

import Qt.labs.presentation 1.0
import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Scene3D 2.0
import QtQuick.Layouts 1.1
import QtCharts 2.0

Presentation
{
    id: presentation

    width: 1280
    height: 720

    Master {
        presentation: parent
    }

    property var sections: [
        [ slideTitle ],
        [ slideAdvantages, slideObtain, slideWhat ],
        [ slideHeatmap, slideEfficient, slideComp1, slideMockUp ],
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
        //title: "Title & Introduction"
        textFormat: Text.RichText
        centeredText: "<br><b>Presentations in Qml</b><br><br>Daniel Bulla, M. Eng.<br>FH Aachen University of applied science"
        // Hello my name is Daniel Bulla from FH Aachen University of applied sience and I want to share
        // my experience about creating presentations in qml with you and talk about why it might enable
        // us to take presenting in the future to a whole new level using new technology.
        // How did I come to Qml for presentations?
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
        centeredText: "https://github.com/qt-labs/qml-presentation-system\n\nhttps://github.com/dabulla/qml-presentation-system"
    }

    Slide {
        id: slideWhat
        title: "What you get"
        // What you basically get is the two classes "Presentation" and "Slide". "Slide" has implementation for 90% of the slides you will ever need.
        // You can show centered text, nested bullet points and even codeblocks with it.
        // Bulletpoints is just an array of text which will adapt it's size and wordwrapping automatically.
        content: [ "QML Components:",
                   " Presentation",
                   " Slide",
                   "  content, centeredText, ...",
                   "Tutorial & Examples"
                   ]
        contentWidth: parent.width * 0.6
        CodeBlock {
            anchors.fill: parent
            anchors.leftMargin: parent.width*0.4
            textColor: "black"
            code:
"Presentation {\n" +
"    // Slide Master\n" +
"    Rectangle {\n" +
"        anchors.fill: parent\n" +
"        color: \"white\"\n" +
"        SlideCounter {\n" +
"            anchors.right: parent.right\n" +
"            anchors.bottom: parent.bottom\n" +
"        }\n" +
"    }\n" +
"    Slide {\n" +
"        title: \""+ parent.title +"\"\n" +
"        content: [ \""+ parent.content[0] +"\",\n" +
"                   \""+ parent.content[1] +"\",\n" +
"                   \""+ parent.content[2] +"\",\n" +
"                   \""+ parent.content[3] +"\",\n" +
"                   \""+ parent.content[4] +"\" ]\n" +
"    }\n" +
"    Slide { ... }\n" +
"    Slide { ... }\n" +
"    ...\n" +
"}"
        }
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
    // Heatmap
    // slick step animation. QML Animations
    // It was not that much effort because I could copy paste a lot of my shaders into the presentation.
    // If you want to present your qml application with this, this may also be the case for you. I heard about people
    // who put there complete application inside the presentation to discuss a prototype or mockup with their stakeholders.

    Slide {
        id: slideHeatmap
        // Last year, when I did the presentation for my thesis I wanted to show 3D graphics and so I hacked some basic effects into my presentation using shaders.
        // Now, one year later this is not needed anymore because there is (or there will be) Qt3D which enables us to include fancy 3D graphics in a presentation.
        // Back when I did this, I also could reuse some of the code from my original application, e.g. I could copy/paste some shaders.
        // This is the use case we see on the top right. If you have an qml application and want to dicuss it with customers it may be efficient
        // to put it in a presentations and step through your frontend while talking.
        // Also if you have an application written in qml and want to discuss
        // a MockUp with your stakeholders it may be efficient to put the qml of your app into a presentation.
        title: "New frameworks and components we can use"
        content: ["Examples:", " Qt3D", " QtCharts"]
        delayPoints: true
        showAllPoints: true
        Scene3D {
            id: scene3d
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            width: parent.width * (slideHeatmap.currentStep === 1 ? 1.0 : 0.33)
            height: slideHeatmap.currentStep === 1 ? parent.height : Math.min(width, parent.height*0.5)
            z: slideHeatmap.currentStep === 1
            focus: true
            aspects: ["input", "logic"]
            cameraAspectRatioMode: Scene3D.AutomaticAspectRatio

            AnimatedEntity { vpw: width; vph: height}
            Behavior on width {
                NumberAnimation { duration: 500; easing.type: Easing.InOutQuad }
            }
            Behavior on height {
                NumberAnimation { duration: 500; easing.type: Easing.InOutQuad }
            }
            Behavior on z {
                NumberAnimation { duration: 500 }
            }
        }
        ChartView {
            id: chartView
            title: "Horizontal Bar series"
            anchors.bottom: parent.bottom
            x: parent.width*0.33
            z: slideHeatmap.currentStep === 2
            legend.alignment: Qt.AlignBottom
            antialiasing: true

            Behavior on z {
                NumberAnimation { duration: 500 }
            }
            HorizontalBarSeries {
                axisY: BarCategoryAxis { categories: ["2007", "2008", "2009", "2010", "2011", "2012" ] }
                axisX: ValueAxis {
                    min: 0
                    max: 14
                    minorTickCount: 5
                    minorGridVisible: slideHeatmap.currentStep === 2
                    tickCount: chartView.width/100
//                    Behavior on tickCount {
//                        NumberAnimation { duration: 2500; easing.type: Easing.InOutQuad }
//                    }
                }
                BarSet { label: "Bob"; values: [2, 2, 3, 4, 5, 6] }
                BarSet { label: "Susan"; values: [5, 1, 2, 4, 1, 7] }
                BarSet { label: "James"; values: [3, 5, 8, 13, 5, 8] }
            }
            states: [
                State {
                    name: "fullscreen"
                    when: slideHeatmap.currentStep === 2
                    PropertyChanges {
                        target: chartView
                        x: 0
                        width: parent.width
                        height: parent.height
                    }
                },
                State {
                    name: "preview"
                    when: slideHeatmap.currentStep !== 2
                    PropertyChanges {
                        target: chartView
                        x: parent.width * 0.33
                        width: parent.width * 0.33
                        height: Math.min(width, parent.height*0.5)
                    }
                }
            ]
            transitions: [
                Transition {
                    from: "preview"
                    to: "fullscreen"
                    SequentialAnimation {
                        PauseAnimation {
                            duration: 500
                        }
                        NumberAnimation {
                            duration: 500
                            target: chartView
                            properties: "x, width, height"
                            easing.type: Easing.InOutQuad
                        }
                    }
                },
                Transition {
                    from: "fullscreen"
                    to: "preview"
                    NumberAnimation {
                        target: chartView
                        duration: 500
                        properties: "x, width, height"
                        easing.type: Easing.InOutQuad
                        onStopped: {
                        }
                    }
                }
            ]
//            Behavior on width {
//                NumberAnimation { duration: 500; easing.type: Easing.InOutQuad }
//            }
//            Behavior on height {
//                NumberAnimation { duration: 500; easing.type: Easing.InOutQuad }
//            }
        }
        ChartView {
            title: "We learn"
            anchors.bottom: parent.bottom
            x: parent.width * 0.66
            width: parent.width * 0.4
            height: width
            legend.alignment: Qt.AlignBottom
            antialiasing: true
            animationOptions: ChartView.AllAnimations

            PieSeries {
                id: pieSeries
                PieSlice { label: "taste"; value: 3; labelVisible: slideHeatmap.currentStep !== 4 }
                PieSlice { label: "smell"; value: 3; labelVisible: slideHeatmap.currentStep !== 4 }
                PieSlice { label: "touch"; value: 6; labelVisible: true }
                PieSlice { label: "hearing"; value: 13; labelVisible: slideHeatmap.currentStep !== 4 }
                PieSlice { label: "sight"; value: 75; labelVisible: slideHeatmap.currentStep !== 4 }
//                PieSlice {
//                    label: "Others"
//                    value: slideHeatmap.currentStep === 4 ? 52.0 : 0.0
//                    labelVisible: slideHeatmap.currentStep === 4
//                }
            }
        }
        onCurrentStepChanged: {
            if(currentStep == 4 ) {
                pieSeries.find("touch").exploded = true
            }
        }
        function resetSlide() { pieSeries.find("touch").exploded = false }
        function advanceStep() {

            return currentStep < 4;
        }
    }

//    Slide {
//        id: slideEfficient
//        title: "Gain efficiency by using components"
//        // This first example was from my presentation of for masterthesis. It was okay for me to put a lot of effort into that.
//        // But usually you want to create slides more efficient and create them a lot faster.
//        // This is possible by reusing components.
//    }
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
            anchors.leftMargin: parent.width*0.6
            sources: [ ep.path + "images/surfel_circle2.png",
                       ep.path + "images/surfel_ellipse2.png",
                       ep.path + "images/surfel_raycast2.png" ]
            alignments: [Image.AlignBottom, Image.AlignBottom, Image.AlignBottom]
            // zoom out after every step by setting "step" to -1.
            // generates: -1,  0, -1,  1, -1,  2, ...
            step: slideComp1.currentStep%2 === 1 ? (slideComp1.currentStep-1)/2 : -1
        }
        function advanceStep() {
            return currentStep < imgCol.sources.length*2;
        }
    }
//    Slide {
//        id: slideCharts
//        // And since Qt 5.7 Qt Charts are also available for open source users and can be used in qml
//    }

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
        content: ["Interact with your presentation on stage",
                  "Open new channel to de",
                  "Need for new Dataformat",
                  " basic programmability",
                  " Still efficient to create slides, declarative" ]
    }

    Slide {
        id: slideEnd
        centeredText: "Thanks for your attention"
    }
}
