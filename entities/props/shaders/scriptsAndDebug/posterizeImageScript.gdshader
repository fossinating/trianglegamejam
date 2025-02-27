shader_type spatial;
render_mode ambient_light_disabled,specular_toon, blend_mix,cull_back;

uniform vec3 baseColor : source_color;
uniform sampler2D colorGradient : source_color;
//uniform float colorCount;

uniform sampler2D postPosterizingTexture : source_color;
uniform float postPosterizingTextureStrength: hint_range(0.0, 1.0, 0.01);
uniform float imageShadowStrength: hint_range(0.0, 1.0, 0.01);
uniform sampler2D shadingTexture : source_color;
uniform float shadingTextureStrength: hint_range(0.0, 1.0, 0.01);

uniform float UVOffsetX: hint_range(-1.0, 1.0, 0.01);
uniform float UVOffsetY: hint_range(-1.0, 1.0, 0.01);

uniform float UVScaleX: hint_range(-20.0, 20.0, 0.01);
uniform float UVScaleY: hint_range(-20.0, 20.0, 0.01);

varying vec2 new_uvs;

uniform float normalStrength: hint_range(-1.0, 1.0, 0.01);
uniform float normalSize: hint_range(0.0, 10.0, 0.01);

uniform sampler2D roughnessGradient : source_color;
uniform float roughnessStrength: hint_range(0.0, 1.0, 0.01);
uniform sampler2D specularGradient : source_color;
uniform float specularStrength: hint_range(0.0, 20.0, 0.01);
uniform vec3 specularColor : source_color;

uniform float diffuseLightingStrength: hint_range(0.0, 1.0, 0.01);

uniform sampler2D paintTexture : source_color;
uniform float paintTextureStrength: hint_range(0.0, 1.0, 0.01);
uniform sampler2D paintTextureGradient : source_color;



float fmod(float x, float y) {
	return sign(x) * (abs(x) - y * floor(abs(x) / y));
}

float random(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
	//random(vec2(TIME,0.0))
}

void vertex() {

}
//texture(paintTextureGradient, vec2(paintTexture, 0.5)).x
vec4 heightToNormal(sampler2D heightTexture){
	vec2 size = vec2(2.0,0.0);
	vec3 off = vec3(-1,0,1);
	float x = (texture(heightTexture, new_uvs).x + texture(heightTexture, new_uvs).y + texture(heightTexture, new_uvs).z)/3.0;
    x = x * (1.0-paintTextureStrength) + texture(paintTextureGradient, vec2(texture(paintTexture, new_uvs).x, 0.5)).x*paintTextureStrength;
	float xy = (texture(heightTexture, new_uvs+off.xy).x+texture(heightTexture, new_uvs+off.xy).y+texture(heightTexture, new_uvs+off.xy).z)/3.0;
    xy = xy * (1.0-paintTextureStrength) + texture(paintTextureGradient, vec2(texture(paintTexture, new_uvs+off.xy).x, 0.5)).x*paintTextureStrength;
	float zy = (texture(heightTexture, new_uvs+off.zy).x+texture(heightTexture, new_uvs+off.zy).y+texture(heightTexture, new_uvs+off.zy).z)/3.0;
    zy = zy * (1.0-paintTextureStrength) + texture(paintTextureGradient, vec2(texture(paintTexture, new_uvs+off.zy).x, 0.5)).x*paintTextureStrength;
	float yx = (texture(heightTexture, new_uvs+off.yx).x+texture(heightTexture, new_uvs+off.yx).y+texture(heightTexture, new_uvs+off.yx).z)/3.0;
	yx = yx * (1.0-paintTextureStrength) + texture(paintTextureGradient, vec2(texture(paintTexture, new_uvs+off.yx).x, 0.5)).x*paintTextureStrength;
	float yz = (texture(heightTexture, new_uvs+off.yz).x+texture(heightTexture, new_uvs+off.yz).y+texture(heightTexture, new_uvs+off.yz).z)/3.0;
	yz = yz * (1.0-paintTextureStrength) + texture(paintTextureGradient, vec2(texture(paintTexture, new_uvs+off.yz).x, 0.5)).x*paintTextureStrength;
	vec3 va = normalize(vec3(size.xy,xy-zy*normalSize));
    vec3 vb = normalize(vec3(size.yx,yz-yx*normalSize));
    return vec4( cross(va,vb),x)*(1.0-texture(heightTexture, new_uvs).a);
}

void fragment() {
	new_uvs = UV * vec2(UVScaleX, UVScaleY) + (vec2(UVOffsetX - 0.5,UVOffsetY - 0.5));
	float monochromeTexture = (texture(shadingTexture,new_uvs).r + texture(shadingTexture,new_uvs).g + texture(shadingTexture,new_uvs).b)/3.0;
	ALBEDO = mix(baseColor, texture(shadingTexture,new_uvs).rgb, shadingTextureStrength);
	//EMISSION = vec3(0.1, 0.1, 0.1);
	ROUGHNESS = texture(roughnessGradient, vec2(monochromeTexture, 0.5)).r* roughnessStrength*(1.0-paintTextureStrength) + mix(texture(roughnessGradient, vec2(monochromeTexture, 0.5)).r,1.0,0.6) * roughnessStrength * (texture(paintTexture, new_uvs).r+(1.0-texture(shadingTexture,new_uvs).a)) * paintTextureStrength;
	SPECULAR = texture(specularGradient, vec2(monochromeTexture, 0.5)).r * specularStrength*(1.0-paintTextureStrength) + mix(texture(specularGradient, vec2(monochromeTexture, 0.5)).r,1.0,0.6) * specularStrength * (texture(paintTexture, new_uvs).r+(1.0-texture(shadingTexture,new_uvs).a)) * paintTextureStrength;


	NORMAL_MAP = heightToNormal(postPosterizingTexture).rgb;
	NORMAL_MAP_DEPTH = normalStrength;
}



void light() {

	DIFFUSE_LIGHT += ALBEDO * ATTENUATION * LIGHT_COLOR * max(dot(LIGHT,NORMAL)+0.4, 0.0)*diffuseLightingStrength;



	float attenuation = smoothstep(0.2, 0.25, ATTENUATION);
	vec3 addedCam = normalize(VIEW + LIGHT);
	float vDotL = pow(clamp(dot(NORMAL, addedCam), 0.0, 1.0),(ROUGHNESS));
     // using custom attenuation for specular highlights
	vDotL = pow(vDotL * attenuation, 120)*3.0;
	vDotL = smoothstep(0.8, 0.81, vDotL);
	float specular = pow(vDotL, 1.0) * 0.1;
	if(specular>0.099){
		DIFFUSE_LIGHT += specularColor.rgb*specularStrength;
	}


	// assign the result
	//SPECULAR_LIGHT = round(DIFFUSE_LIGHT*colorCount - 0.5)/colorCount;
	// posterizes the final color
	SPECULAR_LIGHT = DIFFUSE_LIGHT; // do nothing to the result
	float position = clamp((SPECULAR_LIGHT.r+SPECULAR_LIGHT.g+SPECULAR_LIGHT.b)/3.0,0.01,0.99);
	SPECULAR_LIGHT = texture(colorGradient, vec2(position, 0.5)).rgb;

	SPECULAR_LIGHT = mix(SPECULAR_LIGHT, texture(postPosterizingTexture,new_uvs).rgb+(mix(vec3(0.0,0.0,0.0), DIFFUSE_LIGHT* texture(postPosterizingTexture,new_uvs).rgb,imageShadowStrength)), texture(postPosterizingTexture,new_uvs).a * postPosterizingTextureStrength);

	// cancel all contribution of the diffuse_light variable
	SPECULAR_LIGHT -= ALBEDO * DIFFUSE_LIGHT;

	//SPECULAR_LIGHT= vec3(0.0,0.0,0.0);
	//DIFFUSE_LIGHT = NORMAL;




}
