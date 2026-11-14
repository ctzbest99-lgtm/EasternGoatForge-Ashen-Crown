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
    }
    return undefined;
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
