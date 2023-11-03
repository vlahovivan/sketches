#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform float iTime;
uniform vec2 iResolution;

uniform vec3 bg_color_1;
uniform vec3 bg_color_2;
uniform vec3 line_color_1;
uniform vec3 line_color_2;
uniform vec3 circle_color_1;
uniform vec3 circle_color_2;

float rand(vec2 co, float seed) {
    return fract(sin(dot(co, vec2(26.9898, 98.233))) * seed);
}

void main() {
    float seed_1 = 43758.5453 + floor(iTime * 30.0);
    float seed_2 = 45252.2524 + floor(iTime * 30.0);
    
    vec2 original_p = (gl_FragCoord.xy)/iResolution.y;
    
    vec2 p = original_p;
    vec2 color_p = p;

    float rows = 6.0;
    p *= rows;
    color_p *= rows;
    
    color_p += 0.5;
    
    vec2 idx = floor(p);
    vec2 color_idx = floor(color_p);
    
    p = fract(p) - 0.5;
    color_p = fract(color_p) - 0.5;

    if(rand(idx, seed_1) > 0.5) {
        p *= mat2(0.0, 1.0, -1.0, 0.0);
    }
    
    float aa_const = 0.75 * rows / iResolution.y;
    
    float r = min(length(p - vec2(0.5, 0.5)), length(p - vec2(-0.5, -0.5)));
    float l = smoothstep(0.6 + aa_const, 0.6 - aa_const, r) - smoothstep(0.4 + aa_const, 0.4 - aa_const, r);
    
    float r_c = length(color_p);
    float l_c = smoothstep(0.15 + aa_const, 0.15 - aa_const, r_c);
    
    if(rand(color_idx, seed_2) > 0.25) {
        l_c = 0.0;
    }
    
    float gradient_amt = clamp(length(original_p) * 0.6, 0.0, 1.0);
    
    vec4 bg_color = vec4(mix(bg_color_1, bg_color_2, gradient_amt), 1.0);
    vec4 line_color = vec4(mix(line_color_1, line_color_2, gradient_amt), 1.0);
    vec4 circle_color = vec4(mix(circle_color_1, circle_color_2, gradient_amt), 1.0);
    
    gl_FragColor = bg_color;
    gl_FragColor = mix(gl_FragColor, line_color, l);
    gl_FragColor = mix(gl_FragColor, circle_color, l_c);
}