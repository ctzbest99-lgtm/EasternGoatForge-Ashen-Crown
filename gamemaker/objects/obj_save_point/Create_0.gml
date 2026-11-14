/// obj_save_point : Create
/// Ember-crowned crystal. Parent: obj_interactable. Idle loop 8 fps; activate plays once at 12 fps, then the save menu opens.
event_inherited();
speaker_name = "";
dialogue_lines = [];
script_id = "SAVE_POINT";
activating = false;
var _spr = scr_menu_sprite_save_point_idle();
if (scr_sprite_is_valid(_spr)) {
    sprite_index = _spr;
    image_xscale = 1;
    image_yscale = 1;
}
var _fps = max(1, game_get_speed(gamespeed_fps));
image_speed = 8 / _fps;
image_index = 0;

interact = function() {
    if (scr_input_locked()) return;
    if (room == BATTLE_ROOM) return;
    if (activating) return;
    var _act = scr_menu_sprite_save_point_activate();
    if (scr_sprite_is_valid(_act)) {
        activating = true;
        sprite_index = _act;
        image_index = 0;
        image_speed = 12 / max(1, game_get_speed(gamespeed_fps));
    } else {
        scr_save_menu_open("save", false);
    }
};
