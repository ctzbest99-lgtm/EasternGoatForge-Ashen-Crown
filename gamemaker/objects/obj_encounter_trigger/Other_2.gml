/// obj_encounter_trigger : Room Start   (Other > Room Start)
/// Runs after Instance Creation Code, so per-instance encounter_id overrides are already applied.
scr_game_state_init();
if (encounter_id != "" && variable_struct_exists(global.game.cleared_encounters, encounter_id)) {
    instance_destroy();
}
