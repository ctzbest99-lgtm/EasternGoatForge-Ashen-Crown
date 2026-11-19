/// obj_inventory_menu : Clean Up
if (variable_global_exists("game") && is_struct(global.game)) global.game.menu_open = false;
scr_input_block(1); // closing must not also move, interact, or reopen the menu
