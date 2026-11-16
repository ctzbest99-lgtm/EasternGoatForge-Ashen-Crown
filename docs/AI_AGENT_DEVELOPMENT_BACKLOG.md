# AI Agent Development Backlog — ASHEN CROWN

**Last reconciled:** 2026-11-15  
**Updated 2026-11-16:** Acts I–IV are built and unplayed (Chapters 1–11, 31 rooms, 91 scripts), audio is wired through `scr_audio`, and Act V is approved in outline only. Items below that call any of that data-only, design-only or audio-absent are done — check `docs/CHANGELOG.md` and `docs/DEVELOPMENT_ROADMAP.md` for current state. Also prefer the targeted importers in `tools/` over re-running `gen_gamemaker.py` wholesale, which churns resource UUIDs.  
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
- Chapters 1–11: built in source/project data; README reports 31 rooms. They are not yet verified by an IDE playtest — `docs/PLAYTEST_RUNBOOK.md` is the order to check them in.
- Act V: outline and approvals only — no chapter script, dialogue, rooms, enemies or code.
- Acts VI–VIII: titles only.
- Bestiary: seen/defeated tracking and information pane exist; all 33 descriptions are placeholder prose. The monster sprite is not currently shown in the Bestiary UI, despite being part of the requested feature.
- Art: ten placeholder sprites remain, including Lyra's overworld and battle strips. Check `game/sprites/IMPORT.md` and `docs/ASSET_INVENTORY.md`.
- Audio: no authored music or sound effects yet.
- Controller support: not complete or verified; keyboard is the baseline.
- Runtime status: **the project has not been compiled or playtested in GameMaker**. CI/validator checks structure only.
- Open PR #1 is an old debug-menu change and must be reviewed against current code before any merge; do not merge it blindly.

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

#### P1.1 — Add monster sprites to the Bestiary
**Why:** The Bestiary currently has tracking and descriptive data but does not render the requested monster sprite.

Tasks:
- Inspect `game/objects/obj_adventure_menu/Draw_GUI.gml`, `game/scripts/scr_bestiary.gml`, and the enemy sprite/data mapping.
- Add a stable enemy-ID-to-sprite mapping; do not infer sprite names from arbitrary strings unless validated.
- Render the selected enemy's sprite in the Bestiary detail pane with correct scaling/origin and no UI overlap.
- Handle missing sprite mappings gracefully with a clear fallback.
- Keep list navigation, description, level/role, weakness, area, and stats readable.
- Update asset/docs and add manual test cases.

Acceptance:
- Every enemy with an available sprite shows the correct one.
- Missing art never crashes or draws an unrelated sprite.
- Selection changes update both details and sprite.
- Test with mouse not assumed; keyboard navigation works.

#### P1.2 — Replace Lyra placeholder art
Tasks:
- Identify the exact placeholder sprite resources and their required frame dimensions/origins/fps from `game/sprites/IMPORT.md`.
- Create/import approved overworld and battle strips without changing gameplay data.
- Regenerate the GameMaker project and update the asset inventory.

Acceptance:
- No flat-color placeholder remains for Lyra in the relevant game states.
- Idle/walk/battle animations use the correct frames and origins.
- Structural validation passes; runtime appearance is manually checked when IDE available.

#### P1.3 — Audit remaining placeholder art and animation gaps
Tasks:
- Review the ten `*_placeholder` sprites, missing Fallen Knight overworld art, Guard pose, and known animation differences in `docs/ASSET_INVENTORY.md`.
- Separate required player-facing assets from acceptable temporary placeholders.
- Prioritize missing assets by visibility and gameplay impact.

Acceptance:
- Asset inventory accurately records each asset's status, dimensions, source/creator, license, import settings, and test status.
- No asset is marked complete without an actual file and verification.

#### P1.4 — Reconcile Bestiary descriptions and enemy data
Tasks:
- Review all 33 placeholder descriptions against approved chapter scripts and enemy data.
- Replace placeholder prose only where canon/encounter facts are supported.
- Flag missing lore rather than inventing it.

Acceptance:
- No description contradicts the story scripts or enemy data.
- Unresolved lore remains explicitly marked for owner review.

#### P1.5 — Verify save/load, migration, and party edge cases
Tasks:
- Test schema v3 and v1/v2 migration behavior.
- Verify only save crystals in church/tavern interiors open the slot panel.
- Test full party, reserve swap, defeated party, missing/corrupt slots, and title-screen Continue.
- Preserve the save-only-at-crystal rule.

Acceptance:
- No save corruption, lost party state, invalid room spawn, or save access outside approved rooms.
- Migration behavior is documented and repeatable.

### P2 — Input and accessibility

#### P2.1 — Centralize input handling
Tasks:
- Inspect `game/scripts/scr_input.gml` and all direct keyboard reads, especially player movement and menu/battle objects.
- Introduce a shared action layer for up/down/left/right/confirm/cancel/menu.
- Preserve current keyboard defaults (arrows; Z/Enter/Space confirm; X/Backspace cancel; I/Tab menu where currently used).
- Avoid changing gameplay semantics while replacing direct reads.

Acceptance:
- All game systems use the shared action layer.
- Existing keyboard controls still work.
- No double-trigger/repeat regression in dialogue, menus, battles, or interactions.

#### P2.2 — Add gamepad/controller support
Tasks:
- Support D-pad and analog movement with normalized diagonal speed.
- Support confirm/cancel, menu open/close, party/menu navigation, and battle commands.
- Handle controller disconnect/reconnect and controller index changes safely.
- Show or document the active control scheme; do not hard-code Xbox-only assumptions.

Acceptance:
- Keyboard and controller can be used interchangeably.
- No stuck input or duplicate actions on reconnect.
- Manual test plan includes controller cases.

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

#### P4.1 — Build Chapter 5 from existing enemy/encounter data
Tasks:
- Read approved Chapter 5 design/script sources and existing enemy/encounter tables.
- Create rooms, markers, map data, dialogue, encounter flow, and boss sequence in small slices.
- Reuse existing room/story patterns without copying stale assumptions.
- Do not invent story beats where the source material is incomplete.

Acceptance:
- Chapter 5 can be entered, completed, and exited without softlocks.
- All encounters, rewards, flags, and save return paths work.
- Chapter 5 tests and docs are updated.

#### P4.2 — Resolve stub overworld entrances as content becomes available
Tasks:
- Audit the 12 reported `status: "stub"` entrances and their destination names.
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

- Acts III and IV are fully built and unplayed — Chapters 6–11, the Blackwood and barrow rooms, dialogue data, story scripts and quest stages; Chapters 7–8's decisions still await individual approval. Act V is approved in outline only (`docs/story/ACT5_OUTLINE.md`), with no chapter written and nothing built. See `docs/DECISIONS_AND_OPEN_QUESTIONS.md`.

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
- ~~README counts and titles~~ — resolved: both READMEs now report the current 31 rooms / 91 scripts / 843 sprites and the Act I–IV build state.
- ~~Pixel interpolation disagreement~~ — resolved: every platform option file has `interpolate_pixels` set to `false`, and `gen_gamemaker.py` now normalises it (and the product name) on regeneration.
- Battle-presentation documentation is inconsistent: `docs/story/STORY_BIBLE.md` still calls it open and `docs/DECISIONS_AND_OPEN_QUESTIONS.md` records the dedicated-room prototype assumption. The owner-approved direction from prior planning is hybrid presentation varying by encounter; reconcile the decision log, GDD, story bible and implementation without changing battle behavior silently.
- The README is the current project snapshot; keep its status synchronized when build/content state changes.
- ~~Story Bible provenance cites a missing `MASTER_GDD.txt`~~ — resolved: the header now names the chapter scripts and act outlines as its sources and states plainly that the old master document is not in the repository.
- The old open PR #1 contains a debug-menu change and may reference outdated objects. Review its diff against current source before deciding whether to close, update, or merge it.
- The old generic Windows branding values noted in the audit should be replaced before release packaging.
- Pixel interpolation settings must be checked against the actual GameMaker options and README; the current project README says interpolation is disabled. Keep generated project options consistent.

## Recommended first task

Start with **P0.1 — Open and compile the current GameMaker project**. Do not begin controller support, audio, or new chapter content until the IDE build result is known. If you cannot access GameMaker, perform the repository validator and source-level audit, clearly mark the IDE checks **NOT RUN**, and ask the owner to run the supplied manual steps.
