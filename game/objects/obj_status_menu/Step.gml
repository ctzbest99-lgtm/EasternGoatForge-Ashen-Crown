/// obj_status_menu : Step
/// Every transition is on keyboard_check_pressed, so holding a key cannot open, close, scroll or use
/// an item twice.
if (!variable_global_exists("menu_open")) global.menu_open = false;

if (!menu.open) {
    if (keyboard_check_pressed(ord("C")) && scr_status_menu_can_open(global.battle_active, menu.open)) {
        scr_status_menu_open(menu);
        global.menu_open = true;
        locked_players = [];
        var _player_obj = asset_get_index("obj_player");
        if (_player_obj >= 0) {
            var _count = instance_number(_player_obj);
            for (var _i = 0; _i < _count; _i++) {
                var _p = instance_find(_player_obj, _i);
                if (_p.input_enabled) {
                    _p.input_enabled = false;
                    array_push(locked_players, _p);
                }
            }
        }
    }
    exit;
}

var _party = scr_party_ensure_global();
var _up = keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"));
var _down = keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"));
var _confirm = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space);
var _back = keyboard_check_pressed(vk_escape);
var _close_all = keyboard_check_pressed(ord("C"));

if (menu.mode == STATUS_VIEW.ITEM) {
    var _stacks = array_length(scr_inventory_usable(scr_status_inventory(_party)));
    if (_back) {
        /// ESC steps back one level: item list, then the panel itself.
        scr_status_menu_close_items(menu);
        exit;
    }
    if (_up) scr_status_menu_move_item(menu, -1, _stacks);
    if (_down) scr_status_menu_move_item(menu, 1, _stacks);
    if (_confirm) scr_status_menu_use_item(menu, _party, scr_status_menu_member(_party, menu));
} else if (menu.mode == STATUS_VIEW.EQUIP) {
    var _carried = array_length(scr_inventory_equipment(scr_status_inventory(_party)));
    if (_back) {
        /// ESC steps back one level: equip list, member list, then the panel.
        scr_status_menu_close_equip(menu);
        exit;
    }
    if (_up) scr_status_menu_move_equip(menu, -1, _carried);
    if (_down) scr_status_menu_move_equip(menu, 1, _carried);
    if (_confirm) scr_status_menu_equip_selected(menu, _party, scr_status_menu_member(_party, menu));
} else {
    if (_up) scr_status_menu_move(menu, -1, array_length(_party.members));
    if (_down) scr_status_menu_move(menu, 1, array_length(_party.members));
    if (_confirm) scr_status_menu_open_items(menu, _party);
    if (keyboard_check_pressed(ord("E"))) scr_status_menu_open_equip(menu, _party);
    if (_back) _close_all = true;
}

if (!_close_all) exit;

scr_status_menu_close(menu);
global.menu_open = false;
/// Restore only what was taken, so a player already locked by something else stays locked.
for (var _i = 0; _i < array_length(locked_players); _i++) {
    if (instance_exists(locked_players[_i])) locked_players[_i].input_enabled = true;
}
