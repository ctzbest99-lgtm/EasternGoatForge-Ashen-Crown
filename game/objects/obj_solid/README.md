# obj_solid

Blocking collision object. No events and no code.

- Sprite: `spr_solid_placeholder` (any solid-colour square, e.g. 32×32; tile size is still undecided).
- Collision mask: full image rectangle.
- Visible: on while prototyping (turn off later if walls are drawn by a tile layer instead).
- Stretch instances in the Room Editor to make long walls.

obj_player collides with obj_solid and all of its children (obj_interactable uses it as parent),
plus an optional tile layer named `Collision` (see game/rooms/ROOM_SETUP.md).
