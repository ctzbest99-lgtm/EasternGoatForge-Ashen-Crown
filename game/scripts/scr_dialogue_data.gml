/// scr_dialogue_data — Chapter 1 dialogue nodes keyed by stable IDs from
/// docs/story/CHAPTER1_SCRIPT.md (ZONE_PLACE_NN). Text is verbatim from the script.
/// Speaker "" is NARRATION (no name in the box).

function scr_dialogue_node(_id) {
    switch (_id) {
        // ENC_ASHBOUND_HUNTER (CHAPTER1_SCRIPT.md §4.1)
        case "ENC_AH_01": // NARRATION [CANON event]
            return { id: "ENC_AH_01", speaker: "", lines: ["An arrow slams into the dirt beside Kael's boot."] };
        case "ENC_AH_02": // Kael [C-confirmed]
            return { id: "ENC_AH_02", speaker: "Kael", lines: ["That was a warning. Or a bad shot. Let's find out which."] };
        case "ENC_AH_03": // NARRATION, after victory, first time [CANON object]
            return { id: "ENC_AH_03", speaker: "", lines: ["A folded parchment is tucked inside the hunter's coat."] };
        case "ENC_AH_04": // Parchment [CANON text, verbatim]
            return { id: "ENC_AH_04", speaker: "Parchment", lines: ["“Find the girl. The Varyn girl is still alive.”"] };
        case "ENC_AH_05": // Kael [C-confirmed] — two lines, one box
            return { id: "ENC_AH_05", speaker: "Kael", lines: ["Alive.", "...Then who else is looking for her?"] };

        // GH_TOMAS (CHAPTER1_SCRIPT.md §1.2) — talking to Pell or Tomas starts the scene
        case "GH_TOMAS_01": // Pell [C-confirmed]
            return { id: "GH_TOMAS_01", speaker: "Pell", lines: ["Kael? Gods. He kept saying you'd come. Over here. Careful."] };
        case "GH_TOMAS_02": // Kael
            return { id: "GH_TOMAS_02", speaker: "Kael", lines: ["Father."] };
        case "GH_TOMAS_03": // Tomas
            return { id: "GH_TOMAS_03", speaker: "Tomas", lines: ["Kael... you came home."] };
        case "GH_TOMAS_04": // Kael
            return { id: "GH_TOMAS_04", speaker: "Kael", lines: ["Don't talk. Where's Mira?"] };
        case "GH_TOMAS_05": // Tomas [CANON]
            return { id: "GH_TOMAS_05", speaker: "Tomas", lines: ["“Your sister… she went into the woods.”"] };
        case "GH_TOMAS_06": // Kael
            return { id: "GH_TOMAS_06", speaker: "Kael", lines: ["The woods? Why would she—"] };
        case "GH_TOMAS_07": // Pell [C-confirmed]
            return { id: "GH_TOMAS_07", speaker: "Pell", lines: ["He's been like that since. In and out. I'll stay with him. Go."] };
        case "GH_TOMAS_08": // Kael
            return { id: "GH_TOMAS_08", speaker: "Kael", lines: ["Keep him breathing. I'll be back."] };
        case "GH_TOMAS_R1": // NARRATION, repeat talk with Tomas [C-confirmed]
            return { id: "GH_TOMAS_R1", speaker: "", lines: ["He's breathing. Barely."] };
        case "GH_TOMAS_R2": // Pell, repeat talk [C-confirmed]
            return { id: "GH_TOMAS_R2", speaker: "Pell", lines: ["I've got him. Find her, Kael."] };

        // GH_HOUSE_03 (CHAPTER1_SCRIPT.md §1.3) — Mira's pendant under the bed rubble
        case "GH_HOUSE_03": // NARRATION [CANON event]
            return { id: "GH_HOUSE_03", speaker: "", lines: ["Under the ash and splinters: a small wooden pendant on a cord.", "Mira's."] };
        case "GH_HOUSE_04": // SYSTEM
            return { id: "GH_HOUSE_04", speaker: "SYSTEM", lines: ["Obtained: Mira's Wooden Pendant (Story Item)."] };
        case "GH_HOUSE_05": // Kael
            return { id: "GH_HOUSE_05", speaker: "Kael", lines: ["No body. That means something.", "...It has to."] };

        // FK_01 (CHAPTER1_SCRIPT.md §5.1)
        case "FK_01_01":
            return { id: "FK_01_01", speaker: "Fallen Knight", lines: ["...Varyn."] };
        case "FK_01_02":
            return { id: "FK_01_02", speaker: "Kael", lines: ["You know me?"] };
        case "FK_01_03": // [CANON]
            return { id: "FK_01_03", speaker: "Fallen Knight", lines: ["“Your father knew what was coming.”"] };
        case "FK_01_04":
            return { id: "FK_01_04", speaker: "Kael", lines: ["What's that supposed to mean? Hey—!"] };

        // FK_02 (CHAPTER1_SCRIPT.md §6.3)
        case "FK_02_01":
            return { id: "FK_02_01", speaker: "Kael", lines: ["You. Talk. Where is my sister?"] };
        case "FK_02_02": // [CANON]
            return { id: "FK_02_02", speaker: "Fallen Knight", lines: ["“She opened the door.”"] };
        case "FK_02_03":
            return { id: "FK_02_03", speaker: "Kael", lines: ["What door? —"] };

        // WT_BANNER (CHAPTER1_SCRIPT.md §6.2)
        case "WT_BANNER_01":
            return { id: "WT_BANNER_01", speaker: "", lines: ["An old royal banner hangs in tatters. The symbol stitched at its center..."] };
        case "WT_BANNER_02": // [CANON]
            return { id: "WT_BANNER_02", speaker: "", lines: ["...is the same mark carved on Mira's pendant."] };
        case "WT_BANNER_03":
            return { id: "WT_BANNER_03", speaker: "Kael", lines: ["A royal banner. Mira's pendant. Same mark.", "Why would the crown share anything with a girl from Greyhaven?"] };
    }
    return undefined;
}

/// Play a named scene (marker script_id) from CHAPTER1_SCRIPT.md. Returns true if
/// this function handled the id (even if it only queued a repeat line). _source
/// is the interacting instance, or noone.
function scr_dialogue_play_script(_script_id, _source = noone) {
    scr_game_state_init();
    switch (_script_id) {
        case "GH_TOMAS":
            if (scr_flag_get("flag_met_tomas")) {
                var _npc = "";
                if (_source != noone && instance_exists(_source) && variable_instance_exists(_source, "npc_id")) {
                    _npc = _source.npc_id;
                }
                if (_npc == "pell") scr_dialogue_play(["GH_TOMAS_R2"]);
                else scr_dialogue_play(["GH_TOMAS_R1"]);
            } else {
                scr_dialogue_play(
                    ["GH_TOMAS_01", "GH_TOMAS_02", "GH_TOMAS_03", "GH_TOMAS_04", "GH_TOMAS_05", "GH_TOMAS_06", "GH_TOMAS_07", "GH_TOMAS_08"],
                    function() { scr_flag_set("flag_met_tomas"); }
                );
            }
            return true;
        case "GH_HOUSE_03":
            if (scr_flag_get("flag_pendant_found") || scr_inventory_has("item_mira_pendant")) return true;
            var _item_src = _source;
            scr_dialogue_play(["GH_HOUSE_03", "GH_HOUSE_04", "GH_HOUSE_05"], method({ src: _item_src }, function() {
                scr_inventory_add("item_mira_pendant", "Mira's Wooden Pendant", 1, true);
                scr_flag_set("flag_pendant_found");
                if (src != noone && instance_exists(src)) instance_destroy(src);
            }));
            return true;
        case "FK_01":
            if (scr_flag_get("flag_fk_seen_1")) return true;
            var _fk1 = _source;
            scr_dialogue_play(["FK_01_01", "FK_01_02", "FK_01_03", "FK_01_04"], method({ src: _fk1 }, function() {
                scr_flag_set("flag_fk_seen_1");
                if (src != noone && instance_exists(src)) instance_destroy(src);
            }));
            return true;
        case "FK_02":
            if (scr_flag_get("flag_fk_seen_2")) return true;
            var _fk2 = _source;
            scr_dialogue_play(["FK_02_01", "FK_02_02", "FK_02_03"], method({ src: _fk2 }, function() {
                scr_flag_set("flag_fk_seen_2");
                if (src != noone && instance_exists(src)) instance_destroy(src);
            }));
            return true;
        case "WT_BANNER":
            if (scr_flag_get("flag_banner_clue")) {
                // Allow a re-read of the clue; do not replay Kael's first reaction only? Keep full scene for now.
            }
            scr_dialogue_play(["WT_BANNER_01", "WT_BANNER_02", "WT_BANNER_03"], function() {
                scr_flag_set("flag_banner_clue");
            });
            return true;
    }
    return false;
}

/// Queue dialogue node IDs and optionally a callback that runs when the sequence finishes.
/// Each node uses its own speaker. The queue is advanced by obj_game_controller : Begin Step.
function scr_dialogue_play(_node_ids, _on_finish = undefined) {
    scr_game_state_init();
    var _g = global.game;
    if (!is_array(_node_ids)) _node_ids = [_node_ids];
    for (var _i = 0; _i < array_length(_node_ids); _i++) {
        array_push(_g.dialogue_queue, _node_ids[_i]);
    }
    if (!is_undefined(_on_finish)) _g.dialogue_on_finish = _on_finish;
    scr_dialogue_try_advance_queue();
}

/// Open the next queued node, or run the finish callback when the queue is empty.
/// Safe to call every frame; does nothing while a box is open, or during battle/transition.
function scr_dialogue_try_advance_queue() {
    scr_game_state_init();
    var _g = global.game;
    if (_g.dialogue_open || instance_exists(obj_dialogue_box)) return;
    if (_g.battle_active || _g.transition_active) return;

    while (array_length(_g.dialogue_queue) > 0) {
        var _id = _g.dialogue_queue[0];
        array_delete(_g.dialogue_queue, 0, 1);
        var _node = scr_dialogue_node(_id);
        if (!is_struct(_node)) continue;
        var _box = scr_dialogue_open(_node.lines, _node.speaker);
        if (_box != noone) return;
    }

    if (!is_undefined(_g.dialogue_on_finish)) {
        var _cb = _g.dialogue_on_finish;
        _g.dialogue_on_finish = undefined;
        _cb();
    }
}
