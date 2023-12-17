shader_type canvas_item;

void fragment() {
	if(UV.x < UV.y){
		COLOR = vec4(0.0, 0.0, 0.0, 1.0);
	}
}
