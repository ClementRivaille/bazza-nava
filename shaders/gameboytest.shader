// Based on gameboytest by RebelMoogle
// https://www.shadertoy.com/view/ltV3Wc
shader_type canvas_item;

float CalculateHue(vec4 color, float minCol, float maxCol)
{
    float hue = 0.0;  
    hue = hue*60.0;
    
    if(hue < 0.0)
    {
        hue += 360.0;
    }
    
    if(abs(maxCol - color.r) < 0.000001)
    {
        // If Red is max, then Hue = (G-B)/(max-min)
        hue = (color.g - color.b)/(maxCol-minCol);
    }
   	else if(abs(maxCol - color.g) < 0.000001)
    {
        // If Green is max, then Hue = 2.0 + (B-R)/(max-min)
        hue = 2.0 + (color.b - color.r)/(maxCol-minCol);
    }
    else
    {
        // If Blue is max, then Hue = 4.0 + (R-G)/(max-min)
        hue = 4.0 + (color.r - color.g)/(maxCol-maxCol);
    }
    
    return hue;
}

void fragment()
{
    vec3 darkest =  vec3(0.0588235, 0.219608, 0.0588235);
    vec3 darker = vec3( 0.188235, 0.384314, 0.188235);
    vec3 lighter = vec3( 0.545098, 0.67451, 0.0588235);
    vec3 lightest = vec3(  0.607843, 0.737255, 0.0588235);
    float lumDarkest = 0.392156862745098;
    float lumDarker = 0.48627450980392155;
    float lumLighter = 0.7466666666666667;
    float lumLightest = 0.9503921568627454;

	vec2 uv = FRAGCOORD.xy / (1.0 / SCREEN_PIXEL_SIZE).xy;
    uv *= 200.0;
    uv = vec2(floor(uv.x), floor(uv.y));
    uv *= 0.005;   
    
    
	COLOR = texture(TEXTURE, uv);
    float maxCol = max(max(COLOR.r, COLOR.g), COLOR.b);
    float minCol = min(min(COLOR.r, COLOR.g), COLOR.b);
    float lum = (minCol + maxCol)/2.0;
    
    float darkestDist = abs(lumDarkest - lum); //length(darkest - COLOR.rgb);
    float darkerDist = abs(lumDarker - lum); //length(darker - COLOR.rgb);
    float lighterDist = abs(lumLighter - lum); //length(lighter - COLOR.rgb);
    float lightestDist = abs(lumLightest - lum); //length(lightest - COLOR.rgb);
    
    float minDist = min(min(min(darkestDist, darkerDist), lighterDist), lightestDist);
    
    if( abs(minDist - darkestDist) < 0.000001)
    {
        COLOR = vec4(darkest, 1.0);
    }
    else if(abs(minDist - darkerDist) < 0.000001)
    {
        COLOR = vec4(darker, 1.0);
    }
    else if(abs(minDist - lighterDist) < 0.000001)
    {
        COLOR = vec4(lighter, 1.0);
    }
    else
    {
        COLOR = vec4(lightest, 1.0);
    }
    
   
}