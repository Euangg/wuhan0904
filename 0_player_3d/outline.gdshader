shader_type spatial;

void vertex() {
	// Called for every vertex the material is visible on.
}

uniform sampler2D tex:source_color;
uniform vec3 flash_color:source_color=vec3(1.0);
uniform float intensity:hint_range(0.0, 1.0, 0.1)=0.0;

void fragment() {
	//COLOR=COLOR;
}


//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
