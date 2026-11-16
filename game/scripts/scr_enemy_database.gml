/// scr_enemy_database — prototype values; playtest and rebalance before release.

/// @desc Every enemy id in the database, in menu order (used by the debug spawner and the planned Bestiary).
function scr_get_enemy_ids() {
    return ["bandit", "fallen_knight"];
}

/// @desc Sprite asset name for an enemy, or "" when there is no sheet (asset_get_index then gives -1).
function scr_enemy_sprite_name(_enemy_id) {
    switch (_enemy_id) {
        case "bandit": return "spr_bandit_walk";
        case "fallen_knight": return "spr_fallen_knight_walk";
    }
    return "";
}

function scr_get_enemy_data(_enemy_id) {
    switch (_enemy_id) {
        case "bandit":
            return { id: "bandit", name: "Bandit", max_hp: 18, attack: 5, defense: 1, xp_reward: 6, gold_reward: 4 };
        case "fallen_knight":
            return { id: "fallen_knight", name: "Fallen Knight", max_hp: 30, attack: 7, defense: 4, xp_reward: 12, gold_reward: 8 };
    }
    return undefined;
}

