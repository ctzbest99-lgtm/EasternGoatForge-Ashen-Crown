/// scr_party — five-person roster, four active battle slots, one reserve slot.
/// Member structs are shared by reference across roster / party / reserve.
/// Placeholder stats and join times are pending owner approval. Kael is the only
/// default joined member.

function scr_roster_member_create(_actor_id, _name, _full_name, _class_name, _role, _max_hp, _attack, _defense, _weapon_categories, _starting_weapon = "", _armor_profs = [], _shield_prof = false) {
    var _actor = scr_actor_create(_actor_id, _name, _max_hp, _attack, _defense);
    _actor.full_name = _full_name;
    _actor.class_name = _class_name;
    _actor.role = _role;
    _actor.weapon_categories = is_array(_weapon_categories) ? _weapon_categories : [];
    _actor.armor_profs = is_array(_armor_profs) ? _armor_profs : [];
    _actor.shield_prof = _shield_prof;
    _actor.equipment.weapon = _starting_weapon;
    _actor.joined = false;
    _actor.age = -1; // -1 = not specified
    return _actor;
}

/// The five permanent members. None are joined except as set by scr_party_state_create().
function scr_roster_create() {
    var _roster = [
        // Proficiencies (2026-11-18): Kael swords + selected greatswords, medium/heavy armour;
        // Taren heavy weapons + shields + heavy armour; the rest follow their established class.
        scr_roster_member_create("kael", "Kael", "Kael Varyn", "Vanguard", "Frontline", KAEL_BASE_HP, KAEL_BASE_ATTACK, KAEL_BASE_DEFENSE, ["longsword", "greatsword"], "", ["medium", "heavy"], false),
        scr_roster_member_create("lyra", "Lyra", "Lyra Veyne", "Rogue", "Crits / speed", LYRA_BASE_HP, LYRA_BASE_ATTACK, LYRA_BASE_DEFENSE, ["dagger", "shortsword"], "item_twin_daggers", ["light"], false),
        scr_roster_member_create("caelan", "Caelan", "Caelan Rook", "Arcanist", "Elemental magic", CAELAN_BASE_HP, CAELAN_BASE_ATTACK, CAELAN_BASE_DEFENSE, ["spellbook", "staff"], "item_spellbook", ["light"], false),
        scr_roster_member_create("sera", "Sera", "Seraphine Thorn", "Warden", "Healing / holy", SERA_BASE_HP, SERA_BASE_ATTACK, SERA_BASE_DEFENSE, ["holy_sword", "mace"], "item_holy_sword", ["medium"], false),
        // Taren Holt: warrior / frontline, heavy swords; starting weapon stub is a bastard sword.
        // Skills are placeholders; class is Rebel Captain of the Broken Yoke (STORY_BIBLE.md §5.5).
        scr_roster_member_create("taren", "Taren", "Taren Holt", "Rebel Captain", "Frontline warrior", TAREN_BASE_HP, TAREN_BASE_ATTACK, TAREN_BASE_DEFENSE, ["heavy_sword", "greatsword", "shield"], "bastard_sword", ["heavy"], true)
    ];
    for (var _r = 0; _r < array_length(_roster); _r++) scr_actor_apply_battle_defaults(_roster[_r]);
    var _kael = scr_roster_find(_roster, "kael");
    if (is_struct(_kael)) _kael.age = 24;
    var _taren = scr_roster_find(_roster, "taren");
    if (is_struct(_taren)) {
        _taren.age = 27;
        _taren.equipment.armor = "item_travel_brigandine"; // starting armour: Travel Brigandine, DEF +2 (provisional value)
    }
    return _roster;
}

/// Level-1 SPD / MDEF / MP and starting skills per roster member. All numbers PLACEHOLDER.
/// Taren's starting skills are canon (CHAPTER2_SCRIPT.md WF_CALDER_SYS_02, STORY_BIBLE.md §5.5):
/// Rallying Cry and Cleave (active) and Unbowed (passive). Nobody else has a skill yet.
function scr_actor_battle_defaults(_actor_id) {
    switch (_actor_id) {
        // Kael: Last Stand (canon passive, CHAPTER1_SCRIPT.md §2.1): below 25% HP,
        // ATK +15% / DEF +10% (implemented in scr_battle_stat).
        case "kael":   return { spd: KAEL_BASE_SPD,   mdef: KAEL_BASE_MDEF,   mp: KAEL_BASE_MP,   skills: [], passives: ["last_stand"] };
        // Lyra's starting skills are canon (CHAPTER3_SCRIPT.md Decision 4): Twin Cut and
        // Open Vein (active) and Cutthroat (passive). She joins at the Debtman fight (§6).
        case "lyra":   return { spd: LYRA_BASE_SPD,   mdef: LYRA_BASE_MDEF,   mp: LYRA_BASE_MP,   skills: ["twin_cut", "open_vein"], passives: ["cutthroat"] };
        case "caelan": return { spd: CAELAN_BASE_SPD, mdef: CAELAN_BASE_MDEF, mp: CAELAN_BASE_MP, skills: ["ember", "frost_lance", "arc_bolt"], passives: [] };
        // Sera's starting kit is Mend / Aegis / Smite (approved 2026-11-16). Numbers PLACEHOLDER.
        case "sera":   return { spd: SERA_BASE_SPD,   mdef: SERA_BASE_MDEF,   mp: SERA_BASE_MP,   skills: ["mend", "aegis", "smite"], passives: [] };
        case "taren":  return { spd: TAREN_BASE_SPD,  mdef: TAREN_BASE_MDEF,  mp: TAREN_BASE_MP,  skills: ["rallying_cry", "cleave"], passives: ["unbowed"] };
    }
    return { spd: 8, mdef: 0, mp: 0, skills: [], passives: [] };
}

/// Apply level-1 battle defaults, then placeholder growth for (level - 1) levels.
/// Used when the roster is created and when an old (v1) save is migrated.
function scr_actor_apply_battle_defaults(_actor) {
    if (!is_struct(_actor)) return;
    var _d = scr_actor_battle_defaults(_actor.actor_id);
    var _lv = variable_struct_exists(_actor, "level") ? max(1, _actor.level) : 1;
    var _gt = scr_level_growth_total(_lv);
    _actor.base_spd = _d.spd + _gt.spd;
    _actor.spd = _actor.base_spd;
    _actor.base_mdef = _d.mdef + _gt.mdef;
    _actor.mdef = _actor.base_mdef;
    _actor.max_mp = _d.mp + _gt.mp;
    _actor.mp = _actor.max_mp;
    _actor.base_max_mp = _actor.max_mp;
    if (!variable_struct_exists(_actor, "base_max_hp")) _actor.base_max_hp = _actor.max_hp;
    _actor.skills = _d.skills;
    _actor.passives = _d.passives;
    _actor.buffs = [];
    _actor.statuses = [];
}

function scr_roster_find(_roster, _actor_id) {
    if (!is_array(_roster)) return undefined;
    for (var _i = 0; _i < array_length(_roster); _i++) {
        if (is_struct(_roster[_i]) && _roster[_i].actor_id == _actor_id) return _roster[_i];
    }
    return undefined;
}

/// Build roster + active + reserve. Default: Kael joined and active; the others exist
/// on the roster but have not joined (not in a slot). DEBUG_ADD_FULL_ROSTER fills all five.
function scr_party_state_create() {
    var _roster = scr_roster_create();
    var _kael = scr_roster_find(_roster, "kael");
    _kael.joined = true;
    var _state = {
        roster: _roster,
        party: [_kael],
        reserve: []
    };
    if (DEBUG_ADD_FULL_ROSTER) {
        scr_party_debug_fill_roster(_state);
    } else if (DEBUG_ADD_PLACEHOLDER_ALLY) {
        scr_party_add_member(_state.party, scr_actor_create("placeholder_ally", "Placeholder Ally", 24, 5, 2));
    }
    return _state;
}

/// All five join: Kael, Lyra, Caelan, Sera active (in that order); Taren in reserve.
function scr_party_debug_fill_roster(_state) {
    var _ids_active = ["kael", "lyra", "caelan", "sera"];
    var _active = [];
    for (var _i = 0; _i < array_length(_ids_active); _i++) {
        var _m = scr_roster_find(_state.roster, _ids_active[_i]);
        _m.joined = true;
        array_push(_active, _m);
    }
    var _taren = scr_roster_find(_state.roster, "taren");
    _taren.joined = true;
    _state.party = _active;
    _state.reserve = [_taren];
}

function scr_party_list_active() {
    scr_game_state_init();
    return global.game.party;
}

function scr_party_list_reserve() {
    scr_game_state_init();
    return global.game.reserve;
}

/// Swap the active member at `_active_index` with the single reserve member.
/// Returns false if the reserve is empty or the index is out of range.
function scr_party_swap_active_reserve(_active_index) {
    scr_game_state_init();
    var _active = global.game.party;
    var _reserve = global.game.reserve;
    if (!is_array(_active) || !is_array(_reserve)) return false;
    if (array_length(_reserve) != 1) return false;
    if (_active_index < 0 || _active_index >= array_length(_active)) return false;
    var _tmp = _active[_active_index];
    _active[_active_index] = _reserve[0];
    _reserve[0] = _tmp;
    return true;
}

/// Mark a roster member joined and place them in an open active slot, or the reserve
/// if the active party is full. Returns false if they don't exist, already joined,
/// or there is no free slot (4 active + 1 reserve already filled).
function scr_party_join(_actor_id) {
    scr_game_state_init();
    var _member = scr_roster_find(global.game.roster, _actor_id);
    if (!is_struct(_member) || _member.joined) return false;
    if (array_length(global.game.party) < PARTY_ACTIVE_MAX) {
        _member.joined = true;
        array_push(global.game.party, _member);
        return true;
    }
    if (array_length(global.game.reserve) < PARTY_RESERVE_MAX) {
        _member.joined = true;
        array_push(global.game.reserve, _member);
        return true;
    }
    return false;
}

/// Full heal + clear Guard for active and reserve members (used after a defeat).
function scr_party_restore_active_and_reserve() {
    scr_party_restore_all(scr_party_list_active());
    scr_party_restore_all(scr_party_list_reserve());
}

/// Compatibility wrapper. The full versioned payload lives in scr_save_collect().
function scr_save_state_collect() {
    return scr_save_collect(1);
}

function scr_party_ids_of(_list) {
    var _ids = [];
    if (!is_array(_list)) return _ids;
    for (var _i = 0; _i < array_length(_list); _i++) {
        if (is_struct(_list[_i])) array_push(_ids, _list[_i].actor_id);
    }
    return _ids;
}

/// Clear per-battle participation on every known member (roster, active, and reserve).
function scr_party_clear_participation() {
    scr_game_state_init();
    var _lists = [global.game.roster, global.game.party, global.game.reserve];
    for (var _l = 0; _l < array_length(_lists); _l++) {
        var _list = _lists[_l];
        if (!is_array(_list)) continue;
        for (var _i = 0; _i < array_length(_list); _i++) {
            if (is_struct(_list[_i])) {
                _list[_i].participated = false;
                _list[_i].pending_xp = 0;
            }
        }
    }
}

function scr_party_mark_participated(_actor) {
    if (is_struct(_actor)) _actor.participated = true;
}

function scr_party_has_reserve() {
    scr_game_state_init();
    return is_array(global.game.reserve) && array_length(global.game.reserve) > 0;
}

/// Battle command menu: Attack, Skill (only if `_actor` knows an active skill), Guard,
/// plus Swap when a reserve member is waiting.
function scr_party_battle_commands(_actor = undefined, _allow_escape = false) {
    var _opts = ["Attack"];
    if (is_struct(_actor) && variable_struct_exists(_actor, "skills") && is_array(_actor.skills) && array_length(_actor.skills) > 0) {
        array_push(_opts, "Skill");
    }
    if (array_length(scr_party_battle_items()) > 0) array_push(_opts, "Item");
    array_push(_opts, "Guard");
    if (scr_party_has_reserve()) array_push(_opts, "Swap");
    // Escape is offered only when obj_battle_controller says the fight is escapable
    // (no bosses, no scripted / story battle, not the tutorial fight).
    if (_allow_escape) array_push(_opts, "Escape");
    return _opts;
}

/// Consumables the battle Item command can use (shared bag; counted once per stack).
/// Anything with a battle effect (heal / MP / cures) is offered; the item itself decides
/// on use whether it has an effect (scr_item_use_on) and is only consumed when it does.
function scr_party_battle_items() {
    scr_game_state_init();
    var _out = [];
    var _inv = global.game.inventory;
    for (var _i = 0; _i < array_length(_inv); _i++) {
        var _slot = _inv[_i];
        if (!is_struct(_slot) || !variable_struct_exists(_slot, "item_id") || _slot.qty <= 0) continue;
        if (scr_item_category(_slot.item_id) != "consumable") continue;
        // Standard effect list, not the legacy flat fields: a new consumable effect type only
        // needs a row in scr_item_effect_schema() and a use branch.
        if (!scr_item_has_effect(_slot.item_id, "healing")
                && !scr_item_has_effect(_slot.item_id, "mp_restore")
                && !scr_item_has_effect(_slot.item_id, "status_recovery", "status", "poison")
                && !scr_item_has_effect(_slot.item_id, "revival")) continue;
        array_push(_out, _slot.item_id);
    }
    return _out;
}

/// Unique members (active first, then reserve, then the rest of the roster) who took
/// at least one turn this battle.
function scr_party_participants() {
    scr_game_state_init();
    var _out = [];
    var _lists = [global.game.party, global.game.reserve, global.game.roster];
    for (var _l = 0; _l < array_length(_lists); _l++) {
        var _list = _lists[_l];
        if (!is_array(_list)) continue;
        for (var _i = 0; _i < array_length(_list); _i++) {
            var _actor = _list[_i];
            if (!is_struct(_actor) || !_actor.participated) continue;
            var _exists = false;
            for (var _j = 0; _j < array_length(_out); _j++) {
                if (_out[_j].actor_id == _actor.actor_id) { _exists = true; break; }
            }
            if (!_exists) array_push(_out, _actor);
        }
    }
    return _out;
}

/// When an enemy dies, credit its XP to each member who has already taken a turn
/// and is not KO'd at this moment (owner decision 2026-11-14). Banked in
/// pending_xp and applied only if the party later wins.
function scr_party_credit_enemy_xp(_amount) {
    if (_amount <= 0) return;
    var _list = scr_party_participants();
    for (var _i = 0; _i < array_length(_list); _i++) {
        var _actor = _list[_i];
        if (!scr_actor_is_alive(_actor)) continue;
        _actor.pending_xp += _amount;
    }
}

/// Apply banked pending_xp (victory only). Returns level-up structs, same shape
/// as scr_party_grant_xp_to. Pending is cleared. A defeat never calls this, so
/// no XP is granted if the party loses.
function scr_party_apply_pending_xp() {
    scr_game_state_init();
    var _ups = [];
    var _lists = [global.game.party, global.game.reserve, global.game.roster];
    var _seen = [];
    for (var _l = 0; _l < array_length(_lists); _l++) {
        var _list = _lists[_l];
        if (!is_array(_list)) continue;
        for (var _i = 0; _i < array_length(_list); _i++) {
            var _actor = _list[_i];
            if (!is_struct(_actor)) continue;
            var _exists = false;
            for (var _j = 0; _j < array_length(_seen); _j++) {
                if (_seen[_j] == _actor.actor_id) { _exists = true; break; }
            }
            if (_exists) continue;
            array_push(_seen, _actor.actor_id);
            if (_actor.pending_xp <= 0) continue;
            var _more = scr_party_grant_xp_to([_actor], _actor.pending_xp);
            _actor.pending_xp = 0;
            for (var _u = 0; _u < array_length(_more); _u++) array_push(_ups, _more[_u]);
        }
    }
    return _ups;
}
