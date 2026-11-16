# GameMaker Starter Code

This folder contains illustrative GML snippets and setup notes, not a complete GameMaker project. No .yyp or IDE-generated .yy resources are included. Create resources in GameMaker and copy/adapt snippets into matching events/scripts.

Suggested resources: scr_game_constants, scr_battle_math, scr_battle_core, scr_battle_start, scr_encounter, scr_enemy_database, scr_player_animation, obj_game_controller, obj_player, obj_enemy, obj_battle_controller, rm_overworld, and optionally rm_battle_test.

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

Not implemented yet: a four-character party, items, flee, enemy AI variety, enemy movement or patrols (the marker is stationary), battle animations, and XP/level application.
