shader_type spatial;
render_mode blend_mix, depth_draw_never, unshaded, cull_disabled;

uniform vec3 baseColor : source_color = vec3(0.0, 0.0, 0.0);
uniform float heightBias: hint_range(-3.0, 3.0, 0.01) = 1.0;
uniform float heightCutoff: hint_range(-3.0, 3.0, 0.01) = 0.52;

varying vec3 topVertex;
varying vec3 world_position;

uniform float speed = 3.0;
uniform float frequency = 4.0;
uniform float amplitude = 0.05;

uniform float specular_power = 1.0;
uniform float specular_strength = 10000.0;
uniform vec3 specular_color : source_color = vec3(0.0, 0.0, 0.0);

void vertex() {
	world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	vec3 world_pos = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
	vec3 obj_pos = (inverse(MODEL_MATRIX) * vec4(world_pos, 1.0)).xyz;


	//topVertex = (inverse(MODEL_NORMAL_MATRIX) * VERTEX).xyz;
	vec3 fixedNorm = (MODEL_NORMAL_MATRIX * VERTEX).xyz ;
	topVertex = clamp(fixedNorm,-10.0,10.0)* heightBias;


	//if(topVertex.y - 0.1 > 0.0){
		//VERTEX = VERTEX-((topVertex.y-heightCutoff)*fixedNorm);
		//vec3 worldTopVertex = (MODEL_MATRIX * vec4(0.0, heightCutoff, 0.0, 1.0)).xyz;
		vec3 worldTopVertex = world_position + vec3(0.0, sin(world_pos.y * frequency + TIME*speed)*amplitude*clamp(topVertex.y-0.1,0.0,1.0),0.0);
		VERTEX = (inverse(MODEL_MATRIX) * vec4(worldTopVertex, 1.0)).xyz;
		//VERTEX = (inverse(MODEL_MATRIX) * vec4(world_position, 1.0)).xyz;






}



void fragment() {
	ALBEDO = baseColor;
	SPECULAR = 0.9;
	ROUGHNESS = 0.4;

	if(topVertex.y > heightCutoff){
		//ALBEDO = vec3(1.0,1.0,1.0);
		ALPHA = 0.0;
	}
	else{
		//ALBEDO = vec3(0.0,0.0,0.0);
		ALPHA = 1.0;
	}


	//ALPHA = 1.0;

	//ALBEDO =  topVertex.y*vec3(1.0,1.0,1.0);

	/*
	if(VERTEX.y > heightCutoff){
		ALPHA = 0.0;
	}
	else{
		ALPHA = 1.0;
	}
	*/
	//ALPHA = 0.0;
	// Called for every pixel the material is visible on.
}
void light(){
    // our stylized attenuation
	float attenuation = smoothstep(0.2, 0.25, ATTENUATION);

	vec3 addedCam = normalize(VIEW + LIGHT);
	float vDotL = clamp(dot(NORMAL, addedCam), 0.0, 1.0);
     // using custom attenuation for specular highlights
	vDotL = pow(vDotL * attenuation, 120);
	vDotL = smoothstep(0.8, 0.81, vDotL);




	float specular = pow(vDotL, specular_power) * specular_strength * ATTENUATION;
	if(specular>0.1){
		SPECULAR_LIGHT += specular_color.rgb;
	}
}
