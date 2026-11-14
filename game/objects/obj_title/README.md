# obj_title

Place one instance in `rm_title` (first in Room Order). Draws the parallax title / main menu in Draw GUI.

Do not place `obj_player` in `rm_title`. Place `obj_game_controller` here too (persistent) so `global.game` exists before New Game.

See `game/rooms/ROOM_SETUP.md` section 0 and `game/sprites/IMPORT.md` (Title).

Continue is enabled when any of `save1.sav`–`save3.sav` exists and opens a load panel (slot location, lead level, playtime, gold). New Game resets `global.game` and goes to `rm_overworld`.
