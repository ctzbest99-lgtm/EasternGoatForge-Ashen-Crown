# Development Roadmap

1. **Project shell:** create the real GameMaker project in the IDE; choose version, room size, tile size, and input scheme; compile an empty room.
2. **Exploration:** top-down movement, collision, placeholder sprites, one interactable, dialogue input lock.
3. **Battle prototype:** one trigger, Attack/Guard, explicit battle states, one enemy, victory/defeat, safe overworld return.
4. **Party/progression:** four-person actor data, party order, status, XP, levels, currency, equipment, inventory.
5. **Menus/saves:** versioned save schema; equipment, party order, items, save/load, status, Bestiary.
6. **Zone 1 slice:** finalize rare encounter and boss, integrate approved art/audio/UI, playtest difficulty.
7. **Polish:** readability, controller support, performance, save migration, regression tests.

## Status (2026-11-15)

| Step | State |
|---|---|
| 1. Project shell | **Done** — `gamemaker/AshenCrown.yyp` opens and runs; the exact GameMaker version is still nominally open. |
| 2. Exploration | **Done** — movement, collision, interaction, dialogue lock, 18 rooms covering Chapters 1–3. |
| 3. Battle prototype | **Done, well past prototype** — skills, statuses, weakness, boss phases, Escape, defeat and respawn. |
| 4. Party / progression | **Done** — five-person roster, four active plus reserve, XP / levels, equipment, inventory, gold, shops. |
| 5. Menus / saves | **Done** — Adventure menu (Items, Equip, Party Order, Status, Bestiary), shops, versioned saves (schema v3) at save crystals inside a town's church or tavern. |
| 6. Zone 1 slice | **Playable, not playtested** — Chapter 1 content, art and balance are in, but there is no audio and the numbers are still provisional. |
| 7. Polish | **Partly started** — the quest journal UI is in (Adventure menu → Quests). Audio, controller support, real Lyra art and the whole `docs/TEST_PLAN.md` pass are still outstanding. |

Beyond the slice: Chapter 4 is built (rooms, markers, dialogue, story flow and Caelan's kit, unplaytested); Chapter 5 has enemy stats, encounter tables and boss groups but no rooms, markers or dialogue; Act III onward is design only. The 12 remaining `status: "stub"` overworld entrances point at rooms that do not exist.