# Decisions and Open Questions

## Confirmed
- Working title: ASHEN CROWN; GameMaker/GML.
- Dark medieval fantasy RPG; top-down classic JRPG exploration, not side-view.
- Protagonist: Kael Varyn; tragic backstory planned, details not locked as canon.
- Tone: atmospheric and serious with some lighthearted moments.
- Classic menu-driven turn-based combat; five-person roster with four active and one reserve.
- Zone 1 standard enemies: Bandit and Fallen Knight.
- No automatic enemy level scaling by default.
- Planned menu: equipment, party order, items, save/load, status, Bestiary.

## Adventure menu / Bestiary / Escape (implemented 2026-11-15)
Implements the "planned menu: equipment, party order, items, save/load, status, Bestiary" line above. Open points for the owner:
- The field menu is `obj_adventure_menu` (Items, Equip, Party Order, Status, Bestiary, Close). **Save / Load are deliberately not rows in it**: saving stays at `obj_save_point` and the post-battle prompt, per the existing save-point decision. Adding a Save row would make the menu save-anywhere and is not done without approval.
- Party Order edits `global.game.party` directly, so the change applies immediately and survives the next save; the reserve swap uses the same `scr_party_swap_active_reserve` as the in-battle Swap command. Story events that force or lock slots would need to respect (or override) this — still undecided.
- Escape is allowed only in ordinary field fights. Bosses (`is_boss` / `boss_index >= 0`), scripted / story encounters (`pending_battle.script_id != ""`) and the tutorial fight never offer it. Chance 55% ± 6% per level of difference between the average living party level and the average living enemy level, clamped to 10–90%. **These numbers are PLACEHOLDER.** `scr_actor_from_enemy_data` copies `level` from the enemy database, and every enemy now carries one (see the table below), so the roll is 55% at level parity, about 79% three levels above an enemy and capped at 90% roughly six levels above it.
- **Chapter 1–2 enemy levels** (data only — nothing in the damage, HP or reward formulas reads `level`; only the Escape roll and the Bestiary pane do). Batch 7–8 enemies already carried the design band from `scr_enemy_scaled`; the hand-written early entries had no level at all, so the escape roll was capped against them.

| Enemy | Level | Basis |
|---|---|---|
| Bandit | 1 | Farmlands band 1–2 (`CHAPTER1_SCRIPT.md` §2); the tutorial fight is level 1 |
| Ash Wolf | 2 | Design note "Lv 1–2 / 2–3" (§2–§4) |
| Fallen Knight | 3 | Bandit Camp 3–4 (§5) and Watchtower 4–7 (§6) |
| Ashen Wretch | 3 | Old Road / Bandit Camp 2–4 (§4–§5) |
| Ashbound Hunter | 4 | Middle of the script's recommended 3–5 (§4) |
| Grave Spider | 5 | Watchtower 4–7 (§6) |
| Hollow Soldier | 5 | Watchtower 4–7 (§6) |
| Blackguard | 6 | End of the 4–7 zone. Coder choice: the script gives no boss level, and Escape is never offered in a boss fight |
| Crown Patrolman | 8 | Chapter 2 suggested band 8–10 (`CHAPTER2_SCRIPT.md` §2 road) |
| Crown Crossbowman | 8 | Same band, bottom |
| Grey Ash Wolf | 8 | Same band, bottom |
| Occupation Soldier | 9 | Middle of the band |
| Bandit Veteran | 9 | Middle of the band; it also appears in the Chapter 3 road table (10–13) but keeps the Chapter 2 stat set |
| Reeve Calder | 10 | Top of 8–10, where the Calder fight is tuned to land |

Crown Sergeant (9), and every Chapter 3+ enemy, already had a level from the `scr_enemy_scaled` template. If the Chapter 1–2 levels later conflict with a per-zone recommendation, change the `level` field only — it cannot move damage or rewards. A successful escape grants no XP or gold, does not mark the encounter cleared, and does not count as a defeat (no penalty).
- Bestiary: `global.game.bestiary` counts `seen` and `defeated` per enemy. A **yielded boss counts as defeated** (the fight is over for it) and story enemies that withdraw after a yield are not counted. All 33 descriptions are PLACEHOLDER prose written for this feature, deliberately free of new canon; the owner should review or replace them.
- Save schema is now **v3** (bestiary field). v1/v2 saves migrate on load with an empty log, so an existing save starts with nothing recorded.

## Owner-decided (2026-11-14)
- Defeat: when the party loses a battle, they wake up back in town with HP fully restored. Until a town room exists, the respawn target is `TOWN_RESPAWN_ROOM` (currently `rm_overworld`), at `obj_respawn_point` if one is placed (the overworld builder drops one at Greyhaven `town_square`), otherwise at `TOWN_RESPAWN_X` / `TOWN_RESPAWN_Y` (3192, 2832). A short placeholder wake-up dialogue is shown through the existing dialogue box and reports the gold and XP lost.
- Defeat penalty: lose `DEFEAT_GOLD_LOSS_PCT` of current shared gold (floored) and `DEFEAT_XP_LOSS_PCT` of each member's XP progress toward the next level (`floor((xp - scr_xp_for_level(level)) * 0.1)`), never causing a level-down or a negative total. Defaults are 50% gold and 10% of progress; exact percentages are pending tuning.
- Random encounters: classic JRPG walking encounters using a randomized steps-until-encounter counter (distance-based). Steps count only while the player is actually moving and input is not locked, after a grace period following battle or room entry. Per-area tables (an `obj_encounter_zone` and/or a room table in `scr_encounter_tables`) pick a weighted enemy from `scr_enemy_database`. Towns and other rooms with no table are safe. `obj_encounter_trigger` remains for fixed boss/story fights. Encounter rates are pending tuning (defaults: 16 pixels per step, 8–24 steps between fights, 5 grace steps).
- Ashbound parchment (Chapter 1, approved 2026-11-14): the first Ashbound Hunter fight in the Old Watchtower is a guaranteed scripted encounter (`enc_ashbound_hunter_wt`), so the parchment cannot be missed. The rare 3–5% random Hunter stays on the Old Road, Bandit Camp, and Watchtower. If the parchment was already obtained from a rare fight (`flag_parchment_found`), the guaranteed fight still happens but the pickup and post-fight lines (`ENC_AH_03`–`05`) are skipped.

- Battle XP (2026-11-14): when an enemy dies, its XP is credited to each party member who has already participated (taken at least one turn: Attack, Guard, or Swap) **and** is not KO'd at that moment. Credit is accumulated per member (`pending_xp`) and applied at victory, including level-up messages. If the party loses, no XP is granted. Gold stays shared. A reserve/bench member who swapped in and has taken a turn counts from then on, but gets no credit for enemies that died before their first turn. A member KO'd before an enemy dies gets no XP for that enemy, but keeps credit for enemies that died while they were still standing. A mid-battle Swap command lets an active member switch with the reserve; it costs that member's turn, and the incoming member acts on later rounds.

## Owner-decided (2026-11-15): save and load only at a crystal inside a town's church or tavern
- **Rule:** saving and loading are only available inside a town's church or tavern — the room with the shrine or the hearth and its save crystal. The town around it (streets, squares, shops, the Greyhaven overworld pocket), roads, dungeons, the battlefield, the title screen and the chapter-boundary stops are not save locations.
- **Implementation:** `scr_save_towns()` / `scr_save_town_of_room()` / `scr_save_room_allows_save()` / `scr_save_allowed_here()` in `scr_save.gml`. Each town carries `save_rooms` (its church/tavern interiors) beside `rooms` (the rooms that identify the town); `scr_save_write()` refuses outside a save room and `scr_save_menu_open()` will not open the slot panel there.
- **Towns, their facility and their save rooms** (edit `scr_save_towns()` to add or move a town; nothing else reads it):

| Town | Church | Tavern | Save rooms (`save_rooms`) | Town rooms (`rooms`) |
|---|---|---|---|---|
| Greyhaven | Greyhaven Chapel | Greyhaven Tavern | `rm_greyhaven_chapel`, `rm_greyhaven_tavern` | the two save rooms plus `rm_greyhaven_blacksmith`, `rm_greyhaven_general_store`, `rm_greyhaven_varyn_house`, and `rm_overworld` inside the town bounds (resolved by position, `scr_save_location_name() == "Greyhaven"`) |
| Wrenfield | — | The Bent Post (`CHAPTER2_SCRIPT.md` §“Perrin, the tavern keeper”) | `rm_wrenfield_bent_post` | `rm_wrenfield`, `rm_wrenfield_bent_post`, `rm_wrenfield_store` |
| Valemere | — | The Salt Lamp (`CHAPTER3_SCRIPT.md` §4, a Lower City dive) | `rm_salt_lamp` | `rm_valemere`, `rm_salt_lamp`, `rm_warehouse` |

- **Why the room and not the town:** the crystals are the save interaction and all four stand inside a church or tavern. Gating on the town let the debug F5 key save in a town square where no crystal exists and made the “no shrine, no hearth” line wrong. The narrower rule matches the crystals, keeps every town savable (each has a crystal in a room you can always enter), and leaves the chapter boundaries unchanged.
- **An inn bed is not a save point of its own:** `obj_save_point` (the crystal) is the only save interaction. The Bent Post's Bed (`inn_rest`, placeholder price) and any future inn are rest/flavour only; the tavern room is already a save room, so no extra rule is needed.
- **Save crystals** (one per save room, so they are the only save locations): Greyhaven Chapel (`chapel_save`, tile 10,7), Greyhaven Tavern (`tavern_save`, tile 10,6), **The Bent Post** in Wrenfield (`bent_post_save`, tile 4,9 — added 2026-11-15) and **the Salt Lamp** in Valemere (`salt_lamp_save`, tile 4,6 — added 2026-11-15). A crystal placed anywhere other than a save room in the IDE shows the blocked line instead of the slot panel.
- **The two new crystals were audited against the room builders (2026-11-15):** the Bent Post tile (4,9) and the Salt Lamp tile (4,6) are collision-0 floor with no decor on them — in the Bent Post the open patch only rewrites collision at 5/8, 7/8, 9/8, 11/8, 17/9, 5/11, 7/11, 14/12 and 16/12, so the crystal is clear in both the closed and open states — both are reachable on foot from the room's door (the Bent Post path runs west along row 12, the Salt Lamp straight up the middle), both are clear of the bar, the NPCs and the door, and both use the Greyhaven crystals' feet convention (`x = tile_x*16 + 8`, `y = tile_y*16 + 16`) for the 16×24 sprite. The Greyhaven crystal tiles (10,7) and (10,6) are still marked OPEN for Design.
- **Automatic chapter-end prompts are now silent where they cannot save**: CV_END (Crownveil door), WF_HANDOFF (Chapter 2) and VM_HANDOFF (Chapter 3 west gate) call `scr_save_menu_open("save", false, true)` and therefore do not fire outside a save room. The player has to walk back into a church or tavern in Greyhaven, Wrenfield or Valemere to save. If a chapter boundary should offer a save again, either move the boundary into a save room or make one the destination.
- **Title-screen Continue is not affected**: it reads the slot directly through `scr_save_load()`, because the title screen is not a save room (and must load the game at all).
- **Deliberate attempts get a line**, not silence: a save point or the debug F5 key outside a save room opens the dialogue box with “No shrine, no hearth. Save only at a crystal inside a town's church or tavern.”
- **Settled follow-ups (2026-11-15):** the save point is the church/tavern *interior*, not the whole town — this is now implemented, not open. An inn bed is not a separate save rule; the crystal remains the only save interaction. Still open for Design: the two Greyhaven crystal tiles (10,7) chapel and (10,6) tavern.

## Options screen and saved audio settings (implemented 2026-11-16; UNVERIFIED)

- The title screen's Options entry is a real screen: Music, Ambience, Sound effects, Mute, Back. Left/right changes a gain by 5%; confirm/cancel leave. It replaces a panel that read "Options (placeholder)".
- **Persistence uses `ashen_settings.ini`, not the save file** — a new `ini_open`/`ini_write_real` pair in `scr_audio.gml`. Deliberate: the mix is a client preference, not character state, so it must not bump the save schema to v4 or be lost when a save is deleted. The file sits in the sandbox save area, separate from the three slots.
- Gains are still applied through the existing `scr_audio_set_gain`, so anything already reading `global.audio_ctx` picks the change up. `scr_audio_settings_load()` runs once in `obj_title` Create; a missing file keeps the compiled defaults.
- **Not built:** an in-game Options entry. The Adventure menu has no settings page, so changing the mix mid-chapter means returning to the title screen. That is the next step if the owner wants it.
- **Unverified:** the layout has never been drawn in GameMaker — panel height, row spacing and bar width are arithmetic, not observed. TEST_PLAN M16–M18 are the checks.

## Chapter 6 built (approved 2026-11-16; UNVERIFIED)

The owner approved all eight decisions in §10 of `docs/story/CHAPTER6_SCRIPT.md` as recommended, so **The Green Silence** is canon and built: `scr_dialogue_data_ch6` (51 nodes), `scr_ch6_story`, `scr_ch6_markers_data`, `scr_build_blackwood_deep`, `scr_build_blackwood_hollow`, and the rooms `rm_blackwood_deep` and `rm_blackwood_hollow`.

Implementation choices made while building it, none of which changes a story decision:

- **The boss gate is `scr_ch6_tick`, not a story trigger.** `obj_story_trigger` latches after one attempt, and §5 has to be replayable after a defeat (the Chapter 4 lesson). The check fires when the player crosses into the burnt ground at x = 400 px (tile 25), so the road before it stays quiet as §1 asks. A defeat sets `ch6_boss_cool`, cleared when the party walks back west of x = 320.
- **The rooms are blockouts on `ts_wrenfield`**, as §9.3 specifies, because there is no Blackwood tileset. Cinderhollow's burners use `spr_story_npc_placeholder`; the act's largest art debt is unchanged and is now visible in-game rather than only in the plan.
- **`Q_MBW_S2`'s objective is not reworded at the chapter's end.** §6 says the stage stays active with "Find the shrine under the roots."; the journal's stage text is fixed data (`scr_quest_definitions`), so that objective belongs to Chapter 7's stage instead. Recorded rather than silently resolved.
- **`Q_MAIN_BEYOND_VEIL` is set to `complete`**, keeping Q_BV_S7 as its last stage, rather than gaining an eighth stage — the §0 intent ("the Act II quest closes").
- **The duplicate-trigger rule was applied to repeat talk**: Berrin's campaign line plays once (`ch6_hollow_met`), then `CH_TALK_01/02/03` one per visit in order, then `CH_BERRIN_R1`. The camp and the hollow arrival each latch on their own flag.
- **`rm_blackwood_garrison` gained a `from_blackwood` spawn** (tile 24,10) so the deep room's west door lands in the yard instead of falling back to the default spawn. `tools/gen_ch5_rooms.py` was corrected for a later hand edit to Sera's sprite note before regenerating; the only resulting change is that one marker.
- **Unverified:** nothing compiled or played. TEST_PLAN F16–F28 are the checks.

## Still undecided
GameMaker version; room resolution and whether 640×360 stays (height is not a multiple of 16) or is replaced by a 16-aligned size (e.g. 640×368, 320×180 with a 2× window, or 256×224); camera / view size; input mapping; battle room versus overlay; exact backstory; party members/classes; rare encounter and boss identity/mechanics; license/proprietary status; save-point locations and whether a save-anywhere debug key stays; official item prices and the shop sell rate (defaults below); exact defeat gold/XP percentages (defaults 50% gold / 10% of XP-to-next-level, pending tuning); whether a defeat should also deduct items; exact random-encounter rates and table weights (defaults 8–24 steps, 5 grace, 3:1 Bandit/Fallen Knight); Ashbound Hunter placeholder stats and rare rate (default 4%, midpoint of 3–5%); whether a defeat during the scripted Watchtower Hunter fight should consume the trigger (currently it does not, so the parchment cannot be missed); whether that scripted fight should grant regular XP/gold (currently yes, using the same per-enemy living-participant rule); XP curve, max level, and level-up stat growth (placeholder defaults below); whether the defeat penalty should also hit the reserve; whether story events lock or force party slots. Treat these as open questions, not approved requirements.

## Prototype assumptions (party + progression; pending owner approval)
These were chosen so roadmap step 4 could be built. None is a locked design decision.
- Party roster (coder note from STORY_BIBLE.md, confirmed 2026-11-14): five permanent members — Kael (Vanguard), Lyra (Rogue), Caelan (Arcanist), Sera (Warden), Taren Holt (Rebel Captain, Broken Yoke). Four fight at a time; one reserve slot. Array order of `global.game.party` is battle command and turn order. Default run: Kael only has joined; the other four exist on `global.game.roster` but are not in a slot. `DEBUG_ADD_FULL_ROSTER` puts Kael/Lyra/Caelan/Sera in active and Taren in reserve.
- Defeat *check* and the defeat gold/XP *penalty* apply to active members only (assumption). Reserve HP is still restored on a defeat. Battle XP is owner-decided (see above): participation only.
- Placeholder roster stats (pending approval, not canon): Lyra 24/7/1, Caelan 22/8/1, Sera 28/4/4, Taren Holt 36/8/3 (warrior-leaning). Taren's `weapon_categories` is `["heavy_sword"]` and his equipment stub starts with `bastard_sword` (PLACEHOLDER ATK +3, applied to `attack` via `scr_actor_refresh_equipment`). Skills are placeholders.
- Each member has their own `level` and `xp`. Gold is still a shared party total. `global.game.xp` mirrors Kael's (`party[0]`) XP for the debugger.
- XP curve (total XP to *be* level L): `20*(L-1)^2 + 10*(L-1)`. L1=0, L2=30, L3=100, L4=210, L5=360, L10=1710, L20=7410 (cap 20).
- On level-up: +4 max HP, +1 ATK, +1 DEF (placeholder). Living members also gain the HP increment as current HP; KO'd members stay at 0 HP.
- When an enemy dies, its XP is banked to members who have already taken a turn and are still living. A KO'd member does not receive that enemy's XP, even if they acted earlier; they keep any credit from enemies that died before they fell. A reserve member who swapped in and has taken a turn is eligible for later kills only. Banked XP is applied at victory (level-up messages still play). A defeat grants no XP. Gold is still shared among the party.
- Equipment slots (`weapon`, `armor`, `accessory`) are live: equipped bonuses add to `base_attack` / `base_defense`. The I / Tab inventory can use consumables and equip gear. Status, party-order and Bestiary menus were unbuilt when this was written; all three now live in `obj_adventure_menu`, together with Quests (2026-11-15).


## Prototype assumptions (saves + shops; pending owner approval)
These were chosen so roadmap step 5 (menus/saves) could start. None is a locked design decision.
- Save format: versioned JSON (`save_schema_version` 1) written with `buffer_text` to `save1.sav`–`save3.sav` in the working directory. A missing or corrupt file is refused; it does not crash. A version below 1 or above `SAVE_SCHEMA_VERSION` is refused.
- What is saved: party roster (HP, max HP, levels, XP, base/current ATK and DEF, equipment, joined flag), active and reserve slot ids, gold, inventory and key items, story flags, cleared encounters, current room name, player position and facing, playtime, and pending story fields that matter (`pending_post_dialogue`, Ashbound pending id, encounter-step counters). Mid-battle and title-screen states are not saved.
- Save access: a prompt after `CV_END`, plus `obj_save_point` in the Greyhaven chapel (tile 10, 7) and tavern (tile 10, 6). Both locations are temporary. `#macro DEBUG_SAVE_ANYWHERE` (F5) is off by default.
- Title Continue is enabled when any slot exists and shows location, lead level, playtime, and gold. New Game resets `global.game`.
- Shops are data-driven (`scr_shop_data`). `shop_greyhaven_store` (Marda) sells Minor Potion and Antidote (confirmed stock). `shop_greyhaven_forge` (Pell, after `flag_pendant_found`) sells Iron Sword, Leather Armor, and Iron Helm — PLACEHOLDER stock from Chapter 1 item art, not unique rewards. Talking plays the confirmed lines, then the menu opens. Buy / Sell / Exit, icons, prices, quantity, gold, owned count, and equipment preview (who can equip it, ATK/DEF change) are implemented. Sell is 50% of buy price (PLACEHOLDER, floored, minimum 1). Key items cannot be sold. Input is locked while the shop is open.
- PLACEHOLDER prices: Minor Potion 15g (heals 15 HP), Antidote 20g, Iron Sword 80g (ATK +3, longsword), Leather Armor 60g (DEF +2), Iron Helm 40g (accessory, DEF +1). No prices appear in CHAPTER1_SCRIPT.md or STORY_BIBLE.md.
- Inventory (I / Tab): use Minor Potion; Antidote cures an overworld `poisoned` flag (battle poison does not exist yet, so it usually reports no effect). Equipment can be worn from this menu. Dedicated shop / save / inventory art will land later in `/workspace/sprites/ui/menus/`; menus look up those sprite names first and fall back to the nine-slice windows, font, cursor, and item icons. Layout constants are centralized in `scr_menu_layout.gml`.

## Chapter 2 wiring (feature/chapter2; pending owner approval)
All of `docs/story/CHAPTER2_SCRIPT.md` (approved at cc8faff) is wired. That is 116 line ids, generated verbatim into `scr_dialogue_data_ch2` by `tools/gen_ch2_dialogue.py`. The flow is in `scr_ch2_story`. The rooms are Design's `/workspace/wrenfield` pipeline, copied unchanged except for the repo edits listed below.

**Placement and timing choices (mine; change freely):**
- **Wake-up (§1).** `CV_WAKE_01`–`04` play right after the Chapter 1 save prompt closes, or on loading that save in `rm_old_watchtower`. They set `flag_act2_started`. `WT2_BACK_01` follows straight after, as Kael's first backtrack line. The Blackguard's empty armor (`CV_WAKE_05`) is an invisible inspect spot where he fell (tile 29,6): there is no ash-heap sprite yet. `WT2_SIGN_01` and `GH2_GATE_SIGN` are identical to the Chapter 1 sign text, so those signs are unchanged.
- **Greyhaven return (§3).** After `flag_act2_started`, each survivor's Chapter 1 scene id plays the GH2 lines instead. Pell's repeat line is followed by the forge shop, and Marda's line by her shop. Any GH2 talk sets `flag_greyhaven_return`.
- **Quests.** This was written before the journal existed; the Adventure menu now has a Quests pane driven by `scr_quest_data.gml`, and Act II stages run to `Q_BV_S7`. Stages are still stored as flags (`quest_Q_MAIN_BEYOND_VEIL`, `quest_Q_SIDE_ODA`), and the script's SYSTEM lines still carry the player-facing text. S1 moves to S2 when the hook is heard on the Millhaven Road, or on entering the road with the hook already heard.
- **Crown patrol (§4.2).** It barks `MR_PATROL_01`–`03`, then offers Fight / Move along ("can be avoided or fought"). Move along waves Kael through, and the patrol is gone on later visits (`avoided_enc_crown_patrol`). Fight is **2 Crown Patrolmen** (PLACEHOLDER: it matches the two soldiers on the map and the balance pass's cap of 2 for solo Kael), not the 3-enemy `grp_crown_patrol`.
- **Gallows → Calder (§6–7).**
  - The square trigger (or touching Taren) plays `WF_GALLOWS_01`–`07`.
  - The right rope is cut in place on `_07`. Only the gallows tiles change; the repo version of `scr_wf_cut_rope` no longer lights the inn or opens the store early. Bram swaps to his bound idle pose.
  - Then `WF_GALLOWS_08` and `WF_CALDER_INTRO_01`–`07` play.
  - **Taren joins here:** 2nd slot, raised to Kael's level with full HP/MP, `flag_taren_in_battle`. `WF_CALDER_SYS_01`–`03B` show before the battle room loads. `SYS_04` is appended to the first Rallying Cry message, once per save.
  - Calder's stance message is his bark `WF_CALDER_PHASE2_01`, and his yield message is `WF_CALDER_DEFEAT_01`. Both replace the system lines. "The rest withdraw." from the balance pass stays when a soldier was still standing.
  - After the win: `flag_execution_stopped`; the room reloads in the after state; then `WF_CALDER_DEFEAT_02`–`05`, `WF_CALDER_REWARD_01` and `WF_JOIN_01`–`12` play, and then `flag_taren_recruited` and `Q_BV_S3` are set.
- **Loss to Calder.** The usual town wake-up. Re-entering Wrenfield keeps the rope cut, replays `WF_CALDER_INTRO_07` and restarts the fight (no softlock).
- **Taren after the rescue.** He stands beside Oda and Bram (tile 24,24) for `WF_JOIN_R1`. The map pass had no marker for him.
- **Oda.** `WF_ODA_A2` "[Yes] [No]" is a real choice box. Declining lets her ask again. The after-rescue talk gives the reward once, whether or not the quest was taken (the script allows a one-talk start and finish). Bram: `WF_ODA_B3` the first time, then `WF_BRAM_B1`.
- **Inn (§9).** Perrin plays `WF_TAVERN_B1`, then Rest / Leave at **30 g (PLACEHOLDER, `INN_WRENFIELD_PRICE`)**. Design's marker said "first night free"; I did not do that, because the script's "first one's on the house" is about a drink.
- **Len's store.** `WF_STORE_B1` → `shop_wrenfield_store`. Stock is Minor Potion, Antidote, Ether and **Chain Mail as the mid-tier item (PLACEHOLDER, DEF +4, 220 g)**.
- **Ether chest** (balance pass): Millhaven Road east clearing, tile (25,24). PLACEHOLDER spot.
- **West road (§10).** The barrier (`WF_WEST_LOCKED`, "Crown checkpoint. West road closed by order of the Reeve.") now clears on `flag_execution_stopped`, i.e. right after the Calder fight; Design had `flag_taren_recruited`. Leaving plays `WF_HANDOFF_01`–`05` and a stub line, "To be continued." (mine). It sets `flag_chapter2_complete`, lands on the overworld spawn `from_wrenfield_west` east of Valemere, and opens the chapter-end save prompt. Chapter 3 (`rm_valemere_road`) replaces the fallback automatically once it exists.
- **Text written by the art pass, kept:**
  - `WF_STORE_SHUT` (barrier only in the before state)
  - `WF_WEST_LOCKED` and the overworld barrier "Crown checkpoint. No passage south without the Reeve's leave." (both as specified)
  - `WF_TAVERN_NOTICE`
  - the fork sign "South: Wrenfield and the Millhaven road."
- **Flags added by the map pass:** `flag_mr_entered` (MR_ENTER one-shot) and `flag_wf_gate_seen` (sergeant one-shot).

**Repo edits to Design's generated Wrenfield files** (regenerating from `/workspace/wrenfield` needs these re-applied):
1. Each `scr_build_*` (four rooms) also enables the 320×180 camera, as the Zone 1 builders do.
2. `scr_wf_filter_markers` ends with `scr_ch2_marker_fixups` (west barrier flag, inn price, Ether chest, Taren after, patrol escort).
3. `scr_wf_cut_rope` patches only the gallows columns.
4. `scr_wf_patch_overworld` was removed. `scr_build_overworld` applies the overworld patch and merges its markers into its single marker pass, so spawn names like `millhaven_road` still resolve.

**Engine additions** (all generic):
- marker `sprite` for NPCs, story NPCs, encounters and extras
- type `extra` (silent blocking body)
- `fallback_room` / `fallback_spawn` for exits
- exits with a scene (`scr_ch2_exit_script`)
- flag-only walk-on triggers
- encounter barks with Fight / Move along
- an optional callback after post-battle lines
- per-line portrait expression (`expr`)
- party Guard holds a `defend` strip when one exists
- story barks for a boss's stance and yield (`stance_line_node`, `yield_line_node`)

**Open / placeholders:**
- Inn price 30 g. Len's mid-tier item (Chain Mail).
- Calder rewards: 220 XP and 100 g, the Design number, kept.
- Ether chest placement. The "To be continued." line.
- No quest log.
- No ash-heap sprite for the empty armor.
- **Unbowed** (resists Fear / Stun) has no effect, because neither status exists yet.
- Defeat sends the party to the Greyhaven respawn, which is a long walk back to Wrenfield.

## Chapter 3 wiring (feature/chapter3; pending owner approval)
Canon is `docs/story/CHAPTER3_SCRIPT.md` (approved by Kevin Nov 14 2026, 3:53 PM ET). Where the script is silent the following are **placeholders**:

- **Rooms:** Design's Valemere art has not landed anywhere in the repo, so all four rooms (`rm_valemere_road`, `rm_valemere`, `rm_salt_lamp`, `rm_warehouse`) are functional blockouts: `ts_wrenfield` tiles, existing NPC sprites for the Valemere crowd, flat layouts. Generated by `tools/gen_ch3_rooms.py`; swap the data when Design's maps arrive.
- **Lyra:** ~~flat-colour placeholder sprite set~~ **replaced 2026-11-16.** She is now drawn by `party_kit.py` with the rest of the party (16×24 overworld, battle strips and three portraits) and has a `daggers` weapon mode.
- **Lyra kit numbers** (Twin Cut 2 hits × 0.7, Open Vein × 0.9 + Bleed 3 turns at 80%, Cutthroat +15% crit) are the script's suggested levels tuned to feel right, not canon percentages. Same for the Debtman's stats (level 12 boss template).
- **Night lighting:** `obj_night_overlay` is a placeholder (dark overlay + lantern pools drawn in the GUI layer). No tint on the Valemere city yet.
- **Encounter table `ch3_valemere_road`** (Crown Patrolman, Bandit Veteran, Bandit, crossbowman groups; levels 10–13): weights are placeholders, as in every other table.
- **The west-country gate** points at `rm_west_country_road`, which does not exist (Chapter 4). After the handoff and save prompt, leaving is a no-op. The overworld stub entrance to Valemere is untouched.
- **Item command** reuses the field item rules (`scr_item_use_on`): heals / MP / consume; no battle-only items yet.
- The Debtman is **not** Ash-corrupted, is never killed (yields at 0 HP, held alive), and the third Fallen Knight sighting is the last one played in Chapter 3.


## Systems pass: tutorial, Cheap Shot, Last Stand, battle poison (feature/systems-pass)
Canon sources: CHAPTER1_SCRIPT.md §2.1 (C-confirmed). Everything else is a PLACEHOLDER.
- **FL_TUTORIAL is wired.** Pre-battle FL_TUTORIAL_01–03 (marker `script_chain` on `first_bandit`, played by the encounter-prelude path), SYS_01–04 as battle messages at the intro (new `queue_messages` multi-line support in obj_battle_controller), SYS_05 the first time Kael drops below 25% HP (checked at ROUND_START), post-battle 04–05 via `pending_post_dialogue` (`scr_ch1_on_battle_finish`). **`flag_tutorial_done`** is set on the win and gates random encounters (`scr_random_encounter_tick`); an old save with the tutorial already cleared keeps its random encounters (cleared-encounters fallback).
- **Cheap Shot (canon):** Bandit action, ×1.5 vs a guarding target instead of the Guard reduction (`anti_guard` flag on the skill; multiplier PLACEHOLDER). Weight 1 in 4 PLACEHOLDER.
- **Last Stand (canon):** Kael passive; below 25% HP, ATK +15% / DEF +10% (canon values), applied in `scr_battle_stat` before buffs.
- **Battle poison:** "poison" status ticks at ROUND_START like bleed (5% max HP, never kills — PLACEHOLDER rule, same as bleed), HUD tag "Pn". **The Grave Spider's Venom Bite is the PLACEHOLDER inflictor** (0.8 power, 40% chance, 3 rounds — all PLACEHOLDER); Kevin may reassign it. Antidote now cures it in battle (and the overworld `poisoned` flag as before).
- **Stale claims corrected in this file:** the Blackguard entry already carries the canon 450 HP / 250 XP / 100 Gold; the terrace stairs are enforced (barrier marker on `flag_wt_upper_unlocked`); `rm_watchtower_basement` and `rm_valemere` are built; the in-battle Item command exists (Chapter 3); ash_wolf / ashen_wretch / grave_spider / hollow_soldier battle strips exist in the repo (batches landed after the old note).
## Enemy batches 7–8 (feature/enemy-batches-7-8; pending owner approval)
Design batch 7 (Wrenfield elite, Lower City, Hollow Sanctuary, Blackwood Road Garrison) and batch 8 (Act III, the Blackwood) are in the enemy database with sprites and encounter tables. No rooms or story beats use them yet. **Everything below is a PLACEHOLDER.**
- **Stats come from a template** (`scr_enemy_scaled(id, …, role, level, party, extra)`), anchored so a level-9 common matches the balance-pass Chapter 2 regulars. **Rebalanced after the Chapter 4–5 simulation (2026-11-15):** HP now grows **+9 per level** and ATK **+3 per level** (was +7 / +2), because the old curve fell behind the tiered party growth — random fights cost almost nothing and bosses could not kill anyone. A boss now takes its length from **HP × 1.2 × expected party size** and its threat from **+3 ATK / DEF**; elites are unchanged (×2 HP, +2 ATK / DEF, ×2.5 XP). Per-enemy tweaks: Cutpurse ×0.8 HP; Wisp ×0.75 HP; Surgeon ×0.8 HP; Briar Hulk ×1.4 HP; Moths ×0.7 HP; Ward Sentinel and Door Warden +3 DEF; **Commander Hailen** ×1.5 HP and +14 ATK, **Garrison Pikeman** +4 ATK, **Warden** ×1.25 HP and +2 ATK. **Act III (2026-11-16, tuned by the simulation and applied):** `burn_line_hulk` ×2.1 HP and +12 ATK (the Hulk's ×1.4 and the boss ×1.2 × 4), `blackwood_matriarch` ×1.5 HP, `door_warden_boss` ×2.0 HP, and `ward_sentinel_late` as the level-20 Sentinel the Chapter 8 adds need. SPD is set per enemy. XP and gold were left alone — see the open item at the end of this section.
- **Levels** use ACT2_OUTLINE's bands, approved Nov 15 2026: Lower City (Ch 3) 10–13, Hollow Sanctuary (Ch 4) 13–16, Garrison (Ch 5) 16–18. The Blackwood (Act III) is 18–20, which is my placeholder. **Open:** `PARTY_MAX_LEVEL` is 20, so Act III will need a higher cap.
- **Expected party sizes for bosses:** Debtman 3 (after Lyra); Sanctuary Warden, Commander Hailen and the Matriarch 4.
- **Template check** (Kael at the enemy's level, still in Chapter 2 gear, so later gear makes these easier):

| Enemy level | Role | HP / ATK / DEF | Kael hits to kill (same level, Ch2 gear) | Damage to Kael per hit |
|---|---|---|---|---|
| 11 | common | 62 / 19 / 15 | 4 | 10 of 94 HP |
| 11 | elite | 124 / 21 / 17 | 8 | 12 of 94 HP |
| 11 | boss (party 4) | 298 / 22 / 18 | 19 | 13 of 94 HP |
| 14 | common | 89 / 28 / 21 | 5 | 16 of 124 HP |
| 14 | elite | 178 / 30 / 23 | 9 | 18 of 124 HP |
| 14 | boss (party 4) | 427 / 31 / 24 | 23 | 19 of 124 HP |
| 17 | common | 116 / 37 / 27 | 5 | 22 of 154 HP |
| 17 | elite | 232 / 39 / 29 | 11 | 24 of 154 HP |
| 17 | boss (party 4) | 557 / 40 / 30 | 26 | 25 of 154 HP |
| 19 | common | 134 / 43 / 31 | 6 | 26 of 174 HP |
| 19 | elite | 268 / 45 / 33 | 11 | 28 of 174 HP |
| 19 | boss (party 4) | 643 / 46 / 34 | 27 | 29 of 174 HP |

Before the rebalance the same rows read 58–114 HP commons, 8–16 damage a hit and 22–29 Kael hits for a boss — the party outgrew the template by level 14. XP and gold are unchanged (28 + 8 × level above 9), which is now the tightest open item here: the fights cost roughly twice the HP for the same reward.

- **New kit mechanics:**
  - **Steal** (Cutpurse): 60% damage plus 8–20 shared gold. A beaten Cutpurse returns what it took at victory.
  - **Heal ally** (Field Surgeon): 30 HP to the most-hurt ally, only while some ally is below 60% HP.
  - **Buffer elite** (Crown Sergeant Rally): +20% ATK to his side for 3 rounds, only with allies.
  - **Two-phase bosses** (Sanctuary Warden, Blackwood Matriarch): the shift happens at 50% HP and plays `trans`, then `idle_p2` / `attack_p2`. Warden +20% ATK; Matriarch +25% ATK and +20% SPD. Their phase lines are mine.
  - **Yield-or-death** (Commander Hailen): he yields only if `flag_hailen_yields` is set (no story sets it yet). Otherwise he dies. A yield sets `flag_hailen_yielded`.
  - **Blind** (70%, 3 rounds): physical attacks miss 50% of the time.
  - **Sleep** (50%, 2 rounds): the turn is skipped, any damage wakes, and sleeping does not count as taking a turn for XP.
  - Moth dust and the wisp mote fly on cast frame 3. Blind and sleep show as "Bl" / "Sl" in the party window, because the status strip has no frames for them.
  - **Shade Stalker Fade:** for the rest of the round, physical attacks against it miss; drawn at 40% alpha.
  - **Calder idle_p2:** the stance plays once, then `idle_p2` loops (already in place).
- **Boss groups (from Design's mockups):** Debtman + Dock Thug; Warden + Ward Sentinel; Hailen + Garrison Pikeman; Matriarch + Shade Stalker. The Crown Sergeant also appears in the Wrenfield table.
- **blackwood_matriarch is a PLACEHOLDER boss** (Design's proposal, not canon); its name, role and kit wait on Kevin. **lost_one** is a revise-friendly id; its concept may change.
- **Weaknesses** (placeholders): Crown / Garrison troops lightning; Aethari constructs lightning; Briar Hulk and Moths fire; Shade Stalker, Lost One and Matriarch holy. No party skill has an element yet.
- **Open:** Design still needs status icons for blind and sleep.

## Balance pass (feature/balance-pass; pending owner approval)
Every number here is a PLACEHOLDER chosen with `tools/balance_sim.py` (run `python3 tools/balance_sim.py`; it mirrors the GML damage formula, Guard, buffs, SPD order, and enemy AI weights). Targets from the brief: Act II winnable at levels 8–10, Reeve Calder ≈ 8–15 party turns, Occupation Soldiers ≈ 3–5 hits, Chapter 1 unchanged.
- **Party growth is tiered.** Level-ups into levels 2–7 keep the Chapter 1 numbers (+4 HP, +1 ATK, +1 DEF, +2 MP, +1 SPD, +1 MDEF). Level-ups into level 8 and above give +10 HP, +2 ATK, +2 DEF, +3 MP, +1 SPD, +1 MDEF (`LEVEL_UP_TIER_LEVEL`, `LEVEL_UP_*_GROWTH_HIGH`). Chapter 1 is levels 1–7, so its numbers and the Blackguard fight are unchanged. Old saves keep their stored HP / ATK / DEF; their MP / SPD / MDEF use the tiered totals.
- **Gear curve.** End of Chapter 1: Kael ATK +5 (Blackguard's Longsword), DEF +3 (Leather Armor + Iron Helm). Taren joins with the Bastard Sword (ATK +3) and a new **Travel Brigandine** (DEF +2, not sellable). Len sells **Chain Mail** (DEF +4, 220 g) as the Chapter 2 mid-tier item, after the rescue, so the Calder fight does not depend on it.
- **Taren joins at Kael's level** (`scr_actor_raise_to_level`, used by the Chapter 2 wiring). The sim assumes both are the same level.
- **Act II enemies, lowered from Design's suggestions** (HP / ATK / DEF): Crown Patrolman 44 / 13 / 12 (was 90 / 16 / 12), Crown Crossbowman 36 / 14 / 8 (70 / 18 / 8), Occupation Soldier 50 / 12 / 14 (120 / 17 / 16), Bandit Veteran 42 / 13 / 10 (95 / 18 / 11), Grey Ash Wolf 36 / 13 / 8 (80 / 20 / 8), Reeve Calder 130 / 15 / 16 (320 / 24 / 18). SPD, MDEF, XP and gold are unchanged. Calder's stance (+25% ATK, +15% DEF) is unchanged.
- **Millhaven Road groups stop at 2**, because Kael walks it alone (Taren joins at the Calder fight). The 3-enemy Crown group was replaced by a single Crossbowman. The Wrenfield table keeps its groups but is never rolled (no random battles in the village).
- **No in-battle healing exists** (no Item command yet), so every fight is balanced to be survivable on HP alone. **Open:** add an in-battle Item command, which would make the level-8 Calder fight easier.
- **MP recovery:** +2 MP after each win (kept). **Ether** restores 10 MP (60 g; Len's shop and a Millhaven Road chest). The **Wrenfield inn** (The Bent Post, Perrin) costs **30 g** and restores HP and MP for the active party and reserve. All placeholders.
- **Calder's yield (placeholder rule):** if Calder yields while soldiers still stand, they withdraw, but their XP is credited at the moment of the yield to the members who took a turn and are standing, and their gold is added at victory.

Simulated results, 4,000 runs per row. Policy: Taren opens with Rallying Cry, Cleaves while 2+ enemies stand, and otherwise everyone hits the weakest add first, then Calder. No Guard, no items. "Turns on Calder" counts party actions that damaged him (Cleave split across targets).

| Fight | Lv | Party | Win % | Rounds | Party turns | Turns on Calder | Party HP left |
|---|---|---|---|---|---|---|---|
| Millhaven: 1 Patrolman | 8 | Kael | 100% | 4.0 | 4.0 | — | 71% |
| Millhaven: Patrolman + Crossbowman | 8 | Kael | 100% | 7.0 | 7.0 | — | 17% |
| Millhaven: 2 Bandit Veterans | 8 | Kael | 100% | 6.0 | 6.0 | — | 23% |
| Millhaven: 2 Grey Ash Wolves | 8 | Kael | 100% | 6.0 | 6.0 | — | 22% |
| Calder + 2 Occupation Soldiers | 8 | Kael+Taren | 25% | 11.7 | 22.2 | 13.9 | 13% |
| Millhaven: 1 Patrolman | 9 | Kael | 100% | 3.4 | 3.4 | — | 83% |
| Millhaven: Patrolman + Crossbowman | 9 | Kael | 100% | 6.5 | 6.5 | — | 41% |
| Millhaven: 2 Bandit Veterans | 9 | Kael | 100% | 6.0 | 6.0 | — | 43% |
| Millhaven: 2 Grey Ash Wolves | 9 | Kael | 100% | 6.0 | 6.0 | — | 42% |
| Calder + 2 Occupation Soldiers | 9 | Kael+Taren | 94% | 10.2 | 19.1 | 11.3 | 27% |
| Millhaven: 1 Patrolman | 10 | Kael | 100% | 3.0 | 3.0 | — | 89% |
| Millhaven: Patrolman + Crossbowman | 10 | Kael | 100% | 5.0 | 5.0 | — | 71% |
| Millhaven: 2 Bandit Veterans | 10 | Kael | 100% | 6.0 | 6.0 | — | 58% |
| Millhaven: 2 Grey Ash Wolves | 10 | Kael | 100% | 4.0 | 4.0 | — | 71% |
| Calder + 2 Occupation Soldiers | 10 | Kael+Taren | 100% | 8.2 | 16.0 | 9.6 | 54% |

| Level | Kael ATK / DEF / HP | Taren ATK / DEF / HP | Hits (Kael) to kill: Occ. Soldier | Patrolman | Crossbowman | Bandit Vet. | Grey Wolf | Calder (pre-stance) |
|---|---|---|---|---|---|---|---|---|
| 7 | 17 / 11 / 54 | 17 / 11 / 60 | 5 | 4 | 3 | 4 | 3 | 15 |
| 8 | 19 / 13 / 64 | 19 / 13 / 70 | 5 | 4 | 3 | 3 | 3 | 12 |
| 9 | 21 / 15 / 74 | 21 / 15 / 80 | 4 | 3 | 3 | 3 | 3 | 10 |
| 10 | 23 / 17 / 84 | 23 / 17 / 90 | 4 | 3 | 2 | 3 | 2 | 9 |

Reading: at level 8 the Calder fight is hard (about 25% for this naive policy); at 9 it is about 94%; at 10 it is reliable. Calder takes about 10–14 party turns, inside the 8–15 target. Occupation Soldiers take 4–5 Kael hits at levels 8–10. Kael alone clears every Millhaven Road group from level 8.

## Chapter 3 balance check (`feature/chapter3`; PLACEHOLDER)
`python3 tools/balance_sim.py` now also prints these rows (the `c3_tables()` block at the end of the run; the Chapter 2 tables above are unchanged). The sim models the current battle code: criticals (5% base, Cutthroat +15%, ×1.5), Kael's Last Stand below 25% HP, bleed at 6% max HP per round, the Debtman's Bind (Slow, SPD ×0.5, 70% for 2 rounds), Collect drain, his stance when the adds fall (+30% ATK / +30% SPD) and his yield at 0 HP ending the fight with adds still standing (same rule as Calder).

**Assumptions (mine; change freely):**
- Party on Valemere Road is Kael + Taren. Lyra joins only for the Debtman fight, at Kael's level, with the Twin Daggers (+2 ATK) and **no armour**, as `scr_ch3_lyra_join` does.
- Chapter 3 gear assumes Len's **Chain Mail** (+4 DEF, 220 g) is bought for both Kael (with the Iron Helm, so DEF +5) and Taren (DEF +4). Without it, knock about 2 DEF off each and expect a few more rounds and a lower win rate.
- Enemy stats are exactly `scr_enemy_scaled`: Dock Thug common 11 (62 / 19 / 15), Debt Collector elite 12 (142 / 24 / 19), Debtman boss 12 for a party of 3 (**256** HP / 25 ATK / 20 DEF, SPD 12). `grp_debtman` is the Debtman + a Dock Thug + a Debt Collector.
- Policy: Taren opens with Rallying Cry and Cleaves while 2+ enemies stand; Lyra opens with Open Vein on the Debtman (bleed) then Twin Cuts while MP lasts; everyone focuses the **Debtman first** while he stands, because his stance punishes clearing the adds first. No Guard, no items. 4,000 runs per row.

| Fight | Lv | Party | Win % | Rounds | Party turns | Turns on Debtman | Party HP left |
|---|---|---|---|---|---|---|---|
| Valemere Rd: Patrolman | 10 | Kael+Taren | 100% | 2.0 | 4.0 | — | 96% |
| Valemere Rd: Crossbowman | 10 | Kael+Taren | 100% | 2.0 | 3.9 | — | 95% |
| Valemere Rd: Bandit Veteran | 10 | Kael+Taren | 100% | 2.9 | 4.9 | — | 89% |
| Valemere Rd: Patrolman + Crossbowman | 10 | Kael+Taren | 100% | 3.1 | 6.1 | — | 87% |
| Valemere Rd: Veteran + Patrolman | 10 | Kael+Taren | 100% | 3.9 | 7.1 | — | 79% |
| Debtman + Dock Thug + Debt Collector | 10 | Kael+Taren+Lyra | 70% | 6.0 | 16.6 | 15.0 | 7% |
| Valemere Rd: Patrolman | 11 | Kael+Taren | 100% | 2.0 | 3.9 | — | 97% |
| Valemere Rd: Crossbowman | 11 | Kael+Taren | 100% | 2.0 | 3.0 | — | 96% |
| Valemere Rd: Bandit Veteran | 11 | Kael+Taren | 100% | 2.0 | 4.0 | — | 95% |
| Valemere Rd: Patrolman + Crossbowman | 11 | Kael+Taren | 100% | 3.0 | 5.9 | — | 90% |
| Valemere Rd: Veteran + Patrolman | 11 | Kael+Taren | 100% | 3.2 | 6.3 | — | 86% |
| Debtman + Dock Thug + Debt Collector | 11 | Kael+Taren+Lyra | 99% | 5.3 | 15.5 | 13.4 | 28% |
| Valemere Rd: Patrolman | 12 | Kael+Taren | 100% | 2.0 | 3.9 | — | 98% |
| Valemere Rd: Crossbowman | 12 | Kael+Taren | 100% | 2.0 | 3.0 | — | 97% |
| Valemere Rd: Bandit Veteran | 12 | Kael+Taren | 100% | 2.0 | 4.0 | — | 96% |
| Valemere Rd: Patrolman + Crossbowman | 12 | Kael+Taren | 100% | 3.0 | 5.3 | — | 92% |
| Valemere Rd: Veteran + Patrolman | 12 | Kael+Taren | 100% | 3.0 | 6.0 | — | 90% |
| Debtman + Dock Thug + Debt Collector | 12 | Kael+Taren+Lyra | 100% | 4.8 | 14.3 | 12.0 | 45% |

| Level | Kael ATK / DEF / HP | Taren ATK / DEF / HP | Lyra ATK / DEF / HP | Hits to kill: Debtman (K/T/L) | Dock Thug (K/T/L) | Debt Collector (K/T/L) |
|---|---|---|---|---|---|---|
| 10 | 23 / 19 / 84 | 23 / 19 / 90 | 21 / 13 / 78 | 20/20/24 | 4/4/5 | 11/11/12 |
| 11 | 25 / 21 / 94 | 25 / 21 / 100 | 23 / 15 / 88 | 18/18/20 | 4/4/4 | 9/9/11 |
| 12 | 27 / 23 / 104 | 27 / 23 / 110 | 25 / 17 / 98 | 16/16/18 | 4/4/4 | 8/8/9 |

**Reading:**
- **The Debtman fight works, and the 2026-11-15 template rebalance tightened it.** 71% at level 10 (the party crawls out on 7% HP), 99% at 11 (28%) and 100% at 12 (45%) — the same band-bottom-is-hard, one-level-and-it-flips shape as Calder. He runs 5–6 rounds and about 14–17 party turns, 12–15 of them on him, which is inside the 8–15 Calder target now that his boss HP is 256 rather than 293.
- **Focusing the Debtman first is correct.** His stance (+30% ATK / +30% SPD) fires when his adds fall, so killing the Dock Thug and Debt Collector first makes the fight strictly harder. Worth a line in the heist's fight text if the intent is for players to learn that.
- **The Valemere Road is currently harmless.** Every table entry wins 100% in 2–3 rounds with 93–99% HP left at levels 10–12, because Kael and Taren now two- or three-shot the level-11 commons. The road pays 26–32 XP per Crown or Veteran enemy and only 6 for the plain Bandit (54 for a Patrolman + Crossbowman, 38 for a Veteran + Bandit), so going from 10 to 11 (`scr_xp_for_level` 1710 → 2100, 390 XP) takes roughly seven to ten fights. If the road should cost anything, the table needs a three-enemy group, a higher band (11–13), or both — **that is a data change and was not made here.**
- **Bind and Collect barely register** at these levels: a 2-round Slow on one member and about 13 HP of drain do not change the outcome, so the Debtman's flavour is carried by his HP and Hook Reel rather than by his status.
- Still unverified in the engine: these are simulation numbers only. The Debtman fight has never been played, and the heist's night-lighting and dialogue timing are untested.

## Chapter 4–5 balance check (Hollow Sanctuary, Blackwood Road Garrison; PLACEHOLDER)
`python3 tools/balance_sim.py` prints these rows too (`ch45_tables()` and `ch4_prejoin_table()`), using the same extended model plus magic damage (ATK vs **MDEF** instead of DEF), the two-phase boss shift at 50% HP, the Field Surgeon's 30 HP heal when an ally is below 60% HP, and Caelan's approved elemental kit (magic 1.2× / 1.35×, ×1.5 on a matching weakness).

**Assumptions (mine; change freely):**
- Party is Kael + Taren + Lyra + **Caelan** — Caelan joins at the Warden fight (ACT2_OUTLINE §3, CHAPTER4_SCRIPT.md §6). Sera is still held as a deserter until the garrison recruitment, so she is **not** in either fight, including Hailen's.
- Caelan joins at Kael's level with **no armour** and the statless spellbook (ATK +0), and **casts**: Arc Bolt (5 MP, 1.35× magic), Frost Lance / Ember (4 MP, 1.2×). He picks a spell that matches the target's weakness when one exists, otherwise Arc Bolt. 16 MP is about three casts, then he attacks. The spell names are approved; every number here is a PLACEHOLDER.
- Gear is unchanged from Chapter 3: there are no Chapter 4/5 shops or gear upgrades in the data yet.
- Levels simulated: 13–15 for the Sanctuary (approved band 13–16) and 16–18 for the garrison (16–18).
- Enemy stats are exactly `scr_enemy_scaled` plus the two balance passes below: common 14 = 89 / 28 / 21, elite 15 = 196 / 33 / 25; Warden boss 16 for a party of 4 = **514 HP / 37 ATK / 28 DEF / SPD 8 base**, tuned with `hp_mult: 1.25` and `atk_add: 2` → **~643 HP / 39 ATK**; Garrison Pikeman 16 = **107 / 38 / 25** (`atk_add: 4`); elite Knight 17 = 232 / 39 / 29; Hailen boss 18 for 4 = **600 HP / 43 ATK / 32 DEF / SPD 12 base**, tuned with `hp_mult: 1.5` and `atk_add: 14` → **900 HP / 57 ATK**. Hailen does not yield here — nothing sets `flag_hailen_yields` — so he fights to the death.
- Policy: weakest enemy first, Taren opens with Rallying Cry then Cleaves, Lyra opens Open Vein then Twin Cuts, Caelan casts (above), Kael attacks.

**Hollow Sanctuary (Chapter 4)** — four members, Caelan joins at the Warden

| Fight | Lv | Win % | Rounds | Party turns | Turns on Warden | Party HP left |
|---|---|---|---|---|---|---|
| Sanctuary: Sentinel + Wisp | 13 | 100% | 2.0 | 7.7 | — | 94% |
| Sanctuary: 2 Wisps + Sentinel | 13 | 100% | 3.0 | 11.1 | — | 85% |
| Sanctuary: Automaton + Wisp | 13 | 100% | 3.0 | 11.1 | — | 88% |
| Sanctuary Warden + Ward Sentinel | 13 | 35% | 8.2 | 27.8 | 26.1 | 13% |
| Sanctuary: Sentinel + Wisp | 14 | 100% | 2.0 | 7.7 | — | 95% |
| Sanctuary: 2 Wisps + Sentinel | 14 | 100% | 3.0 | 10.3 | — | 87% |
| Sanctuary: Automaton + Wisp | 14 | 100% | 3.0 | 10.5 | — | 89% |
| Sanctuary Warden + Ward Sentinel | 14 | 71% | 7.4 | 26.0 | 24.3 | 20% |
| Sanctuary: Sentinel + Wisp | 15 | 100% | 2.0 | 7.4 | — | 97% |
| Sanctuary: 2 Wisps + Sentinel | 15 | 100% | 2.7 | 9.4 | — | 91% |
| Sanctuary: Automaton + Wisp | 15 | 100% | 3.0 | 9.5 | — | 92% |
| Sanctuary Warden + Ward Sentinel | 15 | 94% | 6.7 | 24.6 | 22.7 | 29% |

**Blackwood Road Garrison (Chapter 5)**

| Fight | Lv | Win % | Rounds | Party turns | Turns on Hailen | Party HP left |
|---|---|---|---|---|---|---|
| Garrison: Pikeman + Surgeon | 16 | 100% | 2.7 | 8.7 | — | 89% |
| Garrison: 2 Pikemen + Surgeon | 16 | 100% | 3.0 | 11.7 | — | 79% |
| Garrison: Knight + Surgeon | 16 | 100% | 3.6 | 12.6 | — | 88% |
| Hailen + Garrison Pikeman | 16 | 52% | 9.1 | 29.7 | 28.0 | 14% |
| Garrison: Pikeman + Surgeon | 17 | 100% | 2.0 | 7.8 | — | 94% |
| Garrison: 2 Pikemen + Surgeon | 17 | 100% | 3.0 | 11.3 | — | 84% |
| Garrison: Knight + Surgeon | 17 | 100% | 3.1 | 11.4 | — | 92% |
| Hailen + Garrison Pikeman | 17 | 78% | 8.7 | 28.5 | 26.6 | 21% |
| Garrison: Pikeman + Surgeon | 18 | 100% | 2.0 | 7.6 | — | 95% |
| Garrison: 2 Pikemen + Surgeon | 18 | 100% | 3.0 | 11.1 | — | 86% |
| Garrison: Knight + Surgeon | 18 | 100% | 3.0 | 10.9 | — | 93% |
| Hailen + Garrison Pikeman | 18 | 94% | 8.1 | 27.9 | 25.6 | 30% |

**Hollow Sanctuary before Caelan (Chapter 4)** — Kael + Taren + Lyra, three members

| Fight | Lv | Win % | Rounds | Party turns | Party HP left |
|---|---|---|---|---|---|
| Sanctuary: Sentinel + Wisp | 13 | 100% | 3.0 | 8.2 | 84% |
| Sanctuary: 2 Wisps + Sentinel | 13 | 100% | 4.5 | 12.3 | 63% |
| Sanctuary: Automaton + Wisp | 13 | 100% | 4.9 | 13.2 | 68% |
| Sanctuary: 1 Sentinel | 13 | 100% | 2.0 | 5.2 | 95% |
| Sanctuary: 2 Wisps | 13 | 100% | 3.0 | 7.2 | 81% |
| Sanctuary: Sentinel + Wisp | 14 | 100% | 3.0 | 8.1 | 86% |
| Sanctuary: 2 Wisps + Sentinel | 14 | 100% | 4.0 | 10.8 | 70% |
| Sanctuary: Automaton + Wisp | 14 | 100% | 4.3 | 12.2 | 75% |
| Sanctuary: 1 Sentinel | 14 | 100% | 2.0 | 5.1 | 96% |
| Sanctuary: 2 Wisps | 14 | 100% | 2.9 | 7.0 | 83% |
| Sanctuary: Sentinel + Wisp | 15 | 100% | 3.0 | 7.7 | 87% |
| Sanctuary: 2 Wisps + Sentinel | 15 | 100% | 3.9 | 9.9 | 74% |
| Sanctuary: Automaton + Wisp | 15 | 100% | 4.0 | 11.1 | 80% |
| Sanctuary: 1 Sentinel | 15 | 100% | 2.0 | 4.9 | 96% |
| Sanctuary: 2 Wisps | 15 | 100% | 2.9 | 6.9 | 85% |

| Level | Kael ATK/DEF/HP | Taren ATK/DEF/HP | Lyra ATK/DEF/HP | Caelan ATK/DEF/HP | Hits to kill Warden (K/T/L/C) | Hits to kill Hailen (K/T/L/C) |
|---|---|---|---|---|---|---|
| 13 | 29 / 25 / 114 | 29 / 25 / 120 | 27 / 19 / 108 | 26 / 19 / 106 | 43/43/50/54 | 70/70/82/90 |
| 14 | 31 / 27 / 124 | 31 / 27 / 130 | 29 / 21 / 118 | 28 / 21 / 116 | 38/38/43/46 | 60/60/70/75 |
| 15 | 33 / 29 / 134 | 33 / 29 / 140 | 31 / 23 / 128 | 30 / 23 / 126 | 34/34/38/41 | 53/53/60/65 |
| 16 | 35 / 31 / 144 | 35 / 31 / 150 | 33 / 25 / 138 | 32 / 25 / 136 | 31/31/34/36 | 48/48/53/57 |
| 17 | 37 / 33 / 154 | 37 / 33 / 160 | 35 / 27 / 148 | 34 / 27 / 146 | 28/28/31/33 | 43/43/48/50 |
| 18 | 39 / 35 / 164 | 39 / 35 / 170 | 37 / 29 / 158 | 36 / 29 / 156 | 26/26/28/30 | 40/40/43/45 |

**Reading:**
- **The Warden is a wall again, tuned for Caelan's kit.** 35% at 13, 71% at 14, 94% at 15; 6.7–8.2 rounds, 24–28 party turns, 13–29% HP left. That is close to the shape recorded before Caelan could cast (27/61/89), without restoring the 27% floor — a mandatory story boss at level 13 should be dangerous, not a coin flip. The knob is `hp_mult`; `atk_add: 2` only keeps his ring relevant.
- **The three-member stretch is safe at the band floor.** All five groups at levels 13–15 are 100% wins; a two-enemy group costs 13–16% of party HP and the three-enemy group 26–37% (63–68% left), which is in the intended 20–25% random-fight shape. At level 11 the same groups still win but leave 40–72% HP, and at 10 the three-enemy group drops to 88% with 21% left — so the halls punish only a party that arrives two levels under the approved band. No pre-join table split was needed.
- **Hailen was the Chapter 5 problem, and he took length rather than damage.** With Caelan casting he was 97/100/100% at 16/17/18 — the fight ended in 6–7 rounds before his single-target hits added up. `hp_mult: 1.5` + `atk_add: 14` (**900 HP / 57 ATK**) gives **52 / 78 / 94%** at 16/17/18, 8.1–9.1 rounds and 14–30% party HP left. Pushing ATK instead was much less useful: at 900 HP, ATK 65 still won 78% at 18 but crashed level 16 to 16%, which is the wrong shape — HP moves the level-16 row without making the fight a coin flip at 18.
- **The garrison's random fights were slightly light, so the Pikeman got +4 ATK** (34 → 38). The two-pikeman group now costs 21% of party HP at level 16 instead of 18%; the single-pikeman and Knight groups stay at 11–12%, which is fine for a two-enemy draw. Nothing here can wipe the party (100% at every level).
- **The Warden's ring is the only enemy magic in the game**, and it is where MDEF matters: about 20 damage to the whole party per cast, and the main source of HP loss in that fight. Hailen is the opposite — pure single-target pressure.
- **Caelan is no longer dead weight.** Magic damage (Arc Bolt 1.35×, Frost Lance / Ember 1.2×) plus ×1.5 on the Sentinel, Automaton, Pikeman and Knight lightning weakness is why both bosses needed tuning at all.
- Simulation only: the Chapter 5 garrison rooms and script are still unwritten, and **nothing in Chapter 4 or 5 has been played in GameMaker**. These are model numbers.

## Act III balance check (Blackwood, Chapters 6–8; PROPOSED numbers)
`python3 tools/balance_sim.py` prints these rows too (`ch6_tables()`), on the same model plus the Blackwood kits as coded: Fade (attacks miss until the next round), Blinding Dust (70%, 50% physical miss for three rounds), Drowsy Dust (50%, two turns skipped), the Matriarch's two phases with Ash Breath (0.8× to the whole party, doubled weight in phase 2), and Sera's Mend (+30, 4 MP) and Smite (1.3× holy, ×1.5 on a holy-weak target). The party is Kael / Taren / Lyra with Caelan, and again with Sera, in Chapter 5 gear — there are no Act III weapons or armour in the item data. Sera joins at 28 HP / 4 ATK / 4 DEF with the Holy Sword, which carries `atk_bonus: 0`.

Enemy stats are exactly `scr_enemy_scaled`: level 18 = 125 / 40 / 29 / MDEF 15, 19 = 134 / 43 / 31 / 16, 20 = 143 / 46 / 33 / 17. The Act III bosses are those entries re-scaled as bosses (the data change the outline proposes), plus the Matriarch as it is already written.

**As specced — every fight won, none of them a threat (party of four with Caelan):**

| Fight | Lv | Win % | Rounds | Party turns | Deaths | Party HP left |
|---|---|---|---|---|---|---|
| Burn-Line Hulk, alone (HP ×1.0) | 18 | 100% | 5.1 | 19.0 | 0.01 | 74% |
| Burn-Line Hulk, alone (HP ×1.0) | 20 | 100% | 4.8 | 17.0 | 0.00 | 79% |
| Blackwood Matriarch (HP ×1.0) | 19 | 100% | 5.0 | 17.7 | 0.16 | 47% |
| Blackwood Matriarch (HP ×1.0) | 20 | 100% | 4.8 | 16.9 | 0.05 | 54% |
| Door Warden + 2 Sentinels (**level 14, as data**) | 20 | 100% | 4.7 | 16.8 | 0.00 | 78% |
| Door Warden + 2 Sentinels (level 20) | 20 | 100% | 5.2 | 20.2 | 0.08 | 57% |

With Sera in for Caelan the same fights run 0.5–1.5 rounds longer and finish a little worse off (Matriarch 5.6 rounds / 47% left / 0.05 deaths), because she spends turns healing rather than casting.

**Hulk what-ifs (level 18, ATK variants; it has one target and no AoE):**

| Variant | Win % | Rounds | Deaths | Party HP left |
|---|---|---|---|---|
| HP ×1.5, ATK +8 | 100% | 7.1 | 0.35 | 52% |
| HP ×1.5, ATK +12 | 100% | 7.2 | 0.63 | 46% |
| HP ×1.0, ATK +12 | 100% | 5.2 | 0.19 | 63% |
| HP ×2.0, ATK +8 | 99% | 8.6 | 0.66 | 41% |
| HP ×1.5, ATK +12, **+ 2 Shade Stalkers** | 88% | 8.4 | 1.29 | 22% |
| HP ×1.0, + 2 Shade Stalkers | 100% | 6.7 | 0.18 | 50% |

**Boss HP sweep (chapter level, party of four with Caelan):**

| Fight | HP ×1.0 | ×1.5 | ×2.0 | ×2.5 |
|---|---|---|---|---|
| Burn-Line Hulk (18) | 100% / 5.1 r | 100% / 7.0 r | 100% / 8.4 r | 100% / 9.6 r |
| Matriarch (19) | 100% / 5.0 r | 91% / 6.7 r | 56% / 8.3 r | 32% / 9.3 r |
| Warden + 2 L20 Sentinels (20) | 100% / 5.2 r | 100% / 7.0 r | 96% / 8.2 r | 75% / 9.2 r |

- **Recommendation:** Hulk ×1.5 HP / +12 ATK with two Shade Stalkers (88%, 8.4 rounds, 1.3 deaths); Matriarch ×1.5 HP (91–92%, 6.7–7.6 rounds, ~1 death); Warden ×2.0 HP with two **level-20** Sentinels (96–99%, 8.2–10.3 rounds, ~1 death). Those are the numbers now written into `ACT3_OUTLINE.md` §7.
- **The Hulk cannot be made dangerous with HP.** At ×2.5 it still lost 0 of 2000 runs. Its threat has to come from ATK and from adds.
- **The Matriarch is the only boss that scales with HP**, because Ash Breath hits all four members; it is also the only fight where the party can plausibly lose someone (1.0 death at ×1.5).
- **Sentinels must be level 20.** As level-14 commons they die in a single hit: 78% HP left and no chance of a loss.
- **Sera's Smite is weaker than expected.** Against the holy-weak Matriarch at ×1.5 she wins 92% in 7.6 rounds; with a hypothetical +6 ATK Holy Sword, 93% in 7.3. Caelan's party does 91% in 6.7. Her real contribution is Mend, not the holy weakness.
- **Level 20 is comfortable everywhere**, which supports the cap raise to 24 — and means Act IV's numbers must exceed this curve rather than inherit it.
- **Not verified:** simulation only. No Act III fight has been played, and the sim assumes the four-member party always focuses the boss, never uses items (there is no in-battle Item command) and never retreats.

**Applied to the data (2026-11-16).** The tuned entries are now in `scr_enemy_database.gml`, so the sim's Act III rows re-measure exactly what ships:

| Fight (group) | Lv | Party | Win % | Rounds | Deaths | Party HP left |
|---|---|---|---|---|---|---|
| `grp_burn_line_hulk`: Hulk + 1 Stalker | 18 | with Caelan | 100% | 7.6 | 0.44 | 42% |
| `grp_burn_line_hulk`: Hulk + 1 Stalker | 18 | with Sera | 100% | 9.6 | 0.05 | 50% |
| `grp_blackwood_matriarch`: Matriarch + Stalker | 19 | with Caelan | 97% | 7.3 | 0.77 | 26% |
| `grp_blackwood_matriarch`: Matriarch + Stalker | 19 | with Sera | 97% | 8.3 | 0.29 | 30% |
| `grp_door_warden_boss`: Warden + 2 Sentinels | 20 | with Caelan | 96% | 8.2 | 1.02 | 24% |
| `grp_door_warden_boss`: Warden + 2 Sentinels | 20 | with Sera | 99% | 10.3 | 0.51 | 26% |

- New entries: **`burn_line_hulk`** (boss 18, 1260 HP / 55 ATK / 32 DEF, fire-weak — briar_hulk at boss scale with `hp_mult: 2.1` and `atk_add: 12`), **`door_warden_boss`** (boss 19, 1286 HP / 46 ATK / 37 DEF, lightning-weak, `hp_mult: 2.0`), **`ward_sentinel_late`** (common 20, 143 / 46 / 36, lightning-weak). `blackwood_matriarch` gained `hp_mult: 1.5`.
- Groups: `grp_burn_line_hulk` (one Shade Stalker — two made the opening boss harder than the second), `grp_door_warden_boss` (two level-20 Sentinels). `grp_blackwood_matriarch` was already there and keeps its one Stalker.
- The new ids reuse the base creature's battle art (`scr_sprites.gml` maps them), so nothing draws a missing-sprite plate. The Bestiary goes 33 → 35 entries: `burn_line_hulk` and `door_warden_boss` get rows (the latter named **The Door Warden** so it is not a second "Door Warden" beside the elite), while `ward_sentinel_late` shares the `ward_sentinel` row through `scr_bestiary_alias`, because it is the same creature at level 20.
- The difficulty ramp now climbs instead of starting at its peak: wins 100% → 97% → 96%, average deaths 0.44 → 0.77 → 1.02.
- At level 20 all three are 100% comfortable, which is the strongest argument in the file for the cap raise to 24.

## Chapter 5 script decisions (approved 2026-11-16)

All eleven items in `docs/story/CHAPTER5_SCRIPT.md` §14 were approved as recommended. The script is canon; the build has not started.

| # | Decision | Approved | Build consequence |
|---|---|---|---|
| 1 | Chapter title | **The Deserted Oath** | Title card, quest header, changelog and outline all use it. |
| 2 | Level band | **16–18** | Matches the `blackwood_garrison` table and Hailen at 18; the simulated curve already assumes it. No tuning needed. |
| 3 | Sera becomes controllable | **After the Hailen fight** | The boss stays a four-member fight, so 52 / 78 / 94% at 16 / 17 / 18 remains valid. Sera is the first reserve in the roster; the player picks who sits via Party Order, no forced bench. |
| 4 | Hailen's yield branch | **Pre-battle choice** | Sets `flag_hailen_yields` before initiative, using the existing `yields_if_flag` hook. Would be `scr_dialogue_choice`'s first chapter use; if that UI is not ready, the approved fallback is to set the flag unconditionally (Hailen always yields) rather than ship a dead branch. |
| 5 | Sera's starting kit | **Mend, Aegis, Smite** | Three new `scr_skill_data.gml` entries with PLACEHOLDER numbers; Smite uses the existing `holy` weakness. |
| 6 | Why the party gets inside | **They are not let in** | The sergeant's ledger holds Taren Holt's name and the gate closes behind them; the fight is a failed arrest, not an ambush. |
| 7 | The Blackwood lead | **Sealed Crown order, non-Crown seal** | Tells the post to stop looking; Caelan recognizes the mark and refuses to explain it. Act III inherits an unanswered mystery. |
| 8 | Fallen Knight's second line | **"The forest has already taken its share. It will want another."** | Names nothing, stays off Mira and the sealed order. |
| 9 | Chapter ending | **At the treeline** | `Q_BV_S7` active, act-complete card, quiet save prompt (church/tavern rule unchanged). |
| 10 | Rooms | **Two** (`rm_blackwood_garrison`, `rm_garrison_keep`) | Follows the Chapter 4 two-room build; markers for road, notice board, gate, yard, cells, office, records. |
| 11 | Sera's detention | **Awaiting transport, not sentenced** | Keeps the Crown's process vague and Hailen a tired officer following orders. |

**Rejected at approval:** Sera joining at the start of the Hailen fight (would invalidate the measured curve and force an unearned bench), Sera as a guest ally outside the four (needs new battle-engine support), Hailen always yielding or always dying, a 17–19 level band, a patrol map or Aethari token as the lead, "She went in further than the trees", a one-room garrison, and an execution sentence.

**Still open after approval:** all skill damage numbers (PLACEHOLDER), whether the reserve earns XP and whether story may force a bench (bible q36), what Sera saw in the palace (q4), the Fallen Knight's identity (q2), and everything the sealed order points at.

**Built 2026-11-16, unplaytested:** `rm_blackwood_garrison`, `rm_garrison_keep`, `scr_ch5_story` and `scr_dialogue_data_ch5` implement all eleven approvals as written. Two implementation readings worth recording: Sera's join plays on the keep doorway rather than a yard trigger (a story trigger latches after one attempt, so a gated trigger could dead-end), and the Hailen trigger is deliberately not consumed by a defeat so the fight can be replayed. Neither changes an approved decision.

## Prototype assumptions (battle upgrade; pending owner approval)
Built on `feature/battle-upgrade` (depends on PR #10). Every number below is a PLACEHOLDER unless marked canon. Owner-decided rules above (XP per enemy to living participants, defeat penalty, random encounters, Swap) are unchanged.
- **Canon used:** Taren's Rallying Cry (raises party Attack for 3 turns), Cleave (hits all enemies for reduced damage), Unbowed (passive, resists Fear and Stun) — STORY_BIBLE.md §5.5 / CHAPTER2_SCRIPT.md WF_CALDER_SYS. Reeve Calder's kit (Guard, a shout that buffs his soldiers, a heavy strike, a harder stance when the detachment falls, he yields and lives). Blackguard 450 HP / phases / Phase 3 SPD +30%.
- **New stats (placeholder base, then growth per level):** SPD / MDEF / MP — Kael 10 / 2 / 6, Lyra 14 / 2 / 6, Caelan 9 / 5 / 16, Sera 8 / 5 / 12, Taren 9 / 2 / 12. Level-up growth: +2 max MP, +1 SPD, +1 MDEF (on top of the existing +4 HP / +1 ATK / +1 DEF).
- **Turn order:** sorted by SPD each round (after all commands are chosen), tiebreak `random(0.99)`. Buffs and the Blackguard's speed mod count.
- **MDEF** is stored, saved, and grows, but no current skill deals magic damage, so it has no effect yet.
- **Skills (placeholder costs / percentages):** Rallying Cry 4 MP, +25% ATK to all living allies for 3 rounds (ticks at round start, so the cast round + 2). Cleave 3 MP, 60% of normal damage to each living enemy. Unbowed is implemented as a status resist; nothing inflicts Fear or Stun yet. Only Taren has skills; Kael / Lyra / Caelan / Sera have none (Skill hidden).
- **Elemental weakness:** ×1.5 damage (`BATTLE_WEAKNESS_MULTIPLIER`). Only Blackguard (holy), Ashbound Hunter (ice), Ash Wolf / Grey Ash Wolf (fire), and the Crown troops (lightning, placeholder) have one. No party skill has an element yet, so it never triggers in play.
- **MP recovery:** +2 MP per member after each victory (`BATTLE_VICTORY_MP_REGEN`), full MP on defeat respawn. There is no inn, Ether, or MP item — **open**.
- **Enemy AI weights (placeholder):** Chapter 1 specials keep their old odds (Howl / Scream 1 in 5, Web / Shield Wall 1 in 4, Blackguard per phase). Patrolman Attack 2 / Thrust 2 (×1.2) / Brace 1 (+50% DEF, 2 rounds, not while active). Crossbowman Bolt only. Occupation Soldier Attack 2 / Slash 2 (×1.1) / Guard 1. Bandit Veteran Attack. Grey Ash Wolf Attack 4 / Howl 1. Calder Heavy Strike 3 (×1.3) / Guard 1 / Rallying Shout 2 (6 MP of 20, +25% ATK to his side for 3 rounds, only while a soldier stands); alone: Heavy Strike 3 / Guard 1.
- **Calder stance:** +25% ATK and +15% DEF for the rest of the battle, once, when his last add falls. A system line ("Reeve Calder takes a harder stance!") replaces the bark; WF_CALDER_PHASE2_01 is left for the Chapter 2 dialogue task.
- **Calder yield:** at 0 HP he yields instead of dying (HP held at 1), the battle ends as a victory with his full XP / gold, and `flag_reeve_calder_yielded` is set. Soldiers still standing withdraw with no XP / gold — **open** (could instead require clearing the adds). `flag_execution_stopped` and the defeat dialogue are left for the Chapter 2 dialogue task.
- **Calder group:** boss + `CALDER_ADD_COUNT` (2) Occupation Soldiers (brief allowed 2–3). Formation slots (GUI coords, feet): 1 enemy (86, 118); 2 → (52, 112), (98, 124); 3 → (36, 108), (64, 120), (100, 126); boss (100, 124) with adds (30, 106), (52, 127), (14, 124).
- **Act II enemies:** Design's suggested HP / ATK / DEF / MDEF / SPD / XP / gold (not approved). Gold is rolled in `gold_min`–`gold_max`. Grey Ash Wolf MDEF 4 and gold 10–16 are mine (Design gave none). Crown "lightning" weakness is a placeholder.
- **Act II encounter stubs:** `ch2_millhaven_road` and `ch2_wrenfield` (level band 8–10) with single and group entries — weights are placeholders. No Act II rooms, zones, or dialogue are wired.
- **Act II battle backgrounds:** Wrenfield and the Calder fight reuse the Greyhaven background; Millhaven Road reuses the forest one until Design paints new ones.
- **Encounter level bands — four Act I tables out of band, Chapter 3 settled (2026-11-16).** `validate_gamemaker.py` now compares every encounter table against the band `scr_encounter_table_level_band` declares. Four Act I tables are one level under: `zone01_old_road`/`old_road` and `zone01_bandit_camp`/`bandit_camp` roll `bandit` (L1) in bands 2–3 and 3–4, and `zone01_watchtower`/`watchtower` plus `zone01_basement_hall` roll `fallen_knight` (L3) in band 4–7. That reads as deliberate weak filler and needs no change beyond a decision that a one-level tail is acceptable. **`ch3_valemere_road` was the real one and is now fixed:** its band is 10–13 but it rolled Act I/II enemies (`bandit` L1, `crown_patrolman` L8, `crown_crossbowman` L8, `bandit_veteran` L9), so the road fought two to nine levels under its own band. The table now spawns level-10/11 versions of the same creatures — `crown_patrolman_road`, `crown_crossbowman_road`, `bandit_veteran_road`, aliased onto the Act II Bestiary rows — which puts every road fight inside the band. `CHAPTER3_SCRIPT.md` §1 names Crown Patrols and Bandits on that road, so the creatures did not change, only their level. The road is still 100% winnable but no longer free: the hardest group goes from 2.0 to 3.9 rounds and 98% to 79% party HP left at level 10. `zone01_path` declares no band; that is fine for a fallback table, and the check reports it as a warning only.
- **Chapter 2 balance — open, needs tuning:** with placeholder growth, a level-9 Kael (ATK ~13 + gear) deals single-digit damage to Calder (DEF 18) and to Occupation Soldiers (DEF 16), so the fight would take ~40 hits. Either party growth, Chapter 2 gear, or Design's enemy DEF must change before Act II is playable.
- **Save schema v2:** members now save MP, max MP, base SPD / MDEF, skills, and passives. v1 saves are upgraded on load (level-scaled defaults, full MP). Buffs and statuses are battle-only and not saved.

## Prototype assumptions (Zone 1 overworld + sprites; pending owner approval)
These were chosen so Design's map and art could be wired into the existing prototype. None is a locked design decision.
- `rm_overworld` is the 400×300-tile Eldara hub (6400×4800 px) including Zone 1 "The Ashen Road" and Greyhaven. `rm_old_watchtower` is 60×45 tiles (960×720). Tile size is 16×16 (`TILE_SIZE`). The old 640×360 test layout is retired.
- Overworld uses the 16×24 Kael / Bandit sheets on that 16×16 grid. `PLAYER_MOVE_SPEED` is 1 (same tiles per second as the earlier speed of 2 on 32 px tiles). `PLAYER_INTERACT_REACH` is 4. Encounter steps are 16 pixels so "8–24 steps" still means 8–24 tiles.
- Town respawn is Greyhaven `town_square` (3192, 2832). The builder drops `obj_respawn_point` there. `player_start` is the south-road opening (199, 186) and is not the defeat wake-up tile.
- Y-sort with `depth = -y`. Overworld `left` is a pre-mirrored sheet; `image_xscale` stays 1. Battle party members are flipped with `xscale = -1` because battle strips only face right.
- Battle playback: idle 6 fps, attack/hurt/death 10 fps, drawn in Draw GUI at `BATTLE_SPRITE_SCALE` 2. Damage is applied at about 60% through the attack clip; a KO plays death instead of hurt and holds the last frame. Confirm skips the clip. There is no Guard pose in the art.
- Camera view 320×180, optionally displayed at 2× (640×360 window). `CAMERA_FOLLOW_PLAYER` is on. `scr_camera_follow_player` is defined once in `scr_map_tilemaps.gml` and called from `obj_game_controller` End Step. Overhead tiles use depth -10000 so they stay above a player that y-sorts with `depth = -y`.
- Greyhaven is safe (no encounter zone, no room-wide table). Other areas use the existing `obj_encounter_zone` API with tables `zone01_farmlands`, `zone01_old_road`, `zone01_bandit_camp`, `zone01_watchtower`. Only Bandit Camp and Watchtower opt into the `zone01_path` fallback (which includes Fallen Knights). Farmlands and the Old Road do not.
- Blackguard placeholder stats: 80 HP, 12 ATK, 8 DEF, 50 XP, 30 gold. Not balanced.
- Entrances to rooms that are not built yet (`rm_rimehold`, `rm_saltreach`, `rm_blackwood_doors`, `rm_flooded_ruins`, `rm_ashlands_breach`, and others) only show a placeholder dialogue line. Built rooms (`rm_old_watchtower`, `rm_watchtower_basement`, the Greyhaven interiors, and the Chapter 2–3 rooms and roads) open normally.
- A story-flag system and key-item inventory helpers exist (`scr_flag_get` / `scr_inventory_add`). The Tomas scene (`GH_TOMAS`, inside the Blacksmith), Mira's pendant (`GH_HOUSE_03`–`05` inside Varyn House, actually added to inventory), banner clue (`WT_BANNER`), Fallen Knight beats (`FK_01` / `FK_02`), arrival (`GH_ARRIVAL`), survivor talk (Hob, Ilse, Marda, Wenna, Dov, Corwin), `WB_CARVING`, `BG_INTRO` / `BG_DEFEAT`, and `CV_END` (after `blackguard_defeated`) are wired from Chapter 1 confirmed lines. Chapter 2 `[PROPOSED]` lines are not wired. Marda's store and Pell's forge (after the pendant) open a Buy / Sell / Exit shop overlay. The locked terrace stairs are blocked from below by a barrier marker on `flag_wt_upper_unlocked` (set by the Basement stairs; the old `watchtower_basement_cleared` name is retired).
- The guaranteed Ashbound Hunter fight (`enc_ashbound_hunter_wt`) is spawned in `rm_old_watchtower` on walkable tile (33, 33), on the way to `old_royal_banner` (41, 25). Interactables are fitted to one 16×16 tile so a 32×32 placeholder cannot cover the trigger. Rare Hunter rolls are allowed on `zone01_old_road`, `zone01_bandit_camp`, and `zone01_watchtower` (short ids `old_road` / `bandit_camp` / `watchtower` still work).
- Bandit overworld sheets are in the repo but not used by any object yet. There is no Fallen Knight overworld sheet. Battle assets are named `spr_hero_*`; overworld Kael is `spr_kael_ow*`.

### Placeholders still waiting on Kevin (story bible Open, or not implemented)
- Names of the Frostwilds settlement and the Drowned Coast village.
- Whether the new `royal_banner` / `carving_crown_sun` tiles and `spr_item_mira_pendant` match the confirmed crown-ringing-a-black-sun design (the tiles are in the Design drop; they have not been visually approved in GameMaker).
- Several chest loots (`hidden_grove_chest`, `watchtower_chest_2`, `watchtower_chest_3`).
- What lies past the Crownveil breach (`CV_END` is still a stub).
- PLACEHOLDER combat stats (not approved) exist for **ash_wolf**, **ashen_wretch**, **grave_spider**, and **hollow_soldier**, plus the Ashbound Hunter entry. Blackguard carries its canon 450 HP / three phases / 250 XP / 100 Gold. Battle strips for the new enemies exist (batch art); FL_TUTORIAL system lines are wired (systems pass). Chest loot marked `placeholder` is not invented. Official shop prices, Pell's final stock, and the 50% sell rate are PLACEHOLDER (open). Save-point tiles in the chapel and tavern are temporary (open). Battle poison is implemented (systems pass; inflictor and tick rule are PLACEHOLDERS).

## Prototype assumptions (exploration + battle prototype; pending owner approval)
These were chosen so roadmap steps 2–3 could be built. None is a locked design decision.
- Battle presentation: dedicated room `rm_battle_test` rather than an overlay.
- Input: arrows move; Z/Enter/Space confirm; X/Backspace cancel. Diagonal movement kept from the original snippet.
- Collision: `obj_solid` objects plus an optional tile layer named `Collision`; requires GameMaker 2023.1+.
- Placeholder sizes: player **16×24** (FF1-scale overworld, origin 8, 23) with a 16×16 standing-tile feet mask; room placeholders 16×16; rooms still **640×360**. 360 is not a multiple of 16 (22 tiles + 8 px). Battle battlers stay 32×48 side-view strips (death 48×48; Fallen Knight attack 64×48). A 32×48 overworld set exists as a fallback only.
- Party defaults and progression numbers: see "Prototype assumptions (party + progression)" above. Guard still halves incoming damage (min 1) until the party's next command phase.
- Fixed `obj_encounter_trigger` encounters are removed after victory for the session. Whether cleared triggers persist in saves is undecided. Random walking encounters are owner-decided (see above); they are not cleared after victory.
- Enemy HP is visible in battle for debugging; whether players see enemy HP is undecided.
- Chapter 1 overworld / Watchtower sign wording is C-confirmed (see CHAPTER1_SCRIPT.md). Battle messages and remaining inspect text (chests, Renn, unbuilt rooms) are still placeholders.
