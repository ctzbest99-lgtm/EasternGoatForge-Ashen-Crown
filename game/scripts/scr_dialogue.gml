/// scr_dialogue — dialogue scripts and playback state, with no input and no drawing.
/// A script is data: a speaker and ordered lines. obj_dialogue_box draws it and translates keys, so the
/// flow (open, reveal, advance, close) can be tested without a window. Requires GameMaker 2.3+.

/// A closing press and the NPC's "talk" press are the same physical key, so a short window after a
/// dialogue closes prevents it from immediately reopening.
#macro DIALOGUE_REOPEN_COOLDOWN_MS 250
/// Typewriter speed. Reads as brisk narration rather than a slow teletype.
#macro DIALOGUE_CHARS_PER_SECOND 45

/// @desc A dialogue script, or undefined for an unknown id.
function scr_dialogue_data(_script_id) {
    switch (_script_id) {
        case "npc_hermit":
            return {
                id: "npc_hermit",
                speaker: "Hermit",
                lines: [
                    "You came up the old road? Then you saw the smoke.",
                    "Ashen Crown took the keep a season ago. Nobody who went in came back out.",
                    "Take the potions in your bag. You will need them before the ruins."
                ],
                /// Reaching the end of this scene is what starts the quest.
                set_flag: "npc_hermit_met"
            };
        case "npc_hermit_after":
            return {
                id: "npc_hermit_after",
                speaker: "Hermit",
                lines: [
                    "You still have the potions? Good. The ruin door will not open for the dead.",
                    "Come back when you have seen what is inside. I will be here, as always."
                ],
                requires: "npc_hermit_met",
                set_flag: "npc_hermit_quest"
            };
        case "npc_hermit_checkoff":
            return {
                id: "npc_hermit_checkoff",
                speaker: "Hermit",
                lines: [
                    "So you found the door. And it has been opened from the inside.",
                    "Then the keep is not empty after all.",
                    "Go carefully. I have nothing left to give you but warning."
                ],
                /// Needs the quest taken and the door actually seen, not just one of the two.
                requires_all: ["npc_hermit_quest", "ruin_door_found"],
                set_flag: "npc_hermit_quest_done"
            };
        case "ruin_door":
            return {
                id: "ruin_door",
                speaker: "Ruin Door",
                lines: [
                    "A door of black iron, warped in its frame.",
                    "Fresh scrapes across the threshold. Something has been going in and out.",
                    "The Hermit should hear about this."
                ],
                set_flag: "ruin_door_found"
            };
        case "ruin_door_locked":
            return {
                id: "ruin_door_locked",
                speaker: "Ruin Door",
                lines: [
                    "The door will not move. Something on the far side is holding it.",
                    "The Hermit knew about this before you did. Ask him what he is not saying."
                ]
            };
        case "sign_ruins":
            return {
                id: "sign_ruins",
                speaker: "Weathered Sign",
                lines: [
                    "ASHEN CROWN - KEEP ROAD. NO PASSAGE AFTER DUSK."
                ]
            };
    }
    return undefined;
}

/// @desc Every dialogue id, in menu order.
function scr_dialogue_ids() {
    return ["npc_hermit", "npc_hermit_after", "npc_hermit_checkoff", "ruin_door", "ruin_door_locked", "sign_ruins"];
}

/// @desc True when the script exists and its `requires` flag (if any) is set.
function scr_dialogue_playable(_script_id, _flags) {
    var _data = scr_dialogue_data(_script_id);
    if (is_undefined(_data)) return false;
    var _requires = variable_struct_exists(_data, "requires") ? _data.requires : "";
    if (_requires != "" && !scr_flags_has(_flags, _requires)) return false;
    /// requires_all gates on several flags at once, for scenes that only make sense once both halves of a
    /// quest are true.
    if (variable_struct_exists(_data, "requires_all")) {
        var _all = _data.requires_all;
        for (var _i = 0; _i < array_length(_all); _i++) {
            if (!scr_flags_has(_flags, _all[_i])) return false;
        }
    }
    return true;
}

/// @desc Pick the furthest-along script in a chain that is currently playable, else the first entry.
/// The NPC lists its scenes in order; the flags decide how far along the player is, so no visit counter
/// and no per-NPC branching code is needed.
function scr_dialogue_pick_chain(_chain, _flags) {
    var _count = array_length(_chain);
    if (_count <= 0) return "";
    for (var _i = _count - 1; _i >= 0; _i--) {
        if (scr_dialogue_playable(_chain[_i], _flags)) return _chain[_i];
    }
    return _chain[0];
}

/// @desc Two-script convenience wrapper over scr_dialogue_pick_chain.
function scr_dialogue_pick(_primary_id, _alternative_id, _flags) {
    return scr_dialogue_pick_chain([_primary_id, _alternative_id], _flags);
}

/// @desc Apply a script's `set_flag`, if it has one. Returns the flag name, or "".
function scr_dialogue_apply_flag(_script_id, _flags) {
    var _data = scr_dialogue_data(_script_id);
    if (is_undefined(_data) || !variable_struct_exists(_data, "set_flag")) return "";
    scr_flags_set(_flags, _data.set_flag);
    return _data.set_flag;
}

/// @desc A closed dialogue state.
function scr_dialogue_create() {
    return { open: false, id: "", speaker: "", lines: [], index: 0, reveal: 0, reveal_clock: 0, reward: false };
}

/// @desc Start a script on this state. Returns false for an unknown id or an empty script.
function scr_dialogue_open(_dialogue, _script_id) {
    var _data = scr_dialogue_data(_script_id);
    if (is_undefined(_data) || array_length(_data.lines) == 0) return false;
    _dialogue.open = true;
    _dialogue.id = _data.id;
    _dialogue.speaker = _data.speaker;
    _dialogue.lines = _data.lines;
    _dialogue.index = 0;
    _dialogue.reward = false;
    scr_dialogue_reset_reveal(_dialogue);
    return true;
}

/// @desc The line currently shown, or "" when nothing is open.
function scr_dialogue_current(_dialogue) {
    if (!_dialogue.open || _dialogue.index < 0 || _dialogue.index >= array_length(_dialogue.lines)) return "";
    return _dialogue.lines[_dialogue.index];
}

/// @desc Characters in the current line; 0 when closed.
function scr_dialogue_line_length(_dialogue) {
    return string_length(scr_dialogue_current(_dialogue));
}

/// @desc Restart the typewriter at the beginning of the current line.
function scr_dialogue_reset_reveal(_dialogue) {
    _dialogue.reveal = 0;
    _dialogue.reveal_clock = 0;
    return true;
}

/// @desc True while characters are still appearing.
function scr_dialogue_revealing(_dialogue) {
    return (_dialogue.open && _dialogue.reveal < scr_dialogue_line_length(_dialogue));
}

/// @desc The part of the line that should be drawn. Empty lines and a zero reveal give "".
function scr_dialogue_visible(_dialogue) {
    var _text = scr_dialogue_current(_dialogue);
    var _total = string_length(_text);
    var _shown = clamp(_dialogue.reveal, 0, _total);
    if (_shown <= 0) return "";
    if (_shown >= _total) return _text;
    return string_copy(_text, 1, _shown);
}

/// @desc Advance the typewriter by _delta_us microseconds. Returns true while it is still revealing,
/// so the caller can drive it from delta_time without owning the timing rules.
function scr_dialogue_tick(_dialogue, _delta_us, _chars_per_second = DIALOGUE_CHARS_PER_SECOND) {
    if (!scr_dialogue_revealing(_dialogue)) return false;
    var _total = scr_dialogue_line_length(_dialogue);
    var _step_us = 1000000 / max(1, _chars_per_second);
    _dialogue.reveal_clock += max(0, _delta_us);
    while (_dialogue.reveal_clock >= _step_us && _dialogue.reveal < _total) {
        _dialogue.reveal += 1;
        _dialogue.reveal_clock -= _step_us;
    }
    return _dialogue.reveal < _total;
}

/// @desc Show the whole current line at once. Returns false when it was already complete.
function scr_dialogue_skip(_dialogue) {
    if (!scr_dialogue_revealing(_dialogue)) return false;
    _dialogue.reveal = scr_dialogue_line_length(_dialogue);
    _dialogue.reveal_clock = 0;
    return true;
}

/// @desc True on the last line, so the box can prompt close instead of next.
function scr_dialogue_is_last(_dialogue) {
    return (_dialogue.index >= array_length(_dialogue.lines) - 1);
}

/// @desc Show a single extra page after a scene, used for "Received Hi-Potion." once a quest pays out.
/// This is a fresh one-line scene rather than an appended line, so the script data is never mutated and
/// the page can be shown after the dialogue has already reported itself closed.
function scr_dialogue_show_reward(_dialogue, _text) {
    if (_text == "") return false;
    _dialogue.open = true;
    _dialogue.id = "";
    _dialogue.speaker = "Reward";
    _dialogue.lines = [_text];
    _dialogue.index = 0;
    _dialogue.reward = true;
    scr_dialogue_reset_reveal(_dialogue);
    return true;
}

function scr_dialogue_close(_dialogue) {
    _dialogue.open = false;
    _dialogue.id = "";
    _dialogue.speaker = "";
    _dialogue.lines = [];
    _dialogue.index = 0;
    _dialogue.reward = false;
    scr_dialogue_reset_reveal(_dialogue);
    return true;
}

/// @desc Advance one line, restarting the typewriter. Returns true while the dialogue is still open.
function scr_dialogue_advance(_dialogue) {
    if (!_dialogue.open) return false;
    if (_dialogue.index < array_length(_dialogue.lines) - 1) {
        _dialogue.index += 1;
        scr_dialogue_reset_reveal(_dialogue);
        return true;
    }
    scr_dialogue_close(_dialogue);
    return false;
}

/// @desc One confirm press: complete the line first, advance on the next press.
/// Returns "skipped", "advanced" or "closed". This is the whole reason a fast reader is never forced
/// to wait for the typewriter: any press lands the full line before it can move on.
/// Passing _flags applies the script's set_flag when the scene reaches its natural end. ESC closes through
/// scr_dialogue_close instead, so abandoning a scene cannot complete a quest.
function scr_dialogue_confirm(_dialogue, _flags = undefined) {
    if (!_dialogue.open) return "closed";
    if (scr_dialogue_skip(_dialogue)) return "skipped";
    var _script_id = _dialogue.id;
    if (scr_dialogue_advance(_dialogue)) return "advanced";
    if (!is_undefined(_flags)) scr_dialogue_apply_flag(_script_id, _flags);
    return "closed";
}

/// @desc May a dialogue start right now?
function scr_dialogue_start_allowed(_battle_active, _dialogue_open, _ms_since_close) {
    if (_battle_active) return false;
    if (_dialogue_open) return false;
    return (_ms_since_close >= DIALOGUE_REOPEN_COOLDOWN_MS);
}

/// @desc Spawn the dialogue box for a script. Returns the instance, or noone when it cannot start.
function scr_dialogue_begin(_script_id) {
    var _battle = (variable_global_exists("battle_active") && global.battle_active);
    var _open = (variable_global_exists("dialogue_open") && global.dialogue_open);
    var _since = DIALOGUE_REOPEN_COOLDOWN_MS;
    if (variable_global_exists("dialogue_closed_ms")) _since = current_time - global.dialogue_closed_ms;
    if (!scr_dialogue_start_allowed(_battle, _open, _since)) return noone;
    if (!scr_dialogue_playable(_script_id, scr_flags_ensure_global())) return noone;
    var _obj = asset_get_index("obj_dialogue_box");
    if (_obj < 0) {
        show_debug_message("scr_dialogue_begin: obj_dialogue_box is not in this project");
        return noone;
    }
    return instance_create_depth(0, 0, -100, _obj, { script_id: _script_id });
}
