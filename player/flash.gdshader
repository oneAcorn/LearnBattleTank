shader_type canvas_item;

uniform bool active; //外部控制是否闪烁
uniform vec3 flash_color:source_color=vec3(1.0);

void fragment() {
	vec4 t=texture(TEXTURE,UV);
	if(active == true){
		COLOR = vec4(flash_color,t.a);
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
