# Equipment progression, Acts I–VIII

Status: **built, wired for tiers I–VIII, not playtested.**
Boss and encounter bands were retuned against tiers VI–VIII on 2026-11-18 (see the end of this doc).
Every stat, price and drop chance here is PLACEHOLDER until a balance pass is approved.
Run `python3 tools/equipment_check.py` for the live tables and the boss balance check.

## What the system is

One central item table (`scr_item_data.gml`) now carries the full progression metadata, so gear is
never hard-coded in shops or battles:

| Field | Meaning |
|---|---|
| `kind` / `slot` | `weapon`, `armor`, `helm`, `accessory` (plus `consumable`, `key`, `misc`) |
| `rarity` | `common`, `uncommon`, `rare`, `legendary` (shown in the equip preview) |
| `act` | 1–8 — the tier the piece belongs to; `0` = starting / story gear |
| `atk_bonus`, `def_bonus`, `mdef_bonus`, `spd_bonus` | Stat bonuses; MDEF and SPD now actually apply (`scr_actor_refresh_equipment`) |
| `classes` | Roster `class_name`s allowed to wear it; empty = anyone. Weapons also still use `weapon_categories` |
| `unique` | One per party, cannot be sold, one-time boss drops |
| `acquisition` | The source, in words, for the docs and the checker |

Progression unlocks with chapter completion. `scr_story_act()` maps chapters to tiers by their level
bands: `flag_act2_started` → 2, `flag_chapter2_complete` → 3, `flag_chapter3_complete` → 4,
`flag_chapter4_complete` → 5, `flag_chapter5_complete` → 6, `flag_act3_complete`/`chapter8_complete` → 7,
`flag_act4_complete`/`chapter11_complete` → 8. Story acts are coarser than tiers — Act II spans Chapters
2–5, so `flag_act2_complete` only fires after Chapter 5 and is deliberately not used for gating.
Merchants stock their base list plus every `stock_by_act` row at or below the current tier, so the shelf
matches the act the player is in.

Acquisition paths, all four in use:

* **Merchants** — `scr_shop_stock()` filters stock by act; the Greyhaven forge also runs the crafting counter.
* **Enemy loot** — `drops` on the enemy entry, now supporting `qty` and `once` (guaranteed, one per save) alongside `chance`.
* **Treasure** — chest loot names any item in the DB (`scr_item_id_for_name`), not just potions.
* **Crafting** — `scr_craft_recipes()`: tiered materials plus gold, unlocked by act, never legendary.

Legendaries cannot be bought or crafted: they are `unique`, refused by the inventory if duplicated,
and dropped once per save by their boss.

## Tiers at a glance

Every act has a weapon for all five classes, plus armour, a helm or accessory, and a boss legendary.
Bows sit outside the matrix: no current class has bow proficiency, so the six bow records are marked
reserved and are not stocked. Assigning a bow user is an owner decision, not an equipment fix.

| Act | Levels | Armour / accessory tier | Weapons (one per class) | Legendary |
|---|---|---|---|---|
| I | 1–7 | Leather Armor, Iron Helm, Hunter's Charm, **Ash Pendant** | Iron Sword, Hunter's Knife, **Apprentice's Codex, Chapel Blade, Yoke Cleaver** | Blackguard's Longsword |
| II | 8–10 | Chain Mail, **Wrenfield Coat, Patrol Helm, Warden's Sigil** | **Millhaven Sabre, Millhaven Stiletto, Millhaven Primer, Penitent Blade, Patrol Greatsword** | Calder's Greatsword |
| III | 11–14 | **Salt-Lampskin Coat, Valemere Helm** | **Ledger Dirk, Valemere Longsword, Ledger Codex, Saltlight Blade, Watchman's Greatsword** | Debtman's Chain |
| IV | 15–17 | **Barrow Plate, Barrow Helm** | **Oathbreaker, Barrow Longsword, Tomb Shard Dirk, Barrow Codex, Vigil Blade** | Sanctuary Oathblade |
| V | 17–19 | **Drowned Coat, Saltreach Charm** | **Tidesteel Blade, Tideglass Dirk, Tidebound Codex, Drowned Bell Blade, Saltreach Maul** | The Drowned Crown |
| VI | 19–21 | **Mine Plate, Architect Ring** | **Ironspine Maul, Ironspine Longsword, Mine Shard Dirk, Architect Codex, Construct's Bane** | Matriarch's Heartwood |
| VII | 21–23 | **Emberweave Robe, Ash Crown** | **Ashlands Edge, Ashglass Dirk, Ember Codex, Cinder Vigil, Ashfall Greatsword** | Barrow King's Blade |
| VIII | 23–24 | **Veil Plate, Veil Ring** | **True-Name Blade, Rime Sword, Veilstep Dirk, Rime Codex, Winterforge Greatsword** | The Forgotten King's Crown |

Bold = new in the equipment passes; the rest already existed and gained act/rarity/source metadata.

## Weapon coverage — every class, every act

The matrix the checker enforces (a missing cell is a failure, not a warning):

| Act | Kael — longsword | Lyra — dagger | Caelan — spellbook | Sera — holy sword | Taren — heavy sword |
|---|---|---|---|---|---|
| I | Iron Sword (ATK +3) | Hunter's Knife (ATK +2) | Apprentice's Codex (+2, MDEF +2) | Chapel Blade (+3, MDEF +1) | Yoke Cleaver (+4) |
| II | Millhaven Sabre (+5) | Millhaven Stiletto (+4, SPD +2) | Millhaven Primer (+4, MDEF +3) | Penitent Blade (+5, MDEF +2) | Patrol Greatsword (+6) |
| III | Valemere Longsword (+7) | Ledger Dirk (+8, SPD +2) | Ledger Codex (+6, MDEF +4) | Saltlight Blade (+7, MDEF +3) | Watchman's Greatsword (+9) |
| IV | Barrow Longsword (+10) | Tomb Shard Dirk (+8, SPD +3) | Barrow Codex (+8, MDEF +5) | Vigil Blade (+9, MDEF +4) | Oathbreaker (+11) |
| V | Tidesteel Blade (+12) | Tideglass Dirk (+11, SPD +3) | Tidebound Codex (+11, MDEF +6) | Drowned Bell Blade (+12, MDEF +5) | Saltreach Maul (+13) |
| VI | Ironspine Longsword (+14) | Mine Shard Dirk (+12, SPD +3) | Architect Codex (+12, MDEF +7) | Construct's Bane (+13, MDEF +5) | Ironspine Maul (+15) |
| VII | Ashlands Edge (+16) | Ashglass Dirk (+14, SPD +4) | Ember Codex (+14, MDEF +8) | Cinder Vigil (+15, MDEF +6) | Ashfall Greatsword (+17) |
| VIII | True-Name Blade (+19) | Veilstep Dirk (+16, SPD +4) | Rime Codex (+16, MDEF +9) | Rime Sword (+16) | Winterforge Greatsword (+20) |

Role shape: longsword is the ATK baseline, heavy sword +1 ATK, holy sword trades a little ATK for
MDEF, dagger trades 1–3 ATK for SPD, spellbook trades 1–3 ATK for the biggest MDEF. Because every
member now carries a tier-appropriate weapon, party damage stays close to one weapon's worth per
person instead of one carry weapon plus four starters.

Starting weapons: Kael's Longsword ATK +3, Taren's Bastard Sword ATK +3, Lyra's Twin Daggers ATK +2,
Caelan's Spellbook ATK +1 / MAG +3 / MDEF +1, and Sera's Holy Sword ATK +4 / MAG +1 / MDEF +1. The
last two are provisional values proposed in this pass; they sit slightly above the Act I shop tier so
joining with the character's own weapon is not a downgrade. Sera's roster entry now starts with the
Holy Sword instead of an empty hand.

MAG is not cosmetic: magic skills use MAG vs MDEF in `scr_battle_skill_damage`, and base MAG is seeded
from ATK so enemies and old saves keep their previous magic damage curve.

### Weapon prices and sources

| Act | Items (class — price — source) |
|---|---|
| I | Apprentice's Codex 90g, Chapel Blade 95g, Yoke Cleaver 100g — Pell's forge, Greyhaven |
| II | Millhaven Stiletto 170g, Millhaven Primer 175g, Penitent Blade 180g, Patrol Greatsword 190g — Len, Wrenfield |
| III | Valemere Longsword 500g, Ledger Codex 500g, Saltlight Blade 510g, Watchman's Greatsword 540g — Valemere arms |
| IV | Barrow Longsword 900g, Tomb Shard Dirk 880g, Barrow Codex 900g, Vigil Blade 920g — barrow gate smith |
| V | Tideglass Dirk 1350g, Tidebound Codex 1380g, Drowned Bell Blade 1400g, Saltreach Maul 1450g — Saltreach armoury; Mott's cart, Blackwood road |
| VI | Ironspine Longsword 1950g, Mine Shard Dirk 1900g, Architect Codex 1950g, Construct's Bane 1980g — Ironspine supply; Mott's cart, Blackwood road |
| VII | Ashglass Dirk 2550g, Ember Codex 2550g, Cinder Vigil 2580g, Ashfall Greatsword 2620g — Sarn's outpost wagon, Ashlands breach |
| VIII | Veilstep Dirk 3150g, Rime Codex 3180g, Winterforge Greatsword 3250g — Rimehold armoury |

Act I and II are on shelves that exist today (Pell, Len), Act III is on the Valemere stall, Acts V and
VI ride on the Blackwood carter's cart, and Act VII is split across the Barrow Gate Smith (Ashlands
Edge, Emberweave Robe, Ash Crown) and Sarn's outpost wagon in the Ashlands breach outpost (the four
class weapons and Ember Core). Rimehold's Act VIII tier is now wired in `rm_rimehold`; Saltreach's and
Ironspine's shops remain data only, with their stock carried by Mott.

## Wired merchants

| Merchant | Room | Shop id | Tier | Unlocks |
|---|---|---|---|---|
| Stallkeeper (existing NPC, `VM_MERCH_01`) | `rm_valemere`, the stall under the blue awning | `shop_valemere_arms` | III | On entering Chapter 3 (`flag_chapter2_complete`) |
| Orrin, Barrow Gate Smith (new NPC, `BG_SMITH_01`) | `rm_barrow_gate`, forecourt at (17,10) | `shop_barrow_smith` | IV row + VII base stock | On entering the barrow gate |
| Mott, Blackwood carter (new NPC, `BW_CARTER`) | `rm_blackwood_deep`, roadside beside the carved stone at (10,6) | `shop_blackwood_carter` | V + VI | V row once Act II closes (`flag_chapter4_complete`); VI row when Chapter 5 closes (`flag_chapter5_complete`) |
| Sarn, Ashlands outpost trader (new NPC, `AO_TRADER`) | `rm_ashlands_breach`, the breach outpost at (8,12) | `shop_ashlands_outpost` | VII | The breach entrance opens after `flag_act4_complete` (provisional, until Act VII exists); the Act VII row unlocks at `scr_story_act()` 7, before that potions, Ether and Ember Core only |
| Rimehold Armourer (generic NPC, `RIMHOLD_ARMOURER`) | `rm_rimehold`, the armoury courtyard at (12,6) | `shop_rimehold_armoury` | VIII | The armoury entrance opens after `flag_act4_complete` (provisional, until Act VIII exists); the tier-VIII row unlocks at `scr_story_act()` 8, so the Chapter 12–14 band can buy it |

All five use the same flow: talk, then the shelf. Valemere plays its existing dialogue node and opens
the shop on finish; Orrin, the Rimehold armourer and the generic shopkeeper path use
`scr_shopkeeper_talk()`; Mott plays his own greeting node (`BW_CARTER_01/02`) and opens the cart on
finish, and his repeat line is act-aware (`BW_CARTER_R1` while the mine crates are still shut,
`BW_CARTER_R2` after). Sarn does the same in the Ashlands breach outpost (`AO_TRADER_01/02`, then
`AO_TRADER_R1` while the weapon crates are sealed and `R2` after).

Rimehold is the Act VIII stopgap: the armoury courtyard `rm_rimehold` is built ahead of the act,
entered from the overworld's existing `rimehold` marker and gated on `flag_act4_complete`. It is the
only wired source for the whole tier-VIII shelf, and it is why the Act V band can now be simulated at
the tier the story unlocks rather than the tier below it.

Mott is why tiers V and VI are reachable at all: Saltreach and Ironspine have no room of their own,
so their armoury stock is stocked on the cart that came up the road with it. The Act V row carries
Tideglass and the five Act V weapons plus Drowned Coat and Saltreach Charm; the Act VI row carries
Architect Alloy and the five Act VI weapons plus Mine Plate and Architect Ring. Both rows unlock by
act, so during Chapter 5 the party sees the coast stock only and the mine crates stay under the tarp —
which is exactly what Mott's `R1` line says. Being the only wired Tideglass source, his Act V row also
makes the three Tideglass recipes craftable for the first time.

The barrow is story Act IV (Chapters 9–11, levels 21–23), so Orrin's base shelf carries the Act VII
items (Ashlands Edge, Emberweave Robe, Ash Crown) as well as his original Act IV row. The tier-4 row is
legacy stock from the first pass: it is listed and legal, but a party at the barrow has outgrown it.
The Ashlands have three built rooms and no act yet: `rm_ashlands_breach` (32×20, generated by
`tools/gen_ashlands_room.py`), the outpost at the Crownveil breach; the ruins beyond it
(`rm_ashlands_ruins`, 40×28); and the undercroft under the ruin's sanctum (`rm_ashlands_depths`,
36×24). The latter two hold no stock. Sarn's wagon stands in the outpost at (8,12)
with the rest of the tier: the four Act VII class weapons — Ashglass Dirk, Ember Codex, Cinder Vigil,
Ashfall Greatsword — plus the Ember Core material. Both overworld entrances (`crownveil_breach` and
`ashlands_broken_structure`) are marked built and provisionally gated on `flag_act4_complete` until
Act VII has a story, the same stopgap shape as Mott's cart covering Saltreach and Ironspine.

## Item catalogue — armour, accessories, materials, legendaries (new this pass)

| Act | Item | Slot | Stats | Rarity | Classes | Price | Acquisition | Wired? |
|---|---|---|---|---|---|---|---|---|
| I | Ash Pendant | accessory | DEF +1, MDEF +2 | uncommon | any | — | Hidden grove chest | Yes (chest) |
| I | Ash Shard | material | — | common | — | 12 | Bandits, wolves, wretches, Fallen Knights; Marda | Yes (drops + shop) |
| II | Millhaven Sabre | weapon (longsword) | ATK +5 | uncommon | Kael | 180 | Len, Wrenfield; forge | Yes (shop + recipe) |
| II | Wrenfield Coat | armor | DEF +4, SPD +1 | uncommon | any | 160 | Len, Wrenfield | Yes (shop) |
| II | Patrol Helm | helm | DEF +3 | uncommon | any | 140 | Len, Wrenfield | Yes (shop) |
| II | Warden's Sigil | accessory | DEF +1, MDEF +3 | rare | any | 200 | Forge (3 Iron Scale + 120g) | Yes (recipe) |
| II | Iron Scale | material | — | common | — | 18 | Crown patrols, occupation soldiers, veterans | Yes (drops + shop) |
| II | Calder's Greatsword | weapon (heavy) | ATK +8 | legendary | Taren | — | Reeve Calder, once | Yes (boss drop) |
| III | Ledger Dirk | weapon (dagger) | ATK +8, SPD +2 | rare | Lyra | 520 | Valemere arms; forge | Yes — Valemere stall |
| III | Salt-Lampskin Coat | armor | DEF +6, MDEF +3 | rare | Arcanist, Warden | 480 | Valemere arms | Yes — Valemere stall |
| III | Valemere Helm | helm | DEF +5 | rare | any | 440 | Valemere arms; forge | Yes — Valemere stall |
| III | Valemere Steel | material | — | common | — | 40 | Cutpurses, Debt Collectors; Valemere | Drops yes / shop data only |
| III | Debtman's Chain | accessory | DEF +3, MDEF +3 | legendary | any | — | The Debtman, once | Yes (boss drop) |
| IV | Oathbreaker | weapon (heavy) | ATK +11 | rare | Taren | 900 | Barrow gate smith; forge | Yes — barrow smith (legacy) |
| IV | Barrow Plate | armor | DEF +9 | rare | Vanguard, Rebel Captain | 880 | Barrow gate smith | Yes — barrow smith (legacy) |
| IV | Barrow Helm | helm | DEF +7 | rare | any | 760 | Barrow gate smith; forge | Yes — barrow smith (legacy) |
| IV | Barrow Iron | material | — | common | — | 60 | Ward Sentinels, Glyph Wisps | Drops yes / shop data only |
| IV | Sanctuary Oathblade | weapon (holy) | ATK +10 | legendary | Sera | — | Sanctuary Warden, once | Yes (boss drop) |
| V | Tidesteel Blade | weapon (longsword) | ATK +12 | rare | Kael | 1400 | Mott's cart, Blackwood road; forge | Yes — Mott's cart |
| V | Drowned Coat | armor | DEF +11, MDEF +4 | rare | any | 1300 | Mott's cart, Blackwood road | Yes — Mott's cart |
| V | Saltreach Charm | accessory | DEF +2, MDEF +5, SPD +1 | rare | any | 1200 | Mott's cart, Blackwood road; forge | Yes — Mott's cart |
| V | Tideglass | material | — | common | — | 90 | Mott's cart, Blackwood road | Yes — Mott's cart (still no drowned enemies) |
| V | The Drowned Crown | helm | DEF +8, MDEF +6 | legendary | any | — | Saltreach Leviathan (Ch 13) | **Yes (boss drop)** |
| VI | Ironspine Maul | weapon (heavy) | ATK +15 | rare | Taren | 2000 | Mott's cart, Blackwood road; forge | Yes — Mott's cart |
| VI | Mine Plate | armor | DEF +13 | rare | any | 1900 | Mott's cart, Blackwood road | Yes — Mott's cart |
| VI | Architect Ring | accessory | DEF +2, MDEF +6 | rare | any | 1700 | Mott's cart, Blackwood road; forge | Yes — Mott's cart |
| VI | Architect Alloy | material | — | common | — | 120 | Aethari Automatons; Mott's cart | Drops yes; Mott's cart |
| VI | Matriarch's Heartwood | accessory | DEF +5, MDEF +8 | legendary | any | — | Blackwood Matriarch, once | Yes (boss drop) |
| VII | Ashlands Edge | weapon (longsword) | ATK +16 | rare | Kael | 2600 | Barrow gate smith; Ashlands outpost; forge | Yes — barrow smith |
| VII | Emberweave Robe | armor | DEF +10, MDEF +10 | rare | Arcanist, Warden | 2400 | Barrow gate smith; Ashlands outpost | Yes — barrow smith |
| VII | Ash Crown | helm | DEF +8, MDEF +5 | rare | any | 2200 | Barrow gate smith; Ashlands outpost; forge | Yes — barrow smith |
| VII | Ember Core | material | — | common | — | 160 | Late Emberwakes | Drops yes / shop data only |
| VII | Barrow King's Blade | weapon (holy) | ATK +16 | legendary | Sera | — | The Barrow Warden, once | Yes (boss drop) |
| VIII | True-Name Blade | weapon (longsword) | ATK +19 | rare | Kael | 3200 | Rimehold armoury; forge | Yes — Rimehold |
| VIII | Rime Sword | weapon (holy) | ATK +16 | rare | Sera | 3000 | Rimehold armoury | Yes — Rimehold |
| VIII | Veil Plate | armor | DEF +16 | rare | any | 3100 | Rimehold armoury | Yes — Rimehold |
| VIII | Veil Ring | accessory | DEF +5, MDEF +9, SPD +2 | rare | any | 2900 | Rimehold armoury; forge | Yes — Rimehold |
| VIII | Veil Shard | material | — | common | — | 220 | Grave Moths, Oath Iron | Drops yes; Rimehold shop |
| VIII | The Forgotten King's Crown | helm | DEF +10, MDEF +9 | legendary | any | — | The Forgotten King, once | Yes (boss drop) |

"Data only" means the item, its price and its source are defined and checked, but the Act's room,
merchant or boss does not exist yet, so nothing can currently hand it to the player. Five shops are
exceptions and are wired (see below): Valemere Arms, the Barrow Gate Smith, Mott's cart on the
Blackwood road, Sarn's outpost wagon at the Crownveil breach and Rimehold's armoury.

## Legendary sources (wired today)

| Item | Boss | Chapter | Behaviour |
|---|---|---|---|
| Blackguard's Longsword | Blackguard | 1 | guaranteed, once per save; canonical id `item_blackguards_longsword` (the singular id is an old-save alias) |
| Calder's Greatsword | Reeve Calder | 2 | guaranteed, once per save |
| Debtman's Chain | The Debtman | 3 | guaranteed, once per save |
| Sanctuary Oathblade | Sanctuary Warden | 4 | guaranteed, once per save |
| Matriarch's Heartwood | Blackwood Matriarch | 7 | guaranteed, once per save |
| Barrow King's Blade | Barrow Warden | 10 | guaranteed, once per save |
| Forgotten King's Crown | The Forgotten King | 11 | guaranteed, once per save |
| The Drowned Crown | Saltreach Leviathan | 13 | guaranteed, once per save |

The First Forge still has no boss in `scr_enemy_database.gml` (Act VI is not built), so it exists as
data and is reported as incomplete.

## Crafting (forge counter, Pell in Greyhaven)

Recipes unlock by act and are never legendary. Cost is materials + gold.

| Act | Result | Materials | Gold |
|---|---|---|---|
| II | Millhaven Sabre | 2 Ash Shard, 2 Iron Scale | 100 |
| II | Warden's Sigil | 3 Iron Scale | 120 |
| III | Valemere Helm | 4 Valemere Steel | 200 |
| III | Ledger Dirk | 4 Valemere Steel, 4 Iron Scale | 350 |
| IV | Barrow Helm | 5 Barrow Iron | 300 |
| IV | Oathbreaker | 6 Barrow Iron, 4 Valemere Steel | 450 |
| V | Saltreach Charm | 6 Tideglass | 400 |
| V | Tidesteel Blade | 8 Tideglass, 5 Barrow Iron | 600 |
| VI | Architect Ring | 7 Architect Alloy | 500 |
| VI | Ironspine Maul | 9 Architect Alloy, 6 Tideglass | 700 |
| VII | Ash Crown | 8 Ember Core | 600 |
| VII | Ashlands Edge | 10 Ember Core, 6 Architect Alloy | 800 |
| VIII | Veil Ring | 9 Veil Shard | 700 |
| VIII | True-Name Blade | 11 Veil Shard, 6 Ember Core | 900 |

`scr_forge_open("shop_greyhaven_forge")` is the counter: browse wares, or forge this act's patterns.
Pell's post-pendant dialogue now opens it instead of the shop directly.

## Material drops (wired)

| Material | Enemies | Chance |
|---|---|---|
| Ash Shard | Bandit 30%, Ash Wolf 20%, Ashen Wretch 25%, Fallen Knight 35%, Grey Ash Wolf 20% | per enemy |
| Iron Scale | Crown Patrolman 30%, Occupation Soldier 30%, Bandit Veteran 25% | per enemy |
| Valemere Steel | Cutpurse 30%, Debt Collector 30% | per enemy |
| Barrow Iron | Ward Sentinel 30%, Glyph Wisp 25% | per enemy |
| Architect Alloy | Aethari Automaton 35% | per enemy |
| Ember Core | Emberwake (late) 30% | per enemy |
| Veil Shard | Grave Moth 25%, Oath Iron 30% | per enemy |
| Tideglass | Bought from Mott's cart, `rm_blackwood_deep` (no drowned enemies yet) | — |

## Treasure chests (wired)

| Chest | Where | Loot |
|---|---|---|
| `hidden_grove_chest` | Overworld, hidden grove NW of the bandit camp | Ash Pendant, Ash Shard x2 |
| `watchtower_chest_1` | Old Watchtower | Hunter's Knife |
| `watchtower_chest_2` | Old Watchtower | Iron Helm |
| `watchtower_chest_3` | Old Watchtower | 50 Gold, Ash Shard x2 |
| `bandit_camp_chest_1/2` | Bandit camp | potions, 50 Gold, Iron Sword (already existed) |

Chapters 2–5 have no treasure markers at all yet, so later-act chest loot is still missing.

## Balance check

`python3 tools/equipment_check.py` parses the real data and prints best-in-slot parties at each
boss's own level (four active slots, gear legal for the act) against the actual boss stats:

| Boss | Lv | HP | Rounds to kill | Rounds to wipe | Verdict |
|---|---|---|---|---|---|
| Emberwake | 4 | 70 | 2 | 76 | TRIVIAL (optional early boss) |
| Blackguard | 6 | 450 | 11 | 27 | ok |
| Reeve Calder | 10 | 130 | 3 | 80 | TRIVIAL |
| The Debtman | 12 | 256 | 4 | 40 | TRIVIAL |
| Sanctuary Warden | 16 | 514 | 6 | 32 | ok |
| Commander Hailen | 18 | 600 | 6 | 20 | ok |
| Burn-Line Hulk | 18 | 600 | 6 | 22 | ok |
| The Door Warden | 19 | 643 | 6 | 34 | ok |
| Blackwood Matriarch | 20 | 686 | 6 | 36 | ok |
| Magistrate Vell | 21 | 730 | 6 | 35 | ok |
| Barrow Warden | 22 | 773 | 6 | 28 | ok |
| The Forgotten King | 23 | 816 | 6 | 28 | ok |

The final boss still takes six rounds with fully geared level-23 parties, so the Act VIII tier does
not trivialise it, and the party is never safe from a wipe. The three flagged fights are the early
ones and one mid-game boss: Emberwake is an optional level-4 boss; Calder is scripted for two members
at level 9–10; the Debtman's scaled row is built for three members and he yields rather than dies.
The checker assumes four fully geared active members, so those low round counts overstate how easy
the fights are in play.

## Implementation status

**Implemented this pass**

* Item schema: rarity, act, class restrictions, MDEF/SPD bonuses, `unique`, acquisition text.
* 69 new items (61 gear pieces + 8 materials), no duplicate ids; every equipment entry has a
  description, category, rarity, stats and acquisition text.
* **A weapon for every class in every act** (30 new weapon tiers): longsword, dagger, spellbook,
  holy sword and heavy sword for Acts I–VIII, enforced by the checker so a class can never be left
  on an older tier. Acts I–II are on shelves that exist; III–VIII are in the tier shops.
* Class restrictions on armour/helm/accessory (Salt-Lampskin and Emberweave: Arcanist/Warden;
  Barrow Plate: Vanguard/Rebel Captain) plus the existing weapon categories.
* MDEF/SPD now applied by equipment and shown in the equip preview (`DEF/MDEF/SPD a > b`).
* Act-gated merchant stock (`scr_shop_stock`, `scr_story_act`) and seven new tier shops defined:
the six regional shops plus the Blackwood carter's cart (`shop_blackwood_carter`).
* Forge crafting: 14 recipes, act-gated, dialogue counter wired to Pell.
* Enemy drops: `qty` and `once` support; tiered material drops on 16 enemy types; one guaranteed,
  one-per-save legendary on each of the seven built bosses.
* Unique items: one per party, unsellable, never duplicated by chests or repeated bosses.
* Chest loot can name any DB item; four placeholder chests now hold tier-appropriate rewards.
* **Five tier merchants wired**: Valemere Arms through the existing stallkeeper's dialogue; Orrin
  the Barrow Gate Smith on a marker in `rm_barrow_gate` (`tools/gen_ch10_rooms.py` regenerates it);
  Sarn the Ashlands outpost trader on a marker in `rm_ashlands_breach` (`tools/gen_ashlands_room.py`
  regenerates the room and marker); Mott the Blackwood carter on a new marker in
  `rm_blackwood_deep` (`tools/gen_ch6_rooms.py` regenerates it; his lines come from
  `tools/gen_ch6_dialogue.py`); and the Rimehold armourer in `rm_rimehold`
  (`tools/gen_rimehold_room.py` regenerates it). The checker now reports **100 gear items sold by a
  wired merchant** and **0 items defined only for unbuilt Act III–VIII shops**; Saltreach and
  Ironspine remain data-only shops, with their stock riding on Mott.
* `tools/equipment_check.py` (data integrity, progression, reachability, boss balance) and this doc.

**Already existed (reused, not replaced)**

* 28 items, including all five starting weapons and the Blackguard's Longsword.
* Shop menu, pricing, sell flow, the Chapter 9 discount, inn rest.
* `drops` arrays with `chance`; inventory, equip slots, equip preview, save/load v3 (items and
  equipment are stored by id, so no schema change was needed).

**Incomplete / not done**

* The rest of Acts III–VIII is unbuilt: Saltreach and Ironspine have stock data but no room of their
  own, and the Ashlands has three rooms but no act. Mott's cart covers the V and VI gear and Sarn's
  wagon covers VII, so those tiers are reachable; Rimehold's armoury is built ahead of Act VIII, so
  tier VIII is reachable after Chapter 11. Their regions, their enemies and The First Forge boss do
  not exist (the Drowned Coast has enemy data but no rooms).
* Chapters 2–5 have no treasure markers, so their chest loot is unwired.
* No gear icons; menus fall back to the generic row. No rarity colouring in the shop.
* The weapon tiers are bought, not looted: none of the 30 new weapons is in a chest or a boss drop,
  so a player who skips the shops (or reaches an act whose merchant does not exist yet) sees no
  upgrade. Crafting has one recipe per act and covers no dagger or spellbook.
* Nothing here has been compiled or played: all checks are static (validator, audit, checker).

## Balance retune with the new tiers (2026-11-18)

`scr_story_act()` is a **tier** gate, not a story-act count. The mapping that matters is:

| Story act | Chapters | Levels | Tier unlocked at the act start |
|---|---|---|---|
| I | 1 | 1–7 | I |
| II | 2–5 | 8–18 | II at Ch2, III at Ch3, IV at Ch4, V at Ch5 |
| III | 6–8 | 18–20 | VI |
| IV | 9–11 | 21–23 | VII |
| V | 12–14 | 24–26 | VIII (Rimehold armoury; entrance after Chapter 11) |

Acts VI–VIII have titles and gear rows but **no enemies, rooms, encounter tables or bosses**. There is
no authored band to simulate; none was invented. Act V's tier-VIII shop is now built in
`rm_rimehold`, gated on `flag_act4_complete`; the Act V retune below therefore uses tier VIII, the
set the story unlocks.


`tools/balance_sim.py` now carries the best non-legendary set for each class at each tier, including
armour MDEF / SPD / HP, and prints an eight-act `--summary`. The retune raised the boss entries that
had been measured against the old Chapter 5 or tier-V loadout:

| Boss | Lv | Tier | Old HP / ATK | New HP / ATK | Simulated win / rounds / party HP (Caelan / Sera) |
|---|---|---|---|---|---|
| Reeve Calder | 10 | II | 130 / 15 | 156 / 18 | 100% / 6.0 / 76% (solo party) |
| The Debtman | 12 | III | 256 / 25 | 410 / 35 | 100% / 5.6 / 48% (trio) |
| Sanctuary Warden | 15 | IV | 643 / 39 | 900 / 55 | 96% / 6.2 / 28% — 93% / 7.3 / 30% |
| Commander Hailen | 17 | V | 900 / 57 | 1620 / 74 | 80% / 8.4 / 20% — 82% / 9.7 / 31% |
| Burn-Line Hulk | 18 | VI | 1260 / 55 | 1890 / 74 | 99% / 7.6 / 42% — 99% / 9.6 / 44% |
| Blackwood Matriarch | 19 | VI | 1029 / 49 | 1544 / 64 | 93% / 7.2 / 27% — 91% / 7.9 / 28% |
| The Door Warden | 20 | VI | 1286 / 46 | 2315 / 74 | 96% / 8.3 / 25% — 95% / 10.5 / 33% |
| Magistrate Vell | 21 | VII | 1022 / 52 | 1840 / 73 | 100% / 7.5 / 37% — 100% / 9.0 / 49% |
| Barrow Warden | 22 | VII | 1701 / 59 | 2381 / 71 | 99% / 7.4 / 43% — 96% / 9.7 / 40% |
| The Forgotten King | 23 | VII | 1714 / 61 | 2228 / 70 | 98% / 8.0 / 36% — 98% / 9.3 / 39% |
| The Toll-Keeper | 24 | VIII | 1804 / 64 | 2165 / 77 | 100% / 7.3 / 44% — 99% / 8.5 / 45% |
| Saltreach Leviathan | 25 | VIII | 1895 / 67 | 2150 / 72 | 91% / 7.2 / 22% — 77% / 8.3 / 19% |
| The Fallen Knight | 26 | VIII | 2052 / 70 | 2772 / 80 | 98% / 8.4 / 37% — 97% / 9.7 / 41% |

Act V's tier-VIII shelf is in `rm_rimehold`; the entrance opens after Chapter 11. Rates are
stochastic: a fixed-seed rerun moves about ±1–2 points, so the GML comments may show a neighbouring
run by a point.

`blackwood`, `crown_barrow` and `drowned_coast` now field three regular enemies per group instead
of two, because the new tiers made the old two-enemy draws two-to-three-round fights at 91–98% party
HP. Weights are unchanged; group shape is the only encounter-table change.

`python3 validate_gamemaker.py` passes with the four known Act I out-of-band warnings;
`python3 tools/equipment_check.py` passes with five **static** flags (two TRIVIAL and three
party-wipes-first rows; its table now parses scaled-boss HP but deliberately ignores skills, buffs
and healing); `python3 tools/balance_sim.py --summary` produced the table above. Simulation only: no GameMaker compile, playtest or visual check
was possible here.
