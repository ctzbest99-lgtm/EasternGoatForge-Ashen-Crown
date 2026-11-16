/// obj_shop : Step
/// Every transition is keyboard_check_pressed, so holding a key cannot buy twice. Buying is one press, one
/// unit, and scr_shop_buy re-checks the gold itself.
if (keyboard_check_pressed(vk_escape)) {
    instance_destroy();
    exit;
}

var _count = array_length(stock);
var _up = keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"));
var _down = keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"));
if (_up) scr_shop_move(shop, -1, _count);
if (_down) scr_shop_move(shop, 1, _count);

if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) {
    if (_count > 0) {
        var _result = scr_shop_buy(scr_party_ensure_global(), stock[clamp(shop.cursor, 0, _count - 1)]);
        shop.message = _result.message;
    }
}
