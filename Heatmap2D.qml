import QtQuick 2.0

Item {
    property list<HeatmapDatapointModel> points

    property int slices: 16
    property int slice: slices*0.5
    property bool showNormDist: true
    property bool circleAdapt: false
    property bool outerAlpha: true
    property bool zebra: false
    property bool colorlookup: false
    property bool strictMode: true

    property real angle: 0.0//Math.PI*0.5
    property real angleHoriz: 0.5
    property real depth: width*0.5
    property bool contours: false
    property real contoursInterval: 0.2
    property real contourWidth: 1.0
    property bool contoursCorrect: true
    property bool contoursAA: true
    property color contourInputColor: Qt.rgba(0.0,0.0,0.0,1.0)

    property bool asX: false
    property bool withRad: false
    property bool visDP: false
    property real resDiv: 8.0
    property bool asRect: false

    property real lowerAlpha: 1.0
    property real intensityFactor: 1.0

    z: root.slice * (1.0 - ((root.angle>Math.PI*0.5) && (root.angle<Math.PI*1.5))*2.0)

    id: root
    ShaderEffectSource {
        id: datapointRendering
        sourceItem: rect
        hideSource: true
    }
    ShaderEffect {
        id: postprocessShaderEffect
        anchors.fill: parent

        property int myindex: root.slice
        property int maxIndices: root.slices
        property real angle: root.angle
        property real angleHoriz: root.angleHoriz
        property real myWidth: width
        property real myHeight: height
        property real showNormDist: root.showNormDist
        property real circleAdapt: root.circleAdapt
        property real outerAlpha: root.outerAlpha
        property real zebra: root.zebra
        property real colorlookup: root.colorlookup
        property real strictMode: root.strictMode
        property real depth: root.depth
        property real contours: root.contours
        property real contoursInterval: root.contoursInterval
        property real contourWidth: root.contourWidth
        property real contoursCorrect: root.contoursCorrect
        property real contoursAA: root.contoursAA
        property color contourInputColor: root.contourInputColor

        property variant src: datapointRendering
        vertexShader: "
            uniform highp mat4 qt_Matrix;
            attribute highp vec4 qt_Vertex;
            attribute highp vec2 qt_MultiTexCoord0;
            varying highp vec2 coord;
            uniform int myindex;
            uniform int maxIndices;
            uniform float angle;
            uniform float angleHoriz;
            uniform float myWidth;
            uniform float myHeight;
            uniform float depth;

            float radius = depth*0.5;
            float layerOffset = myWidth/float(maxIndices);
            const float pi = 3.14159265359;

            mat4 rotationMatrix(vec3 axis, float angle)
            {
                axis = normalize(axis);
                float s = sin(angle);
                float c = cos(angle);
                float oc = 1.0 - c;

                return mat4(oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s,  0.0,
                            oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z - axis.x * s,  0.0,
                            oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s,  oc * axis.z * axis.z + c,           0.0,
                            0.0,                                0.0,                                0.0,                                1.0);
            }

            void main() {
                vec4 pos = qt_Vertex;
                float lerp = float(myindex)/float(maxIndices)*2.0-1.0;
                float z = lerp*radius;
                pos.z += z;
                vec2 rotationCenter = vec2(myWidth, myHeight) * 0.5;
                pos.xy -= rotationCenter;
                //pos = rotationMatrix(vec3(0.0, 1.0, 0.0), -pi*0.5) * pos; // this is to overcome the lack of z ordering+z buffer (also tho mod() in next line)
                pos = rotationMatrix(vec3(0.0, 1.0, 0.0), angle) * pos; //mod(angle, pi)) * pos;
                pos = rotationMatrix(vec3(1.0, 0.0, 0.0), angleHoriz) * pos;
                pos.xy += rotationCenter;
                pos.w = 1.0;
                pos.z = 0.0;
                coord = qt_MultiTexCoord0;
                gl_Position = qt_Matrix * pos;
            }"
        fragmentShader: "
            varying highp vec2 coord;
            uniform sampler2D src;
            uniform lowp float qt_Opacity;
            uniform float colorlookup;

            uniform float contours;
            uniform float contoursInterval;
            uniform float contourWidth;
            uniform float contoursCorrect;
            uniform float contoursAA;
            uniform vec4 contourInputColor;

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

            highp float getGradientLen(highp float intensity)
            {
                //return fwidth(intensity);
                highp float mx = dFdx(intensity);
                highp float my = dFdy(intensity);
                return length(vec2(mx, my));
            }

            float calcContour(highp float intensity)
            {
                if(intensity <= 0.01 || intensity >= 0.98) return 0.0;
                highp float scale = 1.0/contoursInterval;
                intensity *= scale;

                highp float widthNoCorrectionFactor; // needed to increase/decrease width when it is not corrected/set to contourWidth
                highp float gradientLen;  // the gradient len for correction or 1.0 if correction is off
                highp float postGradientLen;  // needed to do antia aliasing if correction is turned off (because aa always need correction/width in pixels)
                highp float halfContourWidth = contourWidth * 0.5;
                if(contoursCorrect > 0.5)
                {
                    gradientLen = getGradientLen(intensity);
                    postGradientLen = 1.0;
                    widthNoCorrectionFactor = 1.0;
                }
                else
                {
                    if(0 > intensity - 1e-9)
                    {
                        gradientLen = 0.0;
                    }
                    else
                    {
                        gradientLen = 1.0;
                    }
                    postGradientLen = getGradientLen(intensity);
                    widthNoCorrectionFactor = 0.05;
                }
                halfContourWidth *= widthNoCorrectionFactor;

                highp float hPrev = floor(intensity);
                highp float hNext = ceil(intensity);

                highp float distPrev = (intensity-hPrev)/gradientLen;
                highp float distNext = (hNext-intensity)/gradientLen;

                highp float isOnContourPrev = halfContourWidth - distPrev; // positive: is on contour, negative: is not on contour
                highp float isOnContourNext = halfContourWidth - distNext;

                highp float previousContourContrib;
                highp float nextContourContrib;
                if(contoursAA > 0.5)
                {
                    previousContourContrib = smoothstep( 0.0, 1.0, 0.75 + isOnContourPrev);
                    nextContourContrib = smoothstep(0.0, 1.0, 0.75 + isOnContourNext);
                }
                else
                {
                    previousContourContrib = step(0.0, isOnContourPrev);
                    nextContourContrib = step(0.0, isOnContourNext);
                }
                return min(1.0, previousContourContrib + nextContourContrib);
            }

            void main() {
                highp vec4 color = texture2D(src, coord);
                highp float intensity = color.r;
                vec4 colorlooked = vec4(hsv2rgbsmooth(vec3(0.5+intensity*2.0, 1.0, 0.4+intensity)), 0.8)*intensity;

                highp float contour = calcContour(intensity);
                vec4 finColor = mix(color, colorlooked, colorlookup);
                gl_FragColor = mix(finColor, contourInputColor, contour * contours) * qt_Opacity;
            }"
    }
    property real radiusFactor: Math.min(width, height);
    Item {
        id: rect
        anchors.fill: parent

        Repeater {
            model: points
            delegate: HeatmapDatapointSlice {
                x: (modelData.centerx - modelData.radius) * radiusFactor
                y: (modelData.centery - modelData.radius) * radiusFactor
                intensity: modelData.intensity * root.intensityFactor
                width: modelData.radius * 2.0 * radiusFactor
                height: modelData.radius * 2.0 * radiusFactor
                slices: root.slices
                slice: root.slice
                zslicessize: root.depth
                showNormDist: true
                circleAdapt: root.circleAdapt
                outerAlpha: true
                zebra: false
                colorlookup: false // true would destroy heatmap (akkumulation)! root.colorlookup
                angleHoriz: 0.0
                strictMode : true
                asX: root.asX
                asRect: root.asRect
                withRad: root.withRad
                visDP: root.visDP
                resDiv: root.resDiv

                lowerAlpha: root.lowerAlpha
            }
        }
    }
}

