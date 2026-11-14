/// obj_battle_controller : Create
/// Battle prototype in a dedicated room (rm_battle_test): one enemy, Attack/Guard, explicit states.
/// The party is an array of 1–PARTY_MAX_SIZE members (currently Kael only).
scr_game_state_init();
scr_ui_init();

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

dmg_pops = [];
battle_fx = [];
cursor_y = 140;
phase_from = 1;
phase_want = 1;
phase_next = 1;

// Which enemy? Comes from scr_encounter_start(). Falls back to "bandit" if the room is run directly.
var _pending = global.game.pending_battle;
var _enemy_id = is_struct(_pending) ? _pending.enemy_id : "bandit";
if (!is_struct(_pending)) show_debug_message("[battle] No pending battle; using 'bandit' for a standalone room test.");

battle_area = "forest";
if (is_struct(_pending) && variable_struct_exists(_pending, "area") && is_string(_pending.area) && _pending.area != "") {
    battle_area = _pending.area;
} else {
    battle_area = scr_ch1_battle_area(_enemy_id, is_struct(_pending) ? _pending.encounter_id : "");
}
battle_bg = scr_ch1_battle_bg(battle_area);

enemy = scr_actor_from_enemy_data(scr_get_enemy_data(_enemy_id));
if (is_undefined(enemy)) {
    show_debug_message("[battle] Unknown enemy id: " + string(_enemy_id));
    state = BATTLE_STATE.ERROR;
} else if (enemy.actor_id == "blackguard") {
    enemy.phase = 1;
    enemy.base_attack = enemy.attack;
    enemy.base_defense = enemy.defense;
    enemy.is_guarding = false;
    scr_blackguard_apply_phase(enemy, 1);
} else {
    enemy.phase = 1;
    enemy.is_guarding = false;
}

// Visuals: enemy faces right (xscale 1), party faces left (xscale -1). Missing sprites are ok.
var _ephase = (is_struct(enemy) && variable_struct_exists(enemy, "phase")) ? enemy.phase : 1;
enemy_vis = is_struct(enemy) ? scr_battle_vis_create(enemy.actor_id, 1, _ephase) : undefined;
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

/// Begin an attack (or special) clip. Damage is applied when the hit frame is reached
/// (or immediately if the attack sprite is missing). Confirm skips the rest of the clip.
begin_attack_anim = function(_attacker_vis, _target_vis, _hit, _text, _next, _anim = "attack") {
    anim_attacker_vis = _attacker_vis;
    anim_target_vis = _target_vis;
    anim_hit = _hit;
    anim_message = _text;
    anim_next_state = _next;
    anim_hit_applied = false;
    scr_battle_vis_play(_attacker_vis, _anim);
    state = BATTLE_STATE.ANIMATING;
};

apply_pending_hit = function() {
    if (anim_hit_applied) return;
    anim_hit_applied = true;
    if (!is_struct(anim_hit)) return;

    if (anim_hit.kind == "player_attack" && is_struct(enemy)) {
        var _dmg = anim_hit.damage;
        if (variable_struct_exists(enemy, "is_guarding") && enemy.is_guarding) {
            _dmg = scr_apply_guard(_dmg, true);
            enemy.is_guarding = false;
            anim_message = anim_message + " (guarded)";
        }
        enemy.hp = scr_apply_damage(enemy.hp, enemy.max_hp, _dmg);
        var _ef = scr_battle_layout_enemy_feet();
        scr_battle_pop_add(dmg_pops, _ef.x, _ef.y, _dmg, "dmg");
        if (enemy.hp <= 0 && !enemy.xp_credited) {
            // Credit at the actual hit, while living participants are still standing.
            // Banked pending_xp is applied at victory only.
            scr_party_credit_enemy_xp(enemy.xp_reward);
            enemy.xp_credited = true;
        }
        if (is_struct(anim_target_vis)) {
            if (enemy.hp <= 0 && anim_target_vis.kind == "blackguard") anim_target_vis.phase = 3;
            scr_battle_vis_play(anim_target_vis, (enemy.hp <= 0) ? "death" : "hurt");
        }
    } else if (anim_hit.kind == "enemy_attack") {
        var _target = party[anim_hit.party_index];
        var _edmg = anim_hit.damage;
        _target.hp = scr_apply_damage(_target.hp, _target.max_hp, _edmg);
        var _pf = scr_battle_layout_party_feet(anim_hit.party_index);
        if (_edmg > 0) scr_battle_pop_add(dmg_pops, _pf.x, _pf.y, _edmg, "dmg");
        if (is_struct(anim_target_vis)) {
            if (_edmg > 0) {
                scr_battle_vis_play(anim_target_vis, (_target.hp <= 0) ? "death" : "hurt");
            }
        }
        // Visual-only specials (howl / scream / cast / guard / oath) still go back to the next state.
        if (anim_hit.kind == "enemy_attack") {
            anim_next_state = scr_party_any_alive(party) ? BATTLE_STATE.ROUND_START : BATTLE_STATE.DEFEAT;
        }
        scr_ch1_battle_spawn_special_fx(anim_hit);
    } else if (anim_hit.kind == "enemy_special") {
        scr_ch1_battle_spawn_special_fx(anim_hit);
        if (is_struct(enemy) && variable_struct_exists(anim_hit, "sets_guard") && anim_hit.sets_guard) {
            enemy.is_guarding = true;
        }
    }
};

finish_animating = function() {
    if (!anim_hit_applied) apply_pending_hit();
    if (is_struct(anim_attacker_vis) && anim_attacker_vis.anim != "hurt" && anim_attacker_vis.anim != "death" && string_pos("transition", anim_attacker_vis.anim) != 1) {
        // Do not clobber a phase-transition clip; those are handled in PHASE_SHIFT.
        if (string_pos("transition", anim_attacker_vis.anim) <= 0) {
            scr_battle_vis_play(anim_attacker_vis, "idle");
        }
    }
    if (is_struct(anim_target_vis) && anim_target_vis.anim == "hurt") {
        scr_battle_vis_play(anim_target_vis, "idle");
    }
    // Death holds the last frame. A living Blackguard may need a phase transition first.
    if (is_struct(enemy) && enemy.actor_id == "blackguard" && enemy.hp > 0) {
        var _want = scr_blackguard_phase_for_hp(enemy.hp, enemy.max_hp);
        if (_want > enemy.phase) {
            start_phase_shift(_want);
            return;
        }
    }
    queue_message(anim_message, anim_next_state);
};

start_phase_shift = function(_want) {
    phase_from = enemy.phase;
    phase_want = _want;
    phase_next = phase_from + 1;
    var _anim = (phase_next == 2) ? "transition_p1to2" : "transition_p2to3";
    if (is_struct(enemy_vis)) {
        enemy_vis.phase = phase_from;
        scr_battle_vis_play(enemy_vis, _anim);
    }
    state = BATTLE_STATE.PHASE_SHIFT;
};

finish_phase_shift = function() {
    scr_blackguard_apply_phase(enemy, phase_next);
    if (is_struct(enemy_vis)) {
        enemy_vis.phase = phase_next;
        scr_battle_vis_play(enemy_vis, "idle");
    }
    if (phase_next < phase_want) {
        start_phase_shift(phase_want);
        return;
    }
    var _line = anim_message;
    var _pl = scr_blackguard_phase_line(phase_want);
    if (_pl != "") _line = (_line == "") ? _pl : (_line + "\n" + _pl);
    queue_message(_line, anim_next_state);
};
