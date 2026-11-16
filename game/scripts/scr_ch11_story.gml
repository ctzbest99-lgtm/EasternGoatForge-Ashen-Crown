/// scr_ch11_story — Chapter 11 ("The Forgotten King") story flow, and the end of Act IV.
/// Lines live in scr_dialogue_data_ch11 (generated from docs/story/CHAPTER11_SCRIPT.md, written
/// Nov 16 2026 to the approved Act IV outline and the shipped enemy data).
///
/// Flags (script): ch11_entered, ch11_names_seen, ch11_niche_seen, fd_entered,
///   ch11_charter_read, ch11_king_fight, ch11_boss_cool, ch11_king_defeated,
///   ch11_seal_alden, ch11_seal_party, chapter11_complete, flag_act4_complete.
/// Quests: Q_MAIN_CROWN stages Q_MC_S5 (halls entry) and Q_MC_S6 (the King's defeat), then
///   complete once the seal choice resolves.
///
/// The seal is the act's only branch and it states no consequence: `ch11_seal_alden` and
/// `ch11_seal_party` are the whole outcome. Nothing reads them yet, and Act V owns whatever
/// follows. The mark's name is [PROPOSED] and lives in one line of the dialogue data.
///
/// Recorded deviations:
/// - The King has two mechanical phases. The outline's third phase is the §5 beat — the oath
///   letting go — because scr_battle supports a single shift.
/// - Alden is not in the battle line: there is no ally slot.

function scr_ch11_quest_set(_quest_id, _stage_id) {
    scr_flag_set("quest_" + _quest_id, _stage_id);
}

// ------------------------------------------------------------------------------------------------
// Script dispatch

function scr_ch11_play_script(_sid, _src = noone) {
    switch (_sid) {
        // ---- §1.1 The struck names (optional) ----
        case "BH_NAMES":
            if (scr_flag_get("ch11_names_seen")) {
                scr_dialogue_play(["BH_NAMES_R1"]);
            } else {
                scr_dialogue_play(["BH_NAMES_01", "BH_NAMES_02", "BH_NAMES_03"], function() {
                    scr_flag_set("ch11_names_seen");
                });
            }
            return true;

        // ---- §1.2 The grave goods (optional) ----
        case "BH_NICHE":
            if (scr_flag_get("ch11_niche_seen")) {
                scr_dialogue_play(["BH_NICHE_R1"]);
            } else {
                scr_dialogue_play(["BH_NICHE_01", "BH_NICHE_02", "BH_NICHE_03"], function() {
                    scr_flag_set("ch11_niche_seen");
                });
            }
            return true;

        // ---- §3-§4 The charter, the name, and the keeper ----
        case "BK_CHARTER":
            if (scr_flag_get("ch11_charter_read")) {
                scr_dialogue_play(["FD_CHARTER_R1"]);
                return true;
            }
            scr_ch11_charter_scene();
            return true;
    }
    return false;
}

// ------------------------------------------------------------------------------------------------
// §1 The halls

function scr_ch11_open_halls() {
    if (global.game.dialogue_open || global.game.battle_active) return;
    scr_dialogue_play(["BH_ARRIVE_01", "BH_ARRIVE_02", "BH_ARRIVE_03", "BH_ARRIVE_04",
        "BH_ARRIVE_05", "BH_ARRIVE_06", "BH_ARRIVE_07", "BH_ARRIVE_08", "BH_ARRIVE_09",
        "BH_ARRIVE_10"], function() {
        scr_flag_set("ch11_entered");
        scr_ch11_quest_set("Q_MAIN_CROWN", "Q_MC_S5");
    });
}

// ------------------------------------------------------------------------------------------------
// §2 The last chamber

function scr_ch11_open_deep() {
    if (global.game.dialogue_open || global.game.battle_active) return;
    if (scr_flag_get("fd_entered")) return;
    scr_dialogue_play(["FD_ARRIVE_01", "FD_ARRIVE_02", "FD_ARRIVE_03", "FD_ARRIVE_04",
        "FD_ARRIVE_05", "FD_ARRIVE_06", "FD_ARRIVE_07", "FD_ARRIVE_08"], function() {
        scr_flag_set("fd_entered");
    });
}

// ------------------------------------------------------------------------------------------------
// §3-§4 The charter names the mark, and the tomb answers

function scr_ch11_charter_scene() {
    if (global.game.dialogue_open || global.game.battle_active || global.game.transition_active) return;
    scr_dialogue_play(["BK_CHARTER_01", "BK_CHARTER_02", "BK_CHARTER_03", "BK_CHARTER_04",
        "BK_CHARTER_05", "BK_CHARTER_06", "BK_CHARTER_07", "BK_CHARTER_08", "BK_CHARTER_09",
        "BK_CHARTER_10", "BK_CHARTER_11", "BK_CHARTER_12", "BK_CHARTER_13", "BK_CHARTER_14"],
        function() {
            scr_flag_set("ch11_charter_read");
            scr_ch11_king_scene();
        });
}

function scr_ch11_king_scene() {
    if (global.game.battle_active || global.game.transition_active || global.game.dialogue_open) return;
    if (scr_flag_get("ch11_king_defeated")) return;
    var _lines = scr_flag_get("ch11_king_fight")
        ? ["FK_RETRY_01", "FK_INTRO_03", "FK_INTRO_04", "FK_INTRO_05", "FK_INTRO_06"]
        : ["FK_INTRO_01", "FK_INTRO_02", "FK_INTRO_03", "FK_INTRO_04", "FK_INTRO_05",
           "FK_INTRO_06"];
    scr_dialogue_play(_lines, function() {
        scr_ch11_king_fight();
    });
}

function scr_ch11_king_fight() {
    if (global.game.battle_active || global.game.transition_active) return;
    scr_flag_set("ch11_king_fight");
    scr_encounter_start("grp_forgotten_king", "enc_forgotten_king", "BK_CHARTER");
}

function scr_ch11_on_battle_finish(_result, _pending) {
    if (!is_struct(_pending) || !variable_struct_exists(_pending, "encounter_id")) return;
    if (_pending.encounter_id != "enc_forgotten_king") return;
    if (_result != "victory") {
        scr_flag_set("ch11_boss_cool", true);
        return;
    }
    scr_flag_set("ch11_king_defeated");
    scr_ch11_quest_set("Q_MAIN_CROWN", "Q_MC_S6");
    global.game.pending_post_dialogue = [
        "FK_AFTER_01", "FK_AFTER_02", "FK_AFTER_03", "FK_AFTER_04", "FK_AFTER_05",
        "FK_AFTER_06", "FK_AFTER_07", "FK_AFTER_08", "FK_AFTER_09", "FK_AFTER_10", "FK_AFTER_11"
    ];
}

// ------------------------------------------------------------------------------------------------
// §6 The seal: the act's only branch, with no correct answer

function scr_ch11_seal_choice() {
    if (global.game.battle_active || global.game.transition_active || global.game.dialogue_open) return;
    if (scr_flag_get("ch11_choice_made")) return;
    scr_dialogue_play(["SL_CHOICE_01", "SL_CHOICE_02", "SL_CHOICE_03", "SL_CHOICE_04",
        "SL_CHOICE_05"], function() {
        scr_dialogue_choice(["It has to be decided now."], "",
            ["Let Alden carry it.", "No. It stays with us."],
            function(_idx) {
                if (_idx == 0) {
                    scr_flag_set("ch11_seal_alden");
                    scr_dialogue_play(["SL_ALDEN_01", "SL_ALDEN_02", "SL_ALDEN_03", "SL_ALDEN_04",
                        "SL_ALDEN_05", "SL_ALDEN_06"], function() {
                        scr_ch11_act_end();
                    });
                } else {
                    scr_flag_set("ch11_seal_party");
                    scr_dialogue_play(["SL_PARTY_01", "SL_PARTY_02", "SL_PARTY_03", "SL_PARTY_04",
                        "SL_PARTY_05"], function() {
                        scr_ch11_act_end();
                    });
                }
            });
    });
}

// ------------------------------------------------------------------------------------------------
// §6.3 The act card

function scr_ch11_act_end() {
    scr_flag_set("ch11_choice_made");
    scr_ch11_quest_set("Q_MAIN_CROWN", "complete");
    scr_dialogue_play(["ACT4_END_01", "ACT4_END_02", "ACT4_END_03", "ACT4_END_04", "ACT4_END_05",
        "ACT4_END_06"], function() {
        scr_flag_set("chapter11_complete");
        scr_flag_set("flag_act4_complete");
    });
}

// ------------------------------------------------------------------------------------------------
// Room start + per-frame beats

function scr_ch11_on_room_start() {
    scr_game_state_init();
    var _g = global.game;
    var _name = room_get_name(room);

    if (_name == "rm_barrow_halls") {
        if (!scr_flag_get("ch11_entered") && !_g.dialogue_open) scr_ch11_open_halls();
        return;
    }
    if (_name == "rm_barrow_deep") {
        if (!scr_flag_get("fd_entered") && !_g.dialogue_open) {
            scr_ch11_open_deep();
        } else if (scr_flag_get("ch11_king_defeated") && !scr_flag_get("ch11_choice_made")
            && !_g.dialogue_open) {
            // A save that re-enters after the fight still gets the seal.
            scr_ch11_seal_choice();
        }
    }
}

function scr_ch11_tick() {
    if (room_get_name(room) != "rm_barrow_deep") return;
    var _g = global.game;
    if (_g.battle_active || _g.dialogue_open || _g.transition_active) return;
    if (!instance_exists(obj_player)) return;
    var _p = instance_find(obj_player, 0);

    // Walking back down the chamber re-arms a lost fight.
    if (_p.y > 224 && scr_flag_get("ch11_boss_cool")) scr_flag_set("ch11_boss_cool", false);

    if (scr_flag_get("ch11_king_defeated") && !scr_flag_get("ch11_choice_made")) {
        // Let the aftermath's queued lines finish before the choice opens.
        if (variable_struct_exists(_g, "pending_post_dialogue")
            && is_array(_g.pending_post_dialogue)
            && array_length(_g.pending_post_dialogue) > 0) return;
        scr_ch11_seal_choice();
        return;
    }
    if (!scr_flag_get("ch11_charter_read")) return;
    if (scr_flag_get("ch11_king_fight") || scr_flag_get("ch11_boss_cool")) return;
    if (!scr_flag_get("ch11_king_defeated") && _p.y < 144) scr_ch11_king_scene();
}
