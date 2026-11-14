# Ashen Crown, Chapter 2 (Wrenfield) rooms: build status

Pipeline: `src/` (Python + Pillow, hand-authored). Outputs and import steps are in README.md.
**Nothing has been compiled or run in GameMaker yet.** Checks done so far:
- every render and scene render inspected by eye;
- every door/exit `target_spawn` resolves to a spawn in its target room (or the overworld entrance marker, as in zone1);
- every non-extra marker is reachable by flood fill from a spawn, in both states of each room.

| Room | Size (tiles) | Status | Markers | Data / scripts | Renders |
|---|---|---|---|---|---|
| rm_millhaven_road | 32x60 | **done**: signpost, Crown notice, stones, traveler, patrol, encounter zone | 12 | millhaven_road/, gml/scr_build_millhaven_road.gml | rm_millhaven_road_* |
| rm_wrenfield | 56x44 | **done**, before + after (46-tile patch): checkpoints, square, scaffold, gallows, inn/store exteriors, west sign | 49 | wrenfield/, gml/scr_build_wrenfield.gml | rm_wrenfield_{before,after}_* |
| rm_wrenfield_bent_post | 24x16 | **done**, closed + open (35-tile patch): Perrin, inn rest | 5 | interiors/wrenfield_bent_post/, gml/scr_build_wrenfield_bent_post.gml | rm_wrenfield_bent_post_{closed,open}_* |
| rm_wrenfield_store | 20x14 | **done**: Len (shop) | 3 | interiors/wrenfield_store/, gml/scr_build_wrenfield_store.gml | rm_wrenfield_store_* |
| rm_overworld (patch only) | 78 tiles + 3 markers | **done as a patch**; zone1 untouched | 3 | overworld_patch/, gml/scr_wf_overworld_patch.gml | overworld_hookup_before_after.png |

## Not built, on purpose
- `rm_valemere_road` (Chapter 3): the west exit falls back to the overworld spawn `from_wrenfield_west`.
- The Bent Post's upstairs: stairs are drawn only.

## Open items for Kevin / Coder
- Shop stock mid-tier item and the inn rest price are TBD (`rest_price` placeholder).
- `obj_story_npc`, `obj_story_trigger`, `obj_zone_entrance` are still optional objects (as in zone1).
- The overworld entrance requires `flag_act2_started`. Drop it if the road should be open in Chapter 1.
- Calder has no after-rescue marker (the script has him keep the west checkpoint off-screen). Add one if wanted.
