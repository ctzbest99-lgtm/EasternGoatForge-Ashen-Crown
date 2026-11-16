/// scr_ch7_story — Chapter 7 ("The Share") story flow.
/// Lines live in scr_dialogue_data_ch7 (generated from docs/story/CHAPTER7_SCRIPT.md, built
/// Nov 16 2026 from the approved Act III outline). This file decides which lines play when,
/// sets the chapter's flags, runs the tithe choice and its two branches, the Lost Ones, the
/// glade entry and the Matriarch gate.
///
/// Flags (script): ch7_entered, ch7_basin_seen, ch7_tithe_open, ch7_tithe_refused,
///   ch7_tithe_paid, ch7_lost_seen, ch7_glade_seen, ch7_matriarch_defeated, ch7_boss_started,
///   ch7_boss_cool, ch7_glade_crossed, chapter7_complete.
/// Quests: Q_MAIN_BLACKWOOD stages Q_MBW_S3 (entry) and Q_MBW_S4 (Matriarch dead);
///   Q_SIDE_TITHE opens at the tithe scene and closes on the choice.
///
/// The outline's decisions 4, 5, 6 and 8 are implemented as recommended: the tithe stays
/// unexplained, the Matriarch is a beast with no language, the doors are not opened here, and
/// both tithe choices are open with no correct answer and no main-quest effect.
///
/// The Matriarch gate lives in scr_ch7_tick rather than a story trigger so a lost fight is
/// replayable, as with the Chapter 6 boss.

function scr_ch7_quest_set(_quest_id, _stage_id) {
    scr_flag_set("quest_" + _quest_id, _stage_id);
}

// ------------------------------------------------------------------------------------------------
// Script dispatch

function scr_ch7_play_script(_sid, _src = noone) {
    switch (_sid) {
        // ---- §1.1 The basin (optional, never required) ----
        case "SH_BASIN":
            if (scr_flag_get("ch7_basin_seen")) {
                scr_dialogue_play(["SH_BASIN_R1"]);
            } else {
                scr_dialogue_play(["SH_BASIN_01", "SH_BASIN_02", "SH_BASIN_03"], function() {
                    scr_flag_set("ch7_basin_seen");
                });
            }
            return true;

        // ---- §2 The tithe, and the side quest's choice ----
        case "TT_MEET":
            if (scr_flag_get("ch7_tithe_open")) {
                scr_dialogue_play(["TT_MEET_R1"]);
                return true;
            }
            scr_dialogue_play(["TT_MEET_01", "TT_MEET_02", "TT_MEET_03", "TT_MEET_04",
                "TT_MEET_05", "TT_MEET_06"], function() {
                scr_flag_set("ch7_tithe_open");
                scr_ch7_quest_set("Q_SIDE_TITHE", "Q_ST_S1");
                scr_ch7_tithe_choice();
            });
            return true;

        // ---- §5 The glade's owner ----
        case "MT_FIGHT":
            scr_ch7_matriarch_fight();
            return true;
    }
    return false;
}

// ------------------------------------------------------------------------------------------------
// §2.1 / §2.2 The choice: donate a stranger's name, or refuse and lose a villager

function scr_ch7_tithe_choice() {
    if (global.game.battle_active || global.game.transition_active) return;
    scr_dialogue_play(["TT_CHOICE_01"], function() {
        scr_dialogue_choice(["Your call, Berrin. Say it plain."], "Kael",
            ["Don't pay it. Let the wood go hungry.", "Then choose a name from outside."],
            function(_idx) {
                if (_idx == 0) {
                    scr_flag_set("ch7_tithe_refused");
                    scr_dialogue_play(["TT_REFUSE_01", "TT_REFUSE_02", "TT_REFUSE_03"], function() {
                        scr_ch7_quest_set("Q_SIDE_TITHE", "complete");
                    });
                } else {
                    scr_flag_set("ch7_tithe_paid");
                    scr_dialogue_play(["TT_PAY_01", "TT_PAY_02", "TT_PAY_03", "TT_PAY_04"], function() {
                        scr_ch7_quest_set("Q_SIDE_TITHE", "complete");
                        // §2.2 reward: 120 Gold and the charm. Both are PLACEHOLDER numbers.
                        global.game.gold += 120;
                        if (!scr_inventory_has("item_cinderhollow_charm")) {
                            scr_inventory_add("item_cinderhollow_charm", "Cinderhollow Charm", 1, false);
                        }
                    });
                }
            });
    });
}

// ------------------------------------------------------------------------------------------------
// §1 Entry to the shrine, and the beat between the shrine and the glade

function scr_ch7_open() {
    if (global.game.dialogue_open || global.game.battle_active) return;
    scr_dialogue_play(["SH_ARRIVE_01", "SH_ARRIVE_02", "SH_ARRIVE_03", "SH_ARRIVE_04",
        "SH_ARRIVE_05"], function() {
        scr_flag_set("ch7_entered");
        scr_ch7_quest_set("Q_MAIN_BLACKWOOD", "Q_MBW_S3");
    });
}

/// §3 and §4 both play on first entry to the glade: the Lost Ones in the trees, then the
/// clearing and the doors across it.
function scr_ch7_glade_open() {
    if (global.game.dialogue_open || global.game.battle_active) return;
    scr_dialogue_play(["LT_MEET_01", "LT_MEET_02", "LT_MEET_03", "LT_MEET_04",
        "LT_MEET_05", "LT_MEET_06"], function() {
        scr_flag_set("ch7_lost_seen");
        scr_dialogue_play(["GL_ARRIVE_01", "GL_ARRIVE_02", "GL_ARRIVE_03"], function() {
            scr_flag_set("ch7_glade_seen");
        });
    });
}

// ------------------------------------------------------------------------------------------------
// §5 The Blackwood Matriarch

function scr_ch7_matriarch_scene() {
    if (global.game.battle_active || global.game.transition_active || global.game.dialogue_open) return;
    scr_flag_set("ch7_boss_started");
    scr_dialogue_play(["MT_INTRO_01", "MT_INTRO_02", "MT_INTRO_03", "MT_INTRO_04",
        "MT_INTRO_05"], function() {
        scr_ch7_matriarch_fight();
    });
}

function scr_ch7_matriarch_fight() {
    if (global.game.battle_active || global.game.transition_active) return;
    scr_dialogue_play(["MT_FIGHT_01", "MT_FIGHT_02"], function() {
        scr_encounter_start("grp_blackwood_matriarch", "enc_blackwood_matriarch", "MT_FIGHT");
    });
}

/// From scr_battle_finish. Victory opens Q_MBW_S4 and says plainly that nothing was freed;
/// a defeat re-arms the gate (see scr_ch7_tick).
function scr_ch7_on_battle_finish(_result, _pending) {
    if (!is_struct(_pending) || !variable_struct_exists(_pending, "encounter_id")) return;
    if (_pending.encounter_id != "enc_blackwood_matriarch") return;
    if (_result != "victory") {
        scr_flag_set("ch7_boss_started", false);
        scr_flag_set("ch7_boss_cool", true);
        return;
    }
    scr_flag_set("ch7_boss_started", false);
    scr_flag_set("ch7_matriarch_defeated");
    scr_ch7_quest_set("Q_MAIN_BLACKWOOD", "Q_MBW_S4");
    global.game.pending_post_dialogue = ["MT_AFTER_01", "MT_AFTER_02", "MT_AFTER_03", "MT_AFTER_04"];
}

// ------------------------------------------------------------------------------------------------
// §6 Handoff: the far edge of the glade, looking at the doors

function scr_ch7_end_scene() {
    if (global.game.dialogue_open || global.game.battle_active) return;
    if (scr_flag_get("ch7_glade_crossed")) return;
    scr_dialogue_play(["CH7_END_01", "CH7_END_02"], function() {
        scr_flag_set("ch7_glade_crossed");
        scr_flag_set("chapter7_complete");
    });
}

// ------------------------------------------------------------------------------------------------
// Gated doors

/// Returns true when this chapter handled the door (the door must not move the party).
function scr_ch7_exit_script(_door) {
    if (_door == noone || !instance_exists(_door) || !is_struct(_door.map_marker)) return false;
    var _m = _door.map_marker;
    if (!variable_struct_exists(_m, "name")) return false;

    if (_m.name == "to_glade") {
        if (scr_flag_get("ch7_tithe_open")) return false;
        scr_dialogue_play(["CH7_LOCKED_GLADE"]);
        return true;
    }
    if (_m.name == "to_doors") {
        if (scr_flag_get("ch7_matriarch_defeated")) return false;
        scr_dialogue_play(["CH7_LOCKED_DOORS"]);
        return true;
    }
    return false;
}

// ------------------------------------------------------------------------------------------------
// Room start + per-step hooks (obj_game_controller)

function scr_ch7_on_room_start() {
    scr_game_state_init();
    var _g = global.game;
    var _rn = room_get_name(room);

    if (_rn == "rm_blackwood_shrine" && !scr_flag_get("ch7_entered") && !_g.dialogue_open) {
        scr_ch7_open();
        return;
    }
    if (_rn == "rm_blackwood_glade" && !scr_flag_get("ch7_glade_seen") && !_g.dialogue_open) {
        scr_ch7_glade_open();
    }
}

function scr_ch7_tick() {
    var _rn = room_get_name(room);
    if (_rn != "rm_blackwood_glade") return;
    var _g = global.game;
    if (_g.battle_active || _g.dialogue_open || _g.transition_active) return;
    if (!instance_exists(obj_player)) return;
    var _p = instance_find(obj_player, 0);

    // Re-arm gate: walking back south clears the post-defeat cooldown.
    if (_p.y > 224 && scr_flag_get("ch7_boss_cool")) scr_flag_set("ch7_boss_cool", false);

    if (!scr_flag_get("ch7_matriarch_defeated")) {
        if (scr_flag_get("ch7_boss_started") || scr_flag_get("ch7_boss_cool")) return;
        if (_p.y > 192 || _p.x < 80 || _p.x > 400) return; // the far half of the clearing
        scr_ch7_matriarch_scene();
        return;
    }
    // §6: the chapter closes at the far edge, where the doors show through the gap.
    if (!scr_flag_get("ch7_glade_crossed") && _p.y < 96 && _p.x > 256) scr_ch7_end_scene();
}
