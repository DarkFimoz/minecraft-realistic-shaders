#version 120

uniform sampler2D texture;
uniform sampler2D shadow;
uniform sampler2D noisetex;

varying vec2 texcoord;
varying vec4 color;
varying vec3 normal;
varying vec4 shadowPos;

const int shadowMapResolution = 2048;

float getShadow() {
    vec3 shadowCoord = shadowPos.xyz / shadowPos.w;
    shadowCoord = shadowCoord * 0.5 + 0.5;
    
    if (shadowCoord.x < 0.0 || shadowCoord.x > 1.0 || 
        shadowCoord.y < 0.0 || shadowCoord.y > 1.0 ||
        shadowCoord.z < 0.0 || shadowCoord.z > 1.0) {
        return 1.0;
    }
    
    float shadowValue = 0.0;
    float bias = 0.0005;
    vec2 texelSize = 1.0 / vec2(shadowMapResolution);
    
    for (int x = -2; x <= 2; x++) {
        for (int y = -2; y <= 2; y++) {
            vec2 offset = vec2(x, y) * texelSize;
            float shadowDepth = texture2D(shadow, shadowCoord.xy + offset).r;
            shadowValue += (shadowCoord.z - bias > shadowDepth) ? 0.0 : 1.0;
        }
    }
    
    shadowValue /= 25.0;
    return mix(0.4, 1.0, shadowValue);
}

void main() {
    vec4 texColor = texture2D(texture, texcoord) * color;
    float shadowFactor = getShadow();
    
    gl_FragData[0] = texColor * shadowFactor;
}
