/// scr_enemy_database — prototype values; playtest and rebalance before release.

/// @desc Every enemy id in the database, in menu order (used by the debug spawner and the planned Bestiary).
function scr_get_enemy_ids() {
    return ["bandit", "fallen_knight", "pale_shade", "ruin_warden"];
}

/// @desc Sprite asset name for an enemy, or "" when there is no sheet (asset_get_index then gives -1).
function scr_enemy_sprite_name(_enemy_id) {
    switch (_enemy_id) {
        case "bandit": return "spr_bandit_walk";
        case "fallen_knight": return "spr_fallen_knight_walk";
        /// The rare encounter and the boss are planned art (docs/ASSET_INVENTORY.md); "" makes the
        /// sprite lookup give -1 so they stay invisible placeholders rather than borrowing a wrong sheet.
        case "pale_shade": return "";
        case "ruin_warden": return "";
    }
    return "";
}

/// @desc May the party run from this enemy? Only enemies that declare `no_flee` refuse, so an unknown
/// id defaults to fleeable rather than trapping the player in a fight that was never meant to exist.
function scr_enemy_can_flee(_enemy_id) {
    var _data = scr_get_enemy_data(_enemy_id);
    if (is_undefined(_data) || _data == undefined) return true;
    return !(variable_struct_exists(_data, "no_flee") && _data.no_flee);
}

/// @desc Rough strength of an enemy, in levels, from its HP and attack. This is the yardstick the escape
/// chance compares the party's levels against.
function scr_battle_enemy_power(_enemy_id) {
    var _data = scr_get_enemy_data(_enemy_id);
    if (is_undefined(_data) || _data == undefined) return 1;
    return max(1, floor((_data.max_hp + _data.attack * 3) / 12));
}

function scr_get_enemy_data(_enemy_id) {
    switch (_enemy_id) {
        case "bandit":
            return { id: "bandit", name: "Bandit", max_hp: 18, attack: 5, defense: 1, xp_reward: 6, gold_reward: 4 };
        case "fallen_knight":
            return { id: "fallen_knight", name: "Fallen Knight", max_hp: 30, attack: 7, defense: 4, xp_reward: 12, gold_reward: 8 };
        /// Rare Zone 1 encounter, placeholder numbers: a step harder than a knight, worth about two.
        case "pale_shade":
            return { id: "pale_shade", name: "Pale Shade", max_hp: 24, attack: 8, defense: 3, xp_reward: 20, gold_reward: 15 };
        /// Zone 1 boss. Tuned against a level 3-4 lead: about nine turns to kill with potions in reach.
        /// no_flee marks a set-piece fight: the escape command refuses instead of letting the player walk
        /// out of the slice's ending.
        case "ruin_warden":
            return { id: "ruin_warden", name: "Ruin Warden", max_hp: 60, attack: 8, defense: 4, xp_reward: 40, gold_reward: 25, no_flee: true };
    }
    return undefined;
}

