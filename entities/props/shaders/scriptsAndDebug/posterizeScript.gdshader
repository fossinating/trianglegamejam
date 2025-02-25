shader_type spatial;
render_mode ambient_light_disabled;

uniform vec3 baseColor : source_color;
uniform sampler2D colorGradient : source_color;
uniform float colorCount;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALBEDO = baseColor;
	//EMISSION = vec3(0.01, 0.01, 0.01);
	ROUGHNESS = 1.0;
}

float fmod(float x, float y) {
	return sign(x) * (abs(x) - y * floor(abs(x) / y));
}


void light() {
	// light we wish to accumulate
	DIFFUSE_LIGHT += ALBEDO * ATTENUATION * LIGHT_COLOR * max(dot(LIGHT,NORMAL)+0.4, 0.0);

	// assign the result
	//SPECULAR_LIGHT = round(DIFFUSE_LIGHT*colorCount - 0.5)/colorCount;
	// posterizes the final color
	SPECULAR_LIGHT = DIFFUSE_LIGHT; // do nothing to the result
	float position = clamp((SPECULAR_LIGHT.r+SPECULAR_LIGHT.g+SPECULAR_LIGHT.b)/3.0,0.01,0.99);
	SPECULAR_LIGHT = texture(colorGradient, vec2(position, 0.5)).rgb;

	// cancel all contribution of the diffuse_light variable
	SPECULAR_LIGHT -= ALBEDO * DIFFUSE_LIGHT;

}
