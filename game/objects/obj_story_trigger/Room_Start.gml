/// obj_story_trigger : Room Start
scr_game_state_init();
if (story_flag != "" && scr_flag_get(story_flag)) {
    instance_destroy();
}
