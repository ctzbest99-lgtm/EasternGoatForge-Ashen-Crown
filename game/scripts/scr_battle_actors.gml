/// scr_battle_actors — actor structs shared by party members and enemies.
/// The party is an array of 1–PARTY_MAX_SIZE members. Array order is battle turn order.

function scr_actor_create(_actor_id, _name, _max_hp, _attack, _defense) {
    return {
        actor_id: _actor_id,
        name: _name,
        max_hp: _max_hp,
        hp: _max_hp,
        attack: _attack,
        defense: _defense,
        is_guarding: false,
        level: 1,
        xp: 0,
        // Equipment slots are placeholders until menus (roadmap step 5) exist.
        equipment: { weapon: "", armor: "", accessory: "" }
    };
}

/// Build a battle actor from a scr_get_enemy_data() struct. Returns undefined for bad data.
function scr_actor_from_enemy_data(_data) {
    if (!is_struct(_data)) return undefined;
    var _actor = scr_actor_create(_data[$ "id"], _data.name, _data.max_hp, _data.attack, _data.defense);
    _actor.xp_reward = _data.xp_reward;
    _actor.gold_reward = _data.gold_reward;
    return _actor;
}

/// Placeholder party: Kael only, with placeholder stats (not balanced, not canon).
/// Flip DEBUG_ADD_PLACEHOLDER_ALLY to test a two-member party (not a canon character).
function scr_party_create_default() {
    var _party = [ scr_actor_create("kael", "Kael", KAEL_BASE_HP, KAEL_BASE_ATTACK, KAEL_BASE_DEFENSE) ];
    if (DEBUG_ADD_PLACEHOLDER_ALLY) {
        scr_party_add_member(_party, scr_actor_create("placeholder_ally", "Placeholder Ally", 24, 5, 2));
    }
    return _party;
}

/// Append a member if the party is not full. Returns true on success.
function scr_party_add_member(_party, _actor) {
    if (!is_array(_party) || !is_struct(_actor)) return false;
    if (array_length(_party) >= PARTY_MAX_SIZE) return false;
    array_push(_party, _actor);
    return true;
}

/// Swap two slots (party order = command and turn order). No-op on bad indices.
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

/// Restore everyone to full HP and clear Guard. Used after a defeat (owner decision 2026-11-14).
function scr_party_restore_all(_party) {
    for (var _i = 0; _i < array_length(_party); _i++) {
        _party[_i].hp = _party[_i].max_hp;
        _party[_i].is_guarding = false;
    }
}
