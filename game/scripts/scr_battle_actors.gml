/// scr_battle_actors — actor structs shared by party members and enemies.
/// The party is an array so it can grow to the planned four members (roadmap step 4).

function scr_actor_create(_actor_id, _name, _max_hp, _attack, _defense) {
    return {
        actor_id: _actor_id,
        name: _name,
        max_hp: _max_hp,
        hp: _max_hp,
        attack: _attack,
        defense: _defense,
        is_guarding: false
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
function scr_party_create_default() {
    return [ scr_actor_create("kael", "Kael", 30, 6, 2) ];
}

function scr_actor_is_alive(_actor) {
    return is_struct(_actor) && _actor.hp > 0;
}

function scr_party_any_alive(_party) {
    return scr_party_next_living_index(_party, 0) != -1;
}

/// First living party index >= _from, or -1.
function scr_party_next_living_index(_party, _from) {
    for (var _i = max(0, _from); _i < array_length(_party); _i++) {
        if (scr_actor_is_alive(_party[_i])) return _i;
    }
    return -1;
}

/// Random living party index, or -1 if everyone is down.
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

/// Prototype defeat rule: restore everyone to full HP (see open questions).
function scr_party_restore_all(_party) {
    for (var _i = 0; _i < array_length(_party); _i++) {
        _party[_i].hp = _party[_i].max_hp;
        _party[_i].is_guarding = false;
    }
}
