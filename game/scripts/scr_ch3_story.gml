/// scr_ch3_story — Chapter 3 ("Crowns and Alleys") story flow. Lines live in
/// scr_dialogue_data_ch3 (generated from docs/story/CHAPTER3_SCRIPT.md, approved by
/// Kevin Nov 14 2026 3:53 PM ET). This file decides which lines play when, sets the
/// script's flags, runs the heist, the Debtman fight, Lyra's join, the parcel side
/// quest and the chapter end on the west-country road.
///
/// Flags (script): flag_fk_seen_3, flag_entered_valemere, flag_alden_met, flag_lower_city_job,
///   flag_scholar_notes, flag_debtman_beaten, flag_lyra_in_battle, flag_lyra_recruited,
///   flag_parcel_accepted, flag_parcel_done, flag_chapter3_complete.
/// Flags (code, bookkeeping): flag_vm_entered, flag_vr_entered, flag_alden_repeat, quest
///   stages as flags quest_<QUEST_ID> = "<STAGE_ID>" (scr_ch3_quest_set).
///
/// Quests (Q_MAIN_BEYOND_VEIL): Q_BV_S3 active on entry, completes at the gates;
///   Q_BV_S4 Search the Lower City (completes at Lyra's join); Q_BV_S5 Find the Hollow
///   Sanctuary named in the notes. Side quest Q_SIDE_PARCEL "A Parcel Unsealed".

// ------------------------------------------------------------------------------------------------
// Small helpers

/// One node's text on one line, optionally as `Speaker: "text"` (battle messages).
function scr_ch3_node_text(_id, _with_speaker = true) {
    var _n = scr_dialogue_node(_id);
    if (!is_struct(_n)) return "";
    var _t = "";
    for (var _i = 0; _i < array_length(_n.lines); _i++) _t += ((_i > 0) ? " " : "") + _n.lines[_i];
    if (_with_speaker && _n.speaker != "" && _n.speaker != "SYSTEM") _t = _n.speaker + ": \"" + _t + "\"";
    return _t;
}

function scr_ch3_quest_set(_quest_id, _stage_id) {
    scr_flag_set("quest_" + _quest_id, _stage_id);
}

function scr_ch3_quest_get(_quest_id) {
    var _v = scr_flag_get("quest_" + _quest_id);
    return is_string(_v) ? _v : "";
}

function scr_ch3_room_is(_name) {
    return room_get_name(room) == _name;
}

function scr_ch3_src_npc(_src) {
    if (_src != noone && instance_exists(_src) && variable_instance_exists(_src, "npc_id")) return _src.npc_id;
    return "";
}

// ------------------------------------------------------------------------------------------------
// Script dispatch. Called first by scr_dialogue_play_script; returns true if it handled the id.

function scr_ch3_play_script(_sid, _src = noone) {
    switch (_sid) {
        // ---- §1 Valemere Road ----
        case "VR_SIGN_01":
            scr_dialogue_play(["VR_SIGN_01"]);
            return true;
        case "VR_STONE_01":
            scr_dialogue_play(["VR_STONE_01", "VR_STONE_02"]);
            return true;
        case "VR_SETTLE_01":
            scr_dialogue_play(["VR_SETTLE_01", "VR_SETTLE_02"]);
            return true;
        case "VR_DERRY_01":
            if (scr_flag_get("flag_derry_spoke")) {
                scr_dialogue_play(["VR_DERRY_R1"]);
            } else {
                scr_dialogue_play(["VR_DERRY_01", "VR_DERRY_02", "VR_DERRY_03", "VR_DERRY_04", "VR_DERRY_05"], function() {
                    scr_flag_set("flag_derry_spoke");
                });
            }
            return true;
        case "VR_RUMOR_01":
            scr_dialogue_play(["VR_RUMOR_01"]);
            return true;
        case "FK_03":
            scr_ch3_fk_sighting();
            return true;

        // ---- §2 Valemere gates and district barks ----
        case "VM_GATE_01":
            if (scr_flag_get("flag_entered_valemere")) {
                scr_dialogue_play(["VM_GATE_B1"]);
            } else {
                scr_ch3_vm_gate_scene();
            }
            return true;
        case "VM_GATE_SIGN":
            scr_dialogue_play(["VM_GATE_SIGN"]);
            return true;
        case "VM_ROYAL_01":
            scr_dialogue_play(["VM_ROYAL_01", "VM_ROYAL_02", "VM_ROYAL_03"]);
            return true;
        case "VM_MIL_01":
            scr_dialogue_play(["VM_MIL_01", "VM_MIL_02", "VM_MIL_03"]);
            return true;
        case "VM_TEMPLE_01":
            if (scr_flag_get("flag_lyra_recruited")) scr_dialogue_play(["VM_TEMPLE_B1"]);
            else scr_dialogue_play(["VM_TEMPLE_01", "VM_TEMPLE_02", "VM_TEMPLE_03"]);
            return true;
        case "VM_MERCH_01":
            scr_dialogue_play(["VM_MERCH_01"]);
            return true;
        case "VM_CLERK_01":
            scr_dialogue_play(["VM_CLERK_01", "VM_CLERK_02", "VM_CLERK_03", "VM_CLERK_04"]);
            return true;
        case "VM_OLD_01":
            scr_dialogue_play(["VM_OLD_01", "VM_OLD_02", "VM_OLD_03"]);
            return true;
        case "VM_LOWER_01":
            if (scr_flag_get("flag_debtman_beaten")) scr_dialogue_play(["LC_HAWKER_B1"]);
            else scr_dialogue_play(["VM_LOWER_01"]);
            return true;
        case "VM_WEST_SIGN":
            scr_dialogue_play(["VM_WEST_SIGN"]);
            return true;

        // ---- §3 Alden in Weigh-House Square ----
        case "AD_MEET_01":
            if (scr_flag_get("flag_alden_met")) {
                if (scr_flag_get("flag_debtman_beaten")) scr_dialogue_play(["AD_MEET_B1"]);
                else scr_dialogue_play(["AD_MEET_R1"]);
            } else {
                scr_ch3_alden_scene();
            }
            return true;

        // ---- §4 The Salt Lamp ----
        case "SL_NIM_01":
            scr_ch3_nim_talk();
            return true;
        case "SL_LYRA_01":
            scr_dialogue_play([scr_flag_get("flag_lower_city_job") ? "SL_LYRA_R1" : "SL_LYRA_01"]);
            return true;
        case "SL_PARCEL_01":
            scr_ch3_parcel_offer();
            return true;

        // ---- §4.1 parcel quest (Merchant District stall) ----
        case "VM_PARCEL_01":
            if (scr_flag_get("flag_parcel_accepted") && !scr_flag_get("flag_parcel_done")) {
                scr_dialogue_play(["VM_PARCEL_01", "VM_PARCEL_02"], function() {
                    scr_inventory_remove("item_nim_parcel", 1, true);
                    scr_ch3_quest_set("Q_SIDE_PARCEL", "Q_SP_S2");
                });
            } else if (scr_flag_get("flag_parcel_done")) {
                scr_dialogue_play(["VM_PARCEL_01"]);
            }
            return true;
        case "SL_PARCEL_05":
            scr_ch3_parcel_turn_in();
            return true;

        // ---- §5 The seized warehouse ----
        case "LC_HEIST_01":
            scr_dialogue_play(["LC_HEIST_01", "LC_HEIST_02", "LC_HEIST_03"]);
            return true;
        case "LC_LOCK_01":
            scr_dialogue_play(["LC_LOCK_01"]);
            return true;
        case "LC_NOTE_01":
            if (scr_flag_get("flag_scholar_notes")) {
                scr_dialogue_play(["LC_NOTE_R1", "LC_NOTE_R2"]);
            } else {
                scr_ch3_notes_take();
            }
            return true;
        case "LC_HEIST_04":
            scr_dialogue_play(["LC_HEIST_04"]);
            return true;

        // ---- §7 Lyra's join talk (after the fight) ----
        case "LY_JOIN_R1":
            scr_dialogue_play(["LY_JOIN_R1"]);
            return true;
        case "SL_NIM_B1":
            scr_dialogue_play(["SL_NIM_B1"]);
            return true;
    }
    return false;
}

// ------------------------------------------------------------------------------------------------
// §1.1 The Fallen Knight, third sighting

function scr_ch3_fk_sighting() {
    if (scr_flag_get("flag_fk_seen_3")) {
        scr_dialogue_play(["FK_03_01"]);
        return;
    }
    scr_dialogue_play(["FK_03_01", "FK_03_02", "FK_03_03", "FK_03_04", "FK_03_05", "FK_03_06", "FK_03_07",
        "FK_03_08", "FK_03_09"], function() {
        scr_flag_set("flag_fk_seen_3");
    });
}

// ------------------------------------------------------------------------------------------------
// §1 road entry, §2 gates

/// VR_ENTER plays on first entry to rm_valemere_road (scr_ch3_on_room_start).
function scr_ch3_vr_enter() {
    scr_dialogue_play(["VR_ENTER_01", "VR_ENTER_02", "VR_ENTER_03"], function() {
        scr_flag_set("flag_vr_entered");
    });
}

/// The gates scene: the party is admitted, Taren is not arrested.
function scr_ch3_vm_gate_scene() {
    scr_dialogue_play(["VM_GATE_01", "VM_GATE_02", "VM_GATE_03", "VM_GATE_04", "VM_GATE_05", "VM_GATE_06",
        "VM_GATE_07", "VM_GATE_08"], function() {
        scr_flag_set("flag_entered_valemere");
        scr_ch3_quest_set("Q_MAIN_BEYOND_VEIL", "Q_BV_S4"); // S3 completes at the gates; S4: Lower City
    });
}

// ------------------------------------------------------------------------------------------------
// §3 Alden (Weigh-House Square; cannot be missed — Nim gates on him)

function scr_ch3_alden_scene() {
    scr_dialogue_play(["AD_MEET_01", "AD_MEET_02", "AD_MEET_03", "AD_MEET_04", "AD_MEET_05", "AD_MEET_06",
        "AD_MEET_07", "AD_MEET_08", "AD_MEET_09", "AD_MEET_10", "AD_MEET_11", "AD_MEET_12", "AD_MEET_13"],
        function() {
            scr_flag_set("flag_alden_met");
        });
}

// ------------------------------------------------------------------------------------------------
// §4 The Salt Lamp — Nim sells the lead, Lyra takes the job

function scr_ch3_nim_talk() {
    if (scr_flag_get("flag_lower_city_job")) {
        // After the job: the deniable version.
        if (scr_flag_get("flag_debtman_beaten")) {
            scr_dialogue_play(["SL_NIM_B1"]);
        } else {
            scr_dialogue_play(["SL_NIM_R1"]);
        }
        return;
    }
    if (!scr_flag_get("flag_alden_met")) {
        // Nim will not talk business before the square is walked (Alden cannot be missed).
        scr_dialogue_play(["SL_NIM_01"]);
        return;
    }
    scr_dialogue_play(["SL_NIM_02", "SL_NIM_03", "SL_NIM_04", "SL_NIM_05", "SL_NIM_06", "SL_NIM_07",
        "SL_LYRA_01", "SL_LYRA_02", "SL_LYRA_03", "SL_LYRA_04", "SL_LYRA_05", "SL_LYRA_06", "SL_LYRA_07"],
        function() {
            scr_flag_set("flag_lower_city_job");
        });
}

// ------------------------------------------------------------------------------------------------
// §4.1 A Parcel Unsealed — Q_SIDE_PARCEL

function scr_ch3_parcel_offer() {
    if (scr_flag_get("flag_parcel_accepted") || scr_flag_get("flag_parcel_done")) {
        scr_dialogue_play([scr_flag_get("flag_parcel_done") ? "SL_PARCEL_05" : "SL_PARCEL_01"]);
        return;
    }
    scr_dialogue_play(["SL_PARCEL_01"], function() {
        scr_dialogue_choice(["Accept?"], "", ["Yes", "No"], function(_idx) {
            if (_idx == 0) {
                scr_flag_set("flag_parcel_accepted");
                scr_ch3_quest_set("Q_SIDE_PARCEL", "Q_SP_S1");
                scr_inventory_add("item_nim_parcel", "Nim's Parcel", 1, true);
                scr_dialogue_play(["SL_PARCEL_03_YES"]);
            } else {
                scr_dialogue_play(["SL_PARCEL_04_NO"]);
            }
        });
    });
}

function scr_ch3_parcel_turn_in() {
    if (!scr_flag_get("flag_parcel_accepted") || scr_flag_get("flag_parcel_done")) {
        scr_dialogue_play(["SL_NIM_R1"]);
        return;
    }
    if (scr_ch3_quest_get("Q_SIDE_PARCEL") != "Q_SP_S2") {
        scr_dialogue_play(["SL_NIM_R1"]); // not delivered yet
        return;
    }
    scr_dialogue_play(["SL_PARCEL_05", "SL_PARCEL_06"], function() {
        scr_loot_grant_entry("60 Gold");
        scr_loot_grant_entry("Antidote x2");
        scr_flag_set("flag_parcel_done");
        scr_ch3_quest_set("Q_SIDE_PARCEL", "complete");
    });
}

// ------------------------------------------------------------------------------------------------
// §5 The seized warehouse — the notes

function scr_ch3_notes_take() {
    scr_dialogue_play(["LC_NOTE_01", "LC_NOTE_02", "LC_NOTE_03", "LC_NOTE_04"], function() {
        scr_inventory_add("item_scholar_notes", "Scholar's Notes", 1, true);
        scr_flag_set("flag_scholar_notes");
    });
}

// ------------------------------------------------------------------------------------------------
// §6 The Debtman — break, fight, defeat. §5 Decision 2: he is waiting at the door on the way out.

function scr_ch3_heist_break() {
    if (scr_flag_get("flag_debtman_beaten") || global.game.battle_active) return;
    scr_dialogue_play(["LC_BREAK_01", "LC_BREAK_02", "LC_BREAK_03", "LC_BREAK_04", "LC_BREAK_05"], function() {
        scr_ch3_debtman_fight_start();
    });
}

/// Lyra enters the party at the start of this fight (3rd slot, at Kael's level).
function scr_ch3_lyra_join() {
    scr_game_state_init();
    if (scr_flag_get("flag_lyra_in_battle")) return false;
    var _l = scr_roster_find(global.game.roster, "lyra");
    if (!is_struct(_l)) return false;
    if (!_l.joined) scr_party_join("lyra");
    var _kael = scr_roster_find(global.game.roster, "kael");
    var _lv = is_struct(_kael) ? _kael.level : 1;
    if (_l.level < _lv) scr_actor_raise_to_level(_l, _lv);
    _l.equipment.weapon = "item_twin_daggers";
    scr_flag_set("flag_lyra_in_battle");
    return true;
}

function scr_ch3_debtman_fight_start() {
    var _joined = scr_ch3_lyra_join();
    var _chain = ["DM_INTRO_01", "DM_INTRO_02", "DM_INTRO_03", "DM_INTRO_04"];
    if (_joined) {
        array_insert(_chain, 0, "DM_SYS_01"); // Lyra has joined the party (before the intro)
    }
    scr_dialogue_play(_chain, function() {
        scr_encounter_start("grp_debtman", "enc_debtman", "LC_BREAK");
    });
}

/// From scr_battle_finish. A Debtman win (he yields) queues §6.2 and §7 (the join talk).
function scr_ch3_on_battle_finish(_result, _pending) {
    if (!is_struct(_pending) || _result != "victory") return;
    if (!variable_struct_exists(_pending, "encounter_id") || _pending.encounter_id != "enc_debtman") return;
    scr_flag_set("flag_debtman_beaten");
    // DM_DEFEAT_01 is his yield line in battle; the rest plays back in the lane.
    global.game.pending_post_dialogue = [
        "DM_DEFEAT_02", "DM_DEFEAT_03", "DM_DEFEAT_04", "DM_DEFEAT_05", "DM_REWARD_01",
        "LY_JOIN_01", "LY_JOIN_02", "LY_JOIN_03", "LY_JOIN_04", "LY_JOIN_05", "LY_JOIN_06",
        "LY_JOIN_07", "LY_JOIN_08"
    ];
    global.game.pending_post_callback = function() {
        scr_flag_set("flag_lyra_recruited");
        scr_ch3_quest_set("Q_MAIN_BEYOND_VEIL", "Q_BV_S5"); // S4 completes; S5: the sanctuary
    };
}

// ------------------------------------------------------------------------------------------------
// §9 Handoff — the west-country road ends Chapter 3

function scr_ch3_exit_script(_door) {
    if (_door == noone || !instance_exists(_door) || !is_struct(_door.map_marker)) return false;
    var _m = _door.map_marker;
    if (!variable_struct_exists(_m, "name")) return false;
    // §5 Decision 2: the Debtman is waiting at the warehouse door on the way out with the notes.
    if (_m.name == "warehouse_exit") return scr_ch3_warehouse_exit(_door);
    if (_m.name != "west_country_road") return false;
    if (scr_flag_get("flag_chapter3_complete")) {
        scr_ch3_west_leave(_door);
        return true;
    }
    // The handoff needs the notes and Lyra (the party walking out is the end of the job).
    if (!scr_flag_get("flag_lyra_recruited")) {
        scr_dialogue_play(["VM_HANDOFF_GATE"]);
        return true;
    }
    scr_dialogue_play(["VM_HANDOFF_01", "VM_HANDOFF_02", "VM_HANDOFF_03", "VM_HANDOFF_04", "VM_HANDOFF_05"],
        function() {
            scr_flag_set("flag_chapter3_complete");
            global.game.ch3_save_prompt_pending = true;
            scr_ch3_west_leave(_door);
        });
    return true;
}

function scr_ch3_west_leave(_door) {
    // Chapter 4 (the Hollow Sanctuary approach) has no room yet: the gate is the end
    // of the buildable world. Leaving is a no-op when there is nowhere to go.
    var _ok = (_door != noone && instance_exists(_door));
    var _rm = _ok ? _door.target_room : -1;
    var _spawn = _ok ? _door.target_spawn : "";
    if (_rm == -1 || !room_exists(_rm)) return;
    global.map_spawn_name = _spawn;
    room_goto(_rm);
}

/// Leaving the warehouse with the notes: the Debtman is at the door (§5 Decision 2, §6).
/// After the fight (or without the notes) the door is a plain exit back to Valemere.
function scr_ch3_warehouse_exit(_door) {
    if (!scr_flag_get("flag_scholar_notes") || scr_flag_get("flag_debtman_beaten") || global.game.battle_active) {
        return false; // fall through to the normal room change
    }
    scr_ch3_heist_break();
    return true;
}

// ------------------------------------------------------------------------------------------------
// Room start + per-step hooks (obj_game_controller)

function scr_ch3_on_room_start() {
    scr_game_state_init();
    var _g = global.game;
    var _rn = room_get_name(room);
    if (variable_struct_exists(_g, "ch3_save_prompt_pending") && _g.ch3_save_prompt_pending) {
        _g.ch3_save_prompt_pending = false;
        scr_save_menu_open("save", false);
    }
    // §1: the road east of Valemere — one-shot entry scene.
    if (_rn == "rm_valemere_road" && !scr_flag_get("flag_vr_entered") && !_g.dialogue_open) {
        scr_ch3_vr_enter();
    }
    // §4: the Salt Lamp is a safe interior; the entry line plays once.
    if (_rn == "rm_salt_lamp" && !scr_flag_get("flag_sl_entered") && !_g.dialogue_open) {
        scr_dialogue_play(["SL_ENTER_01"], function() { scr_flag_set("flag_sl_entered"); });
    }
}

function scr_ch3_tick() {
    // Nothing per-frame yet: the Chapter 3 beats are all room starts / interacts.
}
