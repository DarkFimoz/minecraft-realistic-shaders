#version 120

uniform sampler2D colortex0;
uniform sampler2D depthtex0;
uniform sampler2D colortex1;
uniform float frameTimeCounter;
uniform vec2 texelSize;
uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferPreviousProjection;
uniform mat4 gbufferPreviousModelView;
uniform mat4 gbufferModelViewInverse;
uniform vec3 cameraPosition;
uniform vec3 previousCameraPosition;

varying vec2 texcoord;

#define MOTION_BLUR_STRENGTH 0.5

vec3 getMotionBlur(vec2 coord) {
    float depth = texture2D(depthtex0, coord).r;
    
    vec4 currentPos = vec4(coord * 2.0 - 1.0, depth * 2.0 - 1.0, 1.0);
    vec4 viewPos = gbufferProjectionInverse * currentPos;
    viewPos /= viewPos.w;
    
    vec4 worldPos = gbufferModelViewInverse * viewPos;
    worldPos.xyz += cameraPosition;
    
    vec4 previousPos = gbufferPreviousProjection * gbufferPreviousModelView * vec4(worldPos.xyz - previousCameraPosition, 1.0);
    previousPos /= previousPos.w;
    previousPos = previousPos * 0.5 + 0.5;
    
    vec2 velocity = (coord - previousPos.xy) * MOTION_BLUR_STRENGTH;
    
    vec3 color = vec3(0.0);
    int samples = 8;
    
    for (int i = 0; i < samples; i++) {
        vec2 offset = velocity * (float(i) / float(samples - 1) - 0.5);
        color += texture2D(colortex0, coord + offset).rgb;
    }
    
    return color / float(samples);
}

void main() {
    vec3 color = getMotionBlur(texcoord);
    gl_FragData[0] = vec4(color, 1.0);
    gl_FragData[1] = texture2D(colortex0, texcoord);
}
