/// obj_save_point : Step
event_inherited();
depth = -y;

if (activating) {
    var _n = max(1, sprite_get_number(sprite_index));
    if (image_index >= _n - 0.5) {
        image_speed = 0;
        image_index = _n - 1;
        activating = false;
        scr_save_menu_open("save", false);
        var _idle = scr_menu_sprite_save_point_idle();
        if (scr_sprite_is_valid(_idle)) {
            sprite_index = _idle;
            image_index = 0;
            image_speed = 8 / max(1, game_get_speed(gamespeed_fps));
        }
    }
}
