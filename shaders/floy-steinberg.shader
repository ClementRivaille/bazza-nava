// Classic Mac floyd-steinberg-ish by Raven Works
// https://www.shadertoy.com/view/4sjGRD

shader_type canvas_item;

uniform int lookupSize = 64;
uniform float errorCarry = 0.3;

float getGrayscale(vec2 coords, vec2 resolution, sampler2D channel){
	vec2 uv = coords / resolution.xy;
	vec3 sourcePixel = texture(channel, uv).rgb;
	return length(sourcePixel*vec3(0.2126,0.7152,0.0722));
}

void fragment( ) {
	
	int topGapY = int((1.0 / SCREEN_PIXEL_SIZE).y - FRAGCOORD.y);
	
	int cornerGapX = int((FRAGCOORD.x < 10.0) ? FRAGCOORD.x : (1.0 / SCREEN_PIXEL_SIZE).x - FRAGCOORD.x);
	int cornerGapY = int((FRAGCOORD.y < 10.0) ? FRAGCOORD.y : (1.0 / SCREEN_PIXEL_SIZE).y - FRAGCOORD.y);
	int cornerThreshhold = ((cornerGapX == 0) || (topGapY == 0)) ? 5 : 4;
	
	if (cornerGapX+cornerGapY < cornerThreshhold) {
				
		COLOR = vec4(0,0,0,1);
		
	} else if (topGapY < 20) {
			
			if (topGapY == 19) {
				
				COLOR = vec4(0,0,0,1);
				
			} else {
		
				COLOR = vec4(1,1,1,1);
				
			}
		
	} else {
		
		float xError = 0.0;
		for(int xLook=0; xLook<lookupSize; xLook++){
			float grayscale = getGrayscale(FRAGCOORD.xy + vec2(float(-lookupSize+xLook),0), (1.0 / SCREEN_PIXEL_SIZE), TEXTURE);
			grayscale += xError;
			float bit = grayscale >= 0.5 ? 1.0 : 0.0;
			xError = (grayscale - bit)*errorCarry;
		}
		
		float yError = 0.0;
		for(int yLook=0; yLook<lookupSize; yLook++){
			float grayscale = getGrayscale(FRAGCOORD.xy + vec2(0,float(-lookupSize+yLook)), (1.0 / SCREEN_PIXEL_SIZE), TEXTURE);
			grayscale += yError;
			float bit = grayscale >= 0.5 ? 1.0 : 0.0;
			yError = (grayscale - bit)*errorCarry;
		}
		
		float finalGrayscale = getGrayscale(FRAGCOORD.xy, (1.0 / SCREEN_PIXEL_SIZE), TEXTURE);
		finalGrayscale += xError*0.5 + yError*0.5;
		float finalBit = finalGrayscale >= 0.5 ? 1.0 : 0.0;
		
		COLOR = vec4(finalBit,finalBit,finalBit,1);
			
	}
	
}