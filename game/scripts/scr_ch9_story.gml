/// scr_ch9_story — Chapter 9 ("The Crown's Ledger") story flow, and the start of Act IV.
/// Lines live in scr_dialogue_data_ch9 (generated from docs/story/CHAPTER9_SCRIPT.md, written
/// Nov 16 2026 to the approved Act IV decisions and the shipped enemy data).
///
/// Flags (script): ch9_entered, ch9_town_seen, ch9_board_read, ch9_ledger_seen, ch9_vell_fight,
///   ch9_vell_yielded, ch9_page_taken, ch9_page_copied, ch9_page_kept, ch9_shop_discount,
///   ch9_alden_met, ch9_alden_pact, chapter9_complete.
/// Quests: Q_MAIN_BLACKWOOD is set complete on entry (Act III is over); Q_MAIN_CROWN opens at
///   Q_MC_S1 and moves to Q_MC_S2 when Vell yields; Q_SIDE_LEDGER opens at Nessa's scene and
///   closes on her choice.
///
/// The chapter's one choice is Nessa's copy of the page. Neither branch is marked right and
/// neither touches the main quest, as with the tithe in Chapter 7.
///
/// Recorded deviations:
/// - `ch9_shop_discount` is read by `scr_shop_buy_price` (10% off, [PROPOSED] percentage,
///   applies at every shop until Coleford has one of its own).
/// - The south exit targets `rm_barrow_gate`, which Chapter 10 will build. Until then the exit
///   script plays the chapter's end scene and the engine's own "[rm_barrow_gate is not built
///   yet.]" line after it.

function scr_ch9_quest_set(_quest_id, _stage_id) {
    scr_flag_set("quest_" + _quest_id, _stage_id);
}

// ------------------------------------------------------------------------------------------------
// Script dispatch (markers carry these ids)

function scr_ch9_play_script(_sid, _src = noone) {
    switch (_sid) {
        // ---- §2.1 The levy board (optional) ----
        case "TN_BOARD":
            if (scr_flag_get("ch9_board_read")) {
                scr_dialogue_play(["TN_BOARD_R1"]);
            } else {
                scr_dialogue_play(["TN_BOARD_01", "TN_BOARD_02", "TN_BOARD_03"], function() {
                    scr_flag_set("ch9_board_read");
                });
            }
            return true;

        // ---- §3-§5 Vell, the ledger, the fight and the page ----
        case "VG_MEET":
            if (scr_flag_get("ch9_page_taken")) {
                scr_dialogue_play(["VG_MEET_R1"]);
                return true;
            }
            if (scr_flag_get("ch9_vell_fight")) {
                scr_ch9_vell_fight();
                return true;
            }
            scr_ch9_vell_scene();
            return true;

        // ---- §6 Nessa's copy ----
        case "CL_CHOICE":
            if (!scr_flag_get("ch9_page_taken")) {
                scr_dialogue_play(["CL_WAIT_01", "CL_WAIT_02"]);
                return true;
            }
            if (scr_quest_is_complete("Q_SIDE_LEDGER")) {
                scr_dialogue_play(["CL_CHOICE_R1"]);
                return true;
            }
            scr_ch9_nessa_choice();
            return true;

        // ---- §7 Alden ----
        case "AL_MEET":
            if (!scr_flag_get("ch9_page_taken")) {
                scr_dialogue_play(["AL_WAIT_01", "AL_WAIT_02"]);
                return true;
            }
            if (scr_flag_get("ch9_alden_pact")) {
                scr_dialogue_play(["AL_MEET_R1"]);
                return true;
            }
            scr_ch9_alden_scene();
            return true;
    }
    return false;
}

// ------------------------------------------------------------------------------------------------
// §1-§2 Entry: out of the wood, into Coleford

function scr_ch9_open() {
    if (global.game.dialogue_open || global.game.battle_active) return;
    scr_dialogue_play(["TN_ROAD_01", "TN_ROAD_02", "TN_ROAD_03", "TN_ROAD_04",
        "TN_ROAD_05", "TN_ROAD_06", "TN_ROAD_07", "TN_ROAD_08", "TN_ROAD_09"], function() {
        scr_flag_set("ch9_entered");
        scr_flag_set("ch9_town_seen");
        // Act III's main quest closes where the act card left it (S6).
        if (scr_quest_is_started("Q_MAIN_BLACKWOOD") && !scr_quest_is_complete("Q_MAIN_BLACKWOOD")) {
            scr_ch9_quest_set("Q_MAIN_BLACKWOOD", "complete");
        }
        scr_ch9_quest_set("Q_MAIN_CROWN", "Q_MC_S1");
    });
}

// ------------------------------------------------------------------------------------------------
// §3-§4 The ledger house, and the magistrate's guard

function scr_ch9_vell_scene() {
    if (global.game.battle_active || global.game.transition_active || global.game.dialogue_open) return;
    scr_dialogue_play(["VG_MEET_01", "VG_MEET_02", "VG_MEET_03", "VG_MEET_04", "VG_MEET_05",
        "VG_MEET_06", "VG_MEET_07", "VG_MEET_08", "VG_MEET_09", "VG_MEET_10", "VG_MEET_11",
        "VG_MEET_12", "VG_MEET_13", "VG_MEET_14", "VG_MEET_15", "VG_MEET_16"], function() {
        scr_flag_set("ch9_ledger_seen");
        scr_ch9_vell_fight();
    });
}

function scr_ch9_vell_fight() {
    if (global.game.battle_active || global.game.transition_active) return;
    scr_dialogue_play(["VG_FIGHT_01", "VG_FIGHT_02", "VG_FIGHT_03", "VG_FIGHT_04", "VG_FIGHT_05"],
        function() {
            scr_encounter_start("grp_magistrate_vell", "enc_magistrate_vell", "VG_MEET");
        });
}

function scr_ch9_on_battle_finish(_result, _pending) {
    if (!is_struct(_pending) || !variable_struct_exists(_pending, "encounter_id")) return;
    if (_pending.encounter_id != "enc_magistrate_vell") return;
    scr_flag_set("ch9_vell_fight");
    if (_result != "victory") {
        // Lost fights are replayable: he is still at the ledger house door.
        return;
    }
    scr_flag_set("ch9_vell_yielded");
    scr_flag_set("ch9_page_taken");
    scr_ch9_quest_set("Q_MAIN_CROWN", "Q_MC_S2");
    scr_ch9_quest_set("Q_SIDE_LEDGER", "Q_SL_S1");
    global.game.pending_post_dialogue = [
        "VG_YIELD_01", "VG_YIELD_02", "VG_YIELD_03",
        "VG_PAGE_01", "VG_PAGE_02", "VG_PAGE_03", "VG_PAGE_04", "VG_PAGE_05", "VG_PAGE_06",
        "VG_PAGE_07", "VG_PAGE_08", "VG_PAGE_09", "VG_PAGE_10", "VG_PAGE_11"
    ];
}

// ------------------------------------------------------------------------------------------------
// §6.1 / §6.2 Nessa's copy: the chapter's one choice

function scr_ch9_nessa_choice() {
    if (global.game.battle_active || global.game.transition_active) return;
    scr_dialogue_play(["CL_CHOICE_01", "CL_CHOICE_02", "CL_CHOICE_03", "CL_CHOICE_04"], function() {
        scr_dialogue_choice(["Your call, Nessa. Say it and we'll do it."], "Kael",
            ["Copy it. An hour.", "No. The page doesn't leave our hands."],
            function(_idx) {
                if (_idx == 0) {
                    scr_flag_set("ch9_page_copied");
                    // Read by scr_shop_buy_price: 10% off at every shop (see the header).
                    scr_flag_set("ch9_shop_discount");
                    scr_dialogue_play(["CL_COPY_01", "CL_COPY_02", "CL_COPY_03", "CL_COPY_04"],
                        function() {
                            scr_ch9_quest_set("Q_SIDE_LEDGER", "complete");
                        });
                } else {
                    scr_flag_set("ch9_page_kept");
                    scr_dialogue_play(["CL_TAKE_01", "CL_TAKE_02", "CL_TAKE_03", "CL_TAKE_04"],
                        function() {
                            scr_ch9_quest_set("Q_SIDE_LEDGER", "complete");
                        });
                }
            });
    });
}

// ------------------------------------------------------------------------------------------------
// §7 Alden Marr: sincere, useful, and the first time anyone says "legitimacy" out loud

function scr_ch9_alden_scene() {
    if (global.game.battle_active || global.game.transition_active || global.game.dialogue_open) return;
    scr_dialogue_play(["AL_MEET_01", "AL_MEET_02", "AL_MEET_03", "AL_MEET_04", "AL_MEET_05",
        "AL_MEET_06", "AL_MEET_07", "AL_MEET_08", "AL_MEET_09", "AL_MEET_10", "AL_MEET_11",
        "AL_MEET_12", "AL_MEET_13", "AL_MEET_14", "AL_MEET_15", "AL_MEET_16", "AL_MEET_17",
        "AL_MEET_18", "AL_MEET_19", "AL_MEET_20", "AL_MEET_21"], function() {
        scr_flag_set("ch9_alden_met");
        scr_flag_set("ch9_alden_pact");
    });
}

// ------------------------------------------------------------------------------------------------
// §8 The road south, and the chapter card

function scr_ch9_end_scene() {
    if (global.game.dialogue_open || global.game.battle_active) return;
    scr_dialogue_play(["CH9_END_01", "CH9_END_02", "CH9_END_03", "CH9_END_04", "CH9_END_05",
        "CH9_END_06", "CH9_END_07", "CH9_END_08", "CH9_END_09"], function() {
        scr_flag_set("chapter9_complete");
    });
}

/// Exit script for the town's south road (obj_zone_entrance calls this before moving rooms).
/// Chapter 10 does not exist yet, so this returns true — blocking the move — every time.
function scr_ch9_exit_script(_door) {
    if (_door == noone || !instance_exists(_door) || !is_struct(_door.map_marker)) return false;
    var _m = _door.map_marker;
    if (!variable_struct_exists(_m, "name") || _m.name != "to_barrow") return false;

    if (!scr_flag_get("ch9_page_taken")) {
        scr_dialogue_play(["CH9_ROAD_01", "CH9_ROAD_02", "CH9_ROAD_03"]);
        return true;
    }
    if (!scr_flag_get("chapter9_complete")) {
        scr_ch9_end_scene();
        return true;
    }
    // Past this point the engine reports that rm_barrow_gate is not built yet — by design.
    return false;
}

// ------------------------------------------------------------------------------------------------
// Room start

function scr_ch9_on_room_start() {
    scr_game_state_init();
    var _g = global.game;
    if (room_get_name(room) != "rm_town") return;
    if (!scr_flag_get("ch9_entered") && !_g.dialogue_open) {
        scr_ch9_open();
    }
}
