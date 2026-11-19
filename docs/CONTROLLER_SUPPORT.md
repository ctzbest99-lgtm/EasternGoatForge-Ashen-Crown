# Controller support

Status: **implemented in source; physical-controller testing NOT RUN.** There is no GameMaker
IDE or controller on the audit machine, so this document records the code and the checklist, not
a passed test.

## Architecture

`game/scripts/scr_input.gml` is the single input layer. Objects call action functions; they do
not read gamepad buttons or movement keys directly. The only direct keyboard read left outside
the layer is the F5 debug save shortcut, which is a developer tool, not gameplay input.

The layer caches the active gamepad once per game frame. It prefers the current device while it
stays connected, then picks the first connected device, so a disconnect, reconnect, or index
change is picked up on the next frame. A disconnected pad resolves to `-1`; no fake held state
survives, so the player cannot keep walking and a menu selection cannot stay latched.

Each action has a pressed, held, and (where useful) released form. Keyboard and pad are ORed
into one action, so pressing both in the same frame still produces one action, not two.

## Mapping

| Action | Keyboard | Xbox-style pad |
|---|---|---|
| Confirm / interact | Z, Enter, Space | A (`gp_face1`) |
| Cancel / back | X, Backspace | B (`gp_face2`) |
| Open / close Adventure menu | I, Tab | Start (`gp_start`) |
| Previous tab | Q | LB (`gp_shoulderl`) |
| Next tab | E | RB (`gp_shoulderr`) |
| Move / navigate | Arrow keys | D-pad or left stick |
| Menu rows / battle targets | Arrow keys | D-pad |

Other pads work through GameMaker's device button mapping; the action layer names Xbox buttons
only because that is the reference layout.

## Movement

`scr_input_move_vector()` returns one normalized vector:

* Keyboard is checked first. Diagonals are multiplied by `0.70710678`, so keyboard diagonal
  speed matches cardinal speed.
* If keyboard is idle, the D-pad is used; a diagonal D-pad press is normalized the same way.
* Otherwise the left stick is read radially. Inside `INPUT_DEADZONE` (0.24) the result is zero;
  outside it the magnitude is rescaled so the dead-zone edge starts at zero and the rim reaches
  full speed. This removes stick drift while preserving analog speed.
* `obj_player` multiplies that vector by the existing `move_speed`; collision, interaction
  range, Y-sorting, and encounter ticking are unchanged.

`scr_input_axis_x()` and `scr_input_axis_y()` expose the same vector for other callers.

## Menus, dialogue, shops, and battle

All of these already route through `scr_input_*_pressed()` and now receive pad input:

* Adventure menu: Items, Equip, Party Order, Quests, Status, Bestiary, Close.
* Inventory: tabs, rows, equip slots, candidate lists, item targets.
* Shops: Buy/Sell/Exit tabs, quantities, confirm, cancel.
* Dialogue: advance, choices, cancel where allowed.
* Battle: commands, skills, items, targets, Guard, Swap, Escape, message advance.
* Title: press-any-key, menu rows, options, save-slot list.

## Input-conflict guards

* `obj_dialogue_box`, `obj_adventure_menu`, `obj_inventory_menu`, `obj_shop_menu`, and
  `obj_save_menu` record `opened_frame` and ignore input on that frame. The button that opened a
  screen cannot also activate its first row, buy an item, or pick a save slot.
* Closing dialogue, the field menu, inventory, shop, or save panel calls `scr_input_block(1)`
  (or the existing equivalent), so the closing press cannot move, interact, or reopen a menu.
* Menus use pressed checks, not held checks, so holding confirm does not repeat rows.
* Analog drift is ignored for menu navigation because menus use D-pad pressed checks.

## Test checklist (NOT RUN)

Physical controller required:

1. Connect before launch; verify title, overworld, dialogue, menu, shop, battle.
2. Disconnect during movement; verify the player stops immediately.
3. Disconnect in a menu; verify the selection is not stuck and keyboard still works.
4. Reconnect, including at a different device index; verify control resumes.
5. Switch keyboard/pad mid-movement; verify no speed spike or double step.
6. Walk all eight directions with the stick; verify no drift inside the dead zone.
7. Walk diagonally with keyboard and with stick; verify equal speed to cardinal.
8. Hold confirm through dialogue; verify one line per press.
9. Open and close the Adventure menu with Start; verify it does not reopen or move.
10. Navigate every menu tab and a long list with D-pad and LB/RB.
11. Buy and sell with pad; change quantity; cancel a purchase.
12. Fight a battle with pad: command, skill, item, target, Guard, Swap, Escape.
13. Open and close a shop with the button that opened it; verify no same-frame purchase.
14. Check Start does not close a shop or save panel unexpectedly (B cancels those).

Keyboard regression still needs a manual pass: arrows, Z/X, I/Tab, Q/E, Enter/Space.

## Not claimed

* No GameMaker compile was run.
* No physical controller was used.
* Analog feel, trigger/shoulder mapping on non-Xbox pads, and menu repeat timing are unverified.
