# Playtest Runbook — compile and play Chapters 1–11 in GameMaker

This is the manual that turns the project from "built and validated" into "verified". It is ordered by **what fails first**, because the expensive mistakes happen early: a version mismatch can convert the project, and a missing resource can look like a code bug.

Nothing in this document has been run. No GameMaker IDE has ever opened this project. Budget roughly 6–10 hours for a first pass; Phase 1 is 30 minutes and tells you whether the rest is worth starting.

Every step has a **gate**: if it fails, stop, fix, and re-run from the top of that phase. Do not push on past a failed gate — later failures become unattributable.

---

## Phase 0 — Before you open anything (15 min)

1. **Record the environment.** GameMaker IDE version, runtime version, OS, and display scaling. Put them in `docs/TEST_PLAN.md` under "Automatic checks". Every bug report needs them.
2. **Back up the project folder** (copy `gamemaker/` somewhere outside the repo, or commit first). The IDE rewrites `.yy` files on save; you want a clean diff if it does.
3. **Confirm the repo is clean.** `git status --short` must be empty, so any change the IDE makes is visible afterwards.
4. **Run both checks from the repo root.** They must pass before you start, or you will be debugging the build and the content at once.
   - `python3 validate_gamemaker.py` → `ALL CHECKS PASSED`
   - `python3 tools/audit_chapters.py` → `No wiring problems found.`
5. **Read the known-issues list at the end of this file.** Those are expected; do not log them as new bugs.

---

## Phase 1 — Opening the project (this is where it breaks first)

### 1.1 Version gate — the single most likely failure
The project's `MetaData.IDEVersion` is **2024.14.4.222** (`gamemaker/AshenCrown.yyp`, line ~849). Use an IDE at **2024.14 or newer**.

- If your IDE is older, it offers to **upgrade/convert** the project. **Cancel.** Update the IDE first. Conversion is one-way and rewrites every `.yy`, which will bury any real bug under thousands of formatting diffs.
- If your IDE is much newer, expect a quieter save-time rewrite of resource versions. That is fine, but note it in the test plan.

Record the exact IDE/runtime pair. This is the value that makes every later bug report reproducible.

### 1.2 Project loads without resource errors
Open `gamemaker/AshenCrown.yyp`. The resource tree should show **34 rooms, 844 sprites, 95 scripts, 22 objects, 29 sounds**, with `rm_title` first in the room order.

Most likely failures here, in order:

| Symptom | Most likely cause | Fix |
|---|---|---|
| "Failed to load" naming a `.yy` in `rooms/rm_barrow_*` or `scripts/scr_ch11_*` / `scr_dialogue_data_ch1_extra` | A resource registered in the yyp but missing on disk, or a `.yy` with a bad `%Name`. The newest resources are the least battle-tested. | Re-run the generator that owns it (`tools/gen_ch11_rooms.py`, `tools/gen_ch11_dialogue.py`, `tools/gen_ch1_extra_dialogue.py`), then `validate_gamemaker.py`. Do not hand-edit the yyp. |
| Duplicate resource name | Two scripts/rooms with the same `name`. | `validate_gamemaker.py` reports duplicates; it should have caught it — re-run it. |
| A sprite opens with wrong size or origin | Import table origin mismatch (16×24 sprites are origin 8,23). | Compare against `game/sprites/IMPORT.md`; fix in `game/sprites/` and regenerate. |
| Sound fails to import | Missing `.wav` or unsupported bit depth. | Check `gamemaker/sounds/<name>/<name>.yy` → `soundFile` exists on disk. |

### 1.3 Compile (F5)
Expected: compiles clean, boots to `rm_title`, window opens.

The newest code is the likeliest place for a syntax error — check these first if the compiler names a script:

- `scr_dialogue_data_ch1_extra.gml` (generated this week) and its chain call in `scr_dialogue_data.gml`
- `scr_story.gml` → `scr_ch1_renn_talk`, `scr_ch1_renn_count_wolves`
- `scr_ch1_art.gml` → `scr_blackguard_phase_line` (it now calls `scr_dialogue_node`)
- `scr_quest_data.gml` → the `Q_SIDE_RENN` row
- `scr_map_markers_data.gml` → the Renn marker's new fields, and `scr_wf_markers_data.gml` → `from_valemere_road`
- `scr_ch11_story.gml`, `scr_dialogue_data_ch11.gml`, `scr_build_barrow_*.gml`

If the compiler names a **script that exists but is "not defined"**, the script is missing from the yyp — re-run the generator, don't add it by hand.

**Gate 1:** the project opens, compiles, and reaches the title screen with no error dialog. If it does not, stop here and report the first error verbatim.

---

## Phase 2 — Title, options, and first boot (20 min)

1. **Title screen draws** with its background and menu, and `snd_mus_*` plays.
2. **Options** — Music / Ambience / SFX adjust and **Mute** works. Change a value, quit, relaunch: it must persist (`ashen_settings.ini` is written next to the executable). This is unverified in engine.
3. **Continue** is disabled or empty with no save file. No crash on selecting it.
4. **New Game** starts. Expected: `rm_overworld`, camera at 320×180 shown 2×, Kael at the south-road `player_start` (tile 199,186).
5. **Look at the pixels and the title bar.** Every platform option file now has `interpolate_pixels` set to **false** and the product name set to **"Ashen Crown"**, so scaled art should be crisp and the window should not say "yyp-template". If either is wrong, the options tree has drifted again — re-run the options block of `gen_gamemaker.py` rather than fixing sprites one by one.

**Gate 2:** New Game reaches the overworld and the player moves.

---

## Phase 3 — Chapter 1, in the order a player hits it (2–3 h)

Do this chapter fully before touching later content: it is the only chapter with a complete art/audio pass, and most engine-level bugs surface here.

### 3.1 Movement, collision, interaction
- 8-way/4-way movement at `PLAYER_MOVE_SPEED` 1; no walking through walls, water, or the north-gate barrier.
- Y-sort looks right under trees/arches; overhead tiles stay above the player.
- Interact reach is 4 px: stand one tile away and press confirm — the prompt should still fire.
- Dialogue locks movement; cancel/Escape behaviour is sane; portraits show the right expression per line.

### 3.2 First guaranteed fight (`zone01_first_bandit`)
- Walking the farm path triggers `FL_TUTORIAL` — this fight cannot be skipped and no random battle should fire before it.
- Battle: command menu, Attack, Guard, Skills, Items all respond; turn order is visible; damage numbers land near the animation.
- **Victory** returns to the map, plays `FL_TUTORIAL_04`–`05` as post-battle lines, and **random encounters switch on** (`flag_tutorial_done`). If post-battle lines never appear, that is a real bug.
- Check XP/gold actually applied and the level-up message is readable.

### 3.3 Scripted Hunter and the parchment
- The Ashbound Hunter fight in `rm_old_watchtower` triggers once, and on victory the **Ashbound Parchment** enters key items and `ENC_AH_03`–`05` play.
- Lose deliberately once: the fight must be replayable and the parchment not missable.

### 3.4 Save and load (do this before any long session)
- Save at a crystal **inside** the Greyhaven chapel or tavern. Slots show chapter/level/playtime.
- Quit to title → Continue → correct slot → correct room, position, party HP/MP, inventory, gold, quests.
- Save mid-chapter, load, and confirm flags survived (e.g. tutorial done, pendant state).

### 3.5 Shops, chests, signs, barriers
- Marda's store: Buy / Sell / Exit, prices from the item DB, gold deducts, sell rate is 50%.
- Pell's forge opens after the pendant; stock differs.
- Chests open once and stay open after reload (`looted_*`).
- Signposts and lore objects show their text; the locked terrace barrier refuses until `flag_wt_upper_unlocked`.
- **Watch for the restored Chapter 1 lines**: `GH_GATE_SIGN`, the farm/camp/old-road/watchtower signs still render from the marker tables (`struck_lines` formatting intact). If a sign is blank, the marker lost its `lines`/`text`.

### 3.6 The Blackguard (three-phase boss)
- The fight starts from the Watchtower arena with the boss and its adds.
- At **60% HP** the shift triggers and the message must read exactly:
  *"His helmet cracks. Ash pours from the seams of his armor."*
- At **20% HP**:
  *"The armor is swallowed in Ash. What's inside no longer moves like a man."*
- These strings are new (they come from `BG_PHASE2_01`/`BG_PHASE3_01` now, not hard-coded text). If you see the old wording, the build is stale.
- Victory: Longsword + Crownveil Fragment, 250 XP / 100 gold, `BG_DEFEAT` lines, then `CV_END` is enterable and Chapter 1 completes with the act card.

### 3.7 Old Hunter Renn — `Q_SIDE_RENN` (the most likely logic bug)
This is the newest gameplay code in the project; test it as a feature, not a formality.

1. Walk to the Hunter's Camp. Renn must have a **sprite**, a **speaker name**, and talk on contact/confirm.
2. First talk plays `HC_RENN_01`–`04`, then a **Yes/No prompt**. The prompt text should be the script's own `HC_RENN_05` line.
3. **Accept** → quest appears in the journal at "Kill five Ash Wolves around the Hunter's Camp." Talking again gives `HC_RENN_07`.
4. Kill wolves. A pack of three must count **three**, not one. Confirm by killing two singles and one trio: the quest should advance to "Return to Old Hunter Renn" at five.
5. Return and talk: `HC_RENN_08`–`11` play, **Hunter's Charm** lands in the inventory as an accessory, the quest reads complete, `flag_renn_done` is set, and talking again gives only `HC_RENN_11`.
6. **Decline** path: reload an earlier save, decline (`HC_RENN_06_NO`), confirm no quest appears and the offer is repeatable.
7. **Equip the Charm** and confirm the +2% crit is reflected where crit is shown; save and reload with it equipped.

If counts don't persist across a save/reload, the numeric flag (`renn_wolves`) is being written but not read back — that is a save-schema bug, report it immediately.

**Gate 3:** Chapter 1 is completable, and 3.4 (save/load) and 3.7 (Renn) both pass.

---

## Phase 4 — Act II traversal, chapter by chapter (2 h)

Test each chapter's **gate and its boss**, not every line. The chapter-specific test rows are already written in `docs/TEST_PLAN.md` (sections "Chapter 2" … "Chapter 5") — tick as you go.

- **Ch 2 Wrenfield:** execution scene, Bram freed, Calder yields instead of dying, Taren joins and becomes controllable. Then **the new exit check**: Wrenfield's west road → `rm_valemere_road` → back. You must arrive at the **west road mouth facing right**, not at the town spawn. This is this week's `from_valemere_road` fix.
- **Ch 3 Valemere:** Nim/Salt Lamp job, the Debtman fight, Lyra controllable from the start of it, "A Parcel Unsealed".
- **Ch 4 Hollow Sanctuary:** Aethari reveal, Caelan joins, Warden two phases.
- **Ch 5 Garrison:** Sera detained, sealed non-Crown order, Hailen yields if you choose, Sera joins, treeline handoff to Act III.

**Gate 4:** all four chapters start, finish, and hand over without a softlock; party is five with one reserve.

---

## Phase 5 — Act III (Blackwood) (1 h)

- Cinderhollow, Berrin, the tithe choice (`Q_SIDE_TITHE` closes on the answer, refusing or paying 120 gold).
- Burn-Line Hulk gate: lose once, walk away, come back — it must be replayable, not latched.
- Shrine → glade → Lost Ones → Matriarch → doors. The pendant answers at the doors and the door stays shut. Act card plays.
- Ambience: forest, night, fire. `rm_blackwood_shrine`/`glade` use the night bed.

---

## Phase 6 — Act IV (Coleford to the King) (1.5 h)

- **Ch 9 Coleford:** Vell yields (`flag_vell_yielded`); Nessa's copy choice; Alden's first scene (he has **no sprite** — expect a placeholder, this is known).
- `Q_SIDE_LEDGER` completes and sets `ch9_shop_discount`. **Test the discount:** in a shop, a buy price should now be 10% lower than its base (rounded down, minimum 1 gold), and buying should charge that shown price — check the displayed row and the gold actually deducted agree. Before the flag it must charge full price.
- **Ch 10 barrow gate:** the Warden, the replayable gate, the road.
- **Ch 11 halls/deep:** the charter names the mark (**Crownveil**); the King fight. **Check all three phases:** at 60% the oath breaks (*"The oath breaks. Something underneath it does not."*) and at 30% it lets go (*"The oath lets go. What is left was always a man."*), with heavier attacks from there. Both messages, the boss bar and the phase damage must all hold.
- **The seal choice**: pick one, confirm `ch11_seal_alden` or `ch11_seal_party` persists through a save/reload. Act IV completes with `flag_act4_complete`.

**Gate 5:** the game is completable from the title screen to the end of Act IV without a softlock.

---

## Phase 7 — Systems matrix (45 min)

Run these inside ordinary battles; each is a distinct code path.

- **Statuses:** bleed, poison (tick + cure), blind (misses), sleep (skips), slow (turn order), buffs (stack rules).
- **Weakness:** fire against an Ash Wolf shows the weakness flag and the multiplier.
- **Guard** halves incoming damage until the party's next command; **Swap** costs the turn and works with one reserve.
- **Escape** works in random battles, **never** in boss fights.
- **Steal** returns an item and reports failure honestly.
- **Passives:** Last Stand below 25% HP (Attack +15%, Defense +10%); Cheap Shot from behind/ambush.
- **Party Order:** rearrange, confirm front/back changes targeting and damage.
- **Levels:** cap is 24; XP at cap does not overflow or wrap.

---

## Phase 8 — Menus, saves, Bestiary, quests (30 min)

- Items, Equip, Party Order, Status all mutate the right state and survive a reload.
- **Bestiary:** 42 entries, all with art, weakest row readable, long descriptions truncate instead of overlapping, burn_line_hulk/door_warden_boss rows present.
- **Quests:** six quests, including `Q_SIDE_RENN` and `Q_SIDE_LEDGER`; stage text matches `scr_quest_data.gml`; completed quests read complete.
- **Save schema v3:** three slots, overwrite confirmation, corrupt/empty slot handled, load from any slot shows the right chapter.
- Audio settings persist across relaunch.

---

## Phase 9 — Audio (20 min)

- Every room has a bed; walk the whole map and listen for a room that drops to silence. Two shops (**Len's store**, **Marda's store**) were just given `fire` and are the newest cases — confirm both.
- `snd_amb_water` is generated but still assigned to no room. Silence at the coast is expected; Act V will use it.
- Music switches on battle start/victory/boss and returns correctly; mute silences everything including ambience.

---

## Phase 10 — Performance and stability (20 min)

- Overworld is 400×300 tiles (6400×4800 px). Walk it with `show_debug_message` timing on: room entry should stay well under a second.
- Watch for memory growth across 20 room transitions.
- Alt-tab, minimise, resize, fullscreen and back. No crash, no lost input.
- Leave a save, quit, relaunch, continue: no regression from Phase 3.4.

---

## Phase 11 — Recording results

For each failure, record: **phase/step number, room name, exact steps, expected, actual, screenshot or short clip, IDE/runtime version, and whether it reproduces after a reload.** Then:

1. Tick or fail the matching row in `docs/TEST_PLAN.md` (never leave it blank — "not run" is a result).
2. Fix causes in `game/`, regenerate, mirror, and re-run both checks:
   `python3 validate_gamemaker.py && python3 tools/audit_chapters.py`
3. Add a `docs/CHANGELOG.md` line for anything fixed, and update `docs/DECISIONS_AND_OPEN_QUESTIONS.md` if a fix changes a recorded decision.
4. Do not renumber or reorder the room list while testing; it makes every bug report ambiguous.

---

## Known issues — do not report these as new bugs

| Issue | Status |
|---|---|
| Every Act III/IV room is a Wrenfield-tileset blockout; Act III–IV enemies borrow strips | Known art debt (18 enemy kinds lack overworld sets) |
| Alden has no sprite and no battle slot | Known; he appears as a placeholder |
| Eleven overworld entrances are `status: "stub"` (Frostwilds, Ironspine, Rimehold…) | Intentional; they show a placeholder line |
| Four encounter tables can roll an enemy outside their band (`zone01_old_road`, `zone01_bandit_camp`, `zone01_watchtower`, `zone01_basement_hall`) | Known warnings from the validator; balance pass pending |
| Nothing after Act IV exists | Acts V–VIII are outline-only; the board ends at `flag_act4_complete` (the Ashlands has three standalone rooms: the breach outpost, the ruins beyond it and the undercroft behind the ruin wall) |

## What "done" looks like

- Phases 1–10 all pass, or every failure has a recorded bug with a reproduction.
- `docs/TEST_PLAN.md` has no blank rows: every line is pass, fail with a link, or not-run with a reason.
- The changelog states the IDE/runtime version that verified it.
- Only then does the project stop being "built and validated" and start being "playtested".
