/// scr_enemy_database — prototype values; playtest and rebalance before release.
///
/// Fields (feature/battle-upgrade): id, level (used by the Escape roll and the Bestiary), name,
/// short_name (enemy list, 12 chars max), max_hp, attack,
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
            // Cheap Shot is the canon Bandit ability (CHAPTER1_SCRIPT.md §2.1 /
            // FL_TUTORIAL_SYS_03): hits harder against a defending target. Weight PLACEHOLDER.
            // Level 1: the Farmlands is the level 1–2 band and the tutorial fight is level 1.
            return { id: "bandit", level: 1, name: "Bandit", max_hp: 18, attack: 5, defense: 1, mdef: 1, spd: 8, max_mp: 0, xp_reward: 6, gold_reward: 4,
                actions: [{ skill: "attack", weight: 3 }, { skill: "cheap_shot", weight: 1 }] };
        case "fallen_knight":
            // Level 3: first appears in the Bandit Camp (3–4) and the Watchtower (4–7).
            return { id: "fallen_knight", level: 3, name: "Fallen Knight", short_name: "Fallen Kn.", max_hp: 30, attack: 7, defense: 4, mdef: 3, spd: 7, max_mp: 0, xp_reward: 12, gold_reward: 8,
                actions: [{ skill: "attack", weight: 1 }] };
        case "ashbound_hunter":
            // Recommended level 3–5 (CHAPTER1_SCRIPT.md §4.1). PLACEHOLDER stats
            // a step above Fallen Knight. Weakness now applies in combat (no party ice skill yet).
            // Level 4: middle of the script's recommended 3–5.
            return { id: "ashbound_hunter", level: 4, name: "Ashbound Hunter", short_name: "Ash. Hunter", max_hp: 42, attack: 9, defense: 5, mdef: 3, spd: 11, max_mp: 0, xp_reward: 20, gold_reward: 12, weakness: "ice",
                actions: [{ skill: "attack", weight: 1 }] };
        case "blackguard":
            // Zone 1 boss (Old Watchtower arena). Canon HP / XP / Gold and phase
            // thresholds are from STORY_BIBLE.md §5.13 and CHAPTER1_SCRIPT.md §8:
            // 450 HP, Phase 2 at 60% (270), Phase 3 at 20% (90), 250 XP, 100 Gold.
            // ATK 12 / DEF 8 / MDEF 6 / SPD 9 remain PLACEHOLDER (not given in those docs).
            // Phase 3 SPD +30% (canon) now matters: speed_mod 1.3 is applied to turn order.
            // phase_actions keep the old odds (P1 1/3 Shield Bash; P2 Attack / Lunge / Oath; P3 Attack / Execution).
            // Level 6: end-of-zone boss (the Watchtower band is 4–7). Coder choice — the script
            // gives no boss level, and Escape is never offered in a boss fight.
            return { id: "blackguard", level: 6, name: "Blackguard", max_hp: 450, attack: 12, defense: 8, mdef: 6, spd: 9, max_mp: 0, xp_reward: 250, gold_reward: 100, weakness: "holy", is_boss: true,
                actions: [{ skill: "attack", weight: 1 }],
                phase_actions: [
                    [{ skill: "attack", weight: 2 }, { skill: "bg_shieldbash", weight: 1 }],
                    [{ skill: "attack", weight: 1 }, { skill: "bg_lunge", weight: 1 }, { skill: "bg_oath", weight: 1 }],
                    [{ skill: "attack", weight: 1 }, { skill: "bg_execution", weight: 1 }]
                ] };
        case "ash_wolf":
            // PLACEHOLDER. Design: Farmlands / Old Road, Lv 1–2 / 2–3. Howl stays visual only (1 in 5).
            return { id: "ash_wolf", level: 2, name: "Ash Wolf", max_hp: 16, attack: 6, defense: 1, mdef: 0, spd: 9, max_mp: 0, xp_reward: 7, gold_reward: 3, weakness: "fire", placeholder: true,
                actions: [{ skill: "attack", weight: 4 }, { skill: "wolf_howl", weight: 1 }] };
        case "ashen_wretch":
            // PLACEHOLDER. Design: Old Road / Bandit Camp, Lv 2–4. Scream stays visual only (1 in 5).
            return { id: "ashen_wretch", level: 3, name: "Ashen Wretch", short_name: "Ash. Wretch", max_hp: 22, attack: 6, defense: 2, mdef: 2, spd: 6, max_mp: 0, xp_reward: 9, gold_reward: 5, placeholder: true,
                actions: [{ skill: "attack", weight: 4 }, { skill: "wretch_scream", weight: 1 }] };
        case "grave_spider":
            // PLACEHOLDER. Design: Watchtower / Basement, Lv 4–7. Web stays visual only (1 in 4).
            // Venom Bite is the PLACEHOLDER battle-poison inflictor (chance PLACEHOLDER).
            return { id: "grave_spider", level: 5, name: "Grave Spider", max_hp: 24, attack: 8, defense: 2, mdef: 2, spd: 8, max_mp: 0, xp_reward: 11, gold_reward: 6, placeholder: true,
                actions: [{ skill: "attack", weight: 3 }, { skill: "spider_web", weight: 1 }, { skill: "venom_bite", weight: 1 }] };
        case "hollow_soldier":
            // PLACEHOLDER. Design: Watchtower / Basement, Lv 4–7. Shield Wall guards the next hit (1 in 4).
            return { id: "hollow_soldier", level: 5, name: "Hollow Soldier", short_name: "Hollow Sol.", max_hp: 28, attack: 7, defense: 3, mdef: 1, spd: 5, max_mp: 0, xp_reward: 11, gold_reward: 7, placeholder: true,
                actions: [{ skill: "attack", weight: 3 }, { skill: "shield_wall", weight: 1 }] };

        // ---- Act II: Millhaven Road / Wrenfield (Design batch 6, level 8–10) ----------------
        // Balance pass (PLACEHOLDER): HP / ATK / DEF were lowered from Design's suggestions so a
        // solo level-8 Kael can clear 1–2 enemy road fights and Kael + Taren at 9–10 beat Calder
        // with no in-battle healing (tools/balance_sim.py; table in DECISIONS). XP / gold / SPD /
        // MDEF are still Design's suggestions. Skill weights are PLACEHOLDER.
        // Design suggested: Patrolman 90/16/12, Crossbowman 70/18/8, Occupation Soldier 120/17/16,
        // Bandit Veteran 95/18/11, Grey Ash Wolf 80/20/8, Reeve Calder 320/24/18 (HP/ATK/DEF).
        case "crown_patrolman":
            // Chapter 2 is the script's suggested level 8–10 band; road enemies sit at its bottom.
            return { id: "crown_patrolman", level: 8, name: "Crown Patrolman", short_name: "Patrolman", max_hp: 44, attack: 13, defense: 12, mdef: 6, spd: 11, max_mp: 0,
                xp_reward: 28, gold_min: 12, gold_max: 20, gold_reward: 16, weakness: "lightning", placeholder: true,
                actions: [{ skill: "attack", weight: 2 }, { skill: "thrust", weight: 2 }, { skill: "brace", weight: 1 }] };
        case "crown_crossbowman":
            return { id: "crown_crossbowman", level: 8, name: "Crown Crossbowman", short_name: "Crossbowman", max_hp: 36, attack: 14, defense: 8, mdef: 6, spd: 13, max_mp: 0,
                xp_reward: 26, gold_min: 12, gold_max: 18, gold_reward: 15, weakness: "lightning", placeholder: true,
                actions: [{ skill: "crossbow_bolt", weight: 1 }] };
        case "occupation_soldier":
            return { id: "occupation_soldier", level: 9, name: "Occupation Soldier", short_name: "Occ. Soldier", max_hp: 50, attack: 12, defense: 14, mdef: 8, spd: 8, max_mp: 0,
                xp_reward: 36, gold_min: 15, gold_max: 25, gold_reward: 20, weakness: "lightning", placeholder: true,
                actions: [{ skill: "attack", weight: 2 }, { skill: "slash", weight: 2 }, { skill: "soldier_guard", weight: 1 }] };
        case "bandit_veteran":
            // Same kit as the bandit (plain attack).
            return { id: "bandit_veteran", level: 9, name: "Bandit Veteran", short_name: "Bandit Vet.", max_hp: 42, attack: 13, defense: 10, mdef: 5, spd: 14, max_mp: 0,
                xp_reward: 32, gold_min: 16, gold_max: 28, gold_reward: 22, placeholder: true,
                actions: [{ skill: "attack", weight: 1 }] };
        case "grey_ash_wolf":
            // Same kit as the ash wolf. MDEF and gold were not in Design's list: PLACEHOLDER 4 and 10–16.
            return { id: "grey_ash_wolf", level: 8, name: "Grey Ash Wolf", short_name: "Grey Wolf", max_hp: 36, attack: 13, defense: 8, mdef: 4, spd: 20, max_mp: 0,
                xp_reward: 28, gold_min: 10, gold_max: 16, gold_reward: 13, weakness: "fire", placeholder: true,
                actions: [{ skill: "attack", weight: 4 }, { skill: "wolf_howl", weight: 1 }] };
        case "reeve_calder":
            // Chapter 2 boss (CHAPTER2_SCRIPT.md §7). Kit is canon: Guard; a shout that buffs his
            // soldiers; a heavy strike; a harder stance when the detachment falls; he yields and lives.
            // Numbers are Design's suggestions. Stance (+25% ATK, +15% DEF for the rest of the
            // battle) is PLACEHOLDER. Fought as group "grp_reeve_calder" with occupation_soldier adds.
            // Level 10: the top of the 8–10 band, where the Calder fight is meant to land.
            return { id: "reeve_calder", level: 10, name: "Reeve Calder", short_name: "Reeve Calder", max_hp: 130, attack: 15, defense: 16, mdef: 12, spd: 10, max_mp: 20,
                xp_reward: 220, gold_min: 80, gold_max: 120, gold_reward: 100, placeholder: true,
                is_boss: true, yields: true, yield_flag: "flag_reeve_calder_yielded",
                stance_on_adds_fall: true,
                // Chapter 2 barks replace the system lines: stance (§7.1) and yield (§7.2).
                stance_line_node: "WF_CALDER_PHASE2_01", yield_line_node: "WF_CALDER_DEFEAT_01",
                stance_buffs: [{ stat: "atk", pct: 0.25, turns: -1 }, { stat: "def", pct: 0.15, turns: -1 }],
                actions: [{ skill: "heavy_strike", weight: 3 }, { skill: "calder_guard", weight: 1 }, { skill: "calder_shout", weight: 2 }],
                actions_alone: [{ skill: "heavy_strike", weight: 3 }, { skill: "calder_guard", weight: 1 }] };

        // ---- Design batch 7: Wrenfield elite, Lower City (Ch 3), Hollow Sanctuary (Ch 4),
        //      Blackwood Road Garrison (Ch 5). Batch 8: the Blackwood (Act III). -------------
        // Stats come from scr_enemy_scaled (role + level template calibrated to the Chapter 2
        // balance pass). Levels follow ACT2_OUTLINE's PROPOSED bands (Ch3 10–13, Ch4 13–16,
        // Ch5 16–18); the Blackwood (18–20) is a coder placeholder. Everything here is PLACEHOLDER.
        case "crown_sergeant": // Wrenfield elite (battle enemy; the gate NPC is crown_sergeant_gate)
            return scr_enemy_scaled("crown_sergeant", "Crown Sergeant", "Sergeant", "elite", 9, 1, { spd: 10, weakness: "lightning",
                actions: [{ skill: "attack", weight: 3 }, { skill: "sergeant_rally", weight: 2 }] });
        // CHAPTER3_SCRIPT.md §1: Crown patrols and bandits on the Valemere road, band 10-13. The
        // Act II entries are level 8 (their own band), so the road needs its own level-10/11
        // versions or it fights two to nine levels under the party. Same names; the Bestiary
        // aliases them onto the Act II rows (scr_bestiary_alias), as it does for the level-20
        // Ward Sentinel.
        case "crown_patrolman_road":
            return scr_enemy_scaled("crown_patrolman_road", "Crown Patrolman", "Patrolman", "common", 10, 1, { spd: 11, weakness: "lightning",
                actions: [{ skill: "attack", weight: 2 }, { skill: "thrust", weight: 2 }, { skill: "brace", weight: 1 }] });
        case "crown_crossbowman_road":
            return scr_enemy_scaled("crown_crossbowman_road", "Crown Crossbowman", "Crossbowman", "common", 10, 1, { spd: 13, hp_mult: 0.8, atk_add: 2, weakness: "lightning",
                actions: [{ skill: "crossbow_bolt", weight: 1 }] });
        case "bandit_veteran_road":
            return scr_enemy_scaled("bandit_veteran_road", "Bandit Veteran", "Bandit Vet.", "common", 11, 1, { spd: 14,
                actions: [{ skill: "attack", weight: 1 }] });
        case "dock_thug":
            return scr_enemy_scaled("dock_thug", "Dock Thug", "Dock Thug", "common", 11, 1, { spd: 9, actions: [{ skill: "attack", weight: 1 }] });
        case "cutpurse":
            return scr_enemy_scaled("cutpurse", "Cutpurse", "Cutpurse", "common", 11, 1, { spd: 18, hp_mult: 0.8,
                actions: [{ skill: "attack", weight: 2 }, { skill: "cutpurse_steal", weight: 2 }] });
        case "debt_collector":
            return scr_enemy_scaled("debt_collector", "Debt Collector", "Collector", "elite", 12, 1, { spd: 10, actions: [{ skill: "attack", weight: 1 }] });
        case "debtman":
            // Ch 3 boss (CHAPTER3_SCRIPT.md §6). Kit is canon: a fast knife strike; Collect
            // (a small HP drain); a bind that Slows one target. When the toughs fall he
            // fights meaner and faster (the stance). He is beaten and withdraws alive
            // (Decision 3): yield replaces death, like Reeve Calder. Not Ash-corrupted.
            // Numbers are PLACEHOLDER (suggested levels 10-13).
            return scr_enemy_scaled("debtman", "The Debtman", "Debtman", "boss", 12, 3, { spd: 12,
                is_boss: true, yields: true, yield_flag: "flag_debtman_yielded",
                stance_on_adds_fall: true, stance_line_node: "DM_PHASE2_01",
                stance_buffs: [{ stat: "atk", pct: 0.30, turns: -1 }, { stat: "spd", pct: 0.30, turns: -1 }],
                actions: [{ skill: "attack", weight: 3 }, { skill: "debtman_reel", weight: 2 },
                    { skill: "debtman_collect", weight: 2 }, { skill: "debtman_bind", weight: 1 }] });
        case "ward_sentinel":
            return scr_enemy_scaled("ward_sentinel", "Ward Sentinel", "Sentinel", "common", 14, 1, { spd: 7, def_add: 3, weakness: "lightning",
                actions: [{ skill: "attack", weight: 1 }] });
        case "glyph_wisp":
            return scr_enemy_scaled("glyph_wisp", "Glyph Wisp", "Wisp", "common", 14, 1, { spd: 15, hp_mult: 0.75,
                actions: [{ skill: "attack", weight: 1 }, { skill: "wisp_mote", weight: 2 }] });
        case "aethari_automaton":
            return scr_enemy_scaled("aethari_automaton", "Aethari Automaton", "Automaton", "elite", 15, 1, { spd: 9, weakness: "lightning",
                actions: [{ skill: "attack", weight: 1 }] });
        case "sanctuary_warden": // Ch 4 boss (working name), two phases
            // hp_mult 1.25 / atk_add 2 compensate for Caelan's approved elemental kit (Chapter 4
            // balance pass 2026-11-15; PLACEHOLDER, 35/71/94% wins at party levels 13/14/15).
            return scr_enemy_scaled("sanctuary_warden", "Sanctuary Warden", "Warden", "boss", 16, 4, { spd: 8,
                hp_mult: 1.25, atk_add: 2,
                phase2_at: 0.5, phase2_buffs: [{ stat: "atk", pct: 0.2, turns: -1 }],
                phase2_line: "The Warden's plates crack. Two more arms unfold!",
                actions: [{ skill: "attack", weight: 2 }, { skill: "warden_ring", weight: 1 }],
                phase_actions: [
                    [{ skill: "attack", weight: 2 }, { skill: "warden_ring", weight: 1 }],
                    [{ skill: "attack", weight: 2 }, { skill: "warden_ring", weight: 2 }]
                ] });
        case "garrison_pikeman":
            // atk_add 4: at 34 ATK the two-pikeman group only cost 18% party HP at level 16
            // (Chapter 5 balance pass 2026-11-15); 38 brings it to ~21%, the band-floor target.
            return scr_enemy_scaled("garrison_pikeman", "Garrison Pikeman", "Pikeman", "common", 16, 1, { spd: 10, weakness: "lightning", atk_add: 4,
                actions: [{ skill: "attack", weight: 2 }, { skill: "pike_thrust", weight: 2 }] });
        case "garrison_field_surgeon":
            return scr_enemy_scaled("garrison_field_surgeon", "Field Surgeon", "Surgeon", "common", 16, 1, { spd: 12, hp_mult: 0.8,
                actions: [{ skill: "attack", weight: 2 }, { skill: "surgeon_heal", weight: 3 }] });
        case "garrison_knight":
            return scr_enemy_scaled("garrison_knight", "Garrison Knight", "Knight", "elite", 17, 1, { spd: 9, weakness: "lightning",
                actions: [{ skill: "attack", weight: 3 }, { skill: "soldier_guard", weight: 1 }] });
        case "commander_hailen": // Ch 5 boss: yields if the story flag is set, otherwise falls
            // Chapter 5 balance pass (2026-11-15): Caelan's kit made him 97/100/100% at 16/17/18,
            // so he took length (hp_mult 1.5) rather than more ATK alone. PLACEHOLDER:
            // ~51/81/96% wins, 9.1/8.6/8.1 rounds, 15/22/30% party HP left.
            return scr_enemy_scaled("commander_hailen", "Commander Hailen", "Hailen", "boss", 18, 4, { spd: 12, hp_mult: 1.5, atk_add: 14,
                yields_if_flag: "flag_hailen_yields", yield_flag: "flag_hailen_yielded",
                actions: [{ skill: "attack", weight: 3 }, { skill: "hailen_glint", weight: 2 }] });
        case "shade_stalker":
            return scr_enemy_scaled("shade_stalker", "Shade Stalker", "Stalker", "common", 18, 1, { spd: 19, weakness: "holy",
                actions: [{ skill: "attack", weight: 3 }, { skill: "shade_fade", weight: 1 }] });
        case "briar_hulk":
            return scr_enemy_scaled("briar_hulk", "Briar Hulk", "Briar Hulk", "common", 18, 1, { spd: 5, hp_mult: 1.4, weakness: "fire",
                actions: [{ skill: "attack", weight: 1 }] });
        case "burn_line_hulk": // ACT3_OUTLINE.md §7: the briar_hulk at boss scale (Chapter 6 boss).
            // Tuned by the Act III simulation: 1260 HP (600 x 2.1, i.e. the Hulk's own x1.4 and the
            // boss x1.2 x party of 4) and 55 ATK, with one Shade Stalker in grp_burn_line_hulk.
            // Simulated 100% wins, 7.6 rounds, 0.42 deaths, 42% party HP at level 18. A second
            // Stalker drops that to 89% at 8.4 rounds, which is the Act IV escalation.
            return scr_enemy_scaled("burn_line_hulk", "Burn-Line Hulk", "Burn-Line Hulk", "boss", 18, 4, { spd: 5, hp_mult: 2.1, atk_add: 12, weakness: "fire",
                actions: [{ skill: "attack", weight: 1 }] });
        case "lost_one": // id and concept may be revised (DECISIONS)
            return scr_enemy_scaled("lost_one", "Lost One", "Lost One", "common", 18, 1, { spd: 8, weakness: "holy",
                actions: [{ skill: "attack", weight: 1 }] });
        case "night_moth_swarm":
            return scr_enemy_scaled("night_moth_swarm", "Night Moth Swarm", "Moths", "common", 19, 1, { spd: 16, hp_mult: 0.7, weakness: "fire",
                actions: [{ skill: "attack", weight: 2 }, { skill: "moth_blind", weight: 2 }, { skill: "moth_sleep", weight: 1 }] });
        case "door_warden":
            return scr_enemy_scaled("door_warden", "Door Warden", "Door Warden", "elite", 19, 1, { spd: 6, def_add: 3, weakness: "lightning",
                actions: [{ skill: "attack", weight: 1 }] });
        case "door_warden_boss": // ACT3_OUTLINE.md §7: the Door Warden at boss scale (Chapter 8 boss).
            // 1286 HP (134 x 1.2 x 4, then x2.0) / 46 ATK / 37 DEF, with two level-20 Sentinels.
            // Simulated 96-99% wins, 8.2-10.3 rounds, ~1 death. The elite door_warden stays in the
            // blackwood random table; this is the fight at the doors.
            return scr_enemy_scaled("door_warden_boss", "The Door Warden", "Door Warden", "boss", 19, 4, { spd: 6, hp_mult: 2.0, def_add: 3, weakness: "lightning",
                actions: [{ skill: "attack", weight: 1 }] });
        case "ward_sentinel_late": // ACT3_OUTLINE.md §7: the Sentinel that guards the doors at 19-20.
            // common 20 = 143 / 46 / 33, +3 DEF. The level-14 ward_sentinel dies in one hit at 20.
            return scr_enemy_scaled("ward_sentinel_late", "Ward Sentinel", "Sentinel", "common", 20, 1, { spd: 7, def_add: 3, weakness: "lightning",
                actions: [{ skill: "attack", weight: 1 }] });
        // ---- Act IV: The Forgotten King (docs/story/ACT4_OUTLINE.md §7; decisions approved 2026-11-16) ----
        // scr_enemy_scaled bases: level 21 = 152 / 49 / 35 / MDEF 18, 22 = 161 / 52 / 37 / 19,
        // 23 = 170 / 55 / 39 / 20. hp_mult and def_add apply after the role multiplier.
        // There is still no Act IV equipment tier, so these are tuned against Chapter 5 gear.
        case "crown_guard_elite": // common 21 = 152 / 49 / 37 (+2 DEF)
            return scr_enemy_scaled("crown_guard_elite", "Crown Guard Elite", "Guard Elite", "common", 21, 1, { spd: 9, def_add: 2,
                actions: [{ skill: "attack", weight: 2 }, { skill: "slash", weight: 1 }, { skill: "soldier_guard", weight: 1 }] });
        case "barrow_husk": // common 21 = 175 / 49 / 35 (x1.15 HP), slow, holy
            return scr_enemy_scaled("barrow_husk", "Barrow Husk", "Barrow Husk", "common", 21, 1, { spd: 6, hp_mult: 1.15, weakness: "holy",
                actions: [{ skill: "attack", weight: 1 }] });
        case "oath_iron": // common 22 = 193 / 52 / 41 (x1.2 HP, +4 DEF), slow, lightning
            return scr_enemy_scaled("oath_iron", "Oath Iron", "Oath Iron", "common", 22, 1, { spd: 5, hp_mult: 1.2, def_add: 4, weakness: "lightning",
                actions: [{ skill: "attack", weight: 1 }] });
        case "grave_moth": // common 22 = 129 / 52 / 37 (x0.8 HP), fast, fire
            return scr_enemy_scaled("grave_moth", "Grave Moth", "Grave Moth", "common", 22, 1, { spd: 14, hp_mult: 0.8, weakness: "fire",
                actions: [{ skill: "attack", weight: 2 }, { skill: "moth_blind", weight: 1 }, { skill: "moth_sleep", weight: 1 }] });
        case "magistrate_vell": // Chapter 9 boss: 1022 HP (152 x 1.2 x 4, then x1.4), 52 ATK / 38 DEF
            // He yields rather than dies (the Calder pattern); the flag is set by the battle system.
            return scr_enemy_scaled("magistrate_vell", "Magistrate Vell", "Vell", "boss", 21, 4, { spd: 11, hp_mult: 1.4,
                yields: true, yield_flag: "flag_vell_yielded",
                actions: [{ skill: "attack", weight: 2 }, { skill: "heavy_strike", weight: 2 }, { skill: "calder_guard", weight: 1 }] });
        case "barrow_warden": // Chapter 10 boss: 1701 HP (161 x 1.2 x 4, then x2.2), 59 ATK / 42 DEF
            // Simulated 98-99% wins in 7.4-9.9 rounds with about half a death; at x1.7 it was 100%.
            return scr_enemy_scaled("barrow_warden", "Barrow Warden", "Barrow Warden", "boss", 22, 4, { spd: 8, hp_mult: 2.2, atk_add: 4, def_add: 2, weakness: "lightning",
                phase2_at: 0.5,
                phase2_buffs: [{ stat: "def", pct: 0.2, turns: -1 }, { stat: "atk", pct: 0.15, turns: -1 }],
                phase2_line: "The iron remembers the oath it was given.",
                actions: [{ skill: "attack", weight: 2 }, { skill: "heavy_strike", weight: 1 }],
                phase_actions: [
                    [{ skill: "attack", weight: 2 }, { skill: "heavy_strike", weight: 1 }],
                    [{ skill: "attack", weight: 1 }, { skill: "heavy_strike", weight: 1 }]
                ] });
        case "forgotten_king": // Act boss: 1714 HP (170 x 1.2 x 4, then x2.1), 61 ATK / 45 DEF
            // At level 23 simulated 96-97% wins in 8.6-9.9 rounds with about one death; the same
            // numbers at level 21 are 81-83%, so arriving early is felt. ACT4_OUTLINE.md asks for
            // three phases, but scr_battle supports ONE shift (phase2_at -> phase_actions[1]);
            // phase three is narrative until the battle system can shift twice.
            return scr_enemy_scaled("forgotten_king", "The Forgotten King", "Forg. King", "boss", 23, 4, { spd: 7, hp_mult: 2.1, atk_add: 3, def_add: 3,
                phase2_at: 0.6,
                phase2_buffs: [{ stat: "atk", pct: 0.2, turns: -1 }, { stat: "spd", pct: 0.2, turns: -1 }],
                phase2_line: "The oath breaks. Something underneath it does not.",
                actions: [{ skill: "attack", weight: 2 }, { skill: "heavy_strike", weight: 1 }],
                phase_actions: [
                    [{ skill: "attack", weight: 2 }, { skill: "heavy_strike", weight: 1 }],
                    [{ skill: "attack", weight: 1 }, { skill: "heavy_strike", weight: 2 }]
                ] });
        case "blackwood_matriarch": // PLACEHOLDER boss (proposed, not canon), two phases
            // hp_mult 1.5 (686 -> 1029 HP) is the Act III tuning: as written she was won 100% of the
            // time in 5.0 rounds; at x1.5 it is 91-92% in 6.7-7.6 rounds with about one death.
            return scr_enemy_scaled("blackwood_matriarch", "Blackwood Matriarch", "Matriarch", "boss", 20, 4, { spd: 13, hp_mult: 1.5, weakness: "holy",
                phase2_at: 0.5, phase2_buffs: [{ stat: "atk", pct: 0.25, turns: -1 }, { stat: "spd", pct: 0.2, turns: -1 }],
                phase2_line: "Her antlers split. Embers wake in the cracks!",
                actions: [{ skill: "attack", weight: 2 }, { skill: "matriarch_breath", weight: 1 }],
                phase_actions: [
                    [{ skill: "attack", weight: 2 }, { skill: "matriarch_breath", weight: 1 }],
                    [{ skill: "attack", weight: 2 }, { skill: "matriarch_breath", weight: 2 }]
                ] });
    }
    return undefined;
}

/// PLACEHOLDER stat template for enemies past Chapter 2 (Design batches 7–8). Calibrated so a
/// "common" at level 9 matches the balance-pass Chapter 2 regulars (≈ 44 HP, 13 ATK, 11 DEF).
/// Rebalanced after the Chapter 4–5 simulation: the old +2 ATK / +7 HP per level fell behind the
/// tiered party growth (DEF +2 and ATK +2 per level, plus a fourth member), so random fights were
/// free and bosses could not kill anyone. ATK now grows +3 and HP +9 per level; a boss takes its
/// length from HP (× 1.2 × expected party size) and its threat from ATK (+3). Roles: "common",
/// "elite" (×2 HP, +2 ATK / DEF, ×2.5 XP), "boss" (+3 ATK / DEF, ×8 XP). `_extra` may set spd,
/// mdef, weakness, actions, phase data, yields_if_flag, and tweaks hp_mult / def_add / atk_add.
/// Not approved.
function scr_enemy_scaled(_id, _name, _short, _role, _level, _party, _extra) {
    var _d = _level - 9;
    var _hp = 44 + 9 * _d;
    var _atk = 13 + 3 * _d;
    var _def = 11 + 2 * _d;
    var _mdef = 6 + _d;
    var _xp = 28 + 8 * _d;
    var _gmin = 12 + 3 * _d;
    var _gmax = 20 + 4 * _d;
    if (_role == "elite") { _hp *= 2; _atk += 2; _def += 2; _xp = round(_xp * 2.5); _gmin *= 2; _gmax *= 2; }
    if (_role == "boss") { _hp = round(_hp * 1.2 * max(1, _party)); _atk += 3; _def += 3; _xp *= 8; _gmin *= 6; _gmax *= 6; }
    var _e = { id: _id, name: _name, short_name: _short, max_hp: _hp, attack: _atk, defense: _def, mdef: _mdef, spd: 10, max_mp: 0,
               xp_reward: _xp, gold_min: _gmin, gold_max: _gmax, gold_reward: round((_gmin + _gmax) / 2), placeholder: true,
               level: _level, role: _role, is_boss: (_role == "boss") };
    if (is_struct(_extra)) {
        var _names = variable_struct_get_names(_extra);
        for (var _i = 0; _i < array_length(_names); _i++) _e[$ _names[_i]] = _extra[$ _names[_i]];
    }
    if (variable_struct_exists(_e, "hp_mult")) _e.max_hp = max(1, round(_e.max_hp * _e.hp_mult));
    if (variable_struct_exists(_e, "def_add")) _e.defense += _e.def_add;
    if (variable_struct_exists(_e, "atk_add")) _e.attack += _e.atk_add;
    return _e;
}

/// Battle background area for a batch 7–8 enemy id ("" = decide by room / encounter).
function scr_enemy_battle_area(_enemy_id) {
    switch (_enemy_id) {
        case "dock_thug": case "cutpurse": case "debt_collector": case "debtman": return "lower_city";
        case "ward_sentinel": case "glyph_wisp": case "aethari_automaton": case "sanctuary_warden": return "sanctuary_hall";
        case "garrison_pikeman": case "garrison_field_surgeon": case "garrison_knight": case "commander_hailen": return "garrison_yard";
        case "shade_stalker": case "briar_hulk": case "burn_line_hulk": case "lost_one": case "night_moth_swarm":
        case "door_warden": case "door_warden_boss": case "ward_sentinel_late": case "blackwood_matriarch": return "blackwood";
    }
    return "";
}
