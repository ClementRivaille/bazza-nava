shader_type canvas_item;

// Based on Simple Sine Wave by crazyheckman
// https://www.shadertoy.com/view/MsX3DN
// And gameboy shader by Krankomat

// edited and updated by Krankomat, Aug 17, 2019 
// ---------- 
// based on: http://ivanskodje.com/2016/10/20/godot-engine-godot-gameboy-shaders/ 
// author: Ivan Skodje 
// date: Oct 20, 2016 


// Colors that we will use
uniform vec4 color_1 : hint_color = vec4( 0.839216, 0.796078, 0.556863, 1 );
uniform vec4 color_2 : hint_color = vec4( 0.47451, 0.541176, 0.337255, 1 );
uniform vec4 color_3 : hint_color = vec4( 0.188235, 0.439216, 0.466667, 1 );
uniform vec4 color_4 : hint_color = vec4( 0.0509804, 0.14902, 0.270588, 1 );

// Color offset - changes threshold for color adjustments
uniform float offset = 0.5;

vec4 sine( vec4 fragColor, vec2 uv, float iTime, sampler2D channel0 )
{
	
	// Modify that X coordinate by the sin of y to oscillate back and forth up in this.
	uv.x += sin(uv.y*15.0+iTime)/10.0;
	
	// The theory be that you turn this sucka into basically a graph 
	// (like on them TI-80 whatevers)
	// The sin of y says that y at 0 is the start of your sin wave
	// Then the bottom of your image is the end of one sin wave
	// (go ahead and delete them 10s and give her a try)
	// This will show 3 images waving back and forth like the JUST DON'T CARE
	// That's because ya'll is waving the x from -1 to 1 (-1, 0, 1)
	// So we need to get all amplitude and freqency on this bitch
	// That's where the 10s come in, and they could be any one of them numbers
	// the multply by 10 increases the frequency making the waves tight or loose as ... well ... you know...
	// the divide by 10 decreases that amplitude til it's wavy as FUCK
	// So play around with them shits.
	
	
	// Get the pixel color at the index.
	return texture(channel0, uv);
}

// Function to convert a pixel color into grayscale
vec4 to_grayscale(vec4 pixcol)
{
    float average = (pixcol.r + pixcol.g + pixcol.b) / 3.0;
    return vec4(average, average, average, 1);
}

// Colorizes the grayscale pixel
vec4 colorize(vec4 grayscale)
{
    // Color greater than (default) 0.75 in value
    // Set brightest color 1
    if(grayscale.r > offset * 1.5)
        return vec4(color_1);
    
    // Color greater than (default) 0.50 in value
    // Set bright color 2
    if(grayscale.r > offset)
        return vec4(color_2);
    
    // Color greater than (default) 0.25 in value
    // Set dark color 3
    if(grayscale.r > offset * 0.5)
        return vec4(color_3);
    
    // Color greater than 0 in value
    // Set darkest color 4
    return vec4(color_4);
}

void fragment() 
{ 
    // Get pixel color on screen 
    vec4 pixel_color =  vec4(texture(TEXTURE, SCREEN_UV)); 
    
    // Set the pixel color we are going to use
    // COLOR = sine(colorize(to_grayscale(pixel_color)), SCREEN_UV, TIME, TEXTURE ) ;
    COLOR = colorize(to_grayscale(sine(pixel_color, SCREEN_UV, TIME, TEXTURE ))) ;
    
} 
