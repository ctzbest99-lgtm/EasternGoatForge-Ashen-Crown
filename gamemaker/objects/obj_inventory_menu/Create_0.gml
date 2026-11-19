/// obj_inventory_menu : Create
scr_game_state_init();
scr_ui_init();
global.game.menu_open = true;
opened_frame = global.game.frame;
tab = 0;            // 0 Items, 1 Equip, 2 Key, 3 Materials
mode = "list";      // "list" | "target" | "slots" | "pick"
index = 0;
scroll = 0;
target_index = 0;
member_index = 0;
slot_index = 0;
cand_index = 0;
cand_scroll = 0;
message = "";
