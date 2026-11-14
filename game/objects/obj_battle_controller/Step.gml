/// obj_battle_controller : Step
/// Exactly one state is handled per frame. All confirms use *_pressed, so holding a key
/// cannot repeat an action.

// Advance looping idles (and any clip already playing) every frame.
if (is_struct(enemy_vis)) scr_battle_vis_update(enemy_vis);
var _v;
for (_v = 0; _v < array_length(party_vis); _v++) scr_battle_vis_update(party_vis[_v]);
scr_battle_fx_step(battle_fx);
scr_battle_pops_step(dmg_pops);

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
        command_options = scr_party_battle_commands();
        var _command_count = array_length(command_options);
        if (command_index >= _command_count) command_index = 0;
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
        if (is_struct(enemy) && enemy.hp <= 0) { state = BATTLE_STATE.VICTORY; break; }
        if (action_index >= array_length(queued_actions)) { state = BATTLE_STATE.ENEMY_TURN; break; }

        var _action = queued_actions[action_index];
        action_index += 1;
        var _actor = party[_action.actor_index];
        if (!scr_actor_is_alive(_actor)) break; // defeated actors cannot act; next action next frame

        // Taking the turn counts for XP, even if the action later fails (e.g. a blocked swap).
        scr_party_mark_participated(_actor);

        if (_action.command == "Guard") {
            _actor.is_guarding = true;
            queue_message(_actor.name + " guards.", BATTLE_STATE.PLAYER_ACTION);
        } else if (_action.command == "Swap") {
            // Costs this member's turn. The incoming reserve member acts on later rounds, not this one.
            var _incoming_name = scr_party_has_reserve() ? global.game.reserve[0].name : "";
            if (scr_party_swap_active_reserve(_action.actor_index)) {
                // Slot changed by reference; rebuild this slot's battle vis for the incoming member.
                party_vis[_action.actor_index] = scr_battle_vis_create(party[_action.actor_index].actor_id, -1);
                queue_message(_actor.name + " swaps out. " + _incoming_name + " joins the front line.", BATTLE_STATE.PLAYER_ACTION);
            } else {
                queue_message(_actor.name + " has no one to swap with.", BATTLE_STATE.PLAYER_ACTION);
            }
        } else { // "Attack"
            var _defense = enemy.defense;
            var _damage = scr_calculate_damage(_actor.attack, _defense);
            var _text = _actor.name + " attacks! " + enemy.name + " takes " + string(_damage) + " damage.";
            var _att_vis = party_vis[_action.actor_index];
            // Damage and XP credit run in apply_pending_hit() at the attack's hit frame.
            begin_attack_anim(_att_vis, enemy_vis, { kind: "player_attack", damage: _damage, party_index: _action.actor_index }, _text, BATTLE_STATE.PLAYER_ACTION, "attack");
        }
        break;

    case BATTLE_STATE.ANIMATING:
        if (!anim_hit_applied && scr_battle_vis_hit_ready(anim_attacker_vis)) {
            apply_pending_hit();
        }
        var _skip = scr_input_confirm_pressed();
        if (_skip) {
            if (!anim_hit_applied) apply_pending_hit();
            if (is_struct(anim_attacker_vis)) scr_battle_vis_snap_end(anim_attacker_vis);
            if (is_struct(anim_target_vis) && (anim_target_vis.anim == "hurt" || anim_target_vis.anim == "death")) {
                scr_battle_vis_snap_end(anim_target_vis);
            }
        }
        var _att_done = !is_struct(anim_attacker_vis) || anim_attacker_vis.finished;
        var _tgt_done = !is_struct(anim_target_vis) || anim_target_vis.finished || (anim_target_vis.anim == "idle");
        if (anim_hit_applied && _att_done && _tgt_done) {
            finish_animating();
        }
        break;

    case BATTLE_STATE.PHASE_SHIFT:
        if (scr_input_confirm_pressed() && is_struct(enemy_vis)) scr_battle_vis_snap_end(enemy_vis);
        if (!is_struct(enemy_vis) || enemy_vis.finished) {
            finish_phase_shift();
        }
        break;

    case BATTLE_STATE.ENEMY_TURN:
        if (is_struct(enemy) && enemy.hp <= 0) { state = BATTLE_STATE.VICTORY; break; }
        var _target_index = scr_party_random_living_index(party);
        if (_target_index == -1) { state = BATTLE_STATE.DEFEAT; break; }

        var _target = party[_target_index];
        var _anim = "attack";
        var _special = false;
        var _sets_guard = false;
        if (enemy.actor_id == "blackguard") {
            var _ph = variable_struct_exists(enemy, "phase") ? enemy.phase : 1;
            _anim = scr_blackguard_pick_anim(_ph);
            if (_anim == "oath") _special = true;
        } else if (enemy.actor_id == "ash_wolf" && irandom(4) == 0) {
            _anim = "howl";
            _special = true;
        } else if (enemy.actor_id == "ashen_wretch" && irandom(4) == 0) {
            _anim = "scream";
            _special = true;
        } else if (enemy.actor_id == "grave_spider" && irandom(3) == 0) {
            _anim = "cast";
            _special = true;
        } else if (enemy.actor_id == "hollow_soldier" && irandom(3) == 0) {
            _anim = "guard";
            _special = true;
            _sets_guard = true;
        }

        var _hit_kind = _special ? "enemy_special" : "enemy_attack";
        var _enemy_damage = 0;
        var _etext;
        if (_special) {
            if (_anim == "oath") _etext = enemy.name + " swears a Blood Oath!";
            else if (_anim == "howl") _etext = enemy.name + " howls!";
            else if (_anim == "scream") _etext = enemy.name + " screams!";
            else if (_anim == "cast") _etext = enemy.name + " casts a web! (visual only)";
            else if (_anim == "guard") _etext = enemy.name + " raises a Shield Wall!";
            else _etext = enemy.name + " uses a special!";
        } else {
            _enemy_damage = scr_apply_guard(scr_calculate_damage(enemy.attack, _target.defense), _target.is_guarding);
            var _guard_note = _target.is_guarding ? " (guarded)" : "";
            var _label = (enemy.actor_id == "blackguard") ? scr_blackguard_anim_label(_anim) : "attacks";
            if (_label == "attacks") {
                _etext = enemy.name + " attacks " + _target.name + "! " + string(_enemy_damage) + " damage" + _guard_note + ".";
            } else {
                _etext = enemy.name + " uses " + _label + " on " + _target.name + "! " + string(_enemy_damage) + " damage" + _guard_note + ".";
            }
        }
        var _hit = {
            kind: _hit_kind,
            damage: _enemy_damage,
            party_index: _target_index,
            anim: _anim,
            enemy_kind: enemy.actor_id,
            sets_guard: _sets_guard
        };
        // anim_next_state is corrected in apply_pending_hit after HP is applied (ROUND_START or DEFEAT).
        begin_attack_anim(enemy_vis, party_vis[_target_index], _hit, _etext, BATTLE_STATE.ROUND_START, _anim);
        break;

    case BATTLE_STATE.VICTORY:
        battle_result = "victory";
        if (!rewards_granted) {
            rewards_granted = true;
            global.game.gold += enemy.gold_reward;
            // Gold is shared. XP was banked per living participant when the enemy died.
            // If the party had lost, pending_xp would be discarded (never applied).
            if (!enemy.xp_credited) {
                scr_party_credit_enemy_xp(enemy.xp_reward);
                enemy.xp_credited = true;
            }
            level_ups = scr_party_apply_pending_xp();
            level_up_index = 0;
            if (array_length(party) > 0 && is_struct(party[0])) global.game.xp = party[0].xp;
        }
        var _after_victory = (array_length(level_ups) > 0) ? BATTLE_STATE.LEVEL_UP : BATTLE_STATE.EXIT;
        queue_message("Victory! Gained " + string(enemy.xp_reward) + " XP and " + string(enemy.gold_reward) + " gold.", _after_victory);
        break;

    case BATTLE_STATE.LEVEL_UP:
        if (level_up_index >= array_length(level_ups)) { state = BATTLE_STATE.EXIT; break; }
        var _up = level_ups[level_up_index];
        level_up_index += 1;
        var _after_level = (level_up_index >= array_length(level_ups)) ? BATTLE_STATE.EXIT : BATTLE_STATE.LEVEL_UP;
        queue_message(_up.name + " reached level " + string(_up.level) + "! HP +" + string(_up.hp) + ", ATK +" + string(_up.attack) + ", DEF +" + string(_up.defense) + ".", _after_level);
        break;

    case BATTLE_STATE.DEFEAT:
        battle_result = "defeat";
        // HP restore and town respawn happen in scr_battle_finish(); keep 0 HP on this message.
        queue_message("The party has fallen...", BATTLE_STATE.EXIT);
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
