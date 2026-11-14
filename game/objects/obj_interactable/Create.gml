/// obj_interactable : Create
/// Placeholder sign/object the player can talk to by facing it and pressing confirm.
/// Recommended parent: obj_solid (so the player cannot walk through it).
/// Override per instance, or let scr_map_spawn_markers fill these from map data.
/// Confirmed Chapter 1 sign wording comes from the marker's lines / struck_lines.
/// script_id, when set, plays the matching CHAPTER1_SCRIPT.md scene instead of dialogue_lines.
speaker_name = "";
dialogue_lines = [
    "[Placeholder sign text. Final wording not approved.]",
    "[Second placeholder line. Press confirm to close.]"
];
struck_lines = [];
script_id = "";
story_flag = "";
item_id = "";
npc_id = "";

interact = function() {
    if (script_id != "" && scr_dialogue_play_script(script_id, id)) return;
    scr_dialogue_open(dialogue_lines, speaker_name, struck_lines);
};
