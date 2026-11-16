# ASHEN CROWN — Game Design Document

A dark medieval fantasy RPG about Kael Varyn, a man marked by tragedy, travelling through a fractured realm. The atmosphere is serious and moody, with occasional lighthearted character moments.

## Pillars
- Classic top-down JRPG exploration in the style of the original Final Fantasy (1987), not side-view.
- Menu-driven turn-based battles; five-person roster with four active slots and one reserve.
- Preparation matters: levels, equipment, party order, and tactics matter. No automatic enemy scaling.
- Pixel art, evocative locations, strong silhouettes, readable UI. Every asset is original to Eastern Goat Forge.
- The mystery of the Crownveil and the Ash is preserved: revelations are paced across the acts.

## Core loop
Explore → interact → encounter → choose commands → resolve turns → earn rewards → recover/upgrade → unlock a route.

## Implemented systems

These are built in this repository; see `docs/DECISIONS_AND_OPEN_QUESTIONS.md` for the per-feature detail and every placeholder value.

| System | State |
|---|---|
| Top-down movement, collision, interaction, dialogue with portraits and per-line expressions, dialogue input lock | Built |
| Random walking encounters with per-area tables, plus fixed `obj_encounter_trigger` fights and story encounters | Built; rates PLACEHOLDER |
| Turn-based battle: Attack, Skill, Guard, Swap, Item, Escape; SPD turn order; criticals; weaknesses; bleed, poison, blind, sleep; two- and three-phase bosses; steal, ally-heal, party buff, yield branches | Built |
| Five-person roster, 4 active + 1 reserve, Party Order, XP with participation rule, tiered level growth, level cap 20 | Built |
| Equipment (weapon / armor / accessory), inventory and key items, gold, shops with buy/sell and equipment preview | Built; prices PLACEHOLDER |
| Save schema v3 at save crystals inside a town's church or tavern; title-screen Continue; v1/v2 migration | Built |
| Defeat → wake in town with HP restored, gold and XP-progress penalty | Built; percentages PLACEHOLDER |
| Adventure menu: Items, Equip, Party Order, Status, Bestiary (with monster illustrations), Quests, Close | Built |
| Quest journal, story flags, chapter-complete screens | Built |
| Audio: 3 music loops, 20 SFX, 6 ambience beds wired through `scr_audio` | Built; never heard in engine |
| Title screen, main menu, save/slot panel, nine-slice UI kit, bitmap font, damage digits, status icons, battle backgrounds | Built |

Still absent: controller support, an options screen (the audio gains exist without UI), a battle-only item tier, and any in-engine playtest.

Ordered next tasks with acceptance criteria live in [AI Agent Development Backlog](AI_AGENT_DEVELOPMENT_BACKLOG.md).

## Content state

- **Chapter 1 — The Night of Ash** (Zone 1, Greyhaven → Old Watchtower → Blackguard → Crownveil Door): built.
- **Act II — The Broken Crown**, four chapters, all scripted, approved and built:
  - **Chapter 2 — The Weight of the Yoke** (Wrenfield, Taren, Reeve Calder), levels 8–10.
  - **Chapter 3 — Crowns and Alleys** (Valemere, Lyra, the Debtman), levels 10–13.
  - **Chapter 4 — The Old Name** (Hollow Sanctuary, Caelan, the Sanctuary Warden), levels 13–16.
  - **Chapter 5 — The Deserted Oath** (Blackwood Road Garrison, Sera, Commander Hailen), levels 16–18.
- **Act III — The Blackwood** — [PROPOSED] outline written (`docs/story/ACT3_OUTLINE.md`): three chapters, levels 18–20, ten decisions awaiting the owner. No code, rooms or dialogue exist for it.
- **Act IV onward** — design only. Thirteen room references (`rm_blackwood_deep`, `rm_ashlands_*`, `rm_ironspine_*`, `rm_frozen_ruins`, `rm_flooded_ruins`, `rm_saltreach*`, `rm_rimehold`, `rm_town`, `rm_shipwreck`) point at rooms that do not exist yet; `validate_gamemaker.py` lists them as the only unresolved refs.

## Vertical slice

The original slice — one map, one interaction, one fight, reliable return to exploration — is long past: Chapter 1 is a complete zone with a dungeon, a three-phase boss, rewards, shops, saves and a chapter ending. It is **not playtested**: `gamemaker/AshenCrown.yyp` has never been compiled in an IDE, and the whole `docs/TEST_PLAN.md` pass is unchecked.

See `docs/DEVELOPMENT_ROADMAP.md` for the build state and `CHANGELOG.md` for the feature history.
