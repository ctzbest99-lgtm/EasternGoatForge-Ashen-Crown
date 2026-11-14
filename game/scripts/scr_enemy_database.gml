/// scr_enemy_database — prototype values; playtest and rebalance before release.
function scr_get_enemy_data(_enemy_id) {
    switch (_enemy_id) {
        case "bandit":
            return { id: "bandit", name: "Bandit", max_hp: 18, attack: 5, defense: 1, xp_reward: 6, gold_reward: 4 };
        case "fallen_knight":
            return { id: "fallen_knight", name: "Fallen Knight", max_hp: 30, attack: 7, defense: 4, xp_reward: 12, gold_reward: 8 };
        case "blackguard":
            // Zone 1 boss (Old Watchtower arena). Placeholder stats, pending owner approval
            // and art. Stronger than Fallen Knight; not balanced. The map marker also lists
            // fallback_enemy_id "fallen_knight" if this entry is removed.
            return { id: "blackguard", name: "Blackguard", max_hp: 80, attack: 12, defense: 8, xp_reward: 50, gold_reward: 30 };
    }
    return undefined;
}
