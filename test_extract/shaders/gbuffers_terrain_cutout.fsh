#version 120

uniform sampler2D texture;
uniform sampler2D shadow;

varying vec2 texcoord;
varying vec4 color;
varying vec3 normal;
varying vec4 shadowPos;

const int shadowMapResolution = 4096;

float getShadow() {
    vec3 shadowCoord = shadowPos.xyz / shadowPos.w;
    shadowCoord = shadowCoord * 0.5 + 0.5;
    
    if (shadowCoord.x < 0.0 || shadowCoord.x > 1.0 || 
        shadowCoord.y < 0.0 || shadowCoord.y > 1.0 ||
        shadowCoord.z < 0.0 || shadowCoord.z > 1.0) {
        return 1.0;
    }
    
    float bias = max(0.0005 * (1.0 - dot(normal, vec3(0.0, 1.0, 0.0))), 0.0001);
    vec2 texelSize = 1.0 / vec2(shadowMapResolution);
    
    float shadowDepth = texture2D(shadow, shadowCoord.xy).r;
    float shadowValue = (shadowCoord.z - bias > shadowDepth) ? 0.5 : 1.0;
    
    float count = 1.0;
    shadowValue += (shadowCoord.z - bias > texture2D(shadow, shadowCoord.xy + vec2(texelSize.x, 0.0)).r) ? 0.5 : 1.0;
    shadowValue += (shadowCoord.z - bias > texture2D(shadow, shadowCoord.xy + vec2(-texelSize.x, 0.0)).r) ? 0.5 : 1.0;
    shadowValue += (shadowCoord.z - bias > texture2D(shadow, shadowCoord.xy + vec2(0.0, texelSize.y)).r) ? 0.5 : 1.0;
    shadowValue += (shadowCoord.z - bias > texture2D(shadow, shadowCoord.xy + vec2(0.0, -texelSize.y)).r) ? 0.5 : 1.0;
    count += 4.0;
    
    return shadowValue / count;
}

void main() {
    vec4 texColor = texture2D(texture, texcoord) * color;
    if (texColor.a < 0.1) discard;
    
    float shadowFactor = getShadow();
    
    gl_FragData[0] = texColor * shadowFactor;
}
