shader_type canvas_item;

uniform float GREEN_MIN : hint_range(0.0, 1.0) = 0.45;
uniform float GREEN_MAX : hint_range(0.0, 1.0) = 0.55;
uniform float YELLOW_MIN : hint_range(0.0, 1.0) = 0.35;
uniform float YELLOW_MAX : hint_range(0.0, 1.0) = 0.65;
uniform float RED_MIN : hint_range(0.0, 1.0) = 0.2;
uniform float RED_MAX : hint_range(0.0, 1.0) = 0.8;

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);
	
	// Origin at the bottom center
	vec2 pos = UV - vec2(0.5, 1.0);
	
	float dist = length(pos);
	
	// atan2 returns -PI to 0 for the area above the origin (y < 0)
	// We normalize this to 0.0 (left) to 1.0 (right)
	float angle = (atan(pos.y, pos.x) + PI) / PI;
	
	vec3 final_rgb = tex_color.rgb;
	
	// Use 1.0 radius to cover the full width/height from the bottom center
	bool in_semicircle = (dist <= 1.0 && pos.y <= 0.0);

	if (in_semicircle) {
		if (angle >= GREEN_MIN && angle < GREEN_MAX) {
			final_rgb = vec3(0.0, 1.0, 0.0); // Green
		} else if (angle >= YELLOW_MIN && angle < YELLOW_MAX) {
			final_rgb = vec3(1.0, 1.0, 0.0); // Yellow
		} else if (angle >= RED_MIN && angle < RED_MAX) {
			final_rgb = vec3(1.0, 0.0, 0.0); // Red
		} else {
			final_rgb = vec3(1.0, 1.0, 1.0); // Outside
		}
		
		COLOR = vec4(final_rgb, tex_color.a);
	} else {
		COLOR = tex_color;
	}
}