import QtQuick 2.0

Item {
    id:root
    property list<HeatmapDatapointModel> points

    property bool colorlookupPost: false

    property int slices: 32
    property int sliceFrom: 0
    property int sliceTo: slices
    property bool showNormDist: true
    property bool circleAdapt: false
    property bool outerAlpha: true
    property bool zebra: false
    property bool colorlookup: false
    property bool strictMode: true

    property real angle: Math.PI*0.5
    property real angleHoriz: 0.5

    property real lowerAlpha: 1.0
    property real intensityFactor: 1.0
    property bool asRect: false

    ShaderEffectSource {
        id: dpr
        sourceItem: rect
        hideSource: colorlookupPost
    }
    ShaderEffect {
        id: postprocessShaderEffect
        anchors.fill: parent
        visible: colorlookupPost

        property variant src: dpr
        vertexShader: "
            uniform highp mat4 qt_Matrix;
            attribute highp vec4 qt_Vertex;
            attribute highp vec2 qt_MultiTexCoord0;
            varying highp vec2 coord;
            void main() {
                coord = qt_MultiTexCoord0;
                gl_Position = qt_Matrix * qt_Vertex;
            }"
        fragmentShader: "
            varying highp vec2 coord;
            uniform sampler2D src;
            vec3 hsv2rgb(vec3 c)
            {
                //linearSpace
                vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
                vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
                return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
            }

            vec3 hsv2rgbsmooth(vec3 c)
            {
                return smoothstep(0.0, 1.0, hsv2rgb(c));
            }

            void main() {
                float intensity = texture2D(src, coord).r;
                vec4 colorlooked = vec4(hsv2rgbsmooth(vec3(0.5+intensity*2.0, 1.0, 0.1+intensity)), 1.0)*intensity;
                gl_FragColor = colorlooked;
            }"
    }

    Item {
        anchors.fill: parent
        id: rect
        Repeater {
            id: rep
            model: root.slices
            Heatmap2D {
                points: root.points
                width: root.width
                height: root.height

                slice: index
                slices: rep.count

                angle: root.angle
                angleHoriz: root.angleHoriz
                showNormDist: root.showNormDist
                circleAdapt: root.circleAdapt
                outerAlpha: root.outerAlpha
                zebra: root.zebra
                colorlookup: root.colorlookup
                //colorlookupPost: root.colorlookupPost
                visible: index >= sliceFrom && index <= sliceTo

                asX: false
                withRad: false
                visDP: true
                contours: false

                lowerAlpha: root.lowerAlpha
                intensityFactor: root.intensityFactor
                asRect: root.asRect
            }
        }
    }
}

