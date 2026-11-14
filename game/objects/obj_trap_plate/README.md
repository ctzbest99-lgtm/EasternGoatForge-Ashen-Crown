# obj_trap_plate

Overworld / dungeon pressure plate. Used for the Watchtower Basement trap hall (`trap_field` with `plate_tiles` / `safe_tiles`) and the two grounds plates in `rm_old_watchtower`.

- Sprite: 16×16 Top Left (e.g. `spr_encounter_trigger_placeholder`). A larger placeholder is scaled to one tile.
- Parent: **none**. Not solid. Visible follows `DEBUG_SHOW_TRIGGERS`.
- Events: Create, Step.

## Safe path
Only `plate_tiles` are spawned. The sigil stones listed in `safe_tiles` have no plate, so they are the safe winding path across the hall. Design has already checked that a plate-free route exists.

## Effect (prototype, pending tuning)
On first step (after the player has been seen off the tile):

1. Play `WT_TRAP_01` ("A pressure plate clicks underfoot—") or the marker's `lines`.
2. Deal `damage_pct` (default 10) percent of each **living active** party member's max HP, minimum 1, never below 1 HP (a plate cannot KO anyone).
3. Knock the player 8 pixels back opposite their facing, if that pixel is free.

The plate then stays sprung for the rest of the session and will not fire again. The three pre-sprung spike tiles in the hall are decoration only (not in `plate_tiles`).
