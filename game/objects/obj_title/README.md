# obj_title

Place one instance in `rm_title` (first in Room Order), with one `obj_game_controller` (persistent). Do not place `obj_player` here.

The room opens **directly on the main menu** — there is no press-any-key gate. The menu is drawn in Draw GUI so it works even when the room has no background layers.

## Menu

| Entry | Behaviour |
|---|---|
| New Game | Asks for confirmation (default **No**), then resets `global.game` once and starts at Greyhaven. Existing save files are not deleted; current unsaved progress is lost. |
| Continue | Loads the **newest valid** save by file write time. Disabled when there is no readable, compatible save. |
| Load Game | Opens the three save slots, with location, lead level/name, party, playtime and gold. Empty and damaged slots are shown safely and cannot crash the loader. |
| Settings | The audio settings the project actually supports: Music, Ambience, Sound effects and Mute, saved immediately to `ashen_settings.ini`. The fixed keyboard controls are shown as information, not as a fake remapping screen. |
| Exit Game | Calls `game_end()`. |

Keyboard: arrows move/change, `Z` / `Enter` / `Space` confirm, `X` / `Backspace` cancel. Gamepad: D-pad/left stick move/change, A confirms, B cancels (through the shared `scr_input` layer). Mouse: hover and click rows, save slots and confirmation buttons.

## New Game initial state

`scr_new_game_start()` performs exactly one reset. It sets Kael's starting weapon to `item_kaels_longsword` and leaves the bag empty (the canon does not define starting consumables). Flags and quests start empty; `GH_ARRIVAL` in `rm_overworld` starts `Q_MAIN_FIND_MIRA` and sets the opening flags. The title's `new_game_starting` guard prevents a double click from initializing twice.

## Save safety

`scr_save_any_valid()` counts only compatible saves for Continue. `scr_save_latest_slot()` uses `file_datetime()` and returns 0 when nothing is valid. `scr_save_slot_info()` marks missing, corrupt and incompatible files without throwing, and `scr_save_load()` re-checks compatibility before applying anything.

See `docs/MAIN_MENU.md` for the implementation and test record, and `game/rooms/ROOM_SETUP.md` section 0 for room setup.
