/// obj_shop_menu : Create
scr_game_state_init();
scr_ui_init();
global.game.menu_open = true;
shop_id = "";
shop = undefined;
mode = "list";   // "list" | "qty"
tab = 0;         // 0 Buy, 1 Sell, 2 Exit
index = 0;
qty = 1;
scroll = 0;
message = "";
buzz_t = 0;
