shader_type canvas_item;
render_mode blend_mix;
//uniform sampler2D gradient;

void vertex() {
	// Called for every vertex the material is visible on.
    //vec4 tex_color = texture(TEXTURE, UV);
    //float gray = dot(COLOR.rgb, vec3(0.299, 0.587, 0.114));
    //COLOR = texture(gradient, vec2(gray, 0.0));
	//COLOR = vec4(0.299, 0.987, 0.114, 1.0);
	
	COLOR = vec4(0,0.985,0,1);
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
