#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D iChannel0;

uniform float iTime;
uniform vec2 iResolution;

uniform vec3 bg_color;
uniform vec3 fg_color_1;
uniform vec3 fg_color_2;
uniform vec3 fg_color_3;
uniform vec3 fg_color_4;

const vec2 sampler_size = vec2(32.0, 32.0);
const vec2 pixels_per_sample = vec2(8.0, 8.0);

smooth in vec4 gl_FragCoord;

float rand(vec2 co, float seed)
{
    vec2 p = co + seed;
	vec3 p3  = fract(vec3(p.xyx) * .1031);
    p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.x + p3.y) * p3.z);
}

float rand11(float p)
{
    return fract(sin(p) * 43758.5453123);
}

vec2 rand12(float p)
{
    float x = rand11(p);
    return vec2(x, rand11(x + p));
}

vec3[] fg_colors = vec3[4](
    fg_color_1,
    fg_color_2,
    fg_color_3,
    fg_color_4
);

void main()
{
    vec2 uv = gl_FragCoord.xy/iResolution.y;
    
    float shape_seed = 45436.2342 + floor(iTime);
    float color_seed = 42352.6335 + floor(iTime + 0.5);

    vec2 grid = vec2(6.0, 6.0);
    vec2 noisePos = floor(rand12(color_seed) * (sampler_size - grid) );
    
    uv *= grid;
    
    vec2 idx = floor(uv);
    vec4 noise = texture2D(iChannel0, ((noisePos + idx) + 0.5) / (sampler_size));

    float r = floor(rand(idx, shape_seed) * 3.0);
    
    if(r == 1.0) {
        uv.x += 0.5;
    } else if(r == 2.0) {
        uv.y += 0.5;
    }
    
    uv = fract(uv);
    
    vec2 pos = uv - 0.5;
    vec3 fg_color = fg_colors[int(noise.r + noise.g * 2.0 + noise.b * 3.0)];

    gl_FragColor = vec4(mix(fg_color, bg_color, smoothstep(0.245, 0.255, dot(pos, pos))), 1.000);
}