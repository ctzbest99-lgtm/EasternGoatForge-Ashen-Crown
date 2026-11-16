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
    PLAYER_RESULT,
    ENEMY_RESULT,
    VICTORY,
    DEFEAT
}

enum BATTLE_COMMAND {
    ATTACK,
    GUARD
}

#macro BATTLE_COMMAND_COUNT 2

/// @desc Display name of a command id.
function scr_battle_command_name(_command) {
    switch (_command) {
        case BATTLE_COMMAND.ATTACK: return "Attack";
        case BATTLE_COMMAND.GUARD: return "Guard";
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

/// @desc Start a battle against _enemy_id. Returns undefined for an unknown id so callers can report it.
/// _player_name is optional; the placeholder player stats are deliberately simple until equipment exists.
function scr_battle_create(_enemy_id, _player_name = "Kael") {
    var _data = scr_get_enemy_data(_enemy_id);
    if (is_undefined(_data) || _data == undefined) return undefined;
    var _player = scr_battle_actor(_player_name, 30, 6, 2);
    var _enemy = scr_battle_actor(_data.name, _data.max_hp, _data.attack, _data.defense);
    _enemy.id = _data.id;
    _enemy.xp_reward = _data.xp_reward;
    _enemy.gold_reward = _data.gold_reward;
    return {
        state: BATTLE_PHASE.INTRO,
        message: _enemy.name + " blocks the way!",
        cursor: BATTLE_COMMAND.ATTACK,
        turn: 1,
        player: _player,
        party: [_player],
        active_actor: 0,
        enemy: _enemy,
        last_damage: 0,
        rewards: { xp: 0, gold: 0 },
        rewarded: false,
        finished: false
    };
}

/// @desc True while the battle still accepts commands (victory and defeat are terminal).
function scr_battle_is_over(_battle) {
    return _battle.state == BATTLE_PHASE.VICTORY || _battle.state == BATTLE_PHASE.DEFEAT;
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
            var _damage = scr_calculate_damage(_battle.player.attack, _battle.enemy.defense);
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

/// @desc One enemy action. Halves incoming damage while the player guards. Returns false when the
/// enemy cannot act, so a defeated enemy never attacks.
function scr_battle_enemy_turn(_battle) {
    if (!scr_battle_is_alive(_battle.enemy) || !scr_battle_is_alive(_battle.player)) return false;
    var _damage = scr_calculate_damage(_battle.enemy.attack, _battle.player.defense);
    var _guarded = _battle.player.guarding;
    if (_guarded) _damage = scr_guard_damage(_damage);
    _battle.player.hp = scr_apply_damage(_battle.player.hp, _battle.player.max_hp, _damage);
    _battle.last_damage = _damage;
    _battle.state = BATTLE_PHASE.ENEMY_RESULT;
    _battle.message = _battle.enemy.name + " hits for " + string(_damage) + (_guarded ? " (guarded)." : ".");
    if (!scr_battle_is_alive(_battle.player)) {
        _battle.state = BATTLE_PHASE.DEFEAT;
        _battle.finished = true;
        _battle.message = _battle.player.name + " falls...";
    }
    return true;
}

/// @desc Confirm the current phase: advance text, execute the pending turn, or open the next command.
/// Returns false when the phase does not advance (victory, defeat, or an invalid press).
function scr_battle_advance(_battle) {
    switch (_battle.state) {
        case BATTLE_PHASE.INTRO:
            _battle.state = BATTLE_PHASE.COMMAND;
            _battle.message = "Choose a command.";
            return true;
        case BATTLE_PHASE.COMMAND:
            return scr_battle_player_command(_battle, _battle.cursor);
        case BATTLE_PHASE.PLAYER_RESULT:
            return scr_battle_enemy_turn(_battle);
        case BATTLE_PHASE.ENEMY_RESULT:
            /// Guard covers exactly one enemy turn; it clears before the next command.
            _battle.player.guarding = false;
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
