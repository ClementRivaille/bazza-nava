shader_type canvas_item;

mat4 contrastMatrix( float contrast )
{
	float t = ( 1.0 - contrast ) / 2.0;
    
    return mat4( vec4(contrast, 0, 0, 0),
                 vec4(0, contrast, 0, 0),
                 vec4(0, 0, contrast, 0),
                 vec4(t, t, t, 1) );

}

mat4 saturationMatrix( float saturation )
{
    vec3 luminance = vec3( 0.3086, 0.6094, 0.0820 );
    
    float oneMinusSat = 1.0 - saturation;
    
    vec3 red = vec3( luminance.x * oneMinusSat );
    red+= vec3( saturation, 0, 0 );
    
    vec3 green = vec3( luminance.y * oneMinusSat );
    green += vec3( 0, saturation, 0 );
    
    vec3 blue = vec3( luminance.z * oneMinusSat );
    blue += vec3( 0, 0, saturation );
    
    return mat4( vec4(red,     0),
                 vec4(green,   0),
                 vec4(blue,    0),
                 vec4(0, 0, 0, 1) );
}

mat4 brightnessMatrix( float brightness )
{
    return mat4( vec4(1, 0, 0, 0),
                 vec4(0, 1, 0, 0),
                 vec4(0, 0, 1, 0),
                 vec4(brightness, brightness, brightness, 1) );
}

void fragment()
{
      vec4 c0 = texture(TEXTURE, SCREEN_UV);
      vec4 c1 = texture(TEXTURE, vec2(1.0-SCREEN_UV.x, SCREEN_UV.y));
      vec4 c2 = texture(TEXTURE, vec2(SCREEN_UV.x, 1.0-SCREEN_UV.y));
      vec4 c3 = texture(TEXTURE, vec2(1.0-SCREEN_UV.x, 1.0-SCREEN_UV.y));
    
    vec4 color = (SCREEN_UV.y >= 0.5 && SCREEN_UV.x >= 0.5) ? c0 :
                 ((SCREEN_UV.y >= 0.5 && SCREEN_UV.x < 0.5) ? c1 :
                 ((SCREEN_UV.y < 0.5 && SCREEN_UV.x >= 0.5) ? c2 : c3));
    
    vec4 d = max(c0, c1);
    d = max(d, c2);
    d = max(d, c3);
    
    
    float saturation = 1.0 + abs(sin(TIME * 0.4 )) * 0.3;
    float contrast = 1.4 + abs(sin(TIME * 0.3)) * 0.2;
    float brightness = -0.02 - abs(sin(TIME * 0.2)) * 0.11;
    
    vec3 s = mix(color.rgb, d.rgb, (color.rgb + d.rgb) * 0.5); 
    COLOR = vec4(s.rgb, 1.0) * contrastMatrix(contrast) * brightnessMatrix(brightness) * saturationMatrix(saturation);
   // COLOR = vec4(s.rgb, 1.0) * contrastMatrix(1.6) * brightnessMatrix(-0.15) * saturationMatrix(saturation);
}