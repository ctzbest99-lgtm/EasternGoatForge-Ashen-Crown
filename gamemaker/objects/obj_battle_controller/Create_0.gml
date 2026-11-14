/// obj_battle_controller : Create
/// FF1-style battle in a dedicated room (rm_battle_test). feature/battle-upgrade:
/// 1–3 regular enemies or a boss plus adds, Attack / Skill / Guard / Swap, SPD turn order,
/// MP skills, timed buffs, elemental weakness, and weighted enemy AI (scr_battle_system,
/// scr_skill_data, scr_enemy_database). The party is global.game.party (1–PARTY_ACTIVE_MAX).
scr_game_state_init();
scr_ui_init();

party = global.game.party; // structs are shared by reference, so HP / MP changes persist to the overworld
scr_party_clear_guard(party);
scr_party_clear_participation();
scr_battle_clear_party_battle_state(false); // fresh buffs / statuses for this battle (no MP regen)

command_options = ["Attack", "Guard"];
command_index = 0;
actor_index = -1;       // party member currently choosing a command
queued_actions = [];    // { actor_index, command, skill_id, target_side, target_index } for this round
pending_command = "";   // "Attack" | "Skill" while a skill or target is being chosen
pending_skill = "";
skill_list = [];        // active skill ids for the SKILL_SELECT window
skill_index = 0;
target_side = "enemy";  // "enemy" | "party" during TARGET_SELECT
target_index = 0;

turn_order = [];        // [{ side: "party" | "enemy", index, action, key }] sorted by SPD (+ tiebreak)
turn_pos = 0;
current_turn = undefined;

state = BATTLE_STATE.INTRO;
next_state = BATTLE_STATE.INTRO;
message = "";
battle_result = "";
rewards_granted = false;
finished = false;
level_ups = [];         // queued level-up structs from scr_party_apply_pending_xp
level_up_index = 0;
victory_xp = 0;
victory_gold = 0;

// Pending action used by BATTLE_STATE.ANIMATING (applied at the attack's hit frame).
anim_message = "";
anim_next_state = BATTLE_STATE.TURN_NEXT;
anim_hit_applied = true;
anim_fx_done = true;
anim_attacker_vis = undefined;
anim_target_vises = [];
anim_hit = undefined;   // see run_skill()

dmg_pops = [];
battle_fx = [];
phase_enemy = -1;       // Blackguard index during PHASE_SHIFT
phase_from = 1;
phase_want = 1;
phase_next = 1;
stance_enemy = -1;      // boss index during STANCE_SHIFT

// ---------------------------------------------------------------------------------------------
// Which enemies? scr_encounter_start() stores enemy_ids (boss first) in pending_battle.
// Falls back to a single "bandit" if the room is run directly.
var _pending = global.game.pending_battle;
var _ids = [];
var _boss_index = -1;
var _lead_id = "bandit";
if (is_struct(_pending)) {
    _lead_id = _pending.enemy_id;
    if (variable_struct_exists(_pending, "enemy_ids") && is_array(_pending.enemy_ids) && array_length(_pending.enemy_ids) > 0) {
        _ids = _pending.enemy_ids;
        _boss_index = variable_struct_exists(_pending, "boss_index") ? _pending.boss_index : -1;
    } else {
        var _res = scr_encounter_resolve_ids(_pending.enemy_id);
        _ids = _res.ids;
        _boss_index = _res.boss_index;
    }
} else {
    show_debug_message("[battle] No pending battle; using 'bandit' for a standalone room test.");
    var _res0 = scr_encounter_resolve_ids("bandit");
    _ids = _res0.ids;
}

battle_area = "forest";
if (is_struct(_pending) && variable_struct_exists(_pending, "area") && is_string(_pending.area) && _pending.area != "") {
    battle_area = _pending.area;
} else {
    battle_area = scr_ch1_battle_area(_lead_id, is_struct(_pending) ? _pending.encounter_id : "");
}
battle_bg = scr_ch1_battle_bg(battle_area);

enemies = [];
var _i;
for (_i = 0; _i < array_length(_ids); _i++) {
    var _actor = scr_actor_from_enemy_data(scr_get_enemy_data(_ids[_i]));
    if (!is_struct(_actor)) {
        show_debug_message("[battle] Unknown enemy id: " + string(_ids[_i]));
        continue;
    }
    _actor.is_add = (_boss_index == 0 && _i > 0);
    if (_actor.actor_id == "blackguard") {
        _actor.base_attack = _actor.attack;
        _actor.base_defense = _actor.defense;
        scr_blackguard_apply_phase(_actor, 1);
    }
    array_push(enemies, _actor);
}
boss_index = (_boss_index == 0 && array_length(enemies) > 0 && enemies[0].is_boss) ? 0 : -1;
enemy = (array_length(enemies) > 0) ? enemies[0] : undefined; // lead enemy (kept for older helpers)
if (array_length(enemies) == 0) state = BATTLE_STATE.ERROR;

scr_battle_label_duplicates(enemies);
var _formation = scr_battle_formation(array_length(enemies), boss_index);
enemy_vis = [];
for (_i = 0; _i < array_length(enemies); _i++) {
    enemies[_i].slot = _i;
    enemies[_i].feet = _formation[min(_i, array_length(_formation) - 1)];
    array_push(enemy_vis, scr_battle_vis_create(enemies[_i].actor_id, 1, enemies[_i].phase));
}

// Party battlers face left (xscale -1). Missing sprites fall back to rectangles.
party_vis = [];
for (_i = 0; _i < array_length(party); _i++) {
    array_push(party_vis, scr_battle_vis_create(party[_i].actor_id, -1));
}

// ---------------------------------------------------------------------------------------------
// Lookups

get_actor = function(_side, _idx) {
    if (_side == "party") return (_idx >= 0 && _idx < array_length(party)) ? party[_idx] : undefined;
    return (_idx >= 0 && _idx < array_length(enemies)) ? enemies[_idx] : undefined;
};

get_vis = function(_side, _idx) {
    if (_side == "party") return (_idx >= 0 && _idx < array_length(party_vis)) ? party_vis[_idx] : undefined;
    return (_idx >= 0 && _idx < array_length(enemy_vis)) ? enemy_vis[_idx] : undefined;
};

get_feet = function(_side, _idx) {
    if (_side == "party") return scr_battle_layout_party_feet(_idx);
    if (_idx >= 0 && _idx < array_length(enemies)) return enemies[_idx].feet;
    return scr_battle_layout_enemy_feet();
};

/// Living = can act and be targeted (a yielded boss is out of the fight).
is_up = function(_side, _idx) {
    var _a = get_actor(_side, _idx);
    if (!is_struct(_a) || _a.hp <= 0) return false;
    if (_side == "enemy" && (_a.yielded || (variable_struct_exists(_a, "withdrawn") && _a.withdrawn))) return false;
    return true;
};

living = function(_side) {
    var _out = [];
    var _n = (_side == "party") ? array_length(party) : array_length(enemies);
    for (var _k = 0; _k < _n; _k++) if (is_up(_side, _k)) array_push(_out, _k);
    return _out;
};

/// "" while the fight goes on, else "victory" / "defeat". A yielded boss ends it as a win.
battle_outcome = function() {
    if (!scr_party_any_alive(party)) return "defeat";
    var _any = false;
    for (var _k = 0; _k < array_length(enemies); _k++) {
        if (enemies[_k].yielded) return "victory";
        if (enemies[_k].hp > 0) _any = true;
    }
    return _any ? "" : "victory";
};

state_after_action = function() {
    var _o = battle_outcome();
    if (_o == "victory") return BATTLE_STATE.VICTORY;
    if (_o == "defeat") return BATTLE_STATE.DEFEAT;
    return BATTLE_STATE.TURN_NEXT;
};

// ---------------------------------------------------------------------------------------------
// Messages and animation

/// Show a message, wait for confirm, then enter _next.
queue_message = function(_text, _next) {
    message = _text;
    next_state = _next;
    state = BATTLE_STATE.MESSAGE;
};

/// Begin an action clip. Damage / effects apply at the hit frame (or immediately if the clip
/// is missing). Confirm skips the rest of the clip. `_target_vises` get hurt / death clips.
begin_anim = function(_attacker_vis, _target_vises, _hit, _text, _anim) {
    anim_attacker_vis = _attacker_vis;
    anim_target_vises = is_array(_target_vises) ? _target_vises : [];
    anim_hit = _hit;
    anim_message = _text;
    anim_next_state = BATTLE_STATE.TURN_NEXT;
    anim_hit_applied = false;
    anim_fx_done = false;
    if (is_struct(_attacker_vis) && is_string(_anim) && _anim != "") scr_battle_vis_play(_attacker_vis, _anim);
    state = BATTLE_STATE.ANIMATING;
};

/// Apply the pending action. Enemy XP is credited here, at the actual killing hit, to members who
/// have taken a turn and are still standing (scr_party_credit_enemy_xp). Gold is summed at victory.
apply_pending_hit = function() {
    if (anim_hit_applied) return;
    anim_hit_applied = true;
    if (!is_struct(anim_hit)) return;
    var _h = anim_hit;
    var _sk = scr_skill_get(_h.skill_id);

    for (var _t = 0; _t < array_length(_h.targets); _t++) {
        var _e = _h.targets[_t];
        var _tgt = get_actor(_e.side, _e.index);
        if (!is_struct(_tgt)) continue;
        var _feet = get_feet(_e.side, _e.index);
        var _vis = get_vis(_e.side, _e.index);

        if (_h.effect == "damage" || _h.effect == "steal") {
            if (_tgt.hp <= 0) continue;
            if (_e.miss) {
                array_push(dmg_pops, { x: _feet.x - 12, y: _feet.y - 40, value: 0, kind: "dmg", word: "spr_ui_dmg_miss", vy: -0.4, life: 40 });
                continue;
            }
            if (_e.side == "enemy" && _e.guarded) _tgt.is_guarding = false; // enemy guard absorbs one hit
            _tgt.hp = scr_apply_damage(_tgt.hp, _tgt.max_hp, _e.damage);
            if (_e.damage > 0) scr_battle_remove_status(_tgt, "sleep"); // a hit wakes a sleeper
            if (_e.steal > 0) {
                var _thief = get_actor(_h.user_side, _h.user_index);
                var _took = min(_e.steal, global.game.gold);
                global.game.gold -= _took;
                if (is_struct(_thief)) _thief.stolen_gold += _took;
            }
            if (_e.damage > 0) scr_battle_pop_add(dmg_pops, _feet.x, _feet.y, _e.damage, "dmg");
            if (_e.weak) array_push(dmg_pops, { x: _feet.x - 14, y: _feet.y - 40, value: 0, kind: "dmg", word: "spr_ui_dmg_weak", vy: -0.4, life: 40 });
            if (_e.side == "enemy") {
                if (_tgt.hp <= 0) {
                    var _does_yield = _tgt.yields || (_tgt.yields_if_flag != "" && scr_flag_get(_tgt.yields_if_flag));
                    if (_does_yield) {
                        // Yield replaces death: hold the yield clip's last frame; he lives.
                        _tgt.yielded = true;
                        _tgt.hp = 1; // he lives; is_up() treats a yielded boss as out of the fight
                        if (is_string(_tgt.yield_flag) && _tgt.yield_flag != "") scr_flag_set(_tgt.yield_flag, true);
                        scr_battle_vis_play(_vis, "yield");
                        // Balance pass (PLACEHOLDER rule): the soldiers still standing withdraw, but
                        // their XP is credited now (same participant rule) and their gold is summed at victory.
                        for (var _w = 0; _w < array_length(enemies); _w++) {
                            var _wd = enemies[_w];
                            if (_wd == _tgt || _wd.hp <= 0 || _wd.yielded) continue;
                            _wd.withdrawn = true;
                            if (!_wd.xp_credited) {
                                scr_party_credit_enemy_xp(_wd.xp_reward);
                                _wd.xp_credited = true;
                            }
                        }
                    } else {
                        if (is_struct(_vis) && _vis.kind == "blackguard") _vis.phase = 3; // final death is the p3 strip
                        scr_battle_vis_play(_vis, "death");
                    }
                    if (!_tgt.xp_credited) {
                        scr_party_credit_enemy_xp(_tgt.xp_reward);
                        _tgt.xp_credited = true;
                    }
                } else {
                    scr_battle_vis_play(_vis, "hurt");
                }
            } else if (_e.damage > 0) {
                scr_battle_vis_play(_vis, (_tgt.hp <= 0) ? "death" : "hurt");
            }
        } else if (_h.effect == "heal") {
            if (_tgt.hp <= 0) continue;
            _tgt.hp = clamp(_tgt.hp + _e.damage, 0, _tgt.max_hp);
            scr_battle_pop_add(dmg_pops, _feet.x, _feet.y, _e.damage, "heal");
        } else if (_h.effect == "buff") {
            for (var _b = 0; _b < array_length(_sk.buffs); _b++) {
                var _bf = _sk.buffs[_b];
                scr_battle_add_buff(_tgt, _bf.stat, _bf.pct, _bf.turns, _sk.id);
            }
        } else if (_h.effect == "guard") {
            _tgt.is_guarding = true;
        } else if (_h.effect == "status") {
            if (_e.status_ok) scr_battle_try_add_status(_tgt, _sk.status, _sk.status_turns);
        }
        // "flavor": message / visual only (Chapter 1 howl, scream, web, Blood Oath).
    }

    if (!anim_fx_done) {
        anim_fx_done = true;
        scr_ch1_battle_spawn_special_fx(_h);
    }
    anim_next_state = state_after_action();
};

finish_animating = function() {
    if (!anim_hit_applied) apply_pending_hit();
    var _av = anim_attacker_vis;
    if (is_struct(_av) && _av.anim != "hurt" && _av.anim != "death" && _av.anim != "yield" && string_pos("transition", _av.anim) <= 0) {
        scr_battle_vis_play(_av, "idle");
    }
    for (var _k = 0; _k < array_length(anim_target_vises); _k++) {
        var _tv = anim_target_vises[_k];
        if (is_struct(_tv) && _tv.anim == "hurt") scr_battle_vis_play(_tv, "idle");
    }
    // A living Blackguard may need a phase transition first (60% / 20% HP).
    for (var _b = 0; _b < array_length(enemies); _b++) {
        var _bg = enemies[_b];
        if (_bg.actor_id == "blackguard" && _bg.hp > 0) {
            var _want = scr_blackguard_phase_for_hp(_bg.hp, _bg.max_hp);
            if (_want > _bg.phase) {
                start_phase_shift(_b, _want);
                return;
            }
        }
    }
    // Generic two-phase bosses (Sanctuary Warden, Blackwood Matriarch): one shift at phase2_at.
    for (var _g2 = 0; _g2 < array_length(enemies); _g2++) {
        var _ge = enemies[_g2];
        if (_ge.actor_id == "blackguard" || _ge.phase2_at <= 0 || _ge.phase >= 2 || !is_up("enemy", _g2)) continue;
        if (_ge.hp <= _ge.max_hp * _ge.phase2_at) {
            start_phase_shift(_g2, 2);
            return;
        }
    }
    if (try_start_stance()) return;
    queue_message(anim_message, anim_next_state);
};

start_phase_shift = function(_index, _want) {
    phase_enemy = _index;
    var _bg = enemies[_index];
    phase_from = _bg.phase;
    phase_want = _want;
    phase_next = phase_from + 1;
    var _anim = (phase_next == 2) ? "transition_p1to2" : "transition_p2to3";
    if (_bg.actor_id != "blackguard") _anim = "trans"; // generic bosses: trans strip, then idle_p2
    var _vis = get_vis("enemy", _index);
    if (is_struct(_vis)) {
        _vis.phase = phase_from;
        scr_battle_vis_play(_vis, _anim);
    }
    state = BATTLE_STATE.PHASE_SHIFT;
};

finish_phase_shift = function() {
    var _bg = enemies[phase_enemy];
    var _generic = (_bg.actor_id != "blackguard");
    if (_generic) {
        _bg.phase = phase_next;
        for (var _pb = 0; _pb < array_length(_bg.phase2_buffs); _pb++) {
            var _pbf = _bg.phase2_buffs[_pb];
            scr_battle_add_buff(_bg, _pbf.stat, _pbf.pct, _pbf.turns, "phase2");
        }
    } else {
        scr_blackguard_apply_phase(_bg, phase_next);
    }
    var _vis = get_vis("enemy", phase_enemy);
    if (is_struct(_vis)) {
        _vis.phase = phase_next;
        scr_battle_vis_play(_vis, "idle");
    }
    if (phase_next < phase_want) {
        start_phase_shift(phase_enemy, phase_want);
        return;
    }
    var _line = anim_message;
    var _pl = _generic ? ((_bg.phase2_line != "") ? _bg.phase2_line : (_bg.name + " changes!")) : scr_blackguard_phase_line(phase_want);
    if (_pl != "") _line = (_line == "") ? _pl : (_line + "\n" + _pl);
    queue_message(_line, anim_next_state);
};

/// One-time boss stance when every add has fallen (Reeve Calder). Returns true if it started.
try_start_stance = function() {
    if (anim_next_state != BATTLE_STATE.TURN_NEXT) return false; // battle already over
    for (var _k = 0; _k < array_length(enemies); _k++) {
        var _b = enemies[_k];
        if (!_b.stance_on_adds_fall || _b.stance_used || !is_up("enemy", _k)) continue;
        var _adds = 0;
        var _adds_up = 0;
        for (var _a = 0; _a < array_length(enemies); _a++) {
            if (!enemies[_a].is_add) continue;
            _adds += 1;
            if (is_up("enemy", _a)) _adds_up += 1;
        }
        if (_adds == 0 || _adds_up > 0) continue;
        _b.stance_used = true;
        stance_enemy = _k;
        var _vis = get_vis("enemy", _k);
        if (is_struct(_vis)) scr_battle_vis_play(_vis, "stance");
        state = BATTLE_STATE.STANCE_SHIFT;
        return true;
    }
    return false;
};

finish_stance = function() {
    var _b = enemies[stance_enemy];
    for (var _s = 0; _s < array_length(_b.stance_buffs); _s++) {
        var _sb = _b.stance_buffs[_s];
        scr_battle_add_buff(_b, _sb.stat, _sb.pct, _sb.turns, "stance");
    }
    _b.phase = 2; // drives idle_p2 for Calder when imported
    var _vis = get_vis("enemy", stance_enemy);
    if (is_struct(_vis)) {
        _vis.phase = 2;
        scr_battle_vis_play(_vis, "idle");
    }
    // System line only. Calder's bark (WF_CALDER_PHASE2_01) is wired with the Chapter 2 dialogue task.
    var _line = _b.full_name + " takes a harder stance!";
    queue_message((anim_message == "") ? _line : (anim_message + "\n" + _line), anim_next_state);
};

// ---------------------------------------------------------------------------------------------
// Targets and actions

/// Resolve a skill's targets as [{ side, index }]. A dead / yielded single target is replaced
/// by the first living one (enemy side) or a random living member (party side).
resolve_targets = function(_side, _idx, _sk, _pick) {
    var _opp = (_side == "party") ? "enemy" : "party";
    var _out = [];
    switch (_sk.target) {
        case "single":
            var _ti = _pick;
            if (_side == "enemy") {
                _ti = scr_party_random_living_index(party);
            } else if (!is_up(_opp, _ti)) {
                var _lv = living(_opp);
                _ti = (array_length(_lv) > 0) ? _lv[0] : -1;
            }
            if (_ti != -1) array_push(_out, { side: _opp, index: _ti });
            break;
        case "all":
            var _all = living(_opp);
            for (var _k = 0; _k < array_length(_all); _k++) array_push(_out, { side: _opp, index: _all[_k] });
            break;
        case "ally":
            var _ai = is_up(_side, _pick) ? _pick : _idx;
            array_push(_out, { side: _side, index: _ai });
            break;
        case "ally_lowest": // most-hurt living member of the user's side (field surgeon heal)
            var _lw = living(_side);
            var _best = -1;
            var _best_pct = 2;
            for (var _q = 0; _q < array_length(_lw); _q++) {
                var _qa = get_actor(_side, _lw[_q]);
                var _pct = _qa.hp / max(1, _qa.max_hp);
                if (_pct < _best_pct) { _best_pct = _pct; _best = _lw[_q]; }
            }
            if (_best != -1) array_push(_out, { side: _side, index: _best });
            break;
        case "all_allies":
            var _mine = living(_side);
            for (var _m = 0; _m < array_length(_mine); _m++) array_push(_out, { side: _side, index: _mine[_m] });
            break;
        default: // "self"
            array_push(_out, { side: _side, index: _idx });
            break;
    }
    return _out;
};

/// Build the hit, its message, and start the clip for one skill use (Attack is the "attack" skill).
run_skill = function(_side, _idx, _sk, _targets) {
    var _user = get_actor(_side, _idx);
    var _hit = {
        kind: (_side == "party") ? "player_skill" : "enemy_skill",
        user_side: _side,
        user_index: _idx,
        skill_id: _sk.id,
        effect: _sk.effect,
        targets: [],
        anim: _sk.anim,
        enemy_kind: (_side == "enemy") ? _user.actor_id : "",
        party_index: 0,
        fx_frame: _sk.fx_frame,
        projectile: _sk.projectile,
        projectile_frames: _sk.projectile_frames,
        fx_from: get_feet(_side, _idx),
        fx_to: undefined
    };
    var _vises = [];
    var _parts = "";
    for (var _t = 0; _t < array_length(_targets); _t++) {
        var _tr = _targets[_t];
        var _tgt = get_actor(_tr.side, _tr.index);
        var _entry = { side: _tr.side, index: _tr.index, damage: 0, weak: false, guarded: false, miss: false, steal: 0, status_ok: false };
        if (_sk.effect == "damage" || _sk.effect == "steal") {
            var _r = scr_battle_skill_damage(_user, _tgt, _sk);
            _entry.damage = _r.damage;
            _entry.weak = _r.weak;
            if (_tgt.is_guarding) {
                _entry.damage = scr_apply_guard(_entry.damage, true);
                _entry.guarded = true;
            }
            // Physical misses: a blind user, or a veiled (faded) target.
            if (_sk.dmg_type == "phys" && (scr_battle_status_has(_tgt, "veiled")
                || (scr_battle_status_has(_user, "blind") && random(1) < BATTLE_BLIND_MISS_CHANCE))) {
                _entry.miss = true;
                _entry.damage = 0;
            }
            if (_sk.effect == "steal" && !_entry.miss && _tr.side == "party") {
                _entry.steal = min(global.game.gold, irandom_range(_sk.steal_min, _sk.steal_max));
            }
            array_push(_vises, get_vis(_tr.side, _tr.index));
            if (_parts != "") _parts += ", ";
            _parts += _tgt.name + (_entry.miss ? " missed" : (" " + string(_entry.damage))) + (_entry.guarded ? " (guarded)" : "") + (_entry.weak ? " Weak!" : "");
        } else if (_sk.effect == "status") {
            _entry.status_ok = (random(1) < _sk.status_chance) && !scr_battle_status_has(_tgt, _sk.status) && !scr_battle_status_resisted(_tgt, _sk.status);
        } else if (_sk.effect == "heal") {
            _entry.damage = max(1, floor(_sk.power));
            array_push(_vises, get_vis(_tr.side, _tr.index));
        }
        array_push(_hit.targets, _entry);
        if (_t == 0) {
            if (_tr.side == "party") _hit.party_index = _tr.index;
            _hit.fx_to = get_feet(_tr.side, _tr.index);
        }
    }

    // Message. Single-target Attack keeps the Chapter 1 wording.
    var _text = "";
    if ((_sk.effect == "damage" || _sk.effect == "steal") && array_length(_hit.targets) == 1 && _hit.targets[0].miss) {
        var _m0 = get_actor(_hit.targets[0].side, _hit.targets[0].index);
        _text = _user.name + ((_sk.id == "attack") ? " attacks" : (" uses " + _sk.name)) + "... " + _m0.name + " evades! (miss)";
    } else if (_sk.effect == "steal" && array_length(_hit.targets) == 1) {
        var _s0 = _hit.targets[0];
        var _st0 = get_actor(_s0.side, _s0.index);
        _text = _user.name + " strikes " + _st0.name + " for " + string(_s0.damage) + " and steals " + string(_s0.steal) + " gold!";
    } else if (_sk.effect == "status" && _sk.target != "self") {
        var _sp = "";
        for (var _si = 0; _si < array_length(_hit.targets); _si++) {
            var _se = _hit.targets[_si];
            var _sa = get_actor(_se.side, _se.index);
            var _word = (_sk.status == "blind") ? " is blinded!" : ((_sk.status == "sleep") ? " falls asleep!" : (" is afflicted (" + _sk.status + ")!"));
            _sp += (_sp == "" ? "" : " ") + _sa.name + (_se.status_ok ? _word : " resists.");
        }
        _text = _user.name + " uses " + _sk.name + "! " + _sp;
    } else if (_sk.effect == "status") {
        _hit.targets[0].status_ok = true; // self status (Fade) always lands
        _text = _user.name + " " + ((_sk.verb != "") ? _sk.verb : ("uses " + _sk.name + "!"));
    } else if (_sk.effect == "damage" && array_length(_hit.targets) == 1) {
        var _e0 = _hit.targets[0];
        var _t0 = get_actor(_e0.side, _e0.index);
        var _gn = _e0.guarded ? " (guarded)" : "";
        var _wk = _e0.weak ? " Weak!" : "";
        if (_side == "party") {
            if (_sk.id == "attack") _text = _user.name + " attacks! " + _t0.name + " takes " + string(_e0.damage) + " damage." + _gn + _wk;
            else _text = _user.name + " uses " + _sk.name + "! " + _t0.name + " takes " + string(_e0.damage) + " damage." + _gn + _wk;
        } else {
            if (_sk.id == "attack") _text = _user.name + " attacks " + _t0.name + "! " + string(_e0.damage) + " damage" + _gn + "." + _wk;
            else _text = _user.name + " uses " + _sk.name + " on " + _t0.name + "! " + string(_e0.damage) + " damage" + _gn + "." + _wk;
        }
    } else if (_sk.effect == "damage") {
        _text = _user.name + " uses " + _sk.name + "! " + _parts + ".";
    } else if (_sk.verb != "") {
        _text = _user.name + " " + _sk.verb;
    } else {
        _text = _user.name + " uses " + _sk.name + "!";
    }

    begin_anim(get_vis(_side, _idx), _vises, _hit, _text, _sk.anim);
};

/// Resolve one queued party Attack / Skill. MP is spent here, when the turn actually happens.
do_party_skill = function(_pi, _skill_id, _pick) {
    var _actor = party[_pi];
    var _sk = scr_skill_get(_skill_id);
    if (_sk.mp_cost > _actor.mp) {
        queue_message(_actor.name + " tries " + _sk.name + ", but lacks the MP.", BATTLE_STATE.TURN_NEXT);
        return;
    }
    var _targets = resolve_targets("party", _pi, _sk, _pick);
    if (array_length(_targets) == 0) {
        state = state_after_action();
        return;
    }
    _actor.mp -= _sk.mp_cost;
    run_skill("party", _pi, _sk, _targets);
};

/// Queue this member's choice, then move to the next living member or start the round.
commit_action = function(_entry) {
    array_push(queued_actions, _entry);
    pending_command = "";
    pending_skill = "";
    var _next_actor = scr_party_next_living_index(party, actor_index + 1);
    if (_next_actor == -1) {
        build_turn_order();
        state = BATTLE_STATE.TURN_NEXT;
    } else {
        actor_index = _next_actor;
        command_index = 0;
        state = BATTLE_STATE.COMMAND_SELECT;
    }
};

/// Pick a target for the pending Attack / Skill. One living target = no extra confirm
/// (a single-enemy Chapter 1 fight plays exactly as before).
begin_target_select = function(_side) {
    var _lv = living(_side);
    if (array_length(_lv) == 0) return;
    if (array_length(_lv) == 1 && _side == "enemy") {
        commit_action({ actor_index: actor_index, command: pending_command, skill_id: pending_skill, target_side: _side, target_index: _lv[0] });
        return;
    }
    target_side = _side;
    target_index = (_side == "party") ? actor_index : _lv[0];
    if (!is_up(_side, target_index)) target_index = _lv[0];
    state = BATTLE_STATE.TARGET_SELECT;
};

/// Step `target_index` to the next / previous living target on `target_side`.
cycle_target = function(_dir) {
    var _lv = living(target_side);
    var _n = array_length(_lv);
    if (_n == 0) return;
    var _pos = 0;
    for (var _k = 0; _k < _n; _k++) if (_lv[_k] == target_index) _pos = _k;
    _pos = (_pos + _dir + _n) mod _n;
    target_index = _lv[_pos];
};

/// SPD order for the round: every queued party action plus every living enemy.
/// key = battle SPD (buffs, Blackguard speed_mod) + random(0..BATTLE_SPD_TIEBREAK).
build_turn_order = function() {
    turn_order = [];
    for (var _q = 0; _q < array_length(queued_actions); _q++) {
        var _qa = queued_actions[_q];
        var _pa = party[_qa.actor_index];
        array_push(turn_order, { side: "party", index: _qa.actor_index, action: _qa, key: scr_battle_stat(_pa, "spd") + random(BATTLE_SPD_TIEBREAK) });
    }
    for (var _k = 0; _k < array_length(enemies); _k++) {
        if (!is_up("enemy", _k)) continue;
        array_push(turn_order, { side: "enemy", index: _k, action: undefined, key: scr_battle_stat(enemies[_k], "spd") + random(BATTLE_SPD_TIEBREAK) });
    }
    turn_order = scr_battle_sort_turns(turn_order);
    turn_pos = 0;
};
