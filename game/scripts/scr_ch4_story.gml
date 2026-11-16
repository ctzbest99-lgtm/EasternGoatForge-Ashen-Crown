/// scr_ch4_story — Chapter 4 ("The Old Name") story flow. Lines live in
/// scr_dialogue_data_ch4 (generated from docs/story/CHAPTER4_SCRIPT.md, approved Nov 15 2026).
/// This file decides which lines play when, sets the script's flags, runs the sanctuary
/// encounters, the Sanctuary Warden fight, Caelan's join and the handoff to the Blackwood.
///
/// Flags (script): flag_hs_entered, flag_hs_door_seen, flag_sanctuary_entered,
///   flag_aethari_name_learned, flag_caelan_met, flag_caelan_in_battle, flag_caelan_recruited,
///   flag_sw_triggered, flag_sanctuary_warden_beaten, flag_chapter4_complete.
/// Flags (code, bookkeeping): flag_hs_shep_spoke, ch4_save_prompt_pending, quest stages as
///   flags quest_<QUEST_ID> = "<STAGE_ID>" (scr_ch4_quest_set).
///
/// Quests (Q_MAIN_BEYOND_VEIL): Q_BV_S5 Find the Hollow Sanctuary completes when Caelan is
///   recruited and the Aethari name is learned; Q_BV_S6 Investigate the Blackwood Road
///   Garrison opens at the same moment. No side quest in this chapter.

// ------------------------------------------------------------------------------------------------
// Small helpers

function scr_ch4_quest_set(_quest_id, _stage_id) {
    scr_flag_set("quest_" + _quest_id, _stage_id);
}

function scr_ch4_quest_get(_quest_id) {
    var _v = scr_flag_get("quest_" + _quest_id);
    return is_string(_v) ? _v : "";
}

function scr_ch4_room_is(_name) {
    return room_get_name(room) == _name;
}

// ------------------------------------------------------------------------------------------------
// Script dispatch. Called first by scr_dialogue_play_script; returns true if it handled the id.

function scr_ch4_play_script(_sid, _src = noone) {
    switch (_sid) {
        // ---- §1 The approach ----
        case "HS_SIGN_01":
            scr_dialogue_play(["HS_SIGN_01"]);
            return true;
        case "HS_SHEP_01":
            if (scr_flag_get("flag_hs_shep_spoke")) {
                scr_dialogue_play(["HS_SHEP_R1"]);
            } else {
                scr_dialogue_play(["HS_SHEP_01", "HS_SHEP_02", "HS_SHEP_03"], function() {
                    scr_flag_set("flag_hs_shep_spoke");
                });
            }
            return true;

        // ---- §2 The outer door and its inscription ----
        case "HS_DOOR_05":
            scr_ch4_door_scene();
            return true;

        // ---- §3 The hollow halls ----
        case "HS_LORE_01":
            scr_dialogue_play(["HS_LORE_01_01", "HS_LORE_01_02", "HS_LORE_01_03", "HS_LORE_01_04"]);
            return true;
        case "HS_LORE_02":
            scr_dialogue_play(["HS_LORE_02_01", "HS_LORE_02_02", "HS_LORE_02_03"]);
            return true;
        case "HS_LORE_03":
            scr_dialogue_play(["HS_LORE_03_01", "HS_LORE_03_02", "HS_LORE_03_03"]);
            return true;

        // ---- §4 Caelan in the records hall ----
        case "CA_MEET_01":
            scr_ch4_caelan_scene();
            return true;

        // ---- §5 The Sanctuary Warden ----
        case "SW_INTRO":
            scr_ch4_warden_scene();
            return true;
    }
    return false;
}

// ------------------------------------------------------------------------------------------------
// §1 Entry to the hollow (one-shot), §2 the doors

/// HS_ENTER plays on first entry to rm_hollow_approach (scr_ch4_on_room_start).
function scr_ch4_hs_enter() {
    scr_dialogue_play(["HS_ENTER_01", "HS_ENTER_02", "HS_ENTER_03", "HS_ENTER_04", "HS_ENTER_05",
        "HS_ENTER_06"], function() {
        scr_flag_set("flag_hs_entered");
        // Chapter 3 hands off with Q_BV_S5 active; keep that true for a save that skipped the chain.
        var _q = scr_ch4_quest_get("Q_MAIN_BEYOND_VEIL");
        if (_q == "" || _q == "Q_BV_S4" || _q == "Q_BV_S3") {
            scr_ch4_quest_set("Q_MAIN_BEYOND_VEIL", "Q_BV_S5");
        }
    });
}

/// The doors are ajar; the party forces them and reads the old name. Set at the end.
function scr_ch4_door_scene() {
    if (scr_flag_get("flag_sanctuary_entered")) {
        scr_dialogue_play(["HS_DOOR_05", "HS_DOOR_06"]);
        return;
    }
    scr_dialogue_play(["HS_DOOR_01", "HS_DOOR_02", "HS_DOOR_03", "HS_DOOR_04", "HS_DOOR_05",
        "HS_DOOR_06", "HS_DOOR_07", "HS_DOOR_08", "HS_DOOR_09"], function() {
        scr_flag_set("flag_sanctuary_entered");
        scr_flag_set("flag_hs_door_seen");
    });
}

// ------------------------------------------------------------------------------------------------
// §4 Caelan — the meeting and the Aethari reveal (cannot be skipped: SW_INTRO gates on it)

function scr_ch4_caelan_scene() {
    if (scr_flag_get("flag_caelan_recruited")) {
        scr_dialogue_play(["CA_JOIN_R1"]);
        return;
    }
    if (scr_flag_get("flag_caelan_met")) {
        scr_dialogue_play(["CA_MEET_R1"]);
        return;
    }
    if (global.game.dialogue_open) return;
    scr_dialogue_play(["CA_MEET_01", "CA_MEET_02", "CA_MEET_03", "CA_MEET_04", "CA_MEET_05",
        "CA_MEET_06", "CA_MEET_07", "CA_MEET_08", "CA_MEET_09", "CA_MEET_10", "CA_MEET_11",
        "CA_MEET_12", "CA_MEET_13", "CA_MEET_14", "CA_MEET_15", "CA_MEET_16", "CA_MEET_17",
        "CA_MEET_18", "CA_MEET_19", "CA_MEET_20", "CA_MEET_21", "CA_MEET_22", "CA_MEET_23",
        "CA_MEET_24", "CA_MEET_25", "CA_MEET_26"], function() {
        scr_flag_set("flag_aethari_name_learned");
        scr_flag_set("flag_caelan_met");
    });
}

// ------------------------------------------------------------------------------------------------
// §5 The Sanctuary Warden — trigger, fight, defeat. §6 Caelan's join follows the battle.

/// Caelan becomes controllable at the start of the Warden fight (4th slot, at Kael's level).
function scr_ch4_caelan_join() {
    scr_game_state_init();
    if (scr_flag_get("flag_caelan_in_battle")) return false;
    var _c = scr_roster_find(global.game.roster, "caelan");
    if (!is_struct(_c)) return false;
    if (!_c.joined) scr_party_join("caelan");
    var _kael = scr_roster_find(global.game.roster, "kael");
    if (is_struct(_kael) && _c.level < _kael.level) scr_actor_raise_to_level(_c, _kael.level);
    _c.equipment.weapon = "item_spellbook";
    scr_flag_set("flag_caelan_in_battle");
    return true;
}

function scr_ch4_warden_scene() {
    if (scr_flag_get("flag_sanctuary_warden_beaten")) {
        scr_dialogue_play(["SW_DOOR_AFTER"]);
        return;
    }
    if (global.game.battle_active || global.game.transition_active) return;
    if (!scr_flag_get("flag_caelan_met")) {
        scr_dialogue_play(["SW_LOCKED"]);
        return;
    }
    if (scr_flag_get("flag_sw_triggered")) {
        scr_dialogue_play(["SW_INTRO_05"]);
        return;
    }
    var _joined = scr_ch4_caelan_join();
    var _chain = ["SW_INTRO_01", "SW_INTRO_02", "SW_INTRO_03", "SW_INTRO_04", "SW_INTRO_05"];
    if (_joined) array_insert(_chain, 0, "SW_SYS_01"); // Caelan has joined (before the intro)
    scr_dialogue_play(_chain, function() {
        // Do not set flag_sw_triggered here: a defeat must be able to retrigger the fight.
        // The flag is set on victory (scr_ch4_on_battle_finish), which also removes the trigger.
        scr_encounter_start("grp_sanctuary_warden", "enc_sanctuary_warden", "SW_INTRO");
    });
}

/// From scr_battle_finish. A Warden win queues §5.1 and §6 (the join talk), then S5 -> S6.
function scr_ch4_on_battle_finish(_result, _pending) {
    if (!is_struct(_pending) || _result != "victory") return;
    if (!variable_struct_exists(_pending, "encounter_id") || _pending.encounter_id != "enc_sanctuary_warden") return;
    scr_flag_set("flag_sanctuary_warden_beaten");
    scr_flag_set("flag_sw_triggered");
    global.game.pending_post_dialogue = [
        "SW_DEFEAT_01", "SW_DEFEAT_02", "SW_DEFEAT_03", "SW_DEFEAT_04", "SW_DEFEAT_05", "SW_DEFEAT_06",
        "CA_JOIN_01", "CA_JOIN_02", "CA_JOIN_03", "CA_JOIN_04", "CA_JOIN_05", "CA_JOIN_06",
        "CA_JOIN_07", "CA_JOIN_08", "CA_JOIN_09", "CA_JOIN_10", "CA_JOIN_11", "CA_JOIN_12",
        "CA_SYS_01", "CA_SYS_02", "CA_SYS_03", "CA_SYS_04", "CA_SYS_05"
    ];
    global.game.pending_post_callback = function() {
        scr_flag_set("flag_caelan_recruited");
        scr_ch4_quest_set("Q_MAIN_BEYOND_VEIL", "Q_BV_S6"); // S5 completes; S6: the garrison
    };
}

// ------------------------------------------------------------------------------------------------
// §7 Handoff — leaving the sanctuary after the join ends Chapter 4

/// Called from obj_zone_entrance Step (after the Chapter 2/3 exit hooks) for doors with a script_id.
function scr_ch4_exit_script(_door) {
    if (_door == noone || !instance_exists(_door) || !is_struct(_door.map_marker)) return false;
    var _m = _door.map_marker;
    if (!variable_struct_exists(_m, "name")) return false;
    if (_m.name != "to_approach") return false;
    if (!scr_flag_get("flag_caelan_recruited")) return false; // no handoff before the join
    if (scr_flag_get("flag_chapter4_complete")) return false; // afterwards it is a plain door
    var _rm = _door.target_room;
    var _spawn = _door.target_spawn;
    scr_dialogue_play(["HS_HANDOFF_01", "HS_HANDOFF_02", "HS_HANDOFF_03", "HS_HANDOFF_04",
        "HS_HANDOFF_05", "HS_HANDOFF_06"], function() {
        scr_flag_set("flag_chapter4_complete");
        global.game.ch4_save_prompt_pending = true;
        if (_rm != -1 && room_exists(_rm)) {
            global.map_spawn_name = _spawn;
            room_goto(_rm);
        }
    });
    return true;
}

// ------------------------------------------------------------------------------------------------
// Room start + per-step hooks (obj_game_controller)

function scr_ch4_on_room_start() {
    scr_game_state_init();
    var _g = global.game;
    var _rn = room_get_name(room);
    if (variable_struct_exists(_g, "ch4_save_prompt_pending") && _g.ch4_save_prompt_pending) {
        _g.ch4_save_prompt_pending = false;
        // Quiet: saving only exists inside a town's church or tavern (owner decision 2026-11-15).
        scr_save_menu_open("save", false, true);
    }
    // §1: the west-country road into the hollow — one-shot entry scene.
    if (_rn == "rm_hollow_approach" && !scr_flag_get("flag_hs_entered") && !_g.dialogue_open) {
        scr_ch4_hs_enter();
    }
    // §2: the sanctuary itself is entered through the doors (HS_DOOR plays on the approach).
    if (_rn == "rm_hollow_sanctuary" && !scr_flag_get("flag_sanctuary_entered")) {
        scr_flag_set("flag_sanctuary_entered");
    }
}

function scr_ch4_tick() {
    // Nothing per-frame yet: the Chapter 4 beats are room starts, interacts and the boss trigger.
}
