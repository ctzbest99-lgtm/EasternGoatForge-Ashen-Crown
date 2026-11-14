/// obj_story_encounter : Create
/// Default: the guaranteed first Ashbound Hunter fight in the Old Watchtower
/// (`enc_ashbound_hunter_wt`, CHAPTER1_SCRIPT.md §4.1 / §6). Place on a set tile
/// before the banner room. Do NOT parent this to obj_solid.
///
/// Design picks the exact tile. Until rm_watchtower exists, a copy can be placed
/// in rm_overworld for testing.
encounter_id = "enc_ashbound_hunter_wt";
enemy_id = "ashbound_hunter";
script_id = "ENC_ASHBOUND_HUNTER";

// Only fires after the player has been seen OFF the trigger.
armed = false;
visible = DEBUG_SHOW_TRIGGERS;
