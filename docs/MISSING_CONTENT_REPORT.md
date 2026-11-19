# ASHEN CROWN — Missing Content Report

**Audit date:** 2026-11-19
**Baseline:** `b4afeb7f` (PR #40 tip)
**Rule:** this report records what is absent. It does not invent story, names, art or
gameplay to fill a gap. Items marked **PROPOSED** or **DESIGN** need an owner decision
before implementation.

---

## 1. Campaign structure

The story bible defines eight acts plus a separate finale, **The Ashen Crown**. The
repository's eight-act tracker preserves that distinction. The assignment's “exactly
eight acts” is compatible with this structure only if the finale is treated as the
final act or as a separate epilogue; that is an owner decision, not something this audit
changes.

| Act | Title | Chapters | Built? | Playable? | Missing |
|---|---|---:|---|---|---|
| I | The Night of Ash | 1 | Yes | Not verified | Chapter 1 main quest journal/wiring; some quest/character closure |
| II | The Broken Crown | 2–5 | Yes | Not verified | No chapter blockers found; runtime verification |
| III | The Blackwood | 6–8 | Yes | Not verified | Chapters 7–8 are built but individually unapproved; runtime verification |
| IV | The Forgotten King | 9–11 | Yes | Not verified | Chapters 9–11 are built but unapproved; Act V transition |
| V | The Fallen Knight | 12–14 | **No** | No | Every room, dialogue node, quest row, story trigger and transition |
| VI | Beneath the Mountains | — | **No** | No | Outline, chapters, rooms, enemies, boss, transition |
| VII | The Ashlands | — | Partial blockout only | No | Story, chapters, quests, enemies, boss, tileset, transition |
| VIII | The Truth | — | Armoury only | No | Story, chapters, quests, enemies, boss, tileset, transition |
| Finale | The Ashen Crown | — | **No** | No | Outline, final dungeon, Alden's three-phase finale, ending |

“Built” means source/data exists. **No chapter has been compiled or played in
GameMaker.** Do not read “Built: Yes” as “Playable: Yes”.

---

## 2. Act-by-act gaps

### Act I — The Night of Ash (Chapter 1)

Implemented: Greyhaven's five interiors and overworld, the Farmlands/Old Road/Bandit
Camp/Watchtower route, the Blackguard, the Fallen Knight story beat, and 114 dialogue
nodes.

Missing or incomplete:

- **`Q_MAIN_FIND_MIRA` is now implemented in source by PR #44, but not runtime-tested.**
  The approved S1–S9 definition is in `scr_quest_definitions()`, and the existing
  `GH_ARRIVAL`, `GH_TOMAS`, Varyn House pendant, `BG_INTRO` and `CV_END` callbacks drive
  it. `scr_ch1_quest_tick()` backfills older saves. The journal has not been opened in
  GameMaker; runtime status remains **NOT RUN**.
- The marker fields that look like quest authority (`quest_start`, `quest_advance`) are
  still unread. Chapter 1 deliberately uses the same story-function pattern as Chapters
  2–11; remove or document the dead marker fields separately.
- The existing eight-act tracker lists unresolved story closure around Elira, Tomas,
  the parchment/Crownveil Fragment payoff and the Blackguard's identity. Those are story
  decisions, not code repairs; they are not invented here.

### Act II — The Broken Crown (Chapters 2–5)

Implemented: Millhaven Road, Wrenfield, the Bent Post, Len's store, Valemere, the Salt
Lamp, the warehouse, Hollow Approach/Sanctuary, the Blackwood Road Garrison and the
Garrison Keep; Reeve Calder, the Debtman, the Sanctuary Warden and Commander Hailen;
`Q_MAIN_BEYOND_VEIL` and the side quests are written by chapter story code.

Missing: runtime verification. No missing room or quest definition was found for the
built route.

### Act III — The Blackwood (Chapters 6–8)

Implemented: Blackwood Deep, Hollow, Shrine, Glade and Doors; the Burn-Line Hulk, the
Blackwood Matriarch and the Door Warden; 139 dialogue nodes.

Missing:

- Chapters 7 and 8 are recorded as **built but individually unapproved**. Approval is a
  story decision.
- The Blackwood tileset is still a placeholder atlas.
- Runtime verification.

### Act IV — The Forgotten King (Chapters 9–11)

Implemented: Coleford (`rm_town`), Barrow Gate, Barrow Halls, Barrow Deep; Magistrate
Vell, the Barrow Warden and the Forgotten King; 235 dialogue nodes.

Missing:

- Chapters 9–11 are recorded as **built but unapproved**.
- The Act IV → Act V transition: Chapter 11 has no built destination. Act V's first
  room, `rm_saltreach`, does not exist.
- Runtime verification.

### Act V — The Fallen Knight (Chapters 12–14)

Approved as story but **0% implemented in rooms/dialogue**.

Missing:

- All three chapters' dialogue: 638 approved nodes (198 + 256 + 184), zero implemented.
- `rm_saltreach`, `rm_saltreach_pier`, `rm_flooded_ruins`, `rm_shipwreck`.
- Quest rows `Q_MF` (main) and `Q_ST` (side) and their stage flags.
- Story triggers, transitions, minimap markers and ambience hooks.
- The three boss encounters exist only as data/groups: Toll-Keeper, Saltreach
  Leviathan and the returning Fallen Knight (`fallen_knight_last`).
- Enemy data exists for `drowned_husk`, `salt_wretch`, `tide_crawler`, `wreck_shade`,
  `toll_keeper`, `salt_leviathan` and `fallen_knight_last`, but none is in the Bestiary
  because the rooms that would make them reachable are absent.
- Seven Act V/coast items and recipes are data-ready but unobtainable until the rooms
  and merchants exist.

### Act VI — Beneath the Mountains

**Title only.** Missing outline, chapter scripts, dialogue, quests, Ironspine rooms,
enemies, boss, tileset, transition and Bestiary entries. `rm_ironspine_mine` and
`rm_ironspine_ruins` are referenced by map markers and do not exist.

### Act VII — The Ashlands

**Blockout only.** `rm_ashlands_breach`, `rm_ashlands_ruins` and `rm_ashlands_depths`
exist as standalone rooms with no chapter, quest, story trigger, boss or ending. Missing
outline, chapters, dialogue, enemies, Ash King, Ashlands tileset and transition.

### Act VIII — The Truth

**Armoury only.** `rm_rimehold` exists so the tier-VIII equipment shelf is reachable, but
there is no chapter, story, quest, boss, Frostwilds tileset or transition.
`rm_frozen_ruins` is referenced and does not exist.

### Finale — The Ashen Crown

**Title only.** Missing outline, final dungeon, Alden's three-phase final battle and the
ending implementation. The established canon must be preserved:

- Alden Marr genuinely begins wanting to free the serfs.
- His ambition grows until he takes the capital after King Aldric IV's defeat and claims
  the throne.
- Kael and Taren stop him.
- The final boss is Alden in three phases.
- Ending C — The Last Usurper is the established ending.

No audit change touches this.

---

## 3. Missing and incomplete environments

### Deliberate missing room targets (7)

These appear in marker/exit data but have no room resource:

| Room | Region / act | Intended content |
|---|---|---|
| `rm_saltreach` | Drowned Coast, Act V | Coastal village |
| `rm_saltreach_pier` | Drowned Coast, Act V | Harbour/boat hook |
| `rm_flooded_ruins` | Drowned Coast, Act V | Flooded ruins |
| `rm_shipwreck` | Drowned Coast, Act V | Shipwreck |
| `rm_ironspine_mine` | Ironspine, Act VI | Abandoned mine |
| `rm_ironspine_ruins` | Ironspine, Act VI | Architect structures |
| `rm_frozen_ruins` | Frostwilds, Act VIII | Frozen ruins |

These are **not broken exits**: the marker data labels them `status: "stub"` or leaves
them as future destinations. `validate_gamemaker.py` reports them as unresolved refs so
they cannot be silently forgotten. Do not “fix” the validator by deleting the refs;
build the rooms or remove the unreachable marker when the act is cut.

### Built standalone rooms without a chapter

- `rm_ashlands_breach`, `rm_ashlands_ruins`, `rm_ashlands_depths` (Act VII blockout).
- `rm_rimehold` (Act VIII armoury).

### Map/tileset gaps

- **Blackwood atlas is a placeholder.** `ts_blackwood` exists and is used, but the
  inventory records it as placeholder art.
- **No Ashlands tileset.** The three Ashlands rooms currently borrow an atlas.
- **No Drowned Coast / Ironspine / Frostwilds tileset.** Those regions have no built
  rooms yet.
- All room `.yy` tile layers are empty `ts_zone1` layers; the builders switch the layer's
  tileset at runtime (`ts_wrenfield`, `ts_valemere`, `ts_coleford`, `ts_garrison`,
  `ts_barrow`, `ts_blackwood`). This is deliberate, but it means the IDE room view is not
  the final visual.

---

## 4. Missing and borrowed artwork

### What is present

- 1,087 sprite resources.
- All five party members: overworld 16×24, battle strips, portraits.
- Alden, Nim and Derry: overworld sets and three portraits each. **The assignment's
  “Alden has no completed sprite” and “Nim and Derry lack portraits” are stale.**
- Every enemy kind with battle art has a 16×24 overworld set. **The assignment's “18
  enemy types lack overworld sets” is stale.**
- All 43 Bestiary entries resolve to battle idle art.
- 21 portrait sets; 36 NPC overworld kinds.
- Seven tilesets and 29 sound resources.

### What is still missing or borrowed

| Item | Status | Impact |
|---|---|---|
| Emberwake battle art | Borrows `night_moth_swarm` strips | The early boss has no dedicated silhouette; it reads as a moth. |
| `burn_line_hulk` battle art | Borrows `briar_hulk` | Act III boss add is visually a reuse. |
| `door_warden_boss` battle art | Borrows `door_warden` | Act III boss reuse. |
| `crown_guard_elite` | Borrows `occupation_soldier` | Act IV elite reuse. |
| `barrow_husk` | Borrows `lost_one` | Act IV enemy reuse. |
| `oath_iron` | Borrows `aethari_automaton` | Act IV enemy reuse. |
| `grave_moth` | Borrows `night_moth_swarm` | Act IV enemy reuse. |
| `magistrate_vell` battle art | Borrows `crown_sergeant` | Act IV boss reuse. |
| `barrow_warden` battle art | Borrows `sanctuary_warden` | Act IV boss reuse. |
| `forgotten_king` battle art | Borrows `door_warden` | Act IV final boss has no unique art. |
| Ash King / rare-encounter concept art | Unstarted | Future acts. |
| Left-facing battle strips | None | Party battlers are flipped with `image_xscale`; acceptable but not authored art. |
| Ashlands/coast/Ironspine/Frostwilds environment art | Missing | Blocks those acts' visual production. |
| Vell/Nessa portraits | Not planned | They have no portrait slot; not a defect. |

The borrowed boss art is the largest presentation gap in the built acts, especially the
Forgotten King. It is not a compile/runtime blocker.

---

## 5. Bestiary and enemy database

- Bestiary: **43 entries**, 43 distinct names, 43 with art, 6 aliases.
- Enemy database: **56 IDs**; 43 Bestiary rows, 6 aliases, 7 future/coast IDs.
- All 21 encounter tables reference valid enemy IDs; 14 named groups; 13 boss groups.
- Four pre-existing balance warnings: `zone01_old_road` and `zone01_bandit_camp` can roll
  a level-1 bandit in a level 2–4 band; `zone01_watchtower` and
  `zone01_basement_hall` can roll a level-3 Fallen Knight in a level 4–7 band. This is a
  tuning flag, not missing content.

Missing Bestiary content:

- No rows for the seven Act V/coast IDs. This is correct while they are unreachable;
  add them when the coast rooms ship.
- No entries for Acts VI–VIII enemies because those enemies do not exist.
- Bestiary descriptions are canon-reviewed but several are placeholder prose; see
  `docs/AI_AGENT_DEVELOPMENT_BACKLOG.md` P1.4.

---

## 6. Quests and dialogue

### Quests

| Quest | Status |
|---|---|
| `Q_MAIN_FIND_MIRA` | **Definition and stage wiring added in source** (PR #44); journal runtime check **NOT RUN**. |
| `Q_MAIN_BEYOND_VEIL` | Defined; advanced by Chapters 2–6 story code. |
| `Q_MAIN_BLACKWOOD` | Defined; advanced by Chapters 6–9 story code. |
| `Q_MAIN_CROWN` | Defined; advanced by Chapters 9–11 story code. |
| `Q_SIDE_RENN` | Defined; started/turned in by Renn's story code. |
| `Q_SIDE_ODA` | Defined; started/turned in by Wrenfield story code. |
| `Q_SIDE_PARCEL` | Defined; advanced by Chapter 3 story code. |
| `Q_SIDE_TITHE` | Defined; advanced by Chapter 7 story code. |
| `Q_SIDE_LEDGER` | Defined; advanced by Chapter 9 story code. |
| `Q_MF`, `Q_ST` (Act V) | Missing definitions and stages. |

### Dialogue

- 1,027 IDs defined; 958 referenced by scripts.
- 69 unreferenced nodes are reported as audit notes, not automatically missing content.
  Some are signs/tutorial lines that are intentionally optional; Chapter 12–14 docs are
  skipped because they have no dialogue data yet.
- Act V's 638 approved nodes are not implemented at all.

---

## 7. Audio

29 resources exist and are wired: 3 music loops, 6 ambience beds, 20 effects. The
assignment did not identify a specific missing audio asset beyond runtime verification.

Missing:

- No voice acting (not requested).
- No audio for unbuilt regions/acts.
- No in-GameMaker listening test; `step` is deliberately unused.

---

## 8. Corrections to the assignment's “known outstanding” list

The assignment's Phase Five list was written against an older tree. Current measured
state:

| Claim | Actual |
|---|---|
| Alden Marr has no completed sprite | Alden has a 16×24 four-direction set and three portraits. |
| 18 enemy types lack overworld sets | Zero enemy kinds with battle art lack an overworld set. |
| Nim and Derry lack portraits | Both have three portraits and overworld sets. |
| Blackwood tileset requires replacement | True: `ts_blackwood` is still a placeholder. |
| Ashlands needs its own tileset | True: no Ashlands tileset. |
| 34 rooms | 35 rooms (`rm_rimehold` added). |

These corrections are documentation, not new art claims. The actual files and resource
registry were checked.

---

## 9. What must not be invented

- Do not invent Act V–VIII story to “complete” the eight acts. Use the approved scripts
  where they exist and the owner's outline decisions where they do not.
- Do not change Alden's ending, the Ash Veil mythology, the rebellion, or Kael/Taren's
  roles.
- Do not replace placeholder Blackwood art with new canon art without art direction.
- Do not create the seven stub rooms as filler; they need their act's maps, encounters
  and story.
- Do not mark any built chapter as tested. It has not been compiled or played.
