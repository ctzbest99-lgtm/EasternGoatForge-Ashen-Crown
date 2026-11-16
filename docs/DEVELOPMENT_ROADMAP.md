# Development Roadmap

For ordered tasks with acceptance criteria, see [AI Agent Development Backlog](AI_AGENT_DEVELOPMENT_BACKLOG.md); this file tracks phase state and content.

1. **Project shell:** real GameMaker project, version, room size, tile size, input scheme, an empty room that compiles.
2. **Exploration:** top-down movement, collision, interactables, dialogue input lock.
3. **Battle prototype:** triggers, Attack/Guard, explicit battle states, one enemy, victory/defeat, safe overworld return.
4. **Party / progression:** roster, party order, status, XP, levels, currency, equipment, inventory.
5. **Menus / saves:** versioned save schema; equipment, party order, items, save/load, status, Bestiary.
6. **Zone 1 slice:** final encounters and boss, approved art/audio/UI, playtest difficulty.
7. **Polish:** readability, controller support, performance, save migration, regression tests.

## Status (2026-11-16)

| Step | State |
|---|---|
| 1. Project shell | **Done** — `gamemaker/AshenCrown.yyp` is generated from `game/` with 22 rooms, 63 scripts, 22 objects, 843 sprite resources and 29 sounds. The exact GameMaker version is still nominally open, and **nothing has been compiled in an IDE**. |
| 2. Exploration | **Done** — movement, collision, interaction with sprite-driven markers, dialogue lock, portraits with per-line expressions, night overlay, 320×180 camera. |
| 3. Battle prototype | **Done, well past prototype** — skills, six statuses (bleed, poison, blind, sleep, slow, buffs), weaknesses, Guard, Swap, in-battle Item, Escape, two- and three-phase bosses, steal, ally-heal, party buffs, yield branches, defeat and respawn. |
| 4. Party / progression | **Done** — five-person roster with four active plus one reserve, Party Order, per-member XP and levels (cap 20, tiered growth), equipment, inventory, gold, shops. |
| 5. Menus / saves | **Done** — Adventure menu (Items, Equip, Party Order, Status, Bestiary, Quests), shops, versioned saves (schema v3) at save crystals inside a town's church or tavern, title-screen Continue with slot details. |
| 6. Zone 1 slice | **Playable on paper, not playtested** — Chapter 1 content, art, audio and balance numbers are in; the numbers are provisional and the whole `docs/TEST_PLAN.md` pass is unchecked. |
| 7. Polish | **Partly started** — quest journal, bestiary illustrations, audio wiring and a full art pass are in. Controller support, an options screen for the existing audio gains, and performance/save-migration work are outstanding. |

## Content

- **Chapter 1 — The Night of Ash:** built (Greyhaven, farmlands, Old Road, Bandit Camp, Old Watchtower, Basement, Blackguard, Crownveil Door).
- **Act II — The Broken Crown:** complete. All four chapter scripts are approved and built — Chapter 2 *The Weight of the Yoke* (Wrenfield, Taren, Reeve Calder, levels 8–10), Chapter 3 *Crowns and Alleys* (Valemere, Lyra, the Debtman, 10–13), Chapter 4 *The Old Name* (Hollow Sanctuary, Caelan, the Sanctuary Warden, 13–16), Chapter 5 *The Deserted Oath* (Blackwood Road Garrison, Sera, Commander Hailen, 16–18). Chapter 5 ends at the Blackwood treeline.
- **Act III — The Blackwood:** complete and built, unplayed. All three chapters exist — Chapter 6 *The Green Silence* (approved), Chapter 7 *The Share* and Chapter 8 *The Door in the Wood* (built from the outline's recommended decisions, awaiting individual approval). Five Blackwood rooms: deep, hollow, shrine, glade, doors, plus the eastern side path Chapter 9 added. Eleven unresolved room references remain — `rm_ashlands_breach`, `rm_ashlands_ruins`, `rm_ironspine_mine`, `rm_ironspine_ruins`, `rm_frozen_ruins`, `rm_flooded_ruins`, `rm_saltreach`, `rm_saltreach_pier`, `rm_shipwreck`, `rm_rimehold` and the Act V–VIII rooms — none of them Act IV's any more, and none may be "fixed" by inventing rooms.

## Next work, in order

1. **Playtest.** Open the project in GameMaker and follow **`docs/PLAYTEST_RUNBOOK.md`**, which orders the work by what fails first (IDE version, resource load, compile, then content) and gates each phase; tick `docs/TEST_PLAN.md` as you go. Nothing else can be called done before this.
2. **Fix what the playtest finds**, starting with the Chapter 5 blockouts (`rm_blackwood_garrison`, `rm_garrison_keep` are tiles-only rooms) and the Chapter 3 blockouts (`rm_valemere`, `rm_salt_lamp`, `rm_warehouse` still use Wrenfield tiles).
3. **Options screen** — the title screen's Options entry now adjusts Music / Ambience / SFX and Mute and saves them to `ashen_settings.ini` (unverified in engine). Still missing: an in-game entry from the Adventure menu, and controller support.
4. **Act IV — The Forgotten King**: **complete and built, unplayed** — all three chapters, four rooms (`rm_town`, `rm_barrow_gate`, `rm_barrow_halls`, `rm_barrow_deep`), 235 dialogue nodes, two quests and their wiring, verified by the validator. The act closes on the seal choice with `flag_act4_complete`. Still blocking polish: **Alden, Vell and Nessa have no sprites**, every Act IV room is a Wrenfield blockout, Alden has no battle slot, the King's third phase is narrative, `ch9_shop_discount` is a flag the shop does not read, and the charter's name for the mark (**the Crownveil**) needs the owner's sign-off.
5. **Art debt:** 18 enemy kinds still lack 16×24 overworld sets (listed in `docs/ASSET_INVENTORY.md`), Alden has no sprite, and Nim and Derry have no portrait.
