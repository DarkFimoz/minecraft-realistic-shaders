#version 120

varying vec2 texcoord;
varying vec4 color;

uniform mat4 shadowProjection;
uniform mat4 shadowModelView;

void main() {
    vec4 position = shadowModelView * gl_Vertex;
    gl_Position = shadowProjection * position;
    
    texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    color = gl_Color;
}
