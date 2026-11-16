# Development Roadmap

This roadmap reflects the repository state recorded on **2026-11-15**. The project is no longer an empty starter: it has a substantial GameMaker project and Chapters 1–4 implemented in source/project data. The next priority is runtime verification, not rebuilding the project shell.

For actionable, ordered tasks and acceptance criteria, see [AI Agent Development Backlog](AI_AGENT_DEVELOPMENT_BACKLOG.md).

## Current status

| Area | State |
|---|---|
| GameMaker project shell | Generated project exists at `gamemaker/AshenCrown.yyp`; structural validation exists. Runtime compilation/playtesting has **not** been performed. |
| Top-down exploration | Implemented in source/project data; requires IDE runtime verification. |
| Dialogue and interactions | Implemented for current chapters; requires manual regression testing. |
| Turn-based battle | Implemented beyond prototype: skills, statuses, weaknesses, boss phases, Escape, defeat/respawn; requires runtime/balance testing. |
| Party and progression | Five-person roster data, four active plus reserve, XP/levels, equipment, inventory, gold and shops are implemented; some values remain placeholders/open. |
| Menus and saves | Adventure menu includes Items, Equip, Party Order, Status and Bestiary. Versioned save schema v3. Save/load only at crystals inside town churches/taverns. |
| Chapters 1–4 | Built in the project; README reports 20 rooms. Content has not been runtime playtested. |
| Chapter 5 | Enemy stats, encounter tables and boss groups exist; rooms, markers and dialogue are not implemented. |
| Act III onward | Design only. |
| Art | Large sprite inventory exists; ten placeholder sprites remain, including Lyra's overworld and battle strips. See `game/sprites/IMPORT.md` and `docs/ASSET_INVENTORY.md`. |
| Bestiary | Tracking and information pane exist; descriptions are placeholder prose and monster-sprite display is still a required follow-up. |
| Audio | No authored music or sound effects are currently included. |
| Controller support | Not complete/verified; keyboard input is the current baseline. |
| Platform readiness | Windows/macOS/Linux project options exist. Xbox is not a configured target in the current project; console release requires separate feasibility/platform work. |

## Development phases

1. **P0 — Build and runtime verification**
   - Open `gamemaker/AshenCrown.yyp` in GameMaker IDE 2023.1 or newer (project format is 2024.x).
   - Run `python3 validate_gamemaker.py` from the repository root.
   - Press F5, compile, and record the exact IDE/runtime version and any errors.
   - Complete the smoke tests in `docs/TEST_PLAN.md`; fix blockers before feature work.
2. **P1 — Finish and verify existing systems**
   - Add the requested monster sprite to each Bestiary entry and verify list/detail navigation.
   - Replace placeholder Lyra art and review remaining placeholder sprites.
   - Check all party, menu, save migration, battle, map-transition, and story-event edge cases.
   - Reconcile asset inventory and implementation docs with the actual project.
3. **P2 — Input and accessibility**
   - Add a centralized input abstraction for keyboard and gamepad.
   - Support D-pad and analog movement, confirm/cancel, menu navigation, battle commands, and disconnect/reconnect behavior.
   - Keep keyboard controls functional and remappable/documented where feasible.
4. **P3 — Audio and presentation**
   - Add original or properly licensed music, battle/field UI sounds, interaction sounds, and environmental ambience.
   - Document source, license, import settings, and implementation for every audio asset.
5. **P4 — Complete the next story content**
   - Build Chapter 5 rooms, markers, dialogue, encounters, and boss flow.
   - Then plan and implement Act III onward in small approved chapter-sized increments.
   - Resolve the 12 currently reported stub overworld entrances only when their destination content is ready; do not point players into nonexistent rooms.
6. **P5 — Release/platform preparation**
   - Stabilize Windows first, then verify macOS/Linux builds if those remain targets.
   - Treat Xbox as a separate feasibility and platform-integration effort; do not claim Xbox support until the required export access, controller behavior, save integration, and certification work are verified.
   - Complete performance, accessibility, save compatibility, regression, and release packaging checks.

## Definition of done for each task

- One coherent change per branch/PR where practical.
- GML and project resources are consistent with the generator/source-of-truth workflow.
- Relevant docs, asset inventory, changelog, and manual tests are updated.
- Static validation passes.
- GameMaker IDE compile/runtime checks are recorded when available; otherwise mark them explicitly **NOT RUN**.
- No task is called complete merely because files were generated or CI passed.
