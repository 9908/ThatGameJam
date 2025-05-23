shader_type canvas_item;

uniform sampler2D gradient_texture;

// The world height currently visible on screen
uniform float viewport_height = 720.0;

// Fraction of the gradient that represents the current visible world (0 < x ≤ 1)
uniform float visible_range = 0.2;

// Camera Y position in world coordinates
uniform float camera_y = 0.0;

uniform float offset_y = 0.0;

void fragment() {
    float world_y = VERTEX.y + offset_y;

    // The world Y coordinate at the top of the screen
    float world_top = camera_y - viewport_height * 0.5;

    // Map this pixel’s Y to a [0..1] position within the visible world area
    float world_relative = (world_y - world_top) / viewport_height;

    // Now map this to a position in the gradient, inside the visible_range
    float grad_t = clamp(world_relative * visible_range, 0.0, 1.0);

    vec4 grad_color = texture(gradient_texture, vec2(grad_t, 0.5));
    COLOR *= grad_color;
}
