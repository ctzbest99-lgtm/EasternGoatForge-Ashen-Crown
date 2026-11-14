/// scr_save — versioned JSON save / load via buffer + file.
/// Files: save1.sav, save2.sav, save3.sav in the working directory.
/// Missing or corrupt files fail safely and never crash the title or a save point.

function scr_save_filename(_slot) {
    var _n = clamp(floor(_slot), 1, SAVE_SLOT_COUNT);
    return "save" + string(_n) + ".sav";
}

function scr_save_any_exists() {
    for (var _i = 1; _i <= SAVE_SLOT_COUNT; _i++) {
        if (file_exists(scr_save_filename(_i))) return true;
    }
    return false;
}

function scr_save_playtime_seconds() {
    scr_game_state_init();
    var _frames = variable_struct_exists(global.game, "playtime_frames") ? global.game.playtime_frames : 0;
    var _fps = max(1, game_get_speed(gamespeed_fps));
    return _frames / _fps;
}

function scr_save_tick_playtime() {
    scr_game_state_init();
    var _title = asset_get_index("rm_title");
    if (_title != -1 && room == _title) return;
    if (!variable_struct_exists(global.game, "playtime_frames")) global.game.playtime_frames = 0;
    global.game.playtime_frames += 1;
}

function scr_save_location_name(_room_name, _px = 0, _py = 0) {
    switch (_room_name) {
        case "rm_greyhaven_chapel": return "Greyhaven Chapel";
        case "rm_greyhaven_tavern": return "Greyhaven Tavern";
        case "rm_greyhaven_blacksmith": return "Greyhaven Forge";
        case "rm_greyhaven_general_store": return "Greyhaven Store";
        case "rm_greyhaven_varyn_house": return "Varyn House";
        case "rm_old_watchtower": return "Old Watchtower";
        case "rm_watchtower_basement": return "Watchtower Basement";
        case "rm_overworld":
            // Prefer the encounter zone the player is standing in; otherwise Greyhaven / Eldara.
            if (instance_exists(obj_player) && instance_exists(obj_encounter_zone)) {
                var _z = instance_position(_px, _py, obj_encounter_zone);
                if (_z == noone) _z = instance_place(_px, _py, obj_encounter_zone);
                if (_z != noone && variable_instance_exists(_z, "table_id")) {
                    switch (string(_z.table_id)) {
                        case "zone01_farmlands":
                        case "farmlands": return "Farmlands";
                        case "zone01_old_road":
                        case "old_road": return "Old Road";
                        case "zone01_bandit_camp":
                        case "bandit_camp": return "Bandit Camp";
                        case "zone01_watchtower":
                        case "watchtower": return "Watchtower Grounds";
                    }
                }
            }
            // South of the farmlands / inside the village bounding box is Greyhaven.
            if (_px >= 2800 && _py >= 2500) return "Greyhaven";
            return "The Ashen Road";
        case "rm_battle_test": return "Battle";
        case "rm_title": return "Title";
    }
    if (is_string(_room_name) && _room_name != "") return _room_name;
    return "Unknown";
}

function scr_save_clone_via_json(_value) {
    try {
        return json_parse(json_stringify(_value));
    } catch (_e) {
        show_debug_message("[save] clone failed: " + string(_e));
        return undefined;
    }
}

function scr_save_member_snapshot(_actor) {
    if (!is_struct(_actor)) return undefined;
    scr_actor_ensure_bases(_actor);
    var _eq = { weapon: "", armor: "", helm: "", accessory: "" };
    if (is_struct(_actor.equipment)) {
        if (variable_struct_exists(_actor.equipment, "weapon")) _eq.weapon = string(_actor.equipment.weapon);
        if (variable_struct_exists(_actor.equipment, "armor")) _eq.armor = string(_actor.equipment.armor);
        if (variable_struct_exists(_actor.equipment, "helm")) _eq.helm = string(_actor.equipment.helm);
        if (variable_struct_exists(_actor.equipment, "accessory")) _eq.accessory = string(_actor.equipment.accessory);
    }
    var _cats = [];
    if (variable_struct_exists(_actor, "weapon_categories") && is_array(_actor.weapon_categories)) {
        _cats = scr_save_clone_via_json(_actor.weapon_categories);
        if (!is_array(_cats)) _cats = [];
    }
    return {
        actor_id: _actor.actor_id,
        name: _actor.name,
        full_name: variable_struct_exists(_actor, "full_name") ? _actor.full_name : _actor.name,
        class_name: variable_struct_exists(_actor, "class_name") ? _actor.class_name : "",
        role: variable_struct_exists(_actor, "role") ? _actor.role : "",
        hp: _actor.hp,
        max_hp: _actor.max_hp,
        base_attack: _actor.base_attack,
        base_defense: _actor.base_defense,
        attack: _actor.attack,
        defense: _actor.defense,
        level: _actor.level,
        xp: _actor.xp,
        // Schema v2 (battle upgrade): MP, SPD, MDEF, skills.
        mp: variable_struct_exists(_actor, "mp") ? _actor.mp : 0,
        max_mp: variable_struct_exists(_actor, "max_mp") ? _actor.max_mp : 0,
        base_spd: variable_struct_exists(_actor, "base_spd") ? _actor.base_spd : 8,
        base_mdef: variable_struct_exists(_actor, "base_mdef") ? _actor.base_mdef : 0,
        skills: (variable_struct_exists(_actor, "skills") && is_array(_actor.skills)) ? scr_save_clone_via_json(_actor.skills) : [],
        passives: (variable_struct_exists(_actor, "passives") && is_array(_actor.passives)) ? scr_save_clone_via_json(_actor.passives) : [],
        joined: variable_struct_exists(_actor, "joined") ? _actor.joined : false,
        poisoned: variable_struct_exists(_actor, "poisoned") && _actor.poisoned,
        age: variable_struct_exists(_actor, "age") ? _actor.age : -1,
        equipment: _eq,
        weapon_categories: _cats
    };
}

function scr_save_collect(_slot = 1) {
    scr_game_state_init();
    var _g = global.game;
    var _px = 0;
    var _py = 0;
    var _fx = 0;
    var _fy = 1;
    if (instance_exists(obj_player)) {
        _px = obj_player.x;
        _py = obj_player.y;
        _fx = obj_player.facing_x;
        _fy = obj_player.facing_y;
    }
    var _room_name = room_get_name(room);
    var _roster = [];
    if (is_array(_g.roster)) {
        for (var _i = 0; _i < array_length(_g.roster); _i++) {
            var _snap = scr_save_member_snapshot(_g.roster[_i]);
            if (is_struct(_snap)) array_push(_roster, _snap);
        }
    }
    var _inv = is_array(_g.inventory) ? scr_save_clone_via_json(_g.inventory) : [];
    if (!is_array(_inv)) _inv = [];
    var _flags = is_struct(_g.flags) ? scr_save_clone_via_json(_g.flags) : {};
    if (!is_struct(_flags)) _flags = {};
    var _cleared = is_struct(_g.cleared_encounters) ? scr_save_clone_via_json(_g.cleared_encounters) : {};
    if (!is_struct(_cleared)) _cleared = {};
    var _pending = undefined;
    if (variable_struct_exists(_g, "pending_post_dialogue") && is_array(_g.pending_post_dialogue)) {
        _pending = scr_save_clone_via_json(_g.pending_post_dialogue);
    }
    var _kael_level = 1;
    var _lead = (is_array(_g.party) && array_length(_g.party) > 0) ? _g.party[0] : undefined;
    if (is_struct(_lead)) _kael_level = _lead.level;

    return {
        save_schema_version: SAVE_SCHEMA_VERSION,
        slot: clamp(floor(_slot), 1, SAVE_SLOT_COUNT),
        playtime_seconds: scr_save_playtime_seconds(),
        saved_at: date_datetime_string(date_current_datetime()),
        room_name: _room_name,
        location_name: scr_save_location_name(_room_name, _px, _py),
        player_x: _px,
        player_y: _py,
        facing_x: _fx,
        facing_y: _fy,
        gold: _g.gold,
        lead_level: _kael_level,
        inventory: _inv,
        flags: _flags,
        cleared_encounters: _cleared,
        party_active: scr_party_ids_of(_g.party),
        party_reserve: scr_party_ids_of(_g.reserve),
        roster: _roster,
        pending_ashbound_encounter_id: variable_struct_exists(_g, "pending_ashbound_encounter_id") ? _g.pending_ashbound_encounter_id : "",
        pending_post_dialogue: _pending,
        random_encounters_enabled: variable_struct_exists(_g, "random_encounters_enabled") ? _g.random_encounters_enabled : RANDOM_ENCOUNTERS_ENABLED,
        encounter_step_remainder: variable_struct_exists(_g, "encounter_step_remainder") ? _g.encounter_step_remainder : 0,
        encounter_steps_until: variable_struct_exists(_g, "encounter_steps_until") ? _g.encounter_steps_until : 0,
        encounter_grace_steps: variable_struct_exists(_g, "encounter_grace_steps") ? _g.encounter_grace_steps : 0,
        ashbound_rare_chance: variable_struct_exists(_g, "ashbound_rare_chance") ? _g.ashbound_rare_chance : ASHBOUND_HUNTER_RARE_CHANCE
    };
}

/// Write `_data` (a struct) to slot `_slot`. Returns true on success.
function scr_save_write(_slot) {
    if (room == TITLE_ROOM || room == BATTLE_ROOM) return false;
    if (variable_global_exists("game") && is_struct(global.game) && global.game.battle_active) return false;
    var _n = clamp(floor(_slot), 1, SAVE_SLOT_COUNT);
    var _data = scr_save_collect(_n);
    var _json = "";
    try {
        _json = json_stringify(_data);
    } catch (_e) {
        show_debug_message("[save] stringify failed: " + string(_e));
        return false;
    }
    if (!is_string(_json) || _json == "" || string_char_at(_json, 1) != "{") return false;
    var _fname = scr_save_filename(_n);
    var _buf = buffer_create(string_byte_length(_json) + 1, buffer_grow, 1);
    buffer_write(_buf, buffer_text, _json);
    buffer_save(_buf, _fname);
    buffer_delete(_buf);
    show_debug_message("[save] wrote " + _fname);
    return file_exists(_fname);
}

function scr_save_read_raw(_slot) {
    var _fname = scr_save_filename(_slot);
    if (!file_exists(_fname)) return undefined;
    var _buf = buffer_load(_fname);
    if (_buf < 0) return undefined;
    buffer_seek(_buf, buffer_seek_start, 0);
    var _json = buffer_read(_buf, buffer_text);
    buffer_delete(_buf);
    if (!is_string(_json) || string_length(string_trim(_json)) == 0) return undefined;
    if (string_char_at(string_trim(_json), 1) != "{") return undefined;
    try {
        var _data = json_parse(_json);
        if (!is_struct(_data)) return undefined;
        return _data;
    } catch (_e) {
        show_debug_message("[save] parse failed (" + _fname + "): " + string(_e));
        return undefined;
    }
}

function scr_save_is_compatible(_data) {
    if (!is_struct(_data)) return false;
    if (!variable_struct_exists(_data, "save_schema_version")) return false;
    var _v = _data.save_schema_version;
    if (!is_real(_v)) return false;
    // Older stub (version 0) has no room / roster payload. Newer versions are refused.
    // Version 1 (pre battle upgrade) is accepted and upgraded by scr_save_migrate() on load.
    if (_v < 1 || _v > SAVE_SCHEMA_VERSION) return false;
    if (!variable_struct_exists(_data, "room_name")) return false;
    return true;
}

/// Header used by the load / save panels. `ok` is false for missing, corrupt, or incompatible files.
function scr_save_slot_info(_slot) {
    var _info = {
        slot: _slot,
        exists: file_exists(scr_save_filename(_slot)),
        ok: false,
        empty: !file_exists(scr_save_filename(_slot)),
        corrupt: false,
        location_name: "",
        lead_level: 1,
        lead_id: "",
        lead_name: "",
        party_ids: [],
        playtime_seconds: 0,
        gold: 0,
        room_name: ""
    };
    if (!_info.exists) return _info;
    var _data = scr_save_read_raw(_slot);
    if (!is_struct(_data) || !scr_save_is_compatible(_data)) {
        _info.corrupt = true;
        return _info;
    }
    _info.ok = true;
    _info.location_name = variable_struct_exists(_data, "location_name") ? string(_data.location_name) : "";
    if (_info.location_name == "" && variable_struct_exists(_data, "room_name")) {
        _info.location_name = scr_save_location_name(_data.room_name);
    }
    _info.lead_level = variable_struct_exists(_data, "lead_level") ? _data.lead_level : 1;
    _info.lead_id = "kael";
    _info.lead_name = "Kael";
    _info.party_ids = [];
    if (variable_struct_exists(_data, "party_active") && is_array(_data.party_active)) {
        _info.party_ids = _data.party_active;
        if (array_length(_data.party_active) > 0) _info.lead_id = string(_data.party_active[0]);
    }
    if (variable_struct_exists(_data, "roster") && is_array(_data.roster)) {
        for (var _r = 0; _r < array_length(_data.roster); _r++) {
            var _m = _data.roster[_r];
            if (is_struct(_m) && variable_struct_exists(_m, "actor_id") && string(_m.actor_id) == _info.lead_id) {
                if (variable_struct_exists(_m, "name")) _info.lead_name = _m.name;
                if (variable_struct_exists(_m, "level")) _info.lead_level = _m.level;
                break;
            }
        }
    }
    _info.playtime_seconds = variable_struct_exists(_data, "playtime_seconds") ? _data.playtime_seconds : 0;
    _info.gold = variable_struct_exists(_data, "gold") ? _data.gold : 0;
    _info.room_name = variable_struct_exists(_data, "room_name") ? string(_data.room_name) : "";
    return _info;
}

function scr_game_state_reset() {
    scr_menu_close_all();
    if (instance_exists(obj_dialogue_box)) instance_destroy(obj_dialogue_box);
    global.game = undefined;
    scr_game_state_init();
    if (variable_global_exists("map_spawn_name")) global.map_spawn_name = "";
}

function scr_save_apply_member(_actor, _snap) {
    if (!is_struct(_actor) || !is_struct(_snap)) return;
    if (variable_struct_exists(_snap, "name")) _actor.name = _snap.name;
    if (variable_struct_exists(_snap, "full_name")) _actor.full_name = _snap.full_name;
    if (variable_struct_exists(_snap, "class_name")) _actor.class_name = _snap.class_name;
    if (variable_struct_exists(_snap, "role")) _actor.role = _snap.role;
    if (variable_struct_exists(_snap, "max_hp")) _actor.max_hp = _snap.max_hp;
    if (variable_struct_exists(_snap, "hp")) _actor.hp = clamp(_snap.hp, 0, _actor.max_hp);
    if (variable_struct_exists(_snap, "base_attack")) _actor.base_attack = _snap.base_attack;
    if (variable_struct_exists(_snap, "base_defense")) _actor.base_defense = _snap.base_defense;
    if (variable_struct_exists(_snap, "level")) _actor.level = _snap.level;
    if (variable_struct_exists(_snap, "xp")) _actor.xp = _snap.xp;
    if (variable_struct_exists(_snap, "joined")) _actor.joined = _snap.joined;
    if (variable_struct_exists(_snap, "poisoned")) _actor.poisoned = _snap.poisoned;
    if (variable_struct_exists(_snap, "age")) _actor.age = _snap.age;
    if (variable_struct_exists(_snap, "weapon_categories") && is_array(_snap.weapon_categories)) {
        _actor.weapon_categories = _snap.weapon_categories;
    }
    if (variable_struct_exists(_snap, "equipment") && is_struct(_snap.equipment)) {
        _actor.equipment.weapon = variable_struct_exists(_snap.equipment, "weapon") ? string(_snap.equipment.weapon) : "";
        _actor.equipment.armor = variable_struct_exists(_snap.equipment, "armor") ? string(_snap.equipment.armor) : "";
        _actor.equipment.helm = variable_struct_exists(_snap.equipment, "helm") ? string(_snap.equipment.helm) : "";
        _actor.equipment.accessory = variable_struct_exists(_snap.equipment, "accessory") ? string(_snap.equipment.accessory) : "";
    }
    // Schema v2 fields. scr_save_migrate() fills these in for v1 saves before we get here;
    // the fallback below also covers a hand-edited file that lacks them.
    if (variable_struct_exists(_snap, "max_mp")) {
        _actor.max_mp = max(0, _snap.max_mp);
        _actor.mp = variable_struct_exists(_snap, "mp") ? clamp(_snap.mp, 0, _actor.max_mp) : _actor.max_mp;
        if (variable_struct_exists(_snap, "base_spd")) { _actor.base_spd = _snap.base_spd; _actor.spd = _snap.base_spd; }
        if (variable_struct_exists(_snap, "base_mdef")) { _actor.base_mdef = _snap.base_mdef; _actor.mdef = _snap.base_mdef; }
        if (variable_struct_exists(_snap, "skills") && is_array(_snap.skills)) _actor.skills = _snap.skills;
        if (variable_struct_exists(_snap, "passives") && is_array(_snap.passives)) _actor.passives = _snap.passives;
    } else {
        scr_actor_apply_battle_defaults(_actor); // uses the level applied above
    }
    _actor.buffs = [];
    _actor.statuses = [];
    _actor.is_guarding = false;
    _actor.participated = false;
    _actor.pending_xp = 0;
    scr_actor_refresh_equipment(_actor);
}

/// Upgrade an older save payload in place to SAVE_SCHEMA_VERSION. Returns the payload.
/// v1 -> v2 (battle upgrade): each roster member gets level-scaled MP / SPD / MDEF (full MP)
/// and their default skills, from scr_actor_battle_defaults + LEVEL_UP_*_GROWTH.
function scr_save_migrate(_data) {
    if (!is_struct(_data) || !variable_struct_exists(_data, "save_schema_version")) return _data;
    if (_data.save_schema_version < 2) {
        if (variable_struct_exists(_data, "roster") && is_array(_data.roster)) {
            for (var _i = 0; _i < array_length(_data.roster); _i++) {
                var _snap = _data.roster[_i];
                if (!is_struct(_snap) || !variable_struct_exists(_snap, "actor_id")) continue;
                var _d = scr_actor_battle_defaults(_snap.actor_id);
                var _lv = variable_struct_exists(_snap, "level") ? max(1, _snap.level) : 1;
                var _gt = scr_level_growth_total(_lv);
                _snap.max_mp = _d.mp + _gt.mp;
                _snap.mp = _snap.max_mp;
                _snap.base_spd = _d.spd + _gt.spd;
                _snap.base_mdef = _d.mdef + _gt.mdef;
                _snap.skills = _d.skills;
                _snap.passives = _d.passives;
            }
        }
        _data.save_schema_version = 2;
        show_debug_message("[save] migrated a v1 save to v2 (MP / SPD / MDEF / skills).");
    }
    return _data;
}

function scr_save_apply(_data) {
    scr_game_state_reset();
    var _g = global.game;
    if (variable_struct_exists(_data, "gold")) _g.gold = max(0, _data.gold);
    if (variable_struct_exists(_data, "inventory") && is_array(_data.inventory)) _g.inventory = _data.inventory;
    if (variable_struct_exists(_data, "flags") && is_struct(_data.flags)) _g.flags = _data.flags;
    if (variable_struct_exists(_data, "cleared_encounters") && is_struct(_data.cleared_encounters)) {
        _g.cleared_encounters = _data.cleared_encounters;
    }
    if (variable_struct_exists(_data, "playtime_seconds")) {
        var _fps = max(1, game_get_speed(gamespeed_fps));
        _g.playtime_frames = floor(_data.playtime_seconds * _fps);
    }
    if (variable_struct_exists(_data, "pending_ashbound_encounter_id")) {
        _g.pending_ashbound_encounter_id = string(_data.pending_ashbound_encounter_id);
    }
    if (variable_struct_exists(_data, "pending_post_dialogue") && is_array(_data.pending_post_dialogue)) {
        _g.pending_post_dialogue = _data.pending_post_dialogue;
    }
    if (variable_struct_exists(_data, "random_encounters_enabled")) {
        _g.random_encounters_enabled = _data.random_encounters_enabled;
    }
    if (variable_struct_exists(_data, "encounter_step_remainder")) _g.encounter_step_remainder = _data.encounter_step_remainder;
    if (variable_struct_exists(_data, "encounter_steps_until")) _g.encounter_steps_until = _data.encounter_steps_until;
    if (variable_struct_exists(_data, "encounter_grace_steps")) _g.encounter_grace_steps = _data.encounter_grace_steps;
    if (variable_struct_exists(_data, "ashbound_rare_chance")) _g.ashbound_rare_chance = _data.ashbound_rare_chance;

    if (variable_struct_exists(_data, "roster") && is_array(_data.roster)) {
        for (var _i = 0; _i < array_length(_data.roster); _i++) {
            var _snap = _data.roster[_i];
            if (!is_struct(_snap) || !variable_struct_exists(_snap, "actor_id")) continue;
            var _actor = scr_roster_find(_g.roster, _snap.actor_id);
            if (is_struct(_actor)) scr_save_apply_member(_actor, _snap);
        }
    }

    var _active = [];
    var _ids_a = (variable_struct_exists(_data, "party_active") && is_array(_data.party_active)) ? _data.party_active : [];
    for (var _a = 0; _a < array_length(_ids_a); _a++) {
        var _m = scr_roster_find(_g.roster, _ids_a[_a]);
        if (is_struct(_m)) {
            _m.joined = true;
            array_push(_active, _m);
        }
        if (array_length(_active) >= PARTY_ACTIVE_MAX) break;
    }
    var _res = [];
    var _ids_r = (variable_struct_exists(_data, "party_reserve") && is_array(_data.party_reserve)) ? _data.party_reserve : [];
    for (var _r = 0; _r < array_length(_ids_r); _r++) {
        var _rmem = scr_roster_find(_g.roster, _ids_r[_r]);
        if (is_struct(_rmem)) {
            _rmem.joined = true;
            array_push(_res, _rmem);
        }
        if (array_length(_res) >= PARTY_RESERVE_MAX) break;
    }
    if (array_length(_active) == 0) {
        var _kael = scr_roster_find(_g.roster, "kael");
        if (is_struct(_kael)) {
            _kael.joined = true;
            array_push(_active, _kael);
        }
    }
    _g.party = _active;
    _g.reserve = _res;
    if (array_length(_active) > 0) _g.xp = _active[0].xp;
    scr_party_refresh_equipment();

    var _room_name = variable_struct_exists(_data, "room_name") ? string(_data.room_name) : "";
    var _rm = asset_get_index(_room_name);
    if (_rm == -1 || _room_name == "rm_title" || _room_name == "rm_battle_test") {
        show_debug_message("[save] cannot go to room '" + _room_name + "'; falling back to overworld.");
        _rm = asset_get_index("rm_overworld");
        if (_rm == -1) return false;
        _g.pending_load = {
            room_id: _rm,
            px: TOWN_RESPAWN_X,
            py: TOWN_RESPAWN_Y,
            facing_x: 0,
            facing_y: 1
        };
        room_goto(_rm);
        return true;
    }
    _g.pending_load = {
        room_id: _rm,
        px: variable_struct_exists(_data, "player_x") ? _data.player_x : 0,
        py: variable_struct_exists(_data, "player_y") ? _data.player_y : 0,
        facing_x: variable_struct_exists(_data, "facing_x") ? _data.facing_x : 0,
        facing_y: variable_struct_exists(_data, "facing_y") ? _data.facing_y : 1
    };
    room_goto(_rm);
    return true;
}

/// Load slot `_slot`. Returns true if the room transition was started.
/// Corrupt / missing files return false and leave the current state alone.
function scr_save_load(_slot) {
    var _data = scr_save_read_raw(_slot);
    if (!is_struct(_data) || !scr_save_is_compatible(_data)) return false;
    _data = scr_save_migrate(_data);
    return scr_save_apply(_data);
}

function scr_save_menu_open(_mode = "save", _prompt = false) {
    var _inst = scr_menu_open_object("obj_save_menu");
    if (_inst != noone && instance_exists(_inst)) {
        _inst.mode = (_mode == "load") ? "load" : "save";
        _inst.need_prompt = _prompt && (_inst.mode == "save");
        _inst.index = 0;
        _inst.prompt_index = 0;
        _inst.message = "";
        _inst.refresh_slots = true;
    }
    return _inst;
}
