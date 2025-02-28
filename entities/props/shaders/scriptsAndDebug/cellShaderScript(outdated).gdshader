shader_type spatial;
render_mode blend_mix,depth_draw_always, cull_back, diffuse_toon, ambient_light_disabled;


uniform vec3 colorShadow : source_color;
uniform float colorBoundaryDark: hint_range(0.0, 1.01, 0.01);
uniform vec3 colorMidtone : source_color;
uniform float colorBoundaryBright: hint_range(0.0, 1.01, 0.01);
uniform vec3 colorBright : source_color;

uniform vec3 baseColor : source_color;

uniform sampler2D shadingTexture : source_color; //pre cell shading pass
//uniform sampler2D colorTexture : source_color; //post cell shading pass

uniform float specular_power;
uniform float specular_strength;
uniform vec3 specular_color : source_color;


uniform sampler2D fresnel_gradient;

uniform float roughness;
uniform sampler2D roughnessTexture : source_color;

uniform sampler2D normalTexture : source_color;
uniform float normalStrength;







float fresnel(float amount, vec3 normal, vec3 view){
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0 )), amount);
}

void vertex() {

}

void fragment() {

	vec2 base_uv = UV;
	vec4 albedo_tex = texture(shadingTexture, base_uv);

	float basic_fresnel = fresnel(4.0, NORMAL, VIEW);
	//ALBEDO =  colorBright + (basic_fresnel * texture(fresnel_gradient, vec2(basic_fresnel, 0.0)).rgb * 1.0);
	ALBEDO = baseColor * ((albedo_tex.r+albedo_tex.g +albedo_tex.b)/3.0);

	vec4 roughness_texture_channel = vec4(0.0,1.0,0.0,0.0);
	float roughness_tex = dot(texture(roughnessTexture, base_uv), roughness_texture_channel);

	ROUGHNESS = roughness_tex * roughness;
	SPECULAR = 0.0;

	NORMAL_MAP = texture (normalTexture, base_uv).rgb;
	NORMAL_MAP_DEPTH = normalStrength;

}


void light(){
    // our stylized attenuation
	float attenuation = smoothstep(0.2, 0.25, ATTENUATION);


	vec3 addedCam = normalize(VIEW + LIGHT);
	float vDotL = clamp(dot(NORMAL, addedCam), 0.0, 1.0);
     // using custom attenuation for specular highlights
	vDotL = pow(vDotL * attenuation, 120);
	vDotL = smoothstep(0.8, 0.81, vDotL);




	float lightStrength = clamp(dot(NORMAL, LIGHT), 0.0, 1.0) * ATTENUATION;
	//DIFFUSE_LIGHT += lightStrength * vec3(1.0,1.0,1.0);

	if(DIFFUSE_LIGHT != colorBright && DIFFUSE_LIGHT != colorMidtone && DIFFUSE_LIGHT != colorShadow){
		DIFFUSE_LIGHT = colorShadow;
	}
	if(lightStrength  < colorBoundaryBright){
		if(lightStrength < colorBoundaryDark){
			if(DIFFUSE_LIGHT == colorBright){
				DIFFUSE_LIGHT = colorBright;
			}
			else{
				if(DIFFUSE_LIGHT == colorMidtone){
					DIFFUSE_LIGHT = colorMidtone;
				}
				else{
					DIFFUSE_LIGHT += colorShadow;
				}
			}
		}
		else{
			if(DIFFUSE_LIGHT == colorBright){
				DIFFUSE_LIGHT = colorBright;
			}
			else{
				DIFFUSE_LIGHT = colorMidtone;
			}
		}
	}
	else{
		DIFFUSE_LIGHT = colorBright;
	}
	//DIFFUSE_LIGHT = clamp (DIFFUSE_LIGHT/baseColor, 0.0, 1.0);



	float specular = pow(vDotL, specular_power) * specular_strength * ATTENUATION;
	if(specular>0.1){
		SPECULAR_LIGHT += specular_color.rgb;
	}
}





/*
vec4 remapLight(vec3 light){ //remap from -1-1 to 0-1
	float position;
	position = ((light.x + light.y + light.z + 3.0) / 6.0);
	//colorMappingGradient
	return texture(colorMappingGradient, vec2(position, 0.5));
}

vec3 posterizeLight(vec3 light){
	light = (light*2.0)-1.0;
	float diff1 = dot(light, colorShadow);
	float diff2 = dot(light, colorMidtone);
	float diff3 = dot(light, colorBright);


	if(diff1 > diff2){
		if(diff1 > diff3){
			return colorShadow;
		}
		return colorBright;
	}
	if(diff2 > diff3){
		return colorMidtone;
	}

	return colorBright;


}
*/



/*void light() {

	float dotproduct = clamp(dot (NORMAL, LIGHT), -0.9, 0.9);
	float sample = clamp((dotproduct + 1.0) * ATTENUATION / 2.1, 0.05, 0.95);
	vec4 shaded = texture(colorMappingGradient, vec2(sample, 0.0)) ;
	DIFFUSE_LIGHT += clamp ((shaded.rgb * LIGHT_COLOR), 0.0, 1.0);



	DIFFUSE_LIGHT += clamp(dot(NORMAL, LIGHT),0.0,1.0) * ATTENUATION * ALBEDO * LIGHT_COLOR;
	DIFFUSE_LIGHT = posterizeLight(DIFFUSE_LIGHT);

	//DIFFUSE_LIGHT = (remapLight(DIFFUSE_LIGHT).rgb-0.35);


	vec3 H = normalize(VIEW + LIGHT);
	float NdotH = max(0, dot(NORMAL, H));
	float specular = pow(NdotH, specular_power) * specular_strength * ATTENUATION;
	//SPECULAR_LIGHT += specular * specular_color.rgb * LIGHT_COLOR;
}*/
