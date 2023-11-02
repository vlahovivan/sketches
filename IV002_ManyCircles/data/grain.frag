#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

varying vec4 vertTexCoord;
uniform sampler2D texture;

vec4 grain(vec2 uv, vec4 color) {
  float mdf = 0.05; // increase for noise amount 
  float noise = (fract(sin(dot(uv, vec2(12.9898,78.233)*2.0)) * 43758.5453));

  return color - vec4(mdf * noise);
}

void main() {
    vec2 st = vertTexCoord.st;

    vec4 color = texture2D(texture, st);

    gl_FragColor = grain(st, color);
}