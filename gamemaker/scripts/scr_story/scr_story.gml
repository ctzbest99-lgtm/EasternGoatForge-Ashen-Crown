/// scr_story — Chapter 1 story helpers. Ashbound Hunter flow: CHAPTER1_SCRIPT.md §4.1.

/// Play ENC_AH_01–02, then start the Ashbound Hunter battle.
/// `_encounter_id` is "enc_ashbound_hunter_wt" for the guaranteed Watchtower fight,
/// or "" for the rare random fight (not stored in cleared_encounters).
function scr_ashbound_hunter_start(_encounter_id = "") {
    scr_game_state_init();
    var _g = global.game;
    if (_g.battle_active || _g.transition_active) return false;
    _g.pending_ashbound_encounter_id = _encounter_id;
    scr_dialogue_play(["ENC_AH_01", "ENC_AH_02"], scr_ashbound_begin_battle);
    return true;
}

function scr_ashbound_begin_battle() {
    scr_game_state_init();
    var _id = global.game.pending_ashbound_encounter_id;
    global.game.pending_ashbound_encounter_id = "";
    scr_encounter_start("ashbound_hunter", _id, "ENC_ASHBOUND_HUNTER");
}

/// Called from scr_battle_finish. On a Hunter victory, grant the parchment the
/// first time (`flag_parchment_found` / item_ashbound_parchment) and queue ENC_AH_03–05.
/// If the flag is already set, the post-fight lines are skipped.
function scr_ashbound_on_battle_finish(_result, _pending) {
    if (!is_struct(_pending)) return;
    var _is_hunter = (_pending.enemy_id == "ashbound_hunter")
        || (variable_struct_exists(_pending, "script_id") && _pending.script_id == "ENC_ASHBOUND_HUNTER");
    if (!_is_hunter) return;

    scr_game_state_init();
    if (_result != "victory") {
        global.game.pending_post_dialogue = undefined;
        return;
    }

    if (scr_flag_get("flag_parchment_found")) {
        global.game.pending_post_dialogue = undefined;
        return;
    }

    scr_inventory_add("item_ashbound_parchment", "Ashbound Parchment", 1, true);
    scr_flag_set("flag_parchment_found", true);
    global.game.pending_post_dialogue = ["ENC_AH_03", "ENC_AH_04", "ENC_AH_05"];
}

/// After a victory return, play any queued post-fight story lines.
function scr_story_try_pending_post_dialogue() {
    scr_game_state_init();
    var _ids = global.game.pending_post_dialogue;
    global.game.pending_post_dialogue = undefined;
    // Optional callback after the lines (Chapter 2: Taren's join talk sets flag_taren_recruited).
    var _cb = variable_struct_exists(global.game, "pending_post_callback") ? global.game.pending_post_callback : undefined;
    global.game.pending_post_callback = undefined;
    if (is_array(_ids) && array_length(_ids) > 0) {
        scr_dialogue_play(_ids, _cb);
    } else if (!is_undefined(_cb)) {
        _cb();
    }
}

/// True when this area can roll the rare Ashbound Hunter (Old Road, Bandit Camp,
/// Watchtower). A zone's allow_ashbound_rare flag, or the Zone 1 table ids
/// zone01_old_road / zone01_bandit_camp / zone01_watchtower (and the older
/// short ids old_road / bandit_camp / watchtower), opt in. zone01_path and
/// zone01_farmlands do not.
function scr_area_allows_ashbound_rare() {
    if (!instance_exists(obj_player)) return false;
    var _zone = noone;
    with (obj_player) _zone = instance_place(x, y, obj_encounter_zone);
    if (_zone != noone) {
        if (variable_instance_exists(_zone, "allow_ashbound_rare") && _zone.allow_ashbound_rare) return true;
        if (variable_instance_exists(_zone, "table_id")) {
            var _tid = _zone.table_id;
            if (_tid == "zone01_old_road" || _tid == "zone01_bandit_camp" || _tid == "zone01_watchtower") return true;
            if (_tid == "old_road" || _tid == "bandit_camp" || _tid == "watchtower") return true;
        }
    }
    return false;
}


/// On a Blackguard victory: set blackguard_defeated, grant the canon key items
/// (Longsword + Crownveil Fragment), and queue BG_DEFEAT / BG_REWARD. XP (250)
/// and gold (100) come from the canon enemy DB entry.
function scr_blackguard_on_battle_finish(_result, _pending) {
    if (!is_struct(_pending)) return;
    var _is_bg = (_pending.enemy_id == "blackguard");
    if (!_is_bg && variable_struct_exists(_pending, "encounter_id") && _pending.encounter_id == "zone01_boss_blackguard") _is_bg = true;
    if (!_is_bg) return;
    scr_game_state_init();
    if (_result != "victory") {
        return;
    }
    scr_flag_set("blackguard_defeated");
    scr_inventory_add("item_blackguard_longsword", "Blackguard's Longsword", 1, true);
    scr_inventory_add("item_crownveil_fragment", "Crownveil Fragment", 1, true);
    global.game.pending_post_dialogue = ["BG_DEFEAT_01", "BG_DEFEAT_02", "BG_DEFEAT_03", "BG_REWARD_01"];
}
