# Save-migration tests

The save schema is versioned (`SAVE_SCHEMA_VERSION` in `game/scripts/scr_game_constants.gml`). These tests cover the v1→v4 migration path that previously reset level-gained HP/MP and caster MAG.

## Fixtures

The canonical fixtures are in `game/datafiles/tests/saves/`:

| File | Schema | Actor | Purpose |
|---|---|---:|---|
| `v1_kael.json` | 1 | Kael | No MP/SPD/MDEF/base fields; exercises the v1 battle-default migration. |
| `v2_kael.json` | 2 | Kael | Has MP/SPD/MDEF but no v4 base maxima. |
| `v3_kael.json` | 3 | Kael | Adds the Bestiary log; still no v4 base maxima. |
| `v4_caelan.json` | 4 | Caelan | Explicit `base_max_hp` / `base_max_mp` / `base_magic`; no-regression case. |

They are sanitized, invented records. Do not replace them with a real player save. The copies under `gamemaker/datafiles/tests/saves/` are registered as GameMaker Included Files.

## CI contract test

```sh
python3 tests/save_migration_test.py
```

This checks fixture JSON, schema shape, actor/weapon/inventory expectations, `.yyp` registration, the Chapter 1 quest definition/stages and the story/dialogue wiring. It does **not** execute GML; it is the CI-safe half of the check.

## In-engine GML self-test

`scr_save_migration_test()` lives in `game/scripts/scr_save.gml` and calls the real
`scr_save_migrate()` → `scr_save_apply_member()` path for every fixture. It asserts:

- the payload reaches `SAVE_SCHEMA_VERSION`;
- `base_max_hp`, `base_max_mp` and `base_magic` match the expected saved values;
- `max_hp` / `max_mp` do not fall below the saved maxima;
- `level`, `xp`, the weapon slot and the three-potion inventory survive;
- pre-v4 saves use the saved final `attack` for `base_magic`.

To run it in a debug build:

1. Set `#macro DEBUG_SAVE_SELFTEST true` in `game/scripts/scr_game_constants.gml` (and mirror the change into `gamemaker/scripts/scr_game_constants/scr_game_constants.gml`, or run the sync tool).
2. Build and run in GameMaker.
3. Press **F6** in any room except the title or battle room. The result appears in the debug log and, when input is free, in a dialogue box.

You can also call `scr_save_migration_test()` directly from the IDE. A passing Python test is not a substitute for this run; the GML test requires the GameMaker runtime.

## Adding a schema version

1. Add a sanitized fixture next to the existing four.
2. Add its path and expected actor/weapon values to `scr_save_migration_test()`'s `_cases` array.
3. Add the fixture to the `check_fixtures()` and `check_gml_wiring()` cases in `tests/save_migration_test.py`.
4. Register it in `gamemaker/AshenCrown.yyp` under `IncludedFiles` and copy it to `gamemaker/datafiles/tests/saves/`.
5. Extend `scr_save_migrate()` and update `SAVE_SCHEMA_VERSION`; keep the older fixtures so the full chain stays covered.
