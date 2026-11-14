/// obj_inventory_menu : Clean Up
if (variable_global_exists("game") && is_struct(global.game)) global.game.menu_open = false;
