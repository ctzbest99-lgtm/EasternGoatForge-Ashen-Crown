/// scr_item_data — the single standardized item database (181 records: stats, effects, rarity, act,
/// source, equipment rules). Balance values are provisional where the design docs do not fix them;
/// each record's description and `acquisition` say what it is, and aliases preserve old save ids.
/// See docs/ITEM_DATABASE.md and docs/EQUIPMENT_PROGRESSION.md.

function scr_item_id_norm(_item_id) {
    var _s = string(_item_id);
    if (_s == "") return "";
    // The Blackguard's Longsword shipped with two ids. The plural is canonical; the older
    // singular id is an alias so saves, equipment and story grants made before the merge keep
    // resolving to the same record. Never delete the alias: it may already be in a save file.
    if (_s == "item_blackguard_longsword" || _s == "blackguard_longsword") return "item_blackguards_longsword";
    if (string_copy(_s, 1, 5) == "item_") return _s;
    return "item_" + _s;
}

function scr_item_make(_item_id, _name, _kind, _price, _extra = undefined) {
    var _it = {
        item_id: scr_item_id_norm(_item_id),
        name: _name,
        kind: _kind,          // "consumable" | "weapon" | "armor" | "helm" | "accessory" | "key" | "misc"
        category: "",         // six bag categories; derived from kind + slot below
        slot: "",             // canonical: main_hand | off_hand | head | body | legs | accessory
        two_handed: false,
        price: max(0, _price),
        sellable: true,
        key_item: false,
        heal: 0,
        cures_poison: false,
        mp_restore: 0,
        revive_pct: 0,        // 0.25 = Emberwake Feather, 0.50 = Ashenheart Plume
        atk_bonus: 0,
        def_bonus: 0,
        mdef_bonus: 0,
        spd_bonus: 0,
        mag_bonus: 0,
        acc_bonus: 0,
        eva_bonus: 0,
        crit_bonus: 0,
        hp_bonus: 0,
        mp_bonus: 0,
        elem_res: undefined,  // { fire, ice, lightning, holy, shadow } percent
        status_res: undefined,// { poison, bleed, sleep, blind, slow } percent
        armor_class: "",      // "light" | "medium" | "heavy"; "" = no armour proficiency needed
        weapon_categories: [],
        weapon_type: "",      // standard subtype: sword | greatsword | dagger | spear | ...
        stackable: false,     // derived in scr_item_finalize
        declared_effects: [], // authored standard effects, before materialization
        // Equipment progression metadata (docs/EQUIPMENT_PROGRESSION.md).
        rarity: "common",     // "common" | "uncommon" | "rare" | "legendary"
        act: 0,               // story act (1-8) this tier belongs to; 0 = starting / special
        classes: [],          // roster class_names that may equip it; empty = anyone
        unique: false,        // only one copy may exist; cannot be sold
        acquisition: "",      // short human-readable source, for docs and the report
        desc: ""
    };
    if (_kind == "key") {
        _it.key_item = true;
        _it.sellable = false;
    }
    // Category is derived after `_extra` is merged, so a shield declared as an off-hand weapon
    // still lands in the Armor category. An explicit `category` in `_extra` wins.
    switch (_kind) {
        case "weapon":      _it.slot = "main_hand"; break;
        case "armor":       _it.slot = "body";      break;
        case "helm":        _it.slot = "head";      break;
        case "accessory":   _it.slot = "accessory"; break;
    }
    if (is_struct(_extra)) {
        var _names = variable_struct_get_names(_extra);
        for (var _i = 0; _i < array_length(_names); _i++) {
            _it[$ _names[_i]] = _extra[$ _names[_i]];
        }
    }
    // Standard record authoring: a `stats` struct and an `effects` array are accepted in
    // addition to the compact flat fields every existing item uses. Both are folded into the
    // typed fields here, then materialized by scr_item_finalize().
    if (variable_struct_exists(_it, "stats") && is_struct(_it.stats)) {
        var _stat_keys = scr_item_stat_keys();
        for (var _s = 0; _s < array_length(_stat_keys); _s++) {
            var _sk = _stat_keys[_s];
            if (variable_struct_exists(_it.stats, _sk)) {
                var _field = scr_item_stat_field(_sk);
                if (_field != "") _it[$ _field] = _it.stats[$ _sk];
            }
        }
    }
    if (variable_struct_exists(_it, "effects") && is_array(_it.effects)) {
        for (var _e = 0; _e < array_length(_it.effects); _e++) {
            if (is_struct(_it.effects[_e])) array_push(_it.declared_effects, _it.effects[_e]);
        }
    }
    // Standard aliases. `price`, `act`, `desc` and `slot` stay the storage fields.
    if (variable_struct_exists(_it, "buy_price")) _it.price = max(0, _it.buy_price);
    if (variable_struct_exists(_it, "unlock_act")) _it.act = clamp(floor(_it.unlock_act), 0, 8);
    if (variable_struct_exists(_it, "description")) _it.desc = string(_it.description);
    if (variable_struct_exists(_it, "equipment_slot")) _it.slot = _it.equipment_slot;
    if (_it.key_item) _it.sellable = false;
    if (_it.price <= 0) _it.sellable = false;
    scr_item_finalize(_it);
    return _it;
}

// ---- Standard item record (2026-11-18) --------------------------------------------------------
// Every registered item carries the same record shape. The flat fields (atk_bonus, heal, ...) are
// the existing authoring shortcut and stay the runtime projection; `stats`, `effects`, the aliases
// and the validation report are materialized here so new items can be declared with the standard
// structure without touching inventory, equipment, shops, loot, crafting or save code.

function scr_item_stat_keys() {
    return ["hp", "mp", "atk", "def", "mag", "mdef", "spd", "eva", "acc", "crit"];
}

function scr_item_category_values() {
    return ["weapon", "armor", "accessory", "consumable", "material", "key"];
}

function scr_item_rarity_values() {
    return ["common", "uncommon", "rare", "legendary"];
}

function scr_item_weapon_types() {
    return ["sword", "greatsword", "dagger", "spear", "axe", "hammer", "bow", "staff", "shield", "spellbook"];
}

/// Proficiency categories used by `weapon_categories` (more specific than `weapon_type`).
function scr_item_weapon_category_values() {
    return ["longsword", "holy_sword", "shortsword", "heavy_sword", "greatsword", "dagger",
            "polearm", "axe", "mace", "hammer", "bow", "staff", "shield", "spellbook"];
}

function scr_item_element_values() {
    return ["fire", "ice", "lightning", "holy", "shadow", "ash"];
}

function scr_item_status_values() {
    return ["poison", "bleed", "sleep", "blind", "slow"];
}

function scr_item_list_has(_list, _value) {
    if (!is_array(_list)) return false;
    for (var _i = 0; _i < array_length(_list); _i++) {
        if (string(_list[_i]) == string(_value)) return true;
    }
    return false;
}

function scr_item_join(_list, _sep) {
    var _out = "";
    if (!is_array(_list)) return _out;
    for (var _i = 0; _i < array_length(_list); _i++) {
        if (_i > 0) _out += _sep;
        _out += string(_list[_i]);
    }
    return _out;
}

function scr_item_num_ok(_value, _min = -100000, _max = 100000) {
    if (!is_real(_value)) return false;
    if (_value != _value) return false; // NaN
    return _value >= _min && _value <= _max;
}

function scr_item_stat_field(_stat) {
    switch (string(_stat)) {
        case "hp": return "hp_bonus";
        case "mp": return "mp_bonus";
        case "atk": return "atk_bonus";
        case "def": return "def_bonus";
        case "mag": return "mag_bonus";
        case "mdef": return "mdef_bonus";
        case "spd": return "spd_bonus";
        case "eva": return "eva_bonus";
        case "acc": return "acc_bonus";
        case "crit": return "crit_bonus";
    }
    return "";
}

/// Standard weapon subtype for a proficiency category. `weapon_categories` stays authoritative
/// for equipping; `weapon_type` is the readable subtype used by the standard record.
function scr_item_weapon_type_for_categories(_cats) {
    if (!is_array(_cats) || array_length(_cats) == 0) return "";
    var _c = string(_cats[0]);
    switch (_c) {
        case "longsword": case "holy_sword": case "shortsword": return "sword";
        case "heavy_sword": case "greatsword": return "greatsword";
        case "dagger": return "dagger";
        case "polearm": return "spear";
        case "axe": return "axe";
        case "mace": case "hammer": return "hammer";
        case "bow": return "bow";
        case "staff": return "staff";
        case "shield": return "shield";
        case "spellbook": return "spellbook";
    }
    return _c;
}

function scr_item_canonical_slot(_slot) {
    switch (string(_slot)) {
        case "weapon": return "main_hand";
        case "armor": return "body";
        case "helm": return "head";
        case "accessory": return "accessory";
    }
    return string(_slot);
}

/// Six-category classification. Shields are Armor for the bag, but keep `kind: "weapon"` so the
/// existing off-hand/proficiency path is untouched.
function scr_item_category_for(_record) {
    var _kind = string(_record.kind);
    var _slot = scr_item_canonical_slot(variable_struct_exists(_record, "slot") ? _record.slot : "");
    var _cats = variable_struct_exists(_record, "weapon_categories") ? _record.weapon_categories : [];
    switch (_kind) {
        case "weapon":
            if (_slot == "off_hand" && scr_item_list_has(_cats, "shield")) return "armor";
            return "weapon";
        case "armor": case "helm": return "armor";
        case "accessory": return "accessory";
        case "consumable": return "consumable";
        case "key": return "key";
    }
    return "material";
}

function scr_item_effect_key(_effect) {
    if (!is_struct(_effect)) return "invalid";
    var _key = string(variable_struct_exists(_effect, "type") ? _effect.type : "");
    if (variable_struct_exists(_effect, "element")) _key += "|element:" + string(_effect.element);
    if (variable_struct_exists(_effect, "status")) _key += "|status:" + string(_effect.status);
    if (variable_struct_exists(_effect, "stat")) _key += "|stat:" + string(_effect.stat);
    return _key;
}

/// The extensible effect vocabulary. Adding an effect type means adding one row here and, when
/// combat should consume it, one branch where it is read. Item records never need to change.
function scr_item_effect_schema() {
    return {
        elemental_damage:     ["element", "value"],
        elemental_resistance: ["element", "value"],
        status_resistance:    ["status", "value"],
        status_recovery:      ["status"],
        poison_chance:        ["value"],
        critical_bonus:       ["value"],
        hp_drain:             ["value"],
        mp_drain:             ["value"],
        healing:              ["value"],
        revival:              ["value"],
        stat_boost:           ["stat", "value"],
        armor_penetration:    ["value"],
        bonus_damage:         ["value"],
        evasion_bonus:        ["value"],
        mp_restore:           ["value"] // project extension: Ether / Aether Vial
    };
}

/// Build `stats` + `effects`, derive the aliases, and apply authored effects to the flat fields.
/// Idempotent: re-running after the metadata pass never doubles a stat or an effect.
function scr_item_finalize(_record) {
    if (!is_struct(_record)) return _record;

    _record.item_id = scr_item_id_norm(_record.item_id);
    _record.id = _record.item_id;

    _record.description = variable_struct_exists(_record, "description") ? string(_record.description) : "";
    if (_record.description == "") _record.description = variable_struct_exists(_record, "desc") ? string(_record.desc) : "";
    _record.desc = _record.description;

    var _declared_category = variable_struct_exists(_record, "category") ? string(_record.category) : "";
    _record.category = scr_item_list_has(scr_item_category_values(), _declared_category)
        ? _declared_category : scr_item_category_for(_record);

    var _slot = scr_item_canonical_slot(variable_struct_exists(_record, "equipment_slot")
        ? _record.equipment_slot : _record.slot);
    if (_record.category != "weapon" && _record.category != "armor" && _record.category != "accessory") _slot = "";
    _record.slot = _slot;
    _record.equipment_slot = _slot;

    var _weapon_type = variable_struct_exists(_record, "weapon_type") ? string(_record.weapon_type) : "";
    if (_weapon_type == "") {
        _weapon_type = scr_item_weapon_type_for_categories(variable_struct_exists(_record, "weapon_categories")
            ? _record.weapon_categories : []);
    }
    _record.weapon_type = _weapon_type;

    if (!variable_struct_exists(_record, "declared_effects") || !is_array(_record.declared_effects)) {
        _record.declared_effects = [];
    }
    var _declared = _record.declared_effects;
    for (var _d = 0; _d < array_length(_declared); _d++) {
        var _effect = _declared[_d];
        if (!is_struct(_effect)) continue;
        var _type = variable_struct_exists(_effect, "type") ? string(_effect.type) : "";
        var _value = variable_struct_exists(_effect, "value") ? _effect.value : 0;
        switch (_type) {
            case "healing": _record.heal = max(0, _value); break;
            case "mp_restore": _record.mp_restore = max(0, _value); break;
            case "revival": _record.revive_pct = clamp(_value / 100, 0, 1); break;
            case "status_recovery":
                if (string(variable_struct_exists(_effect, "status") ? _effect.status : "") == "poison") {
                    _record.cures_poison = true;
                }
                break;
            case "elemental_resistance":
                if (!is_struct(_record.elem_res)) _record.elem_res = {};
                if (variable_struct_exists(_effect, "element")) {
                    _record.elem_res[$ string(_effect.element)] = _value;
                }
                break;
            case "status_resistance":
                if (!is_struct(_record.status_res)) _record.status_res = {};
                if (variable_struct_exists(_effect, "status")) {
                    _record.status_res[$ string(_effect.status)] = _value;
                }
                break;
            case "critical_bonus": _record.crit_bonus = _value; break;
            case "evasion_bonus": _record.eva_bonus = _value; break;
            case "stat_boost":
                var _stat = string(variable_struct_exists(_effect, "stat") ? _effect.stat : "");
                var _field = scr_item_stat_field(_stat);
                if (_field != "" && variable_struct_exists(_record, _field)) _record[$ _field] = _value;
                break;
        }
    }

    _record.subcategory = scr_item_subcategory_for(_record);

    _record.stats = {
        hp: _record.hp_bonus, mp: _record.mp_bonus, atk: _record.atk_bonus,
        def: _record.def_bonus, mag: _record.mag_bonus, mdef: _record.mdef_bonus,
        spd: _record.spd_bonus, eva: _record.eva_bonus, acc: _record.acc_bonus,
        crit: _record.crit_bonus
    };

    var _effects = [];
    var _seen = {};
    for (var _i = 0; _i < array_length(_declared); _i++) {
        if (!is_struct(_declared[_i])) continue;
        var _key = scr_item_effect_key(_declared[_i]);
        if (variable_struct_exists(_seen, _key)) continue;
        _seen[$ _key] = true;
        array_push(_effects, _declared[_i]);
    }
    var _add_effect = function(_effect_type, _props) {
        var _e = { type: _effect_type };
        if (is_struct(_props)) {
            var _pnames = variable_struct_get_names(_props);
            for (var _p = 0; _p < array_length(_pnames); _p++) _e[$ _pnames[_p]] = _props[$ _pnames[_p]];
        }
        var _ek = scr_item_effect_key(_e);
        if (variable_struct_exists(_seen, _ek)) return;
        _seen[$ _ek] = true;
        array_push(_effects, _e);
    };
    if (_record.heal > 0) _add_effect("healing", { value: _record.heal });
    if (_record.mp_restore > 0) _add_effect("mp_restore", { value: _record.mp_restore });
    if (_record.revive_pct > 0) _add_effect("revival", { value: round(_record.revive_pct * 100) });
    if (_record.cures_poison) _add_effect("status_recovery", { status: "poison" });
    if (is_struct(_record.elem_res)) {
        var _elements = variable_struct_get_names(_record.elem_res);
        for (var _er = 0; _er < array_length(_elements); _er++) {
            _add_effect("elemental_resistance", { element: _elements[_er], value: _record.elem_res[$ _elements[_er]] });
        }
    }
    if (is_struct(_record.status_res)) {
        var _statuses = variable_struct_get_names(_record.status_res);
        for (var _sr = 0; _sr < array_length(_statuses); _sr++) {
            _add_effect("status_resistance", { status: _statuses[_sr], value: _record.status_res[$ _statuses[_sr]] });
        }
    }
    _record.effects = _effects;

    _record.buy_price = max(0, _record.price);
    _record.unlock_act = clamp(floor(variable_struct_exists(_record, "act") ? _record.act : 0), 0, 8);
    _record.act = _record.unlock_act;
    if (_record.key_item || _record.unique || _record.price <= 0) _record.sellable = false;
    _record.sell_price = _record.sellable ? max(1, floor(_record.buy_price * SHOP_SELL_RATE)) : 0;
    var _stackable = (_record.category == "consumable" || _record.category == "material");
    if (_record.key_item || _record.unique || _record.category == "key") _stackable = false;
    _record.stackable = _stackable;
    return _record;
}

/// Descriptive subtype inside a category (ring / pendant / ore / ingot / document / ...). It is
/// derived metadata for future UI and quests; it never gates equipping, selling or use.
function scr_item_subcategory_for(_record) {
    var _cat = string(variable_struct_exists(_record, "category") ? _record.category : "");
    var _name = string_lower(string(variable_struct_exists(_record, "name") ? _record.name : ""));
    var _slot = string(variable_struct_exists(_record, "equipment_slot") ? _record.equipment_slot : "");
    switch (_cat) {
        case "weapon":
            return string(variable_struct_exists(_record, "weapon_type") ? _record.weapon_type : "weapon");
        case "armor":
            switch (_slot) {
                case "head": return "headgear";
                case "body": return "body_armor";
                case "legs": return "leg_armor";
                case "off_hand": return "shield";
            }
            return "armor";
        case "accessory":
            if (string_pos("ring", _name) > 0) return "ring";
            if (string_pos("pendant", _name) > 0) return "pendant";
            if (string_pos("charm", _name) > 0) return "charm";
            if (string_pos("talisman", _name) > 0) return "talisman";
            return "other_accessory";
        case "consumable":
            if (variable_struct_exists(_record, "revive_pct") && _record.revive_pct > 0) return "revival";
            if (variable_struct_exists(_record, "heal") && _record.heal > 0) return "hp_restore";
            if (variable_struct_exists(_record, "mp_restore") && _record.mp_restore > 0) return "mp_restore";
            if (variable_struct_exists(_record, "cures_poison") && _record.cures_poison) return "status_recovery";
            return "other_consumable";
        case "material":
            if (_name == "ore" || string_pos(" ore", " " + _name) > 0) return "ore";
            if (_name == "ingot" || string_pos(" ingot", " " + _name) > 0) return "ingot";
            if (string_pos("pelt", _name) > 0 || string_pos("hide", _name) > 0
                    || string_pos("fang", _name) > 0 || string_pos("claw", _name) > 0
                    || string_pos("scale", _name) > 0) return "monster_material";
            var _rarity = string(variable_struct_exists(_record, "rarity") ? _record.rarity : "");
            if (_rarity == "rare" || _rarity == "legendary") return "rare_component";
            return "magical_material";
        case "key":
            if (string_pos("key", _name) > 0) return "key";
            if (string_pos("notes", _name) > 0 || string_pos("parchment", _name) > 0
                    || string_pos("letter", _name) > 0) return "document";
            if (string_pos("relic", _name) > 0 || string_pos("crown", _name) > 0
                    || string_pos("fragment", _name) > 0) return "relic";
            if (string_pos("parcel", _name) > 0 || string_pos("quest", _name) > 0) return "quest_object";
            return "story_item";
    }
    return "";
}

/// Returns an array of human-readable errors. Registration keeps invalid records queryable but
/// marks them `valid: false` and logs them; tools/equipment_check.py fails on the same rules.
function scr_item_validate(_record) {
    var _errors = [];
    var _add = function(_message) { array_push(_errors, _message); };
    if (!is_struct(_record)) { _add("record is not a struct"); return _errors; }

    var _id = variable_struct_exists(_record, "item_id") ? string(_record.item_id) : "";
    if (_id == "") _add("id is empty");
    if (_id != string_lower(_id)) _add("id is not lowercase");
    if (string_copy(_id, 1, 5) != "item_") _add("id does not start with item_");
    if (string_pos(" ", _id) > 0) _add("id contains a space");
    if (!variable_struct_exists(_record, "name") || string(_record.name) == "") _add("name is empty");

    var _category = variable_struct_exists(_record, "category") ? string(_record.category) : "";
    if (!scr_item_list_has(scr_item_category_values(), _category)) _add("invalid category '" + _category + "'");

    var _rarity = variable_struct_exists(_record, "rarity") ? string(_record.rarity) : "";
    if (!scr_item_list_has(scr_item_rarity_values(), _rarity)) _add("invalid rarity '" + _rarity + "'");

    var _description = variable_struct_exists(_record, "description") ? string(_record.description) : "";
    if (_description == "") _add("description is empty");
    if (!variable_struct_exists(_record, "subcategory") || string(_record.subcategory) == "") {
        _add("subcategory is empty");
    }

    var _equipment = (_category == "weapon" || _category == "armor" || _category == "accessory");
    var _slot = variable_struct_exists(_record, "equipment_slot") ? string(_record.equipment_slot) : "";
    if (_equipment) {
        if (!scr_item_list_has(["main_hand", "off_hand", "head", "body", "legs", "accessory"], _slot)) {
            _add("invalid equipment slot '" + _slot + "'");
        }
    } else if (_slot != "") {
        _add("non-equipment record has a slot");
    }

    var _weapon_type = variable_struct_exists(_record, "weapon_type") ? string(_record.weapon_type) : "";
    var _cats = variable_struct_exists(_record, "weapon_categories") ? _record.weapon_categories : [];
    if (_category == "weapon") {
        if (!scr_item_list_has(scr_item_weapon_types(), _weapon_type) || _weapon_type == "shield") {
            _add("invalid weapon_type '" + _weapon_type + "' for a weapon");
        }
        if (_slot != "main_hand" && _slot != "off_hand") _add("weapon is not in a hand slot");
        if (!is_array(_cats) || array_length(_cats) == 0) _add("weapon has no weapon_categories");
    } else if (_category == "armor" && _slot == "off_hand") {
        if (_weapon_type != "shield") _add("off-hand armor must be a shield");
    } else if (_weapon_type != "") {
        _add("non-weapon record has a weapon_type");
    }
    if (variable_struct_exists(_record, "two_handed") && _record.two_handed) {
        if (_category != "weapon" || _slot != "main_hand") _add("two-handed item is not a main-hand weapon");
    }

    if (!variable_struct_exists(_record, "stats") || !is_struct(_record.stats)) {
        _add("stats struct is missing");
    } else {
        var _stat_keys = scr_item_stat_keys();
        for (var _s = 0; _s < array_length(_stat_keys); _s++) {
            var _sk = _stat_keys[_s];
            if (!variable_struct_exists(_record.stats, _sk)) { _add("stat '" + _sk + "' is missing"); continue; }
            var _sv = _record.stats[$ _sk];
            if (!scr_item_num_ok(_sv)) _add("stat '" + _sk + "' is not a finite number");
            if (_sk == "crit" && (_sv < -1 || _sv > 1)) _add("crit must be a fraction between -1 and 1");
        }
    }

    if (!variable_struct_exists(_record, "effects") || !is_array(_record.effects)) {
        _add("effects array is missing");
    } else {
        var _schema = scr_item_effect_schema();
        var _types = variable_struct_get_names(_schema);
        for (var _e = 0; _e < array_length(_record.effects); _e++) {
            var _effect = _record.effects[_e];
            if (!is_struct(_effect)) { _add("effect " + string(_e) + " is not a struct"); continue; }
            var _type = variable_struct_exists(_effect, "type") ? string(_effect.type) : "";
            if (!scr_item_list_has(_types, _type)) { _add("unknown effect type '" + _type + "'"); continue; }
            var _required = _schema[$ _type];
            for (var _r = 0; _r < array_length(_required); _r++) {
                if (!variable_struct_exists(_effect, _required[_r])) {
                    _add("effect '" + _type + "' is missing '" + _required[_r] + "'");
                }
            }
            if (variable_struct_exists(_effect, "value") && !scr_item_num_ok(_effect.value)) {
                _add("effect '" + _type + "' has a non-numeric value");
            }
            if (variable_struct_exists(_effect, "element")) {
                if (!scr_item_list_has(scr_item_element_values(), string(_effect.element))) {
                    _add("effect '" + _type + "' has unknown element '" + string(_effect.element) + "'");
                }
            }
            if (variable_struct_exists(_effect, "status")) {
                if (!scr_item_list_has(scr_item_status_values(), string(_effect.status))) {
                    _add("effect '" + _type + "' has unknown status '" + string(_effect.status) + "'");
                }
            }
            if (_type == "stat_boost" && variable_struct_exists(_effect, "stat")) {
                if (!scr_item_list_has(scr_item_stat_keys(), string(_effect.stat))) {
                    _add("stat_boost has unknown stat '" + string(_effect.stat) + "'");
                }
            }
            if (_type == "healing" || _type == "mp_restore") {
                if (variable_struct_exists(_effect, "value") && _effect.value <= 0) _add(_type + " must be positive");
            }
            if (_type == "revival" && variable_struct_exists(_effect, "value")) {
                if (_effect.value <= 0 || _effect.value > 100) _add("revival must be between 0 and 100");
            }
            if (_type == "poison_chance" && variable_struct_exists(_effect, "value")) {
                if (_effect.value < 0 || _effect.value > 100) _add("poison_chance must be between 0 and 100");
            }
            if (_type == "critical_bonus" && variable_struct_exists(_effect, "value")) {
                if (_effect.value < -1 || _effect.value > 1) _add("critical_bonus must be a fraction");
            }
            if ((_type == "elemental_resistance" || _type == "status_resistance")
                    && variable_struct_exists(_effect, "value")) {
                if (_effect.value < -100 || _effect.value > 100) _add(_type + " must be between -100 and 100");
            }
        }
    }

    var _buy = variable_struct_exists(_record, "buy_price") ? _record.buy_price : -1;
    var _sell = variable_struct_exists(_record, "sell_price") ? _record.sell_price : -1;
    if (!scr_item_num_ok(_buy, 0, 10000000)) _add("buy_price is invalid");
    if (!scr_item_num_ok(_sell, 0, 10000000)) _add("sell_price is invalid");
    if (_record.sellable && _buy <= 0) _add("sellable record has no buy price");
    if (_record.sellable && _sell > _buy) _add("sell_price is above buy_price");
    if (!_record.sellable && _sell != 0) _add("unsellable record has a sell_price");

    if (!scr_item_num_ok(_record.unlock_act, 0, 8) || floor(_record.unlock_act) != _record.unlock_act) {
        _add("unlock_act must be a whole number from 0 to 8");
    }
    if (!is_real(_record.stackable)) _add("stackable is not a boolean");
    if (_record.stackable && _category != "consumable" && _category != "material") {
        _add("non-stackable category marked stackable");
    }
    if (!_record.stackable && (_category == "consumable" || _category == "material")) {
        _add("stackable category marked non-stackable");
    }
    if ((_record.key_item || _record.unique) && _record.sellable) _add("key/unique record is sellable");
    if (is_array(_cats)) {
        for (var _wc = 0; _wc < array_length(_cats); _wc++) {
            if (!scr_item_list_has(scr_item_weapon_category_values(), string(_cats[_wc]))) {
                _add("unknown weapon category '" + string(_cats[_wc]) + "'");
            }
        }
        if (array_length(_cats) > 0 && !_equipment) _add("non-equipment record has weapon_categories");
    }
    if (variable_struct_exists(_record, "armor_class")) {
        var _ac = string(_record.armor_class);
        if (_ac != "" && _ac != "light" && _ac != "medium" && _ac != "heavy") _add("invalid armor_class '" + _ac + "'");
    }
    return _errors;
}

function scr_item_database() {
    if (variable_global_exists("item_db") && is_struct(global.item_db)) return global.item_db;
    // Validation report for this build. Invalid records stay queryable (so a typo cannot crash a
    // menu or a save), but they are marked and listed here for the audit tool and the debug log.
    global.item_db_errors = [];
    global.item_db_invalid = [];
    global.item_db_duplicates = [];
    var _db = {};
    var _add = function(_db_ref, _it) {
        if (variable_struct_exists(_db_ref, _it.item_id)) {
            array_push(global.item_db_duplicates, _it.item_id);
            show_debug_message("[item_db] duplicate id ignored: " + _it.item_id);
            return;
        }
        _db_ref[$ _it.item_id] = _it;
    };

    // Consumables (Marda). Provisional balance; the Act I baseline.
    _add(_db, scr_item_make("item_minor_potion", "Minor Potion", "consumable", 15, {
        heal: ITEM_MINOR_POTION_HEAL,
        desc: "Restores " + string(ITEM_MINOR_POTION_HEAL) + " HP."
    }));
    _add(_db, scr_item_make("item_antidote", "Antidote", "consumable", 20, {
        cures_poison: true,
        desc: "Cures poison, in battle and out."
    }));

    // Chapter 2 (balance pass). Ether: MP recovery, sold by Len in Wrenfield and found in a
    // Millhaven Road chest. Chain Mail: Len's mid-tier item. Both have dedicated icons.
    _add(_db, scr_item_make("item_ether", "Ether", "consumable", 60, {
        mp_restore: ITEM_ETHER_MP,
        desc: "Restores " + string(ITEM_ETHER_MP) + " MP."
    }));
    _add(_db, scr_item_make("item_chain_mail", "Chain Mail", "armor", 220, {
        def_bonus: 4,
        desc: "Riveted rings over padding. DEF +4."
    }));
    _add(_db, scr_item_make("item_travel_brigandine", "Travel Brigandine", "armor", 0, {
        def_bonus: 2,
        sellable: false,
        desc: "Taren's olive brigandine. DEF +2."
    }));

    // Basic equipment (Pell's forge). Act I shop tier; provisional prices.
    _add(_db, scr_item_make("item_iron_sword", "Iron Sword", "weapon", 80, {
        atk_bonus: 3,
        weapon_categories: ["longsword"],
        desc: "A plain iron blade. ATK +3."
    }));
    _add(_db, scr_item_make("item_leather_armor", "Leather Armor", "armor", 60, {
        def_bonus: 2,
        desc: "Scuffed travelling leathers. DEF +2."
    }));
    _add(_db, scr_item_make("item_iron_helm", "Iron Helm", "helm", 40, {
        def_bonus: 1,
        desc: "A simple iron cap. DEF +1."
    }));

    // Starting / unique equipment (not sold). Provisional bonuses.
    _add(_db, scr_item_make("item_kaels_longsword", "Kael's Longsword", "weapon", 0, {
        atk_bonus: 3,
        weapon_categories: ["longsword"],
        sellable: false,
        desc: "Kael's own blade. ATK +3."
    }));
    _add(_db, scr_item_make("item_bastard_sword", "Bastard Sword", "weapon", 0, {
        atk_bonus: 3,
        weapon_categories: ["heavy_sword"],
        sellable: false,
        desc: "Taren's starting weapon. ATK +3."
    }));
    _add(_db, scr_item_make("item_twin_daggers", "Twin Daggers", "weapon", 0, {
        atk_bonus: 2,
        weapon_categories: ["dagger"],
        sellable: false,
        desc: "Lyra's starting weapon. ATK +2."
    }));
    // Caelan's spellbook (CHAPTER4_SCRIPT.md §6): a starting weapon that leans on magic.
    // Values are provisional, set below the Act I shop weapons so Pell's stock stays an upgrade.
    _add(_db, scr_item_make("item_spellbook", "Spellbook", "weapon", 0, {
        atk_bonus: 1, mag_bonus: 3, mdef_bonus: 1,
        weapon_categories: ["spellbook"],
        sellable: false,
        desc: "Caelan's spellbook. ATK +1, MAG +3, MDEF +1. (Provisional combat values.)"
    }));
    // Sera's holy sword: canon weapon (STORY_BIBLE.md §5.4), approved 2026-11-16.
    // Slightly above the Chapel Blade she can buy, so joining with it is not a downgrade.
    _add(_db, scr_item_make("item_holy_sword", "Holy Sword", "weapon", 0, {
        atk_bonus: 4, mag_bonus: 1, mdef_bonus: 1,
        weapon_categories: ["holy_sword"],
        sellable: false,
        desc: "Sera's Silver Guard blade. ATK +4, MAG +1, MDEF +1. (Provisional combat values.)"
    }));
    // Chapter 3 key items (CHAPTER3_SCRIPT.md §4.1, §5).
    _add(_db, scr_item_make("item_nim_parcel", "Nim's Parcel", "key", 0, {
        sellable: false,
        desc: "A plain parcel, no Crown seal. The stall under the blue awning is expecting it."
    }));
    _add(_db, scr_item_make("item_scholar_notes", "Scholar's Notes", "key", 0, {
        sellable: false,
        desc: "A scholar's hand, hurried. A hollow in the hills a day's walk from the capital. Architect doors. Still standing."
    }));
    _add(_db, scr_item_make("item_hunters_knife", "Hunter's Knife", "weapon", 0, {
        atk_bonus: 2,
        weapon_categories: ["dagger"],
        desc: "A short hunting blade. ATK +2."
    }));
    _add(_db, scr_item_make("item_hunters_charm", "Hunter's Charm", "accessory", 0, {
        def_bonus: 1,
        sellable: false,
        desc: "A worn hunter's charm. DEF +1."
    }));
    // Bow and arrow are reserved for a future bow-proficient recruit. No current class is
    // changed to use them, and they are kept out of shop stock until that decision is approved.
    _add(_db, scr_item_make("item_ashen_longbow", "Ashen Longbow", "weapon", 0, {
        atk_bonus: 3,
        weapon_categories: ["bow"],
        desc: "A grey-ash longbow. Reserved for a future bow-proficient recruit; no current party member can equip it."
    }));
    _add(_db, scr_item_make("item_ashen_arrow", "Ashen Arrow", "material", 0, {
        desc: "Ammunition material for a future bow-proficient recruit. No use action in the current build."
    }));
    // Canonical Blackguard drop. The old singular id (item_blackguard_longsword) is resolved by
    // scr_item_id_norm() as an alias, so old saves and equipment references still load.
    _add(_db, scr_item_make("item_blackguards_longsword", "Blackguard's Longsword", "weapon", 0, {
        atk_bonus: 5,
        weapon_categories: ["longsword"],
        sellable: false,
        desc: "Taken from the Blackguard. ATK +5. (Provisional combat value.)"
    }));

    // Key / story items — cannot be sold or used from the bag (except inspect).
    _add(_db, scr_item_make("item_mira_pendant", "Mira's Wooden Pendant", "key", 0, {
        desc: "Mira's pendant. A story item."
    }));
    _add(_db, scr_item_make("item_watchtower_key", "Watchtower Key", "key", 0, {
        desc: "Opens the rusted arena gate in the Old Watchtower."
    }));
    _add(_db, scr_item_make("item_ashbound_parchment", "Ashbound Parchment", "key", 0, {
        desc: "“Find the girl. The Varyn girl is still alive.”"
    }));
    _add(_db, scr_item_make("item_crownveil_fragment", "Crownveil Fragment", "key", 0, {
        desc: "A fragment of the Crownveil."
    }));
    _add(_db, scr_item_make("item_blackened_feather", "Blackened Feather", "material", 0, {
        desc: "A charred feather from an ash-thing. Forge material; no use action in the current build."
    }));
    // Emberwake's feather: the early boss drops it at 35%, the later ordinary Emberwakes at 10%
    // (scr_battle_roll_drops). A revive item (25% HP) — see scr_item_use_on.
    _add(_db, scr_item_make("item_emberwake_feather", "Emberwake Feather", "consumable", 120, {
        revive_pct: 0.25, rarity: "rare", act: 1,
        acquisition: "Emberwake (Old Road, 35%) and later Emberwakes (10%).",
        desc: "A crimson feather blessed by an ancient fire spirit. Its remaining warmth calls a fallen warrior back from the brink of death. Revives one fallen member with 25% HP."
    }));
    _add(_db, scr_item_make("item_ashenheart_plume", "Ashenheart Plume", "consumable", 400, {
        revive_pct: 0.50, rarity: "rare", act: 7,
        acquisition: "Ashlands fire-things (Act VII); no merchant stocks it yet.",
        desc: "A sacred plume carrying the undying flame of an ancient spirit. Its power can restore even those who have crossed into death. Revives one fallen member with 50% HP."
    }));

    // ---- Eight-act equipment progression --------------------------------------------------
    // Tiers I-VIII. Acts I-II are wired to real content (shops, chests, enemy drops, bosses);
    // Acts III-VIII are data only until those acts' rooms, enemies and merchants exist, which is
    // stated per item in `acquisition` and in docs/EQUIPMENT_PROGRESSION.md. Values are provisional
    // but form one coherent tier per act; `tools/equipment_check.py` checks the curve. Design rules: one weapon tier per act (rotating class), one class-neutral
    // armour/helm/accessory per act, one crafted piece per act, one boss legendary per act.

    // Act I (levels 1-7).
    _add(_db, scr_item_make("item_ash_shard", "Ash Shard", "misc", 12, {
        rarity: "common", act: 1, acquisition: "Dropped by Zone 1 bandits, wolves and wretches; sold by Marda.",
        desc: "A shard of the Ashen Road's glassy crust. Forge material."
    }));
    _add(_db, scr_item_make("item_ash_pendant", "Ash Pendant", "accessory", 0, {
        def_bonus: 1, mdef_bonus: 2, rarity: "uncommon", act: 1, sellable: false,
        acquisition: "Hidden grove chest, north-west of the bandit camp (Act I).",
        desc: "A dull pendant on a leather cord. DEF +1, MDEF +2."
    }));

    // Act II (levels 8-10): Len's stock, Calder's blade, forge crafting.
    _add(_db, scr_item_make("item_millhaven_sabre", "Millhaven Sabre", "weapon", 180, {
        atk_bonus: 5, weapon_categories: ["longsword"], rarity: "uncommon", act: 2,
        acquisition: "Len's shop, Wrenfield (Act II); also crafted at the forge.",
        desc: "A thin Millhaven blade, quick in the hand. ATK +5."
    }));
    _add(_db, scr_item_make("item_wrenfield_coat", "Wrenfield Coat", "armor", 160, {
        def_bonus: 4, spd_bonus: 1, rarity: "uncommon", act: 2,
        acquisition: "Len's shop, Wrenfield (Act II).",
        desc: "Waxed canvas over quilted padding. DEF +4, SPD +1."
    }));
    _add(_db, scr_item_make("item_patrol_helm", "Patrol Helm", "helm", 140, {
        def_bonus: 3, rarity: "uncommon", act: 2,
        acquisition: "Len's shop, Wrenfield (Act II); Watchtower chests.",
        desc: "A Crown patrol helm, dented and re-strapped. DEF +3."
    }));
    _add(_db, scr_item_make("item_warden_sigil", "Warden's Sigil", "accessory", 200, {
        def_bonus: 1, mdef_bonus: 3, rarity: "rare", act: 2,
        acquisition: "Crafted at the forge from Iron Scales (Act II).",
        desc: "A warden's mark, worn smooth. DEF +1, MDEF +3."
    }));
    _add(_db, scr_item_make("item_iron_scale", "Iron Scale", "misc", 18, {
        rarity: "common", act: 2, acquisition: "Dropped by Crown patrols and occupation soldiers (Act II).",
        desc: "A scale prised from Crown-issue mail. Forge material."
    }));
    _add(_db, scr_item_make("item_calders_greatsword", "Calder's Greatsword", "weapon", 0, {
        atk_bonus: 8, weapon_categories: ["heavy_sword"], two_handed: true, rarity: "legendary", act: 2, unique: true, sellable: false,
        acquisition: "Reeve Calder, Wrenfield (guaranteed, once).",
        desc: "The Reeve's heavy blade. ATK +8. Cannot be sold."
    }));

    // Act III (levels 11-14): Valemere.
    _add(_db, scr_item_make("item_ledger_dirk", "Ledger Dirk", "weapon", 520, {
        atk_bonus: 8, spd_bonus: 2, weapon_categories: ["dagger"], rarity: "rare", act: 3,
        acquisition: "Valemere arms stall (Act III); also crafted at the forge.",
        desc: "A narrow capital dirk with a ledger-stamped guard. ATK +8, SPD +2."
    }));
    _add(_db, scr_item_make("item_salt_lampskin", "Salt-Lampskin Coat", "armor", 480, {
        def_bonus: 6, mdef_bonus: 3, classes: ["Arcanist", "Warden"], rarity: "rare", act: 3,
        acquisition: "Valemere arms stall (Act III).",
        desc: "Oilskin lined with salt-lamp wick. Arcanist / Warden only. DEF +6, MDEF +3."
    }));
    _add(_db, scr_item_make("item_valemere_helm", "Valemere Helm", "helm", 440, {
        def_bonus: 5, rarity: "rare", act: 3,
        acquisition: "Valemere arms stall (Act III); crafted at the forge.",
        desc: "A city-watch helm with a brass brow. DEF +5."
    }));
    _add(_db, scr_item_make("item_valemere_steel", "Valemere Steel", "misc", 40, {
        rarity: "common", act: 3, acquisition: "Sold in Valemere; dropped by capital guards (Act III).",
        desc: "A folded bar of capital steel. Forge material."
    }));
    _add(_db, scr_item_make("item_debtmans_chain", "Debtman's Chain", "accessory", 0, {
        def_bonus: 3, mdef_bonus: 3, rarity: "legendary", act: 3, unique: true, sellable: false,
        acquisition: "The Debtman, Valemere (guaranteed, once).",
        desc: "A collector's chain, still cold. DEF +3, MDEF +3. Cannot be sold."
    }));

    // Act IV (levels 15-17): the barrows.
    _add(_db, scr_item_make("item_oath_breaker", "Oathbreaker", "weapon", 900, {
        atk_bonus: 11, weapon_categories: ["heavy_sword"], two_handed: true, rarity: "rare", act: 4,
        acquisition: "Barrow gate smith (Act IV); crafted at the forge.",
        desc: "A barrow-iron greatsword, notched on oath-stones. ATK +11."
    }));
    _add(_db, scr_item_make("item_barrow_plate", "Barrow Plate", "armor", 880, {
        def_bonus: 9, classes: ["Vanguard", "Rebel Captain"], rarity: "rare", act: 4,
        acquisition: "Barrow gate smith (Act IV).",
        desc: "Heavy plates from a tomb's guard. Vanguard / Rebel Captain only. DEF +9."
    }));
    _add(_db, scr_item_make("item_barrow_helm", "Barrow Helm", "helm", 760, {
        def_bonus: 7, rarity: "rare", act: 4,
        acquisition: "Barrow gate smith (Act IV); crafted at the forge.",
        desc: "A dead king's guard helm, visor jammed shut. DEF +7."
    }));
    _add(_db, scr_item_make("item_barrow_iron", "Barrow Iron", "misc", 60, {
        rarity: "common", act: 4, acquisition: "Dropped by barrow guardians and wights (Act IV).",
        desc: "Iron from a sealed tomb, still cold. Forge material."
    }));
    _add(_db, scr_item_make("item_sanctuary_oathblade", "Sanctuary Oathblade", "weapon", 0, {
        atk_bonus: 10, weapon_categories: ["holy_sword"], rarity: "legendary", act: 4, unique: true, sellable: false,
        acquisition: "The Sanctuary Warden (guaranteed, once; Chapter 4).",
        desc: "A warden's oath, still keeping its edge. ATK +10. Cannot be sold."
    }));

    // Act V (levels 17-19): Saltreach and the drowned coast.
    _add(_db, scr_item_make("item_tidesteel_blade", "Tidesteel Blade", "weapon", 1400, {
        atk_bonus: 12, weapon_categories: ["longsword"], rarity: "rare", act: 5,
        acquisition: "Mott's cart, Blackwood road (Act V); crafted at the forge.",
        desc: "A blade of tidesteel, never quite dry. ATK +12."
    }));
    _add(_db, scr_item_make("item_drowned_coat", "Drowned Coat", "armor", 1300, {
        def_bonus: 11, mdef_bonus: 4, rarity: "rare", act: 5,
        acquisition: "Mott's cart, Blackwood road (Act V).",
        desc: "A wreck-diver's coat, tarred and salt-stiff. DEF +11, MDEF +4."
    }));
    _add(_db, scr_item_make("item_saltreach_charm", "Saltreach Charm", "accessory", 1200, {
        def_bonus: 2, mdef_bonus: 5, spd_bonus: 1, rarity: "rare", act: 5,
        acquisition: "Mott's cart, Blackwood road (Act V); crafted at the forge.",
        desc: "A charm of knotted net and glass. DEF +2, MDEF +5, SPD +1."
    }));
    _add(_db, scr_item_make("item_tideglass", "Tideglass", "misc", 90, {
        rarity: "common", act: 5, acquisition: "Sold from Mott's cart, Blackwood road (Act V); no drowned things drop it yet.",
        desc: "Sea-glass worn round by the tide. Forge material."
    }));
    _add(_db, scr_item_make("item_drowned_crown", "The Drowned Crown", "helm", 0, {
        def_bonus: 8, mdef_bonus: 6, rarity: "legendary", act: 5, unique: true, sellable: false,
        acquisition: "The Saltreach Leviathan, Saltreach deep (guaranteed, once).",
        desc: "A coral-crusted crown, worn as a helm. DEF +8, MDEF +6. Cannot be sold."
    }));

    // Act VI (levels 19-21): the Ironspine and the Architects.
    _add(_db, scr_item_make("item_ironspine_maul", "Ironspine Maul", "weapon", 2000, {
        atk_bonus: 15, weapon_categories: ["heavy_sword"], two_handed: true, rarity: "rare", act: 6,
        acquisition: "Mott's cart, Blackwood road (Act VI); crafted at the forge.",
        desc: "A mine-maul reforged into a sword-length hammer. ATK +15."
    }));
    _add(_db, scr_item_make("item_mine_plate", "Mine Plate", "armor", 1900, {
        def_bonus: 13, rarity: "rare", act: 6,
        acquisition: "Mott's cart, Blackwood road (Act VI).",
        desc: "Boiler plate from a shut-down mine lift. DEF +13."
    }));
    _add(_db, scr_item_make("item_architect_ring", "Architect Ring", "accessory", 1700, {
        def_bonus: 2, mdef_bonus: 6, rarity: "rare", act: 6,
        acquisition: "Mott's cart, Blackwood road (Act VI); crafted at the forge.",
        desc: "A ring of machined stone, warm to the touch. DEF +2, MDEF +6."
    }));
    _add(_db, scr_item_make("item_architect_alloy", "Architect Alloy", "misc", 120, {
        rarity: "common", act: 6, acquisition: "Dropped by Architect constructs (Act VI).",
        desc: "An alloy no living smith can name. Forge material."
    }));
    _add(_db, scr_item_make("item_first_forge_hammer", "The First Forge", "weapon", 0, {
        atk_bonus: 17, weapon_categories: ["heavy_sword"], two_handed: true, rarity: "legendary", act: 6, unique: true, sellable: false,
        acquisition: "The Architect, Ironspine ruins (guaranteed, once).",
        desc: "The hammer that taught the Architects to make. ATK +17. Cannot be sold."
    }));

    // Act VII (levels 21-23): the Ashlands.
    _add(_db, scr_item_make("item_ashlands_edge", "Ashlands Edge", "weapon", 2600, {
        atk_bonus: 16, weapon_categories: ["longsword"], rarity: "rare", act: 7,
        acquisition: "Ashlands outpost or the Barrow Gate smith (Act VII); crafted at the forge.",
        desc: "A sword quenched in ash, edge still warm. ATK +16."
    }));
    _add(_db, scr_item_make("item_emberweave_robe", "Emberweave Robe", "armor", 2400, {
        def_bonus: 10, mdef_bonus: 10, classes: ["Arcanist", "Warden"], rarity: "rare", act: 7,
        acquisition: "Ashlands outpost or the Barrow Gate smith (Act VII).",
        desc: "A robe woven from ember-silk. Arcanist / Warden only. DEF +10, MDEF +10."
    }));
    _add(_db, scr_item_make("item_ash_crown", "Ash Crown", "helm", 2200, {
        def_bonus: 8, mdef_bonus: 5, rarity: "rare", act: 7,
        acquisition: "Ashlands outpost or the Barrow Gate smith (Act VII); crafted at the forge.",
        desc: "A circlet of fused ash and iron. DEF +8, MDEF +5."
    }));
    _add(_db, scr_item_make("item_ember_core", "Ember Core", "misc", 160, {
        rarity: "common", act: 7, acquisition: "Dropped by Ashlands fire-things (Act VII).",
        desc: "A coal that will not go out. Forge material."
    }));
    _add(_db, scr_item_make("item_matriarch_heartwood", "Matriarch's Heartwood", "accessory", 0, {
        def_bonus: 5, mdef_bonus: 8, rarity: "legendary", act: 6, unique: true, sellable: false,
        acquisition: "The Blackwood Matriarch (guaranteed, once; Chapter 7).",
        desc: "A knot of living heartwood, still beating. DEF +5, MDEF +8. Cannot be sold."
    }));
    _add(_db, scr_item_make("item_barrow_kings_blade", "Barrow King's Blade", "weapon", 0, {
        atk_bonus: 16, weapon_categories: ["holy_sword"], rarity: "legendary", act: 7, unique: true, sellable: false,
        acquisition: "The Barrow Warden (guaranteed, once; Chapter 10).",
        desc: "A king's sword, blessed and buried. ATK +16. Cannot be sold."
    }));

    // Act VIII (levels 23-24).
    _add(_db, scr_item_make("item_true_name_blade", "True-Name Blade", "weapon", 3200, {
        atk_bonus: 19, weapon_categories: ["longsword"], rarity: "rare", act: 8,
        acquisition: "Rimehold armoury (Act VIII); crafted at the forge.",
        desc: "A blade inscribed with a name that is not yours. ATK +19."
    }));
    _add(_db, scr_item_make("item_rime_sword", "Rime Sword", "weapon", 3000, {
        atk_bonus: 16, weapon_categories: ["holy_sword"], rarity: "rare", act: 8,
        acquisition: "Rimehold armoury (Act VIII).",
        desc: "A Silver Guard blade, rimed and blessed. ATK +16."
    }));
    _add(_db, scr_item_make("item_veil_plate", "Veil Plate", "armor", 3100, {
        def_bonus: 16, rarity: "rare", act: 8,
        acquisition: "Rimehold armoury (Act VIII).",
        desc: "Plate worked with veil-iron. DEF +16."
    }));
    _add(_db, scr_item_make("item_veil_ring", "Veil Ring", "accessory", 2900, {
        def_bonus: 5, mdef_bonus: 9, spd_bonus: 2, rarity: "rare", act: 8,
        acquisition: "Rimehold armoury (Act VIII); crafted at the forge.",
        desc: "A ring that keeps the cold off the hand. DEF +5, MDEF +9, SPD +2."
    }));
    _add(_db, scr_item_make("item_veil_shard", "Veil Shard", "misc", 220, {
        rarity: "common", act: 8, acquisition: "Dropped by veil-touched enemies (Act VIII).",
        desc: "A sliver of the veil, cold enough to burn. Forge material."
    }));
    _add(_db, scr_item_make("item_forgotten_kings_crown", "The Forgotten King's Crown", "helm", 0, {
        def_bonus: 10, mdef_bonus: 9, rarity: "legendary", act: 8, unique: true, sellable: false,
        acquisition: "The Forgotten King, the barrow halls (guaranteed, once; Chapter 11).",
        desc: "The crown the histories forgot. DEF +10, MDEF +9. Cannot be sold."
    }));

    // ---- Named story equipment (2026-11-18) ------------------------------------------------
    // Names come from the design handoff and are fixed. All numbers are PLACEHOLDER.
    _add(_db, scr_item_make("item_beggars_edge", "Beggar's Edge", "weapon", 12, {
        atk_bonus: 2, acc_bonus: 3, weapon_categories: ["longsword"], rarity: "common", act: 1,
        acquisition: "Pell's forge, Greyhaven (Act I).",
        desc: "A chipped blade with a rag grip. ATK +2, ACC +3."
    }));
    _add(_db, scr_item_make("item_soldiers_oath", "Soldier's Oath", "weapon", 210, {
        atk_bonus: 6, def_bonus: 1, acc_bonus: 2, weapon_categories: ["longsword"], rarity: "uncommon", act: 2,
        acquisition: "Len's shop, Wrenfield (Act II).",
        desc: "A Crown soldier's sword, sworn and re-sworn. ATK +6, DEF +1, ACC +2."
    }));
    _add(_db, scr_item_make("item_wardens_steel", "Warden's Steel", "weapon", 900, {
        atk_bonus: 9, mdef_bonus: 4, mag_bonus: 2, weapon_categories: ["holy_sword"], rarity: "rare", act: 3,
        acquisition: "Valemere arms (Act III).",
        desc: "A Warden's blade, bright without a light. ATK +9, MDEF +4, MAG +2."
    }));
    _add(_db, scr_item_make("item_oathkeeper", "Oathkeeper", "weapon", 1500, {
        atk_bonus: 14, def_bonus: 2, weapon_categories: ["heavy_sword"], two_handed: true, rarity: "rare", act: 5,
        acquisition: "Mott's cart, Blackwood road (Act V).",
        desc: "A two-handed greatsword cut with oath-stones. ATK +14, DEF +2."
    }));
    _add(_db, scr_item_make("item_ashen_requiem", "Ashen Requiem", "weapon", 0, {
        atk_bonus: 19, crit_bonus: 0.06, weapon_categories: ["greatsword"], two_handed: true,
        rarity: "legendary", act: 6, unique: true, sellable: false,
        acquisition: "The Architect, Ironspine ruins (guaranteed, once; Act VI).",
        desc: "A greatsword that rings like a funeral bell. ATK +19, CRIT +6%. Cannot be sold."
    }));
    _add(_db, scr_item_make("item_kings_bane", "King's Bane", "weapon", 0, {
        atk_bonus: 22, def_bonus: 3, weapon_categories: ["greatsword"], two_handed: true,
        rarity: "legendary", act: 7, unique: true, sellable: false,
        acquisition: "The Ash King's guard (guaranteed, once; Act VII).",
        desc: "A king-killer's greatsword, notched once for every crown. ATK +22, DEF +3. Cannot be sold."
    }));
    _add(_db, scr_item_make("item_veilrender", "Veilrender", "weapon", 0, {
        atk_bonus: 15, spd_bonus: 4, crit_bonus: 0.10, weapon_categories: ["dagger"],
        rarity: "legendary", act: 8, unique: true, sellable: false,
        acquisition: "Rimehold, the last vault (Act VIII).",
        desc: "A dagger that parts the veil like cloth. ATK +15, SPD +4, CRIT +10%. Cannot be sold."
    }));
    _add(_db, scr_item_make("item_dawnbringer", "Dawnbringer", "weapon", 0, {
        atk_bonus: 18, mdef_bonus: 5, mag_bonus: 6, weapon_categories: ["holy_sword"],
        elem_res: { holy: 20, shadow: 10 }, rarity: "legendary", act: 7, unique: true, sellable: false,
        acquisition: "The Silver Guard's last consecration (Act VII).",
        desc: "A holy sword that keeps a dawn of its own. ATK +18, MAG +6, MDEF +5, HOLY +20%, SHADOW +10%. Cannot be sold."
    }));

    // Legs and off-hand gear, so all seven slots have real choices in every tier band.
    _add(_db, scr_item_make("item_travel_leggings", "Travel Leggings", "armor", 30, {
        slot: "legs", def_bonus: 1, armor_class: "light", rarity: "common", act: 1,
        acquisition: "Marda's store, Greyhaven (Act I).",
        desc: "Patched travelling leggings. DEF +1."
    }));
    _add(_db, scr_item_make("item_yoke_shield", "Yoke Shield", "weapon", 240, {
        slot: "off_hand", def_bonus: 3, weapon_categories: ["shield"], armor_class: "medium",
        rarity: "uncommon", act: 2, acquisition: "Len's shop, Wrenfield (Act II).",
        desc: "A rebel shield, repainted twice. DEF +3. Off-hand."
    }));
    _add(_db, scr_item_make("item_valemere_greaves", "Valemere Greaves", "armor", 420, {
        slot: "legs", def_bonus: 3, armor_class: "heavy", rarity: "rare", act: 3,
        acquisition: "Valemere arms (Act III).",
        desc: "City-watch greaves, brass-capped. DEF +3."
    }));
    _add(_db, scr_item_make("item_barrow_shield", "Barrow Shield", "weapon", 900, {
        slot: "off_hand", def_bonus: 5, mdef_bonus: 1, weapon_categories: ["shield"], armor_class: "heavy",
        rarity: "rare", act: 4, acquisition: "Barrow gate smith (Act IV).",
        desc: "A tomb door cut down into a shield. DEF +5, MDEF +1. Off-hand."
    }));
    _add(_db, scr_item_make("item_tidesteel_greaves", "Tidesteel Greaves", "armor", 1200, {
        slot: "legs", def_bonus: 5, spd_bonus: 1, armor_class: "medium", rarity: "rare", act: 5,
        acquisition: "Mott's cart, Blackwood road (Act V).",
        desc: "Greaves of tidesteel, never quite dry. DEF +5, SPD +1."
    }));
    _add(_db, scr_item_make("item_crownwall_shield", "Crownwall Shield", "weapon", 2200, {
        slot: "off_hand", def_bonus: 8, mdef_bonus: 2, weapon_categories: ["shield"], armor_class: "heavy",
        rarity: "rare", act: 7, acquisition: "Ashlands outpost (Act VII).",
        desc: "A shield that remembers being a wall. DEF +8, MDEF +2. Off-hand."
    }));
    _add(_db, scr_item_make("item_veil_greaves", "Veil Greaves", "armor", 2800, {
        slot: "legs", def_bonus: 7, armor_class: "heavy", rarity: "rare", act: 8,
        acquisition: "Rimehold armoury (Act VIII).",
        desc: "Plate greaves worked with veil-iron. DEF +7."
    }));

    // ---- Act-by-act progression (2026-11-18 handoff) -----------------------------------------
    // Content spec: one kit per act. Names are fixed; numbers are PLACEHOLDER tier fillers.

    // Act I — common survival gear.
    _add(_db, scr_item_make("item_hidebound_vest", "Hidebound Vest", "armor", 45, {
        def_bonus: 2, hp_bonus: 4, armor_class: "light", rarity: "common", act: 1,
        acquisition: "Pell's forge, Greyhaven (Act I); crafted at the forge.",
        desc: "Stitched hide over a linen shirt. DEF +2, HP +4."
    }));
    _add(_db, scr_item_make("item_soldiers_bulwark", "Soldier's Bulwark", "weapon", 55, {
        slot: "off_hand", def_bonus: 2, weapon_categories: ["shield"], armor_class: "medium",
        rarity: "common", act: 1, acquisition: "Pell's forge, Greyhaven (Act I).",
        desc: "A militia shield, split and rebraced. DEF +2. Off-hand."
    }));
    _add(_db, scr_item_make("item_wanderers_cowl", "Wanderer's Cowl", "helm", 35, {
        def_bonus: 1, eva_bonus: 2, armor_class: "light", rarity: "common", act: 1,
        acquisition: "Marda's store, Greyhaven (Act I).",
        desc: "A road-stained cowl. DEF +1, EVA +2."
    }));
    _add(_db, scr_item_make("item_woodsman_bow", "Woodsman's Bow", "weapon", 70, {
        atk_bonus: 3, acc_bonus: 4, weapon_categories: ["bow"], rarity: "common", act: 1,
        acquisition: "Reserved for a future bow-proficient recruit; not stocked in the current build.",
        desc: "A hunting bow of grey ash. ATK +3, ACC +4. No current party member can equip it."
    }));
    _add(_db, scr_item_make("item_initiates_branch", "Initiate's Branch", "weapon", 60, {
        atk_bonus: 2, mag_bonus: 3, weapon_categories: ["staff"], rarity: "common", act: 1,
        acquisition: "Pell's forge, Greyhaven (Act I).",
        desc: "A practice staff with a copper ferrule. ATK +2, MAG +3."
    }));
    _add(_db, scr_item_make("item_wanderers_pike", "Wanderer's Pike", "weapon", 80, {
        atk_bonus: 4, def_bonus: 1, weapon_categories: ["polearm"], rarity: "common", act: 1,
        acquisition: "Pell's forge, Greyhaven (Act I).",
        desc: "A road-worn pike. ATK +4, DEF +1. No roster class is trained with a polearm yet."
    }));
    _add(_db, scr_item_make("item_wayfarers_breeches", "Wayfarer's Breeches", "armor", 40, {
        slot: "legs", def_bonus: 1, spd_bonus: 1, armor_class: "light", rarity: "common", act: 1,
        acquisition: "Marda's store, Greyhaven (Act I).",
        desc: "Patched breeches cut for walking. DEF +1, SPD +1."
    }));
    _add(_db, scr_item_make("item_commoners_draught", "Commoner's Draught", "consumable", 25, {
        heal: 20, rarity: "common", act: 1, acquisition: "Marda's store, Greyhaven (Act I).",
        desc: "Small beer and bitterroot. Restores 20 HP."
    }));
    _add(_db, scr_item_make("item_aether_vial", "Aether Vial", "consumable", 45, {
        mp_restore: 12, rarity: "uncommon", act: 1, acquisition: "Marda's store, Greyhaven (Act I).",
        desc: "A stoppered breath of aether. Restores 12 MP."
    }));
    _add(_db, scr_item_make("item_venomroot_extract", "Venomroot Extract", "consumable", 30, {
        cures_poison: true, rarity: "uncommon", act: 1, acquisition: "Marda's store, Greyhaven (Act I).",
        desc: "A bitter draught that drives poison out. Cures poison."
    }));

    // Act II — iron and steel.
    _add(_db, scr_item_make("item_ironweave", "Ironweave", "armor", 190, {
        def_bonus: 5, hp_bonus: 6, armor_class: "medium", rarity: "uncommon", act: 2,
        acquisition: "Len's shop, Wrenfield (Act II); crafted at the forge.",
        desc: "Iron rings woven into heavy cloth. DEF +5, HP +6."
    }));
    _add(_db, scr_item_make("item_ironwall", "Ironwall", "weapon", 230, {
        slot: "off_hand", def_bonus: 4, weapon_categories: ["shield"], armor_class: "medium",
        rarity: "uncommon", act: 2, acquisition: "Len's shop, Wrenfield (Act II).",
        desc: "A Wrenfield wall-shield. DEF +4. Off-hand."
    }));
    _add(_db, scr_item_make("item_ironbound_greaves", "Ironbound Greaves", "armor", 150, {
        slot: "legs", def_bonus: 2, armor_class: "medium", rarity: "uncommon", act: 2,
        acquisition: "Len's shop, Wrenfield (Act II).",
        desc: "Greaves bound with iron strip. DEF +2."
    }));
    _add(_db, scr_item_make("item_hunters_cover", "Hunter's Cover", "armor", 170, {
        def_bonus: 3, spd_bonus: 2, armor_class: "light", rarity: "uncommon", act: 2,
        acquisition: "Len's shop, Wrenfield (Act II).",
        desc: "A hunter's layered cloak. DEF +3, SPD +2."
    }));
    _add(_db, scr_item_make("item_swiftwind", "Swiftwind", "weapon", 200, {
        atk_bonus: 5, spd_bonus: 2, acc_bonus: 5, weapon_categories: ["bow"], rarity: "uncommon", act: 2,
        acquisition: "Reserved for a future bow-proficient recruit; not stocked in the current build.",
        desc: "A recurved bow that sings on release. ATK +5, SPD +2, ACC +5. No current party member can equip it."
    }));
    _add(_db, scr_item_make("item_bloodcleaver", "Bloodcleaver", "weapon", 220, {
        atk_bonus: 7, weapon_categories: ["heavy_sword"], rarity: "uncommon", act: 2,
        acquisition: "Len's shop, Wrenfield (Act II).",
        desc: "A butcher's blade reground for war. ATK +7."
    }));
    _add(_db, scr_item_make("item_ironfall", "Ironfall", "weapon", 240, {
        atk_bonus: 8, weapon_categories: ["heavy_sword"], two_handed: true, rarity: "uncommon", act: 2,
        acquisition: "Len's shop, Wrenfield (Act II).",
        desc: "A two-handed greatsword named for what it does. ATK +8."
    }));

    // Act III — the Crown's shadow.
    _add(_db, scr_item_make("item_wardens_plate", "Warden's Plate", "armor", 480, {
        def_bonus: 7, mdef_bonus: 2, armor_class: "heavy", rarity: "rare", act: 3,
        acquisition: "Valemere arms (Act III); crafted at the forge.",
        desc: "A Warden's breastplate, stamped at the collar. DEF +7, MDEF +2."
    }));
    _add(_db, scr_item_make("item_crownwatch_helm", "Crownwatch Helm", "helm", 430, {
        def_bonus: 4, acc_bonus: 2, armor_class: "medium", rarity: "rare", act: 3,
        acquisition: "Valemere arms (Act III).",
        desc: "A watch helm with a narrow eye-slit. DEF +4, ACC +2."
    }));
    _add(_db, scr_item_make("item_oathbound_aegis", "Oathbound Aegis", "weapon", 520, {
        slot: "off_hand", def_bonus: 5, mdef_bonus: 2, weapon_categories: ["shield"], armor_class: "heavy",
        rarity: "rare", act: 3, acquisition: "Valemere arms (Act III).",
        desc: "A shield sworn to a dead captain. DEF +5, MDEF +2. Off-hand."
    }));
    _add(_db, scr_item_make("item_silent_thorn", "Silent Thorn", "weapon", 510, {
        atk_bonus: 7, crit_bonus: 0.04, weapon_categories: ["dagger"], rarity: "rare", act: 3,
        acquisition: "Valemere arms (Act III).",
        desc: "A thin dirk with a needle point. ATK +7, CRIT +4%."
    }));
    _add(_db, scr_item_make("item_kings_longshot", "King's Longshot", "weapon", 560, {
        atk_bonus: 8, acc_bonus: 6, weapon_categories: ["bow"], rarity: "rare", act: 3,
        acquisition: "Reserved for a future bow-proficient recruit; not stocked in the current build.",
        desc: "A longbow from the royal hunt. ATK +8, ACC +6. No current party member can equip it."
    }));
    _add(_db, scr_item_make("item_stonebreaker", "Stonebreaker", "weapon", 600, {
        atk_bonus: 10, weapon_categories: ["heavy_sword"], two_handed: true, rarity: "rare", act: 3,
        acquisition: "Valemere arms (Act III).",
        desc: "A greatsword with a mason's chisel ground into the fuller. ATK +10."
    }));
    _add(_db, scr_item_make("item_wardens_greaves", "Warden's Greaves", "armor", 420, {
        slot: "legs", def_bonus: 3, mdef_bonus: 1, armor_class: "heavy", rarity: "rare", act: 3,
        acquisition: "Valemere arms (Act III).",
        desc: "A Warden's greaves, still mud-caked. DEF +3, MDEF +1."
    }));

    // Act IV — the forgotten Aether.
    _add(_db, scr_item_make("item_heart_of_aether", "Heart of Aether", "accessory", 900, {
        mag_bonus: 5, mdef_bonus: 4, hp_bonus: 8, rarity: "rare", act: 4,
        acquisition: "Aethari ruin vault (Act IV).",
        desc: "A suspended drop of aether, warm through the glass. MAG +5, MDEF +4, HP +8."
    }));
    _add(_db, scr_item_make("item_aethari_longbow", "Aethari Longbow", "weapon", 1100, {
        atk_bonus: 10, mag_bonus: 3, acc_bonus: 6, weapon_categories: ["bow"], rarity: "rare", act: 4,
        acquisition: "Reserved for a future bow-proficient recruit; not stocked in the current build.",
        desc: "A bow of grown wood and white metal. ATK +10, MAG +3, ACC +6. No current party member can equip it."
    }));
    _add(_db, scr_item_make("item_aetherbound_circlet", "Aetherbound Circlet", "helm", 950, {
        mag_bonus: 4, mdef_bonus: 4, armor_class: "light", rarity: "rare", act: 4,
        acquisition: "Aethari ruin vault (Act IV); crafted at the forge.",
        desc: "A circlet of pale wire. MAG +4, MDEF +4."
    }));
    _add(_db, scr_item_make("item_elderwood_staff", "Elderwood Staff", "weapon", 1050, {
        atk_bonus: 8, mag_bonus: 7, weapon_categories: ["staff"], rarity: "rare", act: 4,
        acquisition: "Aethari ruin vault (Act IV).",
        desc: "Elderwood, still growing at the tip. ATK +8, MAG +7."
    }));
    _add(_db, scr_item_make("item_veilstalkers_hood", "Veilstalker's Hood", "helm", 900, {
        def_bonus: 3, spd_bonus: 2, eva_bonus: 4, armor_class: "light", rarity: "rare", act: 4,
        acquisition: "Aethari ruin vault (Act IV).",
        desc: "A hood that eats the edge of a silhouette. DEF +3, SPD +2, EVA +4."
    }));
    _add(_db, scr_item_make("item_dawnveil_robes", "Dawnveil Robes", "armor", 1000, {
        def_bonus: 5, mdef_bonus: 7, mag_bonus: 3, armor_class: "light", rarity: "rare", act: 4,
        acquisition: "Aethari ruin vault (Act IV).",
        desc: "Robes woven with dawn-thread. DEF +5, MDEF +7, MAG +3."
    }));
    _add(_db, scr_item_make("item_aethari_vestments", "Aethari Vestments", "armor", 1150, {
        def_bonus: 8, mdef_bonus: 6, armor_class: "medium", rarity: "rare", act: 4,
        acquisition: "Aethari ruin vault (Act IV).",
        desc: "Layered vestments cut for a people who expected to live. DEF +8, MDEF +6."
    }));

    // Act V — the royal reckoning.
    _add(_db, scr_item_make("item_crownward_armor", "Crownward Armor", "armor", 1600, {
        def_bonus: 12, mdef_bonus: 4, armor_class: "heavy", rarity: "rare", act: 5,
        acquisition: "The royal vault, Saltreach (Act V); crafted at the forge.",
        desc: "Crown-issue plate, the seal still bright. DEF +12, MDEF +4."
    }));
    _add(_db, scr_item_make("item_crownward_sabatons", "Crownward Sabatons", "armor", 1400, {
        slot: "legs", def_bonus: 6, armor_class: "heavy", rarity: "rare", act: 5,
        acquisition: "The royal vault, Saltreach (Act V).",
        desc: "Sabatons from the Crown's own armoury. DEF +6."
    }));
    _add(_db, scr_item_make("item_gravekeeper", "Gravekeeper", "weapon", 1700, {
        atk_bonus: 15, weapon_categories: ["heavy_sword"], rarity: "rare", act: 5,
        acquisition: "The royal vault, Saltreach (Act V).",
        desc: "A grave-warden's blade, used more for digging than killing. ATK +15."
    }));
    _add(_db, scr_item_make("item_gravewarden_armor", "Gravewarden Armor", "armor", 1800, {
        def_bonus: 13, hp_bonus: 10, armor_class: "heavy", rarity: "rare", act: 5,
        acquisition: "The royal vault, Saltreach (Act V).",
        desc: "Plate worn by the keepers of the royal dead. DEF +13, HP +10."
    }));

    // Act VI — the Ash Veil.
    _add(_db, scr_item_make("item_ashen_ward", "Ashen Ward", "accessory", 1900, {
        def_bonus: 3, elem_res: { fire: 15, shadow: 10 }, rarity: "rare", act: 6,
        acquisition: "Ashfall reliquary (Act VI).",
        desc: "A ward of ash-glass. DEF +3, FIRE +15%, SHADOW +10%."
    }));
    _add(_db, scr_item_make("item_veilward_charm", "Veilward Charm", "accessory", 2000, {
        mdef_bonus: 5, elem_res: { shadow: 15 }, rarity: "rare", act: 6,
        acquisition: "Ashfall reliquary (Act VI).",
        desc: "A charm that keeps the Veil at arm's length. MDEF +5, SHADOW +15%."
    }));
    _add(_db, scr_item_make("item_ashbound_treads", "Ashbound Treads", "armor", 1800, {
        slot: "legs", def_bonus: 6, elem_res: { fire: 10 }, armor_class: "medium", rarity: "rare", act: 6,
        acquisition: "Ashfall reliquary (Act VI).",
        desc: "Treads bound in ash-cloth. DEF +6, FIRE +10%."
    }));
    _add(_db, scr_item_make("item_veilforged_plate", "Veilforged Plate", "armor", 2100, {
        def_bonus: 14, mdef_bonus: 6, armor_class: "heavy", rarity: "rare", act: 6,
        acquisition: "Ashfall reliquary (Act VI); crafted at the forge.",
        desc: "Plate quenched on the far side of the Veil. DEF +14, MDEF +6."
    }));
    _add(_db, scr_item_make("item_ashen_sigil", "Ashen Sigil", "accessory", 1900, {
        mag_bonus: 4, elem_res: { fire: 15 }, rarity: "rare", act: 6,
        acquisition: "Ashfall reliquary (Act VI).",
        desc: "A sigil that drinks heat. MAG +4, FIRE +15%."
    }));

    // Act VII — the legendary age. Quest/boss rewards, never sold.
    _add(_db, scr_item_make("item_worldrender", "Worldrender", "weapon", 0, {
        atk_bonus: 24, acc_bonus: 6, weapon_categories: ["greatsword"], two_handed: true,
        rarity: "legendary", act: 7, unique: true, sellable: false,
        acquisition: "The Ash King's standard (guaranteed, once; Act VII).",
        desc: "A greatsword that parts the air a half-beat late. ATK +24, ACC +6. Cannot be sold."
    }));
    _add(_db, scr_item_make("item_thronebreaker", "Thronebreaker", "weapon", 0, {
        atk_bonus: 23, def_bonus: 4, weapon_categories: ["heavy_sword"], two_handed: true,
        rarity: "legendary", act: 7, unique: true, sellable: false,
        acquisition: "The empty throne, Ashlands keep (guaranteed, once; Act VII).",
        desc: "A two-hander built to end a line of kings. ATK +23, DEF +4. Cannot be sold."
    }));
    _add(_db, scr_item_make("item_wyrmbane", "Wyrmbane", "weapon", 0, {
        atk_bonus: 20, acc_bonus: 8, weapon_categories: ["bow"], rarity: "legendary", act: 7, unique: true, sellable: false,
        acquisition: "Reserved for a future bow-proficient recruit; not placed in the current build.",
        desc: "A bow strung with something that is not gut. ATK +20, ACC +8. No current party member can equip it. Cannot be sold."
    }));
    _add(_db, scr_item_make("item_wyrmscale_harness", "Wyrmscale Harness", "armor", 0, {
        def_bonus: 17, elem_res: { fire: 20 }, armor_class: "heavy", rarity: "legendary", act: 7, unique: true, sellable: false,
        acquisition: "The wyrm's roost (guaranteed, once; Act VII).",
        desc: "Harness cut from a wyrm's own scales. DEF +17, FIRE +20%. Cannot be sold."
    }));
    _add(_db, scr_item_make("item_last_light_of_eldoria", "Last Light of Eldoria", "accessory", 0, {
        def_bonus: 6, mdef_bonus: 8, hp_bonus: 15, rarity: "legendary", act: 7, unique: true, sellable: false,
        acquisition: "The last lit shrine of Eldoria (Act VII).",
        desc: "A lamp that has not gone out. DEF +6, MDEF +8, HP +15. Cannot be sold."
    }));
    _add(_db, scr_item_make("item_regalia_first_sovereign", "Regalia of the First Sovereign", "armor", 0, {
        def_bonus: 18, mdef_bonus: 10, armor_class: "heavy", rarity: "legendary", act: 7, unique: true, sellable: false,
        acquisition: "The First Sovereign's barrow (Act VII, optional).",
        desc: "The first crown's own war-plate. DEF +18, MDEF +10. Cannot be sold."
    }));

    // Act VIII — the last crown.
    _add(_db, scr_item_make("item_solmourn", "Solmourn", "weapon", 0, {
        atk_bonus: 21, mag_bonus: 8, elem_res: { shadow: 15 }, weapon_categories: ["holy_sword"], two_handed: true,
        rarity: "legendary", act: 8, unique: true, sellable: false,
        acquisition: "The Silver Guard's last vigil (Act VIII).",
        desc: "A two-handed blade that mourns as it burns. ATK +21, MAG +8, SHADOW +15%. Cannot be sold."
    }));
    _add(_db, scr_item_make("item_crown_of_first_king", "Crown of the First King", "helm", 0, {
        def_bonus: 12, mdef_bonus: 10, hp_bonus: 10, armor_class: "heavy", rarity: "legendary", act: 8, unique: true, sellable: false,
        acquisition: "The First King's sealed crown (Act VIII).",
        desc: "The crown before the Crownveil. DEF +12, MDEF +10, HP +10. Cannot be sold."
    }));
    _add(_db, scr_item_make("item_elixir_first_flame", "Elixir of the First Flame", "consumable", 1200, {
        revive_pct: 1.0, rarity: "rare", act: 8, acquisition: "Rimehold, the last vault (Act VIII).",
        desc: "The first flame, held in glass. Revives one fallen member at full HP."
    }));

    // ---- Twenty crafting materials (2026-11-18 handoff) -------------------------------------
    _add(_db, scr_item_make("item_iron_ore", "Iron Ore", "misc", 10, { rarity: "common", act: 1, acquisition: "Crown patrols and mine rubble (Act I+).", desc: "Rough iron, ready for a forge. Crafting material." }));
    _add(_db, scr_item_make("item_copper_ore", "Copper Ore", "misc", 12, { rarity: "common", act: 1, acquisition: "Bandits and road rubble (Act I+).", desc: "Soft copper, good for fittings. Crafting material." }));
    _add(_db, scr_item_make("item_wolf_pelt", "Wolf Pelt", "misc", 14, { rarity: "common", act: 1, acquisition: "Grey ash wolves (Act I).", desc: "A thick grey pelt. Crafting material." }));
    _add(_db, scr_item_make("item_boar_hide", "Boar Hide", "misc", 16, { rarity: "common", act: 1, acquisition: "Boars and beast-type enemies (Act I+).", desc: "Scarred hide, tough as board. Crafting material." }));
    _add(_db, scr_item_make("item_beast_fang", "Beast Fang", "misc", 22, { rarity: "common", act: 2, acquisition: "Wolves and beast-type enemies (Act II+).", desc: "A curved fang. Crafting material." }));
    _add(_db, scr_item_make("item_monster_claw", "Monster Claw", "misc", 26, { rarity: "common", act: 2, acquisition: "Wretches and clawed enemies (Act II+).", desc: "A black claw, still sharp. Crafting material." }));
    _add(_db, scr_item_make("item_steel_ingot", "Steel Ingot", "misc", 40, { rarity: "uncommon", act: 2, acquisition: "Sold by Len and later smiths; smelted from iron.", desc: "A clean bar of steel. Crafting material." }));
    _add(_db, scr_item_make("item_silver_ore", "Silver Ore", "misc", 50, { rarity: "uncommon", act: 3, acquisition: "Capital mines and Crown officers (Act III+).", desc: "Ore with a bright seam. Crafting material." }));
    _add(_db, scr_item_make("item_gold_ore", "Gold Ore", "misc", 90, { rarity: "uncommon", act: 5, acquisition: "Royal vaults and rich seams (Act V+).", desc: "Ore the Crown has already counted. Crafting material." }));
    _add(_db, scr_item_make("item_black_iron", "Black Iron", "misc", 110, { rarity: "rare", act: 5, acquisition: "Barrow and Veil-touched enemies (Act V+).", desc: "Iron that drank something dark. Crafting material." }));
    _add(_db, scr_item_make("item_ancient_cloth", "Ancient Cloth", "misc", 70, { rarity: "rare", act: 4, acquisition: "Aethari ruin chests (Act IV).", desc: "Cloth that outlasted its weavers. Crafting material." }));
    _add(_db, scr_item_make("item_enchanted_wood", "Enchanted Wood", "misc", 85, { rarity: "rare", act: 4, acquisition: "Elderwood groves (Act IV+).", desc: "Wood that still remembers growing. Crafting material." }));
    _add(_db, scr_item_make("item_pure_crystal", "Pure Crystal", "misc", 95, { rarity: "rare", act: 4, acquisition: "Aethari ruin vaults (Act IV).", desc: "A crystal with nothing inside but light. Crafting material." }));
    _add(_db, scr_item_make("item_ancient_rune", "Ancient Rune", "misc", 130, { rarity: "rare", act: 5, acquisition: "Aethari and royal vaults (Act V+).", desc: "A rune cut before the Crown. Crafting material." }));
    _add(_db, scr_item_make("item_dragon_scale", "Dragon Scale", "misc", 220, { rarity: "rare", act: 7, acquisition: "Wyrm-type bosses (Act VII).", desc: "A scale that will not scratch. Crafting material." }));
    _add(_db, scr_item_make("item_ash_crystal", "Ash Crystal", "misc", 140, { rarity: "rare", act: 6, acquisition: "Ashfall enemies (Act VI+).", desc: "A crystal of fused ash. Crafting material." }));
    _add(_db, scr_item_make("item_shadow_essence", "Shadow Essence", "misc", 150, { rarity: "rare", act: 6, acquisition: "Veil-touched enemies (Act VI+).", desc: "Something that moves when the bottle does not. Crafting material." }));
    _add(_db, scr_item_make("item_phoenix_ash", "Phoenix Ash", "misc", 180, { rarity: "rare", act: 7, acquisition: "Emberwake and fire-bosses (Act VII+).", desc: "Ash that is still warm. Crafting material." }));
    _add(_db, scr_item_make("item_holy_fragment", "Holy Fragment", "misc", 190, { rarity: "rare", act: 7, acquisition: "Silver Guard shrines (Act VII+).", desc: "A shard of consecrated stone. Crafting material." }));
    _add(_db, scr_item_make("item_demon_core", "Demon Core", "misc", 240, { rarity: "rare", act: 8, acquisition: "The last ash-things (Act VIII).", desc: "A core that beats without a body. Crafting material." }));

    // ---- Weapon coverage: one weapon per class per act --------------------------------------
    // A weapon tier for all five classes in every act (Acts III-VIII are still data-only).
    // Longsword = baseline ATK; heavy sword +1 ATK; holy sword +MDEF; dagger -ATK +SPD;
    // spellbook -ATK +MDEF. This keeps the party's damage-per-round close to one weapon's worth
    // per member instead of stacking the highest tier onto only one or two characters.

    // Act I (Kael's Iron Sword and Lyra's Hunter's Knife already existed).
    _add(_db, scr_item_make("item_apprentices_codex", "Apprentice's Codex", "weapon", 90, {
        atk_bonus: 2, mdef_bonus: 2, weapon_categories: ["spellbook"], rarity: "common", act: 1,
        acquisition: "Pell's forge, Greyhaven (Act I).",
        desc: "A copybook of half-learned forms. ATK +2, MDEF +2."
    }));
    _add(_db, scr_item_make("item_chapel_blade", "Chapel Blade", "weapon", 95, {
        atk_bonus: 3, mdef_bonus: 1, weapon_categories: ["holy_sword"], rarity: "common", act: 1,
        acquisition: "Pell's forge, Greyhaven (Act I).",
        desc: "A chapel-issue sword, blessed once and rarely since. ATK +3, MDEF +1."
    }));
    _add(_db, scr_item_make("item_yoke_cleaver", "Yoke Cleaver", "weapon", 100, {
        atk_bonus: 4, weapon_categories: ["heavy_sword"], rarity: "common", act: 1,
        acquisition: "Pell's forge, Greyhaven (Act I).",
        desc: "A Rebel smith's cleaver ground down into a sword. ATK +4."
    }));

    // Act II (Kael's Millhaven Sabre already existed).
    _add(_db, scr_item_make("item_millhaven_stiletto", "Millhaven Stiletto", "weapon", 170, {
        atk_bonus: 4, spd_bonus: 2, weapon_categories: ["dagger"], rarity: "uncommon", act: 2,
        acquisition: "Len's shop, Wrenfield (Act II).",
        desc: "A narrow boot knife from the mill district. ATK +4, SPD +2."
    }));
    _add(_db, scr_item_make("item_millhaven_primer", "Millhaven Primer", "weapon", 175, {
        atk_bonus: 4, mdef_bonus: 3, weapon_categories: ["spellbook"], rarity: "uncommon", act: 2,
        acquisition: "Len's shop, Wrenfield (Act II).",
        desc: "A primer of wards copied by a Crown scribe. ATK +4, MDEF +3."
    }));
    _add(_db, scr_item_make("item_penitent_blade", "Penitent Blade", "weapon", 180, {
        atk_bonus: 5, mdef_bonus: 2, weapon_categories: ["holy_sword"], rarity: "uncommon", act: 2,
        acquisition: "Len's shop, Wrenfield (Act II).",
        desc: "A Silver Guard blade, surrendered and bought back. ATK +5, MDEF +2."
    }));
    _add(_db, scr_item_make("item_patrol_greatsword", "Patrol Greatsword", "weapon", 190, {
        atk_bonus: 6, weapon_categories: ["heavy_sword"], two_handed: true, rarity: "uncommon", act: 2,
        acquisition: "Len's shop, Wrenfield (Act II).",
        desc: "A Crown patrolman's two-hander, still tagged. ATK +6."
    }));

    // Act III (Lyra's Ledger Dirk already existed).
    _add(_db, scr_item_make("item_valemere_longsword", "Valemere Longsword", "weapon", 500, {
        atk_bonus: 7, weapon_categories: ["longsword"], rarity: "rare", act: 3,
        acquisition: "Valemere arms (Act III).",
        desc: "A city-watch blade with a brass fuller. ATK +7."
    }));
    _add(_db, scr_item_make("item_ledger_codex", "Ledger Codex", "weapon", 500, {
        atk_bonus: 6, mdef_bonus: 4, weapon_categories: ["spellbook"], rarity: "rare", act: 3,
        acquisition: "Valemere arms (Act III).",
        desc: "A magistrate's codex, margins full of debts. ATK +6, MDEF +4."
    }));
    _add(_db, scr_item_make("item_saltlight_blade", "Saltlight Blade", "weapon", 510, {
        atk_bonus: 7, mdef_bonus: 3, weapon_categories: ["holy_sword"], rarity: "rare", act: 3,
        acquisition: "Valemere arms (Act III).",
        desc: "A sword that holds salt-lamp light in the fuller. ATK +7, MDEF +3."
    }));
    _add(_db, scr_item_make("item_watchmans_greatsword", "Watchman's Greatsword", "weapon", 540, {
        atk_bonus: 9, weapon_categories: ["heavy_sword"], two_handed: true, rarity: "rare", act: 3,
        acquisition: "Valemere arms (Act III).",
        desc: "The watch's gate sword, chained to the post it was taken from. ATK +9."
    }));

    // Act IV (Sera's Sanctuary Oathblade and Taren's Oathbreaker already existed).
    _add(_db, scr_item_make("item_barrow_longsword", "Barrow Longsword", "weapon", 900, {
        atk_bonus: 10, weapon_categories: ["longsword"], rarity: "rare", act: 4,
        acquisition: "Barrow gate smith (Act IV).",
        desc: "Tomb-iron, straight and cold in the hand. ATK +10."
    }));
    _add(_db, scr_item_make("item_tomb_shard_dirk", "Tomb Shard Dirk", "weapon", 880, {
        atk_bonus: 8, spd_bonus: 3, weapon_categories: ["dagger"], rarity: "rare", act: 4,
        acquisition: "Barrow gate smith (Act IV).",
        desc: "A dirk ground from a broken grave-marker. ATK +8, SPD +3."
    }));
    _add(_db, scr_item_make("item_barrow_codex", "Barrow Codex", "weapon", 900, {
        atk_bonus: 8, mdef_bonus: 5, weapon_categories: ["spellbook"], rarity: "rare", act: 4,
        acquisition: "Barrow gate smith (Act IV).",
        desc: "A burial codex, still sealed against the dark. ATK +8, MDEF +5."
    }));
    _add(_db, scr_item_make("item_vigil_blade", "Vigil Blade", "weapon", 920, {
        atk_bonus: 9, mdef_bonus: 4, weapon_categories: ["holy_sword"], rarity: "rare", act: 4,
        acquisition: "Barrow gate smith (Act IV).",
        desc: "A blade kept lit at a tomb that had no visitors. ATK +9, MDEF +4."
    }));

    // Act V (Kael's Tidesteel Blade already existed).
    _add(_db, scr_item_make("item_tideglass_dirk", "Tideglass Dirk", "weapon", 1350, {
        atk_bonus: 11, spd_bonus: 3, weapon_categories: ["dagger"], rarity: "rare", act: 5,
        acquisition: "Mott's cart, Blackwood road (Act V).",
        desc: "A dirk with a tideglass edge, always wet. ATK +11, SPD +3."
    }));
    _add(_db, scr_item_make("item_tidebound_codex", "Tidebound Codex", "weapon", 1380, {
        atk_bonus: 11, mdef_bonus: 6, weapon_categories: ["spellbook"], rarity: "rare", act: 5,
        acquisition: "Mott's cart, Blackwood road (Act V).",
        desc: "Pages of oilskin, bound in net. ATK +11, MDEF +6."
    }));
    _add(_db, scr_item_make("item_drowned_bell_blade", "Drowned Bell Blade", "weapon", 1400, {
        atk_bonus: 12, mdef_bonus: 5, weapon_categories: ["holy_sword"], rarity: "rare", act: 5,
        acquisition: "Mott's cart, Blackwood road (Act V).",
        desc: "A sword forged from a drowned bell's tongue. ATK +12, MDEF +5."
    }));
    _add(_db, scr_item_make("item_saltreach_maul", "Saltreach Maul", "weapon", 1450, {
        atk_bonus: 13, weapon_categories: ["heavy_sword"], two_handed: true, rarity: "rare", act: 5,
        acquisition: "Mott's cart, Blackwood road (Act V).",
        desc: "A wrecking maul with a sword's grip. ATK +13."
    }));

    // Act VI (Taren's Ironspine Maul already existed).
    _add(_db, scr_item_make("item_ironspine_longsword", "Ironspine Longsword", "weapon", 1950, {
        atk_bonus: 14, weapon_categories: ["longsword"], rarity: "rare", act: 6,
        acquisition: "Mott's cart, Blackwood road (Act VI).",
        desc: "A mine overseer's blade, eaten by rust at the ricasso. ATK +14."
    }));
    _add(_db, scr_item_make("item_mine_shard_dirk", "Mine Shard Dirk", "weapon", 1900, {
        atk_bonus: 12, spd_bonus: 3, weapon_categories: ["dagger"], rarity: "rare", act: 6,
        acquisition: "Mott's cart, Blackwood road (Act VI).",
        desc: "A dirk cut from a machine's cutting tooth. ATK +12, SPD +3."
    }));
    _add(_db, scr_item_make("item_architect_codex", "Architect Codex", "weapon", 1950, {
        atk_bonus: 12, mdef_bonus: 7, weapon_categories: ["spellbook"], rarity: "rare", act: 6,
        acquisition: "Mott's cart, Blackwood road (Act VI).",
        desc: "A codex of machined plates, half of it still legible. ATK +12, MDEF +7."
    }));
    _add(_db, scr_item_make("item_constructs_bane", "Construct's Bane", "weapon", 1980, {
        atk_bonus: 13, mdef_bonus: 5, weapon_categories: ["holy_sword"], rarity: "rare", act: 6,
        acquisition: "Mott's cart, Blackwood road (Act VI).",
        desc: "A blade etched against made things. ATK +13, MDEF +5."
    }));

    // Act VII (Kael's Ashlands Edge and Sera's Barrow King's Blade already existed).
    _add(_db, scr_item_make("item_ashglass_dirk", "Ashglass Dirk", "weapon", 2550, {
        atk_bonus: 14, spd_bonus: 4, weapon_categories: ["dagger"], rarity: "rare", act: 7,
        acquisition: "Sarn's outpost wagon, barrow gate (Act VII).",
        desc: "A dirk of fused ash, light and mean. ATK +14, SPD +4."
    }));
    _add(_db, scr_item_make("item_ember_codex", "Ember Codex", "weapon", 2550, {
        atk_bonus: 14, mdef_bonus: 8, weapon_categories: ["spellbook"], rarity: "rare", act: 7,
        acquisition: "Sarn's outpost wagon, barrow gate (Act VII).",
        desc: "A codex whose pages will not burn. ATK +14, MDEF +8."
    }));
    _add(_db, scr_item_make("item_cinder_vigil", "Cinder Vigil", "weapon", 2580, {
        atk_bonus: 15, mdef_bonus: 6, weapon_categories: ["holy_sword"], rarity: "rare", act: 7,
        acquisition: "Sarn's outpost wagon, barrow gate (Act VII).",
        desc: "A vigil blade kept burning through the ashfall. ATK +15, MDEF +6."
    }));
    _add(_db, scr_item_make("item_ashfall_greatsword", "Ashfall Greatsword", "weapon", 2620, {
        atk_bonus: 17, weapon_categories: ["heavy_sword"], rarity: "rare", act: 7,
        acquisition: "Sarn's outpost wagon, barrow gate (Act VII).",
        desc: "A greatsword crusted with cooled ash. ATK +17."
    }));

    // Act VIII (Kael's True-Name Blade and Sera's Rime Sword already existed).
    _add(_db, scr_item_make("item_veilstep_dirk", "Veilstep Dirk", "weapon", 3150, {
        atk_bonus: 16, spd_bonus: 4, weapon_categories: ["dagger"], rarity: "rare", act: 8,
        acquisition: "Rimehold armoury (Act VIII).",
        desc: "A dirk that leaves no print in the frost. ATK +16, SPD +4."
    }));
    _add(_db, scr_item_make("item_rime_codex", "Rime Codex", "weapon", 3180, {
        atk_bonus: 16, mdef_bonus: 9, weapon_categories: ["spellbook"], rarity: "rare", act: 8,
        acquisition: "Rimehold armoury (Act VIII).",
        desc: "A codex rimed shut, opening only for its reader. ATK +16, MDEF +9."
    }));
    _add(_db, scr_item_make("item_winterforge_greatsword", "Winterforge Greatsword", "weapon", 3250, {
        atk_bonus: 20, weapon_categories: ["heavy_sword"], rarity: "rare", act: 8,
        acquisition: "Rimehold armoury (Act VIII).",
        desc: "A greatsword quenched in a Frostwilds spring. ATK +20."
    }));

    // Existing gear gets the same metadata so every item is queryable by act/rarity/source.
    var _meta = {
        item_minor_potion:          { rarity: "common",   act: 1, acquisition: "Marda, Greyhaven store; most chests." },
        item_antidote:              { rarity: "common",   act: 1, acquisition: "Marda, Greyhaven store; most chests." },
        item_ether:                 { rarity: "uncommon", act: 2, acquisition: "Len, Wrenfield; Marda from Act II." },
        item_iron_sword:            { rarity: "common",   act: 1, acquisition: "Pell's forge, Greyhaven (Act I)." },
        item_leather_armor:         { rarity: "common",   act: 1, acquisition: "Pell's forge, Greyhaven (Act I)." },
        item_iron_helm:             { rarity: "common",   act: 1, acquisition: "Pell's forge, Greyhaven (Act I); Watchtower chests." },
        item_chain_mail:            { rarity: "uncommon", act: 2, acquisition: "Len's shop, Wrenfield (Act II)." },
        item_hunters_knife:         { rarity: "common",   act: 1, acquisition: "Watchtower chest (Act I)." },
        item_hunters_charm:         { rarity: "common",   act: 1, acquisition: "Hunter's cache (Act I)." },
        item_ashen_longbow:         { rarity: "uncommon", act: 1, acquisition: "Bandit camp cache (Act I). Reserved for a future bow-proficient recruit; not sold." },
        item_blackguards_longsword: { rarity: "legendary", act: 1, unique: true, sellable: false, acquisition: "The Blackguard, Old Watchtower (guaranteed, once)." },
        item_travel_brigandine:     { rarity: "common",   act: 0, acquisition: "Taren's starting armour (Chapter 2)." },
        item_kaels_longsword:       { rarity: "common",   act: 0, acquisition: "Kael's starting weapon." },
        item_bastard_sword:         { rarity: "common",   act: 0, acquisition: "Taren's starting weapon." },
        item_twin_daggers:          { rarity: "common",   act: 0, acquisition: "Lyra's starting weapon." },
        item_spellbook:             { rarity: "common",   act: 0, acquisition: "Caelan's starting weapon." },
        item_holy_sword:            { rarity: "common",   act: 0, acquisition: "Sera's starting weapon." }
    };
    var _mnames = variable_struct_get_names(_meta);
    for (var _mi = 0; _mi < array_length(_mnames); _mi++) {
        var _mid = _mnames[_mi];
        if (!variable_struct_exists(_db, _mid)) continue;
        var _row = _meta[$ _mid];
        var _entry = _db[$ _mid];
        var _keys = variable_struct_get_names(_row);
        for (var _ki = 0; _ki < array_length(_keys); _ki++) _entry[$ _keys[_ki]] = _row[$ _keys[_ki]];
    }

    // Every record is finalized and validated once, after the metadata pass: that pass supplies
    // rarity/act for the oldest items, and `unlock_act` must be built from the final act.
    var _ids = variable_struct_get_names(_db);
    for (var _vi = 0; _vi < array_length(_ids); _vi++) {
        var _rec = _db[$ _ids[_vi]];
        scr_item_finalize(_rec);
        var _verrs = scr_item_validate(_rec);
        _rec.validation_errors = _verrs;
        _rec.valid = (array_length(_verrs) == 0);
        if (!_rec.valid) {
            array_push(global.item_db_invalid, _ids[_vi]);
            array_push(global.item_db_errors, { id: _ids[_vi], errors: _verrs });
            show_debug_message("[item_db] INVALID " + _ids[_vi] + ": " + scr_item_join(_verrs, "; "));
        }
    }
    if (array_length(global.item_db_invalid) > 0) {
        show_debug_message("[item_db] " + string(array_length(global.item_db_invalid)) + " invalid item record(s); see scr_item_db_audit().");
    }
    global.item_db = _db;
    return global.item_db;
}

function scr_item_get(_item_id) {
    var _id = scr_item_id_norm(_item_id);
    var _db = scr_item_database();
    if (_id != "" && variable_struct_exists(_db, _id)) return _db[$ _id];
    // Unknown id: a safe placeholder so menus never crash.
    var _unknown = scr_item_make(_id == "" ? "item_unknown" : _id, scr_item_display_name(_item_id), "misc", 0, {
        desc: "Unknown item.",
        sellable: false
    });
    _unknown.valid = false;
    _unknown.validation_errors = ["unknown item id"];
    return _unknown;
}

/// True only for a registered record. Unlike scr_item_get(), this never invents a placeholder.
function scr_item_exists(_item_id) {
    var _id = scr_item_id_norm(_item_id);
    if (_id == "") return false;
    var _db = scr_item_database();
    return variable_struct_exists(_db, _id);
}

function scr_item_description(_item_id) {
    return scr_item_get(_item_id).description;
}

function scr_item_stats(_item_id) {
    return scr_item_get(_item_id).stats;
}

function scr_item_effects(_item_id) {
    return scr_item_get(_item_id).effects;
}

/// Sum every matching effect value. `_key` / `_value` optionally filter, e.g.
/// scr_item_effect_total(id, "elemental_resistance", "element", "fire").
function scr_item_effect_total(_item_id, _type, _key = "", _value = "") {
    var _effects = scr_item_get(_item_id).effects;
    if (!is_array(_effects)) return 0;
    var _total = 0;
    for (var _i = 0; _i < array_length(_effects); _i++) {
        var _effect = _effects[_i];
        if (!is_struct(_effect)) continue;
        if (string(variable_struct_exists(_effect, "type") ? _effect.type : "") != string(_type)) continue;
        if (_key != "") {
            if (!variable_struct_exists(_effect, _key)) continue;
            if (string(_effect[$ _key]) != string(_value)) continue;
        }
        if (variable_struct_exists(_effect, "value") && is_real(_effect.value)) _total += _effect.value;
    }
    return _total;
}

function scr_item_has_effect(_item_id, _type, _key = "", _value = "") {
    var _effects = scr_item_get(_item_id).effects;
    if (!is_array(_effects)) return false;
    for (var _i = 0; _i < array_length(_effects); _i++) {
        var _effect = _effects[_i];
        if (!is_struct(_effect)) continue;
        if (string(variable_struct_exists(_effect, "type") ? _effect.type : "") != string(_type)) continue;
        if (_key != "") {
            if (!variable_struct_exists(_effect, _key)) continue;
            if (string(_effect[$ _key]) != string(_value)) continue;
        }
        return true;
    }
    return false;
}

/// Build-time report. `invalid` names every record that failed validation; `errors` carries the
/// per-record messages. Empty invalid/duplicates = the database is structurally sound.
function scr_item_db_audit() {
    var _db = scr_item_database();
    var _ids = variable_struct_get_names(_db);
    var _invalid = [];
    for (var _i = 0; _i < array_length(_ids); _i++) {
        if (!_db[$ _ids[_i]].valid) array_push(_invalid, _ids[_i]);
    }
    if (!variable_global_exists("item_db_errors") || !is_array(global.item_db_errors)) global.item_db_errors = [];
    if (!variable_global_exists("item_db_duplicates") || !is_array(global.item_db_duplicates)) global.item_db_duplicates = [];
    // Duplicate display names are a warning, not an invalid record: two different items may
    // legitimately share a name, but every one must be reviewed so one is not a leftover copy.
    var _dupe_names = [];
    var _by_name = {};
    for (var _n = 0; _n < array_length(_ids); _n++) {
        var _rec = _db[$ _ids[_n]];
        var _key = string_lower(string(_rec.name));
        if (variable_struct_exists(_by_name, _key)) {
            var _label = string(_rec.name) + " (" + _by_name[$ _key] + ", " + _ids[_n] + ")";
            if (!scr_item_list_has(_dupe_names, _label)) array_push(_dupe_names, _label);
        } else {
            _by_name[$ _key] = _ids[_n];
        }
    }
    global.item_db_duplicate_names = _dupe_names;
    return {
        count: array_length(_ids),
        valid_count: array_length(_ids) - array_length(_invalid),
        invalid_count: array_length(_invalid),
        invalid: _invalid,
        duplicates: global.item_db_duplicates,
        duplicate_names: _dupe_names,
        errors: global.item_db_errors
    };
}

function scr_item_is_key(_item_id) {
    var _it = scr_item_get(_item_id);
    return _it.key_item;
}

/// The six bag categories. Everything the UI groups by goes through this.
function scr_item_category(_item_id) {
    var _it = scr_item_get(_item_id);
    if (variable_struct_exists(_it, "category") && string(_it.category) != "") return string(_it.category);
    switch (_it.kind) {
        case "consumable": return "consumable";
        case "key": return "key";
        case "weapon": return "weapon";
        case "armor": case "helm": return "armor";
        case "accessory": return "accessory";
    }
    return "material";
}

/// Canonical slot for an item. Legacy rows stored weapon/armor/helm; map them here.
function scr_item_slot(_item_id) {
    var _it = scr_item_get(_item_id);
    var _s = variable_struct_exists(_it, "slot") ? string(_it.slot) : "";
    switch (_s) {
        case "weapon": return "main_hand";
        case "armor": return "body";
        case "helm": return "head";
    }
    return _s;
}

/// Seven equipment slots, in menu order.
function scr_equipment_slots() {
    return ["main_hand", "off_hand", "head", "body", "legs", "accessory_1", "accessory_2"];
}

/// Storage key in the actor's equipment struct. weapon/armor/helm/accessory are kept for
/// save compatibility; the other three slots are new.
function scr_equipment_storage_key(_slot) {
    switch (_slot) {
        case "main_hand": case "weapon": return "weapon";
        case "off_hand": return "off_hand";
        case "head": case "helm": return "helm";
        case "body": case "armor": return "armor";
        case "legs": return "legs";
        case "accessory": case "accessory_1": return "accessory";
        case "accessory_2": return "accessory_2";
    }
    return _slot;
}

function scr_equipment_slot_label(_slot) {
    switch (_slot) {
        case "main_hand": return "Main Hand";
        case "off_hand": return "Off Hand";
        case "head": return "Head";
        case "body": return "Body";
        case "legs": return "Legs";
        case "accessory_1": return "Accessory 1";
        case "accessory_2": return "Accessory 2";
    }
    return _slot;
}

function scr_item_is_equipment(_item_id) {
    var _c = scr_item_category(_item_id);
    return _c == "weapon" || _c == "armor" || _c == "accessory";
}

/// Merge one item's resistance struct into an accumulating struct.
function scr_res_merge(_dst, _src) {
    if (!is_struct(_src)) return;
    var _names = variable_struct_get_names(_src);
    for (var _i = 0; _i < array_length(_names); _i++) {
        var _k = _names[_i];
        _dst[$ _k] = (variable_struct_exists(_dst, _k) ? _dst[$ _k] : 0) + _src[$ _k];
    }
}

function scr_item_is_consumable(_item_id) {
    return scr_item_category(_item_id) == "consumable";
}

function scr_item_buy_price(_item_id) {
    return scr_item_get(_item_id).buy_price;
}

function scr_item_sell_price(_item_id) {
    var _it = scr_item_get(_item_id);
    if (!_it.sellable || _it.key_item || _it.unique) return 0;
    return max(0, _it.sell_price);
}

/// True when `_actor` can wear this item (joined or not — caller filters the list).
/// Class restrictions (`classes`) gate every slot; weapons also need a matching category.
function scr_item_can_equip(_actor, _item_id) {
    if (!is_struct(_actor)) return false;
    var _it = scr_item_get(_item_id);
    var _slot = scr_item_slot(_item_id);
    if (_slot == "") return false;
    var _classes = _it.classes;
    if (is_array(_classes) && array_length(_classes) > 0) {
        var _cn = variable_struct_exists(_actor, "class_name") ? string(_actor.class_name) : "";
        var _class_ok = false;
        for (var _ci = 0; _ci < array_length(_classes); _ci++) {
            if (string_lower(string(_classes[_ci])) == string_lower(_cn)) { _class_ok = true; break; }
        }
        if (!_class_ok) return false;
    }
    // Armour proficiency (light / medium / heavy). Blank means no restriction (legacy gear).
    var _ac = variable_struct_exists(_it, "armor_class") ? string(_it.armor_class) : "";
    if (_ac != "" && _slot != "main_hand" && _slot != "off_hand") {
        var _ap = variable_struct_exists(_actor, "armor_profs") ? _actor.armor_profs : [];
        var _ok = false;
        if (is_array(_ap)) {
            for (var _ai = 0; _ai < array_length(_ap); _ai++) {
                if (string_lower(string(_ap[_ai])) == string_lower(_ac)) { _ok = true; break; }
            }
        }
        if (!_ok) return false;
    }
    // Off-hand needs shield proficiency. Two-handed weapons and shields are still weapons,
    // so they go through the same weapon-category check.
    if (_slot == "off_hand") {
        var _sp = variable_struct_exists(_actor, "shield_prof") ? _actor.shield_prof : false;
        if (!_sp) return false;
    }
    if (_slot != "main_hand" && _slot != "off_hand") return true;
    var _need = _it.weapon_categories;
    var _have = variable_struct_exists(_actor, "weapon_categories") ? _actor.weapon_categories : [];
    if (!is_array(_need) || array_length(_need) == 0) return true;
    if (!is_array(_have)) return false;
    for (var _i = 0; _i < array_length(_need); _i++) {
        for (var _j = 0; _j < array_length(_have); _j++) {
            if (_have[_j] == _need[_i]) return true;
        }
    }
    return false;
}

function scr_actor_ensure_bases(_actor) {
    if (!is_struct(_actor)) return;
    if (!variable_struct_exists(_actor, "base_attack")) _actor.base_attack = _actor.attack;
    if (!variable_struct_exists(_actor, "base_defense")) _actor.base_defense = _actor.defense;
    if (!variable_struct_exists(_actor, "base_spd")) _actor.base_spd = variable_struct_exists(_actor, "spd") ? _actor.spd : 8;
    if (!variable_struct_exists(_actor, "base_mdef")) _actor.base_mdef = variable_struct_exists(_actor, "mdef") ? _actor.mdef : 0;
    if (!variable_struct_exists(_actor, "poisoned")) _actor.poisoned = false;
    if (!variable_struct_exists(_actor, "equipment") || !is_struct(_actor.equipment)) {
        _actor.equipment = { weapon: "", armor: "", helm: "", accessory: "" };
    }
    if (!variable_struct_exists(_actor.equipment, "helm")) _actor.equipment.helm = "";
    // Iron Helm used to live in the accessory slot; move it if needed.
    var _acc = is_string(_actor.equipment.accessory) ? _actor.equipment.accessory : "";
    if (scr_item_id_norm(_acc) == "item_iron_helm" && _actor.equipment.helm == "") {
        _actor.equipment.helm = _acc;
        _actor.equipment.accessory = "";
    }
    // Seven-slot equipment (2026-11-18). The four legacy keys are kept; these three are new.
    if (!variable_struct_exists(_actor.equipment, "off_hand")) _actor.equipment.off_hand = "";
    if (!variable_struct_exists(_actor.equipment, "legs")) _actor.equipment.legs = "";
    if (!variable_struct_exists(_actor.equipment, "accessory_2")) _actor.equipment.accessory_2 = "";
    // Base maxima, so equipment HP/MP bonuses never compound on every refresh.
    if (!variable_struct_exists(_actor, "base_max_hp")) _actor.base_max_hp = _actor.max_hp;
    if (!variable_struct_exists(_actor, "base_max_mp")) _actor.base_max_mp = variable_struct_exists(_actor, "max_mp") ? _actor.max_mp : 0;
    if (!variable_struct_exists(_actor, "base_magic")) _actor.base_magic = variable_struct_exists(_actor, "magic") ? _actor.magic : 0;
    // Magic was cosmetic in schema v4 saves (base_magic 0, magic skills used ATK). Seed an
    // unset base from ATK so old saves and enemies keep their previous magic damage, while
    // equipment MAG becomes a real bonus on top.
    if (_actor.base_magic <= 0 && _actor.base_attack > 0) _actor.base_magic = _actor.base_attack;
    if (!variable_struct_exists(_actor, "base_acc")) _actor.base_acc = variable_struct_exists(_actor, "accuracy") ? _actor.accuracy : 85;
    if (!variable_struct_exists(_actor, "base_eva")) _actor.base_eva = variable_struct_exists(_actor, "evasion") ? _actor.evasion : 5;
    if (!variable_struct_exists(_actor, "base_crit")) _actor.base_crit = variable_struct_exists(_actor, "crit") ? _actor.crit : 0;
    if (!variable_struct_exists(_actor, "magic")) _actor.magic = _actor.base_magic;
    if (!variable_struct_exists(_actor, "accuracy")) _actor.accuracy = _actor.base_acc;
    if (!variable_struct_exists(_actor, "evasion")) _actor.evasion = _actor.base_eva;
    if (!variable_struct_exists(_actor, "crit")) _actor.crit = _actor.base_crit;
    if (!variable_struct_exists(_actor, "elem_res") || !is_struct(_actor.elem_res)) _actor.elem_res = {};
    if (!variable_struct_exists(_actor, "status_res") || !is_struct(_actor.status_res)) _actor.status_res = {};
}

function scr_item_equip_bonuses(_item_id) {
    if (_item_id == "" || _item_id == undefined) {
        return { atk: 0, def: 0, mdef: 0, spd: 0, mag: 0, acc: 0, eva: 0, crit: 0, hp: 0, mp: 0 };
    }
    var _it = scr_item_get(_item_id);
    if (is_struct(_it.stats)) {
        return {
            atk: _it.stats.atk, def: _it.stats.def, mdef: _it.stats.mdef, spd: _it.stats.spd,
            mag: _it.stats.mag, acc: _it.stats.acc, eva: _it.stats.eva, crit: _it.stats.crit,
            hp: _it.stats.hp, mp: _it.stats.mp
        };
    }
    return {
        atk: _it.atk_bonus, def: _it.def_bonus, mdef: _it.mdef_bonus, spd: _it.spd_bonus,
        mag: _it.mag_bonus, acc: _it.acc_bonus, eva: _it.eva_bonus, crit: _it.crit_bonus,
        hp: _it.hp_bonus, mp: _it.mp_bonus
    };
}

/// Final stats for the seven slots, optionally previewing one replacement.
/// Final = base + equipment. `_replace_slot` is canonical; `_replace_item` an item id.
/// A two-handed main hand preview also drops the off-hand, as equipping it would.
function scr_actor_equip_totals(_actor, _replace_slot = "", _replace_item = "") {
    var _sum = { atk: 0, def: 0, mdef: 0, spd: 0, mag: 0, acc: 0, eva: 0, crit: 0, hp: 0, mp: 0 };
    if (!is_struct(_actor)) return _sum;
    scr_actor_ensure_bases(_actor);
    var _slots = scr_equipment_slots();
    var _replace_it = (_replace_item != "") ? scr_item_get(_replace_item) : undefined;
    var _skip_off = false;
    if (_replace_slot == "main_hand" && is_struct(_replace_it) && _replace_it.two_handed) _skip_off = true;
    // Previewing an off-hand while a two-handed weapon is worn would unequip that weapon first.
    var _skip_main = false;
    if (_replace_slot == "off_hand" && _replace_item != "") {
        var _mh_now = scr_actor_equipped_in_slot(_actor, "main_hand");
        if (_mh_now != "" && scr_item_get(_mh_now).two_handed) _skip_main = true;
    }
    for (var _i = 0; _i < array_length(_slots); _i++) {
        var _slot = _slots[_i];
        if (_skip_off && _slot == "off_hand") continue;
        if (_skip_main && _slot == "main_hand") continue;
        var _id = scr_actor_equipped_in_slot(_actor, _slot);
        if (_replace_slot != "" && _slot == _replace_slot) _id = _replace_item;
        if (!is_string(_id) || _id == "") continue;
        var _b = scr_item_equip_bonuses(_id);
        _sum.atk += _b.atk; _sum.def += _b.def; _sum.mdef += _b.mdef; _sum.spd += _b.spd;
        _sum.mag += _b.mag; _sum.acc += _b.acc; _sum.eva += _b.eva; _sum.crit += _b.crit;
        _sum.hp += _b.hp; _sum.mp += _b.mp;
    }
    return {
        atk: _actor.base_attack + _sum.atk,
        def: _actor.base_defense + _sum.def,
        mdef: _actor.base_mdef + _sum.mdef,
        spd: _actor.base_spd + _sum.spd,
        mag: _actor.base_magic + _sum.mag,
        acc: _actor.base_acc + _sum.acc,
        eva: _actor.base_eva + _sum.eva,
        crit: _actor.base_crit + _sum.crit,
        max_hp: _actor.base_max_hp + _sum.hp,
        max_mp: _actor.base_max_mp + _sum.mp
    };
}

/// Recompute every derived stat from base stats plus the seven equipped slots.
/// Bases are the un-equipped values, so a second call never stacks the same bonus twice.
function scr_actor_refresh_equipment(_actor) {
    if (!is_struct(_actor)) return;
    scr_actor_ensure_bases(_actor);
    var _t = scr_actor_equip_totals(_actor);
    _actor.attack = _t.atk;
    _actor.defense = _t.def;
    _actor.mdef = _t.mdef;
    _actor.spd = _t.spd;
    _actor.magic = _t.mag;
    _actor.accuracy = _t.acc;
    _actor.evasion = _t.eva;
    _actor.crit = _t.crit;
    _actor.max_hp = max(1, _t.max_hp);
    _actor.hp = clamp(_actor.hp, 0, _actor.max_hp);
    _actor.max_mp = max(0, _t.max_mp);
    _actor.mp = clamp(variable_struct_exists(_actor, "mp") ? _actor.mp : 0, 0, _actor.max_mp);
    // Resistances are equipment-only, recomputed from scratch (never stacked).
    var _er = {};
    var _sr = {};
    var _slots = scr_equipment_slots();
    for (var _i = 0; _i < array_length(_slots); _i++) {
        var _id = scr_actor_equipped_in_slot(_actor, _slots[_i]);
        if (_id == "") continue;
        var _it = scr_item_get(_id);
        scr_res_merge(_er, _it.elem_res);
        scr_res_merge(_sr, _it.status_res);
    }
    _actor.elem_res = _er;
    _actor.status_res = _sr;
}

function scr_party_refresh_equipment() {
    scr_game_state_init();
    var _list = global.game.roster;
    if (!is_array(_list)) return;
    for (var _i = 0; _i < array_length(_list); _i++) {
        scr_actor_refresh_equipment(_list[_i]);
    }
}

/// Reads the storage key for a canonical (or legacy) slot name.
function scr_actor_equipped_in_slot(_actor, _slot) {
    if (!is_struct(_actor) || !is_struct(_actor.equipment)) return "";
    var _key = scr_equipment_storage_key(_slot);
    if (!variable_struct_exists(_actor.equipment, _key)) return "";
    var _id = _actor.equipment[$ _key];
    return is_string(_id) ? _id : "";
}

/// Equip from inventory onto a joined member. `_slot` is optional; accessories pick the first
/// free accessory slot. Two-handed weapons clear the off-hand, and equipping an off-hand piece
/// over a two-handed weapon returns the weapon to the bag. Returns a short status string.
function scr_item_equip_to(_actor, _item_id, _slot = "") {
    if (!is_struct(_actor) || !scr_item_can_equip(_actor, _item_id)) return "Can't equip.";
    var _it = scr_item_get(_item_id);
    var _want = (_slot != "") ? _slot : scr_item_slot(_item_id);
    if (_want == "" ) return "Can't equip.";
    if (_want == "accessory") {
        if (scr_actor_equipped_in_slot(_actor, "accessory_1") == "") _want = "accessory_1";
        else if (scr_actor_equipped_in_slot(_actor, "accessory_2") == "") _want = "accessory_2";
        else _want = "accessory_1";
    }
    // The requested slot must accept this item (accessories go in either accessory slot).
    var _item_slot = scr_item_slot(_item_id);
    if (_item_slot == "accessory") {
        if (_want != "accessory_1" && _want != "accessory_2") return "Can't equip.";
    } else if (_want != _item_slot) {
        return "Can't equip.";
    }
    if (!scr_inventory_has(_item_id)) return "You don't have that.";

    // Everything displaced by this equip goes back to the bag.
    var _returns = [];
    if (_want == "main_hand" && _it.two_handed) {
        var _off = scr_actor_equipped_in_slot(_actor, "off_hand");
        if (_off != "") array_push(_returns, _off);
    }
    if (_want == "off_hand") {
        var _mh = scr_actor_equipped_in_slot(_actor, "main_hand");
        if (_mh != "" && scr_item_get(_mh).two_handed) array_push(_returns, _mh);
    }
    var _prev = scr_actor_equipped_in_slot(_actor, _want);
    if (_prev != "" && _prev != _it.item_id) array_push(_returns, _prev);

    if (!scr_inventory_remove(_item_id, 1, true)) return "You don't have that.";
    // Pick up the displaced pieces before writing, so nothing is lost if the bag is full elsewhere.
    for (var _r = 0; _r < array_length(_returns); _r++) {
        var _rid = _returns[_r];
        var _rit = scr_item_get(_rid);
        scr_inventory_add(_rit.item_id, _rit.name, 1, _rit.key_item);
    }
    var _key = scr_equipment_storage_key(_want);
    _actor.equipment[$ _key] = _it.item_id;
    if (_want == "main_hand" && _it.two_handed) _actor.equipment.off_hand = "";
    if (_want == "off_hand") {
        var _mh2 = scr_actor_equipped_in_slot(_actor, "main_hand");
        if (_mh2 != "" && scr_item_get(_mh2).two_handed) _actor.equipment.weapon = "";
    }
    scr_actor_refresh_equipment(_actor);
    return "Equipped " + _it.name + " on " + _actor.name + ".";
}

/// Comparison line: currently equipped vs the selected item, every stat and resistance.
/// Positive deltas are marked +, negative -, so a downgrade reads as one.
function scr_item_preview_line(_actor, _item_id) {
    if (!is_struct(_actor)) return "";
    var _it = scr_item_get(_item_id);
    var _slot = scr_item_slot(_item_id);
    if (_slot == "") return _actor.name;
    if (!scr_item_can_equip(_actor, _item_id)) return _actor.name + "  can't equip";
    var _preview_slot = _slot;
    if (_slot == "accessory") {
        if (scr_actor_equipped_in_slot(_actor, "accessory_1") == "") _preview_slot = "accessory_1";
        else if (scr_actor_equipped_in_slot(_actor, "accessory_2") == "") _preview_slot = "accessory_2";
        else _preview_slot = "accessory_1";
    }
    var _now = scr_actor_equip_totals(_actor);
    var _new = scr_actor_equip_totals(_actor, _preview_slot, scr_item_id_norm(_item_id));
    var _labels = [["atk", "ATK"], ["def", "DEF"], ["mag", "MAG"], ["mdef", "MDEF"],
                   ["spd", "SPD"], ["acc", "ACC"], ["eva", "EVA"], ["crit", "CRIT"],
                   ["max_hp", "HP"], ["max_mp", "MP"]];
    // Kept short: the selected item's name is already on the candidate row, and the
    // description box only holds about two lines.
    var _line = "";
    var _cur_id = scr_actor_equipped_in_slot(_actor, _preview_slot);
    _line = (_cur_id != "") ? ("vs " + scr_item_get(_cur_id).name + ":") : "vs empty:";
    for (var _k = 0; _k < array_length(_labels); _k++) {
        var _key = _labels[_k][0];
        var _d = _new[$ _key] - _now[$ _key];
        if (_d == 0) continue;
        if (_key == "crit") {
            _line += (_d > 0 ? "  CRIT +" : "  CRIT -") + string(round(abs(_d) * 100)) + "%";
        } else {
            _line += "  " + _labels[_k][1] + (_d > 0 ? " +" : " -") + string(abs(_d));
        }
    }
    // Resistance deltas against whatever currently sits in that slot.
    var _old_it = scr_item_get(scr_actor_equipped_in_slot(_actor, _preview_slot));
    var _old_er = is_struct(_old_it.elem_res) ? _old_it.elem_res : {};
    var _old_sr = is_struct(_old_it.status_res) ? _old_it.status_res : {};
    var _er = is_struct(_it.elem_res) ? _it.elem_res : {};
    var _en = variable_struct_get_names(_er);
    for (var _e = 0; _e < array_length(_en); _e++) {
        var _ek = _en[_e];
        var _ev = _er[$ _ek] - (variable_struct_exists(_old_er, _ek) ? _old_er[$ _ek] : 0);
        if (_ev == 0) continue;
        _line += "  " + string_upper(_ek) + (_ev > 0 ? " +" : " ") + string(_ev) + "%";
    }
    var _sr = is_struct(_it.status_res) ? _it.status_res : {};
    var _sn = variable_struct_get_names(_sr);
    for (var _s = 0; _s < array_length(_sn); _s++) {
        var _sk = _sn[_s];
        var _sv = _sr[$ _sk] - (variable_struct_exists(_old_sr, _sk) ? _old_sr[$ _sk] : 0);
        if (_sv == 0) continue;
        _line += "  " + string_upper(_sk) + " RES" + (_sv > 0 ? " +" : " ") + string(_sv) + "%";
    }
    if (_line == "") _line = "  no change";
    if (_it.two_handed) _line = "  [2H]" + _line;
    if (_it.rarity != "common") _line += "  [" + string_upper(_it.rarity) + "]";
    return _actor.name + _line;
}

/// Use a consumable on one actor. Returns a status string; does not remove the item on failure.
function scr_item_use_on(_actor, _item_id) {
    if (!is_struct(_actor)) return "No target.";
    if (scr_item_category(_item_id) != "consumable") return "Can't use that here.";
    // The standardized effect list is the source of truth for use behaviour. The flat fields
    // (heal / mp_restore / revive_pct / cures_poison) are materialized from it at registration.
    var _heal = scr_item_effect_total(_item_id, "healing");
    var _mp = scr_item_effect_total(_item_id, "mp_restore");
    var _rev_pct = scr_item_effect_total(_item_id, "revival") / 100;
    var _cures_poison = scr_item_has_effect(_item_id, "status_recovery", "status", "poison");
    // Revive items (Emberwake Feather 25%, Ashenheart Plume 50%) only work on a fallen member.
    if (_rev_pct > 0) {
        if (_actor.hp > 0) return _actor.name + " is still standing.";
        var _rev = max(1, floor(_actor.max_hp * _rev_pct));
        _actor.hp = min(_actor.max_hp, _rev);
        if (variable_struct_exists(_actor, "mp")) _actor.mp = 0;
        if (variable_struct_exists(_actor, "statuses")) _actor.statuses = [];
        scr_inventory_remove(_item_id, 1, true);
        return _actor.name + " revives with " + string(_rev) + " HP.";
    }
    if (_heal > 0) {
        if (_actor.hp <= 0) return _actor.name + " can't be revived with this.";
        if (_actor.hp >= _actor.max_hp) return _actor.name + "'s HP is already full.";
        var _gain = min(_heal, _actor.max_hp - _actor.hp);
        _actor.hp += _gain;
        scr_inventory_remove(_item_id, 1, true);
        return _actor.name + " recovered " + string(_gain) + " HP.";
    }
    if (_mp > 0) {
        if (_actor.hp <= 0) return _actor.name + " can't use this while down.";
        var _mmp = variable_struct_exists(_actor, "max_mp") ? _actor.max_mp : 0;
        if (_mmp <= 0) return _actor.name + " has no MP.";
        if (_actor.mp >= _mmp) return _actor.name + "'s MP is already full.";
        var _mgain = min(_mp, _mmp - _actor.mp);
        _actor.mp += _mgain;
        scr_inventory_remove(_item_id, 1, true);
        return _actor.name + " recovered " + string(_mgain) + " MP.";
    }
    if (_cures_poison) {
        // Cures the overworld `poisoned` flag and the battle "poison" status.
        var _poisoned = variable_struct_exists(_actor, "poisoned") && _actor.poisoned;
        var _bpoison = scr_battle_status_has(_actor, "poison");
        if (!_poisoned && !_bpoison) return _actor.name + " is not poisoned.";
        if (_poisoned) _actor.poisoned = false;
        if (_bpoison) scr_battle_remove_status(_actor, "poison");
        scr_inventory_remove(_item_id, 1, true);
        return _actor.name + " is no longer poisoned.";
    }
    return "No effect.";
}

/// Reverse lookup by display name (chest loot is written as "Iron Sword", not an id).
function scr_item_id_for_name(_name) {
    var _want = string_lower(string_trim(string(_name)));
    if (_want == "") return "";
    var _db = scr_item_database();
    var _ids = variable_struct_get_names(_db);
    for (var _i = 0; _i < array_length(_ids); _i++) {
        if (string_lower(_db[$ _ids[_i]].name) == _want) return _ids[_i];
    }
    return "";
}

// ---- Forge crafting ------------------------------------------------------------------------
// Tiered materials -> the act's crafted piece. Legendaries are never craftable: they come from
// bosses only (see `unique` / `acquisition`). Recipes unlock with the story act.
function scr_craft_recipes() {
    return [
        { result: "item_millhaven_sabre", act: 2, gold: 100, materials: [{ item: "item_ash_shard", qty: 2 }, { item: "item_iron_scale", qty: 2 }] },
        { result: "item_warden_sigil", act: 2, gold: 120, materials: [{ item: "item_iron_scale", qty: 3 }] },
        { result: "item_valemere_helm", act: 3, gold: 200, materials: [{ item: "item_valemere_steel", qty: 4 }] },
        { result: "item_ledger_dirk", act: 3, gold: 350, materials: [{ item: "item_valemere_steel", qty: 4 }, { item: "item_iron_scale", qty: 4 }] },
        { result: "item_barrow_helm", act: 4, gold: 300, materials: [{ item: "item_barrow_iron", qty: 5 }] },
        { result: "item_oath_breaker", act: 4, gold: 450, materials: [{ item: "item_barrow_iron", qty: 6 }, { item: "item_valemere_steel", qty: 4 }] },
        { result: "item_saltreach_charm", act: 5, gold: 400, materials: [{ item: "item_tideglass", qty: 6 }] },
        { result: "item_tidesteel_blade", act: 5, gold: 600, materials: [{ item: "item_tideglass", qty: 8 }, { item: "item_barrow_iron", qty: 5 }] },
        { result: "item_architect_ring", act: 6, gold: 500, materials: [{ item: "item_architect_alloy", qty: 7 }] },
        { result: "item_ironspine_maul", act: 6, gold: 700, materials: [{ item: "item_architect_alloy", qty: 9 }, { item: "item_tideglass", qty: 6 }] },
        { result: "item_ash_crown", act: 7, gold: 600, materials: [{ item: "item_ember_core", qty: 8 }] },
        { result: "item_ashlands_edge", act: 7, gold: 800, materials: [{ item: "item_ember_core", qty: 10 }, { item: "item_architect_alloy", qty: 6 }] },
        { result: "item_veil_ring", act: 8, gold: 700, materials: [{ item: "item_veil_shard", qty: 9 }] },
        { result: "item_true_name_blade", act: 8, gold: 900, materials: [{ item: "item_veil_shard", qty: 11 }, { item: "item_ember_core", qty: 6 }] },
        // 2026-11-18 progression: one craftable per act from the new material list (never a legendary).
        { result: "item_hidebound_vest", act: 1, gold: 40, materials: [{ item: "item_wolf_pelt", qty: 2 }, { item: "item_copper_ore", qty: 2 }] },
        { result: "item_ironweave", act: 2, gold: 160, materials: [{ item: "item_iron_ore", qty: 4 }, { item: "item_steel_ingot", qty: 1 }] },
        { result: "item_wardens_plate", act: 3, gold: 420, materials: [{ item: "item_steel_ingot", qty: 3 }, { item: "item_silver_ore", qty: 2 }] },
        { result: "item_aetherbound_circlet", act: 4, gold: 820, materials: [{ item: "item_pure_crystal", qty: 3 }, { item: "item_ancient_rune", qty: 1 }] },
        { result: "item_crownward_armor", act: 5, gold: 1450, materials: [{ item: "item_gold_ore", qty: 4 }, { item: "item_black_iron", qty: 3 }] },
        { result: "item_veilforged_plate", act: 6, gold: 1850, materials: [{ item: "item_black_iron", qty: 4 }, { item: "item_shadow_essence", qty: 2 }] }
    ];
}

function scr_craft_recipe_get(_result_id) {
    var _all = scr_craft_recipes();
    for (var _i = 0; _i < array_length(_all); _i++) {
        if (_all[_i].result == scr_item_id_norm(_result_id)) return _all[_i];
    }
    return undefined;
}

/// Recipes unlocked at the current story act.
function scr_craft_available() {
    var _out = [];
    var _all = scr_craft_recipes();
    var _act = scr_story_act();
    for (var _i = 0; _i < array_length(_all); _i++) {
        if (_all[_i].act <= _act) array_push(_out, _all[_i]);
    }
    return _out;
}

/// Empty string when the recipe can be made now, otherwise a short reason.
function scr_craft_block_reason(_recipe) {
    scr_game_state_init();
    if (!is_struct(_recipe)) return "Unknown recipe.";
    if (_recipe.act > scr_story_act()) return "You don't have the recipe yet.";
    var _mats = _recipe.materials;
    for (var _i = 0; _i < array_length(_mats); _i++) {
        var _have = scr_inventory_count(_mats[_i].item);
        if (_have < _mats[_i].qty) {
            return "Needs " + string(_mats[_i].qty) + " " + scr_item_get(_mats[_i].item).name + " (have " + string(_have) + ").";
        }
    }
    if (global.game.gold < _recipe.gold) return "Needs " + string(_recipe.gold) + " gold.";
    return "";
}

function scr_craft_make(_result_id) {
    scr_game_state_init();
    var _rec = scr_craft_recipe_get(_result_id);
    if (!is_struct(_rec)) return "Unknown recipe.";
    var _block = scr_craft_block_reason(_rec);
    if (_block != "") { scr_audio_sfx("menu_error", 0, 0.8); return _block; }
    var _mats = _rec.materials;
    for (var _i = 0; _i < array_length(_mats); _i++) {
        if (!scr_inventory_remove(_mats[_i].item, _mats[_i].qty, true)) return "Missing materials.";
    }
    global.game.gold -= _rec.gold;
    var _it = scr_item_get(_rec.result);
    scr_inventory_add(_it.item_id, _it.name, 1, _it.key_item);
    scr_audio_sfx("item_get", 0.02);
    return "Forged " + _it.name + ".";
}

/// One-line label for the forge menu, with its requirements.
function scr_craft_label(_recipe) {
    var _it = scr_item_get(_recipe.result);
    var _s = _it.name + "  (" + string(_recipe.gold) + "g";
    var _mats = _recipe.materials;
    for (var _i = 0; _i < array_length(_mats); _i++) {
        _s += ", " + string(_mats[_i].qty) + " " + scr_item_get(_mats[_i].item).name;
    }
    return _s + ")";
}

function scr_party_members_for_item(_item_id) {
    scr_game_state_init();
    var _out = [];
    var _lists = [global.game.party, global.game.reserve];
    var _equip = scr_item_is_equipment(_item_id);
    for (var _l = 0; _l < 2; _l++) {
        var _list = _lists[_l];
        if (!is_array(_list)) continue;
        for (var _i = 0; _i < array_length(_list); _i++) {
            var _a = _list[_i];
            if (!is_struct(_a)) continue;
            if (_equip && !scr_item_can_equip(_a, _item_id)) continue;
            array_push(_out, _a);
        }
    }
    return _out;
}
