/// scr_quest — quest payouts. Dialogue sets a quest flag; this turns that flag into an item exactly once,
/// guarded by a "<flag>_paid" flag that is saved alongside everything else.
///
/// It scans for unpaid rewards instead of firing on the moment a flag is set, so calling it twice is
/// harmless and a reward can also be recovered after loading an older save that never paid out.

/// @desc Item granted for finishing a quest, or "" when the flag is not a quest reward.
function scr_quest_reward_item(_flag) {
    switch (_flag) {
        case "npc_hermit_quest": return "hi_potion";
    }
    return "";
}

/// @desc The current stage of the Hermit's quest as one short line, or "" when there is nothing to show.
/// Derived from the story flags alone, so no quest state is stored anywhere else and loading a save puts
/// the HUD back on the right stage. Later stages are tested first, because the flags accumulate.
function scr_quest_stage(_flags) {
    if (is_undefined(_flags)) return "";
    /// A finished quest leaves the panel blank instead of sitting on "Complete" forever: the line going
    /// away is the completion signal, and the Hermit's check-off scene says it in words.
    if (scr_flags_has(_flags, "npc_hermit_quest_done")) return "";
    /// The door only counts once the quest has been taken, so finding it early cannot skip a stage.
    if (scr_flags_has(_flags, "npc_hermit_quest")) {
        if (scr_flags_has(_flags, "ruin_door_found")) return "Tell the Hermit";
        return "Find the ruin door";
    }
    if (scr_flags_has(_flags, "npc_hermit_met")) return "Hear the Hermit out";
    return "";
}

/// @desc The flag that records a payout, so the reward cannot be collected twice.
function scr_quest_paid_flag(_flag) {
    return _flag + "_paid";
}

/// @desc One line describing what was granted, e.g. "Received Hi-Potion." Empty when nothing was.
function scr_quest_reward_text(_granted) {
    var _count = array_length(_granted);
    if (_count <= 0) return "";
    var _text = "Received ";
    for (var _i = 0; _i < _count; _i++) {
        if (_i > 0) _text += ", ";
        _text += _granted[_i].name;
    }
    return _text + ".";
}

/// @desc Grant every quest reward whose flag is set and unpaid. Returns an array of granted
/// { flag, item, name } structs, in flag order. Safe to call as often as you like.
function scr_quest_pay_out(_flags, _party) {
    var _granted = [];
    if (is_undefined(_flags) || is_undefined(_party)) return _granted;
    if (!variable_struct_exists(_party, "items")) return _granted;

    /// Iterate a copy: setting the paid flag appends to the live list, and a growing loop would
    /// revisit entries.
    var _known = scr_flags_copy(_flags);
    var _count = array_length(_known);
    for (var _i = 0; _i < _count; _i++) {
        var _flag = _known[_i];
        var _item = scr_quest_reward_item(_flag);
        if (_item == "") continue;
        if (scr_flags_has(_flags, scr_quest_paid_flag(_flag))) continue;
        scr_inventory_add(_party.items, _item, 1);
        scr_flags_set(_flags, scr_quest_paid_flag(_flag));
        var _data = scr_item_data(_item);
        var _name = is_undefined(_data) ? _item : _data.name;
        array_push(_granted, { flag: _flag, item: _item, name: _name });
        global.last_quest_reward = _name;
    }
    return _granted;
}
