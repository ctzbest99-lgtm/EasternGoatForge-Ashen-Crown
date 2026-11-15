# Zone 1 tileset

| File | Use |
|---|---|
| `ts_zone1.png` | 256×800, 16 columns × 50 rows, 16×16 tiles, no offset or spacing. Tile 0 is empty, tile 1 is the collision solid. |
| `ts_zone1_preview_4x.png` | Labelled 4× preview (index + name on every tile). Do not import as the tileset. |
| `tile_ids.json` | Tile name → index, including multi-tile objects. Reference only. |

## IDE import
1. Create a Sprite named `spr_ts_zone1` and import `ts_zone1.png`. Leave it as one image (do not split).
2. Create a **Tile Set** named exactly `ts_zone1` from that sprite. Tile width and height 16, offset 0, separation 0.

The overworld and Old Watchtower rooms use this tileset. The Chapter 2–3 rooms use `ts_wrenfield` below, whose rows 0–49 are `ts_zone1` unchanged. See `game/rooms/ROOM_SETUP.md`.

## Added tiles (Design update 2026-11-14)
`pallet`, `mira_bed_rubble`, `royal_banner`, `carving_crown_sun`, `signpost_weathered`, plus marker id `mk_story`. Re-import `ts_zone1.png` if an older tileset is already in the IDE.

Rows 0–37 keep their previous tile ids. Rows 38–49 are interior / dungeon tiles (floors, walls, mural, sigil plates, etc.). Re-import `ts_zone1.png` if an older 256×608 tileset is already in the IDE.

## Chapter 2–3 tileset: `ts_wrenfield`
| File | Use |
|---|---|
| `ts_wrenfield.png` | 256×1040, 16 columns × 65 rows. **Rows 0–49 are `ts_zone1`, unchanged (same ids)**; rows 50–64 are the Wrenfield additions (gallows, scaffold, palisade, Crown banners, inn / store fronts). |
| `ts_wrenfield_preview_4x.png` | Labelled preview of the new rows. Do not import. |

IDE: Sprite `spr_ts_wrenfield` (one image) → Tile Set named exactly **`ts_wrenfield`**, 16×16, offset 0, separation 0.
Used by rm_millhaven_road, rm_wrenfield, rm_wrenfield_bent_post, rm_wrenfield_store, and the Chapter 3 rooms
rm_valemere_road, rm_valemere, rm_salt_lamp and rm_warehouse; their build scripts switch the five layers to it
(`scr_wf_prepare_layers`). The overworld keeps `ts_zone1` (its Chapter 2 patch only uses ids < 800).
Source data: `game/maps/chapter2/` (copied from Design's `/workspace/wrenfield`) and `tools/gen_ch3_rooms.py`.
