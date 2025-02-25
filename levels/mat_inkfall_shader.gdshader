shader_type spatial;
render_mode blend_mix, diffuse_toon, specular_toon;

void fragment() {
	ALBEDO = vec3(0.0, 0.0, 0.0);
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
	float NdotL = max(dot(NORMAL, LIGHT), 0.0);
	DIFFUSE_LIGHT += step(0.5, clamp(dot(NORMAL, LIGHT), 0.0, 1.0) * ATTENUATION * LIGHT_COLOR);
	
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
	
	if (length(specular_brdf_NL * LIGHT_COLOR * specular_blob_intensity * ATTENUATION) < 0.003)
	{
		SPECULAR_LIGHT += 0.0;
	}
	else if (length(specular_brdf_NL * LIGHT_COLOR * specular_blob_intensity * ATTENUATION) > 0.01)
	{
		SPECULAR_LIGHT += 1.0;
	}
	else
	{
		SPECULAR_LIGHT += specular_brdf_NL * LIGHT_COLOR * specular_blob_intensity * ATTENUATION * .5;
	}
	
	//SPECULAR_LIGHT += step(0.005, specular_brdf_NL * LIGHT_COLOR * specular_blob_intensity * ATTENUATION);
}
