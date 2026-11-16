/// scr_ch8_story — Chapter 8 ("The Door in the Wood") story flow, and the end of Act III.
/// Lines live in scr_dialogue_data_ch8 (generated from docs/story/CHAPTER8_SCRIPT.md, built
/// Nov 16 2026 from the approved Act III outline).
///
/// Flags (script): ch8_entered, ch8_sentinels_seen, ch8_warden_defeated, ch8_boss_started,
///   ch8_boss_cool, ch8_pendant_answered, chapter8_complete, flag_act3_complete.
/// Quests: Q_MAIN_BLACKWOOD stages Q_MBW_S5 (entry) and Q_MBW_S6 (the pendant scene). The
///   quest stays open at S6 — the party has learned nothing conclusive.
///
/// The outline's decisions 6, 7 and 9 are implemented as recommended: the door does not open,
/// the Fallen Knight never appears, and the act ends on the doors with the act card. The
/// clearing has one scripted fight and no random encounters.

function scr_ch8_quest_set(_quest_id, _stage_id) {
    scr_flag_set("quest_" + _quest_id, _stage_id);
}

function scr_ch8_play_script(_sid, _src = noone) {
    switch (_sid) {
        // ---- §1.1 The sentinels (inspect only) ----
        case "DW_SENT":
            if (scr_flag_get("ch8_sentinels_seen")) {
                scr_dialogue_play(["DW_SENT_R1"]);
            } else {
                scr_dialogue_play(["DW_SENT_01", "DW_SENT_02", "DW_SENT_03"], function() {
                    scr_flag_set("ch8_sentinels_seen");
                });
            }
            return true;

        // ---- §2 The Warden ----
        case "DW_INTRO":
            scr_ch8_warden_fight();
            return true;
    }
    return false;
}

function scr_ch8_open() {
    if (global.game.dialogue_open || global.game.battle_active) return;
    scr_dialogue_play(["DW_ARRIVE_01", "DW_ARRIVE_02", "DW_ARRIVE_03", "DW_ARRIVE_04",
        "DW_ARRIVE_05"], function() {
        scr_flag_set("ch8_entered");
        scr_ch8_quest_set("Q_MAIN_BLACKWOOD", "Q_MBW_S5");
    });
}

function scr_ch8_warden_scene() {
    if (global.game.battle_active || global.game.transition_active || global.game.dialogue_open) return;
    scr_flag_set("ch8_boss_started");
    scr_dialogue_play(["DW_INTRO_01", "DW_INTRO_02", "DW_INTRO_03", "DW_INTRO_04",
        "DW_INTRO_05"], function() {
        scr_ch8_warden_fight();
    });
}

function scr_ch8_warden_fight() {
    if (global.game.battle_active || global.game.transition_active) return;
    scr_dialogue_play(["DW_FIGHT_01", "DW_FIGHT_02"], function() {
        scr_encounter_start("grp_door_warden_boss", "enc_door_warden_boss", "DW_INTRO");
    });
}

function scr_ch8_on_battle_finish(_result, _pending) {
    if (!is_struct(_pending) || !variable_struct_exists(_pending, "encounter_id")) return;
    if (_pending.encounter_id != "enc_door_warden_boss") return;
    if (_result != "victory") {
        scr_flag_set("ch8_boss_started", false);
        scr_flag_set("ch8_boss_cool", true);
        return;
    }
    scr_flag_set("ch8_boss_started", false);
    scr_flag_set("ch8_warden_defeated");
    global.game.pending_post_dialogue = ["DW_AFTER_01", "DW_AFTER_02", "DW_AFTER_03", "DW_AFTER_04"];
}

// ------------------------------------------------------------------------------------------------
// §3-§4 The pendant scene, and the act card. This is the act's question and it answers nothing:
// the mark answers the mark, the seam lights, something on the far side says one sound, silence.

function scr_ch8_pendant_scene() {
    if (global.game.dialogue_open || global.game.battle_active) return;
    if (scr_flag_get("ch8_pendant_answered")) return;
    if (!scr_flag_get("ch8_warden_defeated")) return;
    scr_dialogue_play(["PD_SCENE_01", "PD_SCENE_02", "PD_SCENE_03", "PD_SCENE_04",
        "PD_SCENE_05", "PD_SCENE_06", "PD_SCENE_07", "PD_SCENE_08", "PD_SCENE_09",
        "PD_SCENE_10", "PD_SCENE_11"], function() {
        scr_flag_set("ch8_pendant_answered");
        scr_ch8_quest_set("Q_MAIN_BLACKWOOD", "Q_MBW_S6");
        scr_flag_set("chapter8_complete");
        scr_flag_set("flag_act3_complete");
        scr_dialogue_play(["ACT3_END_01", "ACT3_END_02", "ACT3_END_03"]);
    });
}

// ------------------------------------------------------------------------------------------------
// Room start + per-step hooks

function scr_ch8_on_room_start() {
    scr_game_state_init();
    var _g = global.game;
    if (room_get_name(room) != "rm_blackwood_doors") return;
    if (!scr_flag_get("ch8_entered") && !_g.dialogue_open) {
        scr_ch8_open();
        return;
    }
    // A save that reached the clearing with the Warden already down still gets the scene.
    if (scr_flag_get("ch8_warden_defeated") && !scr_flag_get("ch8_pendant_answered")) {
        scr_ch8_pendant_scene();
    }
}

function scr_ch8_tick() {
    if (room_get_name(room) != "rm_blackwood_doors") return;
    var _g = global.game;
    if (_g.battle_active || _g.dialogue_open || _g.transition_active) return;
    if (!instance_exists(obj_player)) return;
    var _p = instance_find(obj_player, 0);

    if (_p.y > 224 && scr_flag_get("ch8_boss_cool")) scr_flag_set("ch8_boss_cool", false);

    if (!scr_flag_get("ch8_warden_defeated")) {
        if (scr_flag_get("ch8_boss_started") || scr_flag_get("ch8_boss_cool")) return;
        if (_p.y > 144) return; // the Warden holds the opening; the litter is safe
        scr_ch8_warden_scene();
        return;
    }
    // The threshold itself: walking up to the seam starts the pendant scene.
    if (!scr_flag_get("ch8_pendant_answered") && _p.y < 96) scr_ch8_pendant_scene();
}
