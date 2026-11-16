/// obj_shop : Create
/// The trade panel. Created by scr_shop_begin through obj_merchant, never placed by hand. It locks
/// exploration input and restores exactly the instances it locked, the same way the dialogue box does.
scr_game_ensure_globals();
if (!variable_global_exists("shop_open")) global.shop_open = false;

shop = scr_shop_create();
shop.open = true;
shop.message = "Speak up, traveller.";
stock = scr_shop_stock();
locked_players = [];

global.shop_open = true;

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
