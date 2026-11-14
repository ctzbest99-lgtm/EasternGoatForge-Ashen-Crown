# Zone 1 tileset

| File | Use |
|---|---|
| `ts_zone1.png` | 256×608, 16 columns × 38 rows, 16×16 tiles, no offset or spacing. Tile 0 is empty, tile 1 is the collision solid. |
| `ts_zone1_preview_4x.png` | Labelled 4× preview (index + name on every tile). Do not import as the tileset. |
| `tile_ids.json` | Tile name → index, including multi-tile objects. Reference only. |

## IDE import
1. Create a Sprite named `spr_ts_zone1` and import `ts_zone1.png`. Leave it as one image (do not split).
2. Create a **Tile Set** named exactly `ts_zone1` from that sprite. Tile width and height 16, offset 0, separation 0.

The overworld and Old Watchtower rooms both use this tileset. See `game/rooms/ROOM_SETUP.md`.

## Added tiles (Design update 2026-11-14)
`pallet`, `mira_bed_rubble`, `royal_banner`, `carving_crown_sun`, `signpost_weathered`, plus marker id `mk_story`. Re-import `ts_zone1.png` if an older tileset is already in the IDE.
