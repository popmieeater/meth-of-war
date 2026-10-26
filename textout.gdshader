shader_type canvas_item;

uniform vec4 outline_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float outline_thickness : hint_range(0.0, 10.0) = 1.0;

void fragment() {
    vec2 size = TEXTURE_PIXEL_SIZE * outline_thickness;
    
    // Mengecek pixel tetangga (Atas, Bawah, Kiri, Kanan) secara kotak
    float alpha = texture(TEXTURE, UV).a;
    alpha = max(alpha, texture(TEXTURE, UV + vec2(0.0, -size.y)).a);
    alpha = max(alpha, texture(TEXTURE, UV + vec2(0.0, size.y)).a);
    alpha = max(alpha, texture(TEXTURE, UV + vec2(-size.x, 0.0)).a);
    alpha = max(alpha, texture(TEXTURE, UV + vec2(size.x, 0.0)).a);
    
    vec4 sprite_color = texture(TEXTURE, UV);
    
    if (sprite_color.a == 0.0 && alpha > 0.0) {
        // Jika area luar/tepi, gunakan warna outline kustom
        COLOR = outline_color;
    } else {
        // PERBAIKAN: Kalikan warna tekstur asli dengan COLOR (warna bawaan dari Inspector/Modulate)
        // Dengan begini, warna apa pun yang Anda pilih di Inspector akan langsung diaplikasikan.
        COLOR = sprite_color * COLOR;
    }
}
