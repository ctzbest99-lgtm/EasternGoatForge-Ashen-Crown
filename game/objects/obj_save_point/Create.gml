/// obj_save_point : Create
/// World save shrine / ledger. Parent: obj_interactable (solid). Facing + confirm opens the save panel.
event_inherited();
speaker_name = "";
dialogue_lines = [];
script_id = "SAVE_POINT";
var _spr = scr_menu_sprite_save_point();
if (scr_sprite_is_valid(_spr)) sprite_index = _spr;

interact = function() {
    if (scr_input_locked()) return;
    if (room == BATTLE_ROOM) return;
    scr_save_menu_open("save", true);
};
