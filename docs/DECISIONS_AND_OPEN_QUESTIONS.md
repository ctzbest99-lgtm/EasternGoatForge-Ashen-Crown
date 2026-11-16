# Decisions and Open Questions

## Confirmed
- Working title: ASHEN CROWN; GameMaker/GML.
- Dark medieval fantasy RPG; top-down classic JRPG exploration, not side-view.
- Protagonist: Kael Varyn; tragic backstory planned, details not locked as canon.
- Tone: atmospheric and serious with some lighthearted moments.
- Classic menu-driven turn-based combat; planned four-person battle party.
- Zone 1 standard enemies: Bandit and Fallen Knight.
- No automatic enemy level scaling by default.
- Planned menu: equipment, party order, items, save/load, status, Bestiary.
- Battle prototype runs as an overlay in the current room rather than a room transition, so the overworld position and encounter locks survive without save/restore. Revisit if the final presentation needs a dedicated battle screen.
- An NPC's scenes are a chain played furthest-first by flag, and a scene may require one flag (`requires`) or several (`requires_all`); the Hermit's check-off scene therefore needs both the taken quest and the found door.
- Room changes go through `scr_room_transition_request` and a fading `obj_room_transition`, and arrival is a named `obj_room_marker` resolved by one `obj_room_entry` per room, so no object hard-codes coordinates and a missing marker is reported instead of teleporting the player to a wrong place.
- The ruin door is the quest gate: it opens only on `npc_hermit_quest_done`, and finding the door early records the flag without unlocking anything.
- A defeat revives every fallen member to 1 HP (standing members keep their HP) and returns the party to the last safe room, remembered when the player leaves the overworld. Reviving only the lead would strand the rest at 0 HP with no revive item yet. No game-over screen and no third option: the run continues.
- The save records `room` as an optional string. Loading into another room fades there and places the player from the saved position; saves without the field load in place, so the addition did not bump `SAVE_VERSION`.
- Quest rewards are paid by scanning flags for unpaid quests (`scr_quest_pay_out`) and guarded by a saved `<flag>_paid` flag, so the payout is idempotent and cannot be collected twice by replaying a scene or reloading.
- Story flags are a saved list of set names. A dialogue scene sets its flag only when played to its natural end (ESC does not), and `requires` on a script is how a follow-up conversation stays locked until the first has been heard; the NPC picks the script from the flags, not from a visit counter.
- Dialogue is data-driven (a speaker plus ordered lines) and starts only from a discrete press while facing the target, never from overlap. Z talks; the box locks exploration input and sets a 250 ms reopen cooldown, because the closing press is the same key the NPC listens for.
- Items live with the party and are saved as an optional `party.items` list: a save written before the inventory existed still loads with an empty bag, which is why that addition did not bump `SAVE_VERSION`. Healing items are battle-only for now.
- The save is loaded once per launch by a single obj_game_controller, never on room transitions, and is written automatically after a victory (once the overlay closes) in addition to the on-demand key in test builds.
- Saves are JSON with an explicit `version`. Member stats are derived from level on load so balance changes need no migration; unsupported versions are refused rather than partially applied, and there is no migration path yet.
- The shop sells the item table's wares at the item table's prices (`scr_shop_price`), so there is one price per item rather than a second list. Buying is one press per unit, refused without spending when the purse is short, and only one panel may be open at a time.
- Escaping is a command with strength-based odds (party level total against an enemy power derived from HP and attack), clamped to 10-90%. A failed attempt ends the round, not just that member's turn, and bosses declare `no_flee`.
- Battles field every standing member: one command each per round in party order, then one enemy action against the front standing member. Switching members is a command that costs the acting member's turn, and the fight is lost only when the whole party is down.
- Progression: XP is per party member, gold is one shared purse. The active fighter is the first member with HP above zero; member stats are derived from level, with level 1 matching the original battle placeholder (30 HP, 6 attack, 2 defense).

## Still undecided
GameMaker version; room resolution and tile size; input mapping; battle room versus overlay; exact backstory; party members/classes; rare encounter and boss identity/mechanics; save schema; license/proprietary status. Treat these as open questions, not approved requirements.