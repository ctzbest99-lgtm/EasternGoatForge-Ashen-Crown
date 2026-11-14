/// scr_encounter_tables — named and per-room random encounter tables.
/// Enemy ids must match scr_get_enemy_data(). Rooms/areas not listed here are safe
/// unless an obj_encounter_zone is placed. Towns and TOWN_RESPAWN_ROOM stay safe
/// by default (no room table). Weights are placeholders, pending tuning.

/// Named tables referenced by obj_encounter_zone.table_id, or by room lookup below.
function scr_get_encounter_table(_table_id) {
    switch (_table_id) {
        case "zone01_path":
            // 3:1 Bandit to Fallen Knight. Placeholder weights, not approved rates.
            return [
                { enemy_id: "bandit", weight: 3 },
                { enemy_id: "fallen_knight", weight: 1 }
            ];
    }
    return undefined;
}

/// Whole-room table used when the player is not inside an obj_encounter_zone.
/// Return undefined for safe rooms (towns, interiors, the overworld stand-in town).
/// Example when a dedicated wild room exists:
///     if (_room == rm_wilds) return scr_get_encounter_table("zone01_path");
function scr_get_room_encounter_table(_room) {
    // rm_overworld is also the temporary town respawn, so it has no room-wide table.
    // Place an obj_encounter_zone over the wild path instead.
    return undefined;
}
