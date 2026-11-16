/// scr_inventory — party bag. Key items cannot be sold or dropped.

function scr_inventory_find(_item_id) {
    scr_game_state_init();
    var _inv = global.game.inventory;
    for (var _i = 0; _i < array_length(_inv); _i++) {
        if (is_struct(_inv[_i]) && _inv[_i].item_id == _item_id) return _i;
    }
    return -1;
}

function scr_inventory_has(_item_id) {
    return scr_inventory_find(_item_id) != -1;
}

/// Add an item. Key items are unique: a second add does nothing and returns false.
function scr_inventory_add(_item_id, _name, _qty = 1, _key_item = false) {
    scr_game_state_init();
    var _inv = global.game.inventory;
    var _index = scr_inventory_find(_item_id);
    if (_index != -1) {
        if (_inv[_index].key_item || _key_item) return false;
        _inv[_index].qty += max(1, _qty);
        return true;
    }
    array_push(_inv, {
        item_id: _item_id,
        name: _name,
        qty: max(1, _qty),
        key_item: _key_item
    });
    return true;
}


/// True when the chest's loot is still a Design placeholder (do not invent items).
function scr_loot_is_placeholder(_loot) {
    if (!is_array(_loot) || array_length(_loot) == 0) return false;
    for (var _i = 0; _i < array_length(_loot); _i++) {
        var _s = string(_loot[_i]);
        if (string_lower(_s) != "placeholder") return false;
    }
    return true;
}

/// Grant a loot list and/or a single item_id. Gold strings ("50 Gold") add to
/// global.game.gold. Key items: item_mira_pendant, item_watchtower_key,
/// item_ashbound_parchment, item_crownveil_fragment, item_blackguard_longsword.
function scr_loot_grant(_loot = undefined, _item_id = "", _item_name = "") {
    scr_game_state_init();
    if (_item_id != "") {
        var _key = (_item_id == "item_mira_pendant" || _item_id == "item_watchtower_key"
            || _item_id == "item_ashbound_parchment" || _item_id == "item_crownveil_fragment"
            || _item_id == "item_blackguard_longsword");
        var _nm = _item_name;
        if (_nm == "") _nm = scr_item_display_name(_item_id);
        scr_inventory_add(_item_id, _nm, 1, _key);
        scr_audio_sfx("item_get", 0.02);
    }
    if (!is_array(_loot)) return;
    if (scr_loot_is_placeholder(_loot)) return;
    for (var _i = 0; _i < array_length(_loot); _i++) {
        scr_loot_grant_entry(string(_loot[_i]));
    }
}

function scr_inventory_count(_item_id) {
    var _index = scr_inventory_find(_item_id);
    if (_index == -1) return 0;
    var _e = global.game.inventory[_index];
    return (is_struct(_e) && variable_struct_exists(_e, "qty")) ? _e.qty : 0;
}

/// Remove `_qty` of a stack. Key items refuse unless `_allow_key` is true (internal unequip only).
function scr_inventory_remove(_item_id, _qty = 1, _allow_key = false) {
    scr_game_state_init();
    var _index = scr_inventory_find(_item_id);
    if (_index == -1) return false;
    var _e = global.game.inventory[_index];
    if (!is_struct(_e)) return false;
    if (_e.key_item && !_allow_key) return false;
    var _n = max(1, floor(_qty));
    if (_e.qty < _n) return false;
    _e.qty -= _n;
    if (_e.qty <= 0) array_delete(global.game.inventory, _index, 1);
    return true;
}

function scr_item_display_name(_item_id) {
    if (variable_global_exists("item_db") && is_struct(global.item_db)) {
        var _id = scr_item_id_norm(_item_id);
        if (variable_struct_exists(global.item_db, _id)) return global.item_db[$ _id].name;
    }
    switch (_item_id) {
        case "item_mira_pendant": return "Mira's Wooden Pendant";
        case "item_watchtower_key": return "Watchtower Key";
        case "item_ashbound_parchment": return "Ashbound Parchment";
        case "item_minor_potion": return "Minor Potion";
        case "item_antidote": return "Antidote";
        case "item_iron_sword": return "Iron Sword";
        case "item_crownveil_fragment": return "Crownveil Fragment";
        case "item_blackguard_longsword": return "Blackguard's Longsword";
    }
    return _item_id;
}

function scr_loot_grant_entry(_text) {
    scr_game_state_init();
    var _s = string_trim(_text);
    if (_s == "" || string_lower(_s) == "placeholder") return;
    // "50 Gold"
    if (string_pos("Gold", _s) > 0 || string_pos("gold", _s) > 0) {
        var _amt = 0;
        var _digits = "";
        for (var _c = 1; _c <= string_length(_s); _c++) {
            var _ch = string_char_at(_s, _c);
            if (_ch >= "0" && _ch <= "9") _digits += _ch;
        }
        if (_digits != "") _amt = real(_digits);
        if (_amt > 0) {
            global.game.gold += _amt;
            scr_audio_sfx("coin", 0.03);
        }
        return;
    }
    var _qty = 1;
    var _name = _s;
    var _x = string_pos(" x", _s);
    if (_x > 0) {
        _name = string_trim(string_copy(_s, 1, _x - 1));
        var _qtxt = string_trim(string_delete(_s, 1, _x + 1));
        if (string_digits(_qtxt) == _qtxt && _qtxt != "") _qty = real(_qtxt);
    }
    var _id = "";
    var _key = false;
    switch (string_lower(_name)) {
        case "minor potion": _id = "item_minor_potion"; break;
        case "antidote": _id = "item_antidote"; break;
        case "iron sword": _id = "item_iron_sword"; break;
        case "watchtower key": _id = "item_watchtower_key"; _key = true; break;
        case "mira's wooden pendant":
        case "mira's pendant": _id = "item_mira_pendant"; _key = true; break;
        default: _id = "item_" + string_replace_all(string_lower(_name), " ", "_"); break;
    }
    scr_inventory_add(_id, _name, _qty, _key);
    scr_audio_sfx("item_get", 0.02);
}

/// Apply this interactable's item_id / loot and mark it looted. Destroys unique pickups.
function scr_pickup_from_instance(_inst) {
    if (_inst == noone || !instance_exists(_inst)) return;
    var _id = variable_instance_exists(_inst, "item_id") ? _inst.item_id : "";
    var _loot = variable_instance_exists(_inst, "loot") ? _inst.loot : undefined;
    var _flag = variable_instance_exists(_inst, "story_flag") ? _inst.story_flag : "";
    var _name = "";
    if (variable_instance_exists(_inst, "map_marker") && is_struct(_inst.map_marker)) _name = _inst.map_marker.name;
    scr_loot_grant(_loot, _id, "");
    if (_flag != "") scr_flag_set(_flag);
    if (_name != "") scr_flag_set("looted_" + _name);
    // Unique story items leave the world; generic chests stay as "[Empty.]" after looted_ flag.
    if (_id == "item_mira_pendant" || _id == "item_watchtower_key") {
        instance_destroy(_inst);
        return;
    }
    if (variable_instance_exists(_inst, "ch1_chest") && _inst.ch1_chest) {
        scr_ch1_chest_play_open(_inst);
    }
}

/// Overworld / dungeon pressure-plate damage. `_pct` is a percent of max HP.
/// Living active members only. Minimum 1 damage, HP never falls below 1 (cannot KO).
function scr_trap_apply_damage(_pct) {
    scr_game_state_init();
    var _party = scr_party_list_active();
    for (var _i = 0; _i < array_length(_party); _i++) {
        var _a = _party[_i];
        if (!is_struct(_a) || _a.hp <= 0) continue;
        var _dmg = max(1, floor(_a.max_hp * max(0, _pct) / 100));
        _a.hp = max(1, _a.hp - _dmg);
    }
}
