/// obj_save_menu : Create
scr_game_state_init();
scr_ui_init();
global.game.menu_open = true;
mode = "save";        // "save" | "load"
need_prompt = false;  // mockups go straight to the slot list
prompt_index = 1;     // overwrite defaults to No
index = 0;
message = "";
slots = [];
refresh_slots = true;
confirming_overwrite = false;
