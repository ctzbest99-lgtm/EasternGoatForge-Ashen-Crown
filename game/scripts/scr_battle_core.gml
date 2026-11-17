/// scr_battle_core — the battle state machine, with no input and no drawing.
/// obj_battle_controller translates keys into scr_battle_advance / scr_battle_move_cursor and draws
/// `battle`; keeping the loop pure makes it testable outside GameMaker and the UI replaceable.
///
/// Turn order: player command -> player result -> enemy result -> next command. Victory and defeat are
/// terminal: nothing advances out of them, the controller ends the battle.
/// Actor data is already party-shaped: `party` is an array holding the active actor, so adding three
/// more party members is data work, not a rewrite. Requires GameMaker 2.3+.

enum BATTLE_PHASE {
    INTRO,
    COMMAND,
    ITEM,
    SWITCH,
    PLAYER_RESULT,
    ENEMY_RESULT,
    VICTORY,
    DEFEAT,
    ESCAPED
}

enum BATTLE_COMMAND {
    ATTACK,
    GUARD,
    ITEM,
    SWITCH,
    FLEE
}

#macro BATTLE_COMMAND_COUNT 5

/// @desc Display name of a command id.
function scr_battle_command_name(_command) {
    switch (_command) {
        case BATTLE_COMMAND.ATTACK: return "Attack";
        case BATTLE_COMMAND.GUARD: return "Guard";
        case BATTLE_COMMAND.ITEM: return "Item";
        case BATTLE_COMMAND.SWITCH: return "Switch";
        case BATTLE_COMMAND.FLEE: return "Flee";
    }
    return "?";
}

/// @desc Build one battle actor. HP is the only mutable stat here; equipment comes later.
function scr_battle_actor(_name, _max_hp, _attack, _defense) {
    return {
        name: _name,
        hp: _max_hp,
        max_hp: _max_hp,
        attack: _attack,
        defense: _defense,
        guarding: false
    };
}

/// @desc True while the actor can act.
function scr_battle_is_alive(_actor) {
    return _actor.hp > 0;
}

/// @desc Index of the first member still standing at or after _from, or -1 when none is.
function scr_battle_next_standing(_party, _from) {
    var _count = array_length(_party);
    for (var _i = max(0, floor(_from)); _i < _count; _i++) {
        if (scr_battle_is_alive(_party[_i])) return _i;
    }
    return -1;
}

/// @desc How many members can still act.
function scr_battle_standing_count(_party) {
    var _count = array_length(_party);
    var _standing = 0;
    for (var _i = 0; _i < _count; _i++) {
        if (scr_battle_is_alive(_party[_i])) _standing += 1;
    }
    return _standing;
}

/// @desc Put member _index on the field. A downed index falls forward to the next standing member, so
/// the active slot can never be somebody who cannot act.
function scr_battle_set_active(_battle, _index) {
    var _count = array_length(_battle.party);
    if (_count <= 0) return false;
    var _i = clamp(floor(_index), 0, _count - 1);
    if (!scr_battle_is_alive(_battle.party[_i])) {
        var _alt = scr_battle_next_standing(_battle.party, _i);
        if (_alt < 0) _alt = scr_battle_next_standing(_battle.party, 0);
        if (_alt >= 0) _i = _alt;
    }
    _battle.active_actor = _i;
    /// `player` stays the member currently acting, so every command that fought one actor keeps working.
    _battle.player = _battle.party[_i];
    return true;
}

/// @desc The member the enemy strikes: the first one standing, in party order. Party order is the planned
/// menu's ordering, so it earns its keep here, and a fixed rule keeps a fight reproducible.
function scr_battle_enemy_target(_battle) {
    var _index = scr_battle_next_standing(_battle.party, 0);
    if (_index < 0) return undefined;
    return _battle.party[_index];
}

/// @desc Start a battle against _enemy_id. Returns undefined for an unknown id so callers can report it,
/// and also when nobody in the party is standing. Pass one actor or an array of them (usually
/// `party.members`) as _player: every standing member takes the field, by reference, so damage and
/// levelling carry back to the party. _items is the inventory the Item command draws from.
function scr_battle_create(_enemy_id, _player = undefined, _items = undefined) {
    var _data = scr_get_enemy_data(_enemy_id);
    if (is_undefined(_data) || _data == undefined) return undefined;
    if (is_undefined(_items) || _items == undefined) _items = scr_inventory_create();

    var _party = [];
    if (is_undefined(_player) || _player == undefined) {
        array_push(_party, scr_battle_actor("Kael", 30, 6, 2));
    } else if (is_array(_player)) {
        var _members = array_length(_player);
        for (var _i = 0; _i < _members; _i++) {
            if (scr_battle_is_alive(_player[_i])) array_push(_party, _player[_i]);
        }
    } else {
        array_push(_party, _player);
    }
    /// A party with nobody standing has no fight to fight; the caller decides what that means.
    if (array_length(_party) == 0) return undefined;

    var _enemy = scr_battle_actor(_data.name, _data.max_hp, _data.attack, _data.defense);
    _enemy.id = _data.id;
    _enemy.xp_reward = _data.xp_reward;
    _enemy.gold_reward = _data.gold_reward;
    return {
        state: BATTLE_PHASE.INTRO,
        message: _enemy.name + " blocks the way!",
        cursor: BATTLE_COMMAND.ATTACK,
        member_cursor: 0,
        turn: 1,
        player: _party[0],
        party: _party,
        active_actor: 0,
        acting_slot: 0,
        inventory: _items,
        item_cursor: 0,
        enemy: _enemy,
        last_damage: 0,
        rewards: { xp: 0, gold: 0 },
        rewarded: false,
        finished: false
    };
}

/// @desc True while the battle still accepts commands (victory, defeat and escape are terminal).
function scr_battle_is_over(_battle) {
    return (_battle.state == BATTLE_PHASE.VICTORY
        || _battle.state == BATTLE_PHASE.DEFEAT
        || _battle.state == BATTLE_PHASE.ESCAPED);
}

/// @desc Move the command cursor. Does nothing outside COMMAND, so stray presses cannot change state.
function scr_battle_move_cursor(_battle, _delta) {
    if (_battle.state != BATTLE_PHASE.COMMAND || _delta == 0) return false;
    _battle.cursor = (_battle.cursor + _delta + BATTLE_COMMAND_COUNT) mod BATTLE_COMMAND_COUNT;
    return true;
}

/// @desc Apply one command. Returns false when the battle is not accepting that command right now,
/// which is what makes a repeated confirm harmless.
function scr_battle_player_command(_battle, _command) {
    if (_battle.state != BATTLE_PHASE.COMMAND) return false;
    if (!scr_battle_is_alive(_battle.player) || !scr_battle_is_alive(_battle.enemy)) return false;
    switch (_command) {
        case BATTLE_COMMAND.ATTACK:
            var _damage = scr_calculate_damage(scr_actor_attack(_battle.player), _battle.enemy.defense);
            _battle.enemy.hp = scr_apply_damage(_battle.enemy.hp, _battle.enemy.max_hp, _damage);
            _battle.last_damage = _damage;
            _battle.state = BATTLE_PHASE.PLAYER_RESULT;
            _battle.message = _battle.player.name + " strikes for " + string(_damage) + ".";
            /// A killing blow ends the battle here: the enemy never gets a turn.
            if (!scr_battle_is_alive(_battle.enemy)) {
                _battle.state = BATTLE_PHASE.VICTORY;
                _battle.finished = true;
                _battle.message = _battle.enemy.name + " falls. Victory!";
            }
            return true;
        case BATTLE_COMMAND.GUARD:
            _battle.player.guarding = true;
            _battle.state = BATTLE_PHASE.PLAYER_RESULT;
            _battle.message = _battle.player.name + " raises a guard.";
            return true;
    }
    return false;
}

/// @desc Enter the item submenu from the command menu. Returns false and says so when nothing is usable.
function scr_battle_open_items(_battle) {
    if (_battle.state != BATTLE_PHASE.COMMAND) return false;
    if (array_length(scr_inventory_usable(_battle.inventory)) == 0) {
        _battle.message = "No items.";
        return false;
    }
    _battle.state = BATTLE_PHASE.ITEM;
    _battle.item_cursor = 0;
    _battle.message = "Use which item?";
    return true;
}

/// @desc Move inside the item submenu, wrapping. Does nothing outside that submenu.
function scr_battle_move_item_cursor(_battle, _delta) {
    if (_battle.state != BATTLE_PHASE.ITEM || _delta == 0) return false;
    var _count = array_length(scr_inventory_usable(_battle.inventory));
    if (_count <= 0) return false;
    _battle.item_cursor = (_battle.item_cursor + _delta + _count) mod _count;
    return true;
}

/// @desc Back out of the item submenu without spending the turn.
function scr_battle_close_items(_battle) {
    if (_battle.state != BATTLE_PHASE.ITEM) return false;
    _battle.state = BATTLE_PHASE.COMMAND;
    _battle.message = "Choose a command.";
    return true;
}

/// @desc Escape odds, from the party's total level against the enemy's strength: even odds at equal
/// strength, 8% per level of difference, clamped to 10-90% so no fight is a guaranteed exit and none is
/// hopeless. Only standing members count, so a fleeing party is judged by who can actually run.
function scr_battle_flee_chance(_battle) {
    var _levels = 0;
    var _count = array_length(_battle.party);
    for (var _i = 0; _i < _count; _i++) {
        var _actor = _battle.party[_i];
        if (!scr_battle_is_alive(_actor)) continue;
        _levels += variable_struct_exists(_actor, "level") ? _actor.level : 1;
    }
    var _edge = _levels - scr_battle_enemy_power(_battle.enemy.id);
    return clamp(0.5 + 0.08 * _edge, 0.1, 0.9);
}

/// @desc Try to leave the fight. _roll is injected so a test can force either outcome; the controller
/// passes nothing and the real roll happens here. A boss that declares no_flee refuses without spending
/// anything, and a failed escape ends the round in the enemy's favour — otherwise every member could
/// retry and four attempts would make any fight escapable.
function scr_battle_flee_attempt(_battle, _roll = undefined) {
    if (_battle.state != BATTLE_PHASE.COMMAND) return false;
    if (!scr_enemy_can_flee(_battle.enemy.id)) {
        _battle.message = "There is no way out of this one.";
        return false;
    }
    var _chance = scr_battle_flee_chance(_battle);
    var _value = is_undefined(_roll) ? random(1) : clamp(_roll, 0, 0.999999);
    if (_value < _chance) {
        _battle.state = BATTLE_PHASE.ESCAPED;
        _battle.finished = true;
        _battle.message = "The party escapes.";
        return true;
    }
    scr_battle_enemy_turn(_battle);
    _battle.message = "The party fails to escape. " + _battle.message;
    return true;
}

/// @desc Index of the first member who is down, or -1 when nobody is.
function scr_battle_first_downed(_battle) {
    var _count = array_length(_battle.party);
    for (var _i = 0; _i < _count; _i++) {
        if (!scr_battle_is_alive(_battle.party[_i])) return _i;
    }
    return -1;
}

/// @desc Use the selected item. A healing item lands on the acting member; a revive lands on the first
/// member who is down, since the acting member is by definition standing. A refusal (full HP, nobody
/// down, empty stack) keeps the submenu open and spends nothing, so a wasted turn is impossible.
function scr_battle_use_selected_item(_battle) {
    if (_battle.state != BATTLE_PHASE.ITEM) return false;
    var _usable = scr_inventory_usable(_battle.inventory);
    if (array_length(_usable) == 0) return scr_battle_close_items(_battle);
    var _index = min(_battle.item_cursor, array_length(_usable) - 1);
    var _item_id = _usable[_index].id;
    var _data = scr_item_data(_item_id);

    var _target = _battle.player;
    if (scr_item_is_revive(_item_id)) {
        var _down = scr_battle_first_downed(_battle);
        if (_down < 0) {
            _battle.message = "No one is down.";
            return false;
        }
        _target = _battle.party[_down];
    }

    var _result = scr_inventory_use(_battle.inventory, _target, _item_id);
    if (!_result.used) {
        _battle.message = _data.name + ": " + _result.message + ".";
        return false;
    }
    _battle.state = BATTLE_PHASE.PLAYER_RESULT;
    if (scr_item_is_revive(_item_id)) {
        _battle.message = _battle.player.name + " revives " + _target.name + " with " + _data.name + ".";
    } else {
        _battle.message = _battle.player.name + " uses " + _data.name + " and recovers " + string(_result.healed) + " HP.";
    }
    return true;
}

/// @desc Open the member list. Refuses when only one member is standing: a switch with nothing to switch
/// to would burn a turn.
function scr_battle_open_switch(_battle) {
    if (_battle.state != BATTLE_PHASE.COMMAND) return false;
    if (scr_battle_standing_count(_battle.party) < 2) {
        _battle.message = "No one else can fight.";
        return false;
    }
    _battle.state = BATTLE_PHASE.SWITCH;
    _battle.member_cursor = _battle.active_actor;
    _battle.message = "Who takes the field?";
    return true;
}

/// @desc Move the member cursor over standing members only, wrapping. Downed members are skipped rather
/// than selectable-and-refused, so the list never offers a dead end.
function scr_battle_move_member_cursor(_battle, _delta) {
    if (_battle.state != BATTLE_PHASE.SWITCH || _delta == 0) return false;
    var _count = array_length(_battle.party);
    var _step_dir = (_delta > 0) ? 1 : -1;
    var _index = _battle.member_cursor;
    for (var _step = 0; _step < _count; _step++) {
        _index = (_index + _step_dir + _count) mod _count;
        if (scr_battle_is_alive(_battle.party[_index])) {
            _battle.member_cursor = _index;
            return true;
        }
    }
    return false;
}

/// @desc Back out of the member list without spending the turn.
function scr_battle_close_switch(_battle) {
    if (_battle.state != BATTLE_PHASE.SWITCH) return false;
    _battle.state = BATTLE_PHASE.COMMAND;
    _battle.message = "Choose a command.";
    return true;
}

/// @desc Put the selected member on the field. This spends the acting slot's turn: the round continues
/// from that slot, not from the new member, so switching cannot buy a second action.
function scr_battle_confirm_switch(_battle) {
    if (_battle.state != BATTLE_PHASE.SWITCH) return false;
    var _index = clamp(_battle.member_cursor, 0, array_length(_battle.party) - 1);
    if (!scr_battle_is_alive(_battle.party[_index])) return false;
    if (_index == _battle.active_actor) {
        _battle.message = _battle.player.name + " is already in front.";
        return false;
    }
    var _from = _battle.player.name;
    scr_battle_set_active(_battle, _index);
    _battle.state = BATTLE_PHASE.PLAYER_RESULT;
    _battle.message = _from + " steps back. " + _battle.player.name + " takes the field.";
    return true;
}

/// @desc One enemy action against the front standing member. Guarding halves it. Returns false when the
/// enemy cannot act, so a defeated enemy never attacks.
function scr_battle_enemy_turn(_battle) {
    if (!scr_battle_is_alive(_battle.enemy)) return false;
    var _target = scr_battle_enemy_target(_battle);
    /// Everybody down already: that is a defeat, not a skipped turn.
    if (is_undefined(_target)) {
        _battle.state = BATTLE_PHASE.DEFEAT;
        _battle.finished = true;
        _battle.message = "The party falls...";
        return true;
    }
    var _damage = scr_calculate_damage(_battle.enemy.attack, scr_actor_defense(_target));
    var _guarded = _target.guarding;
    if (_guarded) _damage = scr_guard_damage(_damage);
    _target.hp = scr_apply_damage(_target.hp, _target.max_hp, _damage);
    _battle.last_damage = _damage;
    _battle.state = BATTLE_PHASE.ENEMY_RESULT;
    _battle.message = _battle.enemy.name + " hits " + _target.name + " for " + string(_damage) + (_guarded ? " (guarded)." : ".");
    /// The fight ends only when nobody is left standing, so losing one member is not losing the battle.
    if (scr_battle_standing_count(_battle.party) == 0) {
        _battle.state = BATTLE_PHASE.DEFEAT;
        _battle.finished = true;
        _battle.message = _target.name + " falls...";
    }
    return true;
}

/// @desc Confirm the current phase: advance text, execute the pending turn, or open the next command.
/// Returns false when the phase does not advance (victory, defeat, or an invalid press).
/// A round is one command from every standing member, then one enemy action: the acting slot moves
/// forward through the party, and only when nobody is left to act does the enemy take its turn.
function scr_battle_advance(_battle, _roll = undefined) {
    switch (_battle.state) {
        case BATTLE_PHASE.INTRO:
            _battle.state = BATTLE_PHASE.COMMAND;
            _battle.message = "Choose a command.";
            return true;
        case BATTLE_PHASE.COMMAND:
            /// Remember whose action this is: a switch moves the active member, but the *slot* still acts.
            _battle.acting_slot = _battle.active_actor;
            if (_battle.cursor == BATTLE_COMMAND.ITEM) return scr_battle_open_items(_battle);
            if (_battle.cursor == BATTLE_COMMAND.SWITCH) return scr_battle_open_switch(_battle);
            if (_battle.cursor == BATTLE_COMMAND.FLEE) return scr_battle_flee_attempt(_battle, _roll);
            return scr_battle_player_command(_battle, _battle.cursor);
        case BATTLE_PHASE.ITEM:
            return scr_battle_use_selected_item(_battle);
        case BATTLE_PHASE.SWITCH:
            return scr_battle_confirm_switch(_battle);
        case BATTLE_PHASE.PLAYER_RESULT:
            var _next = scr_battle_next_standing(_battle.party, _battle.acting_slot + 1);
            if (_next >= 0) {
                scr_battle_set_active(_battle, _next);
                _battle.state = BATTLE_PHASE.COMMAND;
                _battle.message = "Choose a command.";
                return true;
            }
            return scr_battle_enemy_turn(_battle);
        case BATTLE_PHASE.ENEMY_RESULT:
            /// Guard covers exactly one enemy turn, for everyone who guarded, and clears before the next
            /// round so it is never left on for free.
            var _members = array_length(_battle.party);
            for (var _i = 0; _i < _members; _i++) _battle.party[_i].guarding = false;
            scr_battle_set_active(_battle, max(0, scr_battle_next_standing(_battle.party, 0)));
            _battle.state = BATTLE_PHASE.COMMAND;
            _battle.message = "Choose a command.";
            _battle.turn += 1;
            return true;
    }
    return false;
}

/// @desc Copy the enemy's rewards into the battle once, on victory only. The progression system
/// (roadmap step 4) reads `rewards` when the controller closes.
function scr_battle_grant_rewards(_battle) {
    if (_battle.rewarded || _battle.state != BATTLE_PHASE.VICTORY) return false;
    _battle.rewards.xp = _battle.enemy.xp_reward;
    _battle.rewards.gold = _battle.enemy.gold_reward;
    _battle.rewarded = true;
    return true;
}
