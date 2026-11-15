# obj_save_point

A 16×24 ember-crowned crystal (`spr_save_point_idle_strip8`, origin (8, 23)) that stands in the aisle. The map builder spawns four: Greyhaven Chapel (`chapel_save`), Greyhaven Tavern (`tavern_save`), the Bent Post in Wrenfield (`bent_post_save`, tile 4,9) and the Salt Lamp in Valemere (`salt_lamp_save`, tile 4,6). The Greyhaven tiles are still an open design decision; the two new ones are by the west wall of each tavern and were audited against their room builders on 2026-11-15 (open collision-0 floor with no decor, reachable from the door, and clear in both the Bent Post's closed and open states).

**Parent:** `obj_interactable`. Events: Create, Step (inherits y-sort, then plays the activate clip).

Saving is only allowed inside a town's church or tavern — the room the crystal stands in (owner decision 2026-11-15, `scr_save_towns()` / `scr_save_room_allows_save()` / `scr_save_allowed_here()` in `scr_save.gml`). All four shipped crystals stand in such a room, so all four work; a crystal placed anywhere else (a road, a dungeon, a town square) shows "No shrine, no hearth. Save only at a crystal inside a town's church or tavern." instead of the slot panel.

On confirm, swap to `spr_save_point_activate_strip8` (origin (16, 39), 12 fps, once). At the last frame, open `obj_save_menu` and return to the idle loop (8 fps). The two origins keep the plinth aligned at the same x/y.

If the strips are missing, the interactable placeholder is used and the menu opens immediately. A DEBUG F5 "save anywhere" key exists on `obj_game_controller` but is off by default (`DEBUG_SAVE_ANYWHERE`).
