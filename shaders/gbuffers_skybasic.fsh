#version 120

uniform float rainStrength;
uniform vec3 fogColor;
uniform int worldTime;
uniform vec3 sunPosition;

varying vec4 starData;
varying vec3 viewPos;

const float SKY_BRIGHTNESS = 1.0;

vec3 getSkyColor() {
    vec3 nViewPos = normalize(viewPos);
    float upDot = dot(nViewPos, vec3(0.0, 1.0, 0.0));
    
    vec3 sunDir = normalize(sunPosition);
    float sunDot = dot(nViewPos, sunDir);
    
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
    
    vec3 zenithDay = vec3(0.3, 0.5, 0.9);
    vec3 horizonDay = vec3(0.9, 0.7, 0.5);
    vec3 zenithNight = vec3(0.01, 0.01, 0.05);
    vec3 horizonNight = vec3(0.05, 0.05, 0.1);
    
    vec3 zenith = mix(zenithNight, zenithDay, timeFactor);
    vec3 horizon = mix(horizonNight, horizonDay, timeFactor);
    
    float horizonBlend = pow(1.0 - max(upDot, 0.0), 2.0);
    vec3 skyCol = mix(zenith, horizon, horizonBlend);
    
    float sunGlow = max(sunDot, 0.0);
    vec3 sunGlowColor = vec3(1.0, 0.8, 0.5) * pow(sunGlow, 8.0) * 0.5 * timeFactor;
    skyCol += sunGlowColor;
    
    skyCol = mix(skyCol, fogColor * 0.5, rainStrength);
    
    return skyCol * SKY_BRIGHTNESS;
}

void main() {
    vec3 finalColor;
    
    if (starData.a > 0.5) {
        finalColor = starData.rgb;
    } else {
        finalColor = getSkyColor();
    }
    
    gl_FragData[0] = vec4(finalColor, 1.0);
}
