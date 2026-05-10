#version 120

uniform sampler2D texture;
uniform sampler2D shadow;

varying vec2 texcoord;
varying vec4 color;
varying vec3 normal;
varying vec4 shadowPos;

#define SHADOW_DISTANCE 128.0

float getShadow() {
    vec3 shadowCoord = shadowPos.xyz / shadowPos.w;
    shadowCoord = shadowCoord * 0.5 + 0.5;
    
    if (shadowCoord.x < 0.0 || shadowCoord.x > 1.0 || 
        shadowCoord.y < 0.0 || shadowCoord.y > 1.0 ||
        shadowCoord.z < 0.0 || shadowCoord.z > 1.0) {
        return 1.0;
    }
    
    float shadowDepth = texture2D(shadow, shadowCoord.xy).r;
    float bias = 0.001;
    
    return shadowCoord.z - bias > shadowDepth ? 0.3 : 1.0;
}

void main() {
    vec4 texColor = texture2D(texture, texcoord) * color;
    float shadow = getShadow();
    
    gl_FragData[0] = texColor * shadow;
}
