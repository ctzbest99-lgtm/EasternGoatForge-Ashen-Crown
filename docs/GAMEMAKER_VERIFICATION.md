# ASHEN CROWN — GameMaker Verification

**Date:** 2026-11-19
**Revision:** `b4afeb7f` (PR #40 tip, branch `freebuff/world-art-equipment-pass`); follow-ups at `5994fae8` (PR #44 tip, branch `freebuff/audit-followups`)
**Project file:** `gamemaker/AshenCrown.yyp`
**Audit branches:** `freebuff/audit-save-repair`, `freebuff/audit-ci`, `freebuff/audit-docs`, `freebuff/audit-followups`
**Environment:** Ubuntu 24.04.5 LTS cloud workspace (x86_64, `DISPLAY` unset); no GameMaker IDE, runtime, account/licence or display. The compile and F6 attempt is logged in §2.9.

---

## 1. Bottom line

| Question | Answer |
|---|---|
| Did the GameMaker project import? | **NOT RUN** |
| Did it compile? | **NOT RUN** |
| Did the game launch? | **NOT RUN** |
| Was any chapter played? | **NOT RUN** |
| Was a save loaded in-engine? | **NOT RUN** |
| Was `scr_save_migration_test()` (F6) run? | **NOT RUN** |
| Was a controller tested physically? | **NOT RUN** |
| Was audio heard? | **NOT RUN** |
| Were visuals reviewed? | **NOT RUN** |
| Did automated structural validation pass? | **YES** |
| Did source/generated synchronization pass? | **YES** |
| Did chapter wiring and item audits pass? | **YES** |

Do not describe this revision as “compiles”, “runs”, “playable” or “tested”. The only
verified claims are structural, static and model-based.

---

## 2. Automated results

All commands were run from the repository root after the repairs.

### 2.1 Structural validator

```
python3 validate_gamemaker.py
```

Exit status **0**. Output summary:

```
parsed 1289 json files
datafiles checked: 86
room order: [35 rooms, rm_title through rm_rimehold]
unresolved refs: ['rm_flooded_ruins', 'rm_frozen_ruins', 'rm_ironspine_mine',
                  'rm_ironspine_ruins', 'rm_saltreach', 'rm_saltreach_pier',
                  'rm_shipwreck']
bestiary: 43 entries, 43 distinct names, 43 with art, 6 aliased
encounters: 21 tables, 14 groups, 114 table refs, 13 boss groups
levels: 16 tables checked against their bands, 4 out of band
WARNINGS (4): ...
ALL CHECKS PASSED
```

The seven unresolved refs are deliberate future-act stubs, documented in
`docs/MISSING_CONTENT_REPORT.md`. The four warnings are encounter-band tuning flags,
not validation failures. **No check was weakened to obtain this pass.**

### 2.2 Source-to-generated synchronization

```
python3 tools/sync_gamemaker.py --check
```

Exit status **0**:

```
Generated project validated. Managed file changes: 0
SYNC OK: generated project matches source inputs.
```

This confirms the five changed scripts plus the Bestiary comment are mirrored exactly.
The check is code-focused; it does not prove the generated resource metadata is
byte-identical in every sprite `.yy`.

### 2.3 Chapter wiring audit

```
python3 tools/audit_chapters.py
```

Exit status **0**:

```
story scripts: 10  dialogue files: 12  rooms with markers: 33  exits checked: 52
dialogue ids defined: 1027  referenced by scripts: 958

No wiring problems found.

NOTES (72): ...
```

The 72 notes include three intentionally skipped draft chapters (12–14) and 69
unreferenced dialogue nodes. Notes are not failures; they are the “unused dialogue”
backlog item.

### 2.4 Equipment and item audit

```
python3 tools/equipment_check.py
```

Exit status **0**:

```
schema: 181 records, 0 invalid, max effects 2
items: 181   equipment: 136   recipes: 20   enemies: 56   bosses: 15
gear obtainable by boss drop: 8
gear obtainable by crafting: 20
gear sold by a wired merchant: 100
gear defined only for unbuilt Act III-VIII shops: 0
none. ALL CHECKS PASSED (5 balance flag(s))
```

The warning block lists 12 legendary items without an enemy drop source, most assigned
to unbuilt Act VI–VIII content. The “5 balance flag(s)” total and the warning count are
different counters; read the full output rather than the total alone.

### 2.5 Chapter 5 flow simulation

```
python3 tools/sim_ch5_flow.py
```

Exit status **0**:

```
model states explored: 154
markers checked: 20 (script_ids handled, doors and spawns resolved)
shortest route to the handoff (11 actions): ...
choose_yield branch: yielded=True complete=True
choose_kill branch: yielded=False complete=True
```

This is a **model**, not the GameMaker runtime. It proves the state machine and guard
conditions are internally consistent for the paths it explores.

### 2.6 Balance model

```
python3 tools/balance_sim.py
```

Exit status **0**. The model exercised Act I–V parties, tiers, coast commons, the
Toll-Keeper, the Saltreach Leviathan and the Fallen Knight, including tier-VII-only
comparisons. It printed no tier-VIII block because that content is not built.

This is a simulation of formulas, not a playthrough. It does not prove encounter
placement, AI, turn order or UI.

### 2.7 Python syntax

```
python3 -m py_compile gen_gamemaker.py validate_gamemaker.py tools/*.py
```

Exit status **0**.

### 2.8 Diff hygiene

```
git diff --check
```

Exit status **0** (no whitespace errors). The working tree contained only the intended
code, mirror and documentation changes; local review renders under `artifacts/` were
untracked and excluded.

### 2.9 Runtime attempt: IDE compile and F6 self-test (2026-11-19)

The IDE compile and the in-engine save-migration self-test were **attempted** on this
host, not deferred. The attempt stopped at environment detection: no build was started,
so there is no executable, build log or first compiler error to quote.

```sh
command -v igor GameMaker gamemaker   # all: not found
ls ~/GameMaker* /opt/GameMaker*       # no such files or directories
echo "DISPLAY=${DISPLAY:-<unset>}"    # <unset>
command -v wine mono Xvfb             # all: not found
cat /etc/os-release                   # Ubuntu 24.04.5 LTS
uname -m                              # x86_64
```

GameMaker ships an IDE for Windows, macOS and (beta) Ubuntu 24.04, but every route
requires an interactive account sign-in, a licensed runtime download and a display.
This workspace has none of the three, and installing the proprietary IDE and runtime
unattended was neither possible nor authorised. Both F5 (compile) and F6 (self-test)
run inside that IDE, so neither could be executed.

The static stand-ins were re-run at `5994fae8` instead:

```
python3 tests/save_migration_test.py
save migration fixtures and Chapter 1 quest wiring: OK
runtime GML self-test: NOT RUN (requires GameMaker)
exit 0

python3 validate_gamemaker.py
datafiles checked: 90
ALL CHECKS PASSED (4 encounter-band warnings)
exit 0
```

| Check | Result | Evidence |
|---|---|---|
| Import `AshenCrown.yyp` and compile (F5) | **NOT RUN** | No IDE, runtime, licence or display; probe above |
| F6 `scr_save_migration_test()` on v1–v4 fixtures | **NOT RUN** | Same blocker; no GameMaker process started |
| Build log / first compiler error | **none produced** | No build was started |

**Status unchanged.** §1, §4 and §6 remain the source of truth. The static checks above
are not a compile and do not prove the in-engine self-test passes.

---

## 3. Static checks performed

| Check | Scope | Result |
|---|---|---|
| GML function definitions | 686 | 0 duplicates |
| Function call arity | 3,862 call sites | 0 mismatches (variadic excluded) |
| Undefined `scr_*` calls | All 156 `game/**/*.gml` | 0 after stripping comments/strings |
| Direct gamepad reads | All GML | 0 outside `scr_input.gml` |
| Direct keyboard reads | All GML | Only debug F5 outside `scr_input.gml` |
| Room registrations | 35 rooms | 0 missing from `.yyp` |
| Room builders | 33 creation-code calls | 0 missing/bad builders |
| Exits and spawns | 52 exits | 0 unknown `target_spawn` names |
| Room targets | All marker targets | 7 known stubs, 0 unknown rooms |
| Bestiary → enemy data | 43 IDs | 43/43 resolve |
| Bestiary → battle art | 43 IDs | 43/43 resolve |
| Encounter → enemy data | 114 table refs | 0 unknown IDs |
| Boss groups | 13 | 0 non-boss entries in boss slots |
| Equipment records | 181 | 0 invalid |
| Save schema | v1–v4 | migration reviewed; sanitized fixtures + GML self-test added in PR #44; self-test NOT RUN |

---

## 4. Checks that are NOT RUN and why

| Check | Status | Reason / required environment |
|---|---|---|
| Import `AshenCrown.yyp` | NOT RUN | Attempted 2026-11-19; no GameMaker IDE (§2.9) |
| Compile (Windows VM target) | NOT RUN | Attempted 2026-11-19; no GameMaker runtime/licence/display (§2.9) |
| Launch to title | NOT RUN | No runtime/display |
| New-game Chapter 1 smoke | NOT RUN | No runtime |
| Load migrated v3 save | NOT RUN | No runtime |
| Run `scr_save_migration_test()` (F6) | NOT RUN | Attempted 2026-11-19; blocked with the compile (§2.9); Python contract test only |
| Battle — attack/skill/item/guard/swap/escape | NOT RUN | No runtime |
| Boss phase transitions | NOT RUN | No runtime |
| Shop buy/sell/equipped count | NOT RUN | No runtime |
| Forge | NOT RUN | No runtime |
| Bestiary pane | NOT RUN | No runtime/visual |
| Dialogue box layout/text overflow | NOT RUN | No visual |
| Room transitions/camera/collision feel | NOT RUN | No runtime |
| Audio playback/mixing | NOT RUN | No runtime/audio |
| Physical Xbox controller | NOT RUN | No controller/OS |
| Hot-plug/disconnect | NOT RUN | No controller |
| Performance/FPS/memory | NOT RUN | No runtime |
| Visual review of maps/art | NOT RUN | No display |

**Do not convert any of these to “PASS” based on a validator.** They require a human at
a GameMaker IDE with a display.

The import, compile and F6 rows were attempted on 2026-11-19; §2.9 records the probe
output and why the build could not start. No check was skipped for convenience.

---

## 5. Manual verification procedure

Run this in the supported GameMaker IDE, on the branch to be merged, before calling the
revision verified.

### 5.1 Import and compile

1. Open `gamemaker/AshenCrown.yyp` with the project's supported GameMaker version.
2. Let the asset compiler finish; record every warning and error verbatim.
3. Build for the primary desktop target.
4. If compilation fails, stop. Do not “fix” it by deleting resources or disabling the
   failing system. Record the first error with file/line and object/event.
5. Add the IDE version and build output to this document.

### 5.2 Fresh Chapter 1 smoke

1. Start a new game on slot 1.
2. Confirm the title, opening dialogue, name entry/confirm and first room load.
3. Move with WASD/arrows and the left stick; confirm no wall clipping and no stuck
   spawn.
4. Talk to Tomas, accept the find-Mira objective, and open the journal.
   **Expected after PR #44:** `Q_MAIN_FIND_MIRA` appears and advances through S1–S9,
   then switches to `Q_MAIN_BEYOND_VEIL` at the Crownveil door.
   **Current verification state:** implemented in source but not observed in GameMaker;
   record the actual result, do not mark it fixed from the source diff alone.
5. Pick up the pendant, leave north, cross the Farmlands and Old Road, enter the Bandit
   Camp, the Watchtower and the Basement.
6. Defeat the Blackguard; confirm the Fallen Knight scene and the Chapter 2 hand-off.
7. Save, quit to title and load. Confirm level, HP/MP, MAG, equipment and inventory.

### 5.3 Migrated save

Use a **copy** of a real v3 save, never the original:

1. Place it in the save directory under a spare slot.
2. Load it and record `level`, `xp`, `max_hp`, `max_mp`, `magic`, equipment and inventory
   before and after the load.
3. Confirm `max_hp`/`max_mp` are at least the saved values (plus any new gear bonuses)
   and a caster's MAG is not reset to the level-1 value.
4. Save to a different slot and reload; confirm stability.

### 5.4 Battle matrix

For at least one normal encounter and each boss:

- Attack, skill (single/aoe/heal/buff), item, guard, swap and escape.
- Confirm MP is spent once, damage is applied once, statuses tick and expire, and the
  turn order matches SPD.
- Confirm a defeated party member cannot act and revival works.
- Confirm the Blackguard's 60%/20% phases and the generic `phase2_at`/`phase3_at` bosses.
- Confirm yield and kill branches where available.
- Confirm the victory drop message only lists items actually added.
- Confirm Guard's intended duration. Record whether a guard chosen after all enemies act
  survives to the next enemy action (RISK-001).

### 5.5 Menus and systems

- Inventory tabs, use, equip, unequip, two-handed conflicts, proficiency.
- Shop buy/sell, equipped count in all seven slots, gold and stock.
- Forge recipe list, material consumption, result add.
- Quest journal for Chapters 1–11.
- Bestiary list, entry detail, seen/defeated counters.
- Save/load all three slots, overwrite, cancel and corrupt-file handling.
- Options: volumes, text speed, fullscreen, controller.

### 5.6 Controller

Follow `docs/CONTROLLER_SUPPORT.md`. Test Xbox A/B/Start/LB/RB, D-pad menus, left-stick
movement, dead zone, diagonal speed, disconnect/reconnect and keyboard fallback.

### 5.7 Audio and visuals

Listen to title, field, battle, boss and victory music; confirm ambience and effects.
Review every built room for tile seams, collision mismatch, spawn overlap and camera
bounds. Capture screenshots for the PR, not as a substitute for playing.

---

## 6. Evidence log template

When the manual pass is run, append:

```
IDE version:
Attempted on: (host/OS; if not run, the exact blocker)
Target:
Commit:
Compile result: PASS/FAIL (paste first error)
Fresh save: PASS/FAIL
Migrated v3 save: PASS/FAIL (before/after stats)
Chapter 1–11 smoke: PASS/FAIL per chapter
Battle matrix: PASS/FAIL per boss
Controller: PASS/FAIL, pad/driver:
Audio: PASS/FAIL
Visual: PASS/FAIL
Known failures:
```

Only then may `docs/GAMEMAKER_VERIFICATION.md` change a `NOT RUN` row to a real result.

