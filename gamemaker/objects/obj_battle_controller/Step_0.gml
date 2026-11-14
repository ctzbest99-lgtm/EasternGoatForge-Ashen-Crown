/// obj_battle_controller : Step
/// Exactly one state is handled per frame. All confirms use *_pressed, so holding a key
/// cannot repeat an action.

// Advance looping idles (and any clip already playing) every frame.
var _v;
for (_v = 0; _v < array_length(enemy_vis); _v++) scr_battle_vis_update(enemy_vis[_v]);
for (_v = 0; _v < array_length(party_vis); _v++) scr_battle_vis_update(party_vis[_v]);
scr_battle_fx_step(battle_fx);
scr_battle_pops_step(dmg_pops);

// Defeated regular enemies fade out once their death clip has finished. Bosses and a
// yielding boss stay on screen (yield holds its last frame).
for (_v = 0; _v < array_length(enemies); _v++) {
    var _fe = enemies[_v];
    var _fw = variable_struct_exists(_fe, "withdrawn") && _fe.withdrawn; // left the field after a yield
    if ((_fe.hp > 0 && !_fw) || _fe.yielded || _fe.is_boss || _fe.fade <= 0) continue;
    var _fv = enemy_vis[_v];
    if (_fw || !is_struct(_fv) || _fv.finished) _fe.fade = max(0, _fe.fade - 1 / max(1, BATTLE_DEAD_ENEMY_FADE_FRAMES));
}

switch (state) {

    case BATTLE_STATE.INTRO:
        if (array_length(enemies) == 0) { state = BATTLE_STATE.ERROR; break; }
        queue_message(scr_battle_intro_text(enemies, boss_index), BATTLE_STATE.ROUND_START);
        break;

    case BATTLE_STATE.MESSAGE:
        if (scr_input_confirm_pressed()) state = next_state;
        break;

    case BATTLE_STATE.ROUND_START:
        scr_party_clear_guard(party); // Guard lasts from when it resolves until the party's next command phase
        var _r;
        for (_r = 0; _r < array_length(party_vis); _r++) {
            if (is_struct(party_vis[_r]) && party_vis[_r].anim == "defend") scr_battle_vis_play(party_vis[_r], "idle");
        }
        for (_r = 0; _r < array_length(party); _r++) { scr_battle_tick_buffs(party[_r]); scr_battle_tick_statuses(party[_r]); }
        for (_r = 0; _r < array_length(enemies); _r++) { scr_battle_tick_buffs(enemies[_r]); scr_battle_tick_statuses(enemies[_r]); }
        queued_actions = [];
        turn_order = [];
        turn_pos = 0;
        command_index = 0;
        pending_command = "";
        pending_skill = "";
        actor_index = scr_party_next_living_index(party, 0);
        state = (actor_index == -1) ? BATTLE_STATE.DEFEAT : BATTLE_STATE.COMMAND_SELECT;
        break;

    case BATTLE_STATE.COMMAND_SELECT:
        var _cur = party[actor_index];
        if (scr_battle_status_has(_cur, "sleep")) {
            // Asleep: no command this round (the turn is skipped when it comes up).
            commit_action({ actor_index: actor_index, command: "Sleep", skill_id: "", target_side: "", target_index: -1 });
            break;
        }
        command_options = scr_party_battle_commands(_cur);
        var _command_count = array_length(command_options);
        if (command_index >= _command_count) command_index = 0;
        if (scr_input_up_pressed()) command_index = (command_index - 1 + _command_count) mod _command_count;
        if (scr_input_down_pressed()) command_index = (command_index + 1) mod _command_count;

        if (scr_input_confirm_pressed()) {
            var _cmd = command_options[command_index];
            if (_cmd == "Attack") {
                pending_command = "Attack";
                pending_skill = "attack";
                begin_target_select("enemy");
            } else if (_cmd == "Skill") {
                skill_list = scr_skill_list_active(_cur);
                skill_index = 0;
                if (array_length(skill_list) > 0) state = BATTLE_STATE.SKILL_SELECT;
            } else {
                commit_action({ actor_index: actor_index, command: _cmd, skill_id: "", target_side: "", target_index: -1 });
            }
        } else if (scr_input_cancel_pressed() && array_length(queued_actions) > 0) {
            // Back up to the previous party member's choice (no effect with a one-member party).
            var _undo = array_pop(queued_actions);
            actor_index = _undo.actor_index;
            command_index = 0;
        }
        break;

    case BATTLE_STATE.SKILL_SELECT:
        var _sn = array_length(skill_list);
        if (_sn == 0) { state = BATTLE_STATE.COMMAND_SELECT; break; }
        if (scr_input_up_pressed()) skill_index = (skill_index - 1 + _sn) mod _sn;
        if (scr_input_down_pressed()) skill_index = (skill_index + 1) mod _sn;
        if (scr_input_cancel_pressed()) { state = BATTLE_STATE.COMMAND_SELECT; break; }
        if (scr_input_confirm_pressed()) {
            var _sid = skill_list[skill_index];
            if (!scr_skill_can_afford(party[actor_index], _sid)) break; // greyed out: not enough MP
            pending_command = "Skill";
            pending_skill = _sid;
            var _sdef = scr_skill_get(_sid);
            if (_sdef.target == "single") begin_target_select("enemy");
            else if (_sdef.target == "ally") begin_target_select("party");
            else commit_action({ actor_index: actor_index, command: "Skill", skill_id: _sid, target_side: "", target_index: -1 });
        }
        break;

    case BATTLE_STATE.TARGET_SELECT:
        if (!is_up(target_side, target_index)) cycle_target(1);
        if (scr_input_up_pressed() || scr_input_left_pressed()) cycle_target(-1);
        if (scr_input_down_pressed() || scr_input_right_pressed()) cycle_target(1);
        if (scr_input_cancel_pressed()) {
            state = (pending_command == "Skill") ? BATTLE_STATE.SKILL_SELECT : BATTLE_STATE.COMMAND_SELECT;
            break;
        }
        if (scr_input_confirm_pressed()) {
            commit_action({ actor_index: actor_index, command: pending_command, skill_id: pending_skill, target_side: target_side, target_index: target_index });
        }
        break;

    case BATTLE_STATE.TURN_NEXT:
        var _outcome = battle_outcome();
        if (_outcome == "victory") { state = BATTLE_STATE.VICTORY; break; }
        if (_outcome == "defeat") { state = BATTLE_STATE.DEFEAT; break; }
        if (turn_pos >= array_length(turn_order)) { state = BATTLE_STATE.ROUND_START; break; }
        current_turn = turn_order[turn_pos];
        turn_pos += 1;
        state = (current_turn.side == "party") ? BATTLE_STATE.PLAYER_ACTION : BATTLE_STATE.ENEMY_TURN;
        break;

    case BATTLE_STATE.PLAYER_ACTION:
        var _action = current_turn.action;
        var _actor = party[_action.actor_index];
        if (!scr_actor_is_alive(_actor)) { state = BATTLE_STATE.TURN_NEXT; break; } // KO'd before their turn
        if (_action.command == "Sleep" || scr_battle_status_has(_actor, "sleep")) {
            // Sleeping is not taking a turn, so it does not count for XP participation.
            queue_message(_actor.name + " is asleep.", BATTLE_STATE.TURN_NEXT);
            break;
        }

        // Taking the turn counts for XP, even if the action later fails (e.g. a blocked swap).
        scr_party_mark_participated(_actor);

        if (_action.command == "Guard") {
            _actor.is_guarding = true;
            // Hold a defend pose while guarding when the member has one (Taren: spr_taren_defend_strip3).
            var _gv = get_vis("party", _action.actor_index);
            if (is_struct(_gv) && scr_sprite_is_valid(scr_battle_sprite(_gv.kind, "defend", 1))) scr_battle_vis_play(_gv, "defend");
            queue_message(_actor.name + " guards.", BATTLE_STATE.TURN_NEXT);
        } else if (_action.command == "Swap") {
            // Costs this member's turn. The incoming reserve member acts on later rounds, not this one.
            var _incoming_name = scr_party_has_reserve() ? global.game.reserve[0].name : "";
            if (scr_party_swap_active_reserve(_action.actor_index)) {
                _actor.buffs = [];
                _actor.statuses = [];
                _actor.is_guarding = false;
                // Slot changed by reference; rebuild this slot's battle vis for the incoming member.
                party_vis[_action.actor_index] = scr_battle_vis_create(party[_action.actor_index].actor_id, -1);
                queue_message(_actor.name + " swaps out. " + _incoming_name + " joins the front line.", BATTLE_STATE.TURN_NEXT);
            } else {
                queue_message(_actor.name + " has no one to swap with.", BATTLE_STATE.TURN_NEXT);
            }
        } else if (_action.command == "Skill") {
            do_party_skill(_action.actor_index, _action.skill_id, _action.target_index);
        } else { // "Attack"
            do_party_skill(_action.actor_index, "attack", _action.target_index);
        }
        break;

    case BATTLE_STATE.ENEMY_TURN:
        var _ei = current_turn.index;
        if (!is_up("enemy", _ei)) { state = BATTLE_STATE.TURN_NEXT; break; }
        if (!scr_party_any_alive(party)) { state = BATTLE_STATE.DEFEAT; break; }
        var _foe = enemies[_ei];
        if (scr_battle_status_has(_foe, "sleep")) { queue_message(_foe.name + " is asleep.", BATTLE_STATE.TURN_NEXT); break; }
        var _allies = array_length(living("enemy")) - 1;
        // Field surgeon gate: is any living ally (self included) below the heal threshold?
        _foe.ally_hurt = false;
        var _lh = living("enemy");
        for (var _hq = 0; _hq < array_length(_lh); _hq++) {
            var _ha = enemies[_lh[_hq]];
            if (_ha.hp < _ha.max_hp * BATTLE_HEAL_ALLY_THRESHOLD) _foe.ally_hurt = true;
        }
        var _pick = scr_battle_ai_pick(_foe, _allies);
        var _esk = scr_skill_get(_pick);
        var _etargets = resolve_targets("enemy", _ei, _esk, -1);
        if (array_length(_etargets) == 0) { state = BATTLE_STATE.TURN_NEXT; break; }
        _foe.mp = max(0, _foe.mp - _esk.mp_cost);
        run_skill("enemy", _ei, _esk, _etargets);
        break;

    case BATTLE_STATE.ANIMATING:
        // Projectiles tied to a specific attack frame (crossbowman bolt: frame index 3).
        if (!anim_fx_done && is_struct(anim_hit) && anim_hit.fx_frame >= 0 && is_struct(anim_attacker_vis)
            && anim_attacker_vis.anim == anim_hit.anim && anim_attacker_vis.frame >= anim_hit.fx_frame) {
            anim_fx_done = true;
            scr_ch1_battle_spawn_special_fx(anim_hit);
        }
        if (!anim_hit_applied && scr_battle_vis_hit_ready(anim_attacker_vis)) {
            apply_pending_hit();
        }
        var _skip = scr_input_confirm_pressed();
        if (_skip) {
            if (!anim_hit_applied) apply_pending_hit();
            if (is_struct(anim_attacker_vis)) scr_battle_vis_snap_end(anim_attacker_vis);
            for (var _st = 0; _st < array_length(anim_target_vises); _st++) {
                var _sv = anim_target_vises[_st];
                if (is_struct(_sv) && (_sv.anim == "hurt" || _sv.anim == "death" || _sv.anim == "yield")) scr_battle_vis_snap_end(_sv);
            }
        }
        var _att_done = !is_struct(anim_attacker_vis) || anim_attacker_vis.finished;
        var _tgt_done = true;
        for (var _tt = 0; _tt < array_length(anim_target_vises); _tt++) {
            var _tv = anim_target_vises[_tt];
            if (is_struct(_tv) && !_tv.finished && _tv.anim != "idle") _tgt_done = false;
        }
        if (anim_hit_applied && _att_done && _tgt_done) {
            finish_animating();
        }
        break;

    case BATTLE_STATE.PHASE_SHIFT:
        var _pv = get_vis("enemy", phase_enemy);
        if (scr_input_confirm_pressed() && is_struct(_pv)) scr_battle_vis_snap_end(_pv);
        if (!is_struct(_pv) || _pv.finished) {
            finish_phase_shift();
        }
        break;

    case BATTLE_STATE.STANCE_SHIFT:
        var _sv2 = get_vis("enemy", stance_enemy);
        if (scr_input_confirm_pressed() && is_struct(_sv2)) scr_battle_vis_snap_end(_sv2);
        if (!is_struct(_sv2) || _sv2.finished) {
            finish_stance();
        }
        break;

    case BATTLE_STATE.VICTORY:
        battle_result = "victory";
        var _yield_line = "";
        if (!rewards_granted) {
            rewards_granted = true;
            victory_xp = 0;
            victory_gold = 0;
            // Gold is shared and summed over every defeated (or yielded) enemy. XP was banked per
            // living participant at each enemy's killing hit; this only catches anything missed.
            // Enemies still standing when a boss yields withdraw; they still give XP (credited at
            // the yield) and gold (PLACEHOLDER rule, balance pass).
            for (var _ve = 0; _ve < array_length(enemies); _ve++) {
                var _de = enemies[_ve];
                var _dw = variable_struct_exists(_de, "withdrawn") && _de.withdrawn;
                if (_de.hp > 0 && !_de.yielded && !_dw) continue;
                victory_gold += _de.gold_reward + _de.stolen_gold; // a beaten cutpurse drops what it stole
                victory_xp += _de.xp_reward;
                if (!_de.xp_credited) {
                    scr_party_credit_enemy_xp(_de.xp_reward);
                    _de.xp_credited = true;
                }
            }
            global.game.gold += victory_gold;
            level_ups = scr_party_apply_pending_xp();
            level_up_index = 0;
            if (array_length(party) > 0 && is_struct(party[0])) global.game.xp = party[0].xp;
        }
        for (var _ye = 0; _ye < array_length(enemies); _ye++) {
            if (!enemies[_ye].yielded) continue;
            _yield_line = (enemies[_ye].yield_line != "") ? enemies[_ye].yield_line : (enemies[_ye].full_name + " yields.");
            var _any_wd = false;
            for (var _wq = 0; _wq < array_length(enemies); _wq++) {
                if (variable_struct_exists(enemies[_wq], "withdrawn") && enemies[_wq].withdrawn) _any_wd = true;
            }
            if (_any_wd) _yield_line += " The rest withdraw.";
            _yield_line += "\n";
        }
        var _after_victory = (array_length(level_ups) > 0) ? BATTLE_STATE.LEVEL_UP : BATTLE_STATE.EXIT;
        queue_message(_yield_line + "Victory! Gained " + string(victory_xp) + " XP and " + string(victory_gold) + " gold.", _after_victory);
        break;

    case BATTLE_STATE.LEVEL_UP:
        if (level_up_index >= array_length(level_ups)) { state = BATTLE_STATE.EXIT; break; }
        var _up = level_ups[level_up_index];
        level_up_index += 1;
        var _after_level = (level_up_index >= array_length(level_ups)) ? BATTLE_STATE.EXIT : BATTLE_STATE.LEVEL_UP;
        var _up_mp = variable_struct_exists(_up, "mp") ? (", MP +" + string(_up.mp)) : "";
        var _up_spd = variable_struct_exists(_up, "spd") ? (", SPD +" + string(_up.spd)) : "";
        queue_message(_up.name + " reached level " + string(_up.level) + "! HP +" + string(_up.hp) + _up_mp + ", ATK +" + string(_up.attack) + ", DEF +" + string(_up.defense) + _up_spd + ".", _after_level);
        break;

    case BATTLE_STATE.DEFEAT:
        battle_result = "defeat";
        // HP / MP restore and town respawn happen in scr_battle_finish(); keep 0 HP on this message.
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
