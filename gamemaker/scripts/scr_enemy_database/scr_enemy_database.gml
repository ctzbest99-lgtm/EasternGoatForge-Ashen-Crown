/// scr_enemy_database — prototype values; playtest and rebalance before release.
///
/// Fields (feature/battle-upgrade): id, name, short_name (enemy list, 12 chars max), max_hp, attack,
/// defense, mdef, spd, max_mp, xp_reward, gold_reward (fixed) or gold_min / gold_max (rolled per enemy),
/// weakness (element id, "" = none; now used in combat via BATTLE_WEAKNESS_MULTIPLIER),
/// actions [{ skill, weight }] (scr_skill_data ids; the AI skips skills it cannot afford or whose
/// `cond` fails), optional actions_alone (used when no other enemy on its side is alive),
/// optional phase_actions [[...], [...], [...]] (Blackguard), is_boss, yields / yield_flag
/// (yield replaces death), stance_on_adds_fall / stance_buffs (one-time stance when every add falls).
///
/// Chapter 1 SPD / MDEF / MP are PLACEHOLDER defaults chosen so Kael (SPD 10, +1 per level) still
/// usually acts first in Zone 1, and every Chapter 1 kit keeps its old odds (specials stay visual
/// only, except Shield Wall, which still guards the next hit). Act II stats are Design's
/// suggestions (2026-11-14) and are not approved.
function scr_get_enemy_data(_enemy_id) {
    switch (_enemy_id) {
        case "bandit":
            return { id: "bandit", name: "Bandit", max_hp: 18, attack: 5, defense: 1, mdef: 1, spd: 8, max_mp: 0, xp_reward: 6, gold_reward: 4,
                actions: [{ skill: "attack", weight: 1 }] };
        case "fallen_knight":
            return { id: "fallen_knight", name: "Fallen Knight", short_name: "Fallen Kn.", max_hp: 30, attack: 7, defense: 4, mdef: 3, spd: 7, max_mp: 0, xp_reward: 12, gold_reward: 8,
                actions: [{ skill: "attack", weight: 1 }] };
        case "ashbound_hunter":
            // Recommended level 3–5 (CHAPTER1_SCRIPT.md §4.1). PLACEHOLDER stats
            // a step above Fallen Knight. Weakness now applies in combat (no party ice skill yet).
            return { id: "ashbound_hunter", name: "Ashbound Hunter", short_name: "Ash. Hunter", max_hp: 42, attack: 9, defense: 5, mdef: 3, spd: 11, max_mp: 0, xp_reward: 20, gold_reward: 12, weakness: "ice",
                actions: [{ skill: "attack", weight: 1 }] };
        case "blackguard":
            // Zone 1 boss (Old Watchtower arena). Canon HP / XP / Gold and phase
            // thresholds are from STORY_BIBLE.md §5.13 and CHAPTER1_SCRIPT.md §8:
            // 450 HP, Phase 2 at 60% (270), Phase 3 at 20% (90), 250 XP, 100 Gold.
            // ATK 12 / DEF 8 / MDEF 6 / SPD 9 remain PLACEHOLDER (not given in those docs).
            // Phase 3 SPD +30% (canon) now matters: speed_mod 1.3 is applied to turn order.
            // phase_actions keep the old odds (P1 1/3 Shield Bash; P2 Attack / Lunge / Oath; P3 Attack / Execution).
            return { id: "blackguard", name: "Blackguard", max_hp: 450, attack: 12, defense: 8, mdef: 6, spd: 9, max_mp: 0, xp_reward: 250, gold_reward: 100, weakness: "holy", is_boss: true,
                actions: [{ skill: "attack", weight: 1 }],
                phase_actions: [
                    [{ skill: "attack", weight: 2 }, { skill: "bg_shieldbash", weight: 1 }],
                    [{ skill: "attack", weight: 1 }, { skill: "bg_lunge", weight: 1 }, { skill: "bg_oath", weight: 1 }],
                    [{ skill: "attack", weight: 1 }, { skill: "bg_execution", weight: 1 }]
                ] };
        case "ash_wolf":
            // PLACEHOLDER. Design: Farmlands / Old Road, Lv 1–2 / 2–3. Howl stays visual only (1 in 5).
            return { id: "ash_wolf", name: "Ash Wolf", max_hp: 16, attack: 6, defense: 1, mdef: 0, spd: 9, max_mp: 0, xp_reward: 7, gold_reward: 3, weakness: "fire", placeholder: true,
                actions: [{ skill: "attack", weight: 4 }, { skill: "wolf_howl", weight: 1 }] };
        case "ashen_wretch":
            // PLACEHOLDER. Design: Old Road / Bandit Camp, Lv 2–4. Scream stays visual only (1 in 5).
            return { id: "ashen_wretch", name: "Ashen Wretch", short_name: "Ash. Wretch", max_hp: 22, attack: 6, defense: 2, mdef: 2, spd: 6, max_mp: 0, xp_reward: 9, gold_reward: 5, placeholder: true,
                actions: [{ skill: "attack", weight: 4 }, { skill: "wretch_scream", weight: 1 }] };
        case "grave_spider":
            // PLACEHOLDER. Design: Watchtower / Basement, Lv 4–7. Web stays visual only (1 in 4).
            return { id: "grave_spider", name: "Grave Spider", max_hp: 24, attack: 8, defense: 2, mdef: 2, spd: 8, max_mp: 0, xp_reward: 11, gold_reward: 6, placeholder: true,
                actions: [{ skill: "attack", weight: 3 }, { skill: "spider_web", weight: 1 }] };
        case "hollow_soldier":
            // PLACEHOLDER. Design: Watchtower / Basement, Lv 4–7. Shield Wall guards the next hit (1 in 4).
            return { id: "hollow_soldier", name: "Hollow Soldier", short_name: "Hollow Sol.", max_hp: 28, attack: 7, defense: 3, mdef: 1, spd: 5, max_mp: 0, xp_reward: 11, gold_reward: 7, placeholder: true,
                actions: [{ skill: "attack", weight: 3 }, { skill: "shield_wall", weight: 1 }] };

        // ---- Act II: Millhaven Road / Wrenfield (Design batch 6, level 8–10) ----------------
        // Stats are Design's SUGGESTIONS (2026-11-14), not approved. Skill weights are PLACEHOLDER.
        case "crown_patrolman":
            return { id: "crown_patrolman", name: "Crown Patrolman", short_name: "Patrolman", max_hp: 90, attack: 16, defense: 12, mdef: 6, spd: 11, max_mp: 0,
                xp_reward: 28, gold_min: 12, gold_max: 20, gold_reward: 16, weakness: "lightning", placeholder: true,
                actions: [{ skill: "attack", weight: 2 }, { skill: "thrust", weight: 2 }, { skill: "brace", weight: 1 }] };
        case "crown_crossbowman":
            return { id: "crown_crossbowman", name: "Crown Crossbowman", short_name: "Crossbowman", max_hp: 70, attack: 18, defense: 8, mdef: 6, spd: 13, max_mp: 0,
                xp_reward: 26, gold_min: 12, gold_max: 18, gold_reward: 15, weakness: "lightning", placeholder: true,
                actions: [{ skill: "crossbow_bolt", weight: 1 }] };
        case "occupation_soldier":
            return { id: "occupation_soldier", name: "Occupation Soldier", short_name: "Occ. Soldier", max_hp: 120, attack: 17, defense: 16, mdef: 8, spd: 8, max_mp: 0,
                xp_reward: 36, gold_min: 15, gold_max: 25, gold_reward: 20, weakness: "lightning", placeholder: true,
                actions: [{ skill: "attack", weight: 2 }, { skill: "slash", weight: 2 }, { skill: "soldier_guard", weight: 1 }] };
        case "bandit_veteran":
            // Same kit as the bandit (plain attack).
            return { id: "bandit_veteran", name: "Bandit Veteran", short_name: "Bandit Vet.", max_hp: 95, attack: 18, defense: 11, mdef: 5, spd: 14, max_mp: 0,
                xp_reward: 32, gold_min: 16, gold_max: 28, gold_reward: 22, placeholder: true,
                actions: [{ skill: "attack", weight: 1 }] };
        case "grey_ash_wolf":
            // Same kit as the ash wolf. MDEF and gold were not in Design's list: PLACEHOLDER 4 and 10–16.
            return { id: "grey_ash_wolf", name: "Grey Ash Wolf", short_name: "Grey Wolf", max_hp: 80, attack: 20, defense: 8, mdef: 4, spd: 20, max_mp: 0,
                xp_reward: 28, gold_min: 10, gold_max: 16, gold_reward: 13, weakness: "fire", placeholder: true,
                actions: [{ skill: "attack", weight: 4 }, { skill: "wolf_howl", weight: 1 }] };
        case "reeve_calder":
            // Chapter 2 boss (CHAPTER2_SCRIPT.md §7). Kit is canon: Guard; a shout that buffs his
            // soldiers; a heavy strike; a harder stance when the detachment falls; he yields and lives.
            // Numbers are Design's suggestions. Stance (+25% ATK, +15% DEF for the rest of the
            // battle) is PLACEHOLDER. Fought as group "grp_reeve_calder" with occupation_soldier adds.
            return { id: "reeve_calder", name: "Reeve Calder", short_name: "Reeve Calder", max_hp: 320, attack: 24, defense: 18, mdef: 12, spd: 10, max_mp: 20,
                xp_reward: 220, gold_min: 80, gold_max: 120, gold_reward: 100, placeholder: true,
                is_boss: true, yields: true, yield_flag: "flag_reeve_calder_yielded",
                stance_on_adds_fall: true,
                stance_buffs: [{ stat: "atk", pct: 0.25, turns: -1 }, { stat: "def", pct: 0.15, turns: -1 }],
                actions: [{ skill: "heavy_strike", weight: 3 }, { skill: "calder_guard", weight: 1 }, { skill: "calder_shout", weight: 2 }],
                actions_alone: [{ skill: "heavy_strike", weight: 3 }, { skill: "calder_guard", weight: 1 }] };
    }
    return undefined;
}
