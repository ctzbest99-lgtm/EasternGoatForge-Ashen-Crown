# Art Direction

Pixel art with classic top-down JRPG readability, dark medieval fantasy atmosphere, and strong silhouettes. Exploration is top-down; battle uses side-view character strips.

- Top-down four-direction sprites for exploration; side-view strips for battle.
- Overworld player (recommended): 16×24 on a 16×16 tile grid, origin (8, 23). A 32×48 overworld set (origin 16, 47) also exists as a fallback. Battle battlers are 32×48, origin (16, 47), with wider death (48×48) and Fallen Knight attack (64×48, origin 32, 47) exceptions.
- Consistent sprite origins, collision masks, palette, and animation timing. Overworld `left` is pre-mirrored; battle strips face right.
- Room resolution and tile scale remain undecided. The prototype currently uses 16×16 tiles and 640×360 rooms (360 is not a multiple of 16).

Included: Kael, Bandit, and Fallen Knight character sheets under `game/sprites/` (see `game/sprites/IMPORT.md` and docs/ASSET_INVENTORY.md). Not included: rare-encounter and Zone 1 boss sprites; the Zone 1 tileset / map (still being built); UI, music, and sound.
