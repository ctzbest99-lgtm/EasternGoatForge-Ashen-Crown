/// obj_story_encounter : Create
/// Default: the guaranteed first Ashbound Hunter fight in the Old Watchtower
/// (`enc_ashbound_hunter_wt`, CHAPTER1_SCRIPT.md §4.1 / §6). Do NOT parent this
/// to obj_solid. scr_build_old_watchtower already spawns one instance on
/// walkable tile (41, 23), two tiles north of old_royal_banner (41, 25), so the banner's 16×16 collision cannot cover the trigger.
/// Do not also hand-place a second trigger on that tile.
encounter_id = "enc_ashbound_hunter_wt";
enemy_id = "ashbound_hunter";
script_id = "ENC_ASHBOUND_HUNTER";

// Only fires after the player has been seen OFF the trigger.
armed = false;
visible = DEBUG_SHOW_TRIGGERS;
