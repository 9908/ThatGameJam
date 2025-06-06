shader_type canvas_item;
render_mode unshaded;

uniform float cutoff : hint_range(0.0, 1.0);
uniform float smooth_size : hint_range(0.0, 1.0);
uniform sampler2D mask : source_color;

void fragment() {
    vec4 base_color = texture(TEXTURE, UV);
    float value = texture(mask, UV).r;

    float alpha = smoothstep(cutoff, cutoff + smooth_size, value * (1.0 - smooth_size) + smooth_size);

    vec4 modulated_color = base_color * COLOR; // COLOR is the modulate from the node
    modulated_color.a *= alpha;

    COLOR = modulated_color;
}
