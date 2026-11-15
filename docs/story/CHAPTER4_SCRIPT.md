# ASHEN CROWN — Chapter 4 Script: "The Old Name" (Act II: The Broken Crown)

Route: the west-country road out of Valemere → the hollow in the hills → the Hollow Sanctuary outer door → the hollow halls → the records hall (Caelan) → the inner door → the Sanctuary Warden → the aftermath and Caelan's join → handoff toward the Blackwood Road Garrison.

> **Status: APPROVED.** The project owner approved this script and all eight decisions in section 10 on Nov 15 2026, in chat. Every line below is canon. Items marked **[C-confirmed]** were approved on Nov 15 2026 or earlier; **[CANON]** items come from the design doc. Open questions remain **[O]**.
> Chapter title: **The Old Name** **[C-confirmed]** (Nov 15 2026). Suggested levels: 13–16 **[C-confirmed]** (the `hollow_sanctuary` table already uses 13–16). The act title is **The Broken Crown** **[CANON]**. Boss name: **Sanctuary Warden** **[C-confirmed]** (already the id and label in `scr_enemy_database.gml`).

Source of truth: `STORY_BIBLE.md`. Presentation: FF1-style top-down exploration (confirmed). Battles are presumed to be FF1-style menu battles (still open).

## How to read this file (for Coder)

- Every dialogue node has a stable ID: `PREFIX_PLACE_NN`. Coder can key a dialogue database on these IDs, as with Chapters 1–3.
- Prefixes: `HS_` for the sanctuary, its approach and its stones; `CA_` for Caelan; `SW_` for the Sanctuary Warden.
- Format: `**ID** · Speaker` followed by the dialogue-box text. Each `>` line is one box line: at most 2 lines per box, each under 90 characters. A node with more than 2 lines is several boxes in sequence (each pair of lines is one box).
- `NARRATION` = text with no speaker. `SYSTEM` = tutorial or UI text. `[STAGE]` = direction for Coder and Design, not shown in game.
- Tags: **[CANON]** = exact text or event from the design doc. **[C-confirmed]** = approved by the project owner (Nov 15 2026, or Nov 14 2026 for the earlier beats). Open questions stay **[O]**. Lines inside a scene take that scene's tag.
- Suggested story flags are in `code` font. They are only suggestions, and Coder should match them to the real project.
- **Naming guide (do not break this):** before `flag_aethari_name_learned`, every speaker says **Architects**, never Aethari. The stone says Aethari first; Caelan explains the difference; after that, party dialogue says **Aethari**. UI, bestiary, item and quest text stay on **Architects** for the rest of the game. This is why the quest text in this chapter still reads "the Architect sanctuary."
- **What this chapter must not do:** name or reveal the Fallen Knight (he does not appear), explain the Ash or what destroyed Greyhaven, settle Elira's or Tomas's fate, say why Mira's face is in the old carvings, explain what the Aethari became or what the sanctuary was for, explain the nature of Lumen or the Crown Engine, say why the Crownveil broke, define Caelan's full knowledge, or split Alden from Taren. All of those stay open in the bible.

---

## 0. Quest text

### Main quest: Beyond the Veil — `Q_MAIN_BEYOND_VEIL` [CANON title]

**Description:** "She crossed the Crownveil." The pendant answered the sealed door. Mira is somewhere beyond. **[C-confirmed]** (carried from Chapter 1)

Chapter 4 completes stage 5 of the Act II quest plan and opens stage 6.

| Stage | ID | Objective text | Completes when |
|---|---|---|---|
| 5 | `Q_BV_S5` | Find the Hollow Sanctuary named in the notes. *(carried out of Chapter 3)* | Caelan is recruited and the Aethari name is learned |
| 6 | `Q_BV_S6` | Investigate the Blackwood Road Garrison. | *(Chapter 5 picks this up.)* |

**No side quest in this chapter.** The optional content here is lore and repeat talk only.

---

## 1. The approach — `HS_APPROACH`

[STAGE] Chapter 4 opens on the west-country road out of Valemere, a day's walk from the walls, exactly where Chapter 3 handed off. Late afternoon; grass, old stone, no farm smoke, no patrols. The party is **Kael, Taren and Lyra (3 members)**. Suggested levels 13–16. The approach may use the `hollow_sanctuary` encounter table for a short outdoor stretch, or stay safe and save the fights for the interior; Design's call. No save crystal here (save rule: church or tavern rooms only).

**HS_ENTER_01** · Taren
> One day from the walls and the road's already forgotten us.
> No patrols. No farm smoke. Just hills that don't answer.

**HS_ENTER_02** · Lyra
> Hills don't charge tolls. I'm not complaining.
> Keep your eyes down. Old stone leaves a seam you can follow.

**HS_ENTER_03** · Kael
> The notes said a hollow in the hills.
> Doors still standing.

**HS_ENTER_04** · Taren *(optional; cuttable)*
> Alden would call this a week wasted on a scholar's map.
> He'd still be standing here with us if the city let him go.

**HS_ENTER_05** · Lyra
> If the door's dead, we climb back out and I sell the map.

**HS_ENTER_06** · Kael
> It won't be dead.

### 1.1 Road texture

**HS_SIGN_01** · NARRATION *(a leaning waystone)*
> A waystone, half-sunk. The carved name is worn past reading.
> Someone has scratched a newer mark beneath it: a crown, and a line through it.

[STAGE] The scratched mark is a Broken Yoke mark, and nothing more is made of it. Do not name a leader or a rank **[O]** (question 29).

**HS_SHEP_01** · Shepherd *(optional; on the road)*
> You're walking toward the hollow. Nothing there but doors
> that don't open and a wind that comes from the wrong way.
**HS_SHEP_02** · Taren
> Wrong way how?
**HS_SHEP_03** · Shepherd
> Out of the hill, not over it. I don't go past the second stone.

[STAGE] He will not go on and does not know the name Aethari. Do not explain the wind. It is texture, not a mechanic.

---

## 2. The hollow and the outer door — `HS_DOOR`

[STAGE] A bowl of grass and old stone, a day from Valemere. Two stone doors stand in the hill, taller than a keep's gate. The doors are ajar by a hand's width, and have been for a long time: grass grows in the gap. Taren and Kael force them the rest of the way. Nothing magical opens them, and Mira's pendant does nothing here.

**HS_DOOR_01** · NARRATION
> The hollow is a bowl of grass and old stone.
> Two doors stand in the hill, taller than any keep's gate.

**HS_DOOR_02** · Kael
> Architect work. Same as the Watchtower.

**HS_DOOR_03** · Lyra
> No hinges. No bar. And it's been open a hand's width
> since before any of us were born.

**HS_DOOR_04** · Taren
> Then it opens the rest of the way. Put your back in it.

[STAGE] The doors grind open. Set `flag_sanctuary_entered`. No battle, no trap, no puzzle.

**HS_DOOR_05** · NARRATION *(inscription, cut deep and still legible)*
> Letters cut deep above the doors, older than the road outside:
> "Here the Aethari set the first stone of the Veil."

**HS_DOOR_06** · Kael
> Aethari.

**HS_DOOR_07** · Lyra
> Is that a name, or a warning?

**HS_DOOR_08** · Taren
> Architects, the priests call them. This isn't a priest's word.
> Somebody wrote what they called themselves.

**HS_DOOR_09** · Kael
> Then we find someone who can read the rest.

[STAGE] From here the party still says **Architects** in their own lines. Only the stone says Aethari. `flag_aethari_name_learned` is **not** set yet.

---

## 3. The hollow halls — `HS_HALLS`

[STAGE] A short dungeon, not a labyrinth: a corridor of stone doors, most of them open onto empty cells, then a stair down to the records hall. Use the existing `hollow_sanctuary` encounter table (`ward_sentinel`, `glyph_wisp`, `aethari_automaton`). Enemies are the sanctuary's remaining wards and constructs, still doing work nobody has needed for a very long time. Safe corridor stretches between fights so the lore nodes can be read without random battles. No chests are required; if Design wants one, keep the contents ordinary.

**HS_HALLS_01** · NARRATION
> A corridor of stone doors, most of them open.
> The dust is undisturbed except where something has walked.

**HS_HALLS_02** · Lyra
> Something's been through here. Recently.
> Boots, not claws. One set.

**HS_HALLS_03** · Taren
> Then we're not the first to find the door.

**HS_HALLS_04** · Kael
> We're the first to be expected.

### 3.1 The carved wall — `HS_LORE_01`

**HS_LORE_01_01** · NARRATION
> A wall of small cut marks, thousands of them, worn to lines.
> Near the bottom, a few late ones still read as words.

**HS_LORE_01_02** · NARRATION *(the surviving words)*
> LUMEN. THE ENGINE. THE VEIL STANDS.

[STAGE] These are three names and one claim, and no explanation follows. Do not add a translation, a date, or a mechanism. Caelan will name Lumen and the Crown Engine later without explaining either.

**HS_LORE_01_03** · Taren
> Lumen. That's a word I've heard in temple, and never explained.

**HS_LORE_01_04** · Lyra
> Every temple word is like that. It's how they keep the collection plate full.

### 3.2 The sealed door — `HS_LORE_02`

**HS_LORE_02_01** · NARRATION
> A door sealed with a ring of pale stone, warm under the hand.
> No handle. No seam. It does not answer.

**HS_LORE_02_02** · Kael
> Another one that won't open.

**HS_LORE_02_03** · Lyra
> This one isn't asking us to. It's asking us to leave it alone.

[STAGE] The sealed door stays shut for the whole chapter. It is not the inner door in section 5, and nothing in this script opens it. Whatever is behind it stays **[O]**.

### 3.3 The lamp — `HS_LORE_03`

**HS_LORE_03_01** · NARRATION
> At the foot of the stair, a lamp burns with a steady, unflickering light.
> Someone has trimmed the wick. Someone has been here for a while.

**HS_LORE_03_02** · Taren
> That's a scholar's lamp. No soldier carries a lamp like that.

**HS_LORE_03_03** · Kael
> Then we go quietly and ask him to keep it lit.

---

## 4. The records hall and Caelan — `CA_MEET`

[STAGE] A long hall of shelves, most of them empty, the rest holding stone tablets and a few paper bundles. At the far end: a table, a lamp, a spellbook, and **Caelan Rook**. He is not surprised and not armed like a soldier. He is wary of Crown colors and tired in a way that has nothing to do with sleep. The party enters from the stair; there is no separate door to open.

**CA_MEET_01** · NARRATION
> A long hall of shelves, most of them empty.
> At the far end, a lamp. Someone has been here long enough to need one.

**CA_MEET_02** · Caelan
> Stop there.
> You're wearing a soldier's boots.

**CA_MEET_03** · Kael
> Not anymore.

**CA_MEET_04** · Caelan
> That's what the last ones said. They had horses.
> You don't. That's something.

**CA_MEET_05** · Taren
> We're not Crown. We're looking for a way through the Veil.

**CA_MEET_06** · Caelan
> Everyone with a sword is looking for something.
> Say it in one sentence. I'm busy not being found.

**CA_MEET_07** · Kael
> The door at the Crownveil didn't open. My sister crossed it.
> I need to know how.

**CA_MEET_08** · Caelan
> And you came to a dead sanctuary for that.
> At least you came to the right century.

**CA_MEET_09** · Lyra
> He talks like a ledger. Can we buy the short version?

**CA_MEET_10** · Caelan
> The short version is a name.

[STAGE] Caelan closes the book. This is the reveal. Set `flag_aethari_name_learned` on the last line of `CA_MEET_11`.

**CA_MEET_11** · Caelan **[CANON wording]**
> The Architects. That's what the textbooks call them.
> They called themselves the Aethari.

**CA_MEET_12** · Kael
> Aethari.

**CA_MEET_13** · Taren
> And you know that because...?

**CA_MEET_14** · Caelan
> Because I used to be paid to know things.
> Then I stopped being paid, and started being hunted.

**CA_MEET_15** · Kael
> What did they build the Veil for?

**CA_MEET_16** · Caelan
> They understood Lumen. They built the Crown Engine.
> That's the whole of what I'll say standing in a hallway.

**CA_MEET_17** · Kael
> That's a name and a machine. Not an answer.

**CA_MEET_18** · Caelan
> If I told you what I think, you would take it for an answer.
> It isn't one yet.

**CA_MEET_19** · Lyra
> Wonderful. A scholar with a secret and no horse.

**CA_MEET_20** · Caelan
> You're carrying paper. The Crown's seal is on the corner.
> Where did you get it?

**CA_MEET_21** · Lyra
> A warehouse. We're thieves. Try to keep up.

**CA_MEET_22** · Caelan
> Then you already know more than you should.

**CA_MEET_23** · Taren
> We know enough to knock. We don't know enough to walk through.

**CA_MEET_24** · Caelan
> The inner door is this way. Don't touch the records.
> The Warden counts them.

**CA_MEET_25** · Kael
> The Warden.

**CA_MEET_26** · Caelan
> You'll meet it. Try not to be counted.

[STAGE] Caelan takes his spellbook and leads them to the inner door. He does not explain what the sanctuary was for, what he is doing here, or how long he has been here. Do not answer those **[O]**.

**Repeat talk, CA_MEET_R1** · Caelan:
> The inner door first. Questions after, if we're both still standing.

---

## 5. The Sanctuary Warden — `SW`

[STAGE] The inner door stands at the end of the records hall. As the party approaches it, the far wall unfolds: stone separates from stone without dust, and something the size of a gate takes a step. This is the **Sanctuary Warden**, an ancient guardian-construct. It does not speak. Do not give it dialogue, a name for the Aethari, or a motive beyond guarding the door.

**SW_INTRO_01** · NARRATION
> The far wall unfolds. Stone separates from stone without dust.
> Something the size of a gate takes a step.

**SW_INTRO_02** · Taren
> That's not a door.

**SW_INTRO_03** · Caelan
> It kept the inner door shut for a very long time.
> Stand back from the shelves.

**SW_INTRO_04** · Lyra
> I hate old buildings.

**SW_INTRO_05** · Kael
> Then let's be quick about leaving one.

[STAGE] Battle start: `grp_sanctuary_warden` (boss `sanctuary_warden` plus one `ward_sentinel`). Suggested player level 13–16. The boss is level 16, two phases, phase 2 at 50% HP with the existing line "The Warden's plates crack. Two more arms unfold!" and `warden_ring` in its action pool. Exact stats stay as they are in `scr_enemy_database.gml`; balance is Design's.

[STAGE] **Caelan becomes controllable at the start of this fight**, exactly as Lyra did at the Debtman: he takes the **4th party slot** and the active line is full at four. His join conversation follows the battle (section 6).

**SW_SYS_01** · SYSTEM
> Caelan Rook has joined the party.
> He takes the fourth party slot.

[STAGE] Optional first-turn warning, if Caelan has a defensive spell: "Caelan: The Warden strikes the room, not just you. Spread out."

### 5.1 Defeat — `SW_DEFEAT`

**SW_DEFEAT_01** · NARRATION
> The Warden folds in on itself, plate by plate.
> The hall is quiet in a way it wasn't before.

**SW_DEFEAT_02** · Caelan
> It counted them for a long time.
> It won't count anything now.

**SW_DEFEAT_03** · Taren
> That thing was the lock on your inner door.

**SW_DEFEAT_04** · Caelan
> It kept the door closed. That's all it ever did.

**SW_DEFEAT_05** · Kael
> Then open it.

**SW_DEFEAT_06** · Caelan
> Not yet. Whatever's behind it has waited this long.
> It can wait until we know what we're carrying.

[STAGE] The Warden stops; no Ash drop, no unique loot, no corpse to search. Set `flag_sanctuary_warden_beaten` (optional). Rewards are for Coder and Design to set (placeholder: XP and gold for level 13–16). The inner door is not opened in this chapter **[O]**.

---

## 6. What the name costs — Caelan's join — `CA_JOIN`

[STAGE] The records hall after the fight. Shelves down, one lamp still burning. Caelan is not triumphant; he is a man who has run out of reasons to stay on a hill. He joins because the answers are not in the stone, and because the party is the only place left to stand. He withholds what he knows about the Veil and why it broke **[O]** (bible 5.3). Do not have him confess, apologize at length, or explain his past.

**CA_JOIN_01** · Caelan
> You should go. It will be quiet here for a while.
> Quiet is what people like me are supposed to want.

**CA_JOIN_02** · Kael
> You could stay.

**CA_JOIN_03** · Caelan
> I could. I've done it for a year.
> The Crown would rather a vanished scholar than a talking one.

**CA_JOIN_04** · Taren
> Then don't vanish. Walk out with us.

**CA_JOIN_05** · Caelan
> Greyhaven.
> I heard about it from a carter. I didn't come.

**CA_JOIN_06** · Caelan
> I told myself there was nothing to do from a hill.
> That was true right up until it wasn't.

**CA_JOIN_07** · Kael
> We're going to the Blackwood next. There's a garrison with answers.

**CA_JOIN_08** · Caelan
> Then I'll come as far as the answers.
> After that, we'll see what I'm worth.

**CA_JOIN_09** · Lyra
> Another scholar. Wonderful. Do you have coin?

**CA_JOIN_10** · Caelan
> No.

**CA_JOIN_11** · Lyra
> Then you're my favorite kind of problem.

**CA_JOIN_12** · Kael
> Welcome to it.

[STAGE] **Caelan Rook** is a permanent party member **[C]**. Set `flag_caelan_recruited`. Complete `Q_BV_S5`. Start `Q_BV_S6`. The active line is full at 4; the reserve slot is still empty, and it stays empty until the garrison.

**CA_SYS_01** · SYSTEM
> Caelan Rook has joined the party.
> He takes the fourth party slot.

**CA_SYS_02** · SYSTEM
> Weapon: spellbook.
> Starting skills: Ember, Frost Lance, and Arc Bolt.

**CA_SYS_03** · SYSTEM
> Ember: fire damage. Frost Lance: ice damage.
> Arc Bolt: lightning damage.

**CA_SYS_04** · SYSTEM
> The active party is full at four.
> The reserve slot stays empty until the garrison.

**CA_SYS_05** · SYSTEM *(optional, first elemental hit on a weakness)*
> Foes have weaknesses. Fire, ice and lightning don't all land the same.
> Watch what the hit says.

[STAGE] Caelan's element kit is **[CANON intent]** (bible 5.3: fire, ice, lightning and dark magic; exploiting weaknesses). **Ember**, **Frost Lance** and **Arc Bolt** are approved starting-skill names (Nov 15 2026); their numbers stay **[O]** and need entries in `scr_skill_data.gml`. Dark magic unlocks later; do not add it here. His spellbook is a starting weapon with no stats yet, so he fights with his base ATK until it is given values (the Chapter 4–5 balance sim already assumes this).

[STAGE] **Naming shift.** From here, every party line says **Aethari**, not Architects. UI, bestiary, item and quest text keep saying Architects. Examples for later chapters: Taren "Aethari doors" not "Architect doors"; Lyra "Aethari rubbish"; the quest text still "the Architect sanctuary."

**Repeat talk, CA_JOIN_R1** · Caelan:
> I'll want the notes eventually. Not today.
> Today I'd rather know which road we're taking.

**Repeat talk, HS_R1** · Lyra:
> He's quiet, he's broke, and he knows things.
> Two out of three is better than most of my jobs.

---

## 7. Out of the hollow — handoff to the Blackwood Road Garrison — `HS_HANDOFF`

[STAGE] The party climbs back out through the outer doors. Late light; the hollow behind them. The road east runs toward the Blackwood Road Garrison, a day or two away. This ends Chapter 4. Do not play the garrison, and do not play a Fallen Knight sighting here; the next sighting belongs after the garrison per `ACT2_OUTLINE.md` §10.

**HS_HANDOFF_01** · Taren
> Garrison on the Blackwood road. A day, maybe two.
> Crown post, so we walk in with our hands where they can see them.

**HS_HANDOFF_02** · Lyra
> They'll count us before we knock.

**HS_HANDOFF_03** · Caelan
> Let them count. It's the records I want.

**HS_HANDOFF_04** · Kael
> Then we walk.

**HS_HANDOFF_05** · SYSTEM
> Quest updated: Investigate the Blackwood Road Garrison.

**HS_HANDOFF_06** · SYSTEM
> Chapter 4 — The Old Name — Complete.

[STAGE] Set `flag_chapter4_complete`. Offer a save quietly: there is no crystal here, and the save rule is a town's church or tavern room, so the prompt is the same quiet one used at the end of Chapters 1–3. No unexplained blackout. Chapter 5 begins on the approach to the Blackwood Road Garrison.

---

## 8. Implementation notes (for Coder)

- **Rooms:** `rm_hollow_approach` (short outdoor stretch, optional) and `rm_hollow_sanctuary` (the dungeon: outer door, halls, records hall, inner door). If one room is simpler, merge the approach into the sanctuary room and keep the same markers. Builders follow the `scr_build_*` pattern; do not regenerate UUIDs.
- **Encounters:** `hollow_sanctuary` table already exists (Ward Sentinel, Glyph Wisp, Aethari Automaton), levels 13–16. Boss group `grp_sanctuary_warden` already exists. Boss art, enemy strips and the `sanctuary_warden` stats are already in the project; no new art is required beyond what is imported.
- **Flags:** `flag_sanctuary_entered`, `flag_aethari_name_learned`, `flag_caelan_recruited`, optional `flag_sanctuary_warden_beaten`, `flag_chapter4_complete`.
- **Dialogue:** generate a `scr_dialogue_data_ch4`-style script from these IDs, matching the Chapter 1–3 generator output. Keep the box rule (2 lines, under 90 characters).
- **Story script:** a `scr_ch4_story` with quest helpers mirroring `scr_ch3_story.gml`: complete S5, start S6, set the flags, handle the join.
- **Party:** Caelan enters at the boss fight start (section 5) and is permanent after `CA_JOIN`. Active line is 4; reserve slot exists but stays empty until the garrison recruit.
- **Skills:** `ember`, `frost_lance`, `arc_bolt` do not exist in `scr_skill_data.gml`. Names are approved; add them with PLACEHOLDER numbers. Do not invent percentages in this script.
- **Save:** no crystal, no inn; the chapter-end save prompt stays quiet, per the church/tavern save rule.
- **Naming:** party dialogue Aethari, everything else Architects, from `flag_aethari_name_learned` on.

---

## 9. What this chapter does not do

- The Fallen Knight does not appear, is not named, and does not fight.
- Nothing explains the Ash, Greyhaven's destruction, Elira, Tomas, or Mira's face in the carvings.
- The Aethari name and the word "Aethari" on stone are the reveal; what the Aethari became, what the sanctuary was for, and what happened to them stay **[O]**.
- Lumen and the Crown Engine are named, never explained.
- Caelan does not explain why the Crownveil broke, what he knows, or why he was hiding.
- The sealed door in 3.2 and the inner door stay shut.
- Alden does not appear and does not split from Taren. His rank, role and plans stay **[O]**.
- No Black Hand leader is named; Lyra's ties stay **[O]**.

---

## 10. Decisions (project owner, Nov 15 2026)

All eight recommendations were approved on Nov 15 2026, in chat. Rejected options are kept for the record, struck through. Open questions remain **[O]**.

### 1. Chapter title

**Option A (chosen):** **The Old Name**. It names the reveal without spoiling the Aethari word, and it fits "Crowns and Alleys" in length and tone.

- ~~**Option B:** The Hollow Sanctuary (plain, location-first).~~
- ~~**Option C:** What the Stone Says (more mystery, less series flavor).~~

### 2. Level band

**Option A (chosen):** 13–16, matching the existing `hollow_sanctuary` table and boss level 16.

- ~~**Option B:** 12–15, if Chapter 3's 10–13 should flow in faster.~~

### 3. When Caelan becomes controllable

**Option A (chosen):** At the start of the Warden fight, 4th slot, exactly like Lyra at the Debtman. The join conversation follows the battle. Reuses a pattern the code already supports, and it matches the four-member party the Chapter 4–5 balance sim uses for this boss.

- ~~**Option B:** After the fight only; during the battle he is a guest ally or absent.~~

### 4. Caelan's starting kit

**Option A (chosen):** **Ember** (fire), **Frost Lance** (ice), **Arc Bolt** (lightning) — one skill per element so weakness play starts immediately. No starting passive; dark magic later. Numbers stay **[O]**.

- ~~**Option B:** Two elements at join (fire and ice), lightning and dark later.~~
- ~~**Option C:** Add a passive (for example, a small bonus to identifying weaknesses) at the cost of one element.~~

### 5. Whose notes the party is carrying

**Option A (chosen):** **Left unstated.** Caelan recognizes the Crown seal, not necessarily the hand. Chapter 3's scholar stays anonymous, and this is a canon silence, not a gap to fill by implication.

- ~~**Option B:** The notes are Caelan's own, written when he left court.~~
- ~~**Option C:** The notes belonged to a colleague of his.~~

### 6. Alden in this chapter

**Option A (chosen):** **Absent**, with the single optional Taren line in section 1. The chapter stays self-contained and Alden's plans stay **[O]**.

- ~~**Option B:** A short letter or message from Alden at the sanctuary entrance.~~

### 7. Boss name

**Option A (chosen):** **Sanctuary Warden**, matching the id and label already in the enemy database.

- ~~**Option B:** **The Warden** everywhere (shorter, more ominous).~~
- ~~**Option C:** **Hollow Warden** (ties it to the location name).~~

### 8. Handoff

**Option A (chosen):** End on the road out of the hollow, with `Q_BV_S6` active and the chapter-complete screen; Chapter 5 opens on the approach to the Blackwood Road Garrison. No Fallen Knight sighting until after the garrison.

- ~~**Option B:** End inside the records hall, with the road and chapter-complete screen opening Chapter 5.~~

---

## Approved (project owner, Nov 15 2026, in chat)

The project owner approved the chapter title **The Old Name**, levels **13–16**, Caelan's join timing and his **Ember / Frost Lance / Arc Bolt** kit, leaving the notes' authorship unstated, Alden's absence, the boss name **Sanctuary Warden**, and the Blackwood handoff, plus every line, bark, lore fragment and system message in this file. Two lines were corrected during approval: the carved wall now reads "THE VEIL STANDS" (not "HOLDS", which hinted at containment), and the join system text now says the reserve slot is empty rather than that there is no reserve.

Open questions in the bible remain open: what the sanctuary was for, what happened to the Aethari, Lumen, the Crown Engine, why the Crownveil broke, the Fallen Knight's identity, Alden's backstory and rank, Black Hand leadership, Aldric's motives, Tomas's and Elira's fates, what destroyed Greyhaven, and why Mira's face is in the old carvings.

Approved excerpt can go to Coder for `docs/story/` and for the Chapter 4 dialogue data and rooms.
