# ASHEN CROWN — Chapter 2 Script: "The Weight of the Yoke" (Act II: The Broken Crown)

Route: Crownveil Door → Old Watchtower (backtrack) → optional Greyhaven → Millhaven Road → Wrenfield → handoff toward Valemere.
> **Status: DRAFT.** Kevin approved the six Chapter 2 decisions on Nov 14 2026, not this script as a whole. Those six choices, and only the facts they settle, are **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026). Every other new line and texture stays **[PROPOSED]**.
> Chapter title: **The Weight of the Yoke** **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026). Suggested levels (8–10) stay **[PROPOSED]**. The act title is **The Broken Crown** **[CANON]**. **The Broken Yoke** is the rebellion's name only **[C-confirmed]**.

Source of truth: `STORY_BIBLE.md`. Presentation: FF1-style top-down exploration (confirmed). Battles are presumed to be FF1-style menu battles (still open).

## How to read this file (for Coder)

- Every dialogue node has a stable ID: `ZONE_PLACE_NN`. Coder can key a dialogue database on these IDs.
- Format: `**ID** · Speaker` followed by the dialogue-box text. Each `>` line is one box line: at most 2 lines per box, each under 90 characters. A node with more than 2 lines is several boxes in sequence (each pair of lines is one box).
- `NARRATION` = text with no speaker. `SYSTEM` = tutorial or UI text. `[STAGE]` = direction for Coder and Design, not shown in game.
- Tags: **[CANON]** = exact text or event from the design doc. **[C-confirmed]** = already decided by Kevin (including the Act II decisions of Nov 14 2026, and the six Chapter 2 decisions of the same day). **[PROPOSED]** = new lines or texture in this draft, not approved with those six decisions. Untagged nodes inside a scene take that scene's tag.
- Suggested story flags are in `code` font (e.g. `flag_taren_recruited`). They are only suggestions, and Coder should match them to the real project.
- Ordinary people, soldiers, and early Kael say **Architects**, not Aethari (**[C-confirmed]** naming guide). The party has not learned the old name yet.
- Nothing here names or reveals the Fallen Knight, explains the Ash, says what destroyed Greyhaven, settles Elira's or Tomas's fate, says where Kael, Taren and Alden grew up, defines the Broken Yoke's leadership, or explains the Crownveil, Lumen, or the Crown Engine. All of those stay open in the bible.
- The first Act II Fallen Knight sighting is confirmed for the road to Valemere after Taren has joined. The outline places that road in Chapter 3. Do not play it in this chapter.

---

## 0. Quest text

### Main quest: Beyond the Veil — `Q_MAIN_BEYOND_VEIL` [CANON title / C-confirmed Chapter 1 description]

**Description:** "She crossed the Crownveil." The pendant answered the sealed door. Mira is somewhere beyond. **[C-confirmed]** (carried from Chapter 1)

Chapter 2 uses stages 1–3 of the Act II quest plan. Stage IDs and objective text are **[PROPOSED]**; the completion events for S1–S3 match confirmed Act II decisions.

| Stage | ID | Objective text | Completes when |
|---|---|---|---|
| 1 | `Q_BV_S1` | Find a way beyond the Veil. *(carried out of Chapter 1)* | Kael leaves the sealed door and takes the road toward Millhaven (the hook has been heard) |
| 2 | `Q_BV_S2` | Seek help near Millhaven. | Taren is recruited |
| 3 | `Q_BV_S3` | Travel to Valemere for answers. | The party enters Valemere *(Chapter 3 picks this up.)* |

### Side quest: The One on the List — `Q_SIDE_ODA` **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)

**Giver:** Oda, Wrenfield square (before the hanging is stopped). **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) The close-call prisoner is her brother **Bram**. **Reward:** Minor Potion x2, 40 Gold **[PROPOSED]**.
**Description:** Oda's brother Bram was seized as a Yoke sympathizer and is among the accused in the square.

| Stage | ID | Objective text | Completes when |
|---|---|---|---|
| 1 | `Q_SO_S1` | Find Bram among the accused in Wrenfield square. | The hanging is stopped and Bram is alive |
| 2 | `Q_SO_S2` | Speak to Oda in the square. | Turn-in played |

If the player never speaks to Oda before the rescue, the quest can still start and complete on a single talk with her afterward **[PROPOSED]** staging.

---

## 1. Crownveil Door — waking — `CV_WAKE`

**[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) Act II begins with Kael coming to on *this* side of the sealed stone door. The door is still sealed. The pendant is quiet. Nothing explains the blackout. What "everything stops" means stays **[O]**.

[STAGE] Load the Chapter 1 ending room. No fade-from-black explanation. The save from the end of Chapter 1 resumes here. The door cannot be opened. The Fallen Knight is not here.

**CV_WAKE_01** · NARRATION **[C-confirmed event / PROPOSED wording]**
> Kael comes to on the stone. The sealed door is still in front of him.
> The pendant at his chest is quiet.

**CV_WAKE_02** · Kael **[PROPOSED]**
> ...Mira?

**CV_WAKE_03** · NARRATION **[PROPOSED]**
> He puts a shoulder to the door. It does not move.
> Nothing answers from the other side.

**CV_WAKE_04** · Kael **[PROPOSED]**
> So I can't follow her this way.

[STAGE] Interactable: the Blackguard's empty armor, still in a heap of ash where it fell **[C-confirmed]** Chapter 1 defeat; this revisit is **[PROPOSED]**.

**CV_WAKE_05** · NARRATION *(empty armor)* **[PROPOSED]**
> Empty armor in a heap of ash. Whoever wore it is gone.

**CV_WAKE_06** · NARRATION *(the door, if examined again)* **[PROPOSED]**
> Sealed. The pendant does not warm this time.
> She is on the other side of this. He is not.

[STAGE] Set `flag_act2_started`. `Q_MAIN_BEYOND_VEIL` is already active at `Q_BV_S1`. The way back through the Watchtower is open; locked doors and keys from Chapter 1 stay resolved so the player is not gated on a second clear.

---

## 2. Old Watchtower, backtrack — `WT2_BACK` **[PROPOSED]**

[STAGE] A clear path from the basement and arena back to the Watchtower entrance and the Old Road. Random encounters may be reused from Zone 1 at a slightly higher band, or kept light. Do not restage the Blackguard, the banner clue, or the Fallen Knight.

**WT2_BACK_01** · Kael **[PROPOSED]**
> Back the way I came, then. There has to be another path.

**WT2_SIGN_01** · NARRATION *(entrance sign, same text as Chapter 1)* **[C-confirmed]**
> Old Watchtower. Property of the Crown. Closed by order.

**WT2_BANNER_R1** · NARRATION *(if the banner is examined again)* **[C-confirmed]** symbol / **[PROPOSED]** wording
> The torn royal banner still hangs here. A crown ringing a black sun.
> The same mark as Mira's pendant.

---

## 3. Optional return to Greyhaven — `GH2` **[C-confirmed as optional / PROPOSED lines]**

**[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) Kael may optionally stop in Greyhaven on his way. Tomas is still unconscious in the forge, tended by Pell. Elira is not resolved. Survivors still do not explain the destruction.

[STAGE] Greyhaven is still a safe area with no random battles. All Chapter 1 survivors are where they were. This stop is skippable. If the player never comes here, the Millhaven Road hook in section 4 still sends Kael to Wrenfield, so the hook cannot be missed.

### 3.1 Pell and Tomas — `GH2_FORGE`

[STAGE] Tomas lies on the same pallet in the ruined Blacksmith. He does not wake, and he does not die. Talking to Pell or Tomas starts these lines.

**GH2_TOMAS_01** · NARRATION **[PROPOSED]**
> He's breathing. Barely. No worse than when Kael left.
> No better, either.

**GH2_PELL_01** · Pell **[PROPOSED]**
> You're back. I thought you'd gone into those woods and stayed there.
> He's been in and out. Mostly out.

**GH2_PELL_02** · Kael **[PROPOSED]**
> Keep doing what you're doing.

**GH2_PELL_03** · Pell **[C-confirmed hook / PROPOSED wording]**
> If you're heading out again, listen. Crown's been hanging people
> near Millhaven. Wrenfield, they said. Aiding the rebellion.

**GH2_PELL_04** · Pell **[C-confirmed hook / PROPOSED wording]**
> And someone swore they saw Taren Holt with the Broken Yoke.
> Your Taren. I thought you should hear it from a friend.

**GH2_PELL_05** · Kael **[PROPOSED]**
> Taren. Near Millhaven.
> ...Then that's where I'm going.

[STAGE] Set `flag_hook_taren`. If this is the first time the hook is heard, keep `Q_BV_S1` active until Kael takes the road toward Millhaven, then advance to `Q_BV_S2`.

Repeat talk with Tomas, **GH2_TOMAS_R1** · NARRATION **[PROPOSED]**:
> Still out. Still breathing.
Repeat talk with Pell, **GH2_PELL_R1** · Pell **[PROPOSED]**:
> Wrenfield, near Millhaven. That's all I know. I'll stay with him.

### 3.2 Other survivor barks **[PROPOSED]**

These are optional. They do not explain the destruction, and they do not settle Elira.

**Rusted Boar Tavern: Hob**
**GH2_HOB_01** · Hob
> Back already? Either you found her, or you didn't.
> You don't look like a man who found her.
**GH2_HOB_02** · Kael
> She's alive. That's what I know.
**GH2_HOB_03** · Hob
> I'll take alive. Drink's the same price as yesterday.
> Ashes didn't make it cheaper.

**Greyhaven Chapel: Sister Ilse**
**GH2_ILSE_01** · Sister Ilse
> I prayed you would bring her home. I see that you have not.
> I will keep praying, if that is still welcome.
**GH2_ILSE_02** · Kael
> Pray for a way through a door that won't open.
**GH2_ILSE_03** · Sister Ilse
> Then I will pray for that too.

**General Store: Marda**
**GH2_MARDA_01** · Marda
> You again. Shelves are the same. Prices are the same.
> Don't look at me like that. Coin's still coin.
[STAGE] Shop stock can match Chapter 1, with any Zone 2 items Design wants to add.

**Town Square: Old Wenna**
**GH2_WENNA_01** · Old Wenna
> The well still runs. The rest of us are doing the same.
> Go on, if you're going. We'll be here.

**Town Square: Dov**
**GH2_DOV_01** · Dov
> Did you find her? Mira. You went north.
**GH2_DOV_02** · Kael
> I found where she went. I haven't reached her yet.
**GH2_DOV_03** · Dov
> She said the door was hers. I should've believed her.

**North Gate: Corwin**
**GH2_CORWIN_01** · Corwin **[C-confirmed hook if not yet heard / PROPOSED wording]**
> In and out again? Fine. You should know: Crown patrols have been
> hanging "sympathizers" at Wrenfield, near Millhaven.
**GH2_CORWIN_02** · Corwin
> A drover told me Taren Holt was seen there, with the Broken Yoke.
> If that's your business, I'd move before the ropes do.
**GH2_CORWIN_03** · Kael
> It is now.
[STAGE] Set `flag_hook_taren` if it is not set. The North Gate sign is unchanged **[C-confirmed]**:

**GH2_GATE_SIGN** · NARRATION
> North Gate. Keep it barred after dark.

[STAGE] Set `flag_greyhaven_return` if this area is entered. When Kael leaves Greyhaven bound for the Millhaven Road with `flag_hook_taren` set, complete `Q_BV_S1` and start `Q_BV_S2`.

---

## 4. Millhaven Road — `MR` **[PROPOSED area / C-confirmed hook]**

[STAGE] A new overworld road leading toward the Millhaven area and Wrenfield. Suggested level 8–10. Encounters may include Crown Patrols (human soldiers, not Ash-corrupted) as well as Bandits and Ash Wolves from Zone 1. Do not describe or tour Millhaven **[O]**. A signpost may name it. **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) The hook is unmissable on this road: a traveler, with a Crown notice as backup. If Greyhaven was visited, Pell and Corwin have already said the same thing; this road still carries the hook if that stop was skipped.

### 4.1 Unmissable hook — `MR_HOOK`

[STAGE] **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) A traveler on the first stretch of the road delivers the hook. A Crown notice nailed to a post is the backup, so the hook cannot be missed. The traveler's and notice's exact wording stays **[PROPOSED]**. If `flag_hook_taren` is already set, the traveler can still talk, but the quest does not need to wait on this scene.

**MR_SIGN_01** · NARRATION *(signpost)* **[PROPOSED]**
> Wrenfield. Millhaven beyond. Valemere by the west road.

**MR_NOTICE_01** · NARRATION *(weathered Crown notice)* **[PROPOSED]**
> By order of the Reeve at Wrenfield: those who aid the rebellion
> will hang. Public judgment at midday.

**MR_HOOK_01** · Traveler **[C-confirmed hook / PROPOSED wording]**
> If you're headed south, don't go through Wrenfield today.
> They're hanging folk for aiding the rebellion.
**MR_HOOK_02** · Traveler
> I saw Taren Holt in the square. Sword out. Arguing with the Reeve.
> He always did have more nerve than sense.
**MR_HOOK_03** · Kael
> You know him?
**MR_HOOK_04** · Traveler
> Everyone near Millhaven knows Taren. Or they did.
> I wouldn't linger. The ropes were already out.
**MR_HOOK_05** · Kael
> Then I'm not lingering.

[STAGE] Set `flag_hook_taren`. Complete `Q_BV_S1` if it is still active and start `Q_BV_S2`. Repeat talk, **MR_HOOK_R1** · Traveler:
> Wrenfield. Midday. I wouldn't be there.

### 4.2 Road texture **[PROPOSED]**

**MR_ENTER_01** · Kael
> Near Millhaven. Taren's country.
> If he's in that square, I'm not leaving him in it.

*(He can mention Millhaven as Taren's origin **[C-confirmed]** without describing the place or saying they grew up there **[O]**.)*

**MR_STONE_01** · NARRATION *(old carved stones by the road)*
> Old stones half-sunk in the grass. Architect work, if Kael had to guess.
> The carvings are too worn to read.

**MR_STONE_02** · Kael
> More Architect stones. Not a door this time.
> Good.

**MR_PATROL_01** · Crown Soldier *(optional scripted patrol bark, before a fight)*
> Halt. This road is under watch until Wrenfield is settled.
**MR_PATROL_02** · Kael
> I'm passing through.
**MR_PATROL_03** · Crown Soldier
> Everyone's passing through, until they aren't. Move along,
> or fall in and be counted.

[STAGE] The patrol can be avoided or fought (`enc_crown_patrol`). They are ordinary soldiers. Some sound unwilling. Do not mark them as Ash-corrupted.

---

## 5. Wrenfield approach — `WF_APPROACH` **[C-confirmed setting / PROPOSED texture]**

**[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) Wrenfield is the Crown-occupied village near Millhaven. The Crown has seized several villagers, accused of aiding the rebellion, and scheduled them for public execution.

[STAGE] Set `flag_wrenfield_entered` on first entry. Suggested level 8–10. Checkpoints on the road in. Notices naming the accused as Yoke sympathizers. The square has been cleared for a hanging. Ordinary soldiers hold the line. Some look unwilling. The Crown is not a cartoon. No random battles inside the village.

**WF_GATE_01** · Crown Sergeant **[PROPOSED]**
> Square's open for judgment. In or out. Make it quiet.

**WF_GATE_02** · Kael **[PROPOSED]**
> I'm going in.

**WF_GATE_03** · Crown Sergeant **[PROPOSED]**
> Then keep your hands where I can see them. Reeve Calder
> is already reading the names.

**WF_NOTICE_01** · NARRATION *(posted list)* **[PROPOSED]**
> A list of the accused, nailed to the post. "Aiding the Broken Yoke."
> Four names. One of them is Bram.

Repeat talk with the sergeant, before the hanging is stopped — **WF_GATE_A1** · Crown Sergeant:
> You heard me. In or out.

### 5.1 Village barks, before the rescue (`_A`) **[PROPOSED]**

**WF_SOLDIER_A1** · Crown Soldier *(unwilling, on the edge of the square)*
> Don't look at me. I don't tie the knots.
> I just hold the line.
**WF_SOLDIER_A2** · Crown Soldier *(another, firmer)*
> Rebellion starts with a loaf and ends with a rope.
> Remember that, if you came to gawk.

**The Bent Post: Perrin, the tavern keeper**
**WF_TAVERN_A1** · Perrin
> Bar's closed till the square's done. I don't pour for a hanging.
> You want a drink, come back when the ropes are down.
**WF_TAVERN_A2** · Kael
> They will be.
**WF_TAVERN_A3** · Perrin
> Bold words. I'd keep them off the Reeve's ears.

**Store: Len, the shopkeeper**
**WF_STORE_A1** · Len
> Shop's shut. You can stare at the shutters like everyone else.
> I'm not selling while my neighbors are on a scaffold.

**Oda, in the crowd** *(side quest giver)* **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) as Bram's sister and the giver of "The One on the List." Her lines stay **[PROPOSED]**.
**WF_ODA_A1** · Oda
> Please— they took my brother. Bram. He's on the list.
> He mended a cart for a stranger. That's all he did.
**WF_ODA_A2** · SYSTEM *(choice)*
> Accept? [Yes] [No]
**WF_ODA_A3_YES** · Oda
> He's in the square. The tall one, on the right. Please reach him.
**WF_ODA_A4_NO** · Oda
> Then I'll reach him myself, if I have to go under the horses.
[STAGE] Yes: start `Q_SIDE_ODA` at `Q_SO_S1`. No: she remains in the crowd; the quest can still start after the rescue.

---

## 6. The gallows — `WF_GALLOWS` **[C-confirmed events / PROPOSED lines]**

[STAGE] Midday. Several villagers are bound at the gallows (four, if the posted list is used). **Reeve Calder** stands on the platform and is reading the sentence. He believes he is keeping order in an unstable kingdom **[C-confirmed]**. **Taren Holt** is already in the square, bastard sword in hand, working toward the scaffold without charging it yet — he is trying to stop the hanging without getting the prisoners killed in the rush **[PROPOSED]** timing. Kael enters from the road. There is no time for a reunion.

**[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) A rope is already on a neck when they reach the gallows. All of the accused are cut down alive.

**WF_GALLOWS_01** · Reeve Calder **[PROPOSED]**
> By order of the Crown, these four gave aid to the Broken Yoke.
> The sentence is death. Let the village see it done.

**WF_GALLOWS_02** · NARRATION **[C-confirmed event / PROPOSED wording]**
> On the right-hand gallows, a noose is already on a young man's neck.
> The rope is taut. His feet have almost left the boards.

**WF_GALLOWS_03** · Taren **[PROPOSED]**
> Calder! Cut him down. You want a trial, you can have one.
> You will not have a show.

**WF_GALLOWS_04** · Reeve Calder **[PROPOSED]**
> The trial was held, Holt. You were not invited.

**WF_GALLOWS_05** · Kael **[PROPOSED]**
> Taren!

**WF_GALLOWS_06** · Taren **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> Kael—? Later. The rope.

[STAGE] Kael and Taren reach the right-hand gallows together. Taren cuts the rope (or Kael does, if that plays cleaner). **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) The prisoner with the rope is **Bram**; he hits the boards, alive, gasping. How many other accused there are, and who cuts the rope, stay **[PROPOSED]**. Calder's soldiers close in. Set `flag_close_call`.

**WF_GALLOWS_07** · NARRATION **[C-confirmed event / PROPOSED wording]**
> The rope parts. The young man slams into the boards and draws a breath.
> The other three are still bound. Still alive.

**WF_GALLOWS_08** · Taren **[PROPOSED]**
> Stay down. All of you. Kael— with me.

---

## 7. Reeve Calder — boss intro, fight, and defeat — `WF_CALDER`

**[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) Chapter 2 boss: **Reeve Calder**, a Crown occupation officer who believes he is keeping order. Human, not Ash-corrupted. He is fought with a small detachment of soldiers **[PROPOSED]** kit direction.

### 7.1 Intro — `WF_CALDER_INTRO` **[PROPOSED]**

**WF_CALDER_INTRO_01** · Reeve Calder
> Stay where you are. This is Crown business.
**WF_CALDER_INTRO_02** · Kael
> You're hanging farmers.
**WF_CALDER_INTRO_03** · Reeve Calder
> I'm hanging traitors. There is a difference,
> even if you have forgotten it.
**WF_CALDER_INTRO_04** · Taren
> There's a rope on a man's neck, Reeve.
> That's the only difference I see.
**WF_CALDER_INTRO_05** · Reeve Calder
> Holt. I should have known the Yoke would show itself.
> And you brought a friend. Put the swords down.
**WF_CALDER_INTRO_06** · Taren
> After you cut the rest of them loose.
**WF_CALDER_INTRO_07** · Reeve Calder
> I have my orders. I intend to keep this village standing.
> Step aside.

[STAGE] Battle start: `enc_reeve_calder`. Reeve Calder plus a small detachment of Crown Soldiers (2–3). Suggested player level 8–10. Not Ash-corrupted. Proposed kit: Guard; a shout that buffs his soldiers; a heavy strike. When the detachment falls, Calder shifts to a harder stance (Attack up, or a tighter guard) and continues alone. Exact stats are for Coder and Design to balance. HP is a placeholder until then.

[STAGE] **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) **Party join, at the start of this fight,** after the close call and the short recognition (`WF_GALLOWS_06`). The longer join conversation happens after the battle (section 8). Taren Holt enters the party. He takes the **2nd party slot**. Starting weapon: a **bastard sword** in the heavy-sword category **[C-confirmed]**. Starting skills: **Rallying Cry**, **Cleave**, and **Unbowed** (passive) **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026). Shield the Line, Breaking Blow, and Banner of the Yoke (a later ability) still have no confirmed unlock levels **[O]**. Formation should allow two frontliners (Kael and Taren). Set `flag_taren_in_battle`.

**WF_CALDER_SYS_01** · SYSTEM **[PROPOSED]**
> Taren Holt has joined the party.
> He takes the second party slot.
**WF_CALDER_SYS_02** · SYSTEM **[C-confirmed facts / PROPOSED wording]**
> Weapon: bastard sword (heavy sword).
> Starting skills: Rallying Cry, Cleave, and Unbowed (passive).
**WF_CALDER_SYS_03** · SYSTEM **[C-confirmed kit text / PROPOSED wording]**
> Rallying Cry raises the party's Attack for 3 turns.
> Cleave hits all enemies for reduced damage.
**WF_CALDER_SYS_03B** · SYSTEM **[C-confirmed kit text / PROPOSED wording]**
> Unbowed: Taren resists Fear and Stun.

*(The 3-turn duration, Cleave's "all enemies, reduced damage," and Unbowed's Fear/Stun resist are **[C-confirmed]** kit text. Exact percentages and MP costs stay **[O]**. Do not invent numbers.)*

**WF_CALDER_SYS_04** · SYSTEM *(optional, the first time Rallying Cry is used)* **[PROPOSED]**
> Rallying Cry: Taren leads the line. Kael is the one who holds it.

Phase-change bark **[PROPOSED]**, when the last Crown Soldier in the detachment falls:

**WF_CALDER_PHASE2_01** · Reeve Calder
> Hold, then. I'll finish this myself.

### 7.2 Defeat — `WF_CALDER_DEFEAT`

**[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) Calder is beaten and **yields**. He lives, and withdraws with his remaining men to the village checkpoints. Wrenfield stays occupied. Exact defeat lines stay **[PROPOSED]**. He should still read as a man who thought he was protecting the kingdom.

**WF_CALDER_DEFEAT_01** · Reeve Calder
> Enough. I'll not spend another man on this square.
**WF_CALDER_DEFEAT_02** · Taren
> Then cut them loose and get off the boards.
**WF_CALDER_DEFEAT_03** · Reeve Calder
> You haven't won this village. You've only borrowed it.
> The Crown will be back before the week is out.
**WF_CALDER_DEFEAT_04** · Kael
> We're not staying.
**WF_CALDER_DEFEAT_05** · Reeve Calder
> No. Men like you never do. You leave other people
> to live in what you've made.

[STAGE] Calder withdraws toward the far checkpoint with whatever soldiers can walk. The four accused are cut free. Bram is alive. The gallows still stand. Wrenfield remains occupied; the party does not liberate the region **[C-confirmed]**. Set `flag_execution_stopped`. Rewards are for Coder to set (placeholder: XP and gold appropriate to level 8–10). No Ash item, and no unique "corrupted" drop.

**WF_CALDER_REWARD_01** · SYSTEM **[PROPOSED]**
> The accused are free. The Crown has pulled back to the checkpoints.
> Wrenfield is still under occupation.

---

## 8. Aftermath and Taren's join — `WF_JOIN` **[C-confirmed beats / PROPOSED lines]**

[STAGE] Quiet in the square, not a celebration. Villagers cut the last ropes and take the accused down. Taren and Kael finally have a moment. Taren's personal stake is already confirmed: freedom is worth fighting for, and these are people the Crown would hang to keep its grip. He does not turn this into a recruitment speech for the Yoke. He joins Kael's search. They do not settle where the three of them grew up **[O]**.

**WF_JOIN_01** · Taren **[PROPOSED]**
> Kael Varyn. You pick your hours.
**WF_JOIN_02** · Kael **[PROPOSED]**
> You're one to talk.
**WF_JOIN_03** · Taren **[PROPOSED]**
> I heard about Greyhaven. I was coming, and then this
> happened first. Tell me you found her.
**WF_JOIN_04** · Kael **[PROPOSED]**
> No body. A pendant she left in the house.
> And a parchment that said she's alive.
**WF_JOIN_05** · Kael **[PROPOSED]**
> A thing at the end of the road said she crossed the Crownveil.
> I found the door. It wouldn't open.
**WF_JOIN_06** · Taren **[PROPOSED]**
> Then we find another way. I'm with you.
> You're not walking this one alone.
**WF_JOIN_07** · Taren **[PROPOSED]**
> The Yoke's fight and yours are going to keep crossing.
> I can live with that if you can.
**WF_JOIN_08** · Kael **[PROPOSED]**
> I just need to find Mira.
**WF_JOIN_09** · Taren **[C-confirmed Alden beat / PROPOSED wording]**
> Then Valemere's the next step. Official doors won't open,
> but people will talk, if you know where to stand.
**WF_JOIN_10** · Taren **[C-confirmed Alden beat / PROPOSED wording]**
> Alden's in the capital, talking to people who still think
> the Crown will save them. He'll want to see you.
**WF_JOIN_11** · Kael **[PROPOSED]**
> Alden. It's been a while.
**WF_JOIN_12** · Taren **[PROPOSED]**
> For all three of us. Come on. We shouldn't linger
> while Calder's still got a checkpoint on the west road.

[STAGE] Taren was already added to the party at the start of the boss **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026). Do not add him a second time here; this is the longer join conversation only. He is a permanent party member **[C-confirmed]**. Set `flag_taren_recruited`. Complete `Q_BV_S2`. Start `Q_BV_S3`: Travel to Valemere for answers. Party size is now 2.

Repeat talk with Taren in Wrenfield, **WF_JOIN_R1** · Taren **[PROPOSED]**:
> Valemere when you're ready. Alden's there. So are answers,
> if the Crown hasn't locked them all in a drawer.

---

## 9. Wrenfield after the rescue (`_B`) **[PROPOSED]**

[STAGE] The village is relieved and still afraid. Soldiers have pulled back to the checkpoints, not left the area. Shops may open. The gallows remain.

**WF_GATE_B1** · Crown Sergeant
> Reeve says you get the road. He didn't say you get the village.
> Don't make me sorry I opened the bar.
**WF_SOLDIER_B1** · Crown Soldier *(the unwilling one)*
> I'm glad the ropes came down. I won't say that twice.
> Don't ask me to say it where Calder can hear.
**WF_SOLDIER_B2** · Crown Soldier *(the firmer one)*
> You bought them a week, maybe two. Don't call it a victory.

**Perrin, the tavern keeper**
**WF_TAVERN_B1** · Perrin
> Bar's open. First one's on the house, because I have a conscience
> and almost had a funeral. After that, coin.
[STAGE] Optional inn / tavern rest point.

**Len, the shopkeeper**
**WF_STORE_B1** · Len
> Shutters are up. Prices are what they are.
> I'd rather sell you a potion than a wreath.
[STAGE] Shop: Minor Potion, Antidote, and any mid-tier items Design wants for level 8–10.

### 9.1 Side quest turn-in — `WF_ODA_B`

**WF_ODA_B1** · Oda *(if the quest is active, or if she is spoken to for the first time after the rescue)*
> Bram's alive. He can't talk yet, but he's alive.
> You reached him. I won't forget that.
**WF_ODA_B2** · SYSTEM
> Obtained: Minor Potion x2, 40 Gold.
**WF_ODA_B3** · Bram *(optional, if spoken to)*
> I mended a cart. That's all. Tell them that,
> if they come back with more rope.

[STAGE] Complete `Q_SIDE_ODA`. Set `flag_oda_done`. If Oda was never spoken to before, this scene can start and finish in one talk.

**WF_BRAM_B1** · NARRATION *(if Bram is examined and does not speak)*
> He's alive. His neck will remember the rope longer than he wants it to.

---

## 10. Handoff toward Valemere — `WF_HANDOFF` **[C-confirmed direction / PROPOSED lines]**

[STAGE] A west-road exit from Wrenfield, past Calder's remaining checkpoint, with a sign toward Valemere. Leaving this way ends Chapter 2. Do **not** play the Fallen Knight sighting here. That sighting is confirmed for the road to Valemere after Taren has joined, and the outline places it in Chapter 3.

**WF_WEST_SIGN** · NARRATION **[PROPOSED]**
> West: Valemere. The capital road.

**WF_HANDOFF_01** · Taren **[PROPOSED]**
> That's our road. Stay sharp. Calder meant it
> when he said the Crown would be back.
**WF_HANDOFF_02** · Kael **[PROPOSED]**
> Let them come. I need answers, and Mira's still out there.
**WF_HANDOFF_03** · Taren **[PROPOSED]**
> Then we go get both. Together this time.

[STAGE] **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) Complete Chapter 2 when the party uses the west road toward Valemere. Show a chapter-complete screen and a save prompt, then hand off to the Valemere road (Chapter 3). `Q_BV_S3` is already active. Set `flag_chapter2_complete`. Exact SYSTEM wording stays **[PROPOSED]**.

**WF_HANDOFF_04** · SYSTEM **[PROPOSED]**
> Quest updated: Travel to Valemere for answers.
**WF_HANDOFF_05** · SYSTEM **[C-confirmed title / PROPOSED wording]**
> Chapter 2 — The Weight of the Yoke — Complete.

[STAGE] Offer a save, in the same spirit as Chapter 1's chapter-complete prompt, without another unexplained blackout. Chapter 3 begins on the road to Valemere, with the first Act II Fallen Knight sighting.

---

## 11. Decisions (Kevin, Nov 14 2026)

Kevin approved all six recommendations on Nov 14 2026, **not** the rest of this script. Chosen options are **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026). Rejected options are kept for the record, struck through. All other new lines, names (except Bram and Oda), and texture in this file stay **[PROPOSED]**.

### 1. Reeve Calder's fate after the fight

**[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) **Option A (chosen):** He is beaten and yields. He lives, and withdraws with his remaining men to the village checkpoints. Wrenfield stays occupied, in his own words. His kit and exact defeat lines stay **[PROPOSED]**.

- ~~**Option B:** He is killed in the fight. The remaining soldiers pull back without him.~~ *(Not chosen.)*
- ~~**Option C:** He is beaten and held by the villagers. The occupation becomes a standoff.~~ *(Not chosen.)*

### 2. When Taren becomes controllable

**[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) **Option A (chosen):** At the start of the Calder fight, after the close call and a short recognition ("Kael—? Later. The rope."). The longer join conversation happens after the battle.

- ~~**Option B:** After the fight only. During the battle Taren is a guest ally, or Kael fights alone.~~ *(Not chosen.)*
- ~~**Option C:** Formal join before the fight, with the full conversation in the square, then the boss.~~ *(Not chosen.)*

### 3. How the hook toward Wrenfield is delivered

Greyhaven remains optional.

**[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) **Option A (chosen):** Unmissable on the Millhaven Road (a traveler, with a Crown notice as backup). If Greyhaven is visited, Pell and Corwin say the same thing. Exact hook wording stays **[PROPOSED]**.

- ~~**Option B:** A Crown notice-board only, with no traveler.~~ *(Not chosen.)*
- ~~**Option C:** Pell only, which would make the Greyhaven stop required.~~ *(Not chosen.)*

### 4. Taren's starting skills

**[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) **Option B (chosen):** Rallying Cry and Cleave, plus Unbowed (passive) from the start. Shield the Line, Breaking Blow, and Banner of the Yoke still have no confirmed unlock levels **[O]**. Exact numbers stay **[O]**.

- ~~**Option A:** Rallying Cry and Cleave only at join. Shield the Line, Breaking Blow, and Unbowed unlock later.~~ *(Not chosen.)*
- ~~**Option C:** All confirmed skills except Banner of the Yoke (a later ability) from the start.~~ *(Not chosen.)*

### 5. The close-call prisoner and the optional side quest

**[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) **Option A (chosen):** The prisoner with the rope is **Bram**. His sister **Oda** offers a small optional quest ("The One on the List") that turns in after the rescue. Quest stage text, rewards, and dialogue stay **[PROPOSED]**.

- ~~**Option B:** The close-call prisoner is unnamed, and there is no side quest in Wrenfield.~~ *(Not chosen.)*
- ~~**Option C:** The close-call prisoner is named, but there is no family side quest.~~ *(Not chosen.)*

### 6. Chapter title, and the chapter-complete screen

**[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) **Option A (chosen):** The chapter title is **The Weight of the Yoke**. End on a chapter-complete screen and a save prompt, then hand off to the Valemere road (Chapter 3).

- ~~**Option B:** Retitle the chapter "Wrenfield," with the same chapter-complete presentation.~~ *(Not chosen.)*
- ~~**Option C:** Keep "The Weight of the Yoke," but skip the chapter-complete screen and cut straight to the road.~~ *(Not chosen.)*

---

*Kevin confirmed the six decisions above, not the rest of this script. Remaining [PROPOSED] texture stays until he approves a full Chapter 2 pass. After bible updates, a confirmed excerpt can go to Coder for `docs/story/`.*
