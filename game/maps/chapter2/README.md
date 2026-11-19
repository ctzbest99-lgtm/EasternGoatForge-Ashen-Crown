# ASHEN CROWN: Chapter 2 "Wrenfield" maps (GameMaker)

All art is hand-authored pixel art drawn by Python + Pillow code in `src/`. No image generators were used.
Same pipeline and conventions as `/workspace/zone1`: 16x16 tiles, top-down with a light 3/4 lean, and five tile layers. The marker format is the same, and the data is embedded in GML arrays (plus CSVs).
Source script: `docs/story/CHAPTER2_SCRIPT.md`, approved by Kevin on Nov 14 2026. Every `script_id` on a marker is a line id from that file.

| Map | Room | Size | States |
|---|---|---|---|
| Millhaven Road (signpost, weathered Crown notice, Architect stones, traveler, Crown patrol) | `rm_millhaven_road` | 32x60 tiles = 512x960 px | one |
| Wrenfield (north checkpoint, square + scaffold + two gallows, The Bent Post, Len's store, west checkpoint + Valemere sign) | `rm_wrenfield` | 56x44 = 896x704 px | **before** / **after** (`flag_execution_stopped`) |
| The Bent Post (inn interior) | `rm_wrenfield_bent_post` | 24x16 = 384x256 px | **closed** / **open** (`flag_execution_stopped`) |
| Len's store (interior) | `rm_wrenfield_store` | 20x14 = 320x224 px | one (only reachable after the rescue) |

Build progress: `STATUS.md`.

## Files
```
ts_wrenfield.png                  tileset 256x1040 (16 cols x 65 rows, no spacing). Rows 0-49 ARE ts_zone1, unchanged (same ids);
                                  rows 50-64 are the Wrenfield additions. Tile 0 = empty, tile 1 = collision.
ts_wrenfield_preview_4x.png       labelled 4x preview of the new rows (index + name)
tile_ids.json                     every tile name -> index (zone1 + new; multi-tile objects as [row][col] arrays)
tile_ids_new.json                 only the 48 new Wrenfield objects
millhaven_road/csv/mr_<layer>.csv, millhaven_road/mr_markers.json
wrenfield/csv/wf_before_<layer>.csv, wf_after_<layer>.csv, wrenfield/wf_markers.json
wrenfield/wf_after_patch.json     46 tile changes before -> after: inn lit, store shutters up, right-hand gallows cut
interiors/wrenfield_bent_post/csv/wf_bent_post_closed_<layer>.csv, _open_<layer>.csv, wf_bent_post_markers.json,
                                  wf_bent_post_open_patch.json (35 changes: shutters -> lit windows, cold -> lit hearth, chairs down, mugs)
interiors/wrenfield_store/csv/wf_store_<layer>.csv, wf_store_markers.json
overworld_patch/ow_wrenfield_patch.json   78 overworld tile changes + 3 markers (Millhaven Road branch). zone1 files are NOT modified.
gml/scr_wf_tilemaps.gml           scr_wf_prepare_layers (switches the 5 layers to ts_wrenfield), scr_wf_apply_patch,
                                  scr_wf_filter_markers (show_if_flag / hide_if_flag), scr_wf_cut_rope
gml/scr_build_millhaven_road.gml, scr_build_wrenfield.gml, scr_build_wrenfield_bent_post.gml, scr_build_wrenfield_store.gml
gml/scr_wf_markers_data.gml       scr_<room>_markers() for the four rooms (generated from the JSON)
gml/scr_wf_overworld_patch.gml    scr_wf_overworld_patch(): applies the overworld branch after scr_build_overworld()
renders/rm_<room>[_<state>]_1x.png            tiles only
renders/rm_<room>[_<state>]_scene_2x.png      tiles + the NPC sprites in place (Overhead drawn over them), no labels
renders/rm_<room>[_<state>]_2x_labeled.png    every marker labelled
renders/overworld_hookup_before_after.png     zone1 overworld x270-319, y140-195 as built vs. with the patch
src/                              tiles_wf.py (imports zone1/src/tiles.py), build_wf.py, export_wf.py
```
`<layer>` is one of `ground`, `decor`, `overhead`, `collision`, `markers`. Layers and depths are the same as zone1: Ground 400, Decoration 300, Overhead -100, Collision 500 (hidden), Markers 600 (hidden). The scaffold deck is on **Ground** (walkable). The gallows tops are on **Overhead**, so the noose and crossbeam draw over sprites.

## Import into GameMaker
1. **Tileset:** add `ts_wrenfield.png` as sprite `spr_ts_wrenfield`, then make a Tile Set named exactly `ts_wrenfield` (16x16, offset/separation 0). Rows 0-49 match `ts_zone1`, so zone1 ids keep working in these rooms.
2. **Scripts:** add one Script asset per file in `gml/`. They need zone1's `scr_map_tilemaps` (`scr_map_build_from_arrays`, `scr_map_spawn_markers`, `scr_map_flag_get`, `scr_map_requirement_met`).
3. **Rooms:** create the four rooms at the sizes above, with the five Tile layers at zone1 depths (any tileset; `scr_wf_prepare_layers` switches them to `ts_wrenfield` before setting a tile), `obj_player`, and Creation Code `scr_build_<stem>();`.
4. **Overworld:** in `rm_overworld` Creation Code, after `scr_build_overworld();`, add `scr_wf_overworld_patch();`. This paints the road branch, then adds the Millhaven Road entrance, the fork sign and the `from_wrenfield_west` spawn. If you'd rather bake it in, apply `ow_wrenfield_patch.json` to zone1's overworld data in a zone1 regeneration.
5. **State switching:** each build script builds the A state (before / closed). If `flag_execution_stopped` is set, it applies the patch, then filters the markers. Re-enter the room (or call the build again) after the flag flips. `scr_wf_cut_rope()` swaps the right gallows to the cut tile in place for the WF_GALLOWS cut-down beat, without a room reload.

## Overworld hookup (and where zone1 put the Act II exit)
- zone1 has **no explicit Act II exit marker**. Chapter 2 opens at `crownveil_door` in `rm_old_watchtower` (upper level). The script says the player walks back out through the Watchtower and the Old Road (CH2 lines 54/85). From zone1's map that means rm_old_watchtower -> overworld `old_watchtower` entrance -> Old Road -> Royal/Veil Road east of Valemere.
- The script places Wrenfield **south** ("If you're headed south…", MR_HOOK) and Valemere **west** of it ("West: Valemere", WF_WEST_SIGN). So the patch branches a dirt road **south** off the existing Veil Road at about tile (302,167), down to (303,184):
  - `millhaven_road` entrance at (303,184), px (4856,2960). It targets `rm_millhaven_road` / `from_overworld` and has `requires_flag: flag_act2_started` (canon flag), with the locked line "Crown checkpoint. No passage south without the Reeve's leave." (mine). This keeps it shut during Chapter 1.
  - Fork sign `sign_millhaven_road` at (305,168): "South: Wrenfield and the Millhaven road." (mine)
  - `from_wrenfield_west` spawn at (289,158), on the Royal Road just east of Valemere.
- rm_millhaven_road: the north exit goes to `rm_overworld` / `millhaven_road` (the zone1 convention: an exit targets the overworld entrance marker by name). The south exit goes to `rm_wrenfield` / `from_millhaven_road`.
- rm_wrenfield: the north exit goes back to the road. `west_road_to_valemere` (x0, y27) targets `rm_valemere_road` / `from_wrenfield` (built in Chapter 3). Its `fallback_room`/`fallback_spawn` = `rm_overworld` / `from_wrenfield_west`, kept only as a safety net if that room ever goes missing. It plays WF_HANDOFF and sets `flag_chapter2_complete`. The barrier `west_road_closed` blocks it until `flag_taren_recruited`.

## Room notes
**rm_millhaven_road.** A winding dirt road north->south through forest edges. On it: the signpost (18,4), the weathered Crown notice (12,16), which also sets `flag_hook_taren` as the script's backup hook, the traveler (14,10, MR_HOOK chain), the Architect stones (around 9-12, 27-30, MR_STONE_01/02), and the Crown patrol (17,41: `crown_patrolman`, drawn with `spr_crown_patrolman_ow16_idle_up`, plus the unwilling soldier as an extra; avoidable, MR_PATROL chain). The encounter zone is Lv 8-10 (crown_patrolman, crown_crossbowman, bandit, ash_wolf); adjust it in the marker.

**rm_wrenfield.** Layout:
- The north checkpoint (palisade, barricades, boom, Crown banners, tent, posted list).
- The paved square with the 10x4 scaffold and two 4x3 gallows. Bram is on the right-hand one ("the tall one, on the right"): `bram_noosed` uses `spr_bram_bound_ow16_noose_taut_strip2`, and the rope lines up with the taut noose on `gallows_taut`. Prisoners A-C are bound under the empty nooses, Calder is at the front of the deck, and Taren and Oda are in the crowd.
- The Bent Post on the west side, door (5,16). Len's store on the east side, door (46,15).
- The west checkpoint with the Valemere sign (4,27).

Before: the inn is shuttered/barred, the store is shuttered, and the store door is a barrier. After: the inn is lit, the store is open, the right rope is cut, villagers linger, and Oda and Bram are in the square. The soldiers sit at the checkpoints: unwilling at the north checkpoint, firm at the west one, as in the script.

**rm_wrenfield_bent_post.** Perrin is behind the counter (A1-A3 before, B1 after; `inn_rest: true`). The closed state has chairs on tables, a cold hearth and shutters. The open state has a lit hearth, mugs and lamps. Stairs up are drawn only (no upstairs room).

**rm_wrenfield_store.** Len is behind the counter: WF_STORE_B1, `shop_id: shop_wrenfield_store`, stock [Minor Potion, Antidote, + mid-tier TBD].

## Markers (same fields as zone1, plus)
| Field | Meaning |
|---|---|
| `show_if_flag` | spawn only when this flag is set (after-state NPCs, the store door) |
| `hide_if_flag` | spawn only while this flag is NOT set (the hanging scene, crowd, before-state NPCs) |
| `sprite` | overworld sprite asset to use for the NPC (from `/workspace/sprites/npcs/...` or `enemies/.../overworld`) |
| type `extra` | a non-speaking body (crowd, guards). Spawn as a plain `obj_story_npc` with no lines, or skip |
| `fallback_room` / `fallback_spawn` | where an exit leads until its target room exists |
| `written_by` | `"art pass (placeholder, not in the script)"` on every text I wrote |

Flags used: from the script, `flag_act2_started`, `flag_hook_taren`, `flag_wrenfield_entered`, `flag_close_call`, `flag_execution_stopped`, `flag_taren_in_battle`, `flag_taren_recruited`, `flag_oda_done`, `flag_chapter2_complete`. Added by me: `flag_mr_entered` and `flag_wf_gate_seen` (one-shot story triggers).

## Sign and notice text
Canon text (from CHAPTER2_SCRIPT.md, used verbatim):
| Where | id | Text |
|---|---|---|
| Millhaven Road signpost (18,4) | MR_SIGN_01 | Wrenfield. Millhaven beyond. Valemere by the west road. |
| Weathered Crown notice (12,16) | MR_NOTICE_01 | By order of the Reeve at Wrenfield: those who aid the rebellion / will hang. Public judgment at midday. |
| Architect stones | MR_STONE_01 | Old stones half-sunk in the grass. Architect work, if Kael had to guess. / The carvings are too worn to read. |
| Posted list at the north checkpoint (14,9) | WF_NOTICE_01 | A list of the accused, nailed to the post. "Aiding the Broken Yoke." / Four names. One of them is Bram. |
| West-road sign (4,27) | WF_WEST_SIGN | West: Valemere. The capital road. |

**Text I wrote (not in the script, so change freely):**
| Where | id | Text |
|---|---|---|
| Len's store door, before the rescue (barrier) | WF_STORE_SHUT | Shuttered and barred. Len isn't selling today. |
| West road, before Taren joins (barrier) | WF_WEST_LOCKED | Crown checkpoint. West road closed by order of the Reeve. |
| Board inside The Bent Post | WF_TAVERN_NOTICE | Chalked on a board: "Rooms upstairs. Ask Perrin." |
| Overworld Millhaven Road entrance, locked before Act II | (overworld patch) | Crown checkpoint. No passage south without the Reeve's leave. |
| Overworld fork sign | (overworld patch) | South: Wrenfield and the Millhaven road. |

The painted tiles carry no readable lettering (signpost boards, notice, posted list), so changing the text needs no art change.

## Canon notes
- No Ash on any human. The Crown crest on banners, tent, notice and tabards is a **plain 3-point gold crown**. The crown-ringing-a-black-sun mark (`royal_banner`, `carving_crown_sun` in ts_zone1) is not used anywhere in these rooms.
- Crown blue comes from `sprites/src/crown_pal.py` (`CROWN_BLUE` etc.). Change it there and re-run `tiles_wf.py` + `export_wf.py` to recolour banners and the tent.
- Soft alpha: like ts_zone1, shadow pixels in ts_wrenfield use alpha 90/170. All other pixels are 0/255.

## Regenerating
```
cd /workspace/wrenfield/src
python3 export_wf.py        # builds tiles (tiles_wf.py) and rooms (build_wf.py), writes everything above
```
Sprites used by the scene renders: `cd /workspace/sprites/src && python3 npc_ch2.py && python3 portraits_ch2.py && python3 taren.py`.
