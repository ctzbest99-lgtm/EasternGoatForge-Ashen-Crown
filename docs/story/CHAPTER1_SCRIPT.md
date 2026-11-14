# ASHEN CROWN — Chapter 1 Script: "The Night of Ash" (Zone 1: The Ashen Road)

Vertical slice route: Greyhaven ruins → Farmlands → Hunter's Camp (optional) → Old Road → Abandoned Bandit Camp → Old Watchtower → Watchtower Basement → Blackguard → Crownveil Door.
> **Status: APPROVED.** Kevin approved every proposed item in this script as canon on Nov 14 2026. Items marked **[C-confirmed]** were invented for this script and then approved. **[CANON]** items come from the design doc.

Source of truth: `STORY_BIBLE.md`. Presentation: FF1-style top-down exploration (confirmed). Battles are presumed to be FF1-style menu battles (still open).

## How to read this file (for Coder)

- Every dialogue node has a stable ID: `ZONE_PLACE_NN`. Coder can key a dialogue database on these IDs.
- Format: `**ID** · Speaker` followed by the dialogue-box text. Each `>` line is one box line: at most 2 lines per box, each under 90 characters. A node with more than 2 lines is several boxes in sequence (each pair of lines is one box).
- `NARRATION` = text with no speaker. `SYSTEM` = tutorial or UI text. `[STAGE]` = direction for Coder and Design, not shown in game.
- Tags: **[CANON]** = exact text or event from the design doc or Kevin's decisions. **[C-confirmed]** = connective content written for this script, approved by Kevin (Nov 14 2026). Untagged nodes inside a scene take that scene's tag.
- Suggested story flags are in `code` font (e.g. `flag_met_tomas`). They are only suggestions, and Coder should match them to the real project.
- Nothing here names the Fallen Knight, explains the Ash, says what destroyed Greyhaven, or settles Elira's or Tomas's fate. All of those are still open in the bible.

---

## 0. Quest text

### Main quest: Find Mira — `Q_MAIN_FIND_MIRA` [CANON title / C-confirmed text]
**Description:** Greyhaven is in ruins and Mira is missing. Father said she went into the woods.

| Stage | ID | Objective text | Completes when |
|---|---|---|---|
| 1 | `Q_FM_S1` | Find Father among the survivors. | `GH_TOMAS` scene ends |
| 2 | `Q_FM_S2` | Search the ruins of Varyn House. | Pendant obtained |
| 3 | `Q_FM_S3` | Leave Greyhaven by the North Gate. | Enter the Farmlands |
| 4 | `Q_FM_S4` | Cross the Farmlands toward the Old Road. | Enter the Old Road |
| 5 | `Q_FM_S5` | Follow the Old Road north. | Enter the Bandit Camp |
| 6 | `Q_FM_S6` | Search the Abandoned Bandit Camp. | Camp searched and exit to the Watchtower used |
| 7 | `Q_FM_S7` | Explore the Old Watchtower. | Enter the Basement |
| 8 | `Q_FM_S8` | Find what lies beneath the Watchtower. | Enter the Blackguard Arena |
| 9 | `Q_FM_S9` | Defeat the Blackguard. | Boss defeated |

On completion the quest is replaced by **Beyond the Veil** [CANON].

### Main quest: Beyond the Veil — `Q_MAIN_BEYOND_VEIL` [CANON title / C-confirmed text]
**Description:** "She crossed the Crownveil." The pendant answered the sealed door. Mira is somewhere beyond.
| Stage | ID | Objective text |
|---|---|---|
| 1 | `Q_BV_S1` | Find a way beyond the Veil. *(Chapter 2 picks this up.)* |

### Side quest: Thinning the Pack — `Q_SIDE_RENN` [C-confirmed title / task; CANON giver and reward]
**Giver:** Old Hunter Renn, Hunter's Camp. **Reward:** Hunter's Charm (+2% critical hit) [CANON].
**Description:** Ash Wolves have been running the Farmlands and the Old Road. Renn wants them thinned.
| Stage | ID | Objective text |
|---|---|---|
| 1 | `Q_SR_S1` | Defeat Ash Wolves in the Farmlands or on the Old Road (0/5). |
| 2 | `Q_SR_S2` | Return to Old Hunter Renn. |

---

## 1. Greyhaven ruins (level 1, safe area, no random battles)

### 1.1 Arrival — `GH_ARRIVAL` [CANON event / C-confirmed lines]
[STAGE] Fade in at the south road outside Greyhaven. Burned roofs, collapsed walls, smoke. The destruction is already over. Do not show or flash back to it [CANON]. Kael walks in alone.

**GH_ARRIVAL_01** · NARRATION
> Four years in the Royal Army. Kael Varyn came home to Greyhaven.
> What was left of it.

**GH_ARRIVAL_02** · Kael
> ...No.

**GH_ARRIVAL_03** · Kael
> Father. Mira.

[STAGE] Start `Q_MAIN_FIND_MIRA` at stage 1 (`Q_FM_S1`). Set `flag_arrived_greyhaven`.

### 1.2 Tomas, dying — `GH_TOMAS` [CANON line / C-confirmed framing]
[STAGE] [C-confirmed] Tomas lies on a pallet in the ruined Blacksmith (his own forge), tended by Pell, a young survivor. Talking to Pell or Tomas starts the scene. Tomas does not die on screen here, because whether he dies on screen is still an open question.

**GH_TOMAS_01** · Pell [C-confirmed]
> Kael? Gods. He kept saying you'd come. Over here. Careful.

**GH_TOMAS_02** · Kael
> Father.

**GH_TOMAS_03** · Tomas
> Kael... you came home.

**GH_TOMAS_04** · Kael
> Don't talk. Where's Mira?

**GH_TOMAS_05** · Tomas [CANON]
> “Your sister… she went into the woods.”

**GH_TOMAS_06** · Kael
> The woods? Why would she—

[STAGE] Tomas slips out of consciousness. He does not die.

**GH_TOMAS_07** · Pell [C-confirmed]
> He's been like that since. In and out. I'll stay with him. Go.

**GH_TOMAS_08** · Kael
> Keep him breathing. I'll be back.

[STAGE] Advance to `Q_FM_S2`. Set `flag_met_tomas`.
Repeat talk with Tomas, **GH_TOMAS_R1** · NARRATION [C-confirmed]:
> He's breathing. Barely.
Repeat talk with Pell, **GH_TOMAS_R2** · Pell [C-confirmed]:
> I've got him. Find her, Kael.

### 1.3 Pendant in the Varyn House ruins — `GH_HOUSE` [CANON event / C-confirmed lines]
[STAGE] Varyn House is a burned shell. Interactable debris points (beams, a toppled chest, a scorched bed). The pendant sits under the rubble where Mira's bed was.

**GH_HOUSE_01** · NARRATION *(toppled table)*
> Mother's table. Split down the middle.

**GH_HOUSE_02** · NARRATION *(collapsed beam)*
> The roof came down here. Nothing underneath. Thank the gods.

**GH_HOUSE_03** · NARRATION *(Mira's corner)* [CANON event]
> Under the ash and splinters: a small wooden pendant on a cord.
> Mira's.

**GH_HOUSE_04** · SYSTEM
> Obtained: Mira's Wooden Pendant (Story Item).

**GH_HOUSE_05** · Kael
> No body. That means something.
> ...It has to.

[STAGE] Add the permanent key item `item_mira_pendant` (it can't be sold or dropped) [CANON]. Advance to `Q_FM_S3`. Set `flag_pendant_found`. The North Gate unlocks.

### 1.4 Survivor dialogue [C-confirmed: all names and lines]
Survivors don't know what destroyed the town, and they don't explain it. Lines with `_A` are spoken before the pendant is found, lines with `_B` after.

**Rusted Boar Tavern: Hob, the tavern keeper** [C-confirmed]
**GH_TAVERN_01** · Hob
> Kael Varyn. Wish you'd picked a better week to come home.
> Bar's still standing. That's about all.
**GH_TAVERN_02** · Hob
> Don't ask me what happened. I was in the cellar. I heard it. That's enough.
**GH_TAVERN_03** · Kael
> I didn't ask.
**GH_TAVERN_04** · Hob
> You were going to. Your old man's at the forge, if he's still with us.

**Greyhaven Chapel: Sister Ilse, the chapel keeper** [C-confirmed; faith/order left unnamed, because whether the Chapel belongs to the Radiant Flame is open]
**GH_CHAPEL_01** · Sister Ilse
> We've counted the dead twice. Your sister wasn't among them.
> I don't know if that's a mercy.
**GH_CHAPEL_02** · Sister Ilse
> Mira came here last month with a black stone. Asked me what the mark on it meant.
**GH_CHAPEL_03** · Sister Ilse
> I told her to throw it away. She smiled at me the way children do
> when they've already decided not to.
*(GH_CHAPEL_02–03 fit the canon "she was told to throw it away but kept it". Who told her is not stated in the doc, so this attribution is [C-confirmed].)*

**Blacksmith (Tomas's forge): Pell** [C-confirmed]
**GH_SMITH_01_B** · Pell
> His tools are mostly fine. Iron's tougher than people.
> Take what you need for the road.
[STAGE] Optional: the Blacksmith works as a basic equipment shop run by Pell. Stock should come from the item DB.

**General Store: Marda, the shopkeeper** [C-confirmed]
**GH_STORE_01** · Marda
> Shelves are half ash, but potions don't burn easy.
> Coin's still coin, Kael. Even now.
**GH_STORE_02** · Kael
> Your prices go up?
**GH_STORE_03** · Marda
> Everything went up. Including the roof. Buying or not?
[STAGE] Shop: Minor Potion, Antidote (canon item names). Prices come from the item DB.

**Town Square: survivors** [C-confirmed]
**GH_SQUARE_01** · Old Wenna
> The well still runs. Strange, what's left standing.
**GH_SQUARE_02** · Dov (a boy, about Mira's age)
> Mira said she found a door in the ground. Under the town.
> Nobody believed her. I didn't either.
**GH_SQUARE_03** · Kael
> Where under the town?
**GH_SQUARE_04** · Dov
> She wouldn't tell. Said it was hers.
*(Canon: Mira found a passage beneath Greyhaven. The scene does not reveal where it is or whether it is the Crownveil Door.)*

**North Gate: Corwin, the militia watchman** [C-confirmed]
**GH_GATE_01_A** · Corwin
> Gate stays shut till you've seen your father. He asked for you. Every hour.
**GH_GATE_01_B** · Corwin
> Woods, is it? Then take the Old Road. Farmlands first.
> Bandits came sniffing after the fires. Keep your blade out.
**GH_GATE_02_B** · Corwin
> Someone saw small tracks heading north past the fields. Could be anyone's.
**GH_GATE_03_B** · Kael
> Could be hers.

---

## 2. Greyhaven Farmlands (level 1–2) — Bandits, Ash Wolves

### 2.1 First guaranteed Bandit encounter (tutorial) — `FL_TUTORIAL` [CANON encounter / C-confirmed text]
[STAGE] A scripted trigger on the farm path. One Bandit. Combat can't be skipped, and there are no random battles before it.

**FL_TUTORIAL_01** · Bandit
> Well, well. A soldier boy, picking through the ashes like the rest of us.
**FL_TUTORIAL_02** · Kael
> Move.
**FL_TUTORIAL_03** · Bandit
> Big talk. Let's see that sword, then.

[STAGE] Battle start: `enc_bandit_tutorial` (1× Bandit).

**FL_TUTORIAL_SYS_01** · SYSTEM
> Choose a command for Kael: Attack, Skills, Defend, or Items.
> Turn order depends on Speed.
**FL_TUTORIAL_SYS_02** · SYSTEM
> Attack deals physical damage. Defend reduces damage taken until your next turn.
**FL_TUTORIAL_SYS_03** · SYSTEM
> Careful: some foes hit harder against a defending target. Bandits fight dirty.
**FL_TUTORIAL_SYS_04** · SYSTEM
> Items such as a Minor Potion restore HP. Using one takes Kael's turn.
**FL_TUTORIAL_SYS_05** · SYSTEM *(the first time Kael drops below 25% HP)*
> Last Stand: below 25% HP, Kael's Attack rises 15% and Defense 10%.
*(SYS_03 points at the canon Cheap Shot ability. SYS_05 states the canon Last Stand values.)*

**FL_TUTORIAL_04** · Bandit *(after the battle)*
> Should've... stayed in the army...
**FL_TUTORIAL_05** · Kael
> Should've stayed out of my way.

[STAGE] Random encounters (Bandits, Ash Wolves) switch on. Set `flag_tutorial_done`.

**FL_SIGN_01** · NARRATION *(signpost)* [C-confirmed]
> East: Hunter's Camp. North: the Old Road.

---

## 3. Hunter's Camp (optional, level 2) — Old Hunter Renn

[STAGE] A small camp with a tent, drying racks and a fire. No random battles here [C-confirmed].
Renn's personality is not in the doc. Everything below is **[C-confirmed]**: a gruff, dry old woodsman.

**HC_RENN_01** · Old Hunter Renn
> Varyn's boy. Heard the town went up. Heard you were off playing soldier.
**HC_RENN_02** · Kael
> Heard right, both times.
**HC_RENN_03** · Old Hunter Renn
> Looking for your sister, then. Didn't see her. Don't see much past my fire lately.
**HC_RENN_04** · Old Hunter Renn
> Ash Wolves have been running the fields since that night. More every week.
> Thin the pack for me and I'll make it worth your while.
**HC_RENN_05** · SYSTEM *(choice)*
> Accept? [Yes] [No]
**HC_RENN_06_YES** · Old Hunter Renn
> Five'll do. Fire works on 'em better than steel, if you ever find any.
**HC_RENN_06_NO** · Old Hunter Renn
> Suit yourself. Wolves'll still be here. So will I.

[STAGE] Yes: start `Q_SIDE_RENN` and count Ash Wolf kills in the Farmlands and on the Old Road. *(Ash Wolf weakness to Fire is canon.)*

**HC_RENN_07** · Old Hunter Renn *(quest active, unfinished)*
> Still hear howling. Keep at it.
**HC_RENN_08** · Old Hunter Renn *(turn-in)*
> Quieter out there already. Here. Wore it thirty years. Never missed a shot.
**HC_RENN_09** · SYSTEM
> Obtained: Hunter's Charm (+2% critical hit).
**HC_RENN_10** · Kael
> Never?
**HC_RENN_11** · Old Hunter Renn
> Never missed one I told anyone about. Go find your sister.

[STAGE] Complete `Q_SIDE_RENN`. Set `flag_renn_done`.

---

## 4. Old Road (level 2–3) — Bandits, Ash Wolves, Ashen Wretches, rare Ashbound Hunter

**OR_ENTER_01** · Kael [C-confirmed]
> Small boots. Heading north. Keep going, Mira. I'm right behind you.
*(Uses the "small tracks" hint from GH_GATE_02_B. It is [C-confirmed] connective motivation for following the route.)*

### 4.1 Ashbound Hunter special encounter — `ENC_ASHBOUND_HUNTER` [CANON event + parchment / C-confirmed framing]
[STAGE] A rare random encounter (3–5%) on the Old Road, at the Bandit Camp and in the Watchtower. Before the battle starts, an arrow thuds into the ground beside Kael [CANON]. Recommended level 3–5. The parchment drops only the first time the Hunter is defeated.
**[C-confirmed] The parchment can't be missed.** The first Ashbound Hunter fight in the Old Watchtower is a **guaranteed scripted encounter** (`enc_ashbound_hunter_wt`, triggered once on a set tile in the Watchtower; Design picks which). If the player already has the parchment from a rare encounter, the guaranteed fight still happens, but ENC_AH_03–05 are skipped. Check `flag_parchment_found`.

**ENC_AH_01** · NARRATION [CANON event]
> An arrow slams into the dirt beside Kael's boot.
**ENC_AH_02** · Kael [C-confirmed]
> That was a warning. Or a bad shot. Let's find out which.
[STAGE] Battle: 1× Ashbound Hunter. ENC_AH_01–02 play at both the rare encounter and the guaranteed Watchtower encounter.

**ENC_AH_03** · NARRATION *(after victory, first time)* [CANON object]
> A folded parchment is tucked inside the hunter's coat.
**ENC_AH_04** · Parchment [CANON text, verbatim]
> “Find the girl. The Varyn girl is still alive.”
**ENC_AH_05** · Kael [C-confirmed]
> Alive.
> ...Then who else is looking for her?
[STAGE] Add the key item `item_ashbound_parchment` [C-confirmed as an item]. Set `flag_parchment_found`. If Kevin wants an Ice hint (Ashbound Hunter is weak to Ice [CANON]), add it later through the bestiary, not through dialogue.

---

## 5. Abandoned Bandit Camp (level 3–4) — Bandits, Fallen Knights, Ashen Wretches, rare Ashbound Hunter

**BC_ENTER_01** · Kael [C-confirmed]
> Abandoned. Fires cold for days. Whatever ran them off, I'm walking toward it.

Chests (canon pool): Minor Potion x3, Antidote x2, 50 Gold, Iron Sword. Which chest holds which is up to Design.

### 5.1 The Fallen Knight, first line — `FK_01` [CANON line / C-confirmed placement and staging]
[STAGE] [C-confirmed] At the camp's north exit, an armored Fallen Knight stands motionless in Kael's path. It does not attack. Do not name him; his identity is open. After the line, he turns and walks into the trees toward the Watchtower. This gives the player a [C-confirmed] reason to go there.

**FK_01_01** · Fallen Knight
> ...Varyn.
**FK_01_02** · Kael
> You know me?
**FK_01_03** · Fallen Knight [CANON]
> “Your father knew what was coming.”
**FK_01_04** · Kael
> What's that supposed to mean? Hey—!
[STAGE] The knight leaves. Set `flag_fk_seen_1`. Advance to `Q_FM_S7` when the player takes the path to the Watchtower.

---

## 6. Old Watchtower (level 4–7) — Fallen Knights, Grave Spiders, Hollow Soldiers, Ashbound Hunter

[STAGE] A dungeon with locked doors, keys, chests and traps [CANON]. Ancient symbols are carved in the stone [CANON].
[STAGE] [C-confirmed] The guaranteed first Ashbound Hunter fight happens here (see 4.1), before the banner room.

### 6.1 Interactables and lore notes [C-confirmed unless marked]
**WT_DOOR_LOCKED** · NARRATION
> Locked. The keyhole is crusted with rust.
**WT_KEY_01** · SYSTEM
> Obtained: Watchtower Key. *(Key names and count: [C-confirmed]. Design decides the layout.)*
**WT_SYMBOL_01** · NARRATION *(ancient symbols on the walls)*
> Carvings older than the tower itself. The stone around them is too smooth.
**WT_NOTE_01** · Faded Note *(soldier's note)*
> Third week without relief. They say the post's being closed. Nobody says why.
**WT_NOTE_02** · Faded Note
> Scratching under the floor again last night. Rats, says the sergeant. Big rats.
**WT_TRAP_01** · NARRATION
> A pressure plate clicks underfoot—

### 6.2 Banner clue — `WT_BANNER` [CANON clue / C-confirmed lines]
**WT_BANNER_01** · NARRATION
> An old royal banner hangs in tatters. The symbol stitched at its center...
**WT_BANNER_02** · NARRATION [CANON]
> ...is the same mark carved on Mira's pendant.
**WT_BANNER_03** · Kael
> A royal banner. Mira's pendant. Same mark.
> Why would the crown share anything with a girl from Greyhaven?
[STAGE] Set `flag_banner_clue`. The pendant icon pulses briefly [C-confirmed]. Don't show the symbol's design until Kevin defines it; use a placeholder sprite. The doc says the same symbol is connected to the Crownveil. Kael doesn't know that yet, so he doesn't say it.

### 6.3 The Fallen Knight, second line — `FK_02` [CANON line / C-confirmed placement]
[STAGE] [C-confirmed] At the top of the stairs down to the Basement, the Fallen Knight is waiting again. He doesn't fight.

**FK_02_01** · Kael
> You. Talk. Where is my sister?
**FK_02_02** · Fallen Knight [CANON]
> “She opened the door.”
**FK_02_03** · Kael
> What door? —
[STAGE] The knight descends into darkness and is gone. Set `flag_fk_seen_2`. Advance to `Q_FM_S8`.

---

## 7. Watchtower Basement — Architect carvings

### 7.1 Carvings — `WB_CARVING` [CANON imagery / C-confirmed lines]
[STAGE] A wall-sized relief. Design: a giant crown surrounding a black sun. Below it, a woman stands before a stone door. The woman resembles Mira, even though the carvings are thousands of years old [CANON].

**WB_CARVING_01** · NARRATION
> A great crown, carved around a black sun.
**WB_CARVING_02** · NARRATION
> Beneath it, a woman stands before a stone door.
**WB_CARVING_03** · NARRATION
> The stone is worn smooth by thousands of years. The face is not.
**WB_CARVING_04** · Kael
> ...Mira?
> No. That's not possible.
**WB_CARVING_05** · Kael
> This was old before Greyhaven had a name. So why does it have her face?
[STAGE] Set `flag_carvings_seen`. Don't explain the resemblance; that is open.

---

## 8. Blackguard Arena — Zone 1 boss

[STAGE] Kael enters. The Blackguard, a former Royal Knight corrupted by the Ash, is in full armor with sword and shield [CANON].

### 8.1 Intro — `BG_INTRO` [CANON, verbatim]
**BG_INTRO_01** · Blackguard
> “You shouldn’t have come here.”
**BG_INTRO_02** · Kael
> “Where is my sister?”
**BG_INTRO_03** · Blackguard
> “You still don’t know.”
**BG_INTRO_04** · Kael
> “Know what?”
**BG_INTRO_05** · Blackguard
> “What she opened.”

[STAGE] Battle: The Blackguard (450 HP, weak to Holy). Phases [CANON]:
- **Phase 1, The Knight:** Heavy Slash, Shield Bash, Guard, Counter.
- **Phase 2, The Corruption (60% HP):** the helmet cracks and Ash pours from the armor. Attack goes up and the shield is lost. Ash Slash, Dark Lunge, Blood Oath.
- **Phase 3, Hollow Knight (20% HP):** the armor is engulfed in Ash. Attack +40%, Speed +30%, Defense −20%. New ability: Execution.

Phase-change barks [C-confirmed; the boss says nothing else in canon, so these are optional]:
**BG_PHASE2_01** · NARRATION
> His helmet cracks. Ash pours from the seams of his armor.
**BG_PHASE3_01** · NARRATION
> The armor is swallowed in Ash. What's inside no longer moves like a man.

### 8.2 Defeat — `BG_DEFEAT` [CANON, verbatim]
**BG_DEFEAT_01** · Blackguard
> “The girl didn’t disappear, Kael.”
**BG_DEFEAT_02** · Kael
> “What did you say?”
**BG_DEFEAT_03** · Blackguard
> “She crossed the Crownveil.”

[STAGE] Rewards [CANON]: 250 XP, 100 Gold, Blackguard's Longsword, Crownveil Fragment.
**BG_REWARD_01** · SYSTEM
> Obtained: Blackguard's Longsword. Obtained: Crownveil Fragment.

[STAGE] Whether the Blackguard dies, crumbles or lingers is unspecified. [C-confirmed] He collapses into ash and empty armor. Kevin may prefer otherwise.

---

## 9. Crownveil Door — chapter ending — `CV_END` [CANON events / C-confirmed lines]

[STAGE] Beyond the arena is a sealed stone door. Whether it is the passage beneath Greyhaven is still open, so the script doesn't say.

**CV_END_01** · Kael [C-confirmed]
> The Crownveil. The thing that's supposed to keep us safe.
> ...Mira. What did you do?
**CV_END_02** · NARRATION [CANON event]
> The pendant at Kael's chest grows warm. It is reacting to the door.
**CV_END_03** · NARRATION [CANON event]
> Something touches the other side.
**CV_END_04** · NARRATION [CANON event]
> Then everything stops.

[STAGE] Hard cut to black and silence [C-confirmed]. What "everything stops" means is open, so the presentation doesn't explain it.
Complete `Q_MAIN_FIND_MIRA`. Start `Q_MAIN_BEYOND_VEIL` (`Q_BV_S1`) [CANON quest change].

**CV_END_05** · SYSTEM
> Quest updated: Find Mira → Beyond the Veil.
**CV_END_06** · SYSTEM
> Chapter 1 — The Night of Ash — Complete.

[STAGE] Set `flag_chapter1_complete`. Offer a save [C-confirmed].

---

## Approved (Kevin, Nov 14 2026)

Kevin approved all of the following as canon. Item 9 resolved to the guaranteed Watchtower Hunter option.

1. Survivor names and roles: Pell (young helper tending Tomas, runs the forge shop), Hob (tavern keeper), Sister Ilse (chapel keeper, faith left unnamed), Marda (shopkeeper), Old Wenna and Dov (Town Square), Corwin (North Gate watchman).
2. Tomas lies in his ruined forge (the Blacksmith) and lapses into unconsciousness without dying on screen.
3. All non-canon dialogue lines, including Kael's lines, the Bandit's taunts, and the arrival narration.
4. Sister Ilse is the one who told Mira to throw the black stone away. The doc doesn't say who.
5. Dov's line that Mira "found a door in the ground" under the town. It's a hint at the canon passage that doesn't say where it is.
6. The "small tracks heading north" and the Fallen Knight walking toward the Watchtower, which give the player a reason to follow the route.
7. Tutorial text, including the Cheap Shot warning and the Last Stand popup.
8. Renn's personality and his quest "Thinning the Pack": defeat 5 Ash Wolves, return to Renn, get the Hunter's Charm. Also his dialogue and the hint that wolves are weak to fire.
9. The Ashbound parchment is a key item. The first Ashbound Hunter fight in the Old Watchtower is guaranteed, so the parchment can't be missed.
10. Fallen Knight placement and staging: line 1 at the Bandit Camp's north exit, line 2 at the top of the Watchtower Basement stairs. He never fights or gets named in these scenes.
11. Watchtower lore notes (soldiers' notes about the post closing and scratching under the floor), the key name, and the trap and symbol text.
12. The pendant pulsing at the banner and warming at the door. Warming is my wording for the canon "reacts."
13. Boss phase narration barks, and the Blackguard collapsing into ash and empty armor after defeat.
14. Ending presentation: Kael's line at the door, a hard cut to black for "everything stops," and a save prompt.
15. Quest descriptions and stage objective text for Find Mira and Beyond the Veil.
16. The basic shops: Pell's equipment stock and Marda's Minor Potion and Antidote stock.
