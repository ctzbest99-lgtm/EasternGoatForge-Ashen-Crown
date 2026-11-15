/// scr_ch2_story — Chapter 2 ("The Weight of the Yoke") story flow. Lines live in
/// scr_dialogue_data_ch2 (generated from docs/story/CHAPTER2_SCRIPT.md). This file decides
/// which lines play when, sets the script's flags, and runs the Calder fight, Taren's join,
/// Oda's side quest, the inn / shop in Wrenfield and the chapter end on the west road.
///
/// Flags (script): flag_act2_started, flag_hook_taren, flag_greyhaven_return, flag_wrenfield_entered,
///   flag_close_call, flag_taren_in_battle, flag_execution_stopped, flag_taren_recruited, flag_oda_done,
///   flag_chapter2_complete. (Map art pass): flag_mr_entered, flag_wf_gate_seen (one-shot triggers).
/// Flags (code, bookkeeping): flag_mr_hook_heard, flag_oda_accepted, flag_bram_spoke, flag_rally_sys_seen,
///   flag_gh2_<npc> (first Greyhaven-return talk), avoided_<encounter_id>.
/// Quests have no UI yet: stages are stored as flags quest_<QUEST_ID> = "<STAGE_ID>" (scr_ch2_quest_set).

// ------------------------------------------------------------------------------------------------
// Small helpers

/// One node's text on one line, optionally as `Speaker: "text"` (battle messages).
function scr_ch2_node_text(_id, _with_speaker = true) {
    var _n = scr_dialogue_node(_id);
    if (!is_struct(_n)) return "";
    var _t = "";
    for (var _i = 0; _i < array_length(_n.lines); _i++) _t += ((_i > 0) ? " " : "") + _n.lines[_i];
    if (_with_speaker && _n.speaker != "" && _n.speaker != "SYSTEM") _t = _n.speaker + ": \"" + _t + "\"";
    return _t;
}

function scr_ch2_quest_set(_quest_id, _stage_id) {
    scr_flag_set("quest_" + _quest_id, _stage_id);
}

function scr_ch2_quest_get(_quest_id) {
    var _v = scr_flag_get("quest_" + _quest_id);
    return is_string(_v) ? _v : "";
}

function scr_ch2_room_is(_name) {
    return room_get_name(room) == _name;
}

/// Source instance's npc_id, or "".
function scr_ch2_src_npc(_src) {
    if (_src != noone && instance_exists(_src) && variable_instance_exists(_src, "npc_id")) return _src.npc_id;
    return "";
}

/// First instance whose map marker has this name, or noone.
function scr_ch2_find_marker_inst(_name) {
    var _found = noone;
    with (all) {
        if (_found == noone && variable_instance_exists(id, "map_marker") && is_struct(map_marker)
            && variable_struct_exists(map_marker, "name") && map_marker.name == _name) _found = id;
    }
    return _found;
}

/// Apply a marker's `sprite` (Design's suggested overworld asset). Strips animate at 2 fps.
/// Returns false (and changes nothing) when the asset is not imported.
function scr_ch2_apply_marker_sprite(_inst, _m) {
    if (_inst == noone || !instance_exists(_inst) || !is_struct(_m) || !variable_struct_exists(_m, "sprite")) return false;
    var _spr = scr_sprite_index(_m.sprite);
    if (!scr_sprite_is_valid(_spr)) return false;
    _inst.sprite_index = _spr;
    _inst.mask_index = _spr;
    _inst.image_xscale = 1;
    _inst.image_yscale = 1;
    _inst.image_index = 0;
    var _fps = game_get_speed(gamespeed_fps);
    _inst.image_speed = (sprite_get_number(_spr) > 1 && _fps > 0) ? (2 / _fps) : 0;
    _inst.visible = true;
    scr_ch1_place_at_feet(_inst, _m.x, _m.y);
    return true;
}

/// Swap a placed instance to another sprite in place (feet stay put).
function scr_ch2_swap_sprite(_inst, _sprite_name) {
    if (_inst == noone || !instance_exists(_inst)) return;
    var _spr = scr_sprite_index(_sprite_name);
    if (!scr_sprite_is_valid(_spr)) return;
    var _m = variable_instance_exists(_inst, "map_marker") ? _inst.map_marker : undefined;
    _inst.sprite_index = _spr;
    _inst.mask_index = _spr;
    var _fps = game_get_speed(gamespeed_fps);
    _inst.image_speed = (sprite_get_number(_spr) > 1 && _fps > 0) ? (2 / _fps) : 0;
    if (is_struct(_m)) scr_ch1_place_at_feet(_inst, _m.x, _m.y);
}

// ------------------------------------------------------------------------------------------------
// Marker fix-ups for the generated Wrenfield data (called by scr_wf_filter_markers), so the
// generated files in /workspace/wrenfield stay regenerable. See DECISIONS "Chapter 2".

function scr_ch2_marker_fixups(_markers) {
    var _has = function(_ms, _name) {
        for (var _k = 0; _k < array_length(_ms); _k++) if (variable_struct_exists(_ms[_k], "name") && _ms[_k].name == _name) return true;
        return false;
    };
    for (var _i = 0; _i < array_length(_markers); _i++) {
        var _m = _markers[_i];
        if (!variable_struct_exists(_m, "name")) continue;
        switch (_m.name) {
            case "west_road_closed":
                // Kevin: the west barrier clears after the Calder fight (not after the join talk).
                _m.requires_flag = "flag_execution_stopped";
                break;
            case "perrin_after":
                _m.rest_price = INN_WRENFIELD_PRICE; // PLACEHOLDER (balance pass)
                break;
            case "mr_patrol_escort":
                _m.part_of_encounter = "enc_crown_patrol"; // leaves with the patrol
                break;
        }
    }
    // Millhaven Road: the Ether chest promised by the balance pass (PLACEHOLDER spot, east clearing).
    if (_has(_markers, "mr_signpost") && !_has(_markers, "mr_ether_chest")) {
        array_push(_markers, { type: "treasure", name: "mr_ether_chest", tile_x: 25, tile_y: 24, x: 408, y: 400,
            loot: ["Ether"], written_by: "code (balance pass placeholder)" });
    }
    // Wrenfield after the rescue: Taren waits by Oda and Bram until the party leaves (WF_JOIN_R1).
    if (_has(_markers, "oda_after") && !_has(_markers, "taren_after") && scr_flag_get("flag_execution_stopped")) {
        array_push(_markers, { type: "npc", name: "taren_after", tile_x: 24, tile_y: 24, x: 392, y: 400,
            npc_id: "taren", speaker: "Taren", script_id: "WF_JOIN_R1", sprite: "spr_taren_ow16_idle_left",
            hostile: false, facing: "left", written_by: "code (placement only; line is canon)" });
    }
    return _markers;
}

/// Extras that belong to an encounter (the patrol's second soldier) leave with it.
function scr_ch2_marker_skip(_m) {
    if (!is_struct(_m)) return false;
    if (variable_struct_exists(_m, "part_of_encounter")) {
        var _e = _m.part_of_encounter;
        if (variable_struct_exists(global.game.cleared_encounters, _e) || scr_flag_get("avoided_" + _e)) return true;
    }
    if (variable_struct_exists(_m, "encounter_id") && variable_struct_exists(_m, "avoidable") && _m.avoidable
        && scr_flag_get("avoided_" + _m.encounter_id)) return true;
    return false;
}

// ------------------------------------------------------------------------------------------------
// Script dispatch. Called first by scr_dialogue_play_script; returns true if it handled the id.

function scr_ch2_play_script(_sid, _src = noone) {
    var _act2 = scr_flag_get("flag_act2_started");
    switch (_sid) {
        // ---- §1 Crownveil Door, §2 Watchtower backtrack (Chapter 1 rooms, Act II state) ----
        case "CV_END":
            if (!_act2) return false; // Chapter 1 handler
            scr_dialogue_play(["CV_WAKE_06"]);
            return true;
        case "CV_WAKE_ARMOR":
            scr_dialogue_play(["CV_WAKE_05"]);
            return true;
        case "WT_BANNER":
            if (!_act2 || !scr_flag_get("flag_banner_clue")) return false;
            scr_dialogue_play(["WT2_BANNER_R1"]);
            return true;

        // ---- §3 Optional return to Greyhaven ----
        case "GH_TOMAS":
            if (!_act2) return false;
            scr_flag_set("flag_greyhaven_return");
            if (scr_ch2_src_npc(_src) == "pell") {
                if (scr_flag_get("flag_gh2_pell")) {
                    scr_dialogue_play(["GH2_PELL_R1"], function() { scr_shop_open("shop_greyhaven_forge"); });
                } else {
                    scr_dialogue_play(["GH2_PELL_01", "GH2_PELL_02", "GH2_PELL_03", "GH2_PELL_04", "GH2_PELL_05"], function() {
                        scr_flag_set("flag_gh2_pell");
                        scr_ch2_hook_heard();
                    });
                }
            } else {
                if (scr_flag_get("flag_gh2_tomas")) scr_dialogue_play(["GH2_TOMAS_R1"]);
                else scr_dialogue_play(["GH2_TOMAS_01"], function() { scr_flag_set("flag_gh2_tomas"); });
            }
            return true;
        case "GH_TAVERN": case "GH_TAVERN_01":
            if (!_act2) return false;
            scr_flag_set("flag_greyhaven_return");
            scr_dialogue_play(["GH2_HOB_01", "GH2_HOB_02", "GH2_HOB_03"]);
            return true;
        case "GH_CHAPEL": case "GH_CHAPEL_01":
            if (!_act2) return false;
            scr_flag_set("flag_greyhaven_return");
            scr_dialogue_play(["GH2_ILSE_01", "GH2_ILSE_02", "GH2_ILSE_03"]);
            return true;
        case "GH_STORE": case "GH_STORE_01":
            if (!_act2) return false;
            scr_flag_set("flag_greyhaven_return");
            scr_dialogue_play(["GH2_MARDA_01"], function() { scr_shop_open("shop_greyhaven_store"); });
            return true;
        case "GH_SQUARE_01":
            if (!_act2) return false;
            scr_flag_set("flag_greyhaven_return");
            scr_dialogue_play(["GH2_WENNA_01"]);
            return true;
        case "GH_SQUARE_02":
            if (!_act2) return false;
            scr_flag_set("flag_greyhaven_return");
            scr_dialogue_play(["GH2_DOV_01", "GH2_DOV_02", "GH2_DOV_03"]);
            return true;
        case "GH_GATE": case "GH_GATE_01_A":
            if (!_act2) return false;
            scr_flag_set("flag_greyhaven_return");
            scr_dialogue_play(["GH2_CORWIN_01", "GH2_CORWIN_02", "GH2_CORWIN_03"], function() { scr_ch2_hook_heard(); });
            return true;

        // ---- §4 Millhaven Road ----
        case "MR_ENTER_01":
            scr_dialogue_play(["MR_ENTER_01"], function() {
                scr_flag_set("flag_mr_entered");
                if (scr_flag_get("flag_hook_taren")) scr_ch2_quest_set("Q_MAIN_BEYOND_VEIL", "Q_BV_S2");
            });
            return true;
        case "MR_NOTICE_01":
            scr_dialogue_play(["MR_NOTICE_01"], function() { scr_ch2_hook_heard(); }); // backup hook
            return true;
        case "MR_HOOK_01":
            if (scr_flag_get("flag_mr_hook_heard")) {
                scr_dialogue_play(["MR_HOOK_R1"]);
            } else {
                scr_dialogue_play(["MR_HOOK_01", "MR_HOOK_02", "MR_HOOK_03", "MR_HOOK_04", "MR_HOOK_05"], function() {
                    scr_flag_set("flag_mr_hook_heard");
                    scr_ch2_hook_heard();
                });
            }
            return true;
        case "MR_STONE_01":
            scr_dialogue_play(["MR_STONE_01", "MR_STONE_02"]);
            return true;

        // ---- §5 Wrenfield approach and §5.1 barks (before the rescue) ----
        case "WF_GATE_01":
            scr_dialogue_play(["WF_GATE_01", "WF_GATE_02", "WF_GATE_03"], function() { scr_flag_set("flag_wf_gate_seen"); });
            return true;
        case "WF_TAVERN_A1":
            scr_dialogue_play(["WF_TAVERN_A1", "WF_TAVERN_A2", "WF_TAVERN_A3"]);
            return true;
        case "WF_ODA_A1":
            scr_ch2_oda_before();
            return true;

        // ---- §6–7 The gallows and Reeve Calder ----
        case "WF_GALLOWS_01":
        case "WF_GALLOWS_03":
            if (scr_flag_get("flag_execution_stopped")) return true;
            if (scr_flag_get("flag_close_call")) scr_ch2_calder_retry();
            else scr_ch2_gallows_start();
            return true;

        // ---- §8–9 After the rescue ----
        case "WF_JOIN_R1":
            scr_dialogue_play(["WF_JOIN_R1"]);
            return true;
        case "WF_TAVERN_B1":
            scr_dialogue_play(["WF_TAVERN_B1"], function() { scr_inn_offer("Perrin", INN_WRENFIELD_PRICE); });
            return true;
        case "WF_STORE_B1":
            scr_dialogue_play(["WF_STORE_B1"], function() { scr_shop_open("shop_wrenfield_store"); });
            return true;
        case "WF_ODA_B1":
            scr_ch2_oda_after();
            return true;
        case "WF_ODA_B3":
            if (scr_flag_get("flag_bram_spoke")) {
                scr_dialogue_play(["WF_BRAM_B1"]);
            } else {
                scr_dialogue_play(["WF_ODA_B3"], function() { scr_flag_set("flag_bram_spoke"); });
            }
            return true;
    }
    return false;
}

/// The Taren hook was heard (Pell, Corwin, the traveler or the notice). On the road itself this
/// also moves the main quest to S2 (the script: S1 completes once Kael takes the Millhaven road).
function scr_ch2_hook_heard() {
    scr_flag_set("flag_hook_taren");
    if (scr_ch2_room_is("rm_millhaven_road")) scr_ch2_quest_set("Q_MAIN_BEYOND_VEIL", "Q_BV_S2");
}

// ------------------------------------------------------------------------------------------------
// Oda — Q_SIDE_ODA "The One on the List"

function scr_ch2_oda_before() {
    if (scr_flag_get("flag_oda_accepted")) {
        scr_dialogue_play(["WF_ODA_A3_YES"]);
        return;
    }
    scr_dialogue_play(["WF_ODA_A1"], function() {
        var _n = scr_dialogue_node("WF_ODA_A2");
        var _lines = is_struct(_n) ? _n.lines : ["Accept?"];
        scr_dialogue_choice(_lines, "", ["Yes", "No"], function(_idx) {
            if (_idx == 0) {
                scr_flag_set("flag_oda_accepted");
                scr_ch2_quest_set("Q_SIDE_ODA", "Q_SO_S1");
                scr_dialogue_play(["WF_ODA_A3_YES"]);
            } else {
                scr_dialogue_play(["WF_ODA_A4_NO"]);
            }
        });
    });
}

/// After the rescue. Works whether or not she was spoken to before (one-talk start + finish).
function scr_ch2_oda_after() {
    if (scr_flag_get("flag_oda_done")) {
        scr_dialogue_play(["WF_ODA_B1"]);
        return;
    }
    scr_dialogue_play(["WF_ODA_B1", "WF_ODA_B2"], function() {
        scr_loot_grant_entry("Minor Potion x2");
        scr_loot_grant_entry("40 Gold");
        scr_flag_set("flag_oda_done");
        scr_ch2_quest_set("Q_SIDE_ODA", "complete");
    });
}

// ------------------------------------------------------------------------------------------------
// The gallows, Taren's join, and the Calder fight

function scr_ch2_gallows_start() {
    scr_game_state_init();
    if (variable_struct_exists(global.game, "ch2_gallows_running") && global.game.ch2_gallows_running) return;
    global.game.ch2_gallows_running = true;
    scr_dialogue_play(["WF_GALLOWS_01", "WF_GALLOWS_02", "WF_GALLOWS_03", "WF_GALLOWS_04", "WF_GALLOWS_05", "WF_GALLOWS_06", "WF_GALLOWS_07"], function() {
        // WF_GALLOWS_07: the rope parts. Swap the right gallows to the cut tile and drop Bram.
        scr_flag_set("flag_close_call");
        scr_ch2_show_rope_cut();
        scr_dialogue_play(["WF_GALLOWS_08",
            "WF_CALDER_INTRO_01", "WF_CALDER_INTRO_02", "WF_CALDER_INTRO_03", "WF_CALDER_INTRO_04",
            "WF_CALDER_INTRO_05", "WF_CALDER_INTRO_06", "WF_CALDER_INTRO_07"], function() {
            global.game.ch2_gallows_running = false;
            scr_ch2_calder_fight_start();
        });
    });
}

/// After a loss to Calder (or a reload between the close call and the fight): straight back in.
function scr_ch2_calder_retry() {
    scr_dialogue_play(["WF_CALDER_INTRO_07"], function() { scr_ch2_calder_fight_start(); });
}

function scr_ch2_show_rope_cut() {
    scr_wf_cut_rope();
    var _bram = scr_ch2_find_marker_inst("bram_noosed");
    if (_bram != noone) scr_ch2_swap_sprite(_bram, "spr_bram_bound_ow16_idle_down");
}

/// Taren joins at the start of the fight (2nd slot, at Kael's level), then the battle starts.
function scr_ch2_calder_fight_start() {
    if (scr_ch2_taren_join()) {
        scr_dialogue_play(["WF_CALDER_SYS_01", "WF_CALDER_SYS_02", "WF_CALDER_SYS_03", "WF_CALDER_SYS_03B"], function() {
            scr_encounter_start("grp_reeve_calder", "enc_reeve_calder", "WF_CALDER");
        });
    } else {
        scr_encounter_start("grp_reeve_calder", "enc_reeve_calder", "WF_CALDER");
    }
}

/// Returns true the first time (Taren newly added). Uses the balance pass's raise-to-level helper.
function scr_ch2_taren_join() {
    scr_game_state_init();
    if (scr_flag_get("flag_taren_in_battle")) return false;
    var _t = scr_roster_find(global.game.roster, "taren");
    if (!is_struct(_t)) return false;
    if (!_t.joined) scr_party_join("taren");
    var _kael = scr_roster_find(global.game.roster, "kael");
    var _lv = is_struct(_kael) ? _kael.level : 1;
    if (_t.level < _lv) scr_actor_raise_to_level(_t, _lv);
    scr_flag_set("flag_taren_in_battle");
    return true;
}

/// From scr_battle_finish. A Calder win (he yields) frees the accused and queues §7.2–§8.
function scr_ch2_on_battle_finish(_result, _pending) {
    if (!is_struct(_pending) || _result != "victory") return;
    if (!variable_struct_exists(_pending, "encounter_id") || _pending.encounter_id != "enc_reeve_calder") return;
    scr_flag_set("flag_execution_stopped");
    // WF_CALDER_DEFEAT_01 was his yield line in battle; the rest plays back in the square.
    global.game.pending_post_dialogue = [
        "WF_CALDER_DEFEAT_02", "WF_CALDER_DEFEAT_03", "WF_CALDER_DEFEAT_04", "WF_CALDER_DEFEAT_05", "WF_CALDER_REWARD_01",
        "WF_JOIN_01", "WF_JOIN_02", "WF_JOIN_03", "WF_JOIN_04", "WF_JOIN_05", "WF_JOIN_06",
        "WF_JOIN_07", "WF_JOIN_08", "WF_JOIN_09", "WF_JOIN_10", "WF_JOIN_11", "WF_JOIN_12"
    ];
    global.game.pending_post_callback = function() {
        scr_flag_set("flag_taren_recruited");
        scr_ch2_quest_set("Q_MAIN_BEYOND_VEIL", "Q_BV_S3");
        if (scr_flag_get("flag_oda_accepted") && !scr_flag_get("flag_oda_done")) scr_ch2_quest_set("Q_SIDE_ODA", "Q_SO_S2");
    };
}

// ------------------------------------------------------------------------------------------------
// Patrol prelude (obj_encounter_trigger with a script chain): bark, then fight or move along.

function scr_ch2_encounter_prelude(_trig) {
    if (_trig == noone || !instance_exists(_trig)) return;
    var _ctx = { trig: _trig, chain: _trig.pre_chain, enc: _trig.encounter_id, eid: _trig.enemy_id, avoid: _trig.avoidable };
    scr_dialogue_play(_ctx.chain, method(_ctx, function() {
        var _go = method(self, function() {
            // The road patrol is the two soldiers on the map (PLACEHOLDER pair, balance pass cap of 2).
            var _ids = (enc == "enc_crown_patrol") ? ["crown_patrolman", "crown_patrolman"] : eid;
            scr_encounter_start(_ids, enc);
        });
        if (!avoid) { _go(); return; }
        scr_dialogue_choice(["(The patrol waits.)"], "", ["Fight", "Move along"], method({ go: _go, trig: trig, enc: enc }, function(_idx) {
            if (_idx == 0) { go(); return; }
            scr_flag_set("avoided_" + enc);
            if (trig != noone && instance_exists(trig)) trig.passive = true;
        }));
    }));
}

// ------------------------------------------------------------------------------------------------
// West road: chapter end (§10). Called by obj_zone_entrance when its marker has a script_id.

function scr_ch2_exit_script(_door) {
    if (_door == noone || !instance_exists(_door) || !is_struct(_door.map_marker)) return false;
    var _m = _door.map_marker;
    if (!variable_struct_exists(_m, "name") || _m.name != "west_road_to_valemere") return false;
    var _ctx = { door: _door, m: _m };
    var _leave = method(_ctx, function() {
        // The spawner already swapped in fallback_room / fallback_spawn while rm_valemere_road is missing.
        var _ok = (door != noone && instance_exists(door));
        var _rm = _ok ? door.target_room : -1;
        var _spawn = _ok ? door.target_spawn : "";
        if (_rm == -1 || !room_exists(_rm)) {
            // Chapter 3's rm_valemere_road is not built: stub to the overworld spawn east of Valemere.
            _rm = variable_struct_exists(m, "fallback_room") ? asset_get_index(m.fallback_room) : -1;
            _spawn = variable_struct_exists(m, "fallback_spawn") ? m.fallback_spawn : "";
        }
        if (_rm == -1 || !room_exists(_rm)) return;
        global.map_spawn_name = _spawn;
        room_goto(_rm);
    });
    if (scr_flag_get("flag_chapter2_complete")) {
        _leave();
        return true;
    }
    scr_dialogue_play(["WF_HANDOFF_01", "WF_HANDOFF_02", "WF_HANDOFF_03", "WF_HANDOFF_04", "WF_HANDOFF_05", "CH2_TBC"], method({ leave: _leave }, function() {
        scr_flag_set("flag_chapter2_complete");
        scr_ch2_quest_set("Q_MAIN_BEYOND_VEIL", "Q_BV_S3");
        global.game.ch2_save_prompt_pending = true; // chapter-end save prompt on arrival
        leave();
    }));
    return true;
}

// ------------------------------------------------------------------------------------------------
// Room start + per-step hooks (obj_game_controller)

function scr_ch2_on_room_start() {
    scr_game_state_init();
    var _g = global.game;
    var _rn = room_get_name(room);
    if (variable_struct_exists(_g, "ch2_save_prompt_pending") && _g.ch2_save_prompt_pending) {
        _g.ch2_save_prompt_pending = false;
        // Quiet: saving only exists in a town with a church or a tavern (owner decision 2026-11-15),
        // so this chapter-end prompt simply does not appear at the Watchtower.
        scr_save_menu_open("save", false, true);
    }
    if (_rn == "rm_old_watchtower" && scr_flag_get("blackguard_defeated") && scr_flag_get("flag_act2_started")) {
        // §1: the Blackguard's empty armor where he fell (boss_spawn tile 29,6). Inspect spot only.
        var _o = asset_get_index("obj_interactable");
        if (_o != -1 && scr_ch2_find_marker_inst("ch2_blackguard_armor") == noone) {
            var _lay = layer_exists("Instances") ? "Instances" : layer_get_name(layer_create(0, "Instances"));
            var _a = scr_map_create_at_feet(_o, _lay, 472, 112);
            scr_map_fit_to_tile(_a, 472, 112);
            _a.script_id = "CV_WAKE_ARMOR";
            _a.dialogue_lines = ["Empty armor in a heap of ash. Whoever wore it is gone."];
            _a.map_marker = { type: "lore", name: "ch2_blackguard_armor", tile_x: 29, tile_y: 6, x: 472, y: 112 };
            _a.visible = false; // no ash-heap sprite yet (open placeholder)
        }
    }
    if (_rn == "rm_wrenfield" && scr_flag_get("flag_close_call") && !scr_flag_get("flag_execution_stopped")) {
        // Back after a loss to Calder: the rope is still cut and the fight resumes.
        scr_ch2_show_rope_cut();
        if (!_g.battle_active) scr_ch2_calder_retry();
    }
}

function scr_ch2_tick() {
    scr_game_state_init();
    var _g = global.game;
    // §1 CV_WAKE: after the Chapter 1 save prompt closes, or when that save is loaded.
    if (!scr_flag_get("flag_chapter1_complete") || scr_flag_get("flag_act2_started")) return;
    if (!scr_ch2_room_is("rm_old_watchtower") || scr_input_locked()) return;
    var _sm = asset_get_index("obj_save_menu");
    if (_sm != -1 && instance_exists(_sm)) return;
    if (variable_struct_exists(_g, "ch2_wake_running") && _g.ch2_wake_running) return;
    _g.ch2_wake_running = true;
    scr_dialogue_play(["CV_WAKE_01", "CV_WAKE_02", "CV_WAKE_03", "CV_WAKE_04", "WT2_BACK_01"], function() {
        global.game.ch2_wake_running = false;
        scr_flag_set("flag_act2_started");
        scr_ch2_quest_set("Q_MAIN_BEYOND_VEIL", "Q_BV_S1");
    });
}
