#version 120

uniform sampler2D texture;
uniform int worldTime;
uniform vec3 sunPosition;
uniform vec3 moonPosition;

varying vec2 texcoord;
varying vec4 color;
varying vec3 viewPos;

const float SUN_MOON_SIZE = 1.0;

void main() {
    vec3 nViewPos = normalize(viewPos);
    vec3 sunDir = normalize(sunPosition);
    vec3 moonDir = normalize(moonPosition);
    
    float sunDot = dot(nViewPos, sunDir);
    float moonDot = dot(nViewPos, moonDir);
    
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
    
    vec3 sunColor = vec3(1.0, 0.9, 0.7) * 3.0;
    vec3 moonColor = vec3(0.7, 0.8, 1.0) * 2.0;
    
    vec3 finalColor = color.rgb;
    
    float sunRadius = 0.04 * SUN_MOON_SIZE;
    float moonRadius = 0.035 * SUN_MOON_SIZE;
    
    if (sunDot > cos(sunRadius)) {
        float sunIntensity = smoothstep(cos(sunRadius), cos(sunRadius * 0.5), sunDot);
        finalColor = mix(finalColor, sunColor, sunIntensity * timeFactor);
    }
    
    if (moonDot > cos(moonRadius)) {
        float moonIntensity = smoothstep(cos(moonRadius), cos(moonRadius * 0.5), moonDot);
        finalColor = mix(finalColor, moonColor, moonIntensity * (1.0 - timeFactor));
    }
    
    gl_FragData[0] = vec4(finalColor, 1.0);
}
