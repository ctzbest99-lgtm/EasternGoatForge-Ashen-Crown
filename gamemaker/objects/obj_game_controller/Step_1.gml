/// obj_game_controller : Begin Step
/// Frame counter used by scr_input_block / scr_input_locked and dialogue open-frame guards.
global.game.frame += 1;
scr_save_tick_playtime();
scr_dialogue_try_advance_queue();
scr_ch1_quest_tick(); // Chapter 1 Find Mira stages (flag backfill, position, room)
scr_ch2_tick(); // Chapter 2 wake-up at the Crownveil door (CV_WAKE)
scr_ch3_tick(); // Chapter 3 (no per-frame beats yet)
scr_ch4_tick(); // Chapter 4 (no per-frame beats yet)
scr_ch5_tick(); // Chapter 5 (no per-frame beats yet)
scr_ch6_tick(); // Chapter 6 (the burn-line boss gate)
scr_ch7_tick(); // Chapter 7 (the Matriarch gate, the chapter handoff)
scr_ch8_tick(); // Chapter 8 (the Warden gate, the pendant scene)
scr_ch10_tick(); // Chapter 10 (the Barrow Warden gate and retry)
scr_ch11_tick(); // Chapter 11 (the King gate and the seal choice)


// Adventure menu overlay (I or Tab). Opening is blocked while dialogue / battle / a menu is
// already up; closing is handled here so I still works while menu_open is true.
var _title = asset_get_index("rm_title");
var _on_title = (_title != -1 && room == _title);
if (!_on_title && room != BATTLE_ROOM && scr_input_menu_pressed()) {
    var _shop = asset_get_index("obj_shop_menu");
    var _save = asset_get_index("obj_save_menu");
    var _adv = asset_get_index("obj_adventure_menu");
    var _other_menu = (_shop != -1 && instance_exists(_shop)) || (_save != -1 && instance_exists(_save))
        || (_adv != -1 && instance_exists(_adv));
    if (instance_exists(obj_inventory_menu)) {
        instance_destroy(obj_inventory_menu);
    } else if (_adv != -1 && instance_exists(_adv)) {
        instance_destroy(_adv);
    } else if (!_other_menu && !scr_input_locked()) {
        // The Adventure menu is the field-menu shell: Items / Equip / Party Order / Status / Bestiary.
        if (_adv != -1) instance_create_depth(0, 0, -100000, _adv);
    }
}

// Debug: F5 opens the save panel from the overworld. Off unless DEBUG_SAVE_ANYWHERE is true.
if (DEBUG_SAVE_ANYWHERE && !_on_title && room != BATTLE_ROOM && keyboard_check_pressed(vk_f5)) {
    if (!scr_input_locked()) scr_save_menu_open("save", false);
}

// Debug: F6 runs the sanitized v1-v4 save-migration regression. Off unless DEBUG_SAVE_SELFTEST is true.
if (DEBUG_SAVE_SELFTEST && !_on_title && room != BATTLE_ROOM && keyboard_check_pressed(vk_f6)) {
    var _save_test = scr_save_migration_test();
    if (!scr_input_locked()) scr_dialogue_open(_save_test.lines, "SYSTEM");
}
