# GameMaker Starter Code

This folder contains illustrative GML snippets and setup notes, not a complete GameMaker project. No .yyp or IDE-generated .yy resources are included. Create resources in GameMaker and copy/adapt snippets into matching events/scripts.

Snippets are prototypes, not verified production code. Compile in the selected GameMaker version after adding each resource. Create missing objects/sprites/rooms or adjust code to match the actual project.

**Target syntax:** GameMaker 2023.1 or newer (structs, methods, `function` scripts, default arguments, arrays of objects/tilemaps in `place_meeting`). The final GameMaker version is still an open question.

## File layout
- `game/scripts/<name>.gml` → one **Script** asset named `<name>`; paste the whole file in.
- `game/objects/<obj>/<Event>.gml` → object `<obj>`, event `<Event>` (see the event table below).

## Resources (roadmap steps 2–3: exploration + battle prototype)

### Scripts (Asset Browser → Create → Script; name must match exactly)
| Script | Purpose |
|---|---|
| `scr_game_constants` | Macros (`OVERWORLD_ROOM`, `BATTLE_ROOM`, `TOWN_RESPAWN_ROOM` / `_X` / `_Y`, `DEFEAT_GOLD_LOSS_PCT`, `DEFEAT_XP_LOSS_PCT`, `DEBUG_SHOW_TRIGGERS`, `GUARD_DAMAGE_MULTIPLIER`) and `enum BATTLE_STATE` |
| `scr_game_state` | `global.game` struct, `scr_input_locked()`, `scr_input_block()` |
| `scr_input` | Prototype key mapping: confirm, cancel, menu up/down |
| `scr_dialogue` | `scr_dialogue_open(lines, speaker)` |
| `scr_encounter` | `scr_encounter_start()`, `scr_battle_finish()`, `scr_apply_defeat_penalty()`, `scr_apply_town_respawn()`, `scr_town_wake_up_dialogue()` (overworld ↔ battle hand-off) |
| `scr_battle_actors` | Actor structs, placeholder party, party helpers |
| `scr_battle_math` | Damage, HP clamp, Guard reduction (existing file, `scr_apply_guard` added) |
| `scr_enemy_database` | Bandit / Fallen Knight data (existing, unchanged) |

### Objects
| Object | Sprite | Flags | Events (file → IDE event) |
|---|---|---|---|
| `obj_game_controller` | none | **Persistent** ✔, Visible off | `Create.gml` → Create; `Begin_Step.gml` → Step ▸ Begin Step; `Room_Start.gml` → Other ▸ Room Start |
| `obj_player` | `spr_player_placeholder` | — | `Create.gml` → Create; `Step.gml` → Step ▸ Step |
| `obj_solid` | `spr_solid_placeholder` | — | none (see `obj_solid/README.md`) |
| `obj_interactable` | `spr_interactable_placeholder` | **Parent: `obj_solid`** | `Create.gml` → Create |
| `obj_dialogue_box` | none | — | `Create.gml` → Create; `Step.gml` → Step ▸ Step; `Draw_GUI.gml` → Draw ▸ Draw GUI; `Clean_Up.gml` → Clean Up |
| `obj_encounter_trigger` | `spr_encounter_trigger_placeholder` | No parent (must **not** be `obj_solid`) | `Create.gml` → Create; `Room_Start.gml` → Other ▸ Room Start; `Step.gml` → Step ▸ Step |
| `obj_battle_controller` | none | — | `Create.gml` → Create; `Step.gml` → Step ▸ Step; `Draw_GUI.gml` → Draw ▸ Draw GUI |
| `obj_respawn_point` | optional `spr_respawn_point_placeholder` | — | `Create.gml` → Create (see `obj_respawn_point/README.md`) |

`obj_dialogue_box` and `obj_battle_controller` draw only in Draw GUI. Adding a Draw GUI event does not disable default sprite drawing, but neither object has a sprite, so nothing else is drawn.

### Rooms
- `rm_overworld` (must be **first** in the Room Order) — see `game/rooms/ROOM_SETUP.md`.
- `rm_battle_test` — dedicated battle room.

## How the pieces fit
1. `obj_game_controller` (persistent) creates `global.game` and counts frames.
2. `obj_player` moves only when `scr_input_locked()` is false (no dialogue, battle, or transition, and not the frame right after one closes).
3. Facing an `obj_interactable` and pressing confirm calls its `interact()` method → `scr_dialogue_open()` → `obj_dialogue_box`. Closing the box blocks overworld input for one extra frame so the same key press cannot reopen it.
4. Walking onto an armed `obj_encounter_trigger` calls `scr_encounter_start()`: saves the return point, sets `battle_active`, goes to `rm_battle_test`.
5. `obj_battle_controller` runs the `BATTLE_STATE` machine: INTRO → ROUND_START → COMMAND_SELECT → PLAYER_ACTION → ENEMY_TURN → (ROUND_START | VICTORY | DEFEAT) → EXIT. Every message waits for a confirm press.
6. EXIT calls `scr_battle_finish()` once: remembers a victory by `encounter_id`, clears `battle_active`, sets `transition_active`. Victory and error return to the saved room; defeat restores party HP, deducts 50% of current gold and 10% of total XP (floored; percentages are macros, pending tuning), and goes to `TOWN_RESPAWN_ROOM`. `obj_game_controller`'s Room Start then either restores the pre-battle position/facing, or (on defeat) places the player at `obj_respawn_point` / `TOWN_RESPAWN_X,Y` and opens the wake-up dialogue, including the amounts lost.
7. A won trigger destroys itself on Room Start. A lost encounter is not cleared, so walking back onto that trigger starts the fight again.

## Default controls (prototype; final mapping is an open question)
- Move: arrow keys (diagonal normalized, as before).
- Confirm / interact / advance: **Z**, Enter, or Space.
- Cancel (battle: undo previous party member's command): **X** or Backspace.
- Battle menu: Up/Down.
