/// obj_save_menu : Create
/// Save or load slot panel. Opened from a save point, the CV_END prompt, DEBUG F5, or (load) the title.
scr_game_state_init();
scr_ui_init();
global.game.menu_open = true;
mode = "save";        // "save" | "load"
need_prompt = true;   // "Save your progress?" yes/no first
prompt_index = 0;     // 0 Yes, 1 No
index = 0;
message = "";
slots = [];
refresh_slots = true;
confirming_overwrite = false;
