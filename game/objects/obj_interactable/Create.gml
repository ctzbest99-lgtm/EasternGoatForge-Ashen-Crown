/// obj_interactable : Create
/// Placeholder sign/object the player can talk to by facing it and pressing confirm.
/// Recommended parent: obj_solid (so the player cannot walk through it).
/// Override per instance in the Room Editor's Instance Creation Code, e.g.:
///     speaker_name = "";
///     dialogue_lines = ["[Placeholder line 1]", "[Placeholder line 2]"];
/// Final sign/NPC wording is not approved; keep text as placeholders.
speaker_name = "";
dialogue_lines = [
    "[Placeholder sign text. Final wording not approved.]",
    "[Second placeholder line. Press confirm to close.]"
];

interact = function() {
    scr_dialogue_open(dialogue_lines, speaker_name);
};
