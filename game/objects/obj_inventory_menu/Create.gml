/// obj_inventory_menu : Create
scr_game_state_init();
scr_ui_init();
global.game.menu_open = true;
mode = "list";   // "list" | "target"
index = 0;
target_index = 0;
scroll = 0;
message = "";
