# GameMaker Starter Code

This folder contains illustrative GML snippets and setup notes, not a complete GameMaker project. No .yyp or IDE-generated .yy resources are included. Create resources in GameMaker and copy/adapt snippets into matching events/scripts.

Suggested resources: scr_game_constants, scr_game, scr_hud, scr_items, scr_status_menu, scr_battle_math, scr_battle_ui, scr_battle_core, scr_battle_start, scr_encounter, scr_enemy_database, scr_party, scr_save, scr_player_animation, obj_game_controller, obj_hud, obj_status_menu, obj_player, obj_enemy, obj_battle_controller, rm_overworld, and optionally rm_battle_test.

Snippets are prototypes, not verified production code. Compile in the selected GameMaker version after adding each resource. Create missing objects/sprites/rooms or adjust code to match the actual project.

## Battle prototype (roadmap step 3)

- `scr_battle_core` holds the whole loop as pure data: phases `INTRO → COMMAND → PLAYER_RESULT → ENEMY_RESULT`, with `VICTORY` and `DEFEAT` terminal. No input or drawing code lives there.
- `obj_battle_controller` is a thin wrapper: Create builds the battle and locks exploration input, Step turns key presses into `scr_battle_advance`, Draw GUI renders the panel, Destroy restores input on every exit path.
- `scr_battle_start("bandit")` creates the controller once and refuses a second battle.
- The battle runs as an **overlay** in the current room, so the return position survives without saving and restoring it.
- Guard halves the next enemy attack (rounded down, minimum 1) and clears when the next command opens.
- Rewards are collected once on victory into `battle.rewards`; nothing applies them yet.
- `obj_enemy` is the overworld encounter marker: touching the player starts the battle, and a victory removes the marker. Its trigger re-arms only after the player steps away, so a defeat cannot drop the player back into the same fight.

Trigger one in a test room with the debug overlay: F10, then **B** starts a Bandit fight. The player stats there are placeholders (30 HP, 6 attack, 2 defense).

Not implemented yet: a four-character party with populated members, flee, enemy AI variety, enemy movement or patrols (the marker is stationary), and battle animations.

## Party and progression (roadmap step 4)

- `scr_party` holds the actor data: `members` (up to four, in party order) and one shared `gold` purse.
- Level 1 stats reproduce the battle placeholder exactly (30 HP, 6 attack, 2 defense), so adding progression does not rebalance the existing fight.
- XP is per member and needs `6 + 4 x level` to reach the next level; each level adds 6 max HP, 1 attack and 1 defense, and heals the HP it adds. Members at 0 HP earn nothing.
- `scr_party_lead` returns the first member still standing, and that actor fights: damage taken and XP gained land on the real party member, not a copy.
- Victory pays out once through `scr_battle_grant_rewards` + `scr_party_apply_rewards`, and the battle panel lists any level-ups before you leave.
- `global.party` is created on first use by `scr_party_ensure_global`, so no bootstrap object is needed yet.

## Saves (roadmap step 5, save schema)

- `scr_save` writes `{ version, party: { gold, members }, player: { x, y, facing_x, facing_y } }` to `ashen_crown_save.json`.
- Build, validate and apply are pure; only `scr_save_game`, `scr_save_read` and `scr_save_load` touch the filesystem.
- Member stats are derived from level on load, so rebalancing applies to existing saves. HP is clamped to the max and XP is capped below the next threshold; a fallen member stays fallen.
- Writes go to a temp file and are copied over the real save, so a crash mid-write cannot leave half a document.
- Unreadable, corrupt or newer-version saves are refused with a reason and leave the current party untouched.
- Test builds: F5 saves and F9 loads, even with the overlay closed. A real game should save at save points instead of on a key.
- Bump `SAVE_VERSION` when the schema changes; a mismatched version is refused rather than guessed at, and there is no migration path yet.

## Session (obj_game_controller)

- One controller per game: `Create` calls `scr_game_ensure_globals` and asks `scr_game_begin_session` whether this launch still needs its load.
- The load is deferred to `Step` until a player instance exists, because Create order between objects is not guaranteed and the save restores a position.
- `scr_game_begin_session` is true once per launch, so moving between rooms never rewinds progress or teleports the player back.
- Victory requests an autosave through `scr_game_request_autosave`; the controller writes it only once the battle has closed, so rewards and level-ups are on disk. Duplicate requests collapse into one write.
- A failed or missing save is reported in `load_message` and leaves the new game untouched; F5 still saves on demand in test builds.

## Overworld HUD (obj_hud)

- Draw-only panel in the top-left: lead member name and level, current/max HP with a bar, XP toward the next level with a bar, and the shared gold purse.
- Text and bar fractions come from `scr_hud`, so the numbers are testable without a window.
- Hidden whenever a battle is running, because the battle panel already shows the same actor.
- Uses the default font; a real font asset and icon pass belong with the UI work.

## Status menu (obj_status_menu)

- C opens it, UP/DOWN selects a member (wrapping), ENTER opens the item list for that member, ESC steps back (item list, then the panel) and C closes everything. Every key uses `keyboard_check_pressed`.
- One row per party member in party order: name, level, current/max HP, XP toward the next level, attack and defense. A fallen member's stats grey out.
- Opening locks exploration input exactly like a battle, and remembers which instances it locked so a player already locked elsewhere stays locked on close.
- It refuses to open during a battle, sets `global.menu_open` so the HUD hides and contact encounters pause, and clears that flag on close.
- Item use from the field goes through the same `scr_inventory_use` as battle: the heal clamps at max HP, a potion at full HP is refused with a message and nothing is consumed, and the stack drops by exactly one. The list stays open so a second potion can be used without re-opening it.
- Rows come from `scr_status_rows`, so the values are testable without a window.

## Items and inventory

- `scr_items` defines Potion (heal 12) and Hi-Potion (heal 32), and an inventory of `{ id, count }` stacks that merges duplicates, drops empty stacks and ignores unknown ids.
- Each party carries its own `items`, seeded with two potions, so a new game can survive the first Bandit.
- The battle command menu has a third entry, **Item**. It opens a submenu (UP/DOWN to pick, ENTER to use, ESC to back out); using an item spends the turn and then the enemy acts.
- A heal that would do nothing (HP already full, empty stack) is refused in place: the submenu stays open, nothing is consumed and the turn is not wasted.
- Healing clamps at max HP and reports the actual amount restored, so a Hi-Potion on 25/30 HP heals 5.
- The inventory is saved as `party.items`. The field is optional on load, so a save written before the inventory existed still loads with an empty bag.

Not implemented yet: equipment, buying or finding items, item descriptions in the menu, reviving a fallen member, save points, save slots, and autosave on anything other than victory (using an item in the field does not trigger one).
