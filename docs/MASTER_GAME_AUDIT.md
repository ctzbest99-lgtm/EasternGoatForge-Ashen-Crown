# ASHEN CROWN — Master Game Audit

**Audit date:** 2026-11-19
**Repository:** `ctzbest99-lgtm/EasternGoatForge-Ashen-Crown`
**Engine:** GameMaker Studio (GML)
**Audited revision:** `b4afeb7f5725fcbbb556202868c27fd03cd3136b` — the tip of PR #40, branch `freebuff/world-art-equipment-pass`
**Audit branches:** `freebuff/audit-save-repair` (code), `freebuff/audit-ci` (validation), `freebuff/audit-docs` (this report)
**PR #40:** https://github.com/ctzbest99-lgtm/EasternGoatForge-Ashen-Crown/pull/40

---

## 1. Why this revision was audited

The assignment says to work from the latest `main`. At audit time `main` was
`56eabe45` (`Apply approved Act V level cap of 27 on current mainline (#39)`), while
PR #40 was still open and contained 1,906 files of unpublished work: the regional
tilesets, the seven-slot equipment pass, the centralized input/controller layer, the
1,087 sprite resources and `rm_rimehold`.

Auditing `main` would have audited a project that does not contain the code the team is
actually preparing to merge. This audit therefore uses the PR #40 tip as the effective
development baseline. The audit branch is stacked on PR #40. **It must be retargeted to
`main` after PR #40 merges; nothing here may be merged directly into `main`.**

This is a grading of the code as it exists. It is not a claim that PR #40 is approved.

---

## 2. Executive summary

Ashen Crown already contains substantial, coherent development work:

- A full top-down exploration loop with keyboard and gamepad input.
- Eleven built chapters (Acts I–IV) with dialogue, encounters, bosses and room-to-room
  transitions.
- A turn-based battle system with SPD order, skills, MP, buffs, statuses, weaknesses,
  boss phases, yields, escape and item use.
- A five-person roster with four active slots, one reserve, seven equipment slots,
  shops, a forge and a versioned three-slot save system.
- A 43-entry Bestiary whose entries all resolve to enemy data and battle art.
- 35 rooms, seven tilesets, 1,087 sprite resources and 29 sound resources.
- Structural validation and source-to-generated synchronization in CI.

The project is **not** verified as a running game. No GameMaker IDE or runtime was
available in this environment. Compilation, rendering, collision feel, battle flow,
save/load in-engine, audio playback and physical controller behavior are all
**NOT RUN**. Automated validation proves structure and data consistency; it does not
prove that the project compiles.

Three gameplay defects were repaired and revalidated:

1. **HIGH — legacy saves lost level-gained HP/MP and caster MAG.** Schema v4 rebuilt
   maximum HP/MP from the fresh level-1 roster during migration. v1–v3 saves now seed
   their base maxima (and base MAG) from the saved values before the equipment refresh.
2. **LOW — the shop's “Equipped” count ignored off-hand, legs and accessory 2.** It now
   walks all seven slots.
3. **LOW — a refused unique drop was still announced as “Found”.** The message now only
   appears when the item actually enters the bag.

A stale Bestiary comment (“12/35” → “12/43”) and a CI validation gap (equipment audit and
Python syntax were not run) were also corrected. Those are not gameplay changes.

One content/system gap remains open, and one follow-up implementation is in review:

- **Chapter 1's main quest, `Q_MAIN_FIND_MIRA`, was absent from the journal and had no
  stage wiring.** This is implemented in source by follow-up PR #44 (`freebuff/audit-followups`):
  the approved S1–S9 definition, ordered stage writes, save/flag/room backfill and the
  Crownveil hand-off are wired through the existing story functions. It has **not** been
  compiled or played, so runtime acceptance is still **NOT RUN**.
- **Map-marker quest metadata (`quest_start`, `quest_advance`, `quest_turn_in`,
  `reward`) remains dead data.** Chapter 1 deliberately follows the Chapter 2–11
  story-function pattern (TD-04 option B), so this metadata is still misleading and
  should be removed or given a consumer in a separate change.

The remaining acts are content work, not repair work: Act V has approved scripts and
enemy data but zero rooms/dialogue; Acts VI–VIII and the finale are titles/outlines only.

---

## 3. Repository metrics (measured, not estimated)

| Metric | Count |
|---|---:|
| Human-readable GML files under `game/` | 156 |
| GML source lines under `game/` | 23,983 (23,756 audit baseline + 230 added − 3 removed by PR #44) |
| Script files under `game/scripts/` | 97 |
| Objects / object event files | 22 / 59 |
| Function definitions | 692 (686 baseline + 6 added by PR #44) |
| Generated GML files under `gamemaker/` (includes 33 room creation-code files) | 189 |
| GameMaker JSON files parsed by the validator | 1,289 |
| Included datafiles | 90 (86 + 4 save fixtures) |
| Rooms | 35 |
| Sprite resources | 1,087 |
| Sound resources | 29 |
| Tilesets | 7 |
| Documentation files | 40 (25 under `docs/story/`) |
| Bestiary entries | 43 |
| Enemy IDs in `scr_get_enemy_data()` | 56 (43 Bestiary + 6 aliases + 7 future/coast IDs) |
| Dialogue IDs defined / referenced | 1,027 / 958 |
| Encounter tables / named groups / table references / boss groups | 21 / 14 / 114 / 13 |
| Room exits checked by the chapter audit | 52 |

The 56 enemy IDs break down as:

- 43 Bestiary rows.
- 6 intentional aliases (`emberwake_boss`, `emberwake_late`, `crown_patrolman_road`,
  `crown_crossbowman_road`, `bandit_veteran_road`, `ward_sentinel_late`).
- 7 Act V/coast IDs defined ahead of their rooms (`drowned_husk`, `salt_wretch`,
  `tide_crawler`, `wreck_shade`, `toll_keeper`, `salt_leviathan`,
  `fallen_knight_last`).

---

## 4. What was inspected

### Source code

All 156 `game/**/*.gml` files were processed by the static scans below. High-risk files
were read directly:

- `scr_save.gml`, `scr_game_state.gml`, `scr_input.gml`, `scr_game_constants.gml`
- `scr_party.gml`, `scr_progression.gml`, `scr_battle_actors.gml`
- `scr_battle_system.gml`, `scr_battle_math.gml`, `scr_item_data.gml`,
  `scr_inventory.gml`, `scr_shop_data.gml`, `scr_quest_data.gml`
- `scr_sprites.gml`, `scr_bestiary.gml`, `scr_enemy_database.gml`,
  `scr_encounter_tables.gml`
- `scr_map_tilemaps.gml`, the chapter marker data files, `scr_story.gml`, and the
  Chapter 2–11 story scripts
- `obj_player`, `obj_battle_controller`, `obj_shop_menu`, `obj_inventory_menu`,
  `obj_adventure_menu`, `obj_save_menu`, `obj_game_controller`

### GameMaker project

- `gamemaker/AshenCrown.yyp`
- All 35 room `.yy` files and their creation code
- Object event mappings
- Sprite resource metadata and frame files
- Tileset resources
- Sound resources
- Included files
- `AshenCrown.resource_order`

### Documentation

Game Design Document, Story Bible, development roadmaps, the eight-act completion
tracker, story audits, asset inventory, test plan, playtest runbook, controller note,
equipment progression, backlog and changelog.

### Automation

`gen_gamemaker.py`, `validate_gamemaker.py`, `tools/sync_gamemaker.py`,
`tools/audit_chapters.py`, `tools/equipment_check.py`, `tools/sim_ch5_flow.py`,
`tools/balance_sim.py`, and `.github/workflows/validate.yml`.

---

## 5. System-by-system status

Status vocabulary: **COMPLETE** = implemented and verified by the stated evidence;
**IMPLEMENTED** = code/data exists but runtime testing is incomplete; **INCOMPLETE** =
partial; **MISSING** = absent; **BLOCKED** = needs an external dependency/decision;
**NOT TESTED** = no verification performed.

| System | Status | Evidence and findings |
|---|---|---|
| Project structure / resource registry | COMPLETE (structural) | 1,289 JSON files parse; 35 rooms registered; all resource paths resolve; 1,087 sprite + 29 sound + 7 tileset resources. |
| Source-to-generated sync | COMPLETE (structural) | `tools/sync_gamemaker.py --check` reports zero managed changes after the repaired scripts were mirrored. |
| Exploration / movement | IMPLEMENTED | `scr_input_move_vector` normalizes keyboard and stick diagonals; `obj_player` uses axis-separated collision against `obj_solid` and the `Collision` tile layer. Facing and interaction probes are implemented. No runtime collision/feel test. |
| Room transitions and spawns | IMPLEMENTED | 35 rooms, 33 builders, 52 exits checked; all `target_spawn` names exist; seven intended destinations are missing rooms. No runtime transition test. |
| Party system | IMPLEMENTED | Five-member roster, four active, one reserve; swap, join, reserve, formation order and equipment refresh exist. No runtime test of every join path. |
| Combat core | IMPLEMENTED | Attack/Skill/Item/Guard/Swap/Escape; SPD turn order; MP costs; physical vs magic; weakness and resistance; buffs/statuses; victory/defeat/escape. No runtime test. |
| Boss phases | IMPLEMENTED | Blackguard three phases at 60%/20%; generic `phase2_at` / `phase3_at` transitions; yields and add-withdrawal. Static path is coherent; no runtime test. |
| Inventory | IMPLEMENTED | 181 item records; stackable/unique/key handling; bag tabs; item use removes one on effect. No runtime test. |
| Equipment | IMPLEMENTED | Seven slots (`main_hand`, `off_hand`, `head`, `body`, `legs`, `accessory_1`, `accessory_2`); proficiency, two-handed conflicts, stat/resistance recomputation. Display count repaired. No runtime test. |
| Shops / forge | IMPLEMENTED | Buy/sell, discount, stock-by-act, 20 recipes; equipment checker reports 136 equipment items and full act coverage. No runtime test. |
| Save/load | IMPLEMENTED | Three slots, JSON, schema v4, v1→v4 migration, corruption-safe reads, inventory/equipment sanitization. Legacy base-max migration repaired; sanitized v1–v4 fixtures and an in-engine migration self-test were added by PR #44. The self-test has **NOT RUN** (no GameMaker runtime). |
| Input / controller | IMPLEMENTED | One input layer; Xbox A/B/Start/LB/RB and D-pad mappings; left-stick movement with radial dead zone; disconnect/reconnect scan. Physical controller test **NOT RUN**. |
| Bestiary | COMPLETE (data) | 43 rows, 43 distinct names, 43 with art, 6 aliases; seen/defeated tracking and illustration pane. In-engine pane not viewed. |
| Quests | IMPLEMENTED (source) | Chapters 2–11 write quest flags from story code. Chapter 1's `Q_MAIN_FIND_MIRA` definition and S1–S9 wiring were added by PR #44 using the same story-function pattern; marker quest fields remain unconsumed. No runtime journal check. |
| Dialogue | IMPLEMENTED | 1,027 IDs; 958 referenced; 69 unreferenced nodes reported as notes. No runtime text/layout test. |
| World / maps | IMPLEMENTED | 35 rooms; seven missing room targets are deliberate stubs. No runtime collision, spawn or transition test. |
| Audio | IMPLEMENTED | 29 resources (3 music, 6 ambience, 20 effects) wired through `scr_audio`. Nothing listened to in GameMaker. |
| Assets | IMPLEMENTED | Party, named NPCs, all Bestiary art and all enemy-kind overworld sets exist. Blackwood atlas is still a placeholder; Ashlands/coast have no tileset. See missing-content report. |
| Story Acts I–IV | IMPLEMENTED | Chapters 1–11 built, with 1,027 dialogue IDs, rooms, bosses and transitions. Not compiled or played. |
| Act V | INCOMPLETE | Chapters 12–14 approved as scripts; enemy and boss data exists; zero rooms/dialogue/quest rows/story code. |
| Acts VI–VIII + finale | MISSING (outlines/titles only) | No chapters, scripts, rooms or bosses. Ashlands and Rimehold have standalone rooms only. |
| Validation / CI | IMPLEMENTED | Validator, sync check and chapter audit run in CI. Equipment audit and Python syntax checks were missing and are added by the validation PR. |
| Compilation / playtest | BLOCKED | No GameMaker IDE/runtime in the audit environment. |

---

## 6. Defect summary

Full detail and evidence are in `docs/BUG_AND_REPAIR_LOG.md`.

| ID | Severity | Status | Summary |
|---|---|---|---|
| BUG-001 | HIGH | REPAIRED | v1–v3 saves lost level-gained max HP/MP and caster MAG during v4 migration. |
| BUG-002 | LOW | REPAIRED | Shop “Equipped” count ignored off-hand, legs and accessory 2. |
| BUG-003 | LOW | REPAIRED | A unique drop refused by the bag was still announced as found. |
| CONTENT-001 | HIGH | FIXED IN SOURCE (runtime NOT RUN) | Chapter 1 main quest `Q_MAIN_FIND_MIRA` definition and S1–S9 stage wiring were added by PR #44. |
| DEBT-001 | MEDIUM | OPEN | Marker quest metadata is dead data. Chapter 1 now uses story functions, so the fields remain misleading but no longer block the quest. |
| DEBT-002 | MEDIUM | OPEN | Save writes are not atomic; a crash during `buffer_save` can truncate a slot. |
| DEBT-003 | LOW | OPEN | Equipment sanitization clears an invalid equipped item instead of returning it to the bag. |
| DEBT-004 | LOW | OPEN | `scr_craft_make` ignores a failed inventory add when consuming materials. No current recipe is unique, so the path is latent. |
| DEBT-005 | LOW | OPEN | Left stick is movement-only; menu navigation is D-pad-only despite the input-file header. The assignment only requires D-pad menu navigation. |
| RISK-001 | MEDIUM | UNCONFIRMED | Guard is cleared at `ROUND_START`, so a guard chosen after all enemies act gives no protection. Needs design confirmation/playtest. |

No duplicate function definitions, no undefined `scr_*` calls, no function-arity
mismatches, and no direct gamepad reads outside `scr_input` were found. The only direct
keyboard read outside the input layer is the debug F5 save shortcut.

---

## 7. Static analysis performed

| Check | Result |
|---|---|
| Function definitions / call sites checked for arity | 686 / 3,862 — 0 mismatches (variadic `scr_sprite_index` excluded by design) |
| Duplicate function names | 0 |
| Undefined `scr_*` calls after comments/strings stripped | 0 |
| Missing `spr_` / `obj_` / `snd_` / `ts_` references | 0, after ignoring dynamic concatenation prefixes |
| Unresolved room references | 7, all deliberate stubs |
| `target_spawn` names with no marker | 0 |
| Room `.yy` resources not registered in `.yyp` | 0 |
| Room creation code with a bad builder call | 0 |
| Direct gamepad reads outside `scr_input.gml` | 0 |
| Bestiary IDs absent from enemy data | 0 |
| Bestiary IDs without battle art | 0 |
| Encounter table IDs absent from enemy data | 0 |
| Encounter groups naming a non-boss in the boss slot | 0 |
| Equipment schema invalid records | 0 |

Function/call-site counts above are the pre-PR-#44 audit baseline. PR #44 adds six
GML functions (692 total) in existing scripts and no new script resource, so the
97-script and 156-file counts are unchanged.

The seven deliberate missing rooms are `rm_flooded_ruins`, `rm_frozen_ruins`,
`rm_ironspine_mine`, `rm_ironspine_ruins`, `rm_saltreach`, `rm_saltreach_pier` and
`rm_shipwreck`. They are Act V–VIII destinations. Creating them is content work, not a
one-line map repair.

---

## 8. Documentation reconciliation

Several documents were stale before this audit:

- The backlog said 34 rooms; the project has 35 (`rm_rimehold` was added).
- The assignment's “Nim and Derry lack portraits”, “Alden Marr has no completed sprite”
  and “18 enemy types lack overworld sets” are no longer true. All three named speakers
  have portraits and overworld sets; every enemy kind with battle art has an overworld
  set.
- The Bestiary counter comment said “12/35”; it now says “12/43”.
- `main` is 1,906 files behind the audited revision, so older documentation cannot be
  used as a description of the PR #40 tree without checking the source.

The audit docs and the updated backlog are the corrected description of the audited
revision. They do not rewrite story canon.

---

## 9. What is verified, and what is not

**Verified by tools**

- JSON/resource structure, room registration and included files.
- Source-to-generated GML equality.
- Chapter wiring, encounter tables, dialogue references, spawns and room targets.
- Bestiary-to-enemy-to-art consistency.
- Item/equipment schema, progression tiers, merchant coverage and recipes.
- Chapter 5 state-machine flow and its guard conditions.
- Balance model output (a simulation, not the game).

**Owner-reported (2026-11-19; not independently verified)**

The project owner reports that the game launches and that keyboard input, player
movement, combat, inventory, equipment, party management, leveling and stat upgrades
work. Area transitions and entering areas, NPC interactions and dialogue, save/load
reliability, consumable use outside combat, controller support and full GameMaker IDE
compile confirmation remain outstanding. No build log or commit-specific evidence was
supplied with this report. It does not upgrade any tool-verified claim above.

**Not independently verified**

- GameMaker IDE import or compilation.
- Runtime rendering, collision, camera, menus, battle flow, save/load, audio.
- Controller enumeration, dead zone feel, hot-plug or Xbox certification.
- Any visual review of maps, UI, portraits or animations.
- Act V–VIII content, because it is not built.

`docs/GAMEMAKER_VERIFICATION.md` records every check, the owner report in §1.1, and
every `NOT RUN` item.

---

## 10. Recommended next work

1. Open `gamemaker/AshenCrown.yyp` in the supported GameMaker IDE and record the first
   compile result. Do not add features until the project boots.
2. Play the Chapter 1 smoke path with a fresh save and one migrated v3/v4 fixture. The
   save migration repair and fixtures are in source (PR #44), but no fixture has been
   loaded in GameMaker.
3. Run `scr_save_migration_test()` with `DEBUG_SAVE_SELFTEST` enabled (F6) in the IDE.
   It executes the real migration path against the four sanitized fixtures; the Python
   contract test does not replace it.
4. Confirm the `Q_MAIN_FIND_MIRA` journal appears and advances through S1–S9, then
   switches to `Q_MAIN_BEYOND_VEIL` at the Crownveil door.
5. Play through Chapters 1–11 against `docs/PLAYTEST_RUNBOOK.md`; record failures with
   room, steps and logs.
6. Build Act V rooms/dialogue (Chapters 12–14) only after the existing eleven chapters
   are stable.
7. Replace the Blackwood placeholder atlas and add the Ashlands/coast environment sets
   when those acts enter production.

The project should not be rewritten. The existing systems are coherent; the highest-value
work is verification and the missing content listed in the companion reports.
