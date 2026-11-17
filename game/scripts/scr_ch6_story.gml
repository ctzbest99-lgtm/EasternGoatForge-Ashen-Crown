/// scr_ch6_story — Chapter 6 ("The Green Silence", Act III: The Blackwood) story flow.
/// Lines live in scr_dialogue_data_ch6 (generated from docs/story/CHAPTER6_SCRIPT.md,
/// approved Nov 16 2026). This file decides which lines play when, sets the script's flags,
/// runs the treeline/wood entry, Berrin's conversation and its repeat talk, the patrol camp,
/// the Burn-Line Hulk gate and Berrin's last scene.
///
/// Flags (script): ch6_entered, ch6_deep_seen, ch6_stone_seen, ch6_hollow_met, ch6_tithe_hook,
///   ch6_talk_1/2/3, ch6_camp_found, ch6_seal_seen, ch6_hulk_defeated, ch6_boss_started,
///   ch6_boss_cool, ch6_feed_revealed, ch6_carter_met, chapter6_complete.
/// Flags (code, bookkeeping): quest stages as quest_<QUEST_ID> = "<STAGE_ID>"
///   (scr_ch6_quest_set), the same convention as Chapters 2-5.
///
/// Quests: Q_MAIN_BEYOND_VEIL closes at the treeline (Q_BV_S7 stays its last stage, the quest is
///   set to "complete") and Q_MAIN_BLACKWOOD opens at Q_MBW_S1; Q_MBW_S2 opens when the Hulk dies.
///   Q_SIDE_TITHE is only planted (ch6_tithe_hook) — the quest itself belongs to Chapter 7.
///
/// Decisions this file implements (approved 2026-11-16): Cinderhollow and Berrin exist; the
/// patrol's armour is stacked and its bodies are never shown; the broken seal is noticed, not
/// decoded; the Briar Hulk has no dialogue; the chapter ends on the word "feed" with no act card;
/// the side quest's hook appears but does not open.
///
/// The boss gate lives in scr_ch6_tick rather than a story trigger, so a lost fight is
/// replayable (a map trigger latches after one attempt; the Chapter 4/5 lesson).

// ------------------------------------------------------------------------------------------------
// Small helpers

function scr_ch6_quest_set(_quest_id, _stage_id) {
    scr_flag_set("quest_" + _quest_id, _stage_id);
}

function scr_ch6_quest_get(_quest_id) {
    var _v = scr_flag_get("quest_" + _quest_id);
    return is_string(_v) ? _v : "";
}

// ------------------------------------------------------------------------------------------------
// Script dispatch. Called by scr_dialogue_play_script; returns true if it handled the id.

function scr_ch6_play_script(_sid, _src = noone) {
    switch (_sid) {
        // ---- §2 The carved stone (optional, never required) ----
        case "BW_STONE":
            if (scr_flag_get("ch6_stone_seen")) {
                scr_dialogue_play(["BW_STONE_R1"]);
            } else {
                scr_dialogue_play(["BW_STONE_01", "BW_STONE_02", "BW_STONE_03"], function() {
                    scr_flag_set("ch6_stone_seen");
                });
            }
            return true;

        // ---- §2 The carter drawn off the road: the Act V-VI shelf (Mott) ----
        case "BW_CARTER":
            scr_ch6_carter_talk();
            return true;

        // ---- §3 Cinderhollow: the first sight of the hollow ----
        case "CH_ARRIVE":
            scr_dialogue_play(["CH_ARRIVE_01", "CH_ARRIVE_02", "CH_ARRIVE_03", "CH_ARRIVE_04"]);
            return true;

        // ---- §3 Cinderhollow: Berrin, then his household, then repeat talk ----
        case "CH_BERRIN":
            if (!scr_flag_get("ch6_hollow_met")) {
                scr_dialogue_play(["CH_BERRIN_01", "CH_BERRIN_02", "CH_BERRIN_03",
                    "CH_BERRIN_04", "CH_BERRIN_05", "CH_BERRIN_06", "CH_BERRIN_07"], function() {
                    scr_flag_set("ch6_hollow_met");
                    // §3.1: his household is named once, in passing. Q_SIDE_TITHE is planted only.
                    scr_dialogue_play(["CH_TITHE_01", "CH_TITHE_02", "CH_TITHE_03"], function() {
                        scr_flag_set("ch6_tithe_hook");
                    });
                });
                return true;
            }
            // Repeat talk, one node per visit, in order, then a short refusal. Each adds a person,
            // never a fact — the script is explicit that Cinderhollow is not a lore delivery.
            if (!scr_flag_get("ch6_talk_1")) {
                scr_dialogue_play(["CH_TALK_01"], function() { scr_flag_set("ch6_talk_1"); });
            } else if (!scr_flag_get("ch6_talk_2")) {
                scr_dialogue_play(["CH_TALK_02"], function() { scr_flag_set("ch6_talk_2"); });
            } else if (!scr_flag_get("ch6_talk_3")) {
                scr_dialogue_play(["CH_TALK_03"], function() { scr_flag_set("ch6_talk_3"); });
            } else {
                scr_dialogue_play(["CH_BERRIN_R1"]);
            }
            return true;

        // ---- §4 The patrol's camp ----
        case "PT_CAMP":
            if (scr_flag_get("ch6_camp_found")) {
                scr_dialogue_play(["PT_CAMP_R1"]);
                return true;
            }
            scr_dialogue_play(["PT_CAMP_01", "PT_CAMP_02", "PT_CAMP_03", "PT_CAMP_04",
                "PT_CAMP_05", "PT_CAMP_06"], function() {
                scr_flag_set("ch6_camp_found");
                // §4: the seal is noticed, never decoded. The item has no mechanical effect.
                if (!scr_inventory_has("item_broken_order")) {
                    scr_inventory_add("item_broken_order", "Broken Order", 1, true);
                }
                scr_flag_set("ch6_seal_seen");
            });
            return true;

        // ---- §5 The burn line: the fight, when the party walks into it ----
        case "BH_FIGHT":
            scr_ch6_hulk_fight();
            return true;

        // ---- §6 Berrin's last scene (room start in Cinderhollow after the Hulk) ----
        case "CH_FEED":
            scr_ch6_feed_scene();
            return true;
    }
    return false;
}

// ------------------------------------------------------------------------------------------------
// §1 The treeline, and §2 under the canopy: both on first entry to rm_blackwood_deep

/// BW_HANDOFF, then straight into BW_DEEP: the chapter opens on Chapter 5's closing shot.
function scr_ch6_open() {
    if (global.game.dialogue_open || global.game.battle_active) return;
    scr_dialogue_play(["BW_HANDOFF_01", "BW_HANDOFF_02", "BW_HANDOFF_03", "BW_HANDOFF_04"],
        function() {
            scr_flag_set("ch6_entered");
            // The act turns over here: Act II's quest closes rather than growing an eighth stage.
            scr_ch6_quest_set("Q_MAIN_BEYOND_VEIL", "complete");
            scr_ch6_quest_set("Q_MAIN_BLACKWOOD", "Q_MBW_S1");
            scr_ch6_deep_scene();
        });
}

function scr_ch6_deep_scene() {
    if (global.game.dialogue_open || global.game.battle_active) return;
    scr_dialogue_play(["BW_DEEP_01", "BW_DEEP_02", "BW_DEEP_03"], function() {
        scr_flag_set("ch6_deep_seen");
    });
}

// ------------------------------------------------------------------------------------------------
// §2 The carter: a stranded cart on the road, and the Act V-VI shelf it carries.
// The stock gating lives in the shop's own stock_by_act rows (scr_story_act); the greeting says
// which crates are still shut, so the tarp and the shelf always agree.

function scr_ch6_carter_talk() {
    if (!scr_flag_get("ch6_carter_met")) {
        scr_dialogue_play(["BW_CARTER_01", "BW_CARTER_02"], function() {
            scr_flag_set("ch6_carter_met");
            scr_shop_open("shop_blackwood_carter");
        });
        return;
    }
    // Before Chapter 5 closes the party is at tier 5, so only the coast stock is open.
    if (scr_story_act() < 6) {
        scr_dialogue_play(["BW_CARTER_R1"], function() { scr_shop_open("shop_blackwood_carter"); });
        return;
    }
    scr_dialogue_play(["BW_CARTER_R2"], function() { scr_shop_open("shop_blackwood_carter"); });
}

// ------------------------------------------------------------------------------------------------
// §5 The Burn-Line Hulk

/// The gate: the party crossing into the burnt ground at the east end of the deep room starts
/// BH_INTRO and the fight. Started from scr_ch6_tick, never from a latched map trigger.
function scr_ch6_hulk_scene() {
    if (global.game.battle_active || global.game.transition_active || global.game.dialogue_open) return;
    scr_flag_set("ch6_boss_started");
    scr_dialogue_play(["BH_INTRO_01", "BH_INTRO_02", "BH_INTRO_03"], function() {
        scr_ch6_hulk_fight();
    });
}

function scr_ch6_hulk_fight() {
    if (global.game.battle_active || global.game.transition_active) return;
    scr_dialogue_play(["BH_FIGHT_01", "BH_FIGHT_02"], function() {
        scr_encounter_start("grp_burn_line_hulk", "enc_burn_line_hulk", "BH_FIGHT");
    });
}

/// From scr_battle_finish. Victory clears the burn line and opens Q_MBW_S2; defeat re-arms the
/// gate (its short cooldown is cleared when the party walks back west, see scr_ch6_tick).
function scr_ch6_on_battle_finish(_result, _pending) {
    if (!is_struct(_pending) || !variable_struct_exists(_pending, "encounter_id")) return;
    if (_pending.encounter_id != "enc_burn_line_hulk") return;
    if (_result != "victory") {
        scr_flag_set("ch6_boss_started", false);
        scr_flag_set("ch6_boss_cool", true);
        return;
    }
    scr_flag_set("ch6_boss_started", false);
    scr_flag_set("ch6_hulk_defeated");
    scr_ch6_quest_set("Q_MAIN_BLACKWOOD", "Q_MBW_S2");
    global.game.pending_post_dialogue = ["BH_AFTER_01", "BH_AFTER_02"];
}

// ------------------------------------------------------------------------------------------------
// §6 The share: Berrin's last scene, on returning to Cinderhollow

function scr_ch6_feed_scene() {
    if (global.game.dialogue_open || global.game.battle_active) return;
    if (scr_flag_get("ch6_feed_revealed")) return;
    if (!scr_flag_get("ch6_hulk_defeated")) return;
    scr_dialogue_play(["CH_FEED_01", "CH_FEED_02", "CH_FEED_03", "CH_FEED_04",
        "CH_FEED_05", "CH_FEED_06", "CH_END_01", "CH_END_02"], function() {
        scr_flag_set("ch6_feed_revealed");
        scr_flag_set("chapter6_complete");
        // CH_END_02 carries the chapter card; there is no act card — that belongs to Chapter 8.
    });
}

// ------------------------------------------------------------------------------------------------
// Room start + per-step hooks (obj_game_controller)

function scr_ch6_on_room_start() {
    scr_game_state_init();
    var _g = global.game;
    var _rn = room_get_name(room);

    if (_rn == "rm_blackwood_deep") {
        if (!scr_flag_get("ch6_entered")) {
            scr_ch6_open();
            return;
        }
        if (!scr_flag_get("ch6_deep_seen") && !_g.dialogue_open) scr_ch6_deep_scene();
        return;
    }
    if (_rn == "rm_blackwood_hollow") {
        // §6 plays on the way back, not on the way in: the Hulk has to be dead first.
        if (scr_flag_get("ch6_hulk_defeated") && !scr_flag_get("ch6_feed_revealed")) {
            scr_ch6_feed_scene();
        }
    }
}

function scr_ch6_tick() {
    // The boss gate. Everything else in this chapter is a room start, an interact or the fight itself.
    if (room_get_name(room) != "rm_blackwood_deep") return;
    if (scr_flag_get("ch6_hulk_defeated")) return;
    var _g = global.game;
    if (_g.battle_active || _g.dialogue_open || _g.transition_active) return;
    if (!instance_exists(obj_player)) return;
    var _p = instance_find(obj_player, 0);
    // Walking back west of the burn line clears the post-defeat cooldown, so the gate can re-arm.
    if (_p.x < 320 && scr_flag_get("ch6_boss_cool")) scr_flag_set("ch6_boss_cool", false);
    if (scr_flag_get("ch6_boss_started") || scr_flag_get("ch6_boss_cool")) return;
    if (_p.x < 400) return; // the burnt ground starts at tile 25; the road before it is quiet
    scr_ch6_hulk_scene();
}
