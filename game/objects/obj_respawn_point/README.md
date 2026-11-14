# obj_respawn_point

Optional marker for where the party wakes up after a defeat. No collision; the player does not interact with it.

- Sprite: optional `spr_respawn_point_placeholder` (any small colour, e.g. 16×16 or 32×32; Top Left or Centre origin). Visibility follows `DEBUG_SHOW_TRIGGERS`. A sprite is only needed so you can see the marker while laying out the room.
- Collision mask: does not matter (this object is not in the player's collision list).
- Events: Create only.
- Place **one** instance in `TOWN_RESPAWN_ROOM` in open space. If several are placed, the first instance is used.
- Optional Instance Creation Code: `facing_x = 0; facing_y = 1;` (defaults face down).

Until a town room exists, place the marker in `rm_overworld` at the stand-in wake-up spot. When the town room is built, change `#macro TOWN_RESPAWN_ROOM` in `scr_game_constants` and move (or place) this marker there. The respawn room must also contain `obj_player`.
