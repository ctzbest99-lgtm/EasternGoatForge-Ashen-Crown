/// scr_ch1_art — Chapter 1 art helpers: enemy/NPC/item/portrait lookups, Blackguard
/// phases, battle backgrounds, and overworld binding. All sprite lookups go through
/// scr_sprite_index / asset_get_index so a missing import cannot crash.

function scr_ch1_npc_stem(_npc_id, _name = "") {
    var _id = is_string(_npc_id) ? _npc_id : "";
    if (_id == "" && is_string(_name)) _id = _name;
    switch (_id) {
        case "tomas_varyn": return "tomas_varyn";
        case "pell": return "pell";
        case "old_hunter_renn":
        case "renn": return "renn";
        case "hob": return "hob";
        case "sister_ilse":
        case "ilse": return "ilse";
        case "marda": return "marda";
        case "old_wenna":
        case "wenna": return "wenna";
        case "dov": return "dov";
        case "corwin": return "corwin";
        case "fallen_knight_story": return "fallen_knight_story";
    }
    return "";
}

function scr_ch1_apply_ow_sprite(_inst, _stem, _dir = "down") {
    if (_inst == noone || !instance_exists(_inst) || _stem == "") return false;
    var _idle = scr_sprite_index("spr_" + _stem + "_ow16_idle_" + _dir);
    if (!scr_sprite_is_valid(_idle)) return false;
    _inst.sprite_index = _idle;
    _inst.mask_index = _idle;
    _inst.image_xscale = 1;
    _inst.image_yscale = 1;
    _inst.image_speed = 0;
    _inst.image_index = 0;
    _inst.visible = true;
    if (variable_instance_exists(_inst, "x")) _inst.depth = -_inst.y;
    return true;
}

/// Re-place an instance so the sprite origin's feet sit on (_feet_x, _feet_y). No scaling.
function scr_ch1_place_at_feet(_inst, _feet_x, _feet_y) {
    if (_inst == noone || !instance_exists(_inst)) return;
    var _spr = _inst.sprite_index;
    var _ox = 0;
    var _oy = 0;
    var _sw = 16;
    var _sh = 16;
    if (scr_sprite_is_valid(_spr)) {
        _ox = sprite_get_xoffset(_spr);
        _oy = sprite_get_yoffset(_spr);
        _sw = sprite_get_width(_spr);
        _sh = sprite_get_height(_spr);
    }
    _inst.image_xscale = 1;
    _inst.image_yscale = 1;
    _inst.x = _feet_x - (_sw * 0.5 - _ox);
    _inst.y = _feet_y - (_sh - _oy);
    _inst.depth = -_feet_y;
}

function scr_ch1_bind_npc_ow(_inst, _npc_id, _name, _marker = undefined) {
    if (_inst == noone || !instance_exists(_inst)) return;
    var _stem = scr_ch1_npc_stem(_npc_id, _name);
    if (_stem == "") return;
    var _fx = (is_struct(_marker) && variable_struct_exists(_marker, "x")) ? _marker.x : _inst.x;
    var _fy = (is_struct(_marker) && variable_struct_exists(_marker, "y")) ? _marker.y : _inst.y;
    var _dir = "down";
    if (is_struct(_marker) && variable_struct_exists(_marker, "facing")) _dir = string(_marker.facing);
    _inst.ch1_stem = _stem;
    _inst.ch1_dir = _dir;
    _inst.ch1_lying = (_stem == "tomas_varyn");
    if (_inst.ch1_lying) {
        var _lie = scr_sprite_index("spr_tomas_varyn_ow16_lying_strip2");
        if (scr_sprite_is_valid(_lie)) {
            _inst.sprite_index = _lie;
            _inst.mask_index = _lie;
            _inst.image_xscale = 1;
            _inst.image_yscale = 1;
            _inst.visible = true;
            var _fps = game_get_speed(gamespeed_fps);
            _inst.image_speed = (_fps > 0) ? (1.5 / _fps) : 0; // slow breathing
            scr_ch1_place_at_feet(_inst, _fx, _fy);
            return;
        }
    }
    if (scr_ch1_apply_ow_sprite(_inst, _stem, _dir)) {
        scr_ch1_place_at_feet(_inst, _fx, _fy);
    }
}

function scr_ch1_bind_enemy_ow(_inst, _enemy_id, _marker = undefined) {
    if (_inst == noone || !instance_exists(_inst) || !is_string(_enemy_id)) return;
    var _stem = _enemy_id;
    var _dir = "down";
    if (is_struct(_marker) && variable_struct_exists(_marker, "facing")) _dir = string(_marker.facing);
    var _idle = scr_sprite_index("spr_" + _stem + "_ow16_idle_" + _dir, "spr_" + _stem + "_ow_idle_" + _dir);
    // Blackguard uses spr_blackguard_ow16_*
    if (!scr_sprite_is_valid(_idle) && _stem == "blackguard") {
        _idle = scr_sprite_index("spr_blackguard_ow16_idle_" + _dir);
    }
    if (!scr_sprite_is_valid(_idle)) return;
    _inst.sprite_index = _idle;
    _inst.mask_index = _idle;
    _inst.image_xscale = 1;
    _inst.image_yscale = 1;
    _inst.image_speed = 0;
    _inst.visible = true;
    var _fx = (is_struct(_marker) && variable_struct_exists(_marker, "x")) ? _marker.x : _inst.x;
    var _fy = (is_struct(_marker) && variable_struct_exists(_marker, "y")) ? _marker.y : _inst.y;
    scr_ch1_place_at_feet(_inst, _fx, _fy);
}

function scr_ch1_chest_is_iron(_marker) {
    if (!is_struct(_marker)) return false;
    var _n = variable_struct_exists(_marker, "name") ? string(_marker.name) : "";
    if (string_pos("watchtower", _n) > 0 || string_pos("basement", _n) > 0 || string_pos("iron", _n) > 0) return true;
    var _rn = room_get_name(room);
    if (string_pos("watchtower", _rn) > 0 || string_pos("basement", _rn) > 0) return true;
    return false;
}

function scr_ch1_bind_chest(_inst, _marker, _open = false) {
    if (_inst == noone || !instance_exists(_inst)) return;
    var _iron = scr_ch1_chest_is_iron(_marker);
    var _spr;
    if (_open) {
        _spr = scr_sprite_index(_iron ? "spr_chest_iron_open" : "spr_chest_wood_open");
    } else {
        _spr = scr_sprite_index(_iron ? "spr_chest_iron_closed" : "spr_chest_wood_closed");
    }
    if (!scr_sprite_is_valid(_spr)) return;
    _inst.sprite_index = _spr;
    _inst.image_xscale = 1;
    _inst.image_yscale = 1;
    _inst.image_speed = 0;
    _inst.image_index = 0;
    _inst.visible = true;
    _inst.ch1_chest = true;
    _inst.ch1_chest_iron = _iron;
    _inst.ch1_chest_open = _open;
    var _fx = (is_struct(_marker) && variable_struct_exists(_marker, "x")) ? _marker.x : _inst.x;
    var _fy = (is_struct(_marker) && variable_struct_exists(_marker, "y")) ? _marker.y : _inst.y;
    scr_ch1_place_at_feet(_inst, _fx, _fy);
}

function scr_ch1_chest_play_open(_inst) {
    if (_inst == noone || !instance_exists(_inst)) return;
    var _iron = variable_instance_exists(_inst, "ch1_chest_iron") && _inst.ch1_chest_iron;
    var _spr = scr_sprite_index(_iron ? "spr_chest_iron_open_strip3" : "spr_chest_wood_open_strip3");
    if (scr_sprite_is_valid(_spr)) {
        _inst.sprite_index = _spr;
        _inst.image_index = 0;
        var _fps = game_get_speed(gamespeed_fps);
        _inst.image_speed = (_fps > 0) ? (10 / _fps) : 0;
        _inst.ch1_chest_opening = true;
    } else {
        var _open = scr_sprite_index(_iron ? "spr_chest_iron_open" : "spr_chest_wood_open");
        if (scr_sprite_is_valid(_open)) _inst.sprite_index = _open;
        _inst.ch1_chest_open = true;
    }
}

function scr_ch1_item_sprite(_item_id) {
    if (!is_string(_item_id) || _item_id == "") return -1;
    var _key = _item_id;
    if (string_copy(_key, 1, 5) == "item_") _key = string_delete(_key, 1, 5);
    switch (_key) {
        case "mira_wooden_pendant":
        case "mira_pendant": return scr_sprite_index("spr_item_mira_pendant");
        case "blackguard_longsword":
        case "blackguards_longsword": return scr_sprite_index("spr_item_blackguards_longsword");
        case "watchtower_key": return scr_sprite_index("spr_item_watchtower_key");
        case "ashbound_parchment": return scr_sprite_index("spr_item_ashbound_parchment");
        case "crownveil_fragment": return scr_sprite_index("spr_item_crownveil_fragment");
        case "minor_potion": return scr_sprite_index("spr_item_minor_potion");
        case "antidote": return scr_sprite_index("spr_item_antidote");
        case "iron_sword": return scr_sprite_index("spr_item_iron_sword");
        case "kaels_longsword": return scr_sprite_index("spr_item_kaels_longsword");
        case "hunters_knife": return scr_sprite_index("spr_item_hunters_knife");
        case "hunters_charm": return scr_sprite_index("spr_item_hunters_charm");
        case "ashen_longbow": return scr_sprite_index("spr_item_ashen_longbow");
        case "ashen_arrow": return scr_sprite_index("spr_item_ashen_arrow");
        case "blackened_feather": return scr_sprite_index("spr_item_blackened_feather");
        case "leather_armor": return scr_sprite_index("spr_item_leather_armor");
        case "iron_helm": return scr_sprite_index("spr_item_iron_helm");
        case "gold": return scr_sprite_index("spr_item_gold");
    }
    return scr_sprite_index("spr_item_" + _key);
}

/// Portrait for a dialogue speaker. Expression defaults to "neutral".
function scr_ch1_portrait(_speaker, _expr = "neutral") {
    if (!is_string(_speaker) || _speaker == "") return -1;
    var _who = string_lower(string_trim(_speaker));
    var _stem = "";
    if (_who == "kael") _stem = "kael";
    else if (_who == "tomas" || _who == "tomas varyn") _stem = "tomas_varyn";
    else if (_who == "pell") _stem = "pell";
    else if (_who == "renn" || _who == "old hunter renn" || _who == "old renn") _stem = "renn";
    else if (_who == "fallen knight") _stem = "fallen_knight_story";
    else if (_who == "reeve calder" || _who == "calder") _stem = "reeve_calder"; // neutral / stern / weary (Design batch 6)
    if (_stem == "") return -1;
    var _spr = scr_sprite_index("spr_portrait_" + _stem + "_" + _expr);
    if (!scr_sprite_is_valid(_spr)) _spr = scr_sprite_index("spr_portrait_" + _stem + "_neutral");
    // Design filenames are spr_portrait_<name>_<expr> — also try unsuffixed folder names
    if (!scr_sprite_is_valid(_spr)) {
        var _alt = "spr_portrait_";
        if (_stem == "tomas_varyn") _alt += "tomas_" + _expr;
        else if (_stem == "fallen_knight_story") _alt += "fallen_knight_" + _expr;
        else _alt += _stem + "_" + _expr;
        _spr = scr_sprite_index(_alt);
    }
    return scr_sprite_is_valid(_spr) ? _spr : -1;
}

function scr_ch1_battle_area(_enemy_id, _encounter_id = "") {
    if (_enemy_id == "blackguard" || string_pos("blackguard", _encounter_id) > 0) return "blackguard_arena";
    // Act II stand-ins until Design paints Millhaven Road / Wrenfield backgrounds:
    // Wrenfield (and the Calder fight) use the Greyhaven village bg, as in Design's Calder mockup.
    if (_enemy_id == "reeve_calder" || string_pos("calder", _encounter_id) > 0 || string_pos("wrenfield", _encounter_id) > 0) return "greyhaven";
    var _rn = room_get_name(room);
    if (string_pos("basement", _rn) > 0) return "watchtower";
    if (string_pos("watchtower", _rn) > 0) return "watchtower";
    if (string_pos("greyhaven", _rn) > 0) return "greyhaven";
    // Prefer the encounter zone the player is standing in.
    if (instance_exists(obj_player) && instance_exists(obj_encounter_zone)) {
        var _z = instance_place(obj_player.x, obj_player.y, obj_encounter_zone);
        if (_z != noone && variable_instance_exists(_z, "table_id")) {
            var _tid = string(_z.table_id);
            if (string_pos("farmland", _tid) > 0) return "greyhaven";
            if (string_pos("old_road", _tid) > 0) return "forest";
            if (string_pos("bandit", _tid) > 0) return "bandit_camp";
            if (string_pos("watchtower", _tid) > 0) return "watchtower";
            if (string_pos("wrenfield", _tid) > 0) return "greyhaven";
            if (string_pos("millhaven", _tid) > 0) return "forest";
        }
    }
    if (string_pos("farm", _encounter_id) > 0 || string_pos("greyhaven", _encounter_id) > 0) return "greyhaven";
    if (string_pos("road", _encounter_id) > 0 || string_pos("forest", _encounter_id) > 0) return "forest";
    if (string_pos("bandit", _encounter_id) > 0 || string_pos("camp", _encounter_id) > 0) return "bandit_camp";
    if (string_pos("watch", _encounter_id) > 0 || string_pos("hunter", _encounter_id) > 0) return "watchtower";
    return "forest";
}

function scr_ch1_battle_bg(_area) {
    switch (_area) {
        case "greyhaven": return scr_sprite_index("spr_bg_battle_greyhaven");
        case "bandit_camp": return scr_sprite_index("spr_bg_battle_bandit_camp");
        case "watchtower": return scr_sprite_index("spr_bg_battle_watchtower");
        case "blackguard_arena": return scr_sprite_index("spr_bg_battle_blackguard_arena");
        default: return scr_sprite_index("spr_bg_battle_forest");
    }
}

function scr_blackguard_phase_for_hp(_hp, _max) {
    if (_max <= 0) return 1;
    if (_hp <= _max * BLACKGUARD_PHASE3_HP_PCT) return 3;
    if (_hp <= _max * BLACKGUARD_PHASE2_HP_PCT) return 2;
    return 1;
}

function scr_blackguard_apply_phase(_enemy, _phase) {
    if (!is_struct(_enemy)) return;
    if (!variable_struct_exists(_enemy, "base_attack")) _enemy.base_attack = _enemy.attack;
    if (!variable_struct_exists(_enemy, "base_defense")) _enemy.base_defense = _enemy.defense;
    _enemy.phase = _phase;
    // Phase 2: attack up, shield lost (defense down). Phase 3 canon: ATK +40%, DEF −20%.
    // Speed +30% (canon) is speed_mod, applied to SPD turn order by scr_battle_stat (battle upgrade).
    if (_phase <= 1) {
        _enemy.attack = _enemy.base_attack;
        _enemy.defense = _enemy.base_defense;
        _enemy.speed_mod = 1;
    } else if (_phase == 2) {
        _enemy.attack = max(1, round(_enemy.base_attack * 1.25));
        _enemy.defense = max(1, round(_enemy.base_defense * 0.7));
        _enemy.speed_mod = 1;
    } else {
        _enemy.attack = max(1, round(_enemy.base_attack * 1.4));
        _enemy.defense = max(1, round(_enemy.base_defense * 0.8));
        _enemy.speed_mod = 1.3;
    }
}

function scr_blackguard_pick_anim(_phase) {
    if (_phase <= 1) return (irandom(2) == 0) ? "shieldbash" : "attack";
    if (_phase == 2) {
        var _r = irandom(2);
        if (_r == 0) return "attack";
        if (_r == 1) return "lunge";
        return "oath";
    }
    return (irandom(1) == 0) ? "attack" : "execution";
}

function scr_blackguard_anim_label(_anim) {
    switch (_anim) {
        case "shieldbash": return "Shield Bash";
        case "lunge": return "Dark Lunge";
        case "oath": return "Blood Oath";
        case "execution": return "Execution";
        default: return "attacks";
    }
}

function scr_blackguard_phase_line(_to) {
    if (_to == 2) return "The Blackguard's helmet cracks. Ash pours from the armour!";
    if (_to == 3) return "The Blackguard is engulfed in Ash!";
    return "";
}


function scr_ch1_battle_spawn_special_fx(_hit) {
    if (!is_struct(_hit)) return;
    if (!instance_exists(obj_battle_controller)) return;
    var _ctrl = instance_find(obj_battle_controller, 0);
    if (_ctrl == noone) return;
    var _anim = variable_struct_exists(_hit, "anim") ? _hit.anim : "attack";
    var _kind = variable_struct_exists(_hit, "enemy_kind") ? _hit.enemy_kind : "";
    // Multi-enemy battles pass the attacker's feet (fx_from) and the target's feet (fx_to).
    var _ef = (variable_struct_exists(_hit, "fx_from") && is_struct(_hit.fx_from)) ? _hit.fx_from : scr_battle_layout_enemy_feet();
    var _pi = variable_struct_exists(_hit, "party_index") ? _hit.party_index : 0;
    var _pf = (variable_struct_exists(_hit, "fx_to") && is_struct(_hit.fx_to)) ? _hit.fx_to : scr_battle_layout_party_feet(_pi);

    if (_kind == "crown_crossbowman" && _anim == "attack") {
        // Bolt: 16×8, origin (15, 4) at the tip, 12 fps loop in flight. Spawned on attack frame 3.
        var _bolt = scr_sprite_index("spr_crown_crossbowman_bolt_strip3");
        if (scr_sprite_is_valid(_bolt)) {
            array_push(_ctrl.battle_fx, {
                sprite: _bolt, frame: 0, frames: 3, fps: 12,
                x: _ef.x + 14, y: _ef.y - 26, x0: _ef.x + 14, y0: _ef.y - 26,
                tx: _pf.x - 6, ty: _pf.y - 20, t: 0, life: 12, xscale: 1
            });
        }
    }

    if (_kind == "ashbound_hunter" && _anim == "attack") {
        var _spr = scr_sprite_index("spr_ashbound_hunter_arrow_strip3");
        if (scr_sprite_is_valid(_spr)) {
            array_push(_ctrl.battle_fx, {
                sprite: _spr, frame: 0, frames: 3, fps: 12,
                x: _ef.x, y: _ef.y - 20, x0: _ef.x, y0: _ef.y - 20,
                tx: _pf.x, ty: _pf.y - 20, t: 0, life: 18, xscale: 1
            });
        }
    }
    if (_kind == "grave_spider" && _anim == "cast") {
        var _web = scr_sprite_index("spr_grave_spider_web_proj_strip3");
        if (scr_sprite_is_valid(_web)) {
            array_push(_ctrl.battle_fx, {
                sprite: _web, frame: 0, frames: 3, fps: 10,
                x: _ef.x, y: _ef.y - 8, x0: _ef.x, y0: _ef.y - 8,
                tx: _pf.x, ty: _pf.y - 12, t: 0, life: 24, xscale: 1
            });
        }
        var _ling = scr_sprite_index("spr_spiderling_idle_strip4");
        if (scr_sprite_is_valid(_ling)) {
            array_push(_ctrl.battle_fx, {
                sprite: _ling, frame: 0, frames: 4, fps: 6,
                x: _ef.x + 14, y: _ef.y + 2, t: 0, life: 90, xscale: 1
            });
            array_push(_ctrl.battle_fx, {
                sprite: _ling, frame: 2, frames: 4, fps: 6,
                x: _ef.x - 10, y: _ef.y + 4, t: 0, life: 90, xscale: 1
            });
        }
    }
}

/// First existing speaker portrait, or -1. Tries Design's shorter Tomas / Fallen Knight names.
function scr_ch1_portrait_or_none(_speaker) {
    return scr_ch1_portrait(_speaker, "neutral");
}
