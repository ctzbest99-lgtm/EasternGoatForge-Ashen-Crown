/// obj_inventory_menu : Step
var _inv = global.game.inventory;
var _n = array_length(_inv);
if (scr_input_up_pressed() && _n > 0) index = (index - 1 + _n) mod _n;
if (scr_input_down_pressed() && _n > 0) index = (index + 1) mod _n;
if (index >= _n) index = max(0, _n - 1);

if (scr_input_cancel_pressed() || keyboard_check_pressed(ord("I")) || keyboard_check_pressed(vk_tab)) {
    instance_destroy();
}
