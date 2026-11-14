# Included Files

Copy this folder's contents into the GameMaker project's **Included Files** so the paths match the loaders:

- `overworld/ow_ground.bin`, `ow_decor.bin`, `ow_overhead.bin`, `ow_collision.bin`, `ow_markers.bin` — 400×300 little-endian uint16, row-major. This is the fast path for `scr_build_overworld()`.
- `overworld/chunks/ow_<layer>_<cx>_<cy>.csv` — 16 chunks of 100×75 per layer (cx 0–3 west→east, cy 0–3 north→south). Used only if a `.bin` is missing.

In the IDE: Included Files → Add Existing (or add the `overworld` folder) so `file_exists("overworld/ow_ground.bin")` succeeds at runtime.

The Old Watchtower map is embedded in `scr_build_old_watchtower.gml` and does not use Included Files.
