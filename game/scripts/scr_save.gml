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

/// True when at least one slot has a readable, compatible save. A corrupt file is not
/// a valid Continue target, but it still appears in Load Game as a damaged slot.
function scr_save_any_valid() {
    for (var _i = 1; _i <= SAVE_SLOT_COUNT; _i++) {
        var _info = scr_save_slot_info(_i);
        if (_info.ok) return true;
    }
    return false;
}

/// The newest valid slot, or 0 when there is none. New saves carry the numeric
/// `saved_at_epoch`; saves written before that field existed have 0 and fall back to
/// the highest valid slot so Continue still works for an existing library. Ties prefer
/// the higher slot number.
function scr_save_latest_slot() {
    var _best = 0;
    var _best_time = 0;
    var _fallback = 0;
    for (var _i = 1; _i <= SAVE_SLOT_COUNT; _i++) {
        var _info = scr_save_slot_info(_i);
        if (!_info.ok) continue;
        _fallback = _i;
        var _t = variable_struct_exists(_info, "saved_at_epoch") ? _info.saved_at_epoch : 0;
        if (is_real(_t) && _t > 0 && _t >= _best_time) {
            _best_time = _t;
            _best = _i;
        }
    }
    return (_best != 0) ? _best : _fallback;
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
    var _eq = { weapon: "", armor: "", helm: "", accessory: "", off_hand: "", legs: "", accessory_2: "" };
    if (is_struct(_actor.equipment)) {
        if (variable_struct_exists(_actor.equipment, "weapon")) _eq.weapon = string(_actor.equipment.weapon);
        if (variable_struct_exists(_actor.equipment, "armor")) _eq.armor = string(_actor.equipment.armor);
        if (variable_struct_exists(_actor.equipment, "helm")) _eq.helm = string(_actor.equipment.helm);
        if (variable_struct_exists(_actor.equipment, "accessory")) _eq.accessory = string(_actor.equipment.accessory);
        if (variable_struct_exists(_actor.equipment, "off_hand")) _eq.off_hand = string(_actor.equipment.off_hand);
        if (variable_struct_exists(_actor.equipment, "legs")) _eq.legs = string(_actor.equipment.legs);
        if (variable_struct_exists(_actor.equipment, "accessory_2")) _eq.accessory_2 = string(_actor.equipment.accessory_2);
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
        // Schema v4 (equipment): base maxima and the derived-stat bases.
        base_max_hp: variable_struct_exists(_actor, "base_max_hp") ? _actor.base_max_hp : _actor.max_hp,
        base_max_mp: variable_struct_exists(_actor, "base_max_mp") ? _actor.base_max_mp : (variable_struct_exists(_actor, "max_mp") ? _actor.max_mp : 0),
        base_magic: variable_struct_exists(_actor, "base_magic") ? _actor.base_magic : 0,
        base_acc: variable_struct_exists(_actor, "base_acc") ? _actor.base_acc : 85,
        base_eva: variable_struct_exists(_actor, "base_eva") ? _actor.base_eva : 5,
        base_crit: variable_struct_exists(_actor, "base_crit") ? _actor.base_crit : 0,
        armor_profs: (variable_struct_exists(_actor, "armor_profs") && is_array(_actor.armor_profs)) ? scr_save_clone_via_json(_actor.armor_profs) : [],
        shield_prof: variable_struct_exists(_actor, "shield_prof") ? _actor.shield_prof : false,
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
    var _inv = is_array(_g.inventory) ? scr_save_inventory_snapshot(_g.inventory) : [];
    if (!is_array(_inv)) _inv = [];
    var _flags = is_struct(_g.flags) ? scr_save_clone_via_json(_g.flags) : {};
    if (!is_struct(_flags)) _flags = {};
    var _cleared = is_struct(_g.cleared_encounters) ? scr_save_clone_via_json(_g.cleared_encounters) : {};
    if (!is_struct(_cleared)) _cleared = {};
    var _bestiary = is_struct(_g.bestiary) ? scr_save_clone_via_json(_g.bestiary) : {};
    if (!is_struct(_bestiary)) _bestiary = {};
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
        saved_at_epoch: date_current_datetime(), // numeric, used to pick the latest valid Continue slot
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
        bestiary: _bestiary,
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

// ---------------------------------------------------------------------------------------------
// Save / load locations (owner decision 2026-11-15, narrowed the same day)
// Saving and loading happen only at a save crystal inside a town's church or tavern — the room
// with the shrine or the hearth, not the town around it. Each town lists the rooms that belong to
// it (town identity, used for location names and the blocked line) and the rooms that may save
// (`save_rooms`, always the church/tavern interiors). Greyhaven also lives inside rm_overworld,
// so that room is resolved by position through scr_save_location_name(). Roads, the Old
// Watchtower, the battlefield, town squares and the title screen cannot save.
// Every listed town must have a church or a tavern and at least one save room.
function scr_save_towns() {
    return [
        {
            id: "greyhaven",
            name: "Greyhaven",
            church: "Greyhaven Chapel",
            tavern: "Greyhaven Tavern",
            save_rooms: ["rm_greyhaven_chapel", "rm_greyhaven_tavern"],
            rooms: ["rm_greyhaven_chapel", "rm_greyhaven_tavern", "rm_greyhaven_blacksmith",
                    "rm_greyhaven_general_store", "rm_greyhaven_varyn_house"]
        },
        {
            id: "wrenfield",
            name: "Wrenfield",
            church: "",
            tavern: "The Bent Post",
            save_rooms: ["rm_wrenfield_bent_post"],
            rooms: ["rm_wrenfield", "rm_wrenfield_bent_post", "rm_wrenfield_store"]
        },
        {
            id: "valemere",
            name: "Valemere",
            church: "",
            tavern: "The Salt Lamp",
            save_rooms: ["rm_salt_lamp"],
            rooms: ["rm_valemere", "rm_salt_lamp", "rm_warehouse"]
        }
    ];
}

/// The town a room (with position, for rm_overworld) belongs to. `undefined` when it is not
/// inside a listed town.
function scr_save_town_of_room(_room_name, _px = 0, _py = 0) {
    var _towns = scr_save_towns();
    var _name = string(_room_name);
    if (_name == "rm_overworld") {
        var _loc = scr_save_location_name(_name, _px, _py);
        for (var _t = 0; _t < array_length(_towns); _t++) {
            if (_towns[_t].name == _loc) return _towns[_t];
        }
        return undefined;
    }
    for (var _t2 = 0; _t2 < array_length(_towns); _t2++) {
        var _rooms = _towns[_t2].rooms;
        for (var _r = 0; _r < array_length(_rooms); _r++) {
            if (_rooms[_r] == _name) return _towns[_t2];
        }
    }
    return undefined;
}

/// The town the player is standing in, or `undefined`.
function scr_save_town_here() {
    var _px = instance_exists(obj_player) ? obj_player.x : 0;
    var _py = instance_exists(obj_player) ? obj_player.y : 0;
    return scr_save_town_of_room(room_get_name(room), _px, _py);
}

/// True when this town has a church or a tavern (the first half of the saving requirement).
function scr_save_town_allows_save(_town) {
    if (!is_struct(_town)) return false;
    var _church = variable_struct_exists(_town, "church") ? string(_town.church) : "";
    var _tavern = variable_struct_exists(_town, "tavern") ? string(_town.tavern) : "";
    return (_church != "" || _tavern != "");
}

/// True when `_room_name` is one of the town's save rooms (a church or tavern interior).
/// Second half of the requirement: the town square is not a save location, the crystal is.
function scr_save_room_allows_save(_town, _room_name) {
    if (!is_struct(_town)) return false;
    if (!variable_struct_exists(_town, "save_rooms") || !is_array(_town.save_rooms)) return false;
    var _here = string(_room_name);
    for (var _i = 0; _i < array_length(_town.save_rooms); _i++) {
        if (string(_town.save_rooms[_i]) == _here) return true;
    }
    return false;
}

/// True when the save / load menu may open at the player's current position: the player must be
/// inside a town's church or tavern (the room that holds its save crystal).
/// Title-screen Continue calls scr_save_load() directly and is not affected.
function scr_save_allowed_here() {
    if (room == TITLE_ROOM || room == BATTLE_ROOM) return false;
    if (variable_global_exists("game") && is_struct(global.game) && global.game.battle_active) return false;
    var _town = scr_save_town_here();
    if (!scr_save_town_allows_save(_town)) return false;
    return scr_save_room_allows_save(_town, room_get_name(room));
}

/// Shown when the player deliberately tries to save outside a save room (a town's church or tavern).
function scr_save_blocked_line() {
    return "No shrine, no hearth. Save only at a crystal inside a town's church or tavern.";
}

/// Write `_data` (a struct) to slot `_slot`. Returns true on success.
function scr_save_write(_slot) {
    if (room == TITLE_ROOM || room == BATTLE_ROOM) return false;
    if (variable_global_exists("game") && is_struct(global.game) && global.game.battle_active) return false;
    // Owner decision 2026-11-15: only a town's church or tavern (its save room) can save.
    if (!scr_save_allowed_here()) {
        show_debug_message("[save] blocked in " + room_get_name(room) + ": not a town's church or tavern.");
        return false;
    }
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
        saved_at_epoch: 0,             // numeric save time; 0 when absent (older saves)
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
    _info.saved_at_epoch = (variable_struct_exists(_data, "saved_at_epoch") && is_real(_data.saved_at_epoch)) ? _data.saved_at_epoch : 0;
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

/// Entry point for New Game. One reset, one starting-equipment pass; the title's
/// double-click guard sits in front of this. Starting flags / quests intentionally
/// stay empty: the overworld arrival marker starts Q_MAIN_FIND_MIRA and sets its flags.
function scr_new_game_start() {
    scr_game_state_reset();
    var _g = global.game;
    var _kael = scr_roster_find(_g.roster, "kael");
    if (is_struct(_kael)) {
        _kael.equipment.weapon = "item_kaels_longsword";
        scr_actor_refresh_equipment(_kael);
    }
    _g.playtime_frames = 0;
    _g.gold = 0;
    return _g;
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
        _actor.equipment.off_hand = variable_struct_exists(_snap.equipment, "off_hand") ? string(_snap.equipment.off_hand) : "";
        _actor.equipment.legs = variable_struct_exists(_snap.equipment, "legs") ? string(_snap.equipment.legs) : "";
        _actor.equipment.accessory_2 = variable_struct_exists(_snap.equipment, "accessory_2") ? string(_snap.equipment.accessory_2) : "";
    }
    // Schema v4: base maxima, derived-stat bases and proficiencies (missing = keep current).
    // Pre-v4 saves have no base_max_hp / base_max_mp. Their saved max_hp / max_mp were the
    // un-equipped values (v1-v3 gear had no HP/MP bonuses), so seed the v4 bases from them.
    // Without this, scr_actor_refresh_equipment() rebuilt max HP/MP from the fresh level-1
    // roster and a migrated save lost all level growth.
    if (variable_struct_exists(_snap, "base_max_hp")) {
        _actor.base_max_hp = max(1, _snap.base_max_hp);
    } else if (variable_struct_exists(_snap, "max_hp")) {
        _actor.base_max_hp = max(1, _snap.max_hp);
    }
    if (variable_struct_exists(_snap, "base_max_mp")) {
        _actor.base_max_mp = max(0, _snap.base_max_mp);
    } else if (variable_struct_exists(_snap, "max_mp")) {
        _actor.base_max_mp = max(0, _snap.max_mp);
    }
    // v1-v3 had no MAG: magic skills resolved off final ATK, gear included. Carry that saved
    // ATK into the new base MAG so a migrated caster keeps the damage curve they had before
    // schema v4. Fall back to base_attack for a hand-edited snapshot without `attack`.
    if (!variable_struct_exists(_snap, "base_magic")) {
        if (variable_struct_exists(_snap, "attack")) {
            _actor.base_magic = _snap.attack;
        } else if (variable_struct_exists(_snap, "base_attack")) {
            _actor.base_magic = _snap.base_attack;
        }
    }
    if (variable_struct_exists(_snap, "base_magic")) _actor.base_magic = _snap.base_magic;
    if (variable_struct_exists(_snap, "base_acc")) _actor.base_acc = _snap.base_acc;
    if (variable_struct_exists(_snap, "base_eva")) _actor.base_eva = _snap.base_eva;
    if (variable_struct_exists(_snap, "base_crit")) _actor.base_crit = _snap.base_crit;
    if (variable_struct_exists(_snap, "armor_profs") && is_array(_snap.armor_profs)) _actor.armor_profs = _snap.armor_profs;
    if (variable_struct_exists(_snap, "shield_prof")) _actor.shield_prof = _snap.shield_prof;
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
    // API-created gear and edited saves must not put an unknown id or a mismatched slot back
    // into the equipment struct. Ensure the legacy keys first (Iron Helm migration), then check.
    scr_actor_ensure_bases(_actor);
    scr_save_sanitize_equipment(_actor);
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
    if (_data.save_schema_version < 3) {
        // v3 -> Bestiary log. An older save simply has not met anything yet.
        if (!variable_struct_exists(_data, "bestiary") || !is_struct(_data.bestiary)) _data.bestiary = {};
        _data.save_schema_version = 3;
        show_debug_message("[save] migrated a pre-v3 save to v3 (bestiary log).");
    }
    if (_data.save_schema_version < 4) {
        // v4 -> seven equipment slots + base maxima. apply_member supplies the missing defaults,
        // and scr_actor_ensure_bases seeds base_max_hp from the saved max_hp.
        _data.save_schema_version = 4;
        show_debug_message("[save] migrated a pre-v4 save to v4 (equipment slots).");
    }
    return _data;
}

/// Save side of the standard record: only the stable id and quantity are written. Names and
/// key/unique flags are resolved from the item database on load, so a renamed item cannot leave a
/// stale copy in a save file.
function scr_save_inventory_snapshot(_inventory) {
    var _out = [];
    if (!is_array(_inventory)) return _out;
    for (var _i = 0; _i < array_length(_inventory); _i++) {
        var _entry = _inventory[_i];
        if (!is_struct(_entry)) continue;
        var _id = variable_struct_exists(_entry, "item_id") ? scr_item_id_norm(_entry.item_id) : "";
        if (_id == "") continue;
        var _qty = 1;
        if (variable_struct_exists(_entry, "qty") && is_real(_entry.qty)) _qty = max(1, floor(_entry.qty));
        array_push(_out, { item_id: _id, qty: _qty });
    }
    return _out;
}

function scr_save_warn(_message) {
    if (!variable_global_exists("save_load_warnings") || !is_array(global.save_load_warnings)) {
        global.save_load_warnings = [];
    }
    array_push(global.save_load_warnings, string(_message));
    show_debug_message("[save] " + string(_message));
}

/// Rebuild a saved inventory from ids + quantities. Unknown ids are dropped with a warning;
/// stackable items merge into one row, gear keeps one row per copy, and key/unique status is
/// re-derived from the database instead of trusted from the file.
function scr_save_sanitize_inventory(_inventory) {
    var _out = [];
    if (!is_array(_inventory)) return _out;
    var _total = {};
    var _first = [];
    for (var _i = 0; _i < array_length(_inventory); _i++) {
        var _entry = _inventory[_i];
        if (!is_struct(_entry)) { scr_save_warn("dropped a non-struct inventory entry"); continue; }
        var _id = variable_struct_exists(_entry, "item_id") ? scr_item_id_norm(_entry.item_id) : "";
        if (_id == "" || !scr_item_exists(_id)) {
            scr_save_warn("dropped unknown inventory item '" + _id + "'");
            continue;
        }
        var _it = scr_item_get(_id);
        var _qty = 1;
        if (variable_struct_exists(_entry, "qty") && is_real(_entry.qty)) _qty = floor(_entry.qty);
        if (_qty < 1) _qty = 1;
        if (_it.unique || _it.key_item) {
            if (_qty > 1) scr_save_warn("clamped " + _id + " to one copy (unique/key item)");
            _qty = 1;
        }
        if (_it.stackable) {
            if (!variable_struct_exists(_total, _id)) {
                _total[$ _id] = 0;
                array_push(_first, _id);
            }
            _total[$ _id] = _total[$ _id] + _qty;
        } else {
            for (var _c = 0; _c < _qty; _c++) {
                array_push(_out, { item_id: _id, name: _it.name, qty: 1, key_item: _it.key_item || _it.unique });
            }
        }
    }
    for (var _f = 0; _f < array_length(_first); _f++) {
        var _sid = _first[_f];
        var _sit = scr_item_get(_sid);
        array_push(_out, { item_id: _sid, name: _sit.name, qty: _total[$ _sid], key_item: _sit.key_item || _sit.unique });
    }
    return _out;
}

/// Clear equipped ids that no longer exist, no longer fit the slot, or conflict with a
/// two-handed main hand. Runs after scr_actor_ensure_bases() and before the stat refresh.
function scr_save_sanitize_equipment(_actor) {
    if (!is_struct(_actor) || !is_struct(_actor.equipment)) return;
    var _slots = [
        ["weapon", "main_hand"], ["off_hand", "off_hand"], ["helm", "head"],
        ["armor", "body"], ["legs", "legs"], ["accessory", "accessory"],
        ["accessory_2", "accessory"]
    ];
    for (var _i = 0; _i < array_length(_slots); _i++) {
        var _key = _slots[_i][0];
        var _want = _slots[_i][1];
        if (!variable_struct_exists(_actor.equipment, _key)) { _actor.equipment[$ _key] = ""; continue; }
        var _id = _actor.equipment[$ _key];
        if (!is_string(_id) || _id == "") { _actor.equipment[$ _key] = ""; continue; }
        _id = scr_item_id_norm(_id);
        if (!scr_item_exists(_id)) {
            scr_save_warn("cleared unknown equipped item '" + _id + "' from " + _key);
            _actor.equipment[$ _key] = "";
            continue;
        }
        var _slot = scr_item_slot(_id);
        var _fits = scr_item_is_equipment(_id)
            && ((_want == "accessory") ? (_slot == "accessory") : (_slot == _want));
        if (!_fits) {
            scr_save_warn("cleared " + _id + " from " + _key + ": wrong slot");
            _actor.equipment[$ _key] = "";
            continue;
        }
        _actor.equipment[$ _key] = _id;
    }
    var _main = variable_struct_exists(_actor.equipment, "weapon") ? string(_actor.equipment.weapon) : "";
    var _off = variable_struct_exists(_actor.equipment, "off_hand") ? string(_actor.equipment.off_hand) : "";
    if (_main != "" && _off != "" && scr_item_get(_main).two_handed) {
        scr_save_warn("cleared off-hand " + _off + ": " + _main + " is two-handed");
        _actor.equipment.off_hand = "";
    }
}

function scr_save_apply(_data) {
    scr_game_state_reset();
    var _g = global.game;
    global.save_load_warnings = [];
    if (variable_struct_exists(_data, "gold")) _g.gold = max(0, _data.gold);
    if (variable_struct_exists(_data, "inventory") && is_array(_data.inventory)) {
        _g.inventory = scr_save_sanitize_inventory(_data.inventory);
    }
    if (variable_struct_exists(_data, "flags") && is_struct(_data.flags)) _g.flags = _data.flags;
    if (variable_struct_exists(_data, "cleared_encounters") && is_struct(_data.cleared_encounters)) {
        _g.cleared_encounters = _data.cleared_encounters;
    }
    // Schema v3: Bestiary log (empty on pre-v3 saves; the migration above guarantees the field).
    if (variable_struct_exists(_data, "bestiary") && is_struct(_data.bestiary)) {
        _g.bestiary = _data.bestiary;
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

/// Load one sanitized migration fixture from Included Files. Development-only helper for
/// scr_save_migration_test(); never reads a player save or anything outside tests/saves.
function scr_save_test_load_json(_relative_path) {
    if (!file_exists(_relative_path)) {
        show_debug_message("[save-test] missing fixture: " + _relative_path);
        return undefined;
    }
    var _buf = buffer_load(_relative_path);
    if (_buf == -1) {
        show_debug_message("[save-test] could not load fixture: " + _relative_path);
        return undefined;
    }
    buffer_seek(_buf, buffer_seek_start, 0);
    var _text = buffer_read(_buf, buffer_string);
    buffer_delete(_buf);
    try {
        return json_parse(_text);
    } catch (_e) {
        show_debug_message("[save-test] invalid JSON in " + _relative_path + ": " + string(_e));
        return undefined;
    }
}

/// In-engine regression test for the v1-v4 save contract. Run it from a debug build with
/// DEBUG_SAVE_SELFTEST (F6) or call it directly from the IDE. It uses the real migrate and
/// apply functions on sanitized fixtures, so it exercises the code shipped to players.
/// This is NOT a substitute for a full save/load playtest in GameMaker (not available in CI).
function scr_save_migration_test() {
    var _cases = [
        { file: "tests/saves/v1_kael.json", actor: "kael", weapon: "item_iron_sword", pre_v4: true },
        { file: "tests/saves/v2_kael.json", actor: "kael", weapon: "item_iron_sword", pre_v4: true },
        { file: "tests/saves/v3_kael.json", actor: "kael", weapon: "item_iron_sword", pre_v4: true },
        { file: "tests/saves/v4_caelan.json", actor: "caelan", weapon: "item_spellbook", pre_v4: false }
    ];
    var _failures = [];
    var _lines = [];
    for (var _i = 0; _i < array_length(_cases); _i++) {
        var _case = _cases[_i];
        var _data = scr_save_test_load_json(_case.file);
        if (!is_struct(_data)) {
            array_push(_failures, _case.file + ": could not load");
            continue;
        }
        var _before = variable_struct_exists(_data, "save_schema_version") ? _data.save_schema_version : -1;
        var _migrated = scr_save_migrate(_data);
        if (!is_struct(_migrated) || _migrated.save_schema_version != SAVE_SCHEMA_VERSION) {
            array_push(_failures, _case.file + ": migrated schema is not " + string(SAVE_SCHEMA_VERSION));
            continue;
        }
        if (!variable_struct_exists(_migrated, "roster") || !is_array(_migrated.roster) || array_length(_migrated.roster) == 0) {
            array_push(_failures, _case.file + ": migrated roster is empty");
            continue;
        }
        var _snap = _migrated.roster[0];
        if (!is_struct(_snap) || _snap.actor_id != _case.actor) {
            array_push(_failures, _case.file + ": unexpected roster actor");
            continue;
        }
        var _want_hp = variable_struct_exists(_snap, "max_hp") ? _snap.max_hp : 0;
        var _want_mp = variable_struct_exists(_snap, "max_mp") ? _snap.max_mp : 0;
        var _want_magic = 0;
        if (_case.pre_v4) {
            _want_magic = variable_struct_exists(_snap, "attack") ? _snap.attack : _snap.base_attack;
        } else {
            _want_magic = variable_struct_exists(_snap, "base_magic") ? _snap.base_magic : 0;
        }

        var _roster = scr_roster_create();
        var _actor = scr_roster_find(_roster, _case.actor);
        if (!is_struct(_actor)) {
            array_push(_failures, _case.file + ": actor not found in fresh roster");
            continue;
        }
        scr_save_apply_member(_actor, _snap);
        if (_actor.base_max_hp != _want_hp) {
            array_push(_failures, _case.file + ": base_max_hp " + string(_actor.base_max_hp) + " != " + string(_want_hp));
        }
        if (_actor.base_max_mp != _want_mp) {
            array_push(_failures, _case.file + ": base_max_mp " + string(_actor.base_max_mp) + " != " + string(_want_mp));
        }
        if (_actor.base_magic != _want_magic) {
            array_push(_failures, _case.file + ": base_magic " + string(_actor.base_magic) + " != " + string(_want_magic));
        }
        if (_actor.max_hp < _want_hp) {
            array_push(_failures, _case.file + ": lost max_hp (" + string(_actor.max_hp) + " < " + string(_want_hp) + ")");
        }
        if (_actor.max_mp < _want_mp) {
            array_push(_failures, _case.file + ": lost max_mp (" + string(_actor.max_mp) + " < " + string(_want_mp) + ")");
        }
        if (_actor.level != _snap.level) {
            array_push(_failures, _case.file + ": level changed");
        }
        if (_actor.xp != _snap.xp) {
            array_push(_failures, _case.file + ": xp changed");
        }
        if (_actor.equipment.weapon != _case.weapon) {
            array_push(_failures, _case.file + ": weapon slot " + string(_actor.equipment.weapon) + " != " + string(_case.weapon));
        }
        var _inv = scr_save_sanitize_inventory(variable_struct_exists(_migrated, "inventory") ? _migrated.inventory : []);
        if (array_length(_inv) != 1) {
            array_push(_failures, _case.file + ": inventory did not survive sanitization");
        } else if (_inv[0].qty != 3) {
            array_push(_failures, _case.file + ": inventory quantity changed");
        }
        show_debug_message("[save-test] " + _case.file + " v" + string(_before) + " -> v" + string(_migrated.save_schema_version) + " checked");
    }

    var _failed = array_length(_failures);
    array_push(_lines, "Save migration selftest: " + string(_failed == 0 ? "PASS" : "FAIL") + " (" + string(array_length(_cases) - _failed) + "/" + string(array_length(_cases)) + " fixtures).");
    for (var _f = 0; _f < _failed; _f++) array_push(_lines, "FAIL: " + _failures[_f]);
    if (_failed == 0) array_push(_lines, "v1-v4 base HP/MP/MAG and level were preserved by the real migration path.");
    for (var _l = 0; _l < array_length(_lines); _l++) show_debug_message("[save-test] " + _lines[_l]);
    return { passed: (_failed == 0), failed: _failed, lines: _lines };
}

/// Open the save / load panel. `_quiet` suppresses the "no shrine, no hearth" line for the
/// automatic chapter-end prompts, which simply do not happen outside a save room.
function scr_save_menu_open(_mode = "save", _prompt = false, _quiet = false) {
    // Owner decision 2026-11-15: save and load are only available inside a town's church or tavern.
    if (!scr_save_allowed_here()) {
        if (!_quiet) scr_dialogue_open([scr_save_blocked_line()], "");
        return noone;
    }
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
