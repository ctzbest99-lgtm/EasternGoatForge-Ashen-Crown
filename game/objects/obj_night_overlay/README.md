# obj_night_overlay

Chapter 3 heist-night lighting for the seized warehouse. `scr_build_warehouse()` creates one instance; do not place it by hand in other rooms.

Events: Create, Draw ▸ Draw GUI. No sprite.

## How it draws

Draw GUI renders a full-view dark wash (`dark_alpha` 0.72 of `dark_color`) onto a GUI-sized surface, then punches lantern pools back out with `bm_subtract`: a wide rim plus a tighter core around the player (offset 10 px up, so the light sits at chest height) and around the warehouse lantern tiles `[10,4]`, `[8,6]`, `[18,6]`, `[12,14]`. The surface is recreated if it is lost, and the blend mode is reset before the surface is drawn, so nothing after it inherits subtractive blending.

The camera transform is applied manually (`_sx` / `_sy` from the GUI-to-view ratio), which keeps the pools aligned at any window scale.

## Placeholder status

This is a PLACEHOLDER until Design lands a lighting pass (CHAPTER3_SCRIPT.md §5, heist night): the darkness colour, alpha, radii and lantern coordinates are first-pass values, not approved. Nothing here has been compiled or playtested in GameMaker.

Related: `obj_player` (the light follows it), `scr_build_warehouse()` (creates the instance), `game/rooms/ROOM_SETUP.md` (room notes).
