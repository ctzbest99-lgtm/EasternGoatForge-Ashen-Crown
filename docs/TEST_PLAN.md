# Manual Test Plan

Run tests in GameMaker after integration; static review is not a substitute for running the game.

## Movement and interaction
- [ ] Project opens and compiles.
- [ ] Four-direction movement works; diagonal movement, if enabled, is normalized.
- [ ] Walk animation cycles only while moving, resets to the idle frame when input stops or locks, and shows the row matching the last facing direction.
- [ ] Attack and hurt animations play once, block movement for their duration, and hand control back to the walk cycle (idle frame, movement resumes) when they end.
- [ ] Player cannot pass walls or leave intended map.
- [ ] Input locks during dialogue, menus, and battle.
- [ ] Dialogue closes and returns control; key repeat does not duplicate interaction.

## Battle
- [ ] Encounter starts once only: walking onto an enemy opens exactly one battle, and a second battle cannot start while one is active.
- [ ] Victory removes the overworld enemy; after a defeat the player must step off the enemy before it triggers again.
- [ ] Attack resolves once per confirmation; Guard works and resets as documented.
- [ ] Battle locks exploration input on start and restores it after victory, defeat, or removal of the controller.
- [ ] HP stays between zero and max HP; defeated actors cannot act.
- [ ] Rewards are granted once; victory and defeat return to valid states.
- [ ] Unknown enemy ID is handled safely.

## Menus and saves
- [ ] Selection and cancel/back work.
- [ ] Save/load persists after restart; missing/corrupt save fails safely.
- [ ] Bestiary displays correct sprite and description.

Record GameMaker version, date, result, and reproducible failures.