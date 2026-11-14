/// obj_encounter_zone : Create
/// Stretch this instance over a wild area. Do NOT parent it to obj_solid.
/// The player's collision mask must overlap the zone to use its table.
///
/// Default table is zone01_path (3:1 Bandit / Fallen Knight). Override per instance:
///     table_id = "zone01_path";
///     enemy_table = [{ enemy_id: "bandit", weight: 3 }, { enemy_id: "fallen_knight", weight: 1 }];
/// If table_id is set and found in scr_get_encounter_table(), it wins; otherwise enemy_table is used.
/// Towns and the respawn stand-in should have no zone (safe).
table_id = "zone01_path";
enemy_table = scr_get_encounter_table("zone01_path");
visible = DEBUG_SHOW_TRIGGERS;
