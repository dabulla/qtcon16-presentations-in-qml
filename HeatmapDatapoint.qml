import QtQuick 2.0

Item {
    id:root
    property int slices: 16
    property int sliceFrom: 0
    property int sliceTo: slices
    property bool showNormDist: false
    property bool circleAdapt: false
    property bool outerAlpha: false
    property bool zebra: false
    property bool colorlookup: false
    property bool colorlookupPost: false
    property bool asRect: false

    property real angle: Math.PI*0.5
    property real angleHoriz: 0.5

    Behavior on slices {
        NumberAnimation { duration: 2500 }
    }
    ShaderEffectSource {
        id: datapointRendering
        sourceItem: rect
        hideSource: colorlookupPost
    }
    ShaderEffect {
        id: postprocessShaderEffect
        anchors.fill: parent
        visible: colorlookupPost

        property variant src: datapointRendering
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
                vec4 colorlooked = vec4(hsv2rgbsmooth(vec3(0.5+intensity*0.3, 1.0, 1.0)),intensity*0.6)*intensity*0.5;
                gl_FragColor = colorlooked;
            }"
    }
    Item {
        anchors.fill: parent
        id: rect
        Repeater {
            id: rep
            model: root.slices
            HeatmapDatapointSlice {
                width: Math.min(root.width, root.height)
                height: Math.min(root.width, root.height)

                slice: index
                slices: rep.count
                angle: root.angle
                angleHoriz: root.angleHoriz
                showNormDist: root.showNormDist
                circleAdapt: root.circleAdapt
                outerAlpha: root.outerAlpha
                zebra: root.zebra
                colorlookup: root.colorlookup
                visible: index >= sliceFrom && index <= sliceTo
                asRect: root.asRect
                intensity: 0.6 + root.colorlookup * 0.4
            }
        }
    }
}
