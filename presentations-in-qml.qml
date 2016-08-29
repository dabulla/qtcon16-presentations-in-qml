/****************************************************************************
**
** Author: Daniel Bulla
** Contact: d.bulla@fh-aachen.de
**
****************************************************************************/

import Qt.labs.presentation 1.0
import QtQuick 2.4
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
        textUnderIndicator: presentation.slides[presentation.currentSlide] === slideComp1 && slideComp1.currentStep === imgCol.sources.length*2+1
    }

    property var sections: [
        [ slideTitle ],
        [ slideAdvantages, slideObtain, slideWhat ],
        [ /*slideAnimations,*/ slideHeatmaps, slideCompQt3D, slideMockUp, slideCompCharts, slideComp1 ],
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
        centeredText: "<br><b>Presentations in QML</b><br><br>Daniel Bulla, M. Eng.<br>FH Aachen University of Applied Sciences"
        // Hello my name is Daniel Bulla from FH Aachen University of applied sience and I want to share
        // my experience about creating presentations in qml with you.
        // First I want to ask who knows about the possibility to create presentations in qml?
        // And who did at least one presentation in qml?
        // The community for presenting in qml is not that big yet, let's change that!
        //// First I want to ask who did a presentation in qml in the past?
        //// Lot of hands: I hope I found some usecases which are new for you.
        //// Few hands: I think qml for presentations is a bit underuse for what it delivers. Maybe some of you consider using qml for their next presentation after this talk.
        //// And I will talk about why it might enable
        //// us to take presenting in the future to a whole new level using new technology.
        // How did I come to Qml for presentations?
        // One year ago I did my Masterthesis, I've just written all my text in LaTeX, finished it, printed it
        // still had two weeks to prepare my a presentation to show my work to my professor. For me the question arised, which technology I
        // wanted to use for it.
    }

    Slide {
        id: slideAdvantages
        title: "Characteristics"
        content: [
            "Freedom to add anything to slides",
//            " Animations",
//            " Bonus: interactive content",
            "Efficient (easy) creation of slides",
            "Clean and professional look",
            "Clean and professional way of creating it"]
        // It was obvious to use LaTex, but I was unhappy with that because my professor is a very visual kind of person.
        // She wants a video in every presentation, a lot of pictures and I wanted to have slick animations, which help me to
        // give everyone an understanding of the algorithms I implemented. I used Powerpoint for this in the past and it always got a mess when zooming pictures
        // or something.
    }

    // I brought one example of these animated slides. TODO: Introduce master thesis topic shortly
    DatapointSlide {
        id: slideHeatmaps
        showCode: true
    }

    Slide {
        id: slideMockUp
        title: "QML Applications"
        delayPoints: true
        showAllPoints: true
//        ControlsGalleryApplication {
//            anchors.fill: parent
//            anchors.leftMargin: parent.width*0.6
//        }
        TabView {
            id: tabView

            anchors.fill: parent
            anchors.leftMargin: parent.width*0.3
            anchors.rightMargin: parent.width*0.3
            currentIndex: slideMockUp.currentStep
            Tab {
                title: "Buttons"
                ButtonPage {
                    enabled: true// enabler.checked
                }
            }
            Tab {
                title: "Progress"
                ProgressPage {
                    enabled: true// enabler.checked
                }
            }
            Tab {
                title: "Input"
                InputPage {
                    enabled: true// enabler.checked
                }
            }
        }
        function advanceStep() {
            return currentStep < 2;
        }
    }

//    Slide {
//        id: slideObtain
//        title: "Where can I get it?"//"Where to obtain"
//        // I found the qml presentation framework in the qt-labs folder last year, this is not the case anymore you can obtain it from github now.
//        // I even have my own fork where I basically added some components for reuse. I will come to them later.
//        centeredText: "https://github.com/qt-labs/qml-presentation-system\n\nhttps://github.com/dabulla/qml-presentation-system"
//    }

//    Slide {
//        id: slideWhat
//        title: "What you get"
//        // What you basically get is the two classes "Presentation" and "Slide". "Slide" has implementation for 90% of the slides you will ever need.
//        // You can show centered text, nested bullet points and even codeblocks with it.
//        // Bulletpoints is just an array of text which will adapt it's size and wordwrapping automatically.
//        textFormat: Text.RichText
//        content: [ "Presentation Component",
//                   "Slide Component",
//                   " content, centeredText, ...",
//                   "Tutorial & Examples",
//                   "<it>printslides</it> to create PDFs"
//                   ]
//        contentWidth: parent.width * 0.35
//        CodeBlock {
//            anchors.fill: parent
//            anchors.leftMargin: parent.width*0.4
//            textColor: "black"
//            code:
//"Presentation {\n" +
//"    // Slide Master\n" +
//"    Rectangle {\n" +
//"        anchors.fill: parent\n" +
//"        color: \"white\"\n" +
//"        SlideCounter {\n" +
//"            anchors.right: parent.right\n" +
//"            anchors.bottom: parent.bottom\n" +
//"        }\n" +
//"    }\n" +
//"    Slide {\n" +
//"        title: \""+ parent.title +"\"\n" +
//"        content: [ \""+ parent.content[0] +"\",\n" +
//"                   \""+ parent.content[1] +"\",\n" +
//"                   \""+ parent.content[2] +"\",\n" +
//"                   \""+ parent.content[3] +"\",\n" +
//"                   \""+ parent.content[4] +"\" ]\n" +
//"    }\n" +
//"    Slide { ... }\n" +
//"    Slide { ... }\n" +
//"    ...\n" +
//"}"
//        }
//    }

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

//    Slide {
//        id: slideAnimations
//        title: "Doing animations"
//        // And since Qt 5.7 Qt Charts are also available for open source users and can be used in qml
//        CodeBlock {
//            anchors.fill: parent
//            anchors.leftMargin: -parent.width*0.01
//            anchors.bottomMargin: parent.height*0
//            anchors.topMargin: 0
//            anchors.rightMargin: parent.width*0.46
//            textColor: "black"
//            code:
//                "Slide {\n" +
//                "    id: theSlide\n" +
//                "    Image {\n" +
//                "       width: theSlide.width\n" +
//                "           * (theSlide.currentStep === 1 ? 1.0 : 0.5)\n" +
//                "    }\n" +
//                "    Behaviour on width {\n" +
//                "        NumberAnimation {\n" +
//                "            duration: 500\n" +
//                "            easing.type: Easing.InOutQuad\n" +
//                "        }\n" +
//                "    }\n" +
//                "}"
//        }
//        CodeBlock {
//            anchors.fill: parent
//            anchors.leftMargin: parent.width*0.55
//            anchors.topMargin: parent.height*0.0
//            anchors.rightMargin: -parent.width*0.01
//            textColor: "black"
//            code:
//                "states: [\n" +
//                "    State {\n" +
//                "        name: \"fullscreen\"\n" +
//                "        when: theSlide.currentStep === 1\n" +
//                "        PropertyChanges {\n" +
//                "            target: myImage\n" +
//                "            width: theSlide.width\n" +
//                "        }\n" +
//                "    }, ...\n" +
//                "]\n" +
//                "transitions: [\n" +
//                "    Transition {\n" +
//                "        from: \"preview\"\n" +
//                "        to: \"fullscreen\"\n" +
//                "        SequentialAnimation {\n" +
//                "            PauseAnimation { duration: 500 }\n" +
//                "            NumberAnimation {\n" +
//                "                duration: 500\n" +
//                "                target: myImage\n" +
//                "                properties: \"width, height\"\n" +
//                "                easing.type: Easing.InOutQuad\n" +
//                "            }\n" +
//                "        }\n" +
//                "    },\n" +
//                "    ...\n" +
//                "]\n"
//        }
//    }

    Slide {
        id: slideCompQt3D
        // Last year, when I did the presentation for my thesis I wanted to show 3D graphics and so I hacked some basic effects into my presentation using shaders.
        // Now, one year later this is not needed anymore because there is (or there will be) Qt3D which enables us to include fancy 3D graphics in a presentation.
        // Back when I did this, I also could reuse some of the code from my original application, e.g. I could copy/paste some shaders.
        // This is the use case we see on the top right. If you have an qml application and want to dicuss it with customers it may be efficient
        // to put it in a presentations and step through your frontend while talking.
        // Also if you have an application written in qml and want to discuss
        // a MockUp with your stakeholders it may be efficient to put the qml of your app into a presentation.
        title: "Qt3D"
        delayPoints: true
        showAllPoints: true
        Scene3D {
            id: scene3d
            anchors.centerIn: parent
//            anchors.bottom: parent.bottom
//            anchors.left: parent.left
            width: parent.width * (slideCompQt3D.currentStep === 1 ? 1.0 : 0.33)
            height: slideCompQt3D.currentStep === 1 ? parent.height : Math.min(width, parent.height*0.5)
            z: slideCompQt3D.currentStep === 1
            focus: true
            aspects: ["input", "logic"]
            cameraAspectRatioMode: Scene3D.AutomaticAspectRatio

            AnimatedEntity { vpw: width; vph: height }
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
        function advanceStep() {

            return currentStep < 1;
        }
    }

    Slide {
        id: slideCompCharts
        // Last year, when I did the presentation for my thesis I wanted to show 3D graphics and so I hacked some basic effects into my presentation using shaders.
        // Now, one year later this is not needed anymore because there is (or there will be) Qt3D which enables us to include fancy 3D graphics in a presentation.
        // Back when I did this, I also could reuse some of the code from my original application, e.g. I could copy/paste some shaders.
        // This is the use case we see on the top right. If you have an qml application and want to dicuss it with customers it may be efficient
        // to put it in a presentations and step through your frontend while talking.
        // Also if you have an application written in qml and want to discuss
        // a MockUp with your stakeholders it may be efficient to put the qml of your app into a presentation.
        title: "Charts"
        delayPoints: true
        showAllPoints: true
        CodeBlock {
            anchors.fill: parent
            anchors.leftMargin: parent.width*0.4
            anchors.bottomMargin: parent.height*0.6
            anchors.topMargin: chartView.y*0.5
            anchors.rightMargin: parent.width*0.05
            textColor: "black"
            code:
                "BarSeries {\n" +
                "    axisX: BarCategoryAxis {\n" +
                "       categories: [\"2007\", \"2008\", ... ]\n" +
                "    }\n" +
                "    BarSet { label: \"Bob\"; values: [2, 2, 3, 4, 5, 6] }\n" +
                "    BarSet { label: \"Susan\"; values: [5, 1, 2, 4, 1, 7] }\n" +
                "    BarSet { label: \"James\"; values: [3, 5, 8, 13, 5, 8] }\n" +
                "}"
        }
        CodeBlock {
            anchors.fill: parent
            anchors.leftMargin: parent.width*0.4
            anchors.topMargin: parent.height*0.5
            anchors.rightMargin: parent.width*0.05
            textColor: "black"
            code:
                "HorizontalBarSeries {\n" +
                "    axisY: BarCategoryAxis {\n" +
                "       categories: [\"2007\", \"2008\", ... ]\n" +
                "    }\n" +
                "    BarSet { label: \"Bob\"; values: [2, 2, 3, 4, 5, 6] }\n" +
                "    BarSet { label: \"Susan\"; values: [5, 1, 2, 4, 1, 7] }\n" +
                "    BarSet { label: \"James\"; values: [3, 5, 8, 13, 5, 8] }\n" +
                "}"
        }
        ChartView {
            id: chartView
            title: "Horizontal Bar series"
            y: -parent.height*0.088
            x: parent.width*0.0
            z: slideCompCharts.currentStep === 1
            legend.alignment: Qt.AlignBottom
            antialiasing: true

            Behavior on z {
                NumberAnimation { duration: 500 }
            }
            BarSeries {
                axisX: BarCategoryAxis { categories: ["2007", "2008", "2009", "2010", "2011", "2012" ] }
                axisY: ValueAxis {
                    min: 0
                    max: 14
                    minorTickCount: 5
                    minorGridVisible: slideCompCharts.currentStep === 1
                    tickCount: chartView.height/100
                }
                BarSet { label: "Bob"; values: [2, 2, 3, 4, 5, 6] }
                BarSet { label: "Susan"; values: [5, 1, 2, 4, 1, 7] }
                BarSet { label: "James"; values: [3, 5, 8, 13, 5, 8] }
            }
            states: [
                State {
                    name: "fullscreen"
                    when: slideCompCharts.currentStep === 1
                    PropertyChanges {
                        target: chartView
                        x: 0
                        width: slideCompCharts.width
                        height: slideCompCharts.height
                    }
                },
                State {
                    name: "preview"
                    when: slideCompCharts.currentStep !== 1
                    PropertyChanges {
                        target: chartView
                        x: slideCompCharts.width * 0.0
                        width: slideCompCharts.width * 0.4
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
            title: "% we learn from..."
            y: parent.height * 0.35
            width: parent.width * 0.4
            height: parent.height * 0.66
            legend.alignment: Qt.AlignBottom
            antialiasing: true
            animationOptions: ChartView.AllAnimations

            PieSeries {
                id: pieSeries
                PieSlice { label: "taste"; value: 3; labelVisible: slideCompCharts.currentStep !== 3 }
                PieSlice { label: "smell"; value: 3; labelVisible: slideCompCharts.currentStep !== 3 }
                PieSlice { label: "touch"; value: 6; labelVisible: slideCompCharts.currentStep !== 3 }
                PieSlice { label: "hearing"; value: 13; labelVisible: true; exploded: slideCompCharts.currentStep === 3 }
                PieSlice { label: "sight"; value: 75; labelVisible: slideCompCharts.currentStep !== 3 }
            }
        }
        function advanceStep() {
            return currentStep < 3;
        }
    }

//    Slide {
//        id: slideEfficient
//        title: "Gain efficiency by using components"
//        // This first example was from my presentation of for masterthesis. It was okay for me to put a lot of effort into that.
//        // But usually you want to create slides more efficient and create them a lot faster.
//        // This is possible by reusing components.
//    }
    //TODO: Might be two slides, use pictures from Masterthesis
    Slide {
        id: slideComp1
        delayPoints: true
        showAllPoints: true
        title: "Reusable components"
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
            return currentStep < imgCol.sources.length*2+1;
        }
    }

    Slide {
        id: slideVr
        title: "What about virtual reality?"
        content: ["Interact with your presentation on stage",
                  "Haptic communication channel",
                  "Need for new data formats",
                  " Basic programmability",
                  " Still efficient to create slides" ]
        Image {
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            width: parent.width * 0.4
            height: parent.height * 0.8
            fillMode: Image.PreserveAspectFit
            smooth: true
            mipmap: false
            source: ep.path + "images/presentation-vr-altspacevr.png"
        }
    }

    Slide {
        id: slideEnd
        centeredText: "Thanks for your attention"
    }

    property bool inTransition: false;

    property variant fromSlide
    property variant toSlide

    property int transitionTime: 500

    SequentialAnimation {
        id: forwardTransition
        PropertyAction { target: presentation; property: "inTransition"; value: true }
        PropertyAction { target: toSlide; property: "visible"; value: true }
        ParallelAnimation {
            NumberAnimation { target: fromSlide; property: "opacity"; from: 1; to: 0; duration: deck.transitionTime; easing.type: Easing.OutQuart }
            NumberAnimation { target: fromSlide; property: "scale"; from: 1; to: 1.01; duration: deck.transitionTime; easing.type: Easing.InOutQuart }
            NumberAnimation { target: toSlide; property: "opacity"; from: 0; to: 1; duration: deck.transitionTime; easing.type: Easing.InQuart }
            NumberAnimation { target: toSlide; property: "scale"; from: 0.9; to: 1; duration: deck.transitionTime; easing.type: Easing.InOutQuart }
        }
        PropertyAction { target: fromSlide; property: "visible"; value: false }
        PropertyAction { target: fromSlide; property: "scale"; value: 1 }
        PropertyAction { target: presentation; property: "inTransition"; value: false }
    }
    SequentialAnimation {
        id: backwardTransition
        running: false
        PropertyAction { target: presentation; property: "inTransition"; value: true }
        PropertyAction { target: toSlide; property: "visible"; value: true }
        ParallelAnimation {
            NumberAnimation { target: fromSlide; property: "opacity"; from: 1; to: 0; duration: deck.transitionTime; easing.type: Easing.OutQuart }
            NumberAnimation { target: fromSlide; property: "scale"; from: 1; to: 0.9; duration: deck.transitionTime; easing.type: Easing.InOutQuart }
            NumberAnimation { target: toSlide; property: "opacity"; from: 0; to: 1; duration: deck.transitionTime; easing.type: Easing.InQuart }
            NumberAnimation { target: toSlide; property: "scale"; from: 1.01; to: 1; duration: deck.transitionTime; easing.type: Easing.InOutQuart }
        }
        PropertyAction { target: fromSlide; property: "visible"; value: false }
        PropertyAction { target: fromSlide; property: "scale"; value: 1 }
        PropertyAction { target: presentation; property: "inTransition"; value: false }
    }

    function switchSlides(from, to, forward)
    {
        if (presentation.inTransition)
            return false

        from.resetSlide()
        if(!to.initialized)
            to.initSlide()

        presentation.fromSlide = from
        presentation.toSlide = to

        if (forward)
            forwardTransition.running = true
        else
            backwardTransition.running = true

        return true
    }
}
