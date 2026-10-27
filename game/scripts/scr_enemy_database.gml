/// scr_enemy_database — prototype values; playtest and rebalance before release.
function scr_get_enemy_data(_enemy_id) {
    switch (_enemy_id) {
        case "bandit":
            return { id: "bandit", name: "Bandit", max_hp: 18, attack: 5, defense: 1, xp_reward: 6, gold_reward: 4 };
        case "fallen_knight":
            return { id: "fallen_knight", name: "Fallen Knight", max_hp: 30, attack: 7, defense: 4, xp_reward: 12, gold_reward: 8 };
    }
    return undefined;
}
