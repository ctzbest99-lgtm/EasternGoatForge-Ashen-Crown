/// scr_enemy_database — prototype values; playtest and rebalance before release.
function scr_get_enemy_data(_enemy_id) {
    switch (_enemy_id) {
        case "bandit":
            return { id: "bandit", name: "Bandit", max_hp: 18, attack: 5, defense: 1, xp_reward: 6, gold_reward: 4 };
        case "fallen_knight":
            return { id: "fallen_knight", name: "Fallen Knight", max_hp: 30, attack: 7, defense: 4, xp_reward: 12, gold_reward: 8 };
        case "ashbound_hunter":
            // Recommended level 3–5 (CHAPTER1_SCRIPT.md §4.1). PLACEHOLDER stats
            // a step above Fallen Knight. Weakness is for the bestiary later, not combat.
            return { id: "ashbound_hunter", name: "Ashbound Hunter", max_hp: 42, attack: 9, defense: 5, xp_reward: 20, gold_reward: 12, weakness: "ice" };
        case "blackguard":
            // Zone 1 boss (Old Watchtower arena). PLACEHOLDER stats, pending owner
            // approval. Canon in CHAPTER1_SCRIPT.md §8 is 450 HP with three phases;
            // those phases and the 250 XP / 100 Gold rewards are not implemented.
            // Battle sprites fall back to the coloured rectangle if missing.
            return { id: "blackguard", name: "Blackguard", max_hp: 80, attack: 12, defense: 8, xp_reward: 50, gold_reward: 30 };
        case "ash_wolf":
            // PLACEHOLDER. Design: Farmlands / Old Road, Lv 1–2 / 2–3.
            // Weakness "fire" is for the bestiary (Renn's hint); not used in combat.
            return { id: "ash_wolf", name: "Ash Wolf", max_hp: 16, attack: 6, defense: 1, xp_reward: 7, gold_reward: 3, weakness: "fire", placeholder: true };
        case "ashen_wretch":
            // PLACEHOLDER. Design: Old Road / Bandit Camp, Lv 2–4.
            return { id: "ashen_wretch", name: "Ashen Wretch", max_hp: 22, attack: 6, defense: 2, xp_reward: 9, gold_reward: 5, placeholder: true };
        case "grave_spider":
            // PLACEHOLDER. Design: Watchtower / Basement, Lv 4–7.
            return { id: "grave_spider", name: "Grave Spider", max_hp: 24, attack: 8, defense: 2, xp_reward: 11, gold_reward: 6, placeholder: true };
        case "hollow_soldier":
            // PLACEHOLDER. Design: Watchtower / Basement, Lv 4–7.
            return { id: "hollow_soldier", name: "Hollow Soldier", max_hp: 28, attack: 7, defense: 3, xp_reward: 11, gold_reward: 7, placeholder: true };
    }
    return undefined;
}
