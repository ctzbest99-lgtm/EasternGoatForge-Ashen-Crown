/// scr_ch10_story — Chapter 10 ("The Barrow Road") story flow.
/// Lines live in scr_dialogue_data_ch10 (generated from docs/story/CHAPTER10_SCRIPT.md, written
/// Nov 16 2026 to the approved Act IV outline and the shipped enemy data).
///
/// Flags (script): ch10_entered, ch10_post_seen, ch10_gate_seen, ch10_warden_fight,
///   ch10_fight_started, ch10_boss_cool, ch10_warden_defeated, chapter10_complete.
/// Quests: Q_MAIN_CROWN stages Q_MC_S3 (entry) and Q_MC_S4 (Warden defeated). S5-S6 are defined
///   in scr_quest_data.gml for Chapter 11.
///
/// The boss gate is a per-frame check (scr_ch10_tick) rather than a map trigger, so a lost fight
/// is replayable: the party walks back south of the forecourt and the gate re-arms.
///
/// Recorded deviations:
/// - Alden does not occupy a battle slot; the engine has no ally slot. His part is scripted.
/// - The outline's "physical resistance in phase two" ships as a DEF buff, because the battle
///   system has no damage-type resistance.
/// - The north exit targets `rm_barrow_halls`, which Chapter 11 will build. The exit script plays
///   the chapter's end scene and then lets the engine report the room is not built yet.

function scr_ch10_quest_set(_quest_id, _stage_id) {
    scr_flag_set("quest_" + _quest_id, _stage_id);
}

// ------------------------------------------------------------------------------------------------
// Script dispatch

function scr_ch10_play_script(_sid, _src = noone) {
    switch (_sid) {
        // ---- §1.1 The overwritten survey post (optional) ----
        case "SP_POST":
            if (scr_flag_get("ch10_post_seen")) {
                scr_dialogue_play(["SP_POST_R1"]);
            } else {
                scr_dialogue_play(["SP_POST_01", "SP_POST_02", "SP_POST_03"], function() {
                    scr_flag_set("ch10_post_seen");
                });
            }
            return true;
    }
    return false;
}

// ------------------------------------------------------------------------------------------------
// §1 The road the survey paid for

function scr_ch10_open() {
    if (global.game.dialogue_open || global.game.battle_active) return;
    scr_dialogue_play(["RG_ARRIVE_01", "RG_ARRIVE_02", "RG_ARRIVE_03", "RG_ARRIVE_04",
        "RG_ARRIVE_05", "RG_ARRIVE_06", "RG_ARRIVE_07"], function() {
        scr_flag_set("ch10_entered");
        scr_ch10_quest_set("Q_MAIN_CROWN", "Q_MC_S3");
    });
}

// ------------------------------------------------------------------------------------------------
// §2-§3 The gatehouse, and the thing behind it

function scr_ch10_gate_scene() {
    if (global.game.battle_active || global.game.transition_active || global.game.dialogue_open) return;
    if (scr_flag_get("ch10_gate_seen")) return;
    scr_flag_set("ch10_gate_seen");
    scr_dialogue_play(["RG_GATE_01", "RG_GATE_02", "RG_GATE_03", "RG_GATE_04", "RG_GATE_05",
        "RG_GATE_06", "RG_GATE_07", "RG_GATE_08", "RG_GATE_09", "RG_GATE_10"], function() {
        scr_ch10_warden_scene();
    });
}

function scr_ch10_warden_scene() {
    if (global.game.battle_active || global.game.transition_active || global.game.dialogue_open) return;
    if (scr_flag_get("ch10_warden_defeated")) return;
    scr_flag_set("ch10_fight_started");
    var _lines = scr_flag_get("ch10_warden_fight")
        ? ["BW_RETRY_01", "BW_INTRO_04", "BW_INTRO_05", "BW_INTRO_06"]
        : ["BW_INTRO_01", "BW_INTRO_02", "BW_INTRO_03", "BW_INTRO_04", "BW_INTRO_05",
           "BW_INTRO_06", "BW_INTRO_07"];
    scr_dialogue_play(_lines, function() {
        scr_ch10_warden_fight();
    });
}

function scr_ch10_warden_fight() {
    if (global.game.battle_active || global.game.transition_active) return;
    scr_flag_set("ch10_warden_fight");
    scr_encounter_start("grp_barrow_warden", "enc_barrow_warden", "BW_INTRO");
}

function scr_ch10_on_battle_finish(_result, _pending) {
    if (!is_struct(_pending) || !variable_struct_exists(_pending, "encounter_id")) return;
    if (_pending.encounter_id != "enc_barrow_warden") return;
    scr_flag_set("ch10_fight_started", false);
    if (_result != "victory") {
        scr_flag_set("ch10_boss_cool", true);
        return;
    }
    scr_flag_set("ch10_warden_defeated");
    scr_ch10_quest_set("Q_MAIN_CROWN", "Q_MC_S4");
    global.game.pending_post_dialogue = [
        "BW_AFTER_01", "BW_AFTER_02", "BW_AFTER_03", "BW_AFTER_04", "BW_AFTER_05",
        "BW_AFTER_06", "BW_AFTER_07", "BW_AFTER_08"
    ];
}

// ------------------------------------------------------------------------------------------------
// §4 The steps, and the chapter card

function scr_ch10_end_scene() {
    if (global.game.dialogue_open || global.game.battle_active) return;
    scr_dialogue_play(["CH10_END_01", "CH10_END_02", "CH10_END_03", "CH10_END_04", "CH10_END_05",
        "CH10_END_06", "CH10_END_07", "CH10_END_08", "CH10_END_09"], function() {
        scr_flag_set("chapter10_complete");
    });
}

/// Exit script for the steps beyond the gate (obj_zone_entrance calls this before moving rooms).
function scr_ch10_exit_script(_door) {
    if (_door == noone || !instance_exists(_door) || !is_struct(_door.map_marker)) return false;
    var _m = _door.map_marker;
    if (!variable_struct_exists(_m, "name") || _m.name != "to_halls") return false;

    if (!scr_flag_get("ch10_warden_defeated")) {
        scr_dialogue_play(["CH10_LOCKED"]);
        return true;
    }
    if (!scr_flag_get("chapter10_complete")) {
        scr_ch10_end_scene();
        return true;
    }
    // Past this point the engine reports that rm_barrow_halls is not built yet — by design.
    return false;
}

// ------------------------------------------------------------------------------------------------
// Room start + per-frame gate

function scr_ch10_on_room_start() {
    scr_game_state_init();
    var _g = global.game;
    if (room_get_name(room) != "rm_barrow_gate") return;
    if (!scr_flag_get("ch10_entered") && !_g.dialogue_open) {
        scr_ch10_open();
    }
}

function scr_ch10_tick() {
    if (room_get_name(room) != "rm_barrow_gate") return;
    var _g = global.game;
    if (_g.battle_active || _g.dialogue_open || _g.transition_active) return;
    if (!instance_exists(obj_player)) return;
    var _p = instance_find(obj_player, 0);

    // Walking back down the road re-arms a lost fight.
    if (_p.y > 240 && scr_flag_get("ch10_boss_cool")) {
        scr_flag_set("ch10_boss_cool", false);
        scr_flag_set("ch10_fight_started", false);
    }

    if (!scr_flag_get("ch10_gate_seen")) {
        if (_p.y < 192) scr_ch10_gate_scene();
        return;
    }
    if (!scr_flag_get("ch10_warden_defeated")) {
        if (scr_flag_get("ch10_fight_started") || scr_flag_get("ch10_boss_cool")) return;
        if (_p.y < 176) scr_ch10_warden_scene();
    }
}
