/// obj_interactable : Step
/// Y-sort, Tomas pallet pose, and chest open-strip hold.
depth = -y;

if (variable_instance_exists(id, "ch1_lying") && ch1_lying) {
    var _talking = false;
    if (instance_exists(obj_dialogue_box)) {
        var _box = instance_find(obj_dialogue_box, 0);
        if (_box != noone && is_string(_box.speaker_name)) {
            var _sp = string_lower(_box.speaker_name);
            if (_sp == "tomas" || _sp == "tomas varyn") _talking = true;
        }
    }
    var _want = _talking
        ? scr_sprite_index("spr_tomas_varyn_ow16_lying_awake")
        : scr_sprite_index("spr_tomas_varyn_ow16_lying_strip2");
    if (scr_sprite_is_valid(_want) && sprite_index != _want) {
        var _fx = x;
        var _fy = y;
        if (is_struct(map_marker)) { _fx = map_marker.x; _fy = map_marker.y; }
        sprite_index = _want;
        mask_index = _want;
        if (_talking) {
            image_speed = 0;
            image_index = 0;
        } else {
            var _fps = game_get_speed(gamespeed_fps);
            image_speed = (_fps > 0) ? (1.5 / _fps) : 0;
        }
        scr_ch1_place_at_feet(id, _fx, _fy);
    }
}

if (variable_instance_exists(id, "ch1_chest_opening") && ch1_chest_opening) {
    if (image_index >= sprite_get_number(sprite_index) - 1) {
        image_speed = 0;
        image_index = sprite_get_number(sprite_index) - 1;
        ch1_chest_opening = false;
        ch1_chest_open = true;
        var _iron = variable_instance_exists(id, "ch1_chest_iron") && ch1_chest_iron;
        var _open = scr_sprite_index(_iron ? "spr_chest_iron_open" : "spr_chest_wood_open");
        if (scr_sprite_is_valid(_open)) sprite_index = _open;
    }
}
