/// obj_status_menu : Create
/// Keyboard-driven party status panel. C opens it, UP/DOWN select a member, ESC or C closes it.
/// Opening locks exploration input the same way a battle does, and closing restores exactly the
/// instances it changed.
scr_game_ensure_globals();
if (!variable_global_exists("menu_open")) global.menu_open = false;

menu = scr_status_menu_create();
locked_players = [];
