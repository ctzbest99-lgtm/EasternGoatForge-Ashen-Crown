/// obj_game_controller : Begin Step
/// Frame counter used by scr_input_block / scr_input_locked and dialogue open-frame guards.
global.game.frame += 1;
scr_dialogue_try_advance_queue();


// Inventory overlay (I or Tab). Opening is blocked while dialogue / battle / a menu is already up;
// closing is handled here so I still works while menu_open is true.
var _title = asset_get_index("rm_title");
var _on_title = (_title != -1 && room == _title);
if (!_on_title && room != BATTLE_ROOM && (keyboard_check_pressed(ord("I")) || keyboard_check_pressed(vk_tab))) {
    if (instance_exists(obj_inventory_menu)) {
        instance_destroy(obj_inventory_menu);
    } else if (!scr_input_locked()) {
        var _o = asset_get_index("obj_inventory_menu");
        if (_o != -1) instance_create_depth(0, 0, -100000, _o);
    }
}
