// Based on pixelated noise (pattern3) by udart
// https://www.shadertoy.com/view/4d3Szj

shader_type canvas_item;

vec4 a1(float n, vec2 p, sampler2D channel) {
	vec4 ccc=vec4(0.0,0.0,0.0,0.0);
	p=mod(p/n, 1.0) ;
	ccc = texture(channel,p).rgba;	
	return ccc;
}

vec4 a2(float n, vec2 p, sampler2D channel) {
	vec4 ccc=vec4(0.0,0.0,0.0,0.0);
	p=mod(p/n, 1.0) ;
	ccc=texture(channel,p).rgba;	
	return ccc;
}

vec4 a3(float n, vec2 p, sampler2D channel) {
	vec4 ccc=vec4(0.0,0.0,0.0,0.0);
	p=mod(p/n, 1.0) ;
	ccc=texture(channel,p).rgba;	
	return ccc;
}


float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}



void fragment()
{
  int n;
  float time;
	float gray; 
	vec3 col;
	vec4 a,b,c,d=vec4(1.0);
	vec2 uv = FRAGCOORD.xy;
 	
	col = texture(TEXTURE, floor(uv.xy/5.0)*5.0/(1.0 / SCREEN_PIXEL_SIZE).xy).rgb;		
	gray = (col.r*0.2126)+ (col.g*0.7152)+ (col.b*0.0722);        
	if(gray>0.3){
						
		a=a1(20.0,uv.xy,TEXTURE);
		a.r =col.r-a.r;
		a.g =col.g-a.g;
		a.b =col.b-a.b;	
		
	}
	
	col = texture(TEXTURE, floor(uv/10.0)*10.0/(1.0 / SCREEN_PIXEL_SIZE).xy).rgb;		
	gray = (col.r*0.2126)+ (col.g*0.7152)+ (col.b*0.0722);        
	if(gray>0.4){
		
		a=a2(10.0,uv,TEXTURE);
		a.r =col.r-a.r;
		a.g =col.g-a.g;
		a.b =col.b-a.b;			
	}
	
	
	col = texture(TEXTURE, floor(uv/20.0)*20.0/(1.0 / SCREEN_PIXEL_SIZE).xy).rgb;		
	gray = (col.r*0.2126)+ (col.g*0.7152)+ (col.b*0.0722);        
	if(gray>0.6){
		time=gray*rand(floor(uv/20.0)*20.0/(1.0 / SCREEN_PIXEL_SIZE).xy);		
		
		if(time<0.33){
			a=a1(5.0,uv,TEXTURE);
		}else if(time<0.66){
			a=a2(10.0,uv,TEXTURE);
		}else if(time<0.99){
			a=a3(20.0,uv,TEXTURE);
		}	
		
		a.r =col.r-a.r;
		a.g =col.g-a.g;
		a.b =col.b-a.b;						
	}

	COLOR = a*2.8;
}