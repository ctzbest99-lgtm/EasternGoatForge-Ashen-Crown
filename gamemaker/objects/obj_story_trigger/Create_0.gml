/// obj_story_trigger : Create
/// Walk-on story beat (e.g. BG_INTRO on arena entry). Do NOT parent to obj_solid.
/// Fires script_id once, then sets story_flag and destroys itself. If the player
/// spawns already overlapping the trigger, it still fires (armed starts true)
/// so beats like GH_ARRIVAL / arena entry are not missed.
script_id = "";
script_chain = undefined;
story_flag = "";
map_marker = undefined;
armed = true;
fired = false;
visible = DEBUG_SHOW_TRIGGERS;
