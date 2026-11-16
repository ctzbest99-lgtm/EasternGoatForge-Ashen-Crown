# Codex Master Prompt — ASHEN CROWN

You are helping develop **ASHEN CROWN**, a dark medieval fantasy JRPG by Eastern Goat Forge, built with GameMaker and GML.

## Repository orientation

- The GameMaker project to open is `gamemaker/AshenCrown.yyp`.
- The human-readable source of truth for GML, sprites, and map data is in `game/`.
- `gen_gamemaker.py` generates the GameMaker project from the source tree.
- `validate_gamemaker.py` checks structural consistency between source and generated project.
- Read `README.md`, `docs/GAME_DESIGN_DOCUMENT.md`, `docs/DECISIONS_AND_OPEN_QUESTIONS.md`, and `docs/AI_AGENT_DEVELOPMENT_BACKLOG.md` before making changes.
- This is **not** an empty starter package. Chapters 1–4 and substantial game systems are already present. Chapter 5 is data-only; Act III onward is design-only.
- The repository status says the project has **not** been compiled or playtested in GameMaker. Never imply otherwise.

## Confirmed direction

- Classic top-down JRPG exploration inspired by the original Final Fantasy (1987), not side-view.
- Dark, atmospheric medieval fantasy with occasional lighthearted character moments.
- Classic menu-driven turn-based combat; four active party members and a reserve slot.
- Preparation matters: levels, equipment, party order, and tactics; no automatic enemy level scaling by default.
- The Adventure menu includes Items, Equip, Party Order, Status, and Bestiary.
- Save/load is deliberately restricted to save crystals inside a town church or tavern. Do not add save-anywhere or a Save row to the field menu without explicit approval.
- Zone 1 standard enemies include Bandit and Fallen Knight.
- Some story, stat, price, art, and encounter values are placeholders. Consult the decisions document and chapter scripts; do not promote placeholders to canon.

## Canon and open decisions

- Follow approved chapter scripts and `docs/DECISIONS_AND_OPEN_QUESTIONS.md`.
- Kael Varyn is the protagonist. His exact tragic backstory remains open in the repository decision log until the owner explicitly locks it.
- The five-person roster currently represented in data is Kael, Lyra, Caelan, Sera, and Taren Holt; some roster/stat/class details are still marked as assumptions or placeholders. Do not rewrite their story or recruitment order without checking the approved scripts.
- The owner has separately established Alden Marr's tragic antagonist ending as **Ending C — The Last Usurper**: Alden begins wanting to free the serfs and rebuild Eldoria, but his ambition grows until he claims the throne after King Aldric IV's defeat; Kael and Taren must stop him. Treat that ending as locked story direction, while checking the latest story source before inventing missing scene details.
- The owner approved an eight-act overall story structure. Do not invent details for unbuilt acts and present them as implemented content.

## Required workflow

1. Inspect the relevant GML, object events, data, generated resource, and related tests before editing.
2. Identify the actual source-of-truth file. Prefer editing `game/` and regenerating with `gen_gamemaker.py` when the change affects generated resources.
3. Summarize current behavior and the smallest proposed change before a broad or risky edit.
4. Implement **one small, coherent backlog item at a time**. Do not bundle unrelated features.
5. Preserve existing gameplay and story behavior unless the task explicitly changes it.
6. Ask before changing major story decisions, party recruitment, combat rules, save restrictions, progression formulas, or other owner decisions.
7. Use GML compatible with the project's actual GameMaker version. Do not invent fake `.yy` or `.yyp` metadata.
8. Prevent duplicate actions, invalid state transitions, negative/over-max HP, broken save migration, softlocks, and inaccessible map exits.
9. Update the relevant docs, changelog, asset inventory, and manual test plan with each implementation.
10. Run `python3 validate_gamemaker.py` after generated-project changes. Run any other repository checks relevant to the task.
11. Do not claim compilation, runtime verification, or playtesting unless actually run in GameMaker. If unavailable, report **NOT RUN** and provide exact manual steps.
12. Report: files changed, behavior added/fixed, tests run and results, tests not run, known risks, and the next single backlog item.

## Hard constraints

- Never replace existing source with a new starter template.
- Never overwrite or discard user work to make files match an outdated document.
- Never implement a placeholder value as approved canon without owner approval.
- Never close, merge, or rewrite an existing pull request without reviewing its diff and confirming it is still relevant.
- Prefer a focused branch and pull request for each meaningful task.
