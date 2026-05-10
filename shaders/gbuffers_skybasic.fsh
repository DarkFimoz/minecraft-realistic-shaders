#version 120

uniform float nightVision;
uniform float rainStrength;
uniform float wetness;
uniform vec3 skyColor;
uniform vec3 fogColor;
uniform int worldTime;

varying vec4 starData;
varying vec3 viewPos;

#define SKY_BRIGHTNESS 1.0

vec3 getSkyColor() {
    vec3 nViewPos = normalize(viewPos);
    float upDot = dot(nViewPos, vec3(0.0, 1.0, 0.0));
    
    vec3 daySky = vec3(0.4, 0.6, 1.0);
    vec3 horizonSky = vec3(0.8, 0.85, 1.0);
    vec3 nightSky = vec3(0.01, 0.01, 0.05);
    
    float timeFactor = 0.0;
    if (worldTime < 12000) {
        timeFactor = 1.0;
    } else if (worldTime < 13000) {
        timeFactor = 1.0 - (float(worldTime - 12000) / 1000.0);
    } else if (worldTime < 23000) {
        timeFactor = 0.0;
    } else {
        timeFactor = (float(worldTime - 23000) / 1000.0);
    }
    
    vec3 skyCol = mix(nightSky, daySky, timeFactor);
    skyCol = mix(skyCol, horizonSky, pow(1.0 - max(upDot, 0.0), 3.0));
    skyCol = mix(skyCol, fogColor * 0.5, rainStrength);
    
    return skyCol * SKY_BRIGHTNESS;
}

void main() {
    vec3 color;
    
    if (starData.a > 0.5) {
        color = starData.rgb;
    } else {
        color = getSkyColor();
    }
    
    gl_FragData[0] = vec4(color, 1.0);
}
