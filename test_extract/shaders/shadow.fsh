#version 120

uniform sampler2D texture;
varying vec2 texcoord;
varying vec4 color;

void main() {
    vec4 texColor = texture2D(texture, texcoord) * color;
    if (texColor.a < 0.1) discard;
    
    float depth = gl_FragCoord.z;
    gl_FragData[0] = vec4(vec3(depth), texColor.a);
}
