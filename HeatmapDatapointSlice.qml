import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    property real zoffset: 0.0
    property real zslicessize: width
    property int slices: 16
    property int slice: slices*0.5
    property bool showNormDist: false
    property bool circleAdapt: false
    property bool outerAlpha: false
    property bool strictMode: false
    property bool zebra: false
    property bool colorlookup: false
    property bool asX: false
    property bool withRad: false
    property bool visDP: true
    property real resDiv: 8.0
    property bool blendAdd: false
    property bool asRect: false
    property real intensity: 1.0

    property real angle: Math.PI*0.5
    property real angleHoriz: 0.5

    property real lowerAlpha: 1.0
    id: root

//    border.color: "white"
//    border.width: asRect?1.0:2.0

    ShaderEffect {
        id: shaderEffect
        visible: root.visible
        opacity: 1.0;//root.opacity
        anchors.fill: parent
        //anchors.margins: parent.width*0.16
        blending: true //premultiplied alpha: mix of over and add! vec4(color*alpha, alpha) -> over; vec4(color*alpha, 0) -> add
        property int myindex: root.slice
        property int maxIndices: root.slices
        property real time: root.angle
        property real angleHoriz: root.angleHoriz
        property real myWidth: width
        property real myHeight: height
        property real zslicessize: root.zslicessize
        property real showNormDist: root.showNormDist
        property real circleAdapt: root.circleAdapt
        property real outerAlpha: root.outerAlpha
        property real zebra: root.zebra
        property real colorlookup: root.colorlookup
        property real strictMode: root.strictMode
        property real zoffset: root.zoffset
        property real asX: root.asX
        property real withRad: root.withRad
        property real visDP: root.visDP
        property real resDiv: root.resDiv
        property real blendAdd: root.blendAdd
        property real asRect: root.asRect
        property real intensity: root.intensity
        property real lowerAlpha: root.lowerAlpha

        Behavior on showNormDist {
            NumberAnimation { duration: 500}
        }
        Behavior on circleAdapt {
            NumberAnimation { duration: 500}
        }
        Behavior on outerAlpha {
            NumberAnimation { duration: 500}
        }
        Behavior on zebra {
            NumberAnimation { duration: 500}
        }
        Behavior on colorlookup {
            NumberAnimation { duration: 500}
        }
        Behavior on strictMode {
            NumberAnimation { duration: 500}
        }
        Behavior on asX {
            NumberAnimation { duration: 500}
        }
        Behavior on withRad {
            NumberAnimation { duration: 500}
        }
        Behavior on visDP {
            NumberAnimation { duration: 500}
        }

        vertexShader: "
            uniform highp mat4 qt_Matrix;
            attribute highp vec4 qt_Vertex;
            attribute highp vec2 qt_MultiTexCoord0;
            uniform int myindex;
            uniform int maxIndices;
            uniform float time;
            uniform float angleHoriz;
            uniform float myWidth;
            uniform float myHeight;
            uniform float circleAdapt;
            uniform float zoffset;
            uniform float zslicessize;
            uniform float intensity;

            //out Vertex
            //{
            varying float vertexIntensity;
            varying vec3 vertexToCenter;
            //} output;
            varying vec2 fragPos;
            float radius = myWidth*0.5;

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
                vertexIntensity = intensity;
                float lerp = float(myindex)/float(maxIndices-1)*2.0-1.0;
                float z = lerp*zslicessize*0.5;
                //lerp *= 0.9; //make circle effect less drastic
                float radiusFactor = mix( 1.0, sqrt(1.0 - pow( lerp, 2.0 )), circleAdapt); //Kreisformel, Einheitskreis
                pos.z += z-zoffset;
                vec2 rotationCenter = vec2(myWidth, myHeight) * 0.5;
                pos.xy -= rotationCenter;
                pos.xy *= radiusFactor;

                vertexToCenter = vec3(pos.xy / (radius*radiusFactor), pos.z/radius);
                fragPos = pos.xy/radiusFactor;
                pos = rotationMatrix(vec3(0.0, 1.0, 0.0), -pi * 0.5) * pos; // this is to overcome the lack of z ordering+z buffer (also the mod() in next line)
                pos = rotationMatrix(vec3(0.0, 1.0, 0.0), mod(time, pi)) * pos;
                pos = rotationMatrix(vec3(1.0, 0.0, 0.0), angleHoriz) * pos;
                pos.xy += rotationCenter;
                pos.w = 1.0;
                pos.z = 0.0;
                gl_Position = qt_Matrix * pos;
            }"
        fragmentShader: "
            //in Vertex
            //{
            varying float vertexIntensity;
            varying vec3 vertexToCenter;
            //} input;
            varying vec2 fragPos;
            uniform lowp float qt_Opacity;
            uniform float showNormDist;
            uniform float outerAlpha;
            uniform float zebra;
            uniform int myindex;
            uniform float colorlookup;
            uniform float strictMode;
            uniform float asX;
            uniform float withRad;
            uniform float visDP;
            uniform float myWidth;
            uniform float myHeight;
            uniform float resDiv;
            uniform float blendAdd;
            uniform float asRect;
            uniform float lowerAlpha;

            const float e = 2.71828182846;

            const float sqrt2Pi = 2.506628275;

            float normDist(float s, float var)
            {
                float exponent = -pow(s,2.0)/(2.0*pow(var,2.0));
                return (1.0/(var*sqrt2Pi))*pow(e,exponent);
            }

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
            vec4 visAsX()
            {
                float dist = length(fragPos);
                return vec4(smoothstep(1.0,0.0,dist-2.0));
            }
            vec4 visAsRect()
            {
                float ret = smoothstep(2.0,0.0,abs(1.0 - fragPos.x - fragPos.y));
                ret = max(ret, smoothstep(2.0,0.0,myWidth*0.5 - abs(fragPos.x) - 1.0));
                ret = max(ret, smoothstep(2.0,0.0,myHeight*0.5 - abs(fragPos.y) - 1.0));
                return vec4( ret );
            }
            vec4 visWithRad()
            {
                float dist = length(fragPos);
                return vec4(smoothstep(1.0,0.0,abs(myWidth*0.48-dist)));
            }
            void main() {
                vec4 finalColor = vec4(0.0);
                finalColor += visAsX() * asX;
                finalColor += visWithRad() * withRad;
                finalColor += visAsRect() * asRect;

//                float zebraFactor = mix(1.0,float(mod(myindex,2))*0.5+0.5,zebra);
//                float dist = length(vertexToCenter);
//                float intensity = normDist(dist*0.8, 0.25) * 0.8 * vertexIntensity;
//                float alpha = mix(0.7, 0.1*(1.0-strictMode), outerAlpha);
//                float color = 0.1*(4.0-showNormDist*3.0)*alpha*zebraFactor ;
//                vec4 colorlooked = vec4(hsv2rgbsmooth(vec3(0.5+intensity*0.3, 1.0, 1.0)),intensity*0.6)*intensity*0.5;
//                vec4 colorheat = vec4(1.0, 1.0, 1.0, intensity*0.1 * qt_Opacity)*0.5*showNormDist+vec4(color,color,color,alpha);
//                finalColor += mix(colorheat, colorlooked, colorlookup) * qt_Opacity * visDP;
//                out_color =  vec4( finalColor.rgb * mix(0.3,  0.6, blendAdd), mix(finalColor.a, 0.0, blendAdd));

                float zebraFactor = mix(0.5,float(mod(myindex,2))*0.8+0.2,zebra);
                float dist = length(vertexToCenter);
                float intensity = normDist(dist*0.5, 0.25) * vertexIntensity ;
                float alpha = mix(0.5, 0.1*(1.0-strictMode), outerAlpha);
                vec4 colorlooked = vec4(hsv2rgbsmooth(vec3(0.5+intensity*0.3, 1.0, 1.0)), 1.0 )*intensity;
                vec4 colorBackground = vec4(vec3(0.3)*zebraFactor,alpha);
                vec4 colorheat = vec4(vec3(1.0*intensity), 1.0 * intensity );
                vec4 colorWithBg;
                colorWithBg.rgb = colorheat.rgb * colorheat.a + colorBackground.rgb * colorBackground.a;
                colorWithBg.a = colorheat.a + colorBackground.a * (1.0-colorheat.a);
                colorWithBg.rgb /= colorWithBg.a;
                finalColor += mix(colorWithBg, colorlooked, colorlookup) * visDP;
                gl_FragColor =  mix(finalColor * finalColor.a, vec4(finalColor.aaa, 0.0), blendAdd) * lowerAlpha; //pre multiplied alpha
            }"
    }
}
