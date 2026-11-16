/// scr_party — party actors, XP, levels and gold, as pure data so it can be tested and later saved.
/// XP is per member; gold is one shared purse. Battle rewards arrive through scr_party_apply_rewards.
/// Requires GameMaker 2.3+.

/// @desc Stats for a level. Level 1 reproduces the battle placeholder exactly (30 HP, 6 attack, 2 defense),
/// so adding progression does not silently rebalance the existing fight.
function scr_party_actor_stats(_level) {
    var _l = max(1, floor(_level));
    return {
        max_hp: 24 + 6 * _l,
        attack: 5 + _l,
        defense: 1 + _l
    };
}

/// @desc XP needed to reach the next level from _level.
function scr_party_xp_to_next(_level) {
    return 6 + 4 * max(1, floor(_level));
}

/// @desc One party member at _level with full HP.
function scr_party_make_actor(_name, _level = 1) {
    var _l = max(1, floor(_level));
    var _stats = scr_party_actor_stats(_l);
    return {
        name: _name,
        level: _l,
        xp: 0,
        xp_to_next: scr_party_xp_to_next(_l),
        hp: _stats.max_hp,
        max_hp: _stats.max_hp,
        attack: _stats.attack,
        defense: _stats.defense,
        guarding: false
    };
}

/// @desc A new party with one member and starting supplies. The planned four slots are filled with
/// scr_party_add_member.
function scr_party_create(_lead_name = "Kael") {
    var _party = {
        members: [scr_party_make_actor(_lead_name, 1)],
        gold: 0,
        items: scr_inventory_create()
    };
    /// Two potions: enough to survive the first Bandit without grinding.
    scr_inventory_add(_party.items, "potion", 2);
    /// One Ember Draught, so the revive path can be tried without a shop that does not exist yet.
    scr_inventory_add(_party.items, "ember_draught", 1);
    return _party;
}

/// @desc Names used to fill a party for testing. Placeholders, not canon: the real companions, their
/// classes and how they join are still open questions in docs/DECISIONS_AND_OPEN_QUESTIONS.md.
function scr_party_placeholder_names() {
    return ["Kael", "Lira", "Bran", "Sable"];
}

/// @desc Fill the party up to _size (max 4) with placeholder members. Debug and tests only; the game's
/// real party is built from story events that do not exist yet.
function scr_party_fill_placeholders(_party, _size = 4) {
    var _names = scr_party_placeholder_names();
    var _target = clamp(floor(_size), 1, 4);
    var _added = 0;
    while (array_length(_party.members) < _target) {
        var _slot = array_length(_party.members);
        var _name = _names[min(_slot, array_length(_names) - 1)];
        array_push(_party.members, scr_party_make_actor(_name, 1));
        _added += 1;
    }
    return _added;
}

/// @desc The active member: the first one still standing, or the first slot if everyone is down.
function scr_party_lead(_party) {
    var _count = array_length(_party.members);
    for (var _i = 0; _i < _count; _i++) {
        if (_party.members[_i].hp > 0) return _party.members[_i];
    }
    return _party.members[0];
}

/// @desc Add a member while the four planned slots allow it. Returns false when the party is full.
function scr_party_add_member(_party, _name, _level = 1) {
    if (array_length(_party.members) >= 4) return false;
    array_push(_party.members, scr_party_make_actor(_name, _level));
    return true;
}

/// @desc Swap two party slots, which is how party order is changed.
function scr_party_swap(_party, _a, _b) {
    var _count = array_length(_party.members);
    if (_a < 0 || _b < 0 || _a >= _count || _b >= _count || _a == _b) return false;
    var _temp = _party.members[_a];
    _party.members[_a] = _party.members[_b];
    _party.members[_b] = _temp;
    return true;
}

/// @desc Give one member XP, levelling as often as the total allows. Returns the number of levels gained.
function scr_party_award_xp(_actor, _amount) {
    var _levels = 0;
    if (_amount <= 0) return 0;
    _actor.xp += floor(_amount);
    while (_actor.level < 99 && _actor.xp >= _actor.xp_to_next) {
        _actor.xp -= _actor.xp_to_next;
        _actor.level += 1;
        var _stats = scr_party_actor_stats(_actor.level);
        var _hp_gain = _stats.max_hp - _actor.max_hp;
        _actor.max_hp = _stats.max_hp;
        _actor.attack = _stats.attack;
        _actor.defense = _stats.defense;
        /// Levelling heals the HP it adds, so a level-up never leaves a hole in the bar.
        _actor.hp = min(_actor.max_hp, _actor.hp + max(0, _hp_gain));
        _actor.xp_to_next = scr_party_xp_to_next(_actor.level);
        _levels += 1;
    }
    return _levels;
}

/// @desc Award XP to every member still standing. Returns "Name reached level N!" lines for the UI.
function scr_party_award_xp_to_all(_party, _amount) {
    var _lines = [];
    var _count = array_length(_party.members);
    for (var _i = 0; _i < _count; _i++) {
        var _actor = _party.members[_i];
        if (_actor.hp <= 0) continue;   /// the fallen earn nothing
        if (scr_party_award_xp(_actor, _amount) > 0) {
            array_push(_lines, _actor.name + " reached level " + string(_actor.level) + "!");
        }
    }
    return _lines;
}

/// @desc Add gold to the shared purse.
function scr_party_add_gold(_party, _amount) {
    if (_amount > 0) _party.gold += floor(_amount);
    return _party.gold;
}

/// @desc Spend from the shared purse. Returns false and changes nothing when the purse is short.
function scr_party_spend_gold(_party, _amount) {
    var _cost = floor(_amount);
    if (_cost <= 0) return false;
    if (_party.gold < _cost) return false;
    _party.gold -= _cost;
    return true;
}

/// @desc Apply a battle's reward struct ({ xp, gold }) once. Returns any level-up lines.
function scr_party_apply_rewards(_party, _rewards) {
    if (is_undefined(_rewards) || _rewards == undefined) return [];
    var _lines = scr_party_award_xp_to_all(_party, _rewards.xp);
    scr_party_add_gold(_party, _rewards.gold);
    return _lines;
}

/// @desc The party the game uses, created on first use so no bootstrap object is required yet.
function scr_party_ensure_global() {
    if (!variable_global_exists("party") || global.party == undefined) global.party = scr_party_create();
    return global.party;
}
