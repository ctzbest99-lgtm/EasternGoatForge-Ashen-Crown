# AI Agent Development Backlog — ASHEN CROWN

**Last reconciled:** 2026-11-18

**Updated 2026-11-18:** the gear, merchant and Ashlands work merged to `main` in `8e412618` (PR #31). Acts I–IV are built and unplayed (Chapters 1–11 plus the three standalone Ashlands rooms, 34 rooms, 95 scripts), audio is wired through `scr_audio`, and Act V's Chapters 12–14 are approved as story and its enemy batch is in data; no Act V room or dialogue is built. Items below that call any of that data-only, design-only or audio-absent are done — check `docs/CHANGELOG.md` and `docs/DEVELOPMENT_ROADMAP.md` for current state. Also prefer the targeted importers in `tools/` over re-running `gen_gamemaker.py` wholesale, which churns resource UUIDs.
**Purpose:** single actionable handoff for Codex or another coding agent. Work top-to-bottom, one item at a time.  
**Project:** GameMaker / GML. Open `gamemaker/AshenCrown.yyp`; edit human-readable source in `game/` unless a task specifically concerns project metadata.

## Rules for the agent

1. Read `README.md`, `docs/DECISIONS_AND_OPEN_QUESTIONS.md`, `docs/TEST_PLAN.md`, and this file before coding.
2. Chapters 1–4 and substantial game systems already exist. Do not recreate the project as a starter template.
3. Use `game/` as the source of truth for scripts, sprites, and map data; regenerate the project with `python3 gen_gamemaker.py` when required.
4. Make one small, coherent change per task. Do not silently bundle unrelated features.
5. Preserve approved story and gameplay decisions. Ask before changing major mechanics, recruitment, save rules, progression, or canon.
6. Clearly distinguish implemented, placeholder, designed-only, and unverified content.
7. Run `python3 validate_gamemaker.py` after generated-project changes. A passing structural validator is not a GameMaker compile.
8. Never claim IDE compilation or playtesting unless actually performed. Record unavailable tests as **NOT RUN**.
9. Update this backlog, relevant documentation, changelog, asset inventory, and manual tests as each task is completed.
10. Report files changed, tests run/results, tests not run, remaining risks, and the next single task.

## Current project truth

- Game: dark medieval fantasy, classic top-down JRPG exploration inspired by the original Final Fantasy (1987), not side-view.
- Engine: GameMaker / GML. Project file: `gamemaker/AshenCrown.yyp`.
- Core combat: menu-driven turn-based battles; four active party members plus one reserve; no automatic enemy level scaling by default.
- Adventure menu: Items, Equip, Party Order, Status, Bestiary.
- Save/load: only at save crystals inside a town church or tavern. No save-anywhere and no Save row in the field menu.
- Chapters 1–11 plus `rm_ashlands_breach`, `rm_ashlands_ruins` and `rm_ashlands_depths`: built, merged to `main` in `8e412618` (PR #31), and README reports 34 rooms. They are not yet verified by an IDE playtest — `docs/PLAYTEST_RUNBOOK.md` is the order to check them in.
- Act V: Chapters 12–14 approved as story; seven enemies, `drowned_coast` and three boss groups are data and simulated; no rooms, dialogue, quest rows or story code.
- Acts VI–VIII: titles only. The Ashlands (Act VII) has three standalone blockout rooms (`rm_ashlands_breach`, `rm_ashlands_ruins`, `rm_ashlands_depths`) but no chapter, quest, enemy or tileset of its own.
- Bestiary: 43 entries with seen/defeated tracking, an information pane and a monster illustration (`scr_bestiary_draw_illustration`; black silhouette until seen, `?` plate when an enemy has no art). The 43 descriptions were canon-reviewed on 2026-11-18: they use established facts and observable detail, keep **Architects** in UI text, and fit the 72-character pane. Act IV rows describe the built Act IV text, which remains **PROPOSED** as story.
- Art: party kits, marker sprites and the Alden/Nim/Derry, Berrin, ward-sentinel, burner and Lost One sets are in repo; every enemy kind with battle art now has a 16×24 overworld set (2026-11-19), the Blackwood tileset is a placeholder and the Ashlands has no tileset of its own. Vell and Nessa now have dedicated sets (2026-11-18). Check `game/sprites/IMPORT.md` and `docs/ASSET_INVENTORY.md`.
- Audio: 29 authored resources (3 music loops, 6 ambience beds, 20 effects) play through `scr_audio`; ambience is room-mapped, and the four effects once listed as unhooked are wired. `step` is deliberately unused. Actual listening in GameMaker remains **NOT RUN**.
- Controller support: implemented in `scr_input` (keyboard + Xbox-style pad, D-pad/left stick, A/B/Start/LB/RB, dead zone, disconnect/reconnect). Physical-controller testing remains **NOT RUN**; see `docs/CONTROLLER_SUPPORT.md`.
- Open PR #25 (“Add initial controller support”) is still open and unmerged; its incomplete approach was rebuilt on `main` in `scr_input`, so do not merge it blindly. PR #30 is closed and unmerged.
- Runtime status: **the project has not been compiled or playtested in GameMaker**. CI/validator checks structure only.
- Open PRs #1 (debug menu), #22 (validator hardening and source sync) and #25 (controller support) all predate current `main` and must be reviewed and rebuilt against it before any merge; do not merge them blindly. PR #31 (gear, merchants, Ashlands rooms) is merged. Controller support has since been rebuilt on `main`; see `docs/CONTROLLER_SUPPORT.md`.

## Prioritized work

### P0 — Establish a known-good build

#### P0.1 — Open and compile the current GameMaker project
**Why:** Every feature depends on knowing whether the generated project opens and compiles in the actual IDE.

Tasks:
- Open `gamemaker/AshenCrown.yyp` in GameMaker IDE 2023.1 or newer (project format is 2024.x).
- Record exact IDE/runtime version and target platform.
- Run the project (F5) and capture all compile/runtime errors.
- Fix only confirmed blockers; prefer source edits in `game/`, then regenerate.
- Run `python3 validate_gamemaker.py` from the repository root.

Acceptance:
- Project opens without resource/import errors.
- Project compiles and boots to the title screen.
- Validator passes.
- IDE/runtime version and test result are recorded in `docs/TEST_PLAN.md` and changelog.
- If the IDE is unavailable, mark compile/run **NOT RUN**; do not call the build verified.

#### P0.2 — Complete a smoke playthrough of existing Chapters 1–4
**Why:** Existing content is substantial but unverified in runtime.

Tasks:
- Follow `docs/TEST_PLAN.md` from title/new game through movement, dialogue, battles, rewards, menus, shops, save/load, defeat/respawn, and chapter transitions.
- Test a fresh save and a migrated older save if fixtures are available.
- Record reproducible failures with room, steps, expected result, actual result, and logs.

Acceptance:
- Every test is marked pass/fail/not run with evidence/notes.
- Critical progression blockers and softlocks are fixed before adding new content.

### P1 — Finish existing systems and presentation

#### P1.1 — Add monster sprites to the Bestiary — **DONE (merged 2026-11-17)**
`scr_bestiary_draw_illustration` now draws the selected entry's battle idle in the detail pane, with a contact shadow, a black silhouette until the enemy is seen and a `?` plate when it has no art. The remaining check is visual: Phase 8 of `docs/PLAYTEST_RUNBOOK.md` in the IDE.

#### P1.2 — Replace Lyra placeholder art — **DONE (merged 2026-11-17)**
`docs/ASSET_INVENTORY.md` records a generated party kit for Lyra: 16×24 four-direction idle/walk, 32×48 idle/walk/hurt/defend, 48×48 attack/death and three portraits, wired without gameplay changes. Runtime appearance still needs an IDE check.

#### P1.3 — Audit remaining placeholder art and animation gaps
**Done in this pass:** Kael has a Guard battle pose (`spr_hero_defend_strip3`), Blind/Sleep have dedicated icons (`spr_ui_status_extra_strip2`), and Ether/Chain Mail have enabled+disabled item icons. Remaining tasks:
- Review the current gaps in `docs/ASSET_INVENTORY.md`: the placeholder Blackwood tileset, the missing Ashlands tileset, and any animation differences.
- Separate required player-facing assets from acceptable temporary placeholders.
- Prioritize missing assets by visibility and gameplay impact.

Acceptance:
- Asset inventory accurately records each asset's status, dimensions, source/creator, license, import settings, and test status.
- No asset is marked complete without an actual file and verification.

#### P1.4 — Reconcile Bestiary descriptions and enemy data
Tasks:
- Review all 43 placeholder descriptions against approved chapter scripts and enemy data.
- Replace placeholder prose only where canon/encounter facts are supported.
- Flag missing lore rather than inventing it.

Acceptance:
- No description contradicts the story scripts or enemy data.
- Unresolved lore remains explicitly marked for owner review.

#### P1.5 — Verify save/load, migration, and party edge cases
Tasks:
- Test schema v4 and older-save migration behavior.
- Verify only save crystals in church/tavern interiors open the slot panel.
- Test full party, reserve swap, defeated party, missing/corrupt slots, and title-screen Continue.
- Preserve the save-only-at-crystal rule.

Acceptance:
- No save corruption, lost party state, invalid room spawn, or save access outside approved rooms.
- Migration behavior is documented and repeatable.

### P2 — Input and accessibility

#### P2.1 — Centralize input handling — **DONE**
`scr_input` now owns all gameplay input; `obj_player`, title, menus, dialogue and battle call the action functions. The only direct keyboard read left is the F5 debug shortcut. Tasks kept for the record:
- Inspect `game/scripts/scr_input.gml` and all direct keyboard reads, especially player movement and menu/battle objects.
- Introduce a shared action layer for up/down/left/right/confirm/cancel/menu.
- Preserve current keyboard defaults (arrows; Z/Enter/Space confirm; X/Backspace cancel; I/Tab menu where currently used).
- Avoid changing gameplay semantics while replacing direct reads.

Acceptance:
- All game systems use the shared action layer.
- Existing keyboard controls still work.
- No double-trigger/repeat regression in dialogue, menus, battles, or interactions.

#### P2.2 — Add gamepad/controller support — **DONE in source; physical test NOT RUN**
**Status:** the incomplete PR #25 approach was rebuilt on `main` in `scr_input.gml`: cached gamepad selection, Xbox-style A/B/Start/LB/RB, D-pad and left stick, radial dead zone, normalized diagonals, pressed/held/released actions, disconnect/reconnect/index-change handling, menu `opened_frame` guards and close-frame input blocks. It has not been compiled or tested with a physical pad; `docs/CONTROLLER_SUPPORT.md` is the checklist.

Acceptance met in source: keyboard and controller share one action layer; no stuck input is possible after disconnect; the manual test plan includes controller cases. Runtime acceptance is still **NOT RUN**.

### P3 — Audio and polish

#### P3.1 — Establish audio asset standards and add first pass
**Partly done (2026-11-16):** audio is imported and wired (`scr_audio`, `docs/AUDIO.md`), and the title screen's Options entry now adjusts Music / Ambience / SFX and Mute and saves them to `ashen_settings.ini`. Still missing: an in-game entry, loudness/loop standards for future assets, and any in-engine listen. See `docs/DECISIONS_AND_OPEN_QUESTIONS.md` §"Options screen and saved audio settings".
Tasks:
- Define music/SFX naming, format, loudness expectations, loop points, and import settings.
- Add original or properly licensed title/field/battle music and core UI/interaction/battle SFX.
- Record creator/source and license for every asset.
- Add volume settings if appropriate to existing architecture; do not invent a settings system without inspecting current menus first.

Acceptance:
- No unlicensed audio is included.
- Audio does not restart unexpectedly on room transitions or stack uncontrollably.
- Music/SFX can be adjusted or muted if settings support is implemented.

#### P3.2 — UI, readability, and performance pass
Tasks:
- Check text clipping, menu focus, sprite scaling, transitions, camera boundaries, and texture-page behavior.
- Test target resolutions and window/fullscreen behavior.
- Fix only observed issues and document test coverage.

Acceptance:
- All player-facing text and menu elements are readable and unclipped at supported resolutions.
- No severe frame drops or resource warnings during normal play.

### P4 — Content completion

#### P4.1 — Build Act V — The Fallen Knight (Chapters 12–14) — **next content**
**Why:** Chapter 5 and all of Acts I–IV are built. Act V is the only act with approved decisions and an outline (`docs/story/ACT5_OUTLINE.md`), and its four rooms already exist as stub names.

**Status:** `CHAPTER12_SCRIPT.md` (2026-11-17), `CHAPTER13_SCRIPT.md` and `CHAPTER14_SCRIPT.md` (2026-11-18) are all approved as story. The seven-enemy batch, `drowned_coast` table and three boss groups are data and simulated with `--act5`. No room, dialogue or quest row is built.

Tasks:
- All three chapter scripts are approved, and `PARTY_MAX_LEVEL` is 27 (2026-11-18) with the XP curve landing 24–26 under it; the rooms are next.
- Then build `rm_saltreach`, `rm_saltreach_pier`, `rm_flooded_ruins` and `rm_shipwreck` with their markers, encounters, boss, quest stages and dialogue.
- Keep the approved region order and the knight's unnamed, yielding rules intact.

Acceptance:
- The four rooms can be entered, completed and exited without softlocks.
- All encounters, rewards, flags and return paths work; validator and chapter audit pass.

#### P4.2 — Resolve stub overworld entrances as content becomes available
Tasks:
- Audit the 8 remaining `status: "stub"` entrances: Ironspine mine and ruins, Rimehold, frozen ruins, Saltreach, Saltreach pier, flooded ruins and shipwreck. The Blackwood doors and deep shrine now point at built rooms and are marked `built`.
- Keep unfinished exits clearly blocked/labelled until destinations exist.
- Implement each destination only when its design and story content are approved.

Acceptance:
- No active entrance sends the player to a nonexistent room.
- Completed destinations have valid spawn markers and return routes.

#### P4.3 — Plan and implement Act III onward
Tasks:
- Use the approved eight-act story structure and current story canon as constraints.
- Develop one act/chapter at a time with explicit story, map, encounter, party, and asset requirements.
- Keep Alden Marr's locked ending, **Ending C — The Last Usurper**, intact: he begins seeking to free serfs and rebuild Eldoria, grows into a would-be ruler, claims the throne after King Aldric IV's defeat, and must be stopped by Kael and Taren.
- Do not treat unimplemented narrative plans as shipped game content.

- Acts III and IV are fully built and unplayed — Chapters 6–11, the Blackwood and barrow rooms, dialogue data, story scripts and quest stages; Chapters 7–8's decisions still await individual approval. Act V's Chapters 12–14 are approved as story and its enemy batch is data (`docs/story/ACT5_OUTLINE.md`), with no room, dialogue or quest row built. See `docs/DECISIONS_AND_OPEN_QUESTIONS.md`.

Acceptance:
- Each act has owner-approved story beats, party recruitment/roles, locations, bosses, and implementation scope before coding.
- The story bible and chapter scripts agree.

### P5 — Platform and release preparation

#### P5.1 — Stabilize desktop targets
Tasks:
- Establish Windows as the first verified release target unless the owner changes that priority.
- Build and test Windows first; then verify macOS/Linux export behavior if still in scope.
- Check resolution, input, saves, performance, packaging, and clean-machine startup.

Acceptance:
- Repeatable packaged build and release checklist for each supported desktop target.
- No platform is listed as supported without a successful export and test.

#### P5.2 — Investigate console/Xbox feasibility separately
Tasks:
- Confirm GameMaker export access, platform partner requirements, SDK access, certification, controller UX, and platform save APIs.
- Replace local-file-only save assumptions with supported platform integration only after the target path is confirmed.
- Do not advertise Xbox support until the complete pipeline is tested.

Acceptance:
- Written feasibility decision and verified technical requirements.
- No unsupported console configuration or speculative platform claims.

## Known repository follow-ups

- `prompts/CODEX_MASTER_PROMPT.md`, `docs/GAME_DESIGN_DOCUMENT.md`, and `docs/DEVELOPMENT_ROADMAP.md` have been updated to point agents to this backlog and reflect current build state.
- ~~`docs/ASSET_INVENTORY.md` needs reconciliation against the current assets~~ — resolved: the Zone 1 tileset row now says 256×800, matching `game/tilesets/README.md` and the PNG. Keep verifying rows against the import table when art changes.
- ~~README counts and titles~~ — resolved: both READMEs report the current rooms, scripts and sprite counts and the Act I–IV build state.
- ~~Pixel interpolation disagreement~~ — resolved: every platform option file has `interpolate_pixels` set to `false`, and `gen_gamemaker.py` now normalises it (and the product name) on regeneration.
- Battle-presentation documentation is inconsistent: `docs/story/STORY_BIBLE.md` still calls it open and `docs/DECISIONS_AND_OPEN_QUESTIONS.md` records the dedicated-room prototype assumption. The owner-approved direction from prior planning is hybrid presentation varying by encounter; reconcile the decision log, GDD, story bible and implementation without changing battle behavior silently.
- The README is the current project snapshot; keep its status synchronized when build/content state changes.
- ~~Story Bible provenance cites a missing `MASTER_GDD.txt`~~ — resolved: the header now names the chapter scripts and act outlines as its sources and states plainly that the old master document is not in the repository.
- Open PRs #1 (debug menu), #22 (validator hardening and source sync) and #25 (controller support) all predate current `main` and may reference outdated objects. Review each diff against current source, rebuild or rebase it, and run the validator, chapter audit and IDE checks before deciding whether to close, update or merge.
- The old generic Windows branding values noted in the audit should be replaced before release packaging.
- Pixel interpolation settings must be checked against the actual GameMaker options and README; the current project README says interpolation is disabled. Keep generated project options consistent.

## Recommended first task

Start with **P0.1 — Open and compile the current GameMaker project**. Controller support, audio and the art pass are now source-complete, but none of them is runtime-verified; the IDE build result is still the gate. If you cannot access GameMaker, perform the repository validator and source-level audit, clearly mark the IDE checks **NOT RUN**, and ask the owner to run the supplied manual steps.
