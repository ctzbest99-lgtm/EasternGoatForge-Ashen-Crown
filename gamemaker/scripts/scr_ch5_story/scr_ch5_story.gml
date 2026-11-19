/// scr_ch5_story — Chapter 5 ("The Deserted Oath") story flow. Lines live in
/// scr_dialogue_data_ch5 (generated from docs/story/CHAPTER5_SCRIPT.md, approved Nov 16 2026).
/// This file decides which lines play when, sets the script's flags, runs the gate/yard/records
/// stages, Hailen's yield choice and fight, Sera's join and the Blackwood handoff.
///
/// Flags (script): flag_garrison_entered, flag_bg_gate_seen, flag_bg_yard_seen, flag_sera_met,
///   flag_hailen_intro_seen, flag_hailen_yields (choice), flag_hailen_yielded (engine),
///   flag_hailen_beaten, flag_blackwood_lead, flag_sera_stake_done, flag_sera_recruited,
///   flag_fk_seen_4, flag_chapter5_complete, flag_act2_complete.
/// Flags (code, bookkeeping): ch5_save_prompt_pending, quest stages as flags
///   quest_<QUEST_ID> = "<STAGE_ID>" (scr_ch5_quest_set).
///
/// Quests (Q_MAIN_BEYOND_VEIL): Q_BV_S6 Investigate the Blackwood Road Garrison completes at the
///   treeline, and Q_BV_S7 Follow the trail into the Blackwood opens at the same moment.
///
/// Decisions this file implements (approved 2026-11-16): Sera becomes controllable after the
/// Hailen fight; Hailen's yield is a pre-battle choice on the existing yields_if_flag hook; the
/// party is never "let in" (the sergeant's ledger closes the gate); the lead is the sealed order;
/// the chapter ends at the treeline; two rooms; Sera awaits transport rather than a sentence.

// ------------------------------------------------------------------------------------------------
// Small helpers

function scr_ch5_quest_set(_quest_id, _stage_id) {
    scr_flag_set("quest_" + _quest_id, _stage_id);
}

function scr_ch5_quest_get(_quest_id) {
    var _v = scr_flag_get("quest_" + _quest_id);
    return is_string(_v) ? _v : "";
}

/// Keep Q_BV_S6 active for a save that reached the garrison without the Chapter 4 chain.
function scr_ch5_ensure_quest() {
    var _q = scr_ch5_quest_get("Q_MAIN_BEYOND_VEIL");
    if (_q == "" || _q == "Q_BV_S4" || _q == "Q_BV_S5") {
        scr_ch5_quest_set("Q_MAIN_BEYOND_VEIL", "Q_BV_S6");
    }
}

// ------------------------------------------------------------------------------------------------
// Script dispatch. Called by scr_dialogue_play_script; returns true if it handled the id.

function scr_ch5_play_script(_sid, _src = noone) {
    switch (_sid) {
        // ---- §1 The notice board ----
        case "BG_NOTICE":
            if (scr_flag_get("flag_bg_notice_seen")) {
                scr_dialogue_play(["BG_NOTICE_R1"]);
            } else {
                scr_dialogue_play(["BG_NOTICE_01", "BG_NOTICE_02", "BG_NOTICE_03", "BG_NOTICE_04",
                    "BG_NOTICE_05", "BG_NOTICE_06"], function() {
                    scr_flag_set("flag_bg_notice_seen");
                });
            }
            return true;

        // ---- §2 The gate: the ledger has Taren's name ----
        case "BG_GATE":
            if (scr_flag_get("flag_bg_gate_seen")) {
                scr_dialogue_play(["BG_GATE_R1"]);
            } else {
                scr_dialogue_play(["BG_GATE_01", "BG_GATE_02", "BG_GATE_03", "BG_GATE_04",
                    "BG_GATE_05", "BG_GATE_06", "BG_GATE_07", "BG_GATE_08", "BG_GATE_09",
                    "BG_GATE_10"], function() {
                    scr_flag_set("flag_bg_gate_seen");
                });
            }
            return true;

        // ---- §3 The yard: Sera is brought out of the cells ----
        case "BG_YARD":
            if (scr_flag_get("flag_bg_yard_seen")) {
                scr_dialogue_play(["BG_YARD_R1"]);
            } else {
                scr_dialogue_play(["BG_YARD_01", "BG_YARD_02", "BG_YARD_03", "BG_YARD_04",
                    "BG_YARD_05", "BG_YARD_06", "BG_YARD_07", "BG_YARD_08", "BG_YARD_09",
                    "BG_YARD_10", "BG_YARD_11", "BG_YARD_12", "BG_YARD_13", "BG_YARD_14"],
                    function() {
                        scr_flag_set("flag_bg_yard_seen");
                    });
            }
            return true;

        // ---- §4 Sera: the refusal, and the sealed order she names ----
        case "SR_MEET":
            if (scr_flag_get("flag_sera_met")) {
                scr_dialogue_play(["SR_MEET_R1"]);
            } else {
                scr_dialogue_play(["SR_MEET_01", "SR_MEET_02", "SR_MEET_03", "SR_MEET_04",
                    "SR_MEET_05", "SR_MEET_06", "SR_MEET_07", "SR_MEET_08", "SR_MEET_09",
                    "SR_MEET_10", "SR_MEET_11", "SR_MEET_12", "SR_MEET_13", "SR_MEET_14",
                    "SR_MEET_15", "SR_MEET_16", "SR_MEET_17"], function() {
                    scr_flag_set("flag_sera_met");
                });
            }
            return true;

        // ---- §5-§6 Hailen: the arrest, then the choice ----
        case "HL_INTRO":
            if (scr_flag_get("flag_hailen_beaten")) {
                scr_dialogue_play(["HL_INTRO_R1"]);
                return true;
            }
            if (!scr_flag_get("flag_bg_yard_seen")) {
                scr_dialogue_play(["BG_YARD_R1"]);
                return true;
            }
            // A lost fight must be replayable: the trigger is never consumed on defeat.
            if (scr_flag_get("flag_hailen_intro_seen")) {
                scr_dialogue_play(["HL_INTRO_R1"], function() {
                    scr_ch5_hailen_choice();
                });
                return true;
            }
            scr_ch5_hailen_scene();
            return true;

        // ---- §9 The records room: the sealed order ----
        case "BW_LEAD":
            if (scr_flag_get("flag_blackwood_lead")) {
                scr_dialogue_play(["BW_LEAD_R1"]);
                return true;
            }
            if (!scr_flag_get("flag_hailen_beaten")) {
                scr_dialogue_play(["BG_KEEP_LOCKED"]);
                return true;
            }
            scr_dialogue_play(["BW_LEAD_01", "BW_LEAD_02", "BW_LEAD_03", "BW_LEAD_04",
                "BW_LEAD_05", "BW_LEAD_06", "BW_LEAD_07", "BW_LEAD_08", "BW_LEAD_09",
                "BW_LEAD_10", "BW_LEAD_11"], function() {
                scr_flag_set("flag_blackwood_lead");
            });
            return true;

        // ---- §9.1 Sera's stake: the oath she kept ----
        case "SR_STAKE":
            if (scr_flag_get("flag_sera_stake_done")) {
                scr_dialogue_play(["SR_STAKE_R1"]);
                return true;
            }
            if (!scr_flag_get("flag_blackwood_lead")) {
                scr_dialogue_play(["BW_LEAD_R1"]);
                return true;
            }
            scr_dialogue_play(["SR_STAKE_01", "SR_STAKE_02", "SR_STAKE_03", "SR_STAKE_04",
                "SR_STAKE_05", "SR_STAKE_06", "SR_STAKE_07", "SR_STAKE_08", "SR_STAKE_09"],
                function() {
                    scr_flag_set("flag_sera_stake_done");
                });
            return true;

        // ---- §10 Sera's join: handled at the keep door (scr_ch5_exit_script), not a trigger ----
    }
    return false;
}

// ------------------------------------------------------------------------------------------------
// §1 Entry to the garrison road (one-shot)

/// BG_ENTER plays on first entry to rm_blackwood_garrison (scr_ch5_on_room_start).
function scr_ch5_bg_enter() {
    scr_dialogue_play(["BG_ENTER_01", "BG_ENTER_02", "BG_ENTER_03", "BG_ENTER_04",
        "BG_ENTER_05", "BG_ENTER_06", "BG_ENTER_07"], function() {
        scr_flag_set("flag_garrison_entered");
        scr_ch5_ensure_quest();
    });
}

// ------------------------------------------------------------------------------------------------
// §5-§6 Hailen: the arrest, the pre-battle choice, the fight

/// The choice sets flag_hailen_yields BEFORE initiative: commander_hailen carries
/// yields_if_flag: "flag_hailen_yields", so the battle can only end with him alive if the
/// player picked the first option. The trigger itself is never consumed on defeat, so a lost
/// fight can be replayed (the Chapter 4 lesson).
function scr_ch5_hailen_scene() {
    if (global.game.battle_active || global.game.transition_active) return;
    if (global.game.dialogue_open) return;
    scr_dialogue_play(["HL_INTRO_01", "HL_INTRO_02", "HL_INTRO_03", "HL_INTRO_04",
        "HL_INTRO_05", "HL_INTRO_06", "HL_INTRO_07", "HL_INTRO_08", "HL_INTRO_09",
        "HL_INTRO_10", "HL_INTRO_11", "HL_INTRO_12", "HL_INTRO_13", "HL_INTRO_14",
        "HL_INTRO_15", "HL_INTRO_16", "HL_INTRO_17", "HL_INTRO_18", "HL_INTRO_19"],
        function() {
        scr_flag_set("flag_hailen_intro_seen");
        scr_ch5_hailen_choice();
    });
}

/// The choice itself, split out so a retry after a defeat can reach it directly.
function scr_ch5_hailen_choice() {
    if (global.game.battle_active || global.game.transition_active) return;
    scr_dialogue_play(["HL_CHOICE_01", "HL_CHOICE_02", "HL_CHOICE_03"], function() {
        scr_dialogue_choice(["Your call. Say it plain."], "Kael",
            ["We're not here to kill Crown soldiers.", "He chose this."],
            function(_idx) {
                if (_idx == 0) {
                    scr_flag_set("flag_hailen_yields", true);
                    scr_dialogue_play(["HL_CHOICE_04"], function() {
                        scr_ch5_hailen_fight();
                    });
                } else {
                    // Explicitly cleared, so a reloaded save can never inherit a spare.
                    scr_flag_set("flag_hailen_yields", false);
                    scr_dialogue_play(["HL_CHOICE_05"], function() {
                        scr_ch5_hailen_fight();
                    });
                }
            });
    });
}

function scr_ch5_hailen_fight() {
    if (global.game.battle_active || global.game.transition_active) return;
    scr_dialogue_play(["HL_FIGHT_01", "HL_FIGHT_02"], function() {
        scr_encounter_start("grp_commander_hailen", "enc_commander_hailen", "HL_FIGHT");
    });
}

// ------------------------------------------------------------------------------------------------
// §8 Aftermath: the yield branch and the death branch, both a victory

/// From scr_battle_finish. Queues §8.1 or §8.2, then leaves the keep unlocked.
function scr_ch5_on_battle_finish(_result, _pending) {
    if (!is_struct(_pending) || _result != "victory") return;
    if (!variable_struct_exists(_pending, "encounter_id")) return;
    if (_pending.encounter_id != "enc_commander_hailen") return;
    scr_flag_set("flag_hailen_beaten");
    if (scr_flag_get("flag_hailen_yielded")) {
        global.game.pending_post_dialogue = [
            "HL_YIELD_01", "HL_YIELD_02", "HL_YIELD_03", "HL_YIELD_04", "HL_YIELD_05",
            "HL_YIELD_06", "HL_YIELD_07"
        ];
    } else {
        global.game.pending_post_dialogue = [
            "HL_DEATH_01", "HL_DEATH_02", "HL_DEATH_03", "HL_DEATH_04", "HL_DEATH_05"
        ];
    }
    global.game.pending_post_callback = function() {
        // The records room is now open, and Sera is still in the yard. If he fell, the
        // commander's body is not left standing in the yard as an interactable.
        scr_flag_set("flag_hailen_beaten");
        if (!scr_flag_get("flag_hailen_yielded")) scr_ch5_destroy_marker("hailen");
    };
}

/// Remove a spawned map marker by name (used for NPCs the story has moved on from).
function scr_ch5_destroy_marker(_name) {
    with (obj_interactable) {
        if (is_struct(map_marker) && variable_struct_exists(map_marker, "name")
            && map_marker.name == _name) instance_destroy();
    }
}

// ------------------------------------------------------------------------------------------------
// §10 Sera's join

/// Sera joins after the fight, as the fifth roster member: four active plus one reserve.
/// She joins at Kael's level (the Chapter 4 precedent for Caelan) and takes her holy sword.
function scr_ch5_sera_join() {
    scr_game_state_init();
    if (scr_flag_get("flag_sera_recruited")) return false;
    var _s = scr_roster_find(global.game.roster, "sera");
    if (!is_struct(_s)) return false;
    if (!_s.joined) scr_party_join("sera");
    var _kael = scr_roster_find(global.game.roster, "kael");
    if (is_struct(_kael) && _s.level < _kael.level) scr_actor_raise_to_level(_s, _kael.level);
    _s.equipment.weapon = "item_holy_sword";
    scr_dialogue_play(["SR_JOIN_01", "SR_JOIN_02", "SR_JOIN_03", "SR_JOIN_04", "SR_JOIN_05",
        "SR_JOIN_06", "SR_JOIN_07", "SR_JOIN_08", "SR_JOIN_09", "SR_SYS_01", "SR_SYS_02",
        "SR_SYS_03", "SR_SYS_04"], function() {
        scr_flag_set("flag_sera_recruited");
        // She is in the party now; the prisoner in the cell block is not.
        scr_ch5_destroy_marker("sera_prisoner");
        if (variable_struct_exists(global.game, "ch5_join_door") && global.game.ch5_join_door != noone) {
            var _door = global.game.ch5_join_door;
            global.game.ch5_join_door = noone;
            if (instance_exists(_door) && _door.target_room != -1 && room_exists(_door.target_room)) {
                global.map_spawn_name = _door.target_spawn;
                room_goto(_door.target_room);
            }
        }
    });
    return true;
}

// ------------------------------------------------------------------------------------------------
// Gated doors and the §11 handoff

/// Called from obj_zone_entrance Step for doors with a script_id. Returns true when this
/// chapter handled the door (the door must not move the party).
function scr_ch5_exit_script(_door) {
    if (_door == noone || !instance_exists(_door) || !is_struct(_door.map_marker)) return false;
    var _m = _door.map_marker;
    if (!variable_struct_exists(_m, "name")) return false;

    // The office is barred until the commander is beaten.
    if (_m.name == "to_keep") {
        if (scr_flag_get("flag_hailen_beaten")) return false;
        scr_dialogue_play(["BG_KEEP_LOCKED"]);
        return true;
    }

    // §10: leaving the records room after Sera's stake is where she joins. The scene plays on
    // the doorstep and the door move happens in its callback (the Chapter 4 handoff pattern).
    if (_m.name == "to_yard") {
        if (scr_flag_get("flag_sera_recruited") || !scr_flag_get("flag_sera_stake_done")) return false;
        global.game.ch5_join_door = _door;
        scr_ch5_sera_join();
        return true;
    }

    // §11: the Blackwood treeline. BG_HANDOFF, then the second Fallen Knight sighting.
    if (_m.name != "to_blackwood") return false;
    if (!scr_flag_get("flag_sera_recruited")) {
        scr_dialogue_play(["CH5_HANDOFF_LOCKED"]);
        return true;
    }
    if (scr_flag_get("flag_chapter5_complete")) return false; // afterwards it enters rm_blackwood_deep
    scr_dialogue_play(["BG_HANDOFF_01", "BG_HANDOFF_02", "BG_HANDOFF_03", "BG_HANDOFF_04",
        "BG_HANDOFF_05", "BG_HANDOFF_06", "BG_HANDOFF_07", "BG_HANDOFF_08",
        "FK4_01", "FK4_02", "FK4_03", "FK4_04", "FK4_05"], function() {
        scr_flag_set("flag_fk_seen_4");
        scr_flag_set("flag_chapter5_complete");
        scr_flag_set("flag_act2_complete");
        scr_ch5_quest_set("Q_MAIN_BEYOND_VEIL", "Q_BV_S7"); // S6 completes; S7: the Blackwood
        global.game.ch5_save_prompt_pending = true;
    });
    return true;
}

// ------------------------------------------------------------------------------------------------
// Room start + per-step hooks (obj_game_controller)

function scr_ch5_on_room_start() {
    scr_game_state_init();
    var _g = global.game;
    var _rn = room_get_name(room);
    if (variable_struct_exists(_g, "ch5_save_prompt_pending") && _g.ch5_save_prompt_pending) {
        _g.ch5_save_prompt_pending = false;
        // Quiet: saving only exists inside a town's church or tavern (owner decision 2026-11-15).
        scr_save_menu_open("save", false, true);
    }
    if (_rn == "rm_blackwood_garrison" && !scr_flag_get("flag_garrison_entered") && !_g.dialogue_open) {
        scr_ch5_bg_enter();
    }
}

function scr_ch5_tick() {
    // Nothing per-frame: the Chapter 5 beats are room starts, interacts, and the boss trigger.
}
