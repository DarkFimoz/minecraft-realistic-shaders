#version 120

varying vec4 starData;
varying vec3 viewPos;

void main() {
    gl_Position = ftransform();
    starData = vec4(gl_Color.rgb, float(gl_Color.r == gl_Color.g && gl_Color.g == gl_Color.b && gl_Color.r > 0.0));
    viewPos = (gl_ModelViewMatrix * gl_Vertex).xyz;
}
