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
- Quest rewards are paid by scanning flags for unpaid quests (`scr_quest_pay_out`) and guarded by a saved `<flag>_paid` flag, so the payout is idempotent and cannot be collected twice by replaying a scene or reloading.
- Story flags are a saved list of set names. A dialogue scene sets its flag only when played to its natural end (ESC does not), and `requires` on a script is how a follow-up conversation stays locked until the first has been heard; the NPC picks the script from the flags, not from a visit counter.
- Dialogue is data-driven (a speaker plus ordered lines) and starts only from a discrete press while facing the target, never from overlap. Z talks; the box locks exploration input and sets a 250 ms reopen cooldown, because the closing press is the same key the NPC listens for.
- Items live with the party and are saved as an optional `party.items` list: a save written before the inventory existed still loads with an empty bag, which is why that addition did not bump `SAVE_VERSION`. Healing items are battle-only for now.
- The save is loaded once per launch by a single obj_game_controller, never on room transitions, and is written automatically after a victory (once the overlay closes) in addition to the on-demand key in test builds.
- Saves are JSON with an explicit `version`. Member stats are derived from level on load so balance changes need no migration; unsupported versions are refused rather than partially applied, and there is no migration path yet.
- Progression: XP is per party member, gold is one shared purse. The active fighter is the first member with HP above zero; member stats are derived from level, with level 1 matching the original battle placeholder (30 HP, 6 attack, 2 defense).

## Still undecided
GameMaker version; room resolution and tile size; input mapping; battle room versus overlay; exact backstory; party members/classes; rare encounter and boss identity/mechanics; save schema; license/proprietary status. Treat these as open questions, not approved requirements.