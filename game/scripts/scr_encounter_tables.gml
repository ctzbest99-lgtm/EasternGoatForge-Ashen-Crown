/// scr_encounter_tables — named and per-room random encounter tables.
/// Enemy ids must match scr_get_enemy_data(). Rooms/areas not listed here are safe
/// unless an obj_encounter_zone is placed. Towns, Greyhaven interiors, and
/// TOWN_RESPAWN_ROOM stay safe by default (no room table). Weights are
/// PLACEHOLDER, pending tuning.
///
/// Elite Fallen Knights belong only in the Bandit Camp, Watchtower, and Basement
/// hall tables (and in the zone01_path fallback, which Camp / Watchtower opt into).

function scr_get_encounter_table(_table_id) {
    switch (_table_id) {
        case "zone01_path":
            // 3:1 Bandit to Fallen Knight. Fallback only for areas that set
            // fallback_table_id (Bandit Camp, Watchtower). Farmlands and the
            // Old Road must not use this table.
            return [
                { enemy_id: "bandit", weight: 3 },
                { enemy_id: "fallen_knight", weight: 1 }
            ];
        case "zone01_farmlands":
            // Design: Bandits, Ash Wolves, Lv 1–2. ash_wolf is a PLACEHOLDER entry.
            return [
                { enemy_id: "bandit", weight: 3 },
                { enemy_id: "ash_wolf", weight: 2 }
            ];
        case "zone01_old_road":
        case "old_road":
            // Design: Bandits, Ash Wolves, Ashen Wretches, rare Ashbound Hunter, Lv 2–3.
            // No elite Fallen Knights. Rare Hunter is a separate roll.
            return [
                { enemy_id: "bandit", weight: 3 },
                { enemy_id: "ash_wolf", weight: 2 },
                { enemy_id: "ashen_wretch", weight: 2 }
            ];
        case "zone01_bandit_camp":
        case "bandit_camp":
            // Design: Bandits, Fallen Knights, Ashen Wretches, rare Ashbound Hunter, Lv 3–4.
            return [
                { enemy_id: "bandit", weight: 3 },
                { enemy_id: "fallen_knight", weight: 1 },
                { enemy_id: "ashen_wretch", weight: 2 }
            ];
        case "zone01_watchtower":
        case "watchtower":
            // Design: Fallen Knights, Grave Spiders, Hollow Soldiers, Ashbound Hunter, Lv 4–7.
            return [
                { enemy_id: "fallen_knight", weight: 2 },
                { enemy_id: "grave_spider", weight: 2 },
                { enemy_id: "hollow_soldier", weight: 2 },
                { enemy_id: "ashbound_hunter", weight: 1 }
            ];
        case "zone01_basement_nest":
            // Spider nest. PLACEHOLDER weights.
            return [
                { enemy_id: "grave_spider", weight: 3 },
                { enemy_id: "hollow_soldier", weight: 1 }
            ];
        case "zone01_basement_hall":
            // Carving hall. PLACEHOLDER weights. May include elite Fallen Knights.
            return [
                { enemy_id: "hollow_soldier", weight: 2 },
                { enemy_id: "grave_spider", weight: 2 },
                { enemy_id: "fallen_knight", weight: 1 }
            ];
    }
    return undefined;
}

function scr_get_room_encounter_table(_room) {
    // rm_overworld, Greyhaven interiors, and the Watchtower rooms have no
    // room-wide table: Greyhaven and interiors stay safe. Encounter areas are
    // obj_encounter_zone instances spawned from the map markers.
    return undefined;
}
