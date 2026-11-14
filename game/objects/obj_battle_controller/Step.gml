/// obj_battle_controller : Step
/// Exactly one state is handled per frame. All confirms use *_pressed, so holding a key
/// cannot repeat an action.
switch (state) {

    case BATTLE_STATE.INTRO:
        queue_message("A " + enemy.name + " appears!", BATTLE_STATE.ROUND_START);
        break;

    case BATTLE_STATE.MESSAGE:
        if (scr_input_confirm_pressed()) state = next_state;
        break;

    case BATTLE_STATE.ROUND_START:
        scr_party_clear_guard(party); // Guard lasts from when it resolves until the party's next command phase
        queued_actions = [];
        action_index = 0;
        command_index = 0;
        actor_index = scr_party_next_living_index(party, 0);
        state = (actor_index == -1) ? BATTLE_STATE.DEFEAT : BATTLE_STATE.COMMAND_SELECT;
        break;

    case BATTLE_STATE.COMMAND_SELECT:
        var _command_count = array_length(command_options);
        if (scr_input_up_pressed()) command_index = (command_index - 1 + _command_count) mod _command_count;
        if (scr_input_down_pressed()) command_index = (command_index + 1) mod _command_count;

        if (scr_input_confirm_pressed()) {
            array_push(queued_actions, { actor_index: actor_index, command: command_options[command_index] });
            var _next_actor = scr_party_next_living_index(party, actor_index + 1);
            if (_next_actor == -1) {
                action_index = 0;
                state = BATTLE_STATE.PLAYER_ACTION;
            } else {
                actor_index = _next_actor;
                command_index = 0;
            }
        } else if (scr_input_cancel_pressed() && array_length(queued_actions) > 0) {
            // Back up to the previous party member's choice (no effect with a one-member party).
            var _undo = array_pop(queued_actions);
            actor_index = _undo.actor_index;
            command_index = 0;
        }
        break;

    case BATTLE_STATE.PLAYER_ACTION:
        if (enemy.hp <= 0) { state = BATTLE_STATE.VICTORY; break; }
        if (action_index >= array_length(queued_actions)) { state = BATTLE_STATE.ENEMY_TURN; break; }

        var _action = queued_actions[action_index];
        action_index += 1;
        var _actor = party[_action.actor_index];
        if (!scr_actor_is_alive(_actor)) break; // defeated actors cannot act; next action next frame

        if (_action.command == "Guard") {
            _actor.is_guarding = true;
            queue_message(_actor.name + " guards.", BATTLE_STATE.PLAYER_ACTION);
        } else { // "Attack"
            var _damage = scr_calculate_damage(_actor.attack, enemy.defense);
            enemy.hp = scr_apply_damage(enemy.hp, enemy.max_hp, _damage);
            queue_message(_actor.name + " attacks! " + enemy.name + " takes " + string(_damage) + " damage.", BATTLE_STATE.PLAYER_ACTION);
        }
        break;

    case BATTLE_STATE.ENEMY_TURN:
        if (enemy.hp <= 0) { state = BATTLE_STATE.VICTORY; break; }
        var _target_index = scr_party_random_living_index(party);
        if (_target_index == -1) { state = BATTLE_STATE.DEFEAT; break; }

        var _target = party[_target_index];
        var _enemy_damage = scr_apply_guard(scr_calculate_damage(enemy.attack, _target.defense), _target.is_guarding);
        _target.hp = scr_apply_damage(_target.hp, _target.max_hp, _enemy_damage);
        var _guard_note = _target.is_guarding ? " (guarded)" : "";
        var _after_enemy = scr_party_any_alive(party) ? BATTLE_STATE.ROUND_START : BATTLE_STATE.DEFEAT;
        queue_message(enemy.name + " attacks " + _target.name + "! " + string(_enemy_damage) + " damage" + _guard_note + ".", _after_enemy);
        break;

    case BATTLE_STATE.VICTORY:
        battle_result = "victory";
        if (!rewards_granted) {
            rewards_granted = true;
            global.game.xp += enemy.xp_reward;
            global.game.gold += enemy.gold_reward;
        }
        queue_message("Victory! Gained " + string(enemy.xp_reward) + " XP and " + string(enemy.gold_reward) + " gold.", BATTLE_STATE.EXIT);
        break;

    case BATTLE_STATE.DEFEAT:
        battle_result = "defeat";
        scr_party_restore_all(party); // prototype rule only; real defeat handling is an open question
        queue_message("The party has fallen... [Prototype: HP restored, returning to the map.]", BATTLE_STATE.EXIT);
        break;

    case BATTLE_STATE.ERROR:
        battle_result = "error";
        queue_message("[Encounter data missing. Returning to the map.]", BATTLE_STATE.EXIT);
        break;

    case BATTLE_STATE.EXIT:
        if (!finished) {
            finished = true;
            scr_battle_finish(battle_result);
        }
        break;
}
