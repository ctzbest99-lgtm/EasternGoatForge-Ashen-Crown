# obj_encounter_zone

Rectangle that marks a random-encounter area. No collision with the player; not a story trigger.

- Sprite: `spr_encounter_zone_placeholder` (32×32, Top Left origin, semi-transparent, e.g. yellow). Stretch the instance in the Room Editor to cover the wild area. A sprite is required so the collision mask (used by `instance_place`) matches the stretched rectangle.
- Parent: none. Do **not** parent to `obj_solid`.
- Events: Create only.
- Visible follows `DEBUG_SHOW_TRIGGERS`.

## Table
Default `table_id` is `"zone01_path"` (Bandit weight 3, Fallen Knight weight 1). Override in Instance Creation Code:

```
table_id = "zone01_path";
```

or supply a table directly:

```
table_id = "";
enemy_table = [
    { enemy_id: "bandit", weight: 3 },
    { enemy_id: "fallen_knight", weight: 1 }
];
```

`enemy_id` must exist in `scr_get_enemy_data()`. If several zones overlap, the first instance the player’s mask touches is used.

## Safe areas
Do not cover towns, interiors, or the stand-in respawn/town pocket in `rm_overworld`. Rooms with no zone and no room table in `scr_get_room_encounter_table()` have no random encounters. Keep `obj_encounter_trigger` for fixed boss/story fights.
