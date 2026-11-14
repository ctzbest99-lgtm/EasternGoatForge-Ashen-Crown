/// scr_game_state — global runtime state shared by exploration, dialogue, and battle.
/// Everything lives in one struct, global.game, so the hand-off between rooms is explicit.

/// Create global.game once. Safe to call any number of times.
function scr_game_state_init() {
    if (variable_global_exists("game") && is_struct(global.game)) return;
    global.game = {
        frame: 0,                     // incremented by obj_game_controller : Begin Step
        input_block_until_frame: -1,  // overworld input ignored while frame <= this
        dialogue_open: false,
        battle_active: false,         // true from encounter start until the battle hands control back
        transition_active: false,     // true while returning from battle, until Room Start restores the player
        pending_battle: undefined,    // { enemy_id, encounter_id } set by scr_encounter_start
        return_point: undefined,      // { room_id, px, py, facing_x, facing_y }
        last_battle_result: undefined,// "victory" | "defeat" | "error"
        last_defeat_penalty: undefined, // { gold_lost, xp_lost } set by scr_apply_defeat_penalty
        cleared_encounters: {},       // encounter_id -> true after a victory
        party: scr_party_create_default(),
        xp: 0,                        // mirror of party[0].xp (Kael) for the debugger; each member has their own xp/level
        gold: 0,                      // shared party currency
        inventory: [],                // placeholder item list [{ item_id, name, qty }]; menus are roadmap step 5
        random_encounters_enabled: RANDOM_ENCOUNTERS_ENABLED, // debugger toggle; also requires the macro
        encounter_step_remainder: 0,  // leftover pixels toward the next encounter step
        encounter_steps_until: 0,     // steps remaining until a random fight (0 = roll a new interval)
        encounter_grace_steps: 0      // remaining safe steps after battle or room entry
    };
}

/// True when the overworld (player movement, interaction, encounter triggers) must not act.
function scr_input_locked() {
    scr_game_state_init();
    var _g = global.game;
    return _g.dialogue_open || _g.battle_active || _g.transition_active || (_g.frame <= _g.input_block_until_frame);
}

/// Ignore overworld input for the current frame plus `_frames` more. Used after closing
/// dialogue or returning from battle so one key press cannot trigger two things.
function scr_input_block(_frames = 1) {
    scr_game_state_init();
    global.game.input_block_until_frame = global.game.frame + _frames;
}
