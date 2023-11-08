#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

varying vec4 vertTexCoord;
uniform sampler2D texture;

uniform vec3 color_1;
uniform vec3 color_2;

void main() {
    vec2 st = vertTexCoord.st;
    vec4 color = texture2D(texture, st);

    gl_FragColor = vec4(mix(color_1, color_2, color.r), 1.0);
}