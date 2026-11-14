/// scr_battle_actors — actor structs shared by party members and enemies.
/// The active battle party is global.game.party (1–PARTY_ACTIVE_MAX). Array order is turn order.
/// The fifth roster member sits in global.game.reserve (0–PARTY_RESERVE_MAX). See scr_party.gml.

function scr_actor_create(_actor_id, _name, _max_hp, _attack, _defense, _spd = 8, _mdef = 0, _max_mp = 0) {
    return {
        actor_id: _actor_id,
        name: _name,
        full_name: _name,
        max_hp: _max_hp,
        hp: _max_hp,
        attack: _attack,
        defense: _defense,
        base_attack: _attack,
        base_defense: _defense,
        // Battle upgrade: SPD (turn order), MDEF (magic defense), MP / max MP, skills.
        // `spd` / `mdef` are the current values; `base_spd` / `base_mdef` are before gear (gear has none yet).
        spd: _spd,
        base_spd: _spd,
        mdef: _mdef,
        base_mdef: _mdef,
        max_mp: _max_mp,
        mp: _max_mp,
        skills: [],          // active skill ids (scr_skill_get); shown under the Skill command
        passives: [],        // passive skill ids (e.g. "unbowed"); never shown in the Skill menu
        buffs: [],           // battle-only [{ stat, pct, turns, source }]; cleared at battle start / end
        statuses: [],        // battle-only status ids (e.g. "fear", "stun"); none are inflicted yet
        weakness: "",        // element id; enemies only for now
        is_guarding: false,
        participated: false, // set if they took a turn in the current battle
        pending_xp: 0,       // per-enemy credit accumulated this battle; applied on victory only
        level: 1,
        xp: 0,
        class_name: "",
        role: "",
        joined: false,
        poisoned: false,     // overworld status; battle poison is not implemented yet
        weapon_categories: [],
        equipment: { weapon: "", armor: "", helm: "", accessory: "" }
    };
}

/// Build a battle actor from a scr_get_enemy_data() struct. Returns undefined for bad data.
function scr_actor_from_enemy_data(_data) {
    if (!is_struct(_data)) return undefined;
    var _spd = variable_struct_exists(_data, "spd") ? _data.spd : 8;
    var _mdef = variable_struct_exists(_data, "mdef") ? _data.mdef : 0;
    var _mp = variable_struct_exists(_data, "max_mp") ? _data.max_mp : 0;
    var _actor = scr_actor_create(_data[$ "id"], _data.name, _data.max_hp, _data.attack, _data.defense, _spd, _mdef, _mp);
    _actor.short_name = variable_struct_exists(_data, "short_name") ? _data.short_name : _data.name;
    _actor.xp_reward = _data.xp_reward;
    // Gold: a range (gold_min..gold_max) is rolled once per enemy; otherwise the fixed gold_reward.
    var _gold = variable_struct_exists(_data, "gold_reward") ? _data.gold_reward : 0;
    if (variable_struct_exists(_data, "gold_min") && variable_struct_exists(_data, "gold_max")) {
        _gold = irandom_range(min(_data.gold_min, _data.gold_max), max(_data.gold_min, _data.gold_max));
    }
    _actor.gold_reward = _gold;
    _actor.xp_credited = false; // set when this enemy's XP is banked to living participants
    _actor.weakness = (variable_struct_exists(_data, "weakness") && is_string(_data.weakness)) ? _data.weakness : "";
    _actor.actions = (variable_struct_exists(_data, "actions") && is_array(_data.actions)) ? _data.actions : [{ skill: "attack", weight: 1 }];
    _actor.actions_alone = (variable_struct_exists(_data, "actions_alone") && is_array(_data.actions_alone)) ? _data.actions_alone : undefined;
    _actor.phase_actions = (variable_struct_exists(_data, "phase_actions") && is_array(_data.phase_actions)) ? _data.phase_actions : undefined;
    _actor.is_boss = variable_struct_exists(_data, "is_boss") && _data.is_boss;
    _actor.yields = variable_struct_exists(_data, "yields") && _data.yields;      // yield replaces death (Reeve Calder)
    _actor.yield_flag = variable_struct_exists(_data, "yield_flag") ? _data.yield_flag : "";
    _actor.yielded = false;
    _actor.withdrawn = false; // left the field when the boss yielded (still gives XP / gold)
    _actor.stance_on_adds_fall = variable_struct_exists(_data, "stance_on_adds_fall") && _data.stance_on_adds_fall;
    _actor.stance_used = false;
    _actor.stance_buffs = (variable_struct_exists(_data, "stance_buffs") && is_array(_data.stance_buffs)) ? _data.stance_buffs : [];
    _actor.passives = (variable_struct_exists(_data, "passives") && is_array(_data.passives)) ? _data.passives : [];
    _actor.speed_mod = 1;
    _actor.phase = 1;
    _actor.is_add = false;
    _actor.slot = 0;
    _actor.fade = 1;
    // Batches 7–8 (generic kit support):
    // yields_if_flag — yield instead of dying only while this story flag is set (Commander Hailen:
    //                   "he can live, yield, or fall"); otherwise the normal death clip plays.
    // phase2_at      — HP fraction that triggers a one-time phase shift: play `trans`, then idle_p2 /
    //                   attack_p2, apply phase2_buffs, show phase2_line, use phase_actions[1].
    _actor.yields_if_flag = variable_struct_exists(_data, "yields_if_flag") ? _data.yields_if_flag : "";
    _actor.phase2_at = variable_struct_exists(_data, "phase2_at") ? _data.phase2_at : 0;
    _actor.phase2_buffs = (variable_struct_exists(_data, "phase2_buffs") && is_array(_data.phase2_buffs)) ? _data.phase2_buffs : [];
    _actor.phase2_line = variable_struct_exists(_data, "phase2_line") ? _data.phase2_line : "";
    _actor.stolen_gold = 0; // cutpurse: gold taken this battle; returned at victory if it falls
    // Story barks (dialogue node ids) shown in battle instead of the system line, e.g. Calder's
    // stance bark WF_CALDER_PHASE2_01 and yield line WF_CALDER_DEFEAT_01. "" = system line.
    _actor.stance_line = variable_struct_exists(_data, "stance_line_node") ? scr_ch2_node_text(_data.stance_line_node) : "";
    _actor.yield_line = variable_struct_exists(_data, "yield_line_node") ? scr_ch2_node_text(_data.yield_line_node) : "";
    return _actor;
}

/// Default active party: Kael only. Full roster / reserve are created in scr_party_state_create().
function scr_party_create_default() {
    var _state = scr_party_state_create();
    return _state.party;
}

/// Append a member to an active-party array if it is not full. Returns true on success.
function scr_party_add_member(_party, _actor) {
    if (!is_array(_party) || !is_struct(_actor)) return false;
    if (array_length(_party) >= PARTY_ACTIVE_MAX) return false;
    array_push(_party, _actor);
    return true;
}

/// Swap two active slots (party order = command and turn order). No-op on bad indices.
function scr_party_swap(_party, _a, _b) {
    if (!is_array(_party)) return;
    var _n = array_length(_party);
    if (_a < 0 || _b < 0 || _a >= _n || _b >= _n || _a == _b) return;
    var _tmp = _party[_a];
    _party[_a] = _party[_b];
    _party[_b] = _tmp;
}

function scr_actor_is_alive(_actor) {
    return is_struct(_actor) && _actor.hp > 0;
}

function scr_party_any_alive(_party) {
    return scr_party_next_living_index(_party, 0) != -1;
}

/// First living party index >= _from, or -1. Used for command and action order.
function scr_party_next_living_index(_party, _from) {
    for (var _i = max(0, _from); _i < array_length(_party); _i++) {
        if (scr_actor_is_alive(_party[_i])) return _i;
    }
    return -1;
}

/// Random living party index, or -1 if everyone is down. Used for enemy targeting.
function scr_party_random_living_index(_party) {
    var _living = [];
    for (var _i = 0; _i < array_length(_party); _i++) {
        if (scr_actor_is_alive(_party[_i])) array_push(_living, _i);
    }
    if (array_length(_living) == 0) return -1;
    return _living[irandom(array_length(_living) - 1)];
}

function scr_party_clear_guard(_party) {
    for (var _i = 0; _i < array_length(_party); _i++) _party[_i].is_guarding = false;
}

/// Restore everyone in `_party` to full HP and MP, and clear Guard / battle buffs.
function scr_party_restore_all(_party) {
    if (!is_array(_party)) return;
    for (var _i = 0; _i < array_length(_party); _i++) {
        if (!is_struct(_party[_i])) continue;
        _party[_i].hp = _party[_i].max_hp;
        if (variable_struct_exists(_party[_i], "max_mp")) _party[_i].mp = _party[_i].max_mp;
        _party[_i].is_guarding = false;
        _party[_i].buffs = [];
        _party[_i].statuses = [];
    }
}
