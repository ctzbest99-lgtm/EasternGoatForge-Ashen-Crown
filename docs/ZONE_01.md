# Zone 1 — First Region

Purpose: teach movement, collision, interaction, encounter entry, battle commands, rewards, and safe return to exploration.

## Confirmed standard enemies
- **Bandit:** basic human enemy for teaching Attack/Guard.
- **Fallen Knight:** more heavily armored enemy that encourages preparation.

Stats, descriptions, drops, and difficulty values are placeholders until playtested.

## Planned content
Small outdoor route with grass, road, blocking terrain, a ruined landmark, and one sign/NPC. A rare encounter and boss are planned, but final names, art, lore, and mechanics are not approved.

Never start a second battle while one is active. Preserve the overworld return position and clear encounter locks on every exit.

## Current map (2026-11-14)

The playable overworld is now `rm_overworld` at 400×300 tiles (6400×4800 px, 16×16), with Greyhaven (safe) and The Ashen Road at the centre of a larger Eldara hub. The Old Watchtower is `rm_old_watchtower` (60×45 tiles). Import and layer setup are in `game/rooms/ROOM_SETUP.md`. Labelled overviews live in `game/maps/renders/`. Character sprites for Kael, the Bandit, and the Fallen Knight are in `game/sprites/`.

Standard enemies on the map are still Bandit and Fallen Knight. The arena boss is a placeholder **Blackguard**. Other named encounters from the design (Ash Wolves, Ashen Wretches, Grave Spiders, Hollow Soldiers, Ashbound Hunter) are not in the enemy database on this branch; the Ashbound Hunter scripted fight is being added on `feature/watchtower-scripted-encounter` (PR #4).
