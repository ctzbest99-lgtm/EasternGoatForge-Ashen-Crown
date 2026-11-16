/// obj_enemy : Create
/// Overworld encounter marker: touching the player starts an overlay battle, and a victory removes
/// this instance (obj_battle_controller's Destroy does that through source_instance).
/// Set enemy_id before creating (struct form) or leave it as Bandit for a test room.
if (!variable_instance_exists(id, "enemy_id")) enemy_id = "bandit";

enemy_data = scr_get_enemy_data(enemy_id);
if (is_undefined(enemy_data) || enemy_data == undefined) {
    show_debug_message("obj_enemy: unknown enemy id " + string(enemy_id) + ", falling back to bandit");
    enemy_id = "bandit";
    enemy_data = scr_get_enemy_data(enemy_id);
}
max_hp = enemy_data.max_hp;
hp = max_hp;
attack = enemy_data.attack;
defense = enemy_data.defense;

/// One idle frame from the matching walk sheet; the enemy does not move yet, so image_speed stays 0.
sprite_index = asset_get_index(scr_enemy_sprite_name(enemy_id));
image_speed = 0;
image_index = 0;

/// Behind the player, so the player is never hidden under an encounter marker.
depth = 1;

armed = true;
/// Defensive: any object may read this flag, including before a battle controller has ever existed.
if (!variable_global_exists("battle_active")) global.battle_active = false;
