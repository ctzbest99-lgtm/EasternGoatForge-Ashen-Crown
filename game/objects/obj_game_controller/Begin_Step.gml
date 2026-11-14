/// obj_game_controller : Begin Step
/// Frame counter used by scr_input_block / scr_input_locked and dialogue open-frame guards.
global.game.frame += 1;
scr_save_tick_playtime();
scr_dialogue_try_advance_queue();
scr_ch2_tick(); // Chapter 2 wake-up at the Crownveil door (CV_WAKE)


// Inventory overlay (I or Tab). Opening is blocked while dialogue / battle / a menu is already up;
// closing is handled here so I still works while menu_open is true.
var _title = asset_get_index("rm_title");
var _on_title = (_title != -1 && room == _title);
if (!_on_title && room != BATTLE_ROOM && (keyboard_check_pressed(ord("I")) || keyboard_check_pressed(vk_tab))) {
    var _shop = asset_get_index("obj_shop_menu");
    var _save = asset_get_index("obj_save_menu");
    var _other_menu = (_shop != -1 && instance_exists(_shop)) || (_save != -1 && instance_exists(_save));
    if (instance_exists(obj_inventory_menu)) {
        instance_destroy(obj_inventory_menu);
    } else if (!_other_menu && !scr_input_locked()) {
        var _o = asset_get_index("obj_inventory_menu");
        if (_o != -1) instance_create_depth(0, 0, -100000, _o);
    }
}

// Debug: F5 opens the save panel from the overworld. Off unless DEBUG_SAVE_ANYWHERE is true.
if (DEBUG_SAVE_ANYWHERE && !_on_title && room != BATTLE_ROOM && keyboard_check_pressed(vk_f5)) {
    if (!scr_input_locked()) scr_save_menu_open("save", false);
}
