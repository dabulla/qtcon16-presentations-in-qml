import QtQuick 2.0
import Qt.labs.presentation 1.0

//TODO: another heatmap3d with-> step1: addition in gemeinsamer 3D Textur; step2: Transferfunktion a) b)

Slide {
    id: hmdpSilde
    property bool showCode: true
    delayPoints: true
    title: "Example"
    contentWidth: parent.width*0.55
    fontScale: 0.9
    showBullets: false
    textColor: "white"
    //TODO: only sho one bullet point
    content: [
        "3D voxelization of heatmap events",
        " 1. Create rectangles",
        " 2. Raster 2D normal distributions",
        " 3. Manually rasterize 3rd dimension",
        "  Optimization: remove small values (cut corners)",
        " 4. Store in shared 3D-texture",
        " 5. Transferfunction"
    ]
    Rectangle {
        anchors.fill: parent
        anchors.topMargin: -parent.height*0.07
        anchors.rightMargin: -parent.width*0.5
        anchors.leftMargin: -parent.width*0.5
        anchors.bottomMargin: -parent.width*0.003
        color: "black"
        z: -2
    }

    CodeBlock {
        id: codeblock
        z:hmdp.z+1
        anchors.fill: parent
        anchors.bottomMargin: parent.height*0.08
        anchors.rightMargin: parent.width*0.4
        visible: currentBullet == 1 && currentStep == 1
        title: "datapoint.geom / GLSL"
        textColor: "black"
        code:
    "layout( points ) in;\n" +
    "layout( triangle_strip, max_vertices = 60 ) out;\n" +
    "layout(invocations = 8) in;"
    }

    Rectangle {
        id: interpol
        z:hmdp.z+1
        anchors.fill: parent
        anchors.bottomMargin: parent.height*0.08
        anchors.rightMargin: parent.width*0.5
        visible: currentBullet == 4 && currentStep == 1
        Image {
            ExecutionPath { id: ep }
            anchors.fill: parent
            source: ep.path + "images/interpolation.png"
            fillMode: Image.PreserveAspectFit
        }
    }
    Rectangle {
        id: bigBlackRectangle
        anchors.fill: parent
        anchors.bottomMargin: parent.height*0.01
        color: "black"
        z: hmdp.z-1
        visible: interpol.visible
    }

    Rectangle {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.margins: 5
        width: 16
        height: 16
        color: "grey"
        opacity: 0.1
        MouseArea {
            anchors.fill: parent
            onClicked: {
                resetSteps();
            }
        }
    }

    function advanceStep() {
        switch(currentBullet) {
        case 1:
            return currentStep < 1 && showCode
//        case 4:
//            return currentStep < 2
        default:
            return false;
        }
    }

    //0: overview:  circ: off, norm: on, zebra: off
    //1: 2d raster: circ: off, norm: off, zebra: on
    HeatmapDatapoint {
        id: hmdp
        z: 100
        x: parent.width * 0.6 + (codeblock.visible?parent.width*0.08:0)
        y: parent.height*0.5-height*0.5
        visible: hmdpSilde.currentBullet < 6 && hm.visible === false
        Behavior on anchors.rightMargin {
            NumberAnimation { duration: 1000; easing.type: Easing.InOutCubic }
        }
        Behavior on x {
            NumberAnimation { duration: 1000; easing.type: Easing.InOutCubic }
        }
        Behavior on y {
            NumberAnimation { duration: 1000; easing.type: Easing.InOutCubic }
        }
        Behavior on width {
            NumberAnimation { duration: 1000; easing.type: Easing.InOutCubic }
        }
        Behavior on height {
            NumberAnimation { duration: 1000; easing.type: Easing.InOutCubic }
        }

        width: parent.width*0.4
        height: width
        slices: 7
        angle: Math.PI*0.25
        opacity: 0.0
        Behavior on angle {
            NumberAnimation { duration: 1500 }
        }
        states: [
            State {
                when: hmdpSilde.currentBullet === 0
                name: "overview"
                PropertyChanges {
                    target: hmdp
                    angle: Math.PI*0.25
                    angleHoriz: 0.5
                    colorlookup: false
                    zebra: false
                    circleAdapt: false
                    showNormDist: true
                    outerAlpha: false // todo: true test
                    sliceFrom: 0
                    sliceTo: hmdp.slices
                    opacity: 1.0
                    asRect: false
                }
                PropertyChanges {
                    target: rotationAnimation
                    running: false
                }
                PropertyChanges {
                    target: sliceAnimation
                    running: false
                }
            },
            State {
                when: hmdpSilde.currentBullet === 1
                name: "quads"
                PropertyChanges {
                    target: hmdp
                    //angle: Math.PI*0.25
                    //angleHoriz: 0.5
                    colorlookup: false
                    zebra: true
                    circleAdapt: false
                    showNormDist: true
                    outerAlpha: false // todo: true test
                    sliceFrom: 0
                    sliceTo: hmdp.slices
                    opacity: 1.0
                    asRect: true
                }
                PropertyChanges {
                    target: rotationAnimation
                    running: false
                }
                PropertyChanges {
                    target: sliceAnimation
                    running: false
                }
            },
//            State {
//                when: hmdpSilde.currentBullet === 2
//                name: "singlePlane3d"
//                PropertyChanges {
//                    target: hmdp
//                    angle: Math.PI*0.25
//                    angleHoriz: 0.5
//                    colorlookup: false
//                    zebra: false
//                    showNormDist: true
//                    outerAlpha: false
//                    opacity: 1.0
//                    asRect: true
//                }
//                PropertyChanges {
//                    target: rotationAnimation
//                    running: false
//                }
//            },
            State {
                when: hmdpSilde.currentBullet === 1 && hmdpSilde.currentStep === 1 || hmdpSilde.currentBullet === 2
                name: "zebra3d"
                PropertyChanges {
                    target: hmdp
                    angle: Math.PI*0.25
                    angleHoriz: 0.5
                    colorlookup: false
                    zebra: false
                    circleAdapt: false
                    showNormDist: true
                    outerAlpha: false
                    sliceFrom: 0
                    sliceTo: hmdp.slices
                    opacity: 1.0
                    asRect: true
                }
                PropertyChanges {
                    target: rotationAnimation
                    running: false
                }
                PropertyChanges {
                    target: sliceAnimation
                    running: false
                }
            },
            State {
                when: hmdpSilde.currentBullet === 3
                name: "circleAdapt"
                PropertyChanges {
                    target: hmdp
                    //angle: Math.PI*0.25 //TODO: animate
                    angleHoriz: 0.5
                    colorlookup: false
                    zebra: false
                    circleAdapt: true
                    showNormDist: true
                    outerAlpha: false
                    sliceFrom: 0
                    sliceTo: hmdp.slices
                    opacity: 1.0
                    asRect: true
                }
                PropertyChanges {
                    target: rotationAnimation
                    running: true
                }
                PropertyChanges {
                    target: sliceAnimation
                    running: false
                }
            },
            State {
                when: hmdpSilde.currentBullet === 4
                name: "lowerAlpha"
                PropertyChanges {
                    target: hmdp
                    //angle: Math.PI*0.25 //TODO: animate
                    angleHoriz: 0.5
                    colorlookup: false
                    zebra: false
                    circleAdapt: true
                    showNormDist: true
                    outerAlpha: true
                    sliceFrom: 0
                    sliceTo: hmdp.slices
                    opacity: 1.0
                    asRect: false
                }
                PropertyChanges {
                    target: rotationAnimation
                    running: true
                }
                PropertyChanges {
                    target: sliceAnimation
                    running: false
                }
            },
            State {
                when: hmdpSilde.currentBullet === 5
                name: "lowerAlpha2"
                PropertyChanges {
                    target: hmdp
                    //angle: Math.PI*0.25 //TODO: animate
                    angleHoriz: 0.5
                    colorlookup: false
                    zebra: false
                    circleAdapt: true
                    showNormDist: true
                    outerAlpha: true
                    sliceFrom: 0
                    sliceTo: hmdp.slices
                    opacity: 1.0
                    asRect: false
                    width: hmdpSilde.width * 0.1
                    height: hmdpSilde.height * 0.1
                    x: hmdpSilde.width * 0.73
                    y: hmdpSilde.height - hm.height * 0.95
                }
                PropertyChanges {
                    target: rotationAnimation
                    running: true
                }
                PropertyChanges {
                    target: sliceAnimation
                    running: false
                }
            }
        ]
        NumberAnimation {
            id: rotationAnimation
            loops: Animation.Infinite
            target: hmdp
            property: "angle"
            duration: 10000
            from: Math.PI*0.25
            to: Math.PI*1.25
        }
        ParallelAnimation {
            id:sliceAnimation
            NumberAnimation {
                loops: Animation.Infinite
                target: hmdp
                property: "sliceFrom"
                duration: 5000
                from: 0
                to: hmdp.slices
            }
            NumberAnimation {
                loops: Animation.Infinite
                target: hmdp
                property: "sliceTo"
                duration: 5000
                from: 0
                to: hmdp.slices
            }
        }
    }

    property real intensFac: 1.0//0.1+0.5*(hm.colorlookup)
    property real radiusFac: 0.8
    property list<HeatmapDatapointModel> pointModel: [
        HeatmapDatapointModel { centerx: 0.300; centery: 0.200; intensity: intensFac; radius: radiusFac * 0.1 },
        HeatmapDatapointModel { centerx: 0.010; centery: 0.300; intensity: intensFac; radius: radiusFac * 0.50 },
        HeatmapDatapointModel { centerx: 0.500; centery: 0.300; intensity: intensFac; radius: radiusFac * 0.3 },
        HeatmapDatapointModel { centerx: 0.700; centery: 0.700; intensity: intensFac; radius: radiusFac * 0.100 },
        HeatmapDatapointModel { centerx: 0.777; centery: 0.800; intensity: intensFac; radius: radiusFac * 0.120 },
        HeatmapDatapointModel { centerx: 0.800; centery: 0.900; intensity: intensFac; radius: radiusFac * 0.300 },
        HeatmapDatapointModel { centerx: 0.300; centery: 0.830; intensity: intensFac*0.3; radius: radiusFac * 0.300 },
        HeatmapDatapointModel { centerx: 0.320; centery: 0.650; intensity: intensFac*0.7; radius: radiusFac * 0.300 },
        HeatmapDatapointModel { centerx: 0.300; centery: 0.570; intensity: intensFac*0.5; radius: radiusFac * 0.100 },
        HeatmapDatapointModel { centerx: 0.717; centery: 0.240; intensity: intensFac*0.7; radius: radiusFac * 0.80 }
    ]

    Heatmap3D {
        id: hm
        slices: colorlookup? 64 : 16
        anchors.right: parent.right
        anchors.bottom: capHm.top
        width: parent.width * 0.36
        height: width
        points: pointModel
        angleHoriz: 0.5
        visible: hmdpSilde.currentBullet >= 6 || hmdp.width <= hmdpSilde.width * 0.102
        colorlookup: hmdpSilde.currentBullet >= 6
        colorlookupPost: false
        //asRect: theSlide.currentBullet == 1
        //lowerAlpha: 0.2 + 0.8 * (1.0-(theSlide.currentBullet == 2))
        intensityFactor: 0.8//0.2+0.8*(colorlookup)
        lowerAlpha: 0.3
        //circleAdapt: theSlide.currentBullet == 2
        //circleAdapt: true
        //asRect: true
        z: -1
    }
    Text {
        id:capHm
        font.pixelSize: hmdpSilde.fontSize*0.3
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height*0.01
        anchors.left: hm.left
        anchors.right: hm.right
        horizontalAlignment: Text.AlignHCenter
        text: "Color (post-interpolative classification)"
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        height: implicitHeight
        color: "white"
        visible: hm.colorlookup
    }

    Heatmap3D {
        id:hm2
        slices: 64
        anchors.right: hm.left
        anchors.bottom: capHm2.top
        width: parent.width * 0.36
        height: width
        points: pointModel
        angleHoriz: 0.5
        colorlookup: false
        colorlookupPost: true
        //lowerAlpha: 0.5 //+ 0.8 * (1.0-(theSlide.currentBullet == 2))
        intensityFactor: 0.05
        lowerAlpha: 18.0
        visible: hmdpSilde.currentBullet >= 6
        z: -1
    }
    Text {
        id:capHm2
        font.pixelSize: hmdpSilde.fontSize*0.3
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height*0.01
        anchors.left: hm2.left
        anchors.right: hm2.right
        horizontalAlignment: Text.AlignHCenter
        text: "Heat (2D postprocessing effect on heat image)"
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        height: implicitHeight
        color: "white"
        visible: hm2.visible
    }

    NumberAnimation {
        id: rotationAnimationHM
        loops: Animation.Infinite
        target: hm
        property: "angle"
        duration: 10000
        from: 0.0
        to: Math.PI*2.0
        running: hm.visible
    }
    NumberAnimation {
        id: rotationAnimation2
        loops: Animation.Infinite
        target: hm2
        property: "angle"
        duration: 10000
        from: 0.0
        to: Math.PI*2.0
        running: hm.visible
    }
}
