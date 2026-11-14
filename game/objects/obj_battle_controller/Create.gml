/// obj_battle_controller : Create
/// Battle prototype in a dedicated room (rm_battle_test): one enemy, Attack/Guard, explicit states.
/// The party is an array of 1–PARTY_MAX_SIZE members (currently Kael only).
scr_game_state_init();

party = global.game.party; // structs are shared by reference, so HP changes persist to the overworld
scr_party_clear_guard(party);

command_options = ["Attack", "Guard"];
command_index = 0;
actor_index = -1;       // party member currently choosing a command
queued_actions = [];    // { actor_index, command } for this round
action_index = 0;       // next queued action to resolve

state = BATTLE_STATE.INTRO;
next_state = BATTLE_STATE.INTRO;
message = "";
battle_result = "";
rewards_granted = false;
finished = false;
level_ups = [];         // queued level-up structs from scr_party_grant_xp
level_up_index = 0;

// Which enemy? Comes from scr_encounter_start(). Falls back to "bandit" if the room is run directly.
var _pending = global.game.pending_battle;
var _enemy_id = is_struct(_pending) ? _pending.enemy_id : "bandit";
if (!is_struct(_pending)) show_debug_message("[battle] No pending battle; using 'bandit' for a standalone room test.");

enemy = scr_actor_from_enemy_data(scr_get_enemy_data(_enemy_id));
if (is_undefined(enemy)) {
    show_debug_message("[battle] Unknown enemy id: " + string(_enemy_id));
    state = BATTLE_STATE.ERROR;
}

/// Show a message, wait for confirm, then enter _next.
queue_message = function(_text, _next) {
    message = _text;
    next_state = _next;
    state = BATTLE_STATE.MESSAGE;
};
