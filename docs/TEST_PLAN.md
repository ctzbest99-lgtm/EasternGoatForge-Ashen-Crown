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
- [ ] Walking past an NPC does not start a conversation; facing it and pressing Z does, and the prompt only shows when facing it.
- [ ] Dialogue lines advance one press at a time, ESC closes early, and the conversation does not reopen from the press that closed it.
- [ ] Dialogue text reveals character by character without the paragraph reflowing; a press completes the line and the next press advances.
- [ ] Finishing the Hermit's first scene starts the quest and a second conversation appears on the next visit; ESC out of the first scene leaves the second conversation locked.
- [ ] Story flags survive save and load, and a save without flags loads with none set.
- [ ] Finishing the Hermit's follow-up grants exactly one Hi-Potion, and a Reward page announces it before the box closes.
- [ ] The corner HUD names the current quest stage and updates as each flag is set; it shows no quest line before the quest starts, clears the line once the quest is checked off, and stays compact (no empty row) in both of those states.
- [ ] Replaying the scene grants nothing more and shows no Reward page; the reward survives a reload without being granted again.

## Ruin gate and Zone 1
- [ ] The door refuses to open before the Hermit checks the quest off, and says so in character rather than doing nothing.
- [ ] After the check-off, the door fades to rm_dungeon1 and the player arrives on the `ruin_start` marker, not at 0,0 and not in a wall.
- [ ] Leaving and re-entering the ruin places the player once; no second player instance appears and the fade does not repeat.
- [ ] Each encounter marker holds the enemy named in `scr_ruin_encounters()`, and the rare placeholder can be fought without a sprite.
- [ ] Beating the Ruin Warden sets `ruin_boss_defeated`, and a save made afterwards keeps it set.
- [ ] Losing to the Warden revives every fallen member at 1 HP and returns the party to the safe room with the game playable, never stuck on the battle screen.
- [ ] A save made inside the ruin loads back into the ruin in the same position; a save made outside it loads back outside.

## Four-person party
- [ ] With four members, each one gets a command in party order and the enemy acts once per round.
- [ ] The panel lists all four with HP, marks whoever is acting, and shows a downed member as down.
- [ ] Switch lists only standing members, costs the acting member's turn, and refusing it with ESC costs nothing.
- [ ] A member falling mid-battle does not end the fight; only the last one falling does.
- [ ] Guard halves the enemy hit for every member who guarded, and clears when the enemy turn ends.
- [ ] Victory awards XP to every standing member, not just the front one.
- [ ] A Potion refused on a fallen member, and an Ember Draught brings them back at 30% HP; both messages name the reason.
- [ ] A revive used in battle spends the acting member's turn and shows the revived member standing again.
- [ ] Flee shows the odds by success and failure: a strong party escapes a Bandit more often than a level-1 party escapes the Warden, and a failed escape lets the enemy strike immediately.
- [ ] Flee against the Ruin Warden is refused with no turn spent, and an escape grants no XP or gold and leaves the enemy standing.

## Shop
- [ ] Facing the merchant and pressing Z opens the panel; walking past does not.
- [ ] Buying deducts exactly the listed price and adds one item; the row's "have" count goes up.
- [ ] A purchase with too little gold is refused, says so, and changes neither gold nor inventory.
- [ ] Holding ENTER buys one unit, not several.
- [ ] ESC closes the panel and the player can move again; no second shop opens while one is shown, and none during a battle, conversation or the status menu.

## Equipment
- [ ] The merchant sells Iron Blade, Oak Shield and Warden Mail, and each costs its listed price.
- [ ] Equipping a blade raises ATK by 3 in the status panel and in the damage dealt; a shield lowers the damage taken by 3.
- [ ] Equipping over an occupied slot returns the old piece to the bag; nothing is lost by pressing ENTER twice.
- [ ] A potion cannot be equipped, and a sword does not appear in the item menu.
- [ ] Saving and loading keeps worn gear; a save edited to put a shield in the weapon slot is refused on load.

## Battle
- [ ] Encounter starts once only: walking onto an enemy opens exactly one battle, and a second battle cannot start while one is active.
- [ ] Victory removes the overworld enemy; after a defeat the player must step off the enemy before it triggers again.
- [ ] Attack resolves once per confirmation; Guard works and resets as documented.
- [ ] The Item command lists the bag, heals the active member, decrements the stack, lets the enemy act afterwards, and refuses at full HP without wasting the turn.
- [ ] Battle locks exploration input on start and restores it after victory, defeat, or removal of the controller.
- [ ] HP stays between zero and max HP; defeated actors cannot act.
- [ ] Rewards are granted once; victory and defeat return to valid states.
- [ ] Victory grants XP and gold exactly once, and a level-up raises the member's stats before the next battle.
- [ ] Gold never goes negative and cannot be spent beyond the purse.
- [ ] Battle damage persists on the party member, and the lead is the first member with HP above zero.
- [ ] Unknown enemy ID is handled safely.

## Menus and saves
- [ ] The overworld HUD shows the lead member's level, current/max HP, XP toward the next level and the party gold, and updates after a battle.
- [ ] The HUD hides during battle and comes back on return to exploration.
- [ ] Selection and cancel/back work.
- [ ] The status menu lists every member with level, HP, XP, attack and defense; UP/DOWN wraps, and ESC closes it and returns control.
- [ ] ENTER in the status menu opens the item list; using a potion heals the selected member, decrements the stack, and refuses at full HP without consuming anything.
- [ ] The status menu cannot open during a battle, and the HUD hides while it is open.
- [ ] Save/load persists after restart; missing/corrupt save fails safely.
- [ ] A save from an unsupported version is refused with a message and leaves the current party untouched.
- [ ] Loading restores level, XP, HP, gold and player position; HP is clamped and a fallen member stays fallen.
- [ ] The startup load happens once per launch: changing rooms does not reload the save or move the player.
- [ ] A victory autosaves once, after the battle closes, and the saved file already contains the reward XP and gold.
- [ ] Bestiary displays correct sprite and description.

Record GameMaker version, date, result, and reproducible failures.