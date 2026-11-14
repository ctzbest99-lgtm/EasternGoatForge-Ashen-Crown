/// scr_item_data — Chapter 1 item table (names, prices, slots, bonuses, use effects).
/// Prices, heal amounts, and stat bonuses are PLACEHOLDER: no item DB prices exist in
/// CHAPTER1_SCRIPT.md or STORY_BIBLE.md yet. See docs/DECISIONS_AND_OPEN_QUESTIONS.md.

function scr_item_id_norm(_item_id) {
    var _s = string(_item_id);
    if (_s == "") return "";
    if (string_copy(_s, 1, 5) == "item_") return _s;
    return "item_" + _s;
}

function scr_item_make(_item_id, _name, _kind, _price, _extra = undefined) {
    var _it = {
        item_id: scr_item_id_norm(_item_id),
        name: _name,
        kind: _kind,          // "consumable" | "weapon" | "armor" | "helm" | "accessory" | "key" | "misc"
        slot: "",             // "weapon" | "armor" | "helm" | "accessory" or ""
        price: max(0, _price),
        sellable: true,
        key_item: false,
        heal: 0,
        cures_poison: false,
        mp_restore: 0,
        atk_bonus: 0,
        def_bonus: 0,
        weapon_categories: [],
        desc: ""
    };
    if (_kind == "key") {
        _it.key_item = true;
        _it.sellable = false;
    }
    if (_kind == "weapon") _it.slot = "weapon";
    if (_kind == "armor") _it.slot = "armor";
    if (_kind == "helm") _it.slot = "helm";
    if (_kind == "accessory") _it.slot = "accessory";
    if (is_struct(_extra)) {
        var _names = variable_struct_get_names(_extra);
        for (var _i = 0; _i < array_length(_names); _i++) {
            _it[$ _names[_i]] = _extra[$ _names[_i]];
        }
    }
    if (_it.key_item) _it.sellable = false;
    if (_it.price <= 0) _it.sellable = false;
    return _it;
}

function scr_item_database() {
    if (variable_global_exists("item_db") && is_struct(global.item_db)) return global.item_db;
    var _db = {};
    var _add = function(_db_ref, _it) { _db_ref[$ _it.item_id] = _it; };

    // Consumables (Marda). Heal / prices PLACEHOLDER.
    _add(_db, scr_item_make("item_minor_potion", "Minor Potion", "consumable", 15, {
        heal: ITEM_MINOR_POTION_HEAL,
        desc: "Restores " + string(ITEM_MINOR_POTION_HEAL) + " HP. (PLACEHOLDER amount.)"
    }));
    _add(_db, scr_item_make("item_antidote", "Antidote", "consumable", 20, {
        cures_poison: true,
        desc: "Cures poison. Overworld status only until battle poison exists. (PLACEHOLDER.)"
    }));

    // Chapter 2 (balance pass). Ether: MP recovery, sold by Len in Wrenfield and found in a
    // Millhaven Road chest. Chain Mail: Len's mid-tier item. All numbers / prices PLACEHOLDER.
    // No icons yet (menus fall back to the generic row).
    _add(_db, scr_item_make("item_ether", "Ether", "consumable", 60, {
        mp_restore: ITEM_ETHER_MP,
        desc: "Restores " + string(ITEM_ETHER_MP) + " MP. (PLACEHOLDER amount.)"
    }));
    _add(_db, scr_item_make("item_chain_mail", "Chain Mail", "armor", 220, {
        def_bonus: 4,
        desc: "Riveted rings over padding. DEF +4. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_travel_brigandine", "Travel Brigandine", "armor", 0, {
        def_bonus: 2,
        sellable: false,
        desc: "Taren's olive brigandine. DEF +2. (PLACEHOLDER.)"
    }));

    // Basic equipment (Pell's forge). Bonuses and prices PLACEHOLDER.
    _add(_db, scr_item_make("item_iron_sword", "Iron Sword", "weapon", 80, {
        atk_bonus: 3,
        weapon_categories: ["longsword"],
        desc: "A plain iron blade. ATK +3. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_leather_armor", "Leather Armor", "armor", 60, {
        def_bonus: 2,
        desc: "Scuffed travelling leathers. DEF +2. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_iron_helm", "Iron Helm", "helm", 40, {
        def_bonus: 1,
        desc: "A simple iron cap. DEF +1. (PLACEHOLDER.)"
    }));

    // Starting / unique equipment (not sold). Bonuses PLACEHOLDER.
    _add(_db, scr_item_make("item_kaels_longsword", "Kael's Longsword", "weapon", 0, {
        atk_bonus: 3,
        weapon_categories: ["longsword"],
        sellable: false,
        desc: "Kael's own blade. ATK +3. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_bastard_sword", "Bastard Sword", "weapon", 0, {
        atk_bonus: 3,
        weapon_categories: ["heavy_sword"],
        sellable: false,
        desc: "Taren's starting weapon. ATK +3. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_twin_daggers", "Twin Daggers", "weapon", 0, {
        atk_bonus: 2,
        weapon_categories: ["dagger"],
        sellable: false,
        desc: "Lyra's starting weapon. ATK +2. (PLACEHOLDER.)"
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
        desc: "A short hunting blade. ATK +2. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_hunters_charm", "Hunter's Charm", "accessory", 0, {
        def_bonus: 1,
        sellable: false,
        desc: "A worn hunter's charm. DEF +1. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_ashen_longbow", "Ashen Longbow", "weapon", 0, {
        atk_bonus: 3,
        weapon_categories: ["bow"],
        desc: "No one in the Chapter 1 roster can equip a bow yet. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_ashen_arrow", "Ashen Arrow", "misc", 0, {
        desc: "Ammunition. No use action yet. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_blackguards_longsword", "Blackguard's Longsword", "weapon", 0, {
        atk_bonus: 5,
        weapon_categories: ["longsword"],
        sellable: false,
        desc: "Taken from the Blackguard. ATK +5. (PLACEHOLDER.)"
    }));
    _add(_db, scr_item_make("item_blackguard_longsword", "Blackguard's Longsword", "weapon", 0, {
        atk_bonus: 5,
        weapon_categories: ["longsword"],
        sellable: false,
        desc: "Taken from the Blackguard. ATK +5. (PLACEHOLDER.)"
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
    _add(_db, scr_item_make("item_blackened_feather", "Blackened Feather", "misc", 0, {
        desc: "A charred feather. No use yet. (PLACEHOLDER.)"
    }));

    global.item_db = _db;
    return global.item_db;
}

function scr_item_get(_item_id) {
    var _id = scr_item_id_norm(_item_id);
    var _db = scr_item_database();
    if (_id != "" && variable_struct_exists(_db, _id)) return _db[$ _id];
    // Unknown id: a safe placeholder so menus never crash.
    return scr_item_make(_id == "" ? "item_unknown" : _id, scr_item_display_name(_item_id), "misc", 0, {
        desc: "Unknown item.",
        sellable: false
    });
}

function scr_item_is_key(_item_id) {
    var _it = scr_item_get(_item_id);
    return _it.key_item;
}

function scr_item_is_equipment(_item_id) {
    var _it = scr_item_get(_item_id);
    return _it.slot == "weapon" || _it.slot == "armor" || _it.slot == "helm" || _it.slot == "accessory";
}

function scr_item_is_consumable(_item_id) {
    return scr_item_get(_item_id).kind == "consumable";
}

function scr_item_buy_price(_item_id) {
    return scr_item_get(_item_id).price;
}

function scr_item_sell_price(_item_id) {
    var _it = scr_item_get(_item_id);
    if (!_it.sellable || _it.key_item || _it.price <= 0) return 0;
    return max(1, floor(_it.price * SHOP_SELL_RATE));
}

/// True when `_actor` can wear this item (joined or not — caller filters the list).
function scr_item_can_equip(_actor, _item_id) {
    if (!is_struct(_actor)) return false;
    var _it = scr_item_get(_item_id);
    if (_it.slot == "armor" || _it.slot == "helm" || _it.slot == "accessory") return true;
    if (_it.slot != "weapon") return false;
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
}

function scr_item_equip_bonuses(_item_id) {
    if (_item_id == "" || _item_id == undefined) return { atk: 0, def: 0 };
    var _it = scr_item_get(_item_id);
    return { atk: _it.atk_bonus, def: _it.def_bonus };
}

/// Recompute attack / defense from base stats plus equipped bonuses.
function scr_actor_refresh_equipment(_actor) {
    if (!is_struct(_actor)) return;
    scr_actor_ensure_bases(_actor);
    var _atk = 0;
    var _def = 0;
    var _slots = ["weapon", "armor", "helm", "accessory"];
    for (var _i = 0; _i < 4; _i++) {
        var _id = _actor.equipment[$ _slots[_i]];
        if (is_string(_id) && _id != "") {
            var _b = scr_item_equip_bonuses(_id);
            _atk += _b.atk;
            _def += _b.def;
        }
    }
    _actor.attack = _actor.base_attack + _atk;
    _actor.defense = _actor.base_defense + _def;
}

function scr_party_refresh_equipment() {
    scr_game_state_init();
    var _list = global.game.roster;
    if (!is_array(_list)) return;
    for (var _i = 0; _i < array_length(_list); _i++) {
        scr_actor_refresh_equipment(_list[_i]);
    }
}

function scr_actor_equipped_in_slot(_actor, _slot) {
    if (!is_struct(_actor) || !is_struct(_actor.equipment)) return "";
    var _id = _actor.equipment[$ _slot];
    return is_string(_id) ? _id : "";
}

/// Equip from inventory onto a joined member. Returns a short status string.
function scr_item_equip_to(_actor, _item_id) {
    if (!is_struct(_actor) || !scr_item_can_equip(_actor, _item_id)) return "Can't equip.";
    var _it = scr_item_get(_item_id);
    var _slot = _it.slot;
    if (_slot == "") return "Can't equip.";
    if (!scr_inventory_has(_item_id)) return "You don't have that.";
    var _prev = scr_actor_equipped_in_slot(_actor, _slot);
    if (!scr_inventory_remove(_item_id, 1, true)) return "You don't have that.";
    _actor.equipment[$ _slot] = _it.item_id;
    if (_prev != "") {
        var _prev_it = scr_item_get(_prev);
        scr_inventory_add(_prev_it.item_id, _prev_it.name, 1, _prev_it.key_item);
    }
    scr_actor_refresh_equipment(_actor);
    return "Equipped " + _it.name + " on " + _actor.name + ".";
}

function scr_item_preview_line(_actor, _item_id) {
    if (!is_struct(_actor)) return "";
    var _it = scr_item_get(_item_id);
    if (_it.slot == "") return _actor.name;
    if (!scr_item_can_equip(_actor, _item_id)) return _actor.name + "  can't equip";
    var _b = scr_item_equip_bonuses(_item_id);
    var _cur = scr_item_equip_bonuses(scr_actor_equipped_in_slot(_actor, _it.slot));
    var _atk0 = variable_struct_exists(_actor, "base_attack") ? _actor.base_attack : _actor.attack;
    var _def0 = variable_struct_exists(_actor, "base_defense") ? _actor.base_defense : _actor.defense;
    // Other slots stay worn; only this slot is replaced in the preview.
    var _slots = ["weapon", "armor", "helm", "accessory"];
    var _atk_other = 0;
    var _def_other = 0;
    for (var _i = 0; _i < 4; _i++) {
        if (_slots[_i] == _it.slot) continue;
        var _ob = scr_item_equip_bonuses(scr_actor_equipped_in_slot(_actor, _slots[_i]));
        _atk_other += _ob.atk;
        _def_other += _ob.def;
    }
    var _atk_now = _actor.attack;
    var _def_now = _actor.defense;
    var _atk_new = _atk0 + _atk_other + _b.atk;
    var _def_new = _def0 + _def_other + _b.def;
    var _line = _actor.name;
    if (_atk_new != _atk_now) _line += "  ATK " + string(_atk_now) + " > " + string(_atk_new);
    if (_def_new != _def_now) _line += "  DEF " + string(_def_now) + " > " + string(_def_new);
    if (_atk_new == _atk_now && _def_new == _def_now) _line += "  no change";
    return _line;
}

/// Use a consumable on one actor. Returns a status string; does not remove the item on failure.
function scr_item_use_on(_actor, _item_id) {
    if (!is_struct(_actor)) return "No target.";
    var _it = scr_item_get(_item_id);
    if (_it.kind != "consumable") return "Can't use that here.";
    if (_it.heal > 0) {
        if (_actor.hp <= 0) return _actor.name + " can't be revived with this.";
        if (_actor.hp >= _actor.max_hp) return _actor.name + "'s HP is already full.";
        var _gain = min(_it.heal, _actor.max_hp - _actor.hp);
        _actor.hp += _gain;
        scr_inventory_remove(_item_id, 1, true);
        return _actor.name + " recovered " + string(_gain) + " HP.";
    }
    if (_it.mp_restore > 0) {
        if (_actor.hp <= 0) return _actor.name + " can't use this while down.";
        var _mmp = variable_struct_exists(_actor, "max_mp") ? _actor.max_mp : 0;
        if (_mmp <= 0) return _actor.name + " has no MP.";
        if (_actor.mp >= _mmp) return _actor.name + "'s MP is already full.";
        var _mgain = min(_it.mp_restore, _mmp - _actor.mp);
        _actor.mp += _mgain;
        scr_inventory_remove(_item_id, 1, true);
        return _actor.name + " recovered " + string(_mgain) + " MP.";
    }
    if (_it.cures_poison) {
        var _poisoned = variable_struct_exists(_actor, "poisoned") && _actor.poisoned;
        if (!_poisoned) return _actor.name + " is not poisoned. (Battle poison is not implemented yet.)";
        _actor.poisoned = false;
        scr_inventory_remove(_item_id, 1, true);
        return _actor.name + " is no longer poisoned.";
    }
    return "No effect.";
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
