/// scr_encounter_tables — named and per-room random encounter tables.
/// Enemy ids must match scr_get_enemy_data(). Rooms/areas not listed here are safe
/// unless an obj_encounter_zone is placed. Towns, Greyhaven interiors, and
/// TOWN_RESPAWN_ROOM stay safe by default (no room table). Weights are
/// PLACEHOLDER, pending tuning.
///
/// Elite Fallen Knights belong only in the Bandit Camp, Watchtower, and Basement
/// hall tables (and in the zone01_path fallback, which Camp / Watchtower opt into).
///
/// Entry shapes (feature/battle-upgrade). Single-enemy entries keep working unchanged:
///   { enemy_id: "bandit", weight: 3 }                         one enemy
///   { group: ["crown_patrolman", "crown_crossbowman"], weight: 2 }  1–3 regular enemies
///   { group_id: "grp_reeve_calder", weight: 1 }               a named group (see scr_get_encounter_group)

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

        // ---- Act II stubs (feature/battle-upgrade). Rooms for these zones do not exist yet. ----
        // Level band 8–10 (Design batch 6 / CHAPTER2_SCRIPT.md). Groups and weights are PLACEHOLDER.
        case "ch2_millhaven_road":
        case "millhaven_road":
            // Crown road patrols, road veterans, grey ash wolves. Kael walks this road alone (Taren
            // joins at the Calder fight), so groups stop at 2 (balance pass; see DECISIONS).
            return [
                { enemy_id: "crown_patrolman", weight: 2 },
                { group: ["crown_patrolman", "crown_crossbowman"], weight: 3 },
                { enemy_id: "crown_crossbowman", weight: 1 },
                { enemy_id: "bandit_veteran", weight: 1 },
                { group: ["bandit_veteran", "bandit_veteran"], weight: 2 },
                { enemy_id: "grey_ash_wolf", weight: 1 },
                { group: ["grey_ash_wolf", "grey_ash_wolf"], weight: 2 }
            ];
        case "ch2_wrenfield":
        case "wrenfield":
            // Occupation troops around the village checkpoints (not the scripted Calder fight).
            return [
                { enemy_id: "occupation_soldier", weight: 2 },
                { group: ["occupation_soldier", "crown_patrolman"], weight: 3 },
                { group: ["occupation_soldier", "crown_crossbowman"], weight: 2 },
                { group: ["occupation_soldier", "occupation_soldier"], weight: 1 },
                { group: ["crown_sergeant", "occupation_soldier"], weight: 1 } // batch 7 elite
            ];

        // ---- Chapter 3: the road east of Wrenfield (weights PLACEHOLDER). ----
        case "ch3_valemere_road":
            return [
                // Levels 10-11 to match the table's 10-13 band (CHAPTER3_SCRIPT.md §1). The Act II
                // crown/bandit ids are level 8, which left this road fighting under the party.
                { enemy_id: "crown_patrolman_road", weight: 3 },
                { enemy_id: "crown_crossbowman_road", weight: 1 },
                { enemy_id: "bandit_veteran_road", weight: 2 },
                { group: ["crown_patrolman_road", "crown_crossbowman_road"], weight: 2 },
                { group: ["bandit_veteran_road", "crown_patrolman_road"], weight: 1 }
            ];

        // ---- Design batches 7–8 (data only; no rooms or zones yet). Weights PLACEHOLDER. ----
        case "valemere_lower_city": // Chapter 3
            return [
                { enemy_id: "dock_thug", weight: 2 },
                { group: ["dock_thug", "cutpurse"], weight: 3 },
                { group: ["cutpurse", "dock_thug", "cutpurse"], weight: 1 },
                { group: ["debt_collector", "dock_thug"], weight: 1 }
            ];
        case "hollow_sanctuary": // Chapter 4
            return [
                { group: ["ward_sentinel", "glyph_wisp"], weight: 3 },
                { group: ["glyph_wisp", "glyph_wisp", "ward_sentinel"], weight: 2 },
                { group: ["aethari_automaton", "glyph_wisp"], weight: 1 }
            ];
        case "blackwood_garrison": // Chapter 5
            return [
                { group: ["garrison_pikeman", "garrison_field_surgeon"], weight: 3 },
                { group: ["garrison_pikeman", "garrison_pikeman", "garrison_field_surgeon"], weight: 2 },
                { group: ["garrison_knight", "garrison_field_surgeon"], weight: 1 }
            ];
        case "blackwood": // Act III
            return [
                { group: ["lost_one", "briar_hulk"], weight: 2 },
                { group: ["shade_stalker", "lost_one"], weight: 2 },
                { group: ["lost_one", "briar_hulk", "shade_stalker"], weight: 2 },
                { group: ["night_moth_swarm", "lost_one"], weight: 2 },
                { group: ["door_warden", "night_moth_swarm"], weight: 1 }
            ];
        case "crown_barrow": // Act IV (ACT4_OUTLINE.md §7, decisions approved 2026-11-16)
            return [
                { group: ["crown_guard_elite", "barrow_husk"], weight: 2 },
                { group: ["crown_guard_elite", "oath_iron"], weight: 2 },
                { group: ["barrow_husk", "barrow_husk", "grave_moth"], weight: 2 },
                { group: ["oath_iron", "barrow_husk"], weight: 1 },
                { group: ["grave_moth", "grave_moth", "crown_guard_elite"], weight: 1 }
            ];
    }
    return undefined;
}

/// Level band for a table id, for docs / future scaling. Undefined when unknown.
function scr_encounter_table_level_band(_table_id) {
    switch (_table_id) {
        case "zone01_farmlands": return { min: 1, max: 2 };
        // Fallback table: weak bandits (L1) mixed with Fallen Knights (L3), used when a room
        // sets no band of its own. Band covers both so the table is honest.
        case "zone01_path": return { min: 1, max: 4 };
        case "zone01_old_road": case "old_road": return { min: 2, max: 3 };
        case "zone01_bandit_camp": case "bandit_camp": return { min: 3, max: 4 };
        case "zone01_watchtower": case "watchtower": case "zone01_basement_nest": case "zone01_basement_hall": return { min: 4, max: 7 };
        case "ch2_millhaven_road": case "millhaven_road": case "ch2_wrenfield": case "wrenfield": return { min: 8, max: 10 };
        // PROPOSED bands from ACT2_OUTLINE.md; the Blackwood is a coder placeholder.
        case "valemere_lower_city": case "ch3_valemere_road": return { min: 10, max: 13 };
        case "hollow_sanctuary": return { min: 13, max: 16 };
        case "blackwood_garrison": return { min: 16, max: 18 };
        case "blackwood": return { min: 18, max: 20 };
        case "crown_barrow": return { min: 21, max: 23 };
    }
    return undefined;
}

/// Named enemy groups. `boss` (optional) is drawn at the boss slot; `adds` / `enemies` are
/// regular members. Returns undefined when the id is not a group.
function scr_get_encounter_group(_group_id) {
    if (!is_string(_group_id)) return undefined;
    switch (_group_id) {
        case "grp_reeve_calder": {
            // CHAPTER2_SCRIPT.md §7: Reeve Calder plus a small detachment (2–3). CALDER_ADD_COUNT
            // (PLACEHOLDER 2, matching Design's mockup) picks the size.
            var _adds = [];
            var _n = clamp(CALDER_ADD_COUNT, 0, BATTLE_MAX_ADDS);
            for (var _i = 0; _i < _n; _i++) array_push(_adds, "occupation_soldier");
            return { boss: "reeve_calder", adds: _adds };
        }
        // Batch 7–8 boss groups (adds follow Design's mockups; PLACEHOLDER).
        // CHAPTER3_SCRIPT.md §6: the Debtman plus 1-2 Lower City toughs (PLACEHOLDER 2).
        case "grp_debtman": return { boss: "debtman", adds: ["dock_thug", "debt_collector"] };
        case "grp_sanctuary_warden": return { boss: "sanctuary_warden", adds: ["ward_sentinel"] };
        case "grp_commander_hailen": return { boss: "commander_hailen", adds: ["garrison_pikeman"] };
        // Act IV boss groups (ACT4_OUTLINE.md §7, decisions approved 2026-11-16).
        case "grp_magistrate_vell": return { boss: "magistrate_vell", adds: ["crown_guard_elite", "crown_guard_elite"] };
        case "grp_barrow_warden": return { boss: "barrow_warden", adds: [] };
        case "grp_forgotten_king": return { boss: "forgotten_king", adds: [] };
        case "grp_blackwood_matriarch": return { boss: "blackwood_matriarch", adds: ["shade_stalker"] };
        // Act III bosses (ACT3_OUTLINE.md §7; the numbers come from the balance simulation).
        // One Stalker, not two: with two the act's first boss was harder than its second (89% wins,
        // 7.6 rounds at 18) than the Matriarch (96%). A second Stalker is the Act IV escalation.
        case "grp_burn_line_hulk": return { boss: "burn_line_hulk", adds: ["shade_stalker"] };
        case "grp_door_warden_boss": return { boss: "door_warden_boss", adds: ["ward_sentinel_late", "ward_sentinel_late"] };
        case "grp_crown_patrol":
            return { enemies: ["crown_crossbowman", "crown_patrolman", "occupation_soldier"] };
    }
    return undefined;
}

/// Expand an encounter pick into an ordered enemy id list (boss first) plus its boss flag.
/// Accepts an enemy id string, a group id string, an array of enemy ids, or a group struct.
/// Unknown enemy ids are dropped. Regular groups are capped at BATTLE_MAX_REGULAR_ENEMIES;
/// a boss keeps up to BATTLE_MAX_ADDS adds. Returns { ids: [], boss_index: -1 | 0 }.
function scr_encounter_resolve_ids(_pick) {
    var _out = { ids: [], boss_index: -1 };
    var _group = undefined;
    if (is_struct(_pick)) _group = _pick;
    else if (is_string(_pick)) _group = scr_get_encounter_group(_pick);

    if (is_struct(_group)) {
        if (variable_struct_exists(_group, "boss") && is_string(_group.boss) && is_struct(scr_get_enemy_data(_group.boss))) {
            array_push(_out.ids, _group.boss);
            _out.boss_index = 0;
            var _adds = (variable_struct_exists(_group, "adds") && is_array(_group.adds)) ? _group.adds : [];
            for (var _a = 0; _a < array_length(_adds) && _a < BATTLE_MAX_ADDS; _a++) {
                if (is_struct(scr_get_enemy_data(_adds[_a]))) array_push(_out.ids, _adds[_a]);
            }
            return _out;
        }
        if (variable_struct_exists(_group, "enemies") && is_array(_group.enemies)) _pick = _group.enemies;
    }

    if (is_array(_pick)) {
        for (var _i = 0; _i < array_length(_pick) && array_length(_out.ids) < BATTLE_MAX_REGULAR_ENEMIES; _i++) {
            if (is_struct(scr_get_enemy_data(_pick[_i]))) array_push(_out.ids, _pick[_i]);
        }
    } else if (is_string(_pick) && is_struct(scr_get_enemy_data(_pick))) {
        array_push(_out.ids, _pick);
        var _d = scr_get_enemy_data(_pick);
        if (variable_struct_exists(_d, "is_boss") && _d.is_boss) _out.boss_index = 0;
    }
    return _out;
}

function scr_get_room_encounter_table(_room) {
    // rm_overworld, Greyhaven interiors, and the Watchtower rooms have no
    // room-wide table: Greyhaven and interiors stay safe. Encounter areas are
    // obj_encounter_zone instances spawned from the map markers.
    return undefined;
}
