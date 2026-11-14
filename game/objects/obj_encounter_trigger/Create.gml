/// obj_encounter_trigger : Create
/// Starts one battle when the player walks onto it. Do NOT parent this to obj_solid.
/// Override per instance in Instance Creation Code, e.g.:
///     enemy_id = "fallen_knight";
///     encounter_id = "zone01_test_knight";
/// enemy_id must match scr_get_enemy_data(); encounter_id must be unique (used to remember victories).
enemy_id = "bandit";
encounter_id = "zone01_test_bandit";

// Only fires after the player has been seen OFF the trigger, so returning onto it never re-fires.
armed = false;
visible = DEBUG_SHOW_TRIGGERS;
