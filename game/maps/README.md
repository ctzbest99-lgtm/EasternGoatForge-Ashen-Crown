# Map reference (not imported as GameMaker assets)

- `ow_markers.json`, `wt_markers.json` — source markers. The runtime copies live in `scr_map_markers_data.gml`.
- `old_watchtower_csv/` — optional CSV dump of the Watchtower layers (the room uses the embedded GML arrays).
- `renders/` — labelled overviews and minimaps for layout. The full 1× overworld render (6400×4800) is not in the repo (it is 2.6 MB and can be regenerated).

Source generators are not committed (see Design's `/workspace/zone1/src/`).

Updated 2026-11-14 with Design's Zone 1 dataset (Tomas/Pell in the Blacksmith, pendant at (186, 169), story NPCs, confirmed sign text, new tiles). The guaranteed Ashbound Hunter trigger is kept in `wt_markers.json` at (41, 23), which Design's drop did not include.

Updated 2026-11-14 (interiors + basement): `wb_markers.json` and `watchtower_basement_csv/`; `interiors/greyhaven_*/` for the five Greyhaven rooms; new labelled renders (`rm_greyhaven_*`, `rm_watchtower_basement_*`, `greyhaven_interiors_2x_labeled.png`). The full 1× overworld render is still not in the repo. `player_start` is (199, 186). The guaranteed Hunter trigger is kept at (33, 33) as a walkable `obj_story_encounter`.
