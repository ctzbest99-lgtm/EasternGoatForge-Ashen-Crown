# Decisions and Open Questions

## Confirmed
- Working title: ASHEN CROWN; GameMaker/GML.
- Dark medieval fantasy RPG; top-down classic JRPG exploration, not side-view.
- Protagonist: Kael Varyn; tragic backstory planned, details not locked as canon.
- Tone: atmospheric and serious with some lighthearted moments.
- Classic menu-driven turn-based combat; planned four-person battle party.
- Zone 1 standard enemies: Bandit and Fallen Knight.
- No automatic enemy level scaling by default.
- Planned menu: equipment, party order, items, save/load, status, Bestiary.

## Owner-decided (2026-11-14)
- Defeat: when the party loses a battle, they wake up back in town with HP fully restored. Until a town room exists, the respawn target is `TOWN_RESPAWN_ROOM` (currently `rm_overworld`), at `obj_respawn_point` if one is placed (the overworld builder drops one at Greyhaven `town_square`), otherwise at `TOWN_RESPAWN_X` / `TOWN_RESPAWN_Y` (3192, 2832). A short placeholder wake-up dialogue is shown through the existing dialogue box and reports the gold and XP lost.
- Defeat penalty: lose `DEFEAT_GOLD_LOSS_PCT` of current shared gold (floored) and `DEFEAT_XP_LOSS_PCT` of each member's XP progress toward the next level (`floor((xp - scr_xp_for_level(level)) * 0.1)`), never causing a level-down or a negative total. Defaults are 50% gold and 10% of progress; exact percentages are pending tuning.
- Random encounters: classic JRPG walking encounters using a randomized steps-until-encounter counter (distance-based). Steps count only while the player is actually moving and input is not locked, after a grace period following battle or room entry. Per-area tables (an `obj_encounter_zone` and/or a room table in `scr_encounter_tables`) pick a weighted enemy from `scr_enemy_database`. Towns and other rooms with no table are safe. `obj_encounter_trigger` remains for fixed boss/story fights. Encounter rates are pending tuning (defaults: 16 pixels per step, 8–24 steps between fights, 5 grace steps).
- Ashbound parchment (Chapter 1, approved 2026-11-14): the first Ashbound Hunter fight in the Old Watchtower is a guaranteed scripted encounter (`enc_ashbound_hunter_wt`), so the parchment cannot be missed. The rare 3–5% random Hunter stays on the Old Road, Bandit Camp, and Watchtower. If the parchment was already obtained from a rare fight (`flag_parchment_found`), the guaranteed fight still happens but the pickup and post-fight lines (`ENC_AH_03`–`05`) are skipped.

- Battle XP (2026-11-14): when an enemy dies, its XP is credited to each party member who has already participated (taken at least one turn: Attack, Guard, or Swap) **and** is not KO'd at that moment. Credit is accumulated per member (`pending_xp`) and applied at victory, including level-up messages. If the party loses, no XP is granted. Gold stays shared. A reserve/bench member who swapped in and has taken a turn counts from then on, but gets no credit for enemies that died before their first turn. A member KO'd before an enemy dies gets no XP for that enemy, but keeps credit for enemies that died while they were still standing. A mid-battle Swap command lets an active member switch with the reserve; it costs that member's turn, and the incoming member acts on later rounds.

## Still undecided
GameMaker version; room resolution and whether 640×360 stays (height is not a multiple of 16) or is replaced by a 16-aligned size (e.g. 640×368, 320×180 with a 2× window, or 256×224); camera / view size; input mapping; battle room versus overlay; exact backstory; party members/classes; rare encounter and boss identity/mechanics; license/proprietary status; save-point locations and whether a save-anywhere debug key stays; official item prices and the shop sell rate (defaults below); exact defeat gold/XP percentages (defaults 50% gold / 10% of XP-to-next-level, pending tuning); whether a defeat should also deduct items; exact random-encounter rates and table weights (defaults 8–24 steps, 5 grace, 3:1 Bandit/Fallen Knight); Ashbound Hunter placeholder stats and rare rate (default 4%, midpoint of 3–5%); whether a defeat during the scripted Watchtower Hunter fight should consume the trigger (currently it does not, so the parchment cannot be missed); whether that scripted fight should grant regular XP/gold (currently yes, using the same per-enemy living-participant rule); XP curve, max level, and level-up stat growth (placeholder defaults below); whether the defeat penalty should also hit the reserve; whether story events lock or force party slots. Treat these as open questions, not approved requirements.

## Prototype assumptions (party + progression; pending owner approval)
These were chosen so roadmap step 4 could be built. None is a locked design decision.
- Party roster (coder note from STORY_BIBLE.md, confirmed 2026-11-14): five permanent members — Kael (Vanguard), Lyra (Rogue), Caelan (Arcanist), Sera (Warden), Taren Holt (Rebel Captain, Broken Yoke). Four fight at a time; one reserve slot. Array order of `global.game.party` is battle command and turn order. Default run: Kael only has joined; the other four exist on `global.game.roster` but are not in a slot. `DEBUG_ADD_FULL_ROSTER` puts Kael/Lyra/Caelan/Sera in active and Taren in reserve.
- Defeat *check* and the defeat gold/XP *penalty* apply to active members only (assumption). Reserve HP is still restored on a defeat. Battle XP is owner-decided (see above): participation only.
- Placeholder roster stats (pending approval, not canon): Lyra 24/7/1, Caelan 22/8/1, Sera 28/4/4, Taren Holt 36/8/3 (warrior-leaning). Taren's `weapon_categories` is `["heavy_sword"]` and his equipment stub starts with `bastard_sword` (PLACEHOLDER ATK +3, applied to `attack` via `scr_actor_refresh_equipment`). Skills are placeholders.
- Each member has their own `level` and `xp`. Gold is still a shared party total. `global.game.xp` mirrors Kael's (`party[0]`) XP for the debugger.
- XP curve (total XP to *be* level L): `20*(L-1)^2 + 10*(L-1)`. L1=0, L2=30, L3=100, L4=210, L5=360, L10=1710, L20=7410 (cap 20).
- On level-up: +4 max HP, +1 ATK, +1 DEF (placeholder). Living members also gain the HP increment as current HP; KO'd members stay at 0 HP.
- When an enemy dies, its XP is banked to members who have already taken a turn and are still living. A KO'd member does not receive that enemy's XP, even if they acted earlier; they keep any credit from enemies that died before they fell. A reserve member who swapped in and has taken a turn is eligible for later kills only. Banked XP is applied at victory (level-up messages still play). A defeat grants no XP. Gold is still shared among the party.
- Equipment slots (`weapon`, `armor`, `accessory`) are live: equipped bonuses add to `base_attack` / `base_defense`. The I / Tab inventory can use consumables and equip gear. Status, party-order, and Bestiary menus are still unbuilt.


## Prototype assumptions (saves + shops; pending owner approval)
These were chosen so roadmap step 5 (menus/saves) could start. None is a locked design decision.
- Save format: versioned JSON (`save_schema_version` 1) written with `buffer_text` to `save1.sav`–`save3.sav` in the working directory. A missing or corrupt file is refused; it does not crash. A version below 1 or above `SAVE_SCHEMA_VERSION` is refused.
- What is saved: party roster (HP, max HP, levels, XP, base/current ATK and DEF, equipment, joined flag), active and reserve slot ids, gold, inventory and key items, story flags, cleared encounters, current room name, player position and facing, playtime, and pending story fields that matter (`pending_post_dialogue`, Ashbound pending id, encounter-step counters). Mid-battle and title-screen states are not saved.
- Save access: a prompt after `CV_END`, plus `obj_save_point` in the Greyhaven chapel (tile 10, 7) and tavern (tile 10, 6). Both locations are temporary. `#macro DEBUG_SAVE_ANYWHERE` (F5) is off by default.
- Title Continue is enabled when any slot exists and shows location, lead level, playtime, and gold. New Game resets `global.game`.
- Shops are data-driven (`scr_shop_data`). `shop_greyhaven_store` (Marda) sells Minor Potion and Antidote (confirmed stock). `shop_greyhaven_forge` (Pell, after `flag_pendant_found`) sells Iron Sword, Leather Armor, and Iron Helm — PLACEHOLDER stock from Chapter 1 item art, not unique rewards. Talking plays the confirmed lines, then the menu opens. Buy / Sell / Exit, icons, prices, quantity, gold, owned count, and equipment preview (who can equip it, ATK/DEF change) are implemented. Sell is 50% of buy price (PLACEHOLDER, floored, minimum 1). Key items cannot be sold. Input is locked while the shop is open.
- PLACEHOLDER prices: Minor Potion 15g (heals 15 HP), Antidote 20g, Iron Sword 80g (ATK +3, longsword), Leather Armor 60g (DEF +2), Iron Helm 40g (accessory, DEF +1). No prices appear in CHAPTER1_SCRIPT.md or STORY_BIBLE.md.
- Inventory (I / Tab): use Minor Potion; Antidote cures an overworld `poisoned` flag (battle poison does not exist yet, so it usually reports no effect). Equipment can be worn from this menu. Dedicated shop / save / inventory art will land later in `/workspace/sprites/ui/menus/`; menus look up those sprite names first and fall back to the nine-slice windows, font, cursor, and item icons. Layout constants are centralized in `scr_menu_layout.gml`.

## Enemy batches 7–8 (feature/enemy-batches-7-8; pending owner approval)
Design batch 7 (Wrenfield elite, Lower City, Hollow Sanctuary, Blackwood Road Garrison) and batch 8 (Act III, the Blackwood) are in the enemy database with sprites and encounter tables. No rooms or story beats use them yet. **Everything below is a PLACEHOLDER.**
- **Stats come from a template** (`scr_enemy_scaled(id, …, role, level, party, extra)`), calibrated so a level-9 common matches the balance-pass Chapter 2 regulars and grows like the tiered party growth. Elite: ×2 HP, +2 ATK / DEF, ×2.5 XP. Boss: HP × 1.5 × expected party size, +3 ATK / DEF, ×8 XP. Per-enemy tweaks: Cutpurse ×0.8 HP; Wisp ×0.75 HP; Surgeon ×0.8 HP; Briar Hulk ×1.4 HP; Moths ×0.7 HP; Ward Sentinel and Door Warden +3 DEF. SPD is set per enemy.
- **Levels** use ACT2_OUTLINE's PROPOSED bands: Lower City (Ch 3) 10–13, Hollow Sanctuary (Ch 4) 13–16, Garrison (Ch 5) 16–18. The Blackwood (Act III) is 18–20, which is my placeholder. **Open:** `PARTY_MAX_LEVEL` is 20, so Act III will need a higher cap.
- **Expected party sizes for bosses:** Debtman 3 (after Lyra); Sanctuary Warden, Commander Hailen and the Matriarch 4.
- **Template check** (Kael at the enemy's level, still in Chapter 2 gear, so later gear makes these easier):

| Enemy level | Role | HP / ATK / DEF | Kael hits to kill (same level, Ch2 gear) | Damage to Kael per hit |
|---|---|---|---|---|
| 11 | common | 58 / 17 / 15 | 4 | 8 of 94 HP |
| 11 | elite | 116 / 19 / 17 | 7 | 10 of 94 HP |
| 11 | boss (party 4) | 348 / 20 / 18 | 22 | 11 of 94 HP |
| 14 | common | 79 / 23 / 21 | 4 | 11 of 124 HP |
| 14 | elite | 158 / 25 / 23 | 8 | 13 of 124 HP |
| 14 | boss (party 4) | 474 / 26 / 24 | 25 | 14 of 124 HP |
| 17 | common | 100 / 29 / 27 | 5 | 14 of 154 HP |
| 17 | elite | 200 / 31 / 29 | 9 | 16 of 154 HP |
| 17 | boss (party 4) | 600 / 32 / 30 | 28 | 17 of 154 HP |
| 19 | common | 114 / 33 / 31 | 5 | 16 of 174 HP |
| 19 | elite | 228 / 35 / 33 | 10 | 18 of 174 HP |
| 19 | boss (party 4) | 684 / 36 / 34 | 29 | 19 of 174 HP |

- **New kit mechanics:**
  - **Steal** (Cutpurse): 60% damage plus 8–20 shared gold. A beaten Cutpurse returns what it took at victory.
  - **Heal ally** (Field Surgeon): 30 HP to the most-hurt ally, only while some ally is below 60% HP.
  - **Buffer elite** (Crown Sergeant Rally): +20% ATK to his side for 3 rounds, only with allies.
  - **Two-phase bosses** (Sanctuary Warden, Blackwood Matriarch): the shift happens at 50% HP and plays `trans`, then `idle_p2` / `attack_p2`. Warden +20% ATK; Matriarch +25% ATK and +20% SPD. Their phase lines are mine.
  - **Yield-or-death** (Commander Hailen): he yields only if `flag_hailen_yields` is set (no story sets it yet). Otherwise he dies. A yield sets `flag_hailen_yielded`.
  - **Blind** (70%, 3 rounds): physical attacks miss 50% of the time.
  - **Sleep** (50%, 2 rounds): the turn is skipped, any damage wakes, and sleeping does not count as taking a turn for XP.
  - Moth dust and the wisp mote fly on cast frame 3. Blind and sleep show as "Bl" / "Sl" in the party window, because the status strip has no frames for them.
  - **Shade Stalker Fade:** for the rest of the round, physical attacks against it miss; drawn at 40% alpha.
  - **Calder idle_p2:** the stance plays once, then `idle_p2` loops (already in place).
- **Boss groups (from Design's mockups):** Debtman + Dock Thug; Warden + Ward Sentinel; Hailen + Garrison Pikeman; Matriarch + Shade Stalker. The Crown Sergeant also appears in the Wrenfield table.
- **blackwood_matriarch is a PLACEHOLDER boss** (Design's proposal, not canon); its name, role and kit wait on Kevin. **lost_one** is a revise-friendly id; its concept may change.
- **Weaknesses** (placeholders): Crown / Garrison troops lightning; Aethari constructs lightning; Briar Hulk and Moths fire; Shade Stalker, Lost One and Matriarch holy. No party skill has an element yet.
- **Open:** Design still needs status icons for blind and sleep.

## Balance pass (feature/balance-pass; pending owner approval)
Every number here is a PLACEHOLDER chosen with `tools/balance_sim.py` (run `python3 tools/balance_sim.py`; it mirrors the GML damage formula, Guard, buffs, SPD order, and enemy AI weights). Targets from the brief: Act II winnable at levels 8–10, Reeve Calder ≈ 8–15 party turns, Occupation Soldiers ≈ 3–5 hits, Chapter 1 unchanged.
- **Party growth is tiered.** Level-ups into levels 2–7 keep the Chapter 1 numbers (+4 HP, +1 ATK, +1 DEF, +2 MP, +1 SPD, +1 MDEF). Level-ups into level 8 and above give +10 HP, +2 ATK, +2 DEF, +3 MP, +1 SPD, +1 MDEF (`LEVEL_UP_TIER_LEVEL`, `LEVEL_UP_*_GROWTH_HIGH`). Chapter 1 is levels 1–7, so its numbers and the Blackguard fight are unchanged. Old saves keep their stored HP / ATK / DEF; their MP / SPD / MDEF use the tiered totals.
- **Gear curve.** End of Chapter 1: Kael ATK +5 (Blackguard's Longsword), DEF +3 (Leather Armor + Iron Helm). Taren joins with the Bastard Sword (ATK +3) and a new **Travel Brigandine** (DEF +2, not sellable). Len sells **Chain Mail** (DEF +4, 220 g) as the Chapter 2 mid-tier item, after the rescue, so the Calder fight does not depend on it.
- **Taren joins at Kael's level** (`scr_actor_raise_to_level`, used by the Chapter 2 wiring). The sim assumes both are the same level.
- **Act II enemies, lowered from Design's suggestions** (HP / ATK / DEF): Crown Patrolman 44 / 13 / 12 (was 90 / 16 / 12), Crown Crossbowman 36 / 14 / 8 (70 / 18 / 8), Occupation Soldier 50 / 12 / 14 (120 / 17 / 16), Bandit Veteran 42 / 13 / 10 (95 / 18 / 11), Grey Ash Wolf 36 / 13 / 8 (80 / 20 / 8), Reeve Calder 130 / 15 / 16 (320 / 24 / 18). SPD, MDEF, XP and gold are unchanged. Calder's stance (+25% ATK, +15% DEF) is unchanged.
- **Millhaven Road groups stop at 2**, because Kael walks it alone (Taren joins at the Calder fight). The 3-enemy Crown group was replaced by a single Crossbowman. The Wrenfield table keeps its groups but is never rolled (no random battles in the village).
- **No in-battle healing exists** (no Item command yet), so every fight is balanced to be survivable on HP alone. **Open:** add an in-battle Item command, which would make the level-8 Calder fight easier.
- **MP recovery:** +2 MP after each win (kept). **Ether** restores 10 MP (60 g; Len's shop and a Millhaven Road chest). The **Wrenfield inn** (The Bent Post, Perrin) costs **30 g** and restores HP and MP for the active party and reserve. All placeholders.
- **Calder's yield (placeholder rule):** if Calder yields while soldiers still stand, they withdraw, but their XP is credited at the moment of the yield to the members who took a turn and are standing, and their gold is added at victory.

Simulated results, 4,000 runs per row. Policy: Taren opens with Rallying Cry, Cleaves while 2+ enemies stand, and otherwise everyone hits the weakest add first, then Calder. No Guard, no items. "Turns on Calder" counts party actions that damaged him (Cleave split across targets).

| Fight | Lv | Party | Win % | Rounds | Party turns | Turns on Calder | Party HP left |
|---|---|---|---|---|---|---|---|
| Millhaven: 1 Patrolman | 8 | Kael | 100% | 4.0 | 4.0 | — | 71% |
| Millhaven: Patrolman + Crossbowman | 8 | Kael | 100% | 7.0 | 7.0 | — | 17% |
| Millhaven: 2 Bandit Veterans | 8 | Kael | 100% | 6.0 | 6.0 | — | 23% |
| Millhaven: 2 Grey Ash Wolves | 8 | Kael | 100% | 6.0 | 6.0 | — | 22% |
| Calder + 2 Occupation Soldiers | 8 | Kael+Taren | 25% | 11.7 | 22.2 | 13.9 | 13% |
| Millhaven: 1 Patrolman | 9 | Kael | 100% | 3.4 | 3.4 | — | 83% |
| Millhaven: Patrolman + Crossbowman | 9 | Kael | 100% | 6.5 | 6.5 | — | 41% |
| Millhaven: 2 Bandit Veterans | 9 | Kael | 100% | 6.0 | 6.0 | — | 43% |
| Millhaven: 2 Grey Ash Wolves | 9 | Kael | 100% | 6.0 | 6.0 | — | 42% |
| Calder + 2 Occupation Soldiers | 9 | Kael+Taren | 94% | 10.2 | 19.1 | 11.3 | 27% |
| Millhaven: 1 Patrolman | 10 | Kael | 100% | 3.0 | 3.0 | — | 89% |
| Millhaven: Patrolman + Crossbowman | 10 | Kael | 100% | 5.0 | 5.0 | — | 71% |
| Millhaven: 2 Bandit Veterans | 10 | Kael | 100% | 6.0 | 6.0 | — | 58% |
| Millhaven: 2 Grey Ash Wolves | 10 | Kael | 100% | 4.0 | 4.0 | — | 71% |
| Calder + 2 Occupation Soldiers | 10 | Kael+Taren | 100% | 8.2 | 16.0 | 9.6 | 54% |

| Level | Kael ATK / DEF / HP | Taren ATK / DEF / HP | Hits (Kael) to kill: Occ. Soldier | Patrolman | Crossbowman | Bandit Vet. | Grey Wolf | Calder (pre-stance) |
|---|---|---|---|---|---|---|---|---|
| 7 | 17 / 11 / 54 | 17 / 11 / 60 | 5 | 4 | 3 | 4 | 3 | 15 |
| 8 | 19 / 13 / 64 | 19 / 13 / 70 | 5 | 4 | 3 | 3 | 3 | 12 |
| 9 | 21 / 15 / 74 | 21 / 15 / 80 | 4 | 3 | 3 | 3 | 3 | 10 |
| 10 | 23 / 17 / 84 | 23 / 17 / 90 | 4 | 3 | 2 | 3 | 2 | 9 |

Reading: at level 8 the Calder fight is hard (about 25% for this naive policy); at 9 it is about 94%; at 10 it is reliable. Calder takes about 10–14 party turns, inside the 8–15 target. Occupation Soldiers take 4–5 Kael hits at levels 8–10. Kael alone clears every Millhaven Road group from level 8.

## Prototype assumptions (battle upgrade; pending owner approval)
Built on `feature/battle-upgrade` (depends on PR #10). Every number below is a PLACEHOLDER unless marked canon. Owner-decided rules above (XP per enemy to living participants, defeat penalty, random encounters, Swap) are unchanged.
- **Canon used:** Taren's Rallying Cry (raises party Attack for 3 turns), Cleave (hits all enemies for reduced damage), Unbowed (passive, resists Fear and Stun) — STORY_BIBLE.md §5.5 / CHAPTER2_SCRIPT.md WF_CALDER_SYS. Reeve Calder's kit (Guard, a shout that buffs his soldiers, a heavy strike, a harder stance when the detachment falls, he yields and lives). Blackguard 450 HP / phases / Phase 3 SPD +30%.
- **New stats (placeholder base, then growth per level):** SPD / MDEF / MP — Kael 10 / 2 / 6, Lyra 14 / 2 / 6, Caelan 9 / 5 / 16, Sera 8 / 5 / 12, Taren 9 / 2 / 12. Level-up growth: +2 max MP, +1 SPD, +1 MDEF (on top of the existing +4 HP / +1 ATK / +1 DEF).
- **Turn order:** sorted by SPD each round (after all commands are chosen), tiebreak `random(0.99)`. Buffs and the Blackguard's speed mod count.
- **MDEF** is stored, saved, and grows, but no current skill deals magic damage, so it has no effect yet.
- **Skills (placeholder costs / percentages):** Rallying Cry 4 MP, +25% ATK to all living allies for 3 rounds (ticks at round start, so the cast round + 2). Cleave 3 MP, 60% of normal damage to each living enemy. Unbowed is implemented as a status resist; nothing inflicts Fear or Stun yet. Only Taren has skills; Kael / Lyra / Caelan / Sera have none (Skill hidden).
- **Elemental weakness:** ×1.5 damage (`BATTLE_WEAKNESS_MULTIPLIER`). Only Blackguard (holy), Ashbound Hunter (ice), Ash Wolf / Grey Ash Wolf (fire), and the Crown troops (lightning, placeholder) have one. No party skill has an element yet, so it never triggers in play.
- **MP recovery:** +2 MP per member after each victory (`BATTLE_VICTORY_MP_REGEN`), full MP on defeat respawn. There is no inn, Ether, or MP item — **open**.
- **Enemy AI weights (placeholder):** Chapter 1 specials keep their old odds (Howl / Scream 1 in 5, Web / Shield Wall 1 in 4, Blackguard per phase). Patrolman Attack 2 / Thrust 2 (×1.2) / Brace 1 (+50% DEF, 2 rounds, not while active). Crossbowman Bolt only. Occupation Soldier Attack 2 / Slash 2 (×1.1) / Guard 1. Bandit Veteran Attack. Grey Ash Wolf Attack 4 / Howl 1. Calder Heavy Strike 3 (×1.3) / Guard 1 / Rallying Shout 2 (6 MP of 20, +25% ATK to his side for 3 rounds, only while a soldier stands); alone: Heavy Strike 3 / Guard 1.
- **Calder stance:** +25% ATK and +15% DEF for the rest of the battle, once, when his last add falls. A system line ("Reeve Calder takes a harder stance!") replaces the bark; WF_CALDER_PHASE2_01 is left for the Chapter 2 dialogue task.
- **Calder yield:** at 0 HP he yields instead of dying (HP held at 1), the battle ends as a victory with his full XP / gold, and `flag_reeve_calder_yielded` is set. Soldiers still standing withdraw with no XP / gold — **open** (could instead require clearing the adds). `flag_execution_stopped` and the defeat dialogue are left for the Chapter 2 dialogue task.
- **Calder group:** boss + `CALDER_ADD_COUNT` (2) Occupation Soldiers (brief allowed 2–3). Formation slots (GUI coords, feet): 1 enemy (86, 118); 2 → (52, 112), (98, 124); 3 → (36, 108), (64, 120), (100, 126); boss (100, 124) with adds (30, 106), (52, 127), (14, 124).
- **Act II enemies:** Design's suggested HP / ATK / DEF / MDEF / SPD / XP / gold (not approved). Gold is rolled in `gold_min`–`gold_max`. Grey Ash Wolf MDEF 4 and gold 10–16 are mine (Design gave none). Crown "lightning" weakness is a placeholder.
- **Act II encounter stubs:** `ch2_millhaven_road` and `ch2_wrenfield` (level band 8–10) with single and group entries — weights are placeholders. No Act II rooms, zones, or dialogue are wired.
- **Act II battle backgrounds:** Wrenfield and the Calder fight reuse the Greyhaven background; Millhaven Road reuses the forest one until Design paints new ones.
- **Chapter 2 balance — open, needs tuning:** with placeholder growth, a level-9 Kael (ATK ~13 + gear) deals single-digit damage to Calder (DEF 18) and to Occupation Soldiers (DEF 16), so the fight would take ~40 hits. Either party growth, Chapter 2 gear, or Design's enemy DEF must change before Act II is playable.
- **Save schema v2:** members now save MP, max MP, base SPD / MDEF, skills, and passives. v1 saves are upgraded on load (level-scaled defaults, full MP). Buffs and statuses are battle-only and not saved.

## Prototype assumptions (Zone 1 overworld + sprites; pending owner approval)
These were chosen so Design's map and art could be wired into the existing prototype. None is a locked design decision.
- `rm_overworld` is the 400×300-tile Eldara hub (6400×4800 px) including Zone 1 "The Ashen Road" and Greyhaven. `rm_old_watchtower` is 60×45 tiles (960×720). Tile size is 16×16 (`TILE_SIZE`). The old 640×360 test layout is retired.
- Overworld uses the 16×24 Kael / Bandit sheets on that 16×16 grid. `PLAYER_MOVE_SPEED` is 1 (same tiles per second as the earlier speed of 2 on 32 px tiles). `PLAYER_INTERACT_REACH` is 4. Encounter steps are 16 pixels so "8–24 steps" still means 8–24 tiles.
- Town respawn is Greyhaven `town_square` (3192, 2832). The builder drops `obj_respawn_point` there. `player_start` is the south-road opening (199, 186) and is not the defeat wake-up tile.
- Y-sort with `depth = -y`. Overworld `left` is a pre-mirrored sheet; `image_xscale` stays 1. Battle party members are flipped with `xscale = -1` because battle strips only face right.
- Battle playback: idle 6 fps, attack/hurt/death 10 fps, drawn in Draw GUI at `BATTLE_SPRITE_SCALE` 2. Damage is applied at about 60% through the attack clip; a KO plays death instead of hurt and holds the last frame. Confirm skips the clip. There is no Guard pose in the art.
- Camera view 320×180, optionally displayed at 2× (640×360 window). `CAMERA_FOLLOW_PLAYER` is on. `scr_camera_follow_player` is defined once in `scr_map_tilemaps.gml` and called from `obj_game_controller` End Step. Overhead tiles use depth -10000 so they stay above a player that y-sorts with `depth = -y`.
- Greyhaven is safe (no encounter zone, no room-wide table). Other areas use the existing `obj_encounter_zone` API with tables `zone01_farmlands`, `zone01_old_road`, `zone01_bandit_camp`, `zone01_watchtower`. Only Bandit Camp and Watchtower opt into the `zone01_path` fallback (which includes Fallen Knights). Farmlands and the Old Road do not.
- Blackguard placeholder stats: 80 HP, 12 ATK, 8 DEF, 50 XP, 30 gold. Not balanced.
- Entrances to rooms that are not built yet (`rm_valemere`, `rm_frostwilds_settlement`, `rm_coast_village`, `rm_watchtower_basement`, `rm_ashlands_breach`, and others) only show a placeholder dialogue line.
- A story-flag system and key-item inventory helpers exist (`scr_flag_get` / `scr_inventory_add`). The Tomas scene (`GH_TOMAS`, inside the Blacksmith), Mira's pendant (`GH_HOUSE_03`–`05` inside Varyn House, actually added to inventory), banner clue (`WT_BANNER`), Fallen Knight beats (`FK_01` / `FK_02`), arrival (`GH_ARRIVAL`), survivor talk (Hob, Ilse, Marda, Wenna, Dov, Corwin), `WB_CARVING`, `BG_INTRO` / `BG_DEFEAT`, and `CV_END` (after `blackguard_defeated`) are wired from Chapter 1 confirmed lines. Chapter 2 `[PROPOSED]` lines are not wired. Marda's store and Pell's forge (after the pendant) open a Buy / Sell / Exit shop overlay. The locked terrace stairs are a blocking `obj_interactable` (`watchtower_basement_cleared` is named but not yet enforced in code).
- The guaranteed Ashbound Hunter fight (`enc_ashbound_hunter_wt`) is spawned in `rm_old_watchtower` on walkable tile (33, 33), on the way to `old_royal_banner` (41, 25). Interactables are fitted to one 16×16 tile so a 32×32 placeholder cannot cover the trigger. Rare Hunter rolls are allowed on `zone01_old_road`, `zone01_bandit_camp`, and `zone01_watchtower` (short ids `old_road` / `bandit_camp` / `watchtower` still work).
- Bandit overworld sheets are in the repo but not used by any object yet. There is no Fallen Knight overworld sheet. Battle assets are named `spr_hero_*`; overworld Kael is `spr_kael_ow*`.

### Placeholders still waiting on Kevin (story bible Open, or not implemented)
- Names of the Frostwilds settlement and the Drowned Coast village.
- Whether the new `royal_banner` / `carving_crown_sun` tiles and `spr_item_mira_pendant` match the confirmed crown-ringing-a-black-sun design (the tiles are in the Design drop; they have not been visually approved in GameMaker).
- Several chest loots (`hidden_grove_chest`, `watchtower_chest_2`, `watchtower_chest_3`).
- What lies past the Crownveil breach (`CV_END` is still a stub).
- PLACEHOLDER combat stats (not approved) now exist for **ash_wolf**, **ashen_wretch**, **grave_spider**, and **hollow_soldier**, plus the existing placeholder Blackguard / Ashbound Hunter entries. Blackguard canon is 450 HP with three phases and 250 XP / 100 Gold; the current entry and rewards are still placeholders. Battle sprites for the new enemies fall back to rectangles. FL_TUTORIAL system lines are not implemented. Chest loot marked `placeholder` is not invented. Official shop prices, Pell's final stock, and the 50% sell rate are PLACEHOLDER (open). Save-point tiles in the chapel and tavern are temporary (open). Battle poison is not implemented; Antidote only clears an overworld `poisoned` flag.

## Prototype assumptions (exploration + battle prototype; pending owner approval)
These were chosen so roadmap steps 2–3 could be built. None is a locked design decision.
- Battle presentation: dedicated room `rm_battle_test` rather than an overlay.
- Input: arrows move; Z/Enter/Space confirm; X/Backspace cancel. Diagonal movement kept from the original snippet.
- Collision: `obj_solid` objects plus an optional tile layer named `Collision`; requires GameMaker 2023.1+.
- Placeholder sizes: player **16×24** (FF1-scale overworld, origin 8, 23) with a 16×16 standing-tile feet mask; room placeholders 16×16; rooms still **640×360**. 360 is not a multiple of 16 (22 tiles + 8 px). Battle battlers stay 32×48 side-view strips (death 48×48; Fallen Knight attack 64×48). A 32×48 overworld set exists as a fallback only.
- Party defaults and progression numbers: see "Prototype assumptions (party + progression)" above. Guard still halves incoming damage (min 1) until the party's next command phase.
- Fixed `obj_encounter_trigger` encounters are removed after victory for the session. Whether cleared triggers persist in saves is undecided. Random walking encounters are owner-decided (see above); they are not cleared after victory.
- Enemy HP is visible in battle for debugging; whether players see enemy HP is undecided.
- Chapter 1 overworld / Watchtower sign wording is C-confirmed (see CHAPTER1_SCRIPT.md). Battle messages and remaining inspect text (chests, Renn, unbuilt rooms) are still placeholders.
