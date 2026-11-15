/// scr_game_state — global runtime state shared by exploration, dialogue, and battle.
/// Everything lives in one struct, global.game, so the hand-off between rooms is explicit.

/// Create global.game once. Safe to call any number of times.
function scr_game_state_init() {
    if (variable_global_exists("game") && is_struct(global.game)) return;
    var _ps = scr_party_state_create();
    global.game = {
        frame: 0,                     // incremented by obj_game_controller : Begin Step
        input_block_until_frame: -1,  // overworld input ignored while frame <= this
        dialogue_open: false,
        menu_open: false,             // inventory overlay (I / Tab); locks overworld input
        battle_active: false,         // true from encounter start until the battle hands control back
        transition_active: false,     // true while returning from battle, until Room Start restores the player
        pending_battle: undefined,    // { enemy_id, encounter_id } set by scr_encounter_start
        return_point: undefined,      // { room_id, px, py, facing_x, facing_y }
        last_battle_result: undefined,// "victory" | "defeat" | "escape" | "error"
        last_defeat_penalty: undefined, // { gold_lost, xp_lost } set by scr_apply_defeat_penalty
        cleared_encounters: {},       // encounter_id -> true after a victory
        bestiary: {},                 // enemy_id -> { seen, defeated } (scr_bestiary; saved from schema v3)
        roster: _ps.roster,           // five permanent members (Kael, Lyra, Caelan, Sera, Taren Holt)
        party: _ps.party,             // active battle slots (1–4); this is what battle uses
        reserve: _ps.reserve,         // 0–1 benched member
        xp: 0,                        // mirror of party[0].xp (Kael) for the debugger; each member has their own xp/level
        gold: 0,                      // shared party currency
        inventory: [],                // [{ item_id, name, qty, key_item }]
        flags: {},                    // story flags, e.g. flag_parchment_found (see scr_flag_get / scr_flag_set)
        dialogue_queue: [],           // pending dialogue node IDs (ZONE_PLACE_NN) for scr_dialogue_play
        dialogue_on_finish: undefined,// callback after the queue empties
        pending_post_dialogue: undefined, // node IDs to play after returning from a victory
        pending_ashbound_encounter_id: "",
        ashbound_rare_chance: ASHBOUND_HUNTER_RARE_CHANCE, // debugger-tunable rare roll
        playtime_frames: 0,           // increments off the title; stored in seconds in the save
        pending_load: undefined,      // { room_id, px, py, facing_x, facing_y } applied in Room Start after a load
        random_encounters_enabled: RANDOM_ENCOUNTERS_ENABLED, // debugger toggle; also requires the macro
        encounter_step_remainder: 0,  // leftover pixels toward the next encounter step
        encounter_steps_until: 0,     // steps remaining until a random fight (0 = roll a new interval)
        encounter_grace_steps: 0      // remaining safe steps after battle or room entry
    };
    scr_party_refresh_equipment();
}

/// True when the overworld (player movement, interaction, encounter triggers) must not act.
function scr_input_locked() {
    scr_game_state_init();
    var _g = global.game;
    var _menu = variable_struct_exists(_g, "menu_open") && _g.menu_open;
    return _g.dialogue_open || _menu || _g.battle_active || _g.transition_active || (_g.frame <= _g.input_block_until_frame);
}

/// Ignore overworld input for the current frame plus `_frames` more. Used after closing
/// dialogue or returning from battle so one key press cannot trigger two things.
function scr_input_block(_frames = 1) {
    scr_game_state_init();
    global.game.input_block_until_frame = global.game.frame + _frames;
}
