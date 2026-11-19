# ASHEN CROWN — Chapter 5 Script: "The Deserted Oath" (Act II: The Broken Crown)

Route: the Blackwood road out of the hollow → the garrison notice board → the gate → the yard and cell block → the commander's office and records room (Sera) → Commander Hailen → the aftermath and Sera's join → the Blackwood treeline.

> **Status: APPROVED 2026-11-16 — CANON.** The owner approved all eleven decisions in §14 as recommended, so this script is canon in the Chapter 2–4 format and the build may proceed. Line-level **[PROPOSED]** tags stay as provenance (they mark what this script invented rather than inherited), not as open questions; anything still **[O]** is genuinely undecided. **[CANON]** items come from the design doc / `STORY_BIBLE.md`. **[C-confirmed]** items are owner decisions from Nov 14–16 2026.
> **Built 2026-11-16, not played.** `rm_blackwood_garrison`, `rm_garrison_keep`, `scr_ch5_story`, `scr_dialogue_data_ch5` and Sera's kit now exist; `python3 validate_gamemaker.py` passes. Both rooms now build on the `ts_garrison` atlas, but nothing has been compiled or playtested in GameMaker and TEST_PLAN F1–F15 is unchecked.
> Title: **The Deserted Oath** **[C-confirmed 2026-11-16]**. Levels: **16–18** **[C-confirmed 2026-11-16]** (matches the existing `blackwood_garrison` table and Hailen at level 18). The act title is **The Broken Crown** **[CANON]**.
> Chapter 5 is the fourth and last chapter of Act II: **Sera's recruitment**, **Commander Hailen**, and the handoff into Act III, **The Blackwood** **[CANON]**.

Source of truth: `STORY_BIBLE.md`. Presentation: FF1-style top-down exploration (confirmed). Battles are presumed to be FF1-style menu battles (still open).

## How to read this file (for Coder)

- Every dialogue node has a stable ID: `PREFIX_PLACE_NN`, as with Chapters 1–4.
- Prefixes: `BG_` for the garrison, its road, gate, yard and records; `SR_` for Sera; `HL_` for Commander Hailen; `BW_` for the Blackwood lead; `FK4_` for the second Fallen Knight sighting.
- Format: `**ID** · Speaker` followed by the dialogue-box text. Each `>` line is one box line: at most 2 lines per box, each under 90 characters. A node with more than 2 lines is several boxes in sequence (each pair of lines is one box).
- `NARRATION` = text with no speaker. `SYSTEM` = tutorial or UI text. `[STAGE]` = direction for Coder and Design, not shown in game.
- Tags: **[CANON]** = exact text or event from the design doc. **[C-confirmed]** = approved by the project owner. **[PROPOSED]** = invented for this draft. **[O]** = an open bible question, untouched.
- Suggested story flags are in `code` font. They are suggestions; Coder should match them to the real project.
- **Naming guide:** the party says **Aethari** in dialogue (they learned it in Chapter 4). UI, bestiary, item and quest text stay on **Architects** for the rest of the game. This is why the quest text below still reads "Architect."
- **What this chapter must not do:**
  - Sera does not say, hint at, or describe what she saw inside the royal palace **[O]** (bible question 4). The chapter protects that refusal in dialogue and does not let anyone ask twice.
  - Nothing explains the Blackwood, the stone door, the missing patrols, the Ash, Mira, Lumen, the Crown Engine, or why the Crownveil broke **[O]**.
  - The Fallen Knight is never named, never fights, and is not connected to anyone. His one line is **[PROPOSED]**.
  - Alden does not appear, is not mentioned as a plan, and does not split from Taren **[O]**.
  - Hailen is not a villain: no Ash corruption, no cruelty, no cowardice. He is a tired officer holding a bad post.
  - The chapter does not define what the Crown intends for Sera beyond transport to the capital, and does not say whether she was formally sentenced **[O]**.

---

## 0. Quest text

### Main quest: Beyond the Veil — `Q_MAIN_BEYOND_VEIL` [CANON title]

**Description:** "She crossed the Crownveil." The pendant answered the sealed door. Mira is somewhere beyond. **[C-confirmed]** (carried from Chapter 1)

Chapter 5 completes stage 6 of the Act II quest plan and opens stage 7.

| Stage | ID | Objective text | Completes when |
|---|---|---|---|
| 6 | `Q_BV_S6` | Investigate the Blackwood Road Garrison. *(carried out of Chapter 4)* | Sera is recruited and the Blackwood lead is in hand |
| 7 | `Q_BV_S7` | Follow the trail into the Blackwood. | *(Act III picks this up.)* |

**No side quest in this chapter [PROPOSED].** The optional content here is the garrison's people and repeat talk. If Design wants one later, the natural hook is a soldier's missing brother in the patrol ledger — but it is not written here.

---

## 1. The Blackwood road — `BG_APPROACH`

[STAGE] Chapter 5 opens on the forest road, a day or two out from the hollow, exactly where Chapter 4 handed off. Late afternoon; pines on both sides, a Crown notice board at a bend, and the garrison palisade ahead where the trees thin. The party is **Kael, Taren, Lyra and Caelan (4 members)**, levels 16–18. **Recommend no random encounters on this stretch or in the post:** this is a story location and the garrison's table belongs to the road around it, not to a walk to the gate. If Design wants fights here, use the existing `blackwood_garrison` table (Pikeman, Field Surgeon, Knight) and keep them outside the palisade.

**BG_ENTER_01** · Taren
> Crown post on a forest road. Half a company, maybe less.
> They'll have a ledger and a bad temper.

**BG_ENTER_02** · Lyra
> Every post has a ledger.
> The trick is not getting written into it.

**BG_ENTER_03** · Caelan
> Patrol reports. Sealed orders. A post like this keeps copies.
> The Blackwood is a day in from their gate.

**BG_ENTER_04** · Kael
> Then we ask politely, read what they've written, and leave.

**BG_ENTER_05** · Taren
> A rebel captain, a thief and a scholar walk up to a Crown gate.
> "Politely" is carrying a lot of weight in that sentence.

**BG_ENTER_06** · Caelan
> I'm not a scholar. I'm a deserter with a spellbook.
> The paperwork is different.

**BG_ENTER_07** · Lyra
> Then we're three deserters and a rebel.
> No wonder the road's so quiet.

### 1.1 The notice board — `BG_NOTICE`

[STAGE] A Crown notice board at the bend: old tax notices, a reward for wolves, and one fresh sheet. This is the first mention of Sera. Do not have the party recognize her name yet; Taren reacts to the crest, not the person.

**BG_NOTICE_01** · NARRATION
> A Crown notice board at the bend, most of it older than the trees.
> One sheet is fresh, and the ink hasn't faded.

**BG_NOTICE_02** · NARRATION *(the notice)*
> DESERTER. SILVER GUARD.
> THORN, S. — LAST SEEN ON THE BLACKWOOD ROAD. REWARD.

**BG_NOTICE_03** · Taren
> Silver Guard. That's a long fall from the palace.
> Or a short walk out of it.

**BG_NOTICE_04** · Kael
> We're not bounty hunters.

**BG_NOTICE_05** · Lyra
> No. But we are looking for records.
> A post holding a deserter will have plenty of both.

**BG_NOTICE_06** · Caelan
> A Silver Guard wouldn't run for coin.
> Whatever she left over, she left it for a reason.

[STAGE] Do not explain that reason here or anywhere in this chapter **[O]**.

---

## 2. The gate — `BG_GATE`

[STAGE] A palisade gate, two pikemen, and a sergeant with a ledger and no sleep. The gate is open; the post is not expecting a fight. Nobody is disarmed yet. The sergeant is competent and tired, not cruel, and follows the ledger exactly — which is what dooms the visit, because Taren Holt's name is in it.

**BG_GATE_01** · Sergeant
> State it.

**BG_GATE_02** · Taren
> Road's worse further on. We're looking for a way through.

**BG_GATE_03** · Sergeant
> Road's not closed. It's just not safe.
> Names. All of them.

**BG_GATE_04** · Kael
> Kael Varyn. Taren Holt.

[STAGE] The sergeant's pen stops. One pikeman looks at the other.

**BG_GATE_05** · Sergeant
> Holt.
> Say that again.

**BG_GATE_06** · Taren
> You heard it the first time.

**BG_GATE_07** · Sergeant
> Hands where I can see them. All of you.
> Pikes up. Not on the ground — on them.

**BG_GATE_08** · Lyra
> Told you. Ledger.

**BG_GATE_09** · Sergeant
> Commander wants a word with this lot.
> Walk ahead of the pikes, and don't be clever.

**BG_GATE_10** · Caelan *(quietly)*
> Four of us, six of them, and a locked gate behind.
> We do this the slow way or not at all.

[STAGE] They keep their weapons and are escorted in. Set `flag_garrison_entered`. No battle, no stealth check.

---

## 3. The yard — `BG_YARD`

[STAGE] A yard of packed earth: a well, a smith's cold forge, a dispatch chest under an awning, and a cell block cut into the palisade wall. Horses. A wagon being loaded. Two pikemen are bringing someone out of the cells — wrists bound in front, a Silver Guard coat with the crest cut away, no chains on the ankles. **Sera Thorn.** She is not beaten and not broken; she is bored in a way that has a knife under it.

**BG_YARD_01** · NARRATION
> A yard of packed earth: a well, a cold forge, a cell block in the wall.
> Two pikemen are bringing someone out of it.

**BG_YARD_02** · Lyra
> That's a Silver Guard coat.

**BG_YARD_03** · Caelan
> With the crest cut off.
> That's not a soldier. That's a message.

**BG_YARD_04** · Kael
> About what?

**BG_YARD_05** · Caelan
> About what happens to the ones who leave.

[STAGE] Sera looks them over: Kael's old army boots, Taren's sword, Lyra's hands, Caelan's ink-stained cuffs. She reaches a conclusion and does not share it.

**BG_YARD_06** · Sera
> You're not Crown.

**BG_YARD_07** · Kael
> Not anymore.

**BG_YARD_08** · Sera
> Then you're either very lost or very stupid.
> The commander will want to know which.

**BG_YARD_09** · Taren
> We're looking for records. Blackwood patrols.
> Missing men, missing carts.

**BG_YARD_10** · Sera
> Of course you are.

**BG_YARD_11** · Sera
> They're in the room behind the commander.
> He keeps them close because he thinks they'll save him.

**BG_YARD_12** · Lyra
> Will they?

**BG_YARD_13** · Sera
> No.

**BG_YARD_14** · Sergeant
> That's enough out of the deserter.
> Sit her down. Commander's coming.

---

## 4. Sera — `SR_MEET`

[STAGE] Sera is put on the bench by the cell block with two pikes on her. The party is left standing in the yard under guard. The conversation is quiet, quick and watched: she is testing whether they are worth the trouble, and she does not volunteer anything about the palace. She is the one who names the sealed order, because she is the only one who has read it.

**SR_MEET_01** · Kael
> Sera Thorn.

**SR_MEET_02** · Sera
> That's on a notice, not a name.
> Try again.

**SR_MEET_03** · Kael
> Seraphine Thorn. Silver Guard.
> You left.

**SR_MEET_04** · Sera
> Everyone leaves eventually.
> Some of us just get written down for it.

**SR_MEET_05** · Taren
> We're not here to take you back.

**SR_MEET_06** · Sera
> I know. You're here for the reports.
> The whole yard heard you ask.

**SR_MEET_07** · Caelan
> You were Silver Guard. Palace duty, by the coat.

**SR_MEET_08** · Sera
> *(a beat)*
> Ask me something I'll answer.

[STAGE] This is the refusal, and it is final for the chapter. Nobody presses it. Caelan, of all people, lets it go — he recognizes the shape of it.

**SR_MEET_09** · Caelan
> The Blackwood. Patrols are vanishing.
> What did the Crown write down about it?

**SR_MEET_10** · Sera
> Missing men. Missing carts. A stone door.
> The same three lines, rewritten every month.

**SR_MEET_11** · Kael
> A stone door.

**SR_MEET_12** · Sera
> And a sealed order telling this post to stop looking.
> That's the part the commander won't hand over.

**SR_MEET_13** · Taren
> Why are you still here? You could have run.

**SR_MEET_14** · Sera
> I did run. This is where they caught me.

**SR_MEET_15** · Sera
> And I'm not running from a post I already left.
> That's not desertion. That's cowardice with a head start.

**SR_MEET_16** · Lyra
> I like her.

**SR_MEET_17** · Taren
> You would.

[STAGE] Do not have her explain the coat, the crest, the palace, the arrest, or what she thinks of the Crown. Those stay **[O]** except where the bible or outline already confirmed them.

---

## 5. Commander Hailen — `HL_INTRO`

[STAGE] Hailen comes out of the office without hurrying: plate, no helmet, a ledger under one arm, grey at the temples. He is courteous, immovable and tired. He knows exactly who Taren Holt is. He believes Sera broke her oath. He believes the party is a rebel cell walking in through his front gate, and he is not entirely wrong about two of them. He is trying to hold a bad road in an unstable kingdom, and he has decided that the sealed order is the only thing keeping his men alive.

**HL_INTRO_01** · NARRATION
> Boots on the yard stones. Unhurried.
> The sergeant steps back without being told to.

**HL_INTRO_02** · Hailen
> Taren Holt.
> I'd hoped the report was wrong.

**HL_INTRO_03** · Taren
> It usually isn't.

**HL_INTRO_04** · Hailen
> No. It usually isn't.

**HL_INTRO_05** · Hailen
> You've met my deserter.
> She's told you about the woods, I expect.

**HL_INTRO_06** · Kael
> She's told us what's written down.

**HL_INTRO_07** · Hailen
> Then you know this post is under orders not to look.
> I intend to keep following them.

**HL_INTRO_08** · Caelan
> Men are disappearing under those trees.
> Orders don't make them come back.

**HL_INTRO_09** · Hailen
> No. But they keep the rest of my men from disappearing too.
> That's the arithmetic I have.

**HL_INTRO_10** · Taren
> The arithmetic's wrong.

**HL_INTRO_11** · Hailen
> Possibly.
> You'll forgive me if I don't take a rebel captain's word for it.

[STAGE] Sera speaks once, and it costs her. She is not begging for herself.

**HL_INTRO_12** · Sera
> Commander. Let them take the reports.
> They'll walk into the woods either way.

**HL_INTRO_13** · Hailen
> And if they walk back out with a rebellion behind them?

**HL_INTRO_14** · Sera
> Then you'll have a rebellion, and the reports will still be a
> month old, and the men will still be missing.

**HL_INTRO_15** · Hailen
> You broke an oath, Thorn.
> Don't lecture me about missing men.

**HL_INTRO_16** · Sera
> I know what I broke.
> I know what I kept.

**HL_INTRO_17** · Hailen
> Holt goes to the cells. The rest of you will be questioned.
> The deserter goes to the capital with the next wagon.

**HL_INTRO_18** · Taren
> You don't want to do this.

**HL_INTRO_19** · Hailen
> No.
> Draw.

[STAGE] Note the naming: Crown soldiers call her **Thorn**; the party starts using **Sera** after the join. Keep that line clean in the dialogue data.

---

## 6. The choice — `HL_CHOICE`

[STAGE] Before initiative, one short choice. This is the switch that decides whether the battle can end with Hailen alive: `scr_enemy_database.gml` already carries `yields_if_flag: "flag_hailen_yields"` on `commander_hailen`, and the flag has to be set **before** the killing blow, so it is set here. The engine's dialogue-choice helper (`scr_dialogue_choice`) exists for exactly this; it has not been used in a chapter yet (see §11).

**HL_CHOICE_01** · Sera
> He's not a bad man. He's a tired one.
> If he yields, let him.

**HL_CHOICE_02** · Kael
> He put us in a cell.

**HL_CHOICE_03** · Sera
> He put me in one too.
> Your call. I've made worse.

[STAGE] Choice box, two options **[PROPOSED]**:

| Option | Effect |
|---|---|
| **"We're not here to kill Crown soldiers."** | Set `flag_hailen_yields`. Hailen can yield at 0 HP. |
| **"He chose this."** | Do not set the flag. Hailen fights to the death. |

**HL_CHOICE_04** · Sera *(if the first option is taken)*
> Then keep your word.
> He'll remember it longer than you will.

**HL_CHOICE_05** · Sera *(if the second is taken)*
> Your call.
> I've made worse.

[STAGE] If the owner prefers no branch, the fallback is to set `flag_hailen_yields` unconditionally in this scene (Hailen always yields) — see §13, decision 4. Do not implement a third branch that revives him after death; the engine resolves yield at 0 HP only.

---

## 7. Commander Hailen — the fight — `HL_FIGHT`

[STAGE] Hailen draws; the pikeman beside him sets his pike; the rest of the garrison backs to the walls. This is a clean, human fight in a yard, not an Ash battle: no corruption, no monster transformations, no dark effects. The garrison does not join in beyond the one pikeman in the group.

**HL_FIGHT_01** · Hailen
> Garrison. Hold the post.
> Not the road. The post.

**HL_FIGHT_02** · SYSTEM
> Commander Hailen and the garrison have drawn steel.

[STAGE] Battle start: `grp_commander_hailen` (`commander_hailen` plus one `garrison_pikeman`). Hailen is level 18 for a party of four: **900 HP / 57 ATK / 32 DEF / SPD 12**, `hp_mult: 1.5` and `atk_add: 14`, action pool Attack and **Steel Glint** (1.4× single). Simulated wins: **52% at party level 16, 78% at 17, 94% at 18**, about 8–9 rounds and 14–30% party HP left. Suggested band 16–18. Balance is Design's; the numbers live in `scr_enemy_database.gml`.

[STAGE] **Sera does not fight in this battle by default** (decision 3). The party is the four from Chapter 4, which is what the balance pass measured. If the owner chooses "Sera joins at the start of the fight," the party becomes five with one reserve and the fight must be re-simulated before shipping.

**HL_FIGHT_03** · Hailen *(at the start of round 2, optional)*
> You're better than the reports said.
> It won't be enough.

**HL_FIGHT_04** · Hailen *(when his pikeman falls, optional)*
> Steady. Steady.

---

## 8. Aftermath — `HL_YIELD` and `HL_DEATH`

[STAGE] Two branches, both ending the battle as a victory with full XP and gold. Play only one.

### 8.1 If `flag_hailen_yields` was set — he yields

**HL_YIELD_01** · NARRATION
> Hailen goes down on one knee, sword across it.
> He does not raise it again.

**HL_YIELD_02** · Hailen
> Enough.
> I won't spend my men on this.

**HL_YIELD_03** · Taren
> Wise.

**HL_YIELD_04** · Hailen
> Practical.
> Don't mistake it for wise.

**HL_YIELD_05** · Hailen
> The reports are in the room behind me.
> Take them and be gone before I change my arithmetic.

**HL_YIELD_06** · Sera
> Commander.

**HL_YIELD_07** · Hailen
> You'll want a coat without a crest.
> The road's cold.

[STAGE] The engine sets `flag_hailen_yielded` at the yield (the `yield_flag` on `commander_hailen`); the story sets `flag_hailen_beaten`. Hailen lives. His men stand down, the wagon is not loaded, and the post stays Crown. Keep him available for a later act as a living officer who remembers this **[PROPOSED, for the outline]**.

### 8.2 If he did not yield — he falls

**HL_DEATH_01** · NARRATION
> Hailen falls before he can order the retreat.
> The yard goes quiet in a way that has nothing to do with victory.

**HL_DEATH_02** · Sera
> He was going to hold this post until it killed him.

**HL_DEATH_03** · Taren
> It did.

**HL_DEATH_04** · Kael
> The reports.

**HL_DEATH_05** · Sera
> Behind him.
> Try to deserve them.

[STAGE] Set `flag_hailen_beaten`; no `flag_hailen_yielded`. The garrison stands down rather than avenging him — a sergeant with a ledger is not going to charge four armed strangers over a commander who lost. Nothing else in the chapter changes; the records room is the same room. Do not write a revenge beat into Act III on the strength of this draft alone.

---

## 9. The records room and the Blackwood lead — `BW_LEAD`

[STAGE] The commander's office: a desk, a dispatch chest, a map table with pins in the Blackwood, and a patrol ledger. The lead is the **sealed order**, not a map to a treasure: the Crown told this post to stop looking, and the wax on that order carries a mark that is not the Crown's. Caelan recognizes the mark and will not explain it **[O]**.

**BW_LEAD_01** · NARRATION
> A dispatch chest, a map table, and a ledger with a month of it missing.
> Someone has been crossing out names.

**BW_LEAD_02** · Caelan
> Patrols. Four of them. Same road, same week of the month.
> None of them came back.

**BW_LEAD_03** · Lyra
> And the Crown's answer was to stop looking.

**BW_LEAD_04** · Caelan
> No. The Crown's answer was to stop writing it down.
> Look at the seal.

**BW_LEAD_05** · NARRATION
> A sealed order, broken once and folded again.
> The wax carries a mark older than the Crown.

**BW_LEAD_06** · Caelan
> That's not a Crown seal.

**BW_LEAD_07** · Kael
> Then whose?

**BW_LEAD_08** · Caelan
> A door. There's a stone door in the Blackwood,
> and someone in the palace knows it.

[STAGE] Do not answer who sealed the order, what the mark is, who in the palace knows, or what is behind the door. Caelan recognizes it and stops — same refusal shape as Chapter 4, different secret. Set `flag_blackwood_lead` after `BW_LEAD_08`.

**BW_LEAD_09** · Sera
> The patrols that vanished were following it.
> Every one of them left the road at the same stone.

**BW_LEAD_10** · Taren
> And the Crown sealed the file instead of the road.

**BW_LEAD_11** · Sera
> The Crown seals what it can't explain.
> It's cheaper than an answer.

### 9.1 Sera's stake — `SR_STAKE`

[STAGE] Her recruitment argument is about the oath, not about the party. She does not denounce the Crown at length, does not renounce honorable soldiers, and does not explain the palace. She keeps the oath she actually made.

**SR_STAKE_01** · Kael
> You could stay. Wait for the wagon.

**SR_STAKE_02** · Sera
> I could.

**SR_STAKE_03** · Sera
> I took an oath to protect people.
> Not a king. Not a road. People.

**SR_STAKE_04** · Sera
> I can keep that oath out there.
> I can't keep it in a cell.

**SR_STAKE_05** · Kael
> Then walk with us.

**SR_STAKE_06** · Sera
> One condition.
> When I say I won't talk about the palace, that's the whole answer.

**SR_STAKE_07** · Sera
> Not a secret I'm saving for a better audience.
> Just the end of it.

**SR_STAKE_08** · Kael
> Understood.

**SR_STAKE_09** · Taren
> That's the first honest thing anyone's said in this yard.

[STAGE] This is the chapter's protection of bible question 4: she names the refusal, the party accepts it, and nobody asks again. Do not have Caelan or Lyra probe it later in the chapter.

---

## 10. Sera's join — `SR_JOIN`

[STAGE] In the yard, with the gate open and the post behind them. Sera joins as the **fifth roster member**: four active, one reserve — the first time the reserve slot does anything in the game. **Who sits is the player's choice** through Party Order; do not force a bench in the story unless the owner asks for one (bible question 36 stays open).

**SR_JOIN_01** · Sera
> Seraphine Thorn. Sera.
> Silver Guard, until I wasn't.

**SR_JOIN_02** · Lyra
> Do you have coin?

**SR_JOIN_03** · Sera
> No.

**SR_JOIN_04** · Lyra *(to Caelan)*
> She's your problem now.
> I'm at capacity.

**SR_JOIN_05** · Caelan
> You're at capacity?

**SR_JOIN_06** · Lyra
> Emotionally.

**SR_JOIN_07** · Sera
> I've been in a cell for a month.
> I'll take the back rank and the first watch.

**SR_JOIN_08** · Taren
> You'll take the fourth slot and like it.
> We'll sort the rest at the next crystal.

**SR_JOIN_09** · Kael
> Welcome to it.

[STAGE] **Seraphine "Sera" Thorn** is a permanent party member **[C]**. Set `flag_sera_recruited`. Party size is now 5 with four active and one reserve **[C-confirmed]**. Do not state whether the reserve earns XP **[O]** (question 36); the Party Order screen already lets the player decide who stands.

**SR_SYS_01** · SYSTEM
> Seraphine "Sera" Thorn has joined the party.
> Five in the roster. Four in battle.

**SR_SYS_02** · SYSTEM
> Weapon: holy sword.
> Starting skills: Mend, Aegis, and Smite.

**SR_SYS_03** · SYSTEM
> Mend: restores HP to one ally. Aegis: raises an ally's defense.
> Smite: holy damage. The restless and the Ashbound fear it.

**SR_SYS_04** · SYSTEM
> Choose who stands. Party Order, in the Adventure menu.
> The reserve stays equipped and out of the fight.

[STAGE] Sera's kit is **[CANON intent]** (bible 5.4: healing, shields, buffs, resurrection, holy damage). **Mend / Aegis / Smite** are **[PROPOSED]** starting-skill names; their numbers stay **[O]**. **No resurrection and no party-wide buff yet** — those are later unlocks **[PROPOSED]**. `mend`, `aegis` and `smite` do not exist in `scr_skill_data.gml`; add them with PLACEHOLDER numbers, using the existing `holy` weakness for Smite (Shade Stalker and Lost One are already holy-weak). Her `holy_sword` weapon exists as an id with no stats yet.

Repeat talk, **SR_JOIN_R1** · Sera:
> The palace isn't a story I tell in courtyards.
> Ask me about the road instead.

Repeat talk, **BG_R1** · Sergeant:
> Commander's orders were to hold the post.
> Nobody said anything about holding it well.

---

## 11. Handoff — the Blackwood treeline — `BG_HANDOFF`

[STAGE] Out the gate, down the short road, to the first trees. The post is behind them; the forest is in front. Two beats: the chapter handoff, then the second Fallen Knight sighting. Do not play the forest. Do not play a Mira sighting. Act III begins here and is unwritten.

**BG_HANDOFF_01** · Taren
> Blackwood road.
> From here the map stops being a map.

**BG_HANDOFF_02** · Caelan
> The stone door is a day in. Maybe less.
> The patrols made it in a day.

**BG_HANDOFF_03** · Lyra
> The patrols didn't come out.

**BG_HANDOFF_04** · Kael
> Then we're better than patrols.

**BG_HANDOFF_05** · Sera
> No. We're fewer.
> It'll have to do.

**BG_HANDOFF_06** · SYSTEM
> Quest updated: Follow the trail into the Blackwood.

**BG_HANDOFF_07** · SYSTEM
> Chapter 5 — The Deserted Oath — Complete.

**BG_HANDOFF_08** · SYSTEM
> Act II — The Broken Crown — Complete.

### 11.1 The Fallen Knight — `FK4`

[STAGE] At the first trees, off the road, a figure in ruined plate. He does not block the road, does not draw, and is gone by the time anyone reaches the treeline. He is never named and never fights **[CANON]**. His line is **[PROPOSED]**.

**FK4_01** · NARRATION
> At the first trees, a figure in ruined plate stands off the road.
> He does not move to block it.

**FK4_02** · Fallen Knight
> The forest has already taken its share.
> It will want another.

**FK4_03** · Kael
> Who are you?

**FK4_04** · Fallen Knight
> Someone who counted the ones it took.

**FK4_05** · NARRATION
> By the time the party reaches the treeline, the road is empty.

[STAGE] Set `flag_fk_seen_4`. Do not connect him to Mira, the garrison, Sera, Caelan, or the sealed order. Do not have any party member recognize him.

[STAGE] **Chapter close.** Set `flag_blackwood_lead`, `flag_chapter5_complete`, `flag_act2_complete`; complete `Q_BV_S6` and start `Q_BV_S7`. Offer a save quietly: there is no crystal at a garrison, and the save rule is a town's church or tavern room, so this is the same quiet prompt used at the end of Chapters 1–4. No unexplained blackout. Act III opens in the Blackwood.

---

## 12. Implementation notes (for Coder)

- **Rooms:** recommend two, following the `scr_build_*` pattern (do not regenerate UUIDs):
  - `rm_blackwood_garrison` — road edge, notice board, gate, yard, well, cell block, and the office door. Roughly 26×22 tiles.
  - `rm_garrison_keep` — the commander's office and records room: desk, dispatch chest, map table, ledger. Roughly 20×16 tiles. If one room is simpler, merge the office behind a door into the yard room and keep the same markers; the records scene needs the party standing still, not a separate map.
- **Encounters:** the `blackwood_garrison` table already exists (Pikeman, Field Surgeon, Knight; levels 16–18). **Recommend none inside the post** and none on the short approach; use it on the wider road if Design wants fights before the gate. Boss group `grp_commander_hailen` already exists.
- **Flags:** `flag_garrison_entered`, `flag_hailen_yields` (choice), `flag_hailen_yielded` (engine), `flag_hailen_beaten`, `flag_sera_recruited`, `flag_blackwood_lead`, `flag_fk_seen_4`, `flag_chapter5_complete`, `flag_act2_complete`.
- **Dialogue:** generate a `scr_dialogue_data_ch5` from these IDs in the same shape as `scr_dialogue_data_ch4` (node table + play dispatch), keeping the 2-line / 90-character box rule.
- **Story script:** a `scr_ch5_story` mirroring `scr_ch4_story.gml`: quest helpers, flags, the gate/yard/records stages, Sera's join, the yield branch, the handoff, and the `grp_commander_hailen` battle finish.
- **Yield:** `commander_hailen` already has `yields_if_flag: "flag_hailen_yields"` and `yield_flag: "flag_hailen_yielded"`. The flag must be set before the battle (Ch. 4 learned the hard way that consuming a story trigger on defeat blocks retries — keep the Hailen trigger retryable too). `scr_dialogue_choice` exists and is currently unused by any chapter; if choice UI is not ready, fall back to setting the flag unconditionally (Hailen always yields) rather than shipping a branch that cannot run.
- **Retry on defeat:** the whole approach triggers on `flag_garrison_entered`, not on the Hailen victory, so a lost fight can be replayed.
- **Party:** Sera joins after the battle (decision 3), so the fight stays the four members the balance pass measured. If the owner chooses at-fight-start, the active line becomes 4 of 5, someone benches, and `tools/balance_sim.py` must be re-run with Sera in the party before the numbers are quoted anywhere.
- **Skills:** `mend`, `aegis`, `smite` are new entries in `scr_skill_data.gml` with PLACEHOLDER values; Smite uses the existing `holy` weakness. No resurrection, no party-wide Aegis yet.
- **Art:** Sera has **no overworld or battle sprites** (only a roster entry and a bible description), and Hailen has no battle art either. Both need placeholders before the chapter can be walked; the Chapter 4 precedent is Caelan's traveler placeholder.
- **Save:** no crystal, no inn. Quiet chapter-end prompt, church/tavern rule unchanged.
- **Naming:** party dialogue says Aethari; UI, bestiary, item and quest text stay Architects. Quest S6/S7 text already follows that.

---

## 13. What this chapter does not do

- Sera never says what she saw in the palace, why she left, or what she thinks of the king **[O]** (question 4). The refusal is explicit and accepted once, then dropped.
- Nothing explains the Blackwood, the stone door, the missing patrols, the non-Crown seal, or who in the palace knows about it **[O]**.
- The Fallen Knight is not named, does not fight, and is not linked to anyone **[O]** (question 2).
- No Mira sighting, no Crown Engine, no Lumen, no explanation of the Ash or Greyhaven.
- Alden does not appear; no split with Taren **[O]**.
- Hailen is not corrupted and not a villain; if he lives, no promise is made about his future beyond this draft.
- Whether the reserve earns XP, and whether story events may force a bench, stay **[O]** (question 36).
- The chapter does not open Act III content: the treeline is the end of what is written.

---

## 14. Decisions — all approved 2026-11-16

**The owner approved all eleven decisions as recommended (Option A).** The alternatives below are kept as the record of what was considered; struck-through options were already rejected while drafting, and the remaining alternatives are rejected by this approval. The consequences of each approval are recorded in `docs/DECISIONS_AND_OPEN_QUESTIONS.md` under "Chapter 5 script decisions".

### 1. Chapter title — **APPROVED: The Deserted Oath**

**Option A (recommended): The Deserted Oath.** Double meaning that the chapter actually earns: Sera deserted a post, and the Crown deserted the oath she thought they shared. Short, matches "The Old Name" and "Crowns and Alleys."

- ~~**Option B:** The Garrison (plain, location-first).~~
- ~~**Option C:** What the Wax Knows (mystery-forward, spoils the sealed order).~~

### 2. Level band — **APPROVED: 16–18**

**Option A (recommended): 16–18**, matching the existing `blackwood_garrison` table and Hailen's level 18. Chapter 4 ends at 13–16, so a 16 entry is reachable without grinding and 18 is the ceiling.

- ~~**Option B:** 17–19, if Act III should open above the Chapter 4 ceiling.~~ (Would need table and Hailen changes.)

### 3. When Sera becomes controllable — **APPROVED: after the fight**

**Option A (recommended): After the fight.** Sera joins in the records room aftermath and is available from the road onward. Keeps the Hailen battle as the four members the balance pass measured (52 / 78 / 94% at 16 / 17 / 18), and makes the first reserve decision a quiet one the player makes in Party Order rather than a forced bench at a boss.

- ~~**Option B:** At the start of the Hailen fight, taking the fourth slot and sending Caelan to reserve.~~ Stronger rescue beat, but it changes the measured fight and forces a bench the story has not earned yet; needs a re-sim.
- ~~**Option C:** A guest ally outside the four-member line.~~ Needs new battle engine support; not worth it here.

### 4. Hailen's yield branch — **APPROVED: pre-battle choice**

**Option A (recommended): A pre-battle choice.** "We're not here to kill Crown soldiers" sets `flag_hailen_yields`; otherwise he fights to the death. This uses the hook already in `scr_enemy_database.gml` and gives the player the outcome the outline leaves open. If the choice UI is not ready, fall back to always setting the flag (he always yields) rather than cutting the branch.

- ~~**Option B:** Always yields; no choice.~~ Simplest, but it decides a story question for the player.
- ~~**Option C:** No yield; he always dies.~~ Darkest, and wastes the hook the last balance pass added.

### 5. Sera's starting kit — **APPROVED: Mend, Aegis, Smite**

**Option A (recommended): Mend, Aegis, Smite.** One heal, one shield, one holy attack — the three things the bible names that a level-16 Warden can plausibly start with, and holy damage already has targets (Shade Stalker, Lost One). Numbers stay **[O]**.

- ~~**Option B:** Mend and Smite only; Aegis comes later.~~
- ~~**Option C:** Add a passive (for example, reduced damage to allies below half HP) instead of Aegis.~~

### 6. Why the party is let into the garrison at all — **APPROVED: they are not**

**Option A (recommended): They are not.** The sergeant's ledger has Taren's name, and the gate closes behind them. Hailen's duty is to hold the post, so the fight is an arrest that fails, not an ambush.

- ~~**Option B:** They talk their way in and Hailen turns on them only when Sera is mentioned.~~ Slower, and makes Hailen look duplicitous.

### 7. What the Blackwood lead actually is — **APPROVED: a sealed Crown order, non-Crown seal**

**Option A (recommended): A sealed Crown order, marked with a non-Crown seal, telling the post to stop looking.** It gives the party a direction, an official reason to go, and a mystery the next act can carry without answering.

- ~~**Option B:** A patrol map with the stone door circled.~~ Clearer, less interesting, and says less about the Crown.
- ~~**Option C:** A prisoner's effects holding an Aethari token.~~ Ties the lead to Caelan too early.

### 8. The Fallen Knight's second line — **APPROVED: "The forest has already taken its share."**

**Option A (recommended): "The forest has already taken its share. It will want another."** Cryptic, forest-facing, and consistent with his Chapter 3 line without naming anything.

- ~~**Option B:** "She went in further than the trees."~~ Too close to Mira; risks confirming what the outline protects.
- ~~**Option C:** No line; he is only seen.~~ Cheap, but wastes the second sighting the outline confirmed.

### 9. Where the chapter ends — **APPROVED: at the treeline**

**Option A (recommended): At the treeline, with `Q_BV_S7` active and the act-complete card.** Mirrors Chapter 4's handoff and gives Act III a clean opening image.

- ~~**Option B:** Inside the records room, with the road and act card opening Act III.~~

### 10. Rooms — **APPROVED: two rooms**

**Option A (recommended): Two rooms** — `rm_blackwood_garrison` (road, gate, yard, cells) and `rm_garrison_keep` (office and records). Matches the Chapter 4 two-room build and keeps the yard's crowd and the records scene from sharing one screen.

- ~~**Option B:** One room, with the office behind a door.~~ Fewer markers, more crowded.

### 11. Sera's detention — **APPROVED: awaiting transport, not sentenced**

**Option A (recommended): Awaiting transport to the capital, not formally sentenced.** It keeps the Crown's process vague (as the bible leaves it), lets Hailen be a man following orders rather than a jailer, and gives the "next wagon" line its weight.

- ~~**Option B:** Already sentenced and awaiting execution.~~ Raises the stakes, but forces a rescue the outline does not ask for and makes Hailen complicit in something darker than "tired officer."

---

## 15. Open questions this chapter deliberately leaves open

What Sera saw in the palace (q4); the Blackwood's nature, the stone door, and the missing patrols; who sealed the Crown's order and why; what the mark is; the Fallen Knight's identity (q2); whether Hailen lives in canon (the choice decides per playthrough, and this draft does not promise him a later scene); whether the reserve earns XP and whether story events may force a bench (q36); Alden's plans and the Taren split; Lumen, the Crown Engine, and why the Crownveil broke.

---

*Drafted 2026-11-15; approved by the owner 2026-11-16. This file is now canon in the Chapter 2–4 format, and the build follows the same path as Chapters 3–4: dialogue data → story script → rooms and markers → balance pass → playtest. Nothing in it has been compiled or played.*
