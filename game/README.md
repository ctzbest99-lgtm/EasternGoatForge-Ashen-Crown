# GameMaker Starter Code

This folder contains illustrative GML snippets and setup notes, not a complete GameMaker project. No .yyp or IDE-generated .yy resources are included. Create resources in GameMaker and copy/adapt snippets into matching events/scripts.

Suggested resources: scr_game_constants, scr_game, scr_hud, scr_items, scr_flags, scr_quest, scr_dialogue, scr_interaction, scr_status_menu, scr_battle_math, scr_battle_ui, scr_battle_core, scr_battle_start, scr_encounter, scr_enemy_database, scr_party, scr_save, scr_player_animation, obj_game_controller, obj_hud, obj_status_menu, obj_npc, obj_dialogue_box, obj_player, obj_enemy, obj_battle_controller, rm_overworld, and optionally rm_battle_test.

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

## Battle party (four members)

- `scr_battle_create` takes one actor or an array; `obj_battle_controller` passes `party.members`, and only members still standing take the field. A party with nobody standing yields no battle at all rather than a one-sided fight.
- A round is one command from each standing member, then one enemy action. `active_actor` is whose command is being chosen and `acting_slot` is whose action it is: a switch moves the first without moving the second, which is what stops a switch from buying a second action.
- The enemy strikes the **front standing member** (first in party order), so party order matters in combat and a fight stays reproducible.
- **Switch** is a command: it lists the standing members, spends the acting member's turn, and continues the round from the acting slot. It is refused when only one member can fight, skips downed members, and ESC backs out for free.
- **Flee** is a command too. The odds are `0.5 + 0.08 × (party levels − enemy power)`, clamped to 10–90%, where enemy power is derived from its HP and attack (`scr_battle_enemy_power`). Only standing members count, so a party carrying two downed members flees worse. A failed escape ends the round in the enemy's favour rather than letting each member try in turn, and an enemy marked `no_flee` (the Ruin Warden) refuses the command without costing anything. Escaping grants no rewards and leaves the enemy in the room.
- Guard covers exactly one enemy turn and clears for every member after it. The battle ends in defeat only when the whole party is down, and the active slot can never be a downed member.
- `scr_party_fill_placeholders` fills a party for testing (**P** in the debug overlay). Those names are placeholders, not canon: the real companions, their classes and how they join are still open questions.

## The merchant (shops)

- `scr_shop` holds the wares and the rules: `scr_shop_stock()` is `potion`, `hi_potion`, `ember_draught`, and every price is read from `scr_item_data`, so the shop cannot drift out of step with the items. `scr_shop_buy` re-checks the gold itself and returns `{ ok, message }`; a refusal spends and grants nothing, so a doubled confirm cannot buy twice.
- `obj_merchant` is the shopkeeper you face and press **Z** on. It draws a code placeholder stall. Trading opens `obj_shop`, created by `scr_shop_begin`, which owns the "may a shop open right now" rule: one at a time, never during a battle, a conversation or the status menu.
- The panel locks exploration input, remembers exactly which players it locked, and restores them in Destroy through every exit path. UP/DOWN choose, ENTER buys one unit, ESC leaves. Rows show name, price and how many you already carry, and an unaffordable row is drawn dimmed.
- While a shop is open, enemies do not start encounters and NPCs and the ruin door do not react, so a panel cannot be hidden behind by a battle.

## Equipment

- An item is equipment when its `scr_item_data` entry has a `slot` — `weapon`, `offhand` or `armour`. Four pieces ship, all sold by the merchant from the same stock list as the potions: **Rusted Blade** (+1 ATK, 25 gold), **Iron Blade** (+3 ATK, 80 gold), **Oak Shield** (+3 DEF, 70 gold) and **Warden Mail** (+5 DEF, 140 gold). The rusted blade is the cheap first rung — and the only piece that is worse than another in its slot, so a downgrade from the Iron Blade can actually be seen and tested.
- A member wears ids only (`scr_equipment`), and the numbers come back from the item table each time, so retuning a piece applies to everyone already wearing it and a save can never carry stale stats. Base attack and defense are never overwritten: `scr_actor_attack`/`scr_actor_defense` add the bonus on top, which is what the battle reads for both your strikes and the enemy's.
- Equip in the status panel: **C** to open, choose a member, **E** to open the equip list, **ENTER** to wear a piece. A piece that was already there goes back in the bag rather than vanishing, and `scr_unequip` does the same the other way.
- Each equip row shows the piece's own bonus and, beside it, what wearing it would change against whatever that slot holds now (`scr_equipment_compare`). A like-for-like swap reads `no change`, and a swap that costs you attack reads as a negative number before you confirm it.
- The item menu now offers only consumables — a Potion list that also sells you a sword is a trap — while the equip list offers only gear. A piece in the wrong slot, or one that has been removed from the game since, contributes no bonus at all.

## Saves (roadmap step 5, save schema)

- `scr_save` writes `{ version, party: { gold, members, items }, flags, player: { x, y, facing_x, facing_y } }` to `ashen_crown_save.json`.
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
- Items carry either `heal` or `revive`. The **Ember Draught** is the revive: it brings a fallen member back at 30% of max HP. A healing item refuses a member who is down ("they are down"), so a Potion can never quietly do a revive's job, and a revive refuses a member who is standing.
- In battle a revive lands on the first fallen member, because the acting member is standing by definition; in the field menu it lands on the member you have selected. Either way it spends the turn or one item.
- The inventory is saved as `party.items`. The field is optional on load, so a save written before the inventory existed still loads with an empty bag.

## Interaction and dialogue (prompts 02-03)

- `scr_interaction` picks a target by facing, not by overlap: a candidate must be within range and inside roughly 60 degrees of straight ahead, and the nearest one wins. Standing exactly on a sign still counts.
- `obj_npc` carries a `dialogue_id` and a `talk_range`. Face it and press **Z** to talk; the prompt only appears when it is the NPC the player is facing.
- `scr_dialogue` holds the scripts as data (`speaker` plus ordered lines), and the playback state: open, current line, advance, close. `obj_dialogue_box` draws the panel and translates keys.
- Lines type themselves out at 45 characters per second (`DIALOGUE_CHARS_PER_SECOND`), driven by `delta_time`. The first press completes the line, the second moves on, so a fast reader never waits for the text; ESC closes the whole conversation.
- The panel lays out the full line and paints the revealed prefix on top, so the paragraph does not reflow as letters appear.
- Every key is `keyboard_check_pressed`, so holding it cannot skim a scene or skip two lines.
- The box locks exploration input while open and restores exactly what it locked, including through ESC and manual removal.
- Closing sets a 250 ms cooldown: the closing press is the same key the NPC listens for, so without it the conversation would reopen instantly.
- Dialogue refuses to start during a battle, over another dialogue, or while the status menu is open.
- `scr_flags` holds story flags as a list of set names. A script may declare `set_flag` (applied when the scene reaches its own end) and `requires` (locked until that flag is set).
- An NPC lists its scenes as a chain (`dialogue_id`, `dialogue_id_after`, `dialogue_id_final`), and `scr_dialogue_pick_chain` plays the furthest one whose flags allow it. Scenes may declare `requires` (one flag) or `requires_all` (several), so a check-off conversation cannot play until every half of the quest is true.
- The worked chain: `npc_hermit` sets `npc_hermit_met`; `npc_hermit_after` requires it and sets `npc_hermit_quest` (the payout); examining the ruin door sets `ruin_door_found`; `npc_hermit_checkoff` requires both and sets `npc_hermit_quest_done`, which is the Hermit checking the follow-up off.
- The corner HUD shows the current stage of that quest (`scr_quest_stage`), derived from the flags: *Hear the Hermit out* → *Find the ruin door* → *Tell the Hermit*, and nothing once the quest is checked off. It reads `global.flags` without creating it, so the line appears when the quest starts and clears when it ends rather than staying on "Complete", and the panel is 68px tall without a quest line and 88px with one, so the cleared row leaves no gap.
- ESC closes a scene without setting its flag, so abandoning a conversation cannot complete a quest.
- Flags are saved with the game (optional `flags` list), so quest state survives a restart.
- `scr_quest` pays quests out: finishing the Hermit's follow-up grants one Hi-Potion, and the dialogue box then shows a final **Reward** page ("Received Hi-Potion.") that needs one more press to dismiss. The payout is guarded by a `<flag>_paid` flag, so replaying the scene or reloading cannot grant a second one. It scans for unpaid rewards rather than firing once, which is why calling it twice is harmless and why an older save that finished the quest still gets its reward on load.

## Rooms, the ruin gate and Zone 1 (prompt 10)

- `scr_rooms` owns room changes: `scr_room_transition_request(room_name, marker_id)` refuses an unknown room, refuses a second request while a fade is running, and creates `obj_room_transition`, which fades to black over `ROOM_FADE_MS` (300) and then calls `room_goto`.
- Arrival is a marker, not a coordinate: `obj_room_marker` instances carry a unique `marker_id`, and the room's single `obj_room_entry` places the player on the requested one on its first step, then forgets the request. A save made away from a marker falls back to its exact saved position. A missing marker logs the reason and leaves the room's own placement alone rather than dropping the player at 0,0.
- `obj_ruin_door` is the gate for the slice. Barred, it speaks (`ruin_door` the first time, recording `ruin_door_found`; `ruin_door_locked` after that). Once the Hermit's check-off scene has set `npc_hermit_quest_done`, the same press remembers the current room as the safe room and fades into Zone 1.
- `scr_ruin` holds the slice as data: `RUIN_ROOM`, the entry marker, the boss id and flag, and `scr_ruin_encounters()` — two Bandits, a Fallen Knight, and the rare `pale_shade` placeholder, each naming the marker it stands on.
- The boss is `ruin_warden`, fought through the same battle system as everything else. A victory sets `ruin_boss_defeated`, and `obj_enemy` checks that flag every step, so a reloaded save re-creating the room's placed instances cannot put the Warden back on his feet. A defeat revives every fallen member to 1 HP and sends the party back to the remembered safe room, so a lost fight costs progress and position, never the run — and never leaves three of four members permanently downed.
- The battle fields everyone still standing, one command each per round, then one enemy action. The enemy hits the front member, so party order is meaningful, and switching members costs that member's turn.
- The save records the room name as an optional `room` field. Loading into a different room fades to it and places the player from the saved position; a save with no `room` loads in place. A battle never saves mid-fight, so a half-resolved turn cannot be persisted.

Not implemented yet: equipment, buying or finding items, item descriptions in the menu, reviving a fallen member outside a defeat recovery, dialogue portraits or branching choices, a quest log, a boss sprite or rare-encounter sprite, save points, save slots, and autosave on anything other than victory (using an item in the field does not trigger one).
