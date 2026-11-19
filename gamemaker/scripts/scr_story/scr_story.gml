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

/// Tutorial aftermath (CHAPTER1_SCRIPT.md §2.1) and the Hunter's Camp hunt counter.
/// Victory in the guaranteed first Bandit fight switches random encounters on
/// (flag_tutorial_done) and plays the post-battle lines FL_TUTORIAL_04-05 back on the map.
/// Called from scr_battle_finish.
function scr_ch1_on_battle_finish(_result, _pending) {
    if (!is_struct(_pending) || _result != "victory") return;
    scr_ch1_renn_count_wolves(_pending);
    if (!variable_struct_exists(_pending, "encounter_id") || _pending.encounter_id != "zone01_first_bandit") return;
    scr_flag_set("flag_tutorial_done");
    global.game.pending_post_dialogue = ["FL_TUTORIAL_04", "FL_TUTORIAL_05"];
}

/// Q_SIDE_RENN stage 1: every Ash Wolf killed while the hunt is open counts, five close it.
/// Uses the battle's resolved enemy list, so a pack of three counts as three.
function scr_ch1_renn_count_wolves(_pending) {
    if (scr_flag_get("quest_Q_SIDE_RENN") != "Q_SR_S1") return;
    var _ids = variable_struct_exists(_pending, "enemy_ids") ? _pending.enemy_ids : [_pending.enemy_id];
    var _kills = 0;
    for (var _i = 0; _i < array_length(_ids); _i++) {
        if (_ids[_i] == "ash_wolf") _kills++;
    }
    if (_kills <= 0) return;
    var _n = scr_flag_get("renn_wolves");
    if (!is_numeric(_n)) _n = 0;
    _n += _kills;
    scr_flag_set("renn_wolves", _n);
    if (_n >= 5) scr_flag_set("quest_Q_SIDE_RENN", "Q_SR_S2");
}

/// CHAPTER1_SCRIPT.md §2.2 — Old Hunter Renn at the Hunter's Camp.
/// First talk offers Q_SIDE_RENN; five Ash Wolves finish stage 1; turning in at stage 2
/// grants the Hunter's Charm and sets flag_renn_done.
function scr_ch1_renn_talk() {
    var _q = scr_flag_get("quest_Q_SIDE_RENN");
    if (!is_string(_q)) _q = "";
    if (scr_flag_get("flag_renn_done") || _q == "complete") {
        scr_dialogue_play(["HC_RENN_11"]);
        return;
    }
    if (_q == "Q_SR_S2") {
        scr_dialogue_play(["HC_RENN_08", "HC_RENN_09", "HC_RENN_10", "HC_RENN_11"], function() {
            scr_inventory_add("item_hunters_charm", "Hunter's Charm", 1, false);
            scr_flag_set("quest_Q_SIDE_RENN", "complete");
            scr_flag_set("flag_renn_done", true);
        });
        return;
    }
    if (_q == "Q_SR_S1") {
        scr_dialogue_play(["HC_RENN_07"]);
        return;
    }
    scr_dialogue_play(["HC_RENN_01", "HC_RENN_02", "HC_RENN_03", "HC_RENN_04"], function() {
        var _ask = scr_dialogue_node("HC_RENN_05");
        scr_dialogue_choice(_ask.lines, _ask.speaker, ["Yes.", "No."], function(_idx) {
            if (_idx == 0) {
                scr_flag_set("quest_Q_SIDE_RENN", "Q_SR_S1");
                scr_flag_set("renn_wolves", 0);
                scr_dialogue_play(["HC_RENN_06_YES"]);
            } else {
                scr_dialogue_play(["HC_RENN_06_NO"]);
            }
        });
    });
}

/// Chapter 1 main quest. The approved stages live in CHAPTER1_SCRIPT.md §0; this
/// function is the single progression point for flags, position and room changes.
/// It backfills saves made before Q_MAIN_FIND_MIRA existed, then only advances forward.
function scr_ch1_quest_tick() {
    if (room == TITLE_ROOM || room == BATTLE_ROOM) return;
    var _quest = "Q_MAIN_FIND_MIRA";
    var _stage = scr_quest_stage(_quest);
    // This runs in Begin Step. Only re-evaluate when the room, area, stage or a Chapter 1
    // story flag changes, so definition lookups stay off the per-frame path.
    var _rn = room_get_name(room);
    var _px = 0;
    var _py = 0;
    if (instance_exists(obj_player)) { _px = floor(obj_player.x); _py = floor(obj_player.y); }
    var _zone = _rn;
    if (_rn == "rm_overworld") {
        if (_px >= 2624 && _px <= 2864 && _py >= 2144 && _py <= 2368) _zone = "overworld_camp";
        else if (_py < 2400) _zone = "overworld_old_road";
        else if (_py < 2640) _zone = "overworld_farmlands";
        else _zone = "overworld_greyhaven";
    }
    var _key = string(room) + "|" + _zone + "|" + _stage + "|" + string(scr_flag_get("flag_arrived_greyhaven")) + "|" + string(scr_flag_get("flag_met_tomas")) + "|" + string(scr_flag_get("flag_pendant_found")) + "|" + string(scr_flag_get("flag_bg_intro_seen")) + "|" + string(scr_flag_get("blackguard_defeated"));
    if (variable_global_exists("ch1_quest_key") && global.ch1_quest_key == _key) return;
    global.ch1_quest_key = _key;
    if (_stage == "complete") {
        // The door scene starts Beyond the Veil; a save made at the sealed door can
        // still lack it, so backfill from the chapter-complete flag.
        if (scr_flag_get("flag_chapter1_complete")) scr_quest_advance("Q_MAIN_BEYOND_VEIL", "Q_BV_S1");
        return;
    }

    // Flag backfill: covers existing saves and a scene that was replayed.
    if (scr_flag_get("flag_arrived_greyhaven")) scr_quest_advance(_quest, "Q_FM_S1");
    if (scr_flag_get("flag_met_tomas")) scr_quest_advance(_quest, "Q_FM_S2");
    if (scr_flag_get("flag_pendant_found")) scr_quest_advance(_quest, "Q_FM_S3");

    // Position stages. Coordinates are the marker-table thresholds: Farmlands top y=2640,
    // Old Road top y=2400, bandit camp rect [2624,2144]-[2864,2368]. `_zone` is also the
    // tick cache key, so walking inside one region does not rebuild quest definitions.
    if (_zone == "overworld_farmlands" || _zone == "overworld_old_road" || _zone == "overworld_camp") {
        scr_quest_advance(_quest, "Q_FM_S4");
    }
    if (_zone == "overworld_old_road" || _zone == "overworld_camp") {
        scr_quest_advance(_quest, "Q_FM_S5");
    }
    if (_zone == "overworld_camp") scr_quest_advance(_quest, "Q_FM_S6");
    if (_rn == "rm_old_watchtower") scr_quest_advance(_quest, "Q_FM_S7");
    if (_rn == "rm_watchtower_basement") scr_quest_advance(_quest, "Q_FM_S8");
    if (scr_flag_get("flag_bg_intro_seen")) scr_quest_advance(_quest, "Q_FM_S9");

    if (scr_flag_get("blackguard_defeated")) scr_quest_set(_quest, "complete");
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
    scr_inventory_add("item_blackguards_longsword", "Blackguard's Longsword", 1, true);
    scr_inventory_add("item_crownveil_fragment", "Crownveil Fragment", 1, true);
    scr_quest_set("Q_MAIN_FIND_MIRA", "complete");
    global.game.pending_post_dialogue = ["BG_DEFEAT_01", "BG_DEFEAT_02", "BG_DEFEAT_03", "BG_REWARD_01"];
}
