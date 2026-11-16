# ASHEN CROWN — Game Design Document

A dark medieval fantasy RPG by Eastern Goat Forge. The game follows Kael Varyn through a fractured realm shaped by the Ash Veil, the crown, and rebellion. The intended tone is dark and atmospheric, serious without excluding occasional lighthearted character moments.

## Core design pillars

- **Viewpoint:** classic top-down JRPG exploration inspired by the original Final Fantasy (1987); not side-view.
- **Combat:** classic menu-driven, turn-based battles with a four-character active party and a reserve member.
- **Preparation matters:** levels, equipment, party order, and tactics should matter. No automatic enemy level scaling by default.
- **Presentation:** readable pixel art, evocative medieval-fantasy locations, strong silhouettes, and clear UI.
- **Structure:** exploration, dialogue, encounters, rewards, equipment/progression, and route/story unlocks.

## Core loop

Explore → interact → encounter → choose commands → resolve turns → earn rewards → recover or upgrade → unlock the next route.

## Current implementation status (2026-11-15)

The repository contains a generated, ready-to-open GameMaker project at `gamemaker/AshenCrown.yyp`, generated from the human-readable source in `game/`.

- Chapters 1–4 have rooms, maps, story flow, and implemented systems/content.
- Chapter 5 currently has enemy and encounter data only; it does not yet have its rooms, markers, or dialogue.
- Act III onward remains design work.
- Core systems present include top-down exploration and interaction, dialogue, menu-driven turn-based combat, skills/statuses/weaknesses/boss phases, party progression, equipment, inventory, shops, save/load, and the Adventure menu (Items, Equip, Party Order, Status, Bestiary).
- Save/load is restricted to save crystals inside a town church or tavern. It is not a save-anywhere system.
- The Bestiary currently tracks seen/defeated enemies and displays information, but its descriptions are placeholder prose and the requested monster-sprite presentation still needs implementation/verification.
- There is no authored audio yet. Lyra's art still includes placeholders.
- **The project has not been compiled or playtested in the GameMaker IDE.** A ready-to-open project and passing structural validation do not prove runtime correctness.

For exact current gaps and task order, use `docs/AI_AGENT_DEVELOPMENT_BACKLOG.md` as the active implementation checklist, `docs/DEVELOPMENT_ROADMAP.md` for phase status, and `docs/TEST_PLAN.md` for manual verification.

## First playable milestone

The initial vertical-slice goal has been surpassed in code/content scope: the project now contains multiple chapters and core systems. The next milestone is not another broad feature expansion; it is to open the generated project in the target GameMaker IDE, compile it, and complete a controlled manual playtest. Fix runtime/build blockers before adding more systems.

## Canon and decision discipline

Use `docs/DECISIONS_AND_OPEN_QUESTIONS.md` and the approved chapter scripts as the decision record. Do not silently convert prototype values, placeholder descriptions, implementation shortcuts, or open questions into canon. Ask before changing story-critical decisions, save rules, battle rules, party membership, or progression assumptions.
