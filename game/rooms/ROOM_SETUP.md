# Room Setup

1. Create a new GameMaker project in the IDE.
2. Create rm_overworld and document the chosen room size.
3. Create a placeholder top-down player sprite and assign it to obj_player.
4. Create solid collision objects or configure tilemap collision. Movement must use the project's actual collision system.
5. Add one obj_game_controller and one obj_player to rm_overworld.
6. If choosing a dedicated battle room, create rm_battle_test and add the battle controller and placeholder UI.
7. Compile and run before adding more systems.
8. For test builds, add one obj_debug_menu to rm_overworld: F10 toggles it, UP/DOWN + ENTER spawns an enemy ahead of the player, TAB switches to teleport, where you type `x,y` and press ENTER. Remove the object from release builds.

Do not fabricate .yy/.yyp metadata. Let GameMaker create resources. This document does not prove the project compiles.