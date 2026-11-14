/// obj_battle_controller : Create
/// Battle prototype in a dedicated room (rm_battle_test): one enemy, Attack/Guard, explicit states.
/// The party is an array of 1–PARTY_MAX_SIZE members (currently Kael only).
scr_game_state_init();

party = global.game.party; // structs are shared by reference, so HP changes persist to the overworld
scr_party_clear_guard(party);
scr_party_clear_participation();

command_options = scr_party_battle_commands();
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

// Pending hit used by BATTLE_STATE.ANIMATING (applied at the attack's hit frame).
anim_message = "";
anim_next_state = BATTLE_STATE.ROUND_START;
anim_hit_applied = true;
anim_attacker_vis = undefined;
anim_target_vis = undefined;
anim_hit = undefined; // { kind, damage, is_guarding, target_is_enemy, party_index }

// Which enemy? Comes from scr_encounter_start(). Falls back to "bandit" if the room is run directly.
var _pending = global.game.pending_battle;
var _enemy_id = is_struct(_pending) ? _pending.enemy_id : "bandit";
if (!is_struct(_pending)) show_debug_message("[battle] No pending battle; using 'bandit' for a standalone room test.");

enemy = scr_actor_from_enemy_data(scr_get_enemy_data(_enemy_id));
if (is_undefined(enemy)) {
    show_debug_message("[battle] Unknown enemy id: " + string(_enemy_id));
    state = BATTLE_STATE.ERROR;
}

// Visuals: enemy faces right (xscale 1), party faces left (xscale -1). Missing sprites are ok.
enemy_vis = is_struct(enemy) ? scr_battle_vis_create(enemy.actor_id, 1) : undefined;
party_vis = [];
var _i;
for (_i = 0; _i < array_length(party); _i++) {
    array_push(party_vis, scr_battle_vis_create(party[_i].actor_id, -1));
}

/// Show a message, wait for confirm, then enter _next.
queue_message = function(_text, _next) {
    message = _text;
    next_state = _next;
    state = BATTLE_STATE.MESSAGE;
};

/// Begin an attack clip. Damage is applied when the hit frame is reached (or immediately
/// if the attack sprite is missing). Confirm skips the rest of the clip.
begin_attack_anim = function(_attacker_vis, _target_vis, _hit, _text, _next) {
    anim_attacker_vis = _attacker_vis;
    anim_target_vis = _target_vis;
    anim_hit = _hit;
    anim_message = _text;
    anim_next_state = _next;
    anim_hit_applied = false;
    scr_battle_vis_play(_attacker_vis, "attack");
    state = BATTLE_STATE.ANIMATING;
};

apply_pending_hit = function() {
    if (anim_hit_applied) return;
    anim_hit_applied = true;
    if (!is_struct(anim_hit)) return;

    if (anim_hit.kind == "player_attack" && is_struct(enemy)) {
        enemy.hp = scr_apply_damage(enemy.hp, enemy.max_hp, anim_hit.damage);
        if (enemy.hp <= 0 && !enemy.xp_credited) {
            // Credit at the actual hit, while living participants are still standing.
            // Banked pending_xp is applied at victory only.
            scr_party_credit_enemy_xp(enemy.xp_reward);
            enemy.xp_credited = true;
        }
        if (is_struct(anim_target_vis)) {
            scr_battle_vis_play(anim_target_vis, (enemy.hp <= 0) ? "death" : "hurt");
        }
    } else if (anim_hit.kind == "enemy_attack") {
        var _target = party[anim_hit.party_index];
        _target.hp = scr_apply_damage(_target.hp, _target.max_hp, anim_hit.damage);
        if (is_struct(anim_target_vis)) {
            scr_battle_vis_play(anim_target_vis, (_target.hp <= 0) ? "death" : "hurt");
        }
        anim_next_state = scr_party_any_alive(party) ? BATTLE_STATE.ROUND_START : BATTLE_STATE.DEFEAT;
    }
};

finish_animating = function() {
    if (!anim_hit_applied) apply_pending_hit();
    if (is_struct(anim_attacker_vis) && anim_attacker_vis.anim == "attack") {
        scr_battle_vis_play(anim_attacker_vis, "idle");
    }
    if (is_struct(anim_target_vis) && anim_target_vis.anim == "hurt") {
        scr_battle_vis_play(anim_target_vis, "idle");
    }
    // Death holds the last frame.
    queue_message(anim_message, anim_next_state);
};
