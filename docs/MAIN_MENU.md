# Main menu — implementation record

**Status:** implemented in `obj_title` / `rm_title`; **not compiled or playtested in GameMaker** (the IDE is not available in this workspace). The checks below are static and repository-level, not an in-engine test.

## What the player sees

`rm_title` is first in Room Order and contains `obj_title` plus the persistent `obj_game_controller`. `obj_title` now starts in `mode = "menu"`; the old “Press any key” gate is gone.

```
ASHEN CROWN
  New Game
  Continue
  Load Game
  Settings
  Exit Game
```

The background, parallax layers, embers and logo are the existing title assets. Labels are drawn with the project font so the required wording (including **Load Game**, **Settings** and **Exit Game**) is exact; the old baked “Options/Quit” artwork is no longer used for the list. Continue is greyed out when no compatible save exists.

## Behaviour

### New Game

- Opens a confirmation panel. The default is **No**, so a stray confirm cannot start over.
- The panel says that unsaved progress is lost and that existing save files are kept. New Game does **not** delete `save1.sav`–`save3.sav`.
- On **Yes**, `scr_new_game_start()` runs one reset (`scr_game_state_reset()`), equips Kael's `item_kaels_longsword`, clears playtime and gold, and goes to `rm_overworld`.
- Starting inventory is empty by design: the approved Chapter 1 script defines no starting consumables. Starting quests/flags are empty until `GH_ARRIVAL` runs at the overworld spawn and starts `Q_MAIN_FIND_MIRA`.
- `new_game_starting` guards against double activation while the room change happens.

### Continue

- `scr_save_any_valid()` checks all three slots for a readable, schema-compatible save.
- `scr_save_latest_slot()` chooses the valid save with the newest numeric `saved_at_epoch` (ties go to the higher slot) and `scr_save_load()` loads it directly. Saves written before that field existed fall back to the highest valid slot, so an existing save library still gives Continue a target.
- The entry is disabled when no valid save exists. A present but corrupt/incompatible file does not enable it.
- A failed load leaves the title usable and prints a message; it never crashes.

### Load Game

- Opens the shared three-slot load panel (`scr_menu_draw_save_slots`).
- Each valid slot shows location, lead name/level, party icons, playtime and gold. Empty slots show “- Empty -”; corrupt/incompatible files show “Damaged save”.
- Keyboard skips to valid slots; mouse can select any slot and gets a clear message for empty/damaged slots.
- `scr_save_load()` performs its own compatibility check, so a bad file cannot partially apply a save.

### Settings

- Reuses `scr_options_rows()` / `scr_options_labels()` and the existing `scr_audio` gain/mute API.
- Music, Ambience, Sound effects adjust in 5% steps; Mute toggles. Every change writes `ashen_settings.ini` immediately via `scr_audio_settings_save()`.
- No fake remapping screen: key remapping is not implemented in the project, so the panel shows the fixed keyboard controls as information only. Controller navigation uses the existing standard gamepad mapping in `scr_input` (D-pad, A/B).

### Exit Game

- Calls `game_end()` on the current desktop target. This is the existing project behavior; it was not executed here.

## Input

- Keyboard: arrows, `Z` / `Enter` / `Space` confirm, `X` / `Backspace` cancel.
- Mouse: hover selects only when the pointer moves (so a resting cursor does not fight the keyboard); click activates menu rows, settings rows, save slots and confirmation buttons.
- Gamepad: D-pad moves/changes, A confirms, B cancels, using the shared controller-aware `scr_input` layer from current mainline. Left-stick menu navigation is not wired; the stick is used by overworld movement. No new controller system was added.

## Files changed

- `game/objects/obj_title/Create.gml`
- `game/objects/obj_title/Step.gml`
- `game/objects/obj_title/Draw_GUI.gml`
- `game/scripts/scr_save.gml` — `scr_save_any_valid()`, `scr_save_latest_slot()`, `saved_at_epoch` on new saves/slot info, `scr_new_game_start()`
- `game/scripts/scr_input.gml` — current mainline controller-aware input used by the menu
- `game/scripts/scr_options.gml` — shared audio settings model used by the title and Adventure menu
- `gamemaker/AshenCrown.yyp` — register the `scr_options` script resource
- `game/rooms/ROOM_SETUP.md` — title-room setup text
- generated mirrors under `gamemaker/objects/obj_title/`, `gamemaker/scripts/scr_save/`, `gamemaker/scripts/scr_input/` and `gamemaker/scripts/scr_options/`
- this document and `game/objects/obj_title/README.md`

No new sprites, objects, rooms or external dependencies. The settings work needed the existing `scr_options` model added as a real script resource. New saves add `saved_at_epoch`; older saves load unchanged and fall back to the highest valid slot for Continue.

## Tests performed (actual)

| Check | Result |
|---|---|
| `python3 validate_gamemaker.py` | `ALL CHECKS PASSED` (same four pre-existing Act I encounter-band warnings) |
| `python3 tools/audit_chapters.py` | `No wiring problems found` |
| `git diff --check` | clean |
| `rm_title` contains `obj_title` + `obj_game_controller`, no `obj_player` | verified by validator |
| `rm_title` is first and `rm_overworld` second in Room Order | verified by validator |
| source and generated GameMaker copies of the touched scripts/events are identical | checked with `cmp` |
| New Game / Continue / Load / Settings / Exit paths | **not executed**; no GameMaker runtime or IDE in this workspace |
| Missing/corrupt-save behaviour | code paths inspected; **not executed** against real `.sav` files in-engine |
| Keyboard, mouse, controller and window-close behaviour | **not executed**; controller navigation is wired through `scr_input`, but no gamepad was available to test |
| Visual layout at runtime | **not viewed in-engine** |

The test checklist in `docs/TEST_PLAN.md` (A2 and M17) remains the manual in-engine check. The static validator does not parse every GML expression, so a compile in the IDE is still required before calling this feature verified.
