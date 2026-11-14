# obj_save_point

A 16×24 ember-crowned crystal (`spr_save_point_idle_strip8`, origin (8, 23)) that stands in the aisle. The map builder spawns one in the Greyhaven chapel and one in the tavern (exact tiles are still an open decision).

**Parent:** `obj_interactable`. Events: Create, Step (inherits y-sort, then plays the activate clip).

On confirm, swap to `spr_save_point_activate_strip8` (origin (16, 39), 12 fps, once). At the last frame, open `obj_save_menu` and return to the idle loop (8 fps). The two origins keep the plinth aligned at the same x/y.

If the strips are missing, the interactable placeholder is used and the menu opens immediately. A DEBUG F5 "save anywhere" key exists on `obj_game_controller` but is off by default (`DEBUG_SAVE_ANYWHERE`).
