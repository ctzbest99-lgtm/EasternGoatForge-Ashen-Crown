# Room Setup

1. Create a new GameMaker project in the IDE.
2. Create rm_overworld and document the chosen room size.
3. Create a placeholder top-down player sprite and assign it to obj_player.
4. Create solid collision objects or configure tilemap collision. Movement must use the project's actual collision system.
5. Add one obj_game_controller (Create and Step events), one obj_hud (Create and Draw GUI events), one obj_status_menu (Create, Step and Draw GUI events) and one obj_player to rm_overworld. C opens the status menu. The controller loads the save once on room start and autosaves after each victory; it needs to be in the first room so the load happens at launch.
6. For battles, create obj_battle_controller (Create/Step/Draw GUI/Destroy events) and start it with `scr_battle_start("bandit")` from a trigger. The prototype battles as an overlay in the current room, so no room transition is needed; create rm_battle_test only if you want to test the battle in isolation.
7. Create obj_enemy (Create and Step events) with enemy_id set to `"bandit"` or `"fallen_knight"`, and place instances in rm_overworld. Touching one starts the battle; a victory removes it from the room.
8. Compile and run before adding more systems.
9. For test builds, add one obj_debug_menu to rm_overworld: F10 toggles it, UP/DOWN + ENTER spawns an enemy ahead of the player, TAB switches to teleport, where you type `x,y` and press ENTER, B starts a Bandit battle, and F5/F9 save and load. Remove the object from release builds.

Do not fabricate .yy/.yyp metadata. Let GameMaker create resources. This document does not prove the project compiles.