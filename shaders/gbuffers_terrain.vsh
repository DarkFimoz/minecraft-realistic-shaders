#version 120

varying vec2 texcoord;
varying vec4 color;
varying vec3 normal;
varying vec4 shadowPos;

uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform mat4 shadowProjection;
uniform mat4 shadowModelView;

void main() {
    gl_Position = ftransform();
    texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    color = gl_Color;
    normal = normalize(gl_NormalMatrix * gl_Normal);
    
    vec4 viewPos = gbufferModelView * gl_Vertex;
    vec4 worldPos = gbufferModelViewInverse * viewPos;
    shadowPos = shadowProjection * shadowModelView * worldPos;
}
