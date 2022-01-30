shader_type canvas_item;

uniform sampler2D color_swap_map;
uniform vec4      color : hint_color;

void fragment()
{
	vec4 color_ = color;
	////////////////////////////////////////////////////////////////////////////
	// color swap

	color_.rgb = texture(color_swap_map, vec2(color.r * 16.0, 0.0)).rgb;

    ////////////////////////////////////////////////////////////////////////////

	COLOR = color_;
}
