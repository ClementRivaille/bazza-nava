// Color bending by rohtie
// https://www.shadertoy.com/view/Xt2XRR

shader_type canvas_item;

void fragment() {
    vec2 p = FRAGCOORD.xy / (1.0 / SCREEN_PIXEL_SIZE).xy;
    
    float t = TIME;
    
    COLOR.rgb = vec3(texture(TEXTURE, p).r, texture(TEXTURE, p - 0.025 + cos(t + p.y + p.x)*0.1).g, texture(TEXTURE, p + 0.04  + sin(t + p.y + p.x)*0.1).b);
	COLOR.rgb *= 1.75;
    
    float a = t*0.25;
    
    COLOR.gb -= texture(TEXTURE, (p + length(p) ) *
                      mat2(vec2(cos(a), -sin(a)), 
                       vec2(sin(a), cos(a)))).gb *
                      0.15 + length(p - 0.5);
    
    COLOR.rgb -= length(p - 0.5) * 0.75;
}