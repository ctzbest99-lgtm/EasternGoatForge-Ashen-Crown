# Controller Support

## Current implementation

ASHEN CROWN uses GameMaker's built-in gamepad API through the shared `scr_input` layer. Keyboard controls remain available and work alongside a connected controller.

The first connected gamepad (device IDs 0–11) is used for the local player.

| Action | Xbox-style controller | Keyboard |
|---|---|---|
| Move | Left stick or D-pad | Arrow keys |
| Confirm / interact / advance | A | Z / Enter / Space |
| Cancel / back | B | X / Backspace |
| Open / close Adventure menu | Menu / Start | I / Tab |
| Previous / next menu tab | LB / RB | Q / E |
| Menu navigation | D-pad | Arrow keys |

The left stick uses a 0.25 axis dead zone and movement remains normalized diagonally. D-pad input takes priority over keyboard input when a controller direction is held.

## Manual verification in GameMaker

- [ ] Connect an Xbox-compatible controller before launching; confirm the title screen accepts A.
- [ ] Move Kael in all four directions with the D-pad.
- [ ] Move Kael in all directions with the left stick; confirm the dead zone prevents drift.
- [ ] Walk diagonally and confirm diagonal speed is normalized.
- [ ] Confirm collisions, room bounds, facing and interaction behave exactly as with keyboard input.
- [ ] Open and close dialogue with A; advance dialogue with A; select dialogue choices with the D-pad.
- [ ] Open and close the Adventure menu with Start; navigate every menu with the D-pad; confirm with A and back out with B.
- [ ] Navigate battle commands, skills, items and targets; confirm with A and cancel with B.
- [ ] Use LB/RB to change inventory/shop tabs.
- [ ] Disconnect and reconnect the controller; verify keyboard input remains usable.

## Current scope / follow-up

This is the first controller-input pass. It does not yet include a controller-remapping screen, vibration, controller-specific glyphs, multiple local players, or analog-stick menu navigation. A successful GameMaker compile and physical-controller playtest are still required; repository changes alone do not prove runtime compatibility or Xbox certification.
