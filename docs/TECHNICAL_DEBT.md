# ASHEN CROWN — Technical Debt

**Audit date:** 2026-11-19
**Baseline:** `b4afeb7f` (PR #40 tip)
**Scope:** maintainability and risk in the audited revision. This is not a request to
rewrite working systems. Items are ordered by risk to the next milestone: a clean
GameMaker compile and a Chapter 1–11 playtest.

---

## 1. Priority summary

| ID | Debt | Risk | Effort | Priority |
|---|---|---|---|---|
| TD-01 | No GameMaker compile or runtime test in CI/audit | High | Medium | P0 before merge |
| TD-02 | Save schema has no fixture-based migration tests | High | Medium | P0 |
| TD-03 | Save writes are not atomic | Medium | Small | P1 |
| TD-04 | Quest metadata and Chapter 1 quest are disconnected | High (content correctness) | Medium | P1 |
| TD-05 | Source/generated dual tree plus generator churn | Medium | Medium | P1 |
| TD-06 | Structural validators cannot see runtime/UI/input behavior | Medium | Large | P1 ongoing |
| TD-07 | Room tile layers are placeholders switched at runtime | Medium | Medium | P2 |
| TD-08 | Large data functions and scattered story flags | Medium | Large | P2 |
| TD-09 | Borrowed boss/enemy art | Low–Medium | Art-dependent | P2 |
| TD-10 | Documentation drift and stale “known issues” | Low | Small | P2 |
| TD-11 | 69 unreferenced dialogue nodes with no policy | Low | Small | P3 |
| TD-12 | Encounter-band and equipment balance flags | Low | Small | P3 |
| TD-13 | Input/menu controller behavior has no automated test | Low | Medium | P3 |

---

## 2. TD-01 — No compile or runtime verification

**Evidence.** This environment has no GameMaker IDE, runtime, licence or display. The
validators parse JSON and GML text; they do not compile. `docs/GAMEMAKER_VERIFICATION.md`
records every runtime check as `NOT RUN`.

**Risk.** GML is dynamically typed. A passing structural validator does not prove that
the project imports, that every instance variable exists at runtime, that a room's
creation code runs before its instances need it, or that draw code is valid. The
`main` branch is 1,906 files behind the audited tree, so no one has compiled this exact
revision in CI.

**Mitigation.**

1. Compile `gamemaker/AshenCrown.yyp` in the supported IDE before merging PR #40.
2. Record the IDE version, target and full output in `docs/GAMEMAKER_VERIFICATION.md`.
3. Run the Chapter 1 smoke path on a fresh save and a migrated save.
4. Add a CI job only if the team has a licensed headless GameMaker runner; do not fake
   a compile with a GML parser.

---

## 3. TD-02 — Save migrations are untested

**Evidence.** `scr_save.gml` supports schema v1–v4 and several migrations. The audit
found a real v3→v4 regression (BUG-001) by reading the field sets, not by loading a
fixture. There are no committed v1/v2/v3 save fixtures and no test that asserts
`max_hp`/`max_mp`/`magic` after migration.

**Risk.** Future schema changes can silently reset progression again. The repair is
correct by inspection, but a regression test would make it durable.

**Mitigation.** Add small sanitized JSON fixtures for v1, v2, v3 and v4 under
`tests/fixtures/saves/`, with expected base/derived stats for one warrior and one caster.
Add a Python or GML harness that applies the migration and asserts:
`level`, `xp`, `base_max_hp`, `base_max_mp`, `base_magic`, `max_hp`, `max_mp`, `magic`,
equipment and inventory contents. Do not use real player saves.

This is assigned as P0.3 in `docs/AI_AGENT_DEVELOPMENT_BACKLOG.md`.

---

## 4. TD-03 — Non-atomic save writes

`buffer_save()` writes directly to `saveN.sav`. A crash mid-write truncates the slot.
Reads handle truncation safely (return `undefined`), so the failure is data loss rather
than a crash. A temp-file + validate + rename strategy with one `.bak` is the standard
repair and needs an in-engine file test.

---

## 5. TD-04 — Quest metadata is disconnected

**Evidence.** `quest_start`, `quest_advance`, `quest_turn_in` and marker `reward` exist in
`scr_map_markers_data.gml` / `scr_wf_markers_data.gml` but are read nowhere.
`Q_MAIN_FIND_MIRA` is started by a marker field but has no quest definition. The quest
journal therefore cannot show Chapter 1's main objective.

**Risk.** The data looks authoritative, so a future writer can add a quest marker that
never fires. Chapter 1 is the onboarding chapter; an invisible main quest is a
first-hour content failure.

**Options.**

- **A. Implement generic marker quest actions.** Teach the marker trigger to call
  `scr_quest_start()` / `scr_quest_advance()` / `scr_quest_complete()`, then add the
  missing `Q_MAIN_FIND_MIRA` definition and the S1/S4–S7 stage calls that have no marker
  today.
- **B. Remove the dead fields.** Keep quest transitions in chapter story code, as
  Chapters 2–11 do, and delete the misleading metadata.

Option A matches the existing marker data and is the smaller content edit, but it needs
a deliberate decision about duplicate starts, rewards and turn-in authority. Do not
implement both mechanisms.

---

## 6. TD-05 — Dual source tree and generator churn

**Evidence.** `game/` is the authoring tree; `gamemaker/` is generated by
`gen_gamemaker.py` and synchronized by `tools/sync_gamemaker.py`. The generated tree
contains 189 GML files versus 156 in `game/` because room creation code is generated.
A full `sync_gamemaker.py --apply` in this revision proposes rewriting a large number of
sprite `.yy` metadata files (on the order of 1,000), even when only three scripts changed.

**Risk.** A routine sync can bury a small code change in a thousand metadata diffs. The
audit avoided that by copying the changed scripts to their generated mirrors and relying
on `sync_gamemaker.py --check` (zero managed changes). This is correct but manual, and
future contributors may run `--apply` and create an unreviewable PR.

**Mitigation.** Make the generator write only files whose content actually changed, and
add a `--check` assertion that a code-only change yields a code-only diff. Until then,
document the copy-and-check procedure for small script repairs.

---

## 7. TD-06 — Structural validators are not runtime tests

The validators are useful and should be kept. Their blind spots:

- No GML execution: cannot catch division by zero, undefined variables, bad array
  indices, struct field typos or event-order bugs.
- No draw/UI layout: cannot catch text overflow, missing glyphs or a menu that draws off
  screen.
- No input feel: cannot test dead zones, repeat delay or controller hot-plug.
- No audio: cannot test missing sounds or mixing.
- No save file I/O: cannot test atomicity, permissions or corruption.

Do not weaken or delete a validator because it cannot do these things. Pair it with the
manual matrix in `docs/PLAYTEST_RUNBOOK.md`.

---

## 8. TD-07 — Rooms are visually placeholder assets

All 35 room `.yy` tile layers are empty `ts_zone1` layers. Builders switch the layer's
tileset at runtime to `ts_wrenfield`, `ts_valemere`, `ts_coleford`, `ts_garrison`,
`ts_barrow` or `ts_blackwood`. This keeps room files small and lets one builder serve
multiple visual zones, but:

- The IDE room editor does not show the final map.
- `ts_blackwood` is still placeholder art.
- No Ashlands/coast/Ironspine/Frostwilds atlas exists.
- A future contributor can “fix” an empty room layer and accidentally double-paint.

**Mitigation.** Document the convention in the map-authoring guide, keep the tileset
switch in the builder as the single source of truth, and replace atlases only with art
direction approval.

---

## 9. TD-08 — Large data functions and loose story flags

Largest source files:

| Lines | File |
|---:|---|
| 2,240 | `game/scripts/scr_item_data.gml` |
| 778 | `game/scripts/scr_save.gml` |
| 771 | `game/objects/obj_battle_controller/Create.gml` |
| 632 | `game/scripts/scr_map_tilemaps.gml` |
| 625 | `game/scripts/scr_menu_layout.gml` |
| 522 | `game/scripts/scr_ch2_story.gml` |

`scr_item_database()` is a single 968-line function; `scr_get_enemy_data()` is 370 lines;
several dialogue node functions exceed 200 lines. These are mostly data tables, so line
count alone is not a defect. The real risk is that story state is stored as string flags
(`scr_flag_set("...")`) and quest stages as loose strings, with no schema or exhaustive
transition test. A typo produces a silently dead branch.

**Mitigation.** Do not split the data tables for style. Add a flag/quest audit that lists
every flag written and read, and fail on writes with no reader (or document intentional
one-way flags). This would have caught the dead `Q_MAIN_FIND_MIRA` marker earlier.

---

## 10. TD-09 — Borrowed art

Ten enemies/bosses borrow another creature's battle strips, including the Forgotten King
(borrows `door_warden`) and Emberwake (borrows `night_moth_swarm`). The silhouettes are
readable but the final Act IV boss does not have a unique identity. This is presentation
debt, not a runtime blocker. See `docs/MISSING_CONTENT_REPORT.md` for the full list.

---

## 11. TD-10 — Documentation drift

Examples corrected in this audit:

- Backlog said 34 rooms; the tree has 35.
- Bestiary comment said “12/35”; it has 43.
- The assignment's “Nim/Derry lack portraits” and “18 enemy types lack overworld sets”
  are stale.
- Several story docs predate PR #40's 1,906-file change.

**Mitigation.** Generated counts should come from a script, not be hand-copied. At
minimum, run `validate_gamemaker.py` and `tools/equipment_check.py` before updating a
status document, and date every audit.

---

## 12. TD-11 — Unreferenced dialogue nodes

`tools/audit_chapters.py` reports 69 unreferenced nodes (plus three skipped draft
chapters). Some are optional signs/tutorial lines; others may be dead content. There is
no policy distinguishing “intentionally optional” from “forgotten”.

**Mitigation.** Add an allowlist with a reason per optional node, or delete truly dead
nodes. Do not delete story dialogue without a writer's review; canon is not code.

---

## 13. TD-12 — Balance flags

- Four encounter tables can roll one level below their band:
  `zone01_old_road` (bandit L1 in 2–3), `zone01_bandit_camp` (bandit L1 in 3–4),
  `zone01_watchtower` and `zone01_basement_hall` (Fallen Knight L3 in 4–7).
- `tools/equipment_check.py` reports five balance flags; its warning list includes 12
  legendary items with no enemy drop source. Most are specified as Act VI–VIII quest or
  chest rewards, so this is expected for unbuilt content. The tool counts warning lines
  and a separate flag total; read the output, do not treat “5 flags” as five items.

These are tuning signals, not missing content. Do not “fix” them by deleting the warning.

---

## 14. TD-13 — Input layer is statically sound, dynamically untested

`scr_input.gml` centralizes keyboard and gamepad polling, applies a radial dead zone and
normalizes movement. Static checks found no direct gamepad reads elsewhere. However:

- No physical controller test has been run.
- Left-stick menu navigation is not implemented (D-pad only).
- Repeat delay and dead-zone feel are subjective and untested.
- Hot-plug calls `gamepad_is_connected()` per pad each step; acceptable, but no profile
  has been measured.

**Mitigation.** Run the controller checklist in `docs/CONTROLLER_SUPPORT.md` on Windows
with an Xbox pad, then on the target platforms. Record the exact pad and driver.

---

## 15. Debt explicitly not addressed in this audit

- No architecture rewrite.
- No save-format redesign beyond the v1–v3 seed repair.
- No new quest system, dialogue system, battle system or input abstraction.
- No asset generation or replacement.
- No creation of the seven stub rooms.
- No rebalancing of encounter tables or legendary drop sources.
- No change to the eight-act/finale structure.

Those are product decisions or content production. The audit's job was to make the
current tree honest and keep it from losing player saves.
