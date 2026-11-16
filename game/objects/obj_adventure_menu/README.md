# obj_adventure_menu

Field-menu shell opened with **I** or **Tab** on the overworld (also closed with either key, X, or Backspace).

Rows:

| Row | What it does |
| --- | --- |
| Items | Hands off to `obj_inventory_menu` on the Items tab. |
| Equip | Hands off to `obj_inventory_menu` on the Equip tab. |
| Party Order | Front-line slots 1–4 plus the reserve row. Up/down picks a slot, left/right moves that member within the line-up, Z swaps the highlighted front-line slot with the reserve member. |
| Quests | The journal: every quest that has been started, with its current objective and `stage n / m`, and `done` once complete. Quests come from `scr_quest_data.gml`; state is the `quest_<QUEST_ID>` flag, so the page needs no save data of its own. |
| Status | Kael / Lyra / Caelan / Sera / Taren: class, role, level, XP to next level, HP, MP, ATK / DEF / MAG / MDF / SPD, equipment, skills. Left/right changes member. |
| Bestiary | All 33 enemies in `scr_enemy_database.gml`. Unmet enemies show as `???`; met ones show level, role, stats, weakness, region, description, and how many times they have been beaten. |
| Close | Closes the menu. |

Saving and loading are **not** in this menu: saving still happens at `obj_save_point`, and only inside a town's church or tavern (owner decision 2026-11-15, `scr_save_towns()` in `scr_save.gml`). `scr_menu_close_all()` closes this object with the other menus.

The Bestiary log lives in `global.game.bestiary` (`enemy_id -> { seen, defeated }`), is marked by `obj_battle_controller` at battle start and on each kill, and is saved from save schema v3 (`scr_bestiary.gml`, `scr_save.gml`). Enemy descriptions are PLACEHOLDER text written for this feature.

Layout macros (`MENU_ADV_*`) live in `scr_menu_layout.gml`; the panel art is the shared nine-slice UI used by the other field menus.

Quest definitions live in `scr_quest_data.gml`: `scr_quest_definitions()` (titles, kinds, stage ids and objective text), `scr_quest_started_list()` (journal rows, built from the flags) and `scr_quest_open_count()`. Main-quest objective text is the approved Act II wording; the two side-quest objectives are PLACEHOLDER journal text written for this page. Adding a quest is a data edit plus the existing `quest_<ID>` flag writes.
