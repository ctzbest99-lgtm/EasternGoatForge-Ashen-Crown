/// scr_encounter_tables — named and per-room random encounter tables.
/// Enemy ids must match scr_get_enemy_data(). Rooms/areas not listed here are safe
/// unless an obj_encounter_zone is placed. Towns and TOWN_RESPAWN_ROOM stay safe
/// by default (no room table). Weights are placeholders, pending tuning.

/// Named tables referenced by obj_encounter_zone.table_id, or by room lookup below.
function scr_get_encounter_table(_table_id) {
    switch (_table_id) {
        case "zone01_path":
            // 3:1 Bandit to Fallen Knight. Placeholder weights, not approved rates.
            // Used as the fallback for any Zone 1 area whose named table is missing.
            return [
                { enemy_id: "bandit", weight: 3 },
                { enemy_id: "fallen_knight", weight: 1 }
            ];
        case "zone01_farmlands":
            // Design: Bandits, Ash Wolves, Lv 1–2. Ash Wolves are not in the
            // database yet, so this is Bandits only until that entry exists.
            return [
                { enemy_id: "bandit", weight: 1 }
            ];
        case "zone01_old_road":
            // Design: Bandits, Ash Wolves, Ashen Wretches, rare Ashbound Hunter, Lv 2–3.
            // Missing enemies omitted. PR #4 (feature/watchtower-scripted-encounter) adds
            // the rare Hunter roll for table ids "old_road" / "bandit_camp" / "watchtower";
            // after that PR merges, add "zone01_old_road" (and the two below) to its allow list.
            return [
                { enemy_id: "bandit", weight: 3 },
                { enemy_id: "fallen_knight", weight: 1 }
            ];
        case "zone01_bandit_camp":
            // Design: Bandits, Fallen Knights, Ashen Wretches, rare Ashbound Hunter, Lv 3–4.
            return [
                { enemy_id: "bandit", weight: 2 },
                { enemy_id: "fallen_knight", weight: 2 }
            ];
        case "zone01_watchtower":
            // Design: Fallen Knights, Grave Spiders, Hollow Soldiers, Ashbound Hunter, Lv 4–7.
            // Missing enemies omitted. Greyhaven itself has no zone (safe).
            return [
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
    // rm_overworld has no room-wide table: Greyhaven must stay safe. Encounter
    // areas are obj_encounter_zone instances spawned from the map markers.
    // rm_old_watchtower is the same (its grounds use the zone01_watchtower zone).
    return undefined;
}
