shader_type spatial;
render_mode blend_mix, diffuse_toon, specular_toon;

uniform vec3 baseColor = vec3(0.0, 0.0, 0.0);

uniform float specular_power = 1;
uniform float specular_strength = 100000;
uniform float specular_size = 3;
uniform vec3 specular_color = vec3(1.0, 1.0, 1.0);

uniform sampler2D fresnel_gradient;

uniform float heightBias: hint_range(-3.0, 3.0, 0.01) = 1.0;
uniform float heightCutoff: hint_range(-3.0, 3.0, 0.01) = 0.52;

varying vec3 topVertex;
varying vec3 world_position;

uniform float speed = 3;
uniform float frequency = 3;
uniform float amplitude = 0.03;

void vertex() {
	world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	vec3 world_pos = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
	vec3 obj_pos = (inverse(MODEL_MATRIX) * vec4(world_pos, 1.0)).xyz;

	vec3 fixedNorm = (MODEL_NORMAL_MATRIX * VERTEX).xyz ;
	topVertex = clamp(fixedNorm,-10.0,10.0) * heightBias;

	//vec3 worldTopVertex = world_position + vec3(0.0, sin(world_pos.y * frequency + TIME*speed)*amplitude*clamp(topVertex.y-0.1,0.0,1.0),0.0);
	vec3 worldTopVertex = world_position + vec3(0.0, sin(world_pos.y * frequency + TIME*speed)*amplitude*clamp(1.0,0.0,1.0),0.0);
	VERTEX = (inverse(MODEL_MATRIX) * vec4(worldTopVertex, 1.0)).xyz;
}

void fragment() {
	ALBEDO = baseColor;
	SPECULAR = 0.0;
}

float fresnel(float amount, vec3 normal, vec3 view){
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0 )), amount);
}

float D_GGX(float cos_theta_m, float alpha)
{
	float alpha2 = alpha * alpha;
	float d = 1.0 + (alpha2 - 1.0) * cos_theta_m * cos_theta_m;
	return alpha2 / (PI * d * d);
}

float G_GGX_2cos(float cos_theta_m, float alpha)
{
float k = 0.5 * alpha;
return 0.5 / (cos_theta_m * (1.0 - k) + k);
}

vec3 F0(float metallic, float specular, vec3 albedo)
{
	float dielectric = 0.16 * specular * specular;
	return mix(vec3(dielectric), albedo, vec3(metallic));
}


float SchlickFresnel(float u)
{
	float m = 1.0 - u;
	float m2 = m * m;
	return m2 * m2 * m;
}

void light() {
	float attenuation = smoothstep(0.2, 0.25, ATTENUATION);

	vec3 addedCam = normalize(VIEW + LIGHT);
	float vDotL = clamp(dot(NORMAL, addedCam), 0.0, 1.0);
     // using custom attenuation for specular highlights
	vDotL = pow(vDotL * attenuation, 120)*specular_size;
	vDotL = smoothstep(0.8, 0.81, vDotL);

	float NdotL = max(dot(NORMAL, LIGHT), 0.0);
	DIFFUSE_LIGHT += step(0.5, clamp(dot(NORMAL, LIGHT), 0.0, 1.0) * attenuation * LIGHT_COLOR);

	vec3 halfway = normalize(VIEW + LIGHT);
	float NdotH = max(dot(NORMAL, halfway), 0.0);
	float LdotH = max(dot(LIGHT, halfway), 0.0);
	float NdotV = max(dot(NORMAL, VIEW), 0.0);

	float alpha_ggx = ROUGHNESS * ROUGHNESS;
	float D = D_GGX(NdotH, alpha_ggx);
	float G = G_GGX_2cos(NdotL, alpha_ggx) * G_GGX_2cos(NdotV, alpha_ggx);

	vec3 f0 = F0(METALLIC, SPECULAR_AMOUNT, ALBEDO);
	float cLdotH5 = SchlickFresnel(LdotH);
	vec3 F = mix(vec3(cLdotH5), vec3(1.0), f0);

	vec3 specular_brdf_NL = NdotL * D * F * G;

	float specular_blob_intensity = .25;

	float specular = pow(vDotL, specular_power) * specular_strength;
	if(specular>0.005){
		SPECULAR_LIGHT += specular_color.rgb;
	}

	//if (length(specular_brdf_NL * LIGHT_COLOR * specular_blob_intensity * attenuation) < 0.003)
	//{
		//SPECULAR_LIGHT += 0.0;
	//}
	//else if (length(specular_brdf_NL * LIGHT_COLOR * specular_blob_intensity * attenuation) > 0.01)
	//{
		//SPECULAR_LIGHT += 1.0;
	//}
	//else
	//{
		//SPECULAR_LIGHT += specular_brdf_NL * LIGHT_COLOR * specular_blob_intensity * attenuation * .5;
	//}

	//SPECULAR_LIGHT += step(0.005, specular_brdf_NL * LIGHT_COLOR * specular_blob_intensity * ATTENUATION);
}
