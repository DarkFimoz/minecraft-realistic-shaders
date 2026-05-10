#version 120

uniform sampler2D colortex0;
uniform sampler2D depthtex0;
uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferPreviousProjection;
uniform mat4 gbufferPreviousModelView;
uniform mat4 gbufferModelViewInverse;
uniform vec3 cameraPosition;
uniform vec3 previousCameraPosition;

varying vec2 texcoord;

const float MOTION_BLUR_STRENGTH = 0.3;

void main() {
    vec3 color = texture2D(colortex0, texcoord).rgb;
    float depth = texture2D(depthtex0, texcoord).r;
    
    if (depth > 0.9999) {
        gl_FragData[0] = vec4(color, 1.0);
        return;
    }
    
    vec4 currentPos = vec4(texcoord * 2.0 - 1.0, depth * 2.0 - 1.0, 1.0);
    vec4 viewPos = gbufferProjectionInverse * currentPos;
    viewPos /= viewPos.w;
    
    vec4 worldPos = gbufferModelViewInverse * viewPos;
    worldPos.xyz += cameraPosition;
    
    vec4 previousPos = gbufferPreviousProjection * gbufferPreviousModelView * vec4(worldPos.xyz - previousCameraPosition, 1.0);
    previousPos /= previousPos.w;
    previousPos = previousPos * 0.5 + 0.5;
    
    vec2 velocity = (texcoord - previousPos.xy) * MOTION_BLUR_STRENGTH;
    
    if (length(velocity) < 0.001) {
        gl_FragData[0] = vec4(color, 1.0);
        return;
    }
    
    vec3 result = color;
    result += texture2D(colortex0, texcoord + velocity * 0.33).rgb;
    result += texture2D(colortex0, texcoord - velocity * 0.33).rgb;
    result /= 3.0;
    
    gl_FragData[0] = vec4(result, 1.0);
}
