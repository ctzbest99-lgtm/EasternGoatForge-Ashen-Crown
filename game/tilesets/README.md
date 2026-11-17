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

## Chapter 6–8 tileset: `ts_blackwood`
| File | Use |
|---|---|
| `ts_blackwood.png` | 256×1040, 16 columns × 65 rows. **Rows 0–49 are `ts_zone1`, unchanged (same ids)**; rows 50–64 are the Blackwood's own placeholder material. |
| `ts_blackwood_preview_4x.png` | Labelled preview of rows 50–64. Do not import. |

IDE: Sprite `spr_ts_blackwood` (one image) → Tile Set named exactly **`ts_blackwood`**, 16×16, offset 0, separation 0.
Used by `rm_blackwood_deep` and `rm_blackwood_hollow` (Chapter 6), and by the three Ashlands blockouts
(`rm_ashlands_breach`, `rm_ashlands_ruins`, `rm_ashlands_depths`), through `scr_bw_prepare_layers`, which points the five
layers at it before `scr_map_build_from_arrays` fills them. `python3 tools/gen_blackwood_tileset.py` builds the
PNG, the preview and both GameMaker resources (GUIDs are derived from the resource names, so re-running is stable).

| Ids | Name | Use |
|---|---|---|
| 800–807 | `bwmoss_*` | understory floor (the wood's walkable ground) |
| 816–821 | `bwearth_*` | packed black road |
| 832–838 | `bwchar_*` | charcoal / burn-line ground |
| 848–863 | `bwbog_*` | standing bog water |
| 864–879 | `bwthorn_*` | thorn wall (blocking) |
| 880–895 | `bwtop_*` | dead canopy tops, transparent (Overhead layer) |
| 896–911 | props | brambles, bones, ash, embers, spores, web, kiln 904, vine, thorn post, brazier 907, fallen stone, carved crown stone 909, rune stone, black pool |
| 912–927 | props 2 | roots, standing stone 913, stump, charred beam, skull, moths, thorn snag, smoking kiln, rack, rest, stone, log, fungus |
| 928–943 | `bwtrunk_*` | dead trunk columns (Decor layer) |
| 944–959 | `bwbranch_*` | trunk tops and branches, transparent |
| 960–975 | `bwhut_*` | charred hut planks |
| 976–1007 | `bwcrown_cap_*`, `bwcrown_face_*` | dark stone walls; one face carries the black-sun crown |
| 1008–1023 | `bwroot_arch_*` | root arches and hanging thorns |
| 1024–1039 | `bwspare_*` | mist and spare tiles |

These are placeholder art (flat dark material, drawn by the generator), not Design's Blackwood pass.

## How the built rooms use this atlas

Rooms do not store tiles in their `.yy`. Each room's Creation Code calls `scr_build_<room>()`, which fills the five named layers from the arrays in `scr_<room>_data()` (see `game/rooms/ROOM_SETUP.md` §12). `python3 tools/render_built_maps.py` composites those arrays so a room can be checked without the IDE.

Notes on the atlas itself, measured from the PNG:

- Each material row is a ramp over the grass base: `road_0`, `mud_0`, `water_0` and `stone_0` are plain grass, and the index climbs towards the material. The authored maps use the ramp indices deliberately, so treat these as authored data, not as a simple autotile lookup.
- The grass decals (`flowers_*`, `clover`, `tallgrass_*`, `mushrooms`, `dig_spot`) are drawn on a grass background.
- `canopy_*` and `bwcanopy_*` are transparent tree tops and belong on the Overhead layer, where they draw over the player.
- `ts_zone1` already carries the Blackwood material (`bwcanopy_0..15`, `mud_*`, `ash_*`), so there is no separate biome sheet.
