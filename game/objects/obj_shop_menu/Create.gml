/// obj_shop_menu : Create
/// Buy / Sell / Exit overlay. Opened after a shopkeeper's dialogue via scr_shop_open.
scr_game_state_init();
scr_ui_init();
global.game.menu_open = true;
shop_id = "";
shop = undefined;
mode = "root";   // "root" | "list" | "qty"
tab = 0;         // 0 Buy, 1 Sell, 2 Exit (root only)
index = 0;
qty = 1;
scroll = 0;
message = "";
