/// obj_debug_menu : Create
/// Debug-only overlay for testing. F10 opens/closes it.
/// Spawn mode: UP/DOWN pick an enemy from the database, ENTER spawns it in front of the player.
/// Teleport mode: type x,y then ENTER to move the player there.
visible_debug = false;
debug_mode = 0; // 0 = spawn enemy, 1 = teleport
selected = 0;
message = "";
enemy_ids = scr_get_enemy_ids();
