# obj_save_point

A save shrine in the world. The map builder spawns one in the Greyhaven chapel and one in the tavern (exact tiles are an open decision). Do not also hand-place them unless you are testing.

**Parent:** `obj_interactable` (solid). Events: Create (this file; inherits the parent's Step for y-sort).

Sprite lookup (first one that exists): `spr_menu_save_point`, `spr_save_point`, `spr_ui_save_point`, then `spr_interactable_placeholder`.

Facing the tile and pressing Z / Enter / Space opens `obj_save_menu`. A DEBUG F5 "save anywhere" key exists in `obj_game_controller` but is off by default (`DEBUG_SAVE_ANYWHERE`).
