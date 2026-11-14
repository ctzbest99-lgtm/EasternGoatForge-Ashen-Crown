/// obj_interactable : Create
/// Sign, NPC, chest, lore, or pickup. Parent: obj_solid.
/// script_id plays a CHAPTER1_SCRIPT.md scene when set. Chests / items call
/// scr_loot_grant so pickups actually land in global.game.inventory (or gold).
speaker_name = "";
dialogue_lines = [
    "[Placeholder sign text. Final wording not approved.]",
    "[Second placeholder line. Press confirm to close.]"
];
struck_lines = [];
script_id = "";
script_chain = undefined;
repeat_script_id = "";
story_flag = "";
item_id = "";
loot = undefined;
npc_id = "";
shop_id = "";
map_marker = undefined;

interact = function() {
    if (is_struct(map_marker) && !scr_map_requirement_met(map_marker)) {
        if (script_id != "" && scr_dialogue_play_script(script_id, id)) return;
        scr_dialogue_open(dialogue_lines, speaker_name, struck_lines);
        return;
    }
    var _loot_name = is_struct(map_marker) ? map_marker.name : "";
    if ((_loot_name != "" && scr_flag_get("looted_" + _loot_name))
        || (item_id != "" && scr_inventory_has(item_id) && script_id != "GH_HOUSE_03")
        || (story_flag != "" && scr_flag_get(story_flag) && (item_id != "" || is_array(loot)))) {
        // Unique pickups disappear after being taken; a leftover instance reads as empty.
        if (script_id == "GH_HOUSE_03" || script_id == "WT_KEY_01") {
            scr_dialogue_open(["[Nothing else here.]"], "");
            return;
        }
        if (is_array(loot) || item_id != "") {
            scr_dialogue_open(["[Empty.]"], "");
            return;
        }
    }
    if (script_id != "" && scr_dialogue_play_script(script_id, id)) return;
    if (is_array(script_chain) && array_length(script_chain) > 0) {
        var _self = id;
        scr_dialogue_play(script_chain, method({ src: _self }, function() {
            scr_pickup_from_instance(src);
        }));
        return;
    }
    if (item_id != "" || (is_array(loot) && array_length(loot) > 0 && !scr_loot_is_placeholder(loot))) {
        var _self2 = id;
        var _lines = dialogue_lines;
        if (!is_array(_lines) || array_length(_lines) == 0) _lines = ["Obtained."];
        var _box = scr_dialogue_open(_lines, speaker_name, struck_lines);
        // Grant immediately so a close-without-callback still leaves the item in the bag.
        scr_pickup_from_instance(_self2);
        return;
    }
    scr_dialogue_open(dialogue_lines, speaker_name, struck_lines);
};
