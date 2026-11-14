/// obj_story_npc : Room Start   (Other > Room Start)
/// Remove the instance if this story beat has already played.
scr_game_state_init();
if (story_flag != "" && scr_flag_get(story_flag)) {
    instance_destroy();
}
