/// obj_story_npc : Create
/// Non-hostile talking character. Default: Fallen Knight story beats FK_01 / FK_02
/// (CHAPTER1_SCRIPT.md §5.1 / §6.3). Do NOT parent this to obj_solid — the player
/// must be able to walk onto the tile. Talking (face+confirm, or walking onto the
/// tile once armed) plays script_id; when the scene finishes, story_flag is set
/// and the instance is destroyed (the walk-off is not animated yet).
script_id = "";
story_flag = "";
npc_id = "";
armed = false;

interact = function() {
    if (scr_input_locked()) return;
    if (script_id == "") return;
    // Don't start twice while the box or queue is already running this scene.
    if (global.game.dialogue_open || instance_exists(obj_dialogue_box)) return;
    var _self = id;
    if (!scr_dialogue_play_script(script_id, _self)) {
        scr_dialogue_open(["[Placeholder: " + npc_id + "]"], "");
    }
};
