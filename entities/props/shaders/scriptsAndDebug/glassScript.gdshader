shader_type spatial;
render_mode blend_add,cull_back,specular_toon, depth_draw_always;

uniform vec3 baseColor : source_color;

uniform float specular_power;
uniform float specular_strength;
uniform float specular_size;
uniform vec3 specular_color : source_color;

uniform sampler2D fresnel_gradient;

void fragment() {
	ALBEDO = baseColor;
	SPECULAR = 0.0f;
	ROUGHNESS = 0.0;
}

float fresnel(float amount, vec3 normal, vec3 view){
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0 )), amount);
}

void light() {
	// our stylized attenuation
	float attenuation = smoothstep(0.2, 0.25, ATTENUATION);

	vec3 addedCam = normalize(VIEW + LIGHT);
	float vDotL = clamp(dot(NORMAL, addedCam), 0.0, 1.0);
     // using custom attenuation for specular highlights
	vDotL = pow(vDotL * attenuation, 120)*specular_size;
	vDotL = smoothstep(0.8, 0.81, vDotL);




	float specular = pow(vDotL, specular_power) * specular_strength;
	if(specular>0.01){
		SPECULAR_LIGHT += specular_color.rgb;
	}

	float basic_fresnel = fresnel(4.0, NORMAL, VIEW);
	SPECULAR_LIGHT += (basic_fresnel * texture(fresnel_gradient, vec2(basic_fresnel, 0.0)).rgb * 1.0);;
}
