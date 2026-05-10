#version 120

uniform sampler2D texture;
uniform int worldTime;
uniform vec3 sunPosition;
uniform vec3 moonPosition;

varying vec2 texcoord;
varying vec4 color;
varying vec3 viewPos;

#define SUN_MOON_SIZE 1.0

vec3 getCelestialColor() {
    vec4 texColor = texture2D(texture, texcoord);
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
    
    vec3 sunColor = vec3(1.0, 0.95, 0.8) * 2.0;
    vec3 moonColor = vec3(0.8, 0.85, 1.0) * 1.5;
    
    vec3 celestialColor = texColor.rgb * color.rgb;
    
    if (sunDot > 0.999) {
        celestialColor = mix(celestialColor, sunColor, timeFactor * SUN_MOON_SIZE);
    }
    
    if (moonDot > 0.999) {
        celestialColor = mix(celestialColor, moonColor, (1.0 - timeFactor) * SUN_MOON_SIZE);
    }
    
    return celestialColor;
}

void main() {
    vec3 finalColor = getCelestialColor();
    gl_FragData[0] = vec4(finalColor, texture2D(texture, texcoord).a * color.a);
}
