# ASHEN CROWN — Chapter 3 Script: "Crowns and Alleys" (Act II: The Broken Crown)

Route: Wrenfield west road → Valemere Road → Valemere (hub: gates, Merchant District, Lower City, Temple District, Royal District exterior, Military District, Old Quarter) → Alden → Lower City job → seized warehouse → the Debtman → handoff toward the Hollow Sanctuary.
> **Status: APPROVED.** Kevin approved every proposed item in this script as canon on Nov 14 2026 (3:53 PM ET). Items marked **[C-confirmed]** were invented for this script and then approved, or were confirmed earlier the same day. **[CANON]** items come from the design doc. Open questions remain **[O]**.
> Chapter title: **Crowns and Alleys** **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026). Suggested levels: 10–13 **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026). The act title is **The Broken Crown** **[CANON]**. **The Broken Yoke** is the rebellion's name only **[C-confirmed]**.

Source of truth: `STORY_BIBLE.md`. Presentation: FF1-style top-down exploration (confirmed). Battles are presumed to be FF1-style menu battles (still open).

## How to read this file (for Coder)

- Every dialogue node has a stable ID: `ZONE_PLACE_NN`. Coder can key a dialogue database on these IDs.
- Format: `**ID** · Speaker` followed by the dialogue-box text. Each `>` line is one box line: at most 2 lines per box, each under 90 characters. A node with more than 2 lines is several boxes in sequence (each pair of lines is one box).
- `NARRATION` = text with no speaker. `SYSTEM` = tutorial or UI text. `[STAGE]` = direction for Coder and Design, not shown in game.
- Tags: **[CANON]** = exact text or event from the design doc. **[C-confirmed]** = connective content written for this script, approved by Kevin (Nov 14 2026), including earlier Act II and Chapter 3 decisions the same day. Untagged nodes inside a scene take that scene's tag. Open questions stay **[O]**.
- Suggested story flags are in `code` font. They are only suggestions, and Coder should match them to the real project.
- Ordinary people, soldiers, and Kael still say **Architects**, not Aethari (**[C-confirmed]** naming guide). The party has not learned the old name yet.
- Nothing here names or reveals the Fallen Knight, explains the Ash, says what destroyed Greyhaven, settles Elira's or Tomas's fate, says where Kael, Taren and Alden grew up, defines the Broken Yoke's leadership or Alden's rank, explains the nature of Lyra's Black Hand ties, or explains the Crownveil, Lumen, or the Crown Engine. All of those stay open in the bible.
- **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) The first Act II Fallen Knight sighting is on the road to Valemere, after Taren has joined and before the city. He is never named and never fights.

---

## 0. Quest text

### Main quest: Beyond the Veil — `Q_MAIN_BEYOND_VEIL` [CANON title]

**Description:** "She crossed the Crownveil." The pendant answered the sealed door. Mira is somewhere beyond. **[C-confirmed]** (carried from Chapter 1)

Chapter 3 uses stages 3–5 of the Act II quest plan. Stage IDs, objective text, and the completion events for S3–S5 used in this chapter are **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026). Chapter 4 picks up `Q_BV_S5` at the Hollow Sanctuary.

| Stage | ID | Objective text | Completes when |
|---|---|---|---|
| 3 | `Q_BV_S3` | Travel to Valemere for answers. *(carried out of Chapter 2)* | The party enters Valemere |
| 4 | `Q_BV_S4` | Search the Lower City for a lead. | Lyra is recruited and the scholar's notes are in hand |
| 5 | `Q_BV_S5` | Find the Hollow Sanctuary named in the notes. | The party reaches the Hollow Sanctuary *(Chapter 4 picks this up.)* |

### Side quest: A Parcel Unsealed — `Q_SIDE_PARCEL` **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)

**Giver:** Nim, the Salt Lamp (Lower City). **Reward:** 60 Gold, Antidote x2.
**Description:** Nim wants a parcel walked to a Merchant District stall without a Crown seal on it.

| Stage | ID | Objective text | Completes when |
|---|---|---|---|
| 1 | `Q_SP_S1` | Deliver Nim's parcel to the stall in the Merchant District. | The stallkeeper takes the parcel |
| 2 | `Q_SP_S2` | Return to Nim at the Salt Lamp. | Turn-in played |

Can be accepted before or after Lyra joins. It does not require her.

---

## 1. Valemere Road — `VR` **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)

[STAGE] Chapter 3 begins on the west road out of Wrenfield, already bound for Valemere. `Q_BV_S3` is active. Suggested levels 10–13. Overworld road; small settlements; Crown presence increases as the walls come into view. Encounters may include Crown Patrols, Bandits, and tougher Zone 2 road enemies. Kael and Taren are the party (2 members).

**VR_ENTER_01** · Taren **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> Capital road. Keep your hood handy.
> The Crown has a long memory and a short list of friends.
**VR_ENTER_02** · Kael **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> I wore their colors for four years.
> You're the one they'll look at twice.
**VR_ENTER_03** · Taren **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> Then I'll be dull as a fence post until we're through the gates.
> After that, we find Alden — and a way at your door.

### 1.1 The Fallen Knight, third sighting — `FK_03`

**[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) A non-combat sighting on this road, after Taren has joined and before the city. Cryptic lines only. He bars nothing, never fights, is never named, and walks off. Do not hint at a true name, and do not say whether he is the subject of Act 5. Set `flag_fk_seen_3`.

[STAGE] An armored Fallen Knight stands in the road ahead, motionless, as in Chapter 1. He does not draw a weapon. Taren is present and does not get an answer either.

**FK_03_01** · NARRATION **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> An armored figure stands in the middle of the road.
> It does not draw a weapon.
**FK_03_02** · Kael **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> You again.
**FK_03_03** · Taren **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> Friend of yours?
**FK_03_04** · Kael **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> He never stays long enough to be one.
**FK_03_05** · Fallen Knight **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> You cannot cross where she did. Not yet.
**FK_03_06** · Taren **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> She. You mean his sister? Talk sense.
**FK_03_07** · Kael **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> Hey— wait.

[STAGE] The knight turns from the road and is gone among the trees or the next bend, as in Chapter 1. No battle. No helmet removal. No further explanation.

**FK_03_08** · Taren **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> I don't like a man who knows your family
> and won't give you his name.
**FK_03_09** · Kael **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> I don't like him either. He still isn't why we're here.

### 1.2 Road texture **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)

**VR_SIGN_01** · NARRATION *(road sign)*
> Valemere. Capital of Eldoria. Keep to the Crown road after dark.

**VR_STONE_01** · NARRATION *(old stones in a roadside wall)*
> Architect work, older than the road. The carvings are too faint
> to read. No door this time.
**VR_STONE_02** · Kael
> They liked putting marks on things that last.
> I wish one of them had been instructions.

**VR_SETTLE_01** · Villager *(optional hamlet)*
> Going to the capital? Watch the gates. They've been
> searching carts like everyone's hiding a banner.
**VR_SETTLE_02** · Taren
> We'll be very ordinary.

[STAGE] Optional Broken Yoke contact, **Derry**, on a side path or in the hamlet. He will not name a leader. Skipable.

**VR_DERRY_01** · Derry
> Holt. I'd keep that name in your coat till you're
> past the walls. The capital's been hanging quieter men.
**VR_DERRY_02** · Taren
> I'm not here to raise a banner. I'm here with a friend.
**VR_DERRY_03** · Derry
> Then be a friend and not a captain, just for a day.
> I won't ask who sent you. Don't ask who sent me.
**VR_DERRY_04** · Kael
> We didn't come to seize anything.
**VR_DERRY_05** · Derry
> Good. The people who talk about seizing things
> get counted twice at the gate.

[STAGE] Derry will not discuss Broken Yoke structure or leadership **[O]** (question 29). Repeat talk, **VR_DERRY_R1** · Derry:
> Keep walking. I was never here.

**VR_RUMOR_01** · Cart driver *(optional)*
> They say the king's been shut up in the Royal District
> for weeks. No one I know has seen him.
[STAGE] Do not explain Aldric's motives **[O]** (question 15). This is rumor only.

---

## 2. Valemere gates and hub — `VM` **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)

**[C]** Valemere, capital of Eldoria, about 80,000 residents. Districts: Royal, Merchant, Lower City, Temple, Military, Old Quarter. Major hub for politics, quests, shops, factions, and party development.

**[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) They come here for a lead the Crown will not give, and Taren also wants to find Alden. Official channels will not talk about the Crownveil's failure, or about Mira; the Lower City is where you buy what the Crown will not say **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026).

[STAGE] Set `flag_entered_valemere` on first entry through the gates. Complete `Q_BV_S3`. Start `Q_BV_S4`: Search the Lower City for a lead. Suggested levels 10–13. The Royal District is visible and largely closed. The Temple District can show the Radiant Flame as a living institution; do not decide whether Greyhaven Chapel belongs to it **[O]** (question 30). Taren is a Rebel Captain walking into the capital. Kael is a former Royal Army soldier whose village is in ruins. That tension should color gates, checkpoints, and NPC talk. They are not here to seize the city.

### 2.1 The gates — `VM_GATE` **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)

**VM_GATE_01** · Gate Captain
> Names. Business. Hands where I can see them.
**VM_GATE_02** · Kael
> Kael Varyn. I served four years. We're here
> to see a friend and to ask a few questions.
**VM_GATE_03** · Gate Captain
> Varyn. Greyhaven, if the lists are right.
> Sorry about the town. Questions about what?
**VM_GATE_04** · Kael
> My sister. And a door that wouldn't open.
**VM_GATE_05** · Gate Captain
> Then you're in the wrong city for miracles.
> And you — the quiet one. Name.
**VM_GATE_06** · Taren
> Taren. From near Millhaven. I'm with him.
**VM_GATE_07** · Gate Captain
> Near Millhaven's been noisy. Keep your swords
> in their sheaths and your mouths smaller than they are.
**VM_GATE_08** · Taren
> We'll be a credit to the cobbles.

[STAGE] The party is admitted. Taren is not arrested. A harder check can play as flavor, not a fight. Repeat talk, **VM_GATE_R1** · Gate Captain:
> You're in. Don't make me remember you twice.

**VM_GATE_SIGN** · NARRATION *(gate inscription)*
> Valemere. Under the Crown's peace.

### 2.2 District barks and optional official doors **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)

These can be visited in any order. The confirmed story beats (Alden; the Lower City job) must remain reachable and, for Alden, unmissable (section 3).

**Royal District (exterior, largely closed)**
**VM_ROYAL_01** · Crown Guard
> Royal District is closed to petitioners this month.
> If you have a seal, you're already inside. If you don't, walk on.
**VM_ROYAL_02** · Taren
> Closed. Of course it is.
**VM_ROYAL_03** · Kael
> I didn't come to petition a wall.

**Military District**
**VM_MIL_01** · Drill Sergeant
> You. The one with the longsword. You stand like you drilled here.
**VM_MIL_02** · Kael
> I did. I'm not drilling today.
**VM_MIL_03** · Drill Sergeant
> Then don't loiter. And tell your friend
> to stop looking at the yard like he's measuring it.

**Temple District**
**VM_TEMPLE_01** · Acolyte of the Radiant Flame
> The Ash is a corruption and a punishment. That is the teaching.
> If you've come for comfort, the doors are open. If not, still —
> the doors are open.
**VM_TEMPLE_02** · Kael
> I'm looking for my sister, not a sermon.
**VM_TEMPLE_03** · Acolyte
> Then I will pray you find her uncorrupted.
[STAGE] Doctrine details and leaders stay **[O]**. Do not tie this chapel to Greyhaven.

**Merchant District**
**VM_MERCH_01** · Stallkeeper
> Potions, blades, paper, and bad advice. Coin first.
> The Lower City's cheaper if you don't like sleeping.
[STAGE] Shops and an inn can be placed here. Stock is for Design and the item DB.

**VM_CLERK_01** · Crown Clerk *(optional official channel)*
> If this is about the Crownveil, I have no comment.
> If this is about a missing girl, file it at the watch and wait.
**VM_CLERK_02** · Kael
> How long is a wait?
**VM_CLERK_03** · Crown Clerk
> For Greyhaven? I wouldn't wait in this office.
> I'd try people who don't work here.
**VM_CLERK_04** · Taren
> That's the most honest thing a clerk has ever told us.
> Lower City, then.

**Old Quarter**
**VM_OLD_01** · NARRATION
> Older stone than the rest of the capital. A few Architect marks
> sit in the walls, worn almost smooth.
**VM_OLD_02** · Taren
> Your Architects got everywhere, didn't they?
**VM_OLD_03** · Kael
> Everywhere except into an answer.

**Lower City mouth**
**VM_LOWER_01** · Street hawker
> Lamps, locks, rumors, and regret. The Salt Lamp's down the lane
> if you're buying the last two.

---

## 3. Alden in the capital — `AD_MEET`

**[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) The party meets **Alden Marr** in Valemere, in person. He greets Kael and Taren as friends. He is sincere about freeing the serfs and about the Crown having failed the people **[CANON]**. He has one line that already thinks ahead to "when we hold the city." Taren hears a plan. The player can hear a seed. There is no argument, and no split. The meeting cannot be skipped.

**[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) Placement (Decision 1): **Weigh-House Square**, on the seam between the Merchant District and the Lower City, unmissable on the way to the Salt Lamp. He is speaking to a small knot of people, not from a throne. If the player reaches the Lower City job without this scene, trigger it at the square before the Salt Lamp will open the lead. His backstory, exact role, and any later break with Taren stay **[O]**.

[STAGE] Set `flag_alden_met` when the scene ends.

**AD_MEET_01** · NARRATION **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> A man is speaking in the square, not shouting, not hiding.
> People have stopped to listen.
**AD_MEET_02** · Alden **[CANON intent / C-confirmed wording]** (Confirmed by Kevin, Nov 14 2026)
> The crown has failed these people. We can say that
> without burning the city down tonight.
**AD_MEET_03** · Alden **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> When we hold this city, we can actually build something.
> Not another throne. Something that belongs to them.
**AD_MEET_04** · Taren **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> Alden.
**AD_MEET_05** · Alden **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> Taren. And — Kael. Look at you.
> I heard about Greyhaven. I'm sorry. I'm glad you came.
**AD_MEET_06** · Kael **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> I'm looking for Mira. And for a way through a door
> that wouldn't open.
**AD_MEET_07** · Alden **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> Then you're looking in the right kingdom and the wrong offices.
> The Crown doesn't answer questions it has already failed.
**AD_MEET_08** · Taren **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> He's been saying that since we were boys.
> I still think he's right.
**AD_MEET_09** · Alden **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> I still think we can do this without becoming them.
> Taren keeps me honest. You always did, both of you.
**AD_MEET_10** · Kael **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> I can't stay for a cause today. I need a lead.
**AD_MEET_11** · Alden **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> Then take the Lower City. If the archives won't open,
> talk to the people who steal from them.
**AD_MEET_12** · Taren **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> We'll come find you again.
**AD_MEET_13** · Alden **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> Do. I'll be here, or I'll be where the work is.
> Be careful at the gates on the way out. Both of you.

[STAGE] No argument. No split. Alden remains a friend. He does not give a rank, a command structure, or a plan to seize the throne **[O]**. Repeat talk, **AD_MEET_R1** · Alden:
> The Lower City first. Then come back and tell me what you found.
> I meant what I said. All of it.

---

## 4. The Salt Lamp — lead and Lyra — `SL` **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)

**[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) The party needs a thief to steal a seized document — a scholar's notes or a ledger — that points toward the Hollow Sanctuary. **Lyra Veyne** takes the job for coin.

**[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) The lead is sold by **Nim**, a fence at **the Salt Lamp**, a Lower City dive. The notes belonged to a royal scholar who left court. They mention an abandoned sanctuary and, at most, the word "Architects." They do not explain the Veil, name Lumen, or locate the Crown Engine. They do not have to name Caelan Rook.

[STAGE] The Salt Lamp is a safe interior (no random battles). Nim will not talk business until `flag_alden_met` is set, so Alden cannot be missed. If the player talks to Nim first, he tells them to walk the square and come back.

**SL_ENTER_01** · NARRATION **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> A low room, salt-crusted lamps, and a bar that has heard
> worse plans than this one.
**SL_NIM_01** · Nim **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) *(if Alden has not been met)*
> Sit if you want. I don't sell maps to men who haven't
> even looked at the square. Walk first.
**SL_NIM_02** · Nim **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) *(after `flag_alden_met`)*
> You're the Greyhaven soldier and the loud captain
> trying not to look loud. Fine. I might have work.
**SL_NIM_03** · Taren **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> We're buying a lead, not a sermon.
**SL_NIM_04** · Nim **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> Then buy this: the Crown seized a scholar's notes
> when he walked out of court. They're in a warehouse down-lane.
**SL_NIM_05** · Nim **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> People say they point at some old Architect sanctuary
> a day's walk from the walls. I don't read. I just hear.
**SL_NIM_06** · Kael **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> That's close enough.
**SL_NIM_07** · Nim **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> You'll need a thief. I don't do locks anymore.
> She does. Lyra — they're paying.

[STAGE] **Lyra Veyne** is already in the room, or steps out from a back table. Twin daggers. Dry, useful, not interested in Mira or the Yoke yet.

**SL_LYRA_01** · Lyra **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> I heard "paying." The rest can wait.
**SL_LYRA_02** · Taren **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> We need those notes. That's the job.
**SL_LYRA_03** · Lyra **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> A warehouse, a lock, and two men who walk in
> like they still have an army behind them. Cute.
**SL_LYRA_04** · Kael **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> Can you open it or not?
**SL_LYRA_05** · Lyra **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> I can open it. Coin up front for me, finder's cut for Nim.
> I don't work for causes. I work for coin.
**SL_LYRA_06** · Taren **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> You'll get your coin.
**SL_LYRA_07** · Lyra **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> Then try to look like you belong in an alley.
> The grim one can stay grim. It's almost a disguise.

[STAGE] Set `flag_lower_city_job`. The job is on. Lyra is not yet in the party; she leads them to the warehouse as an NPC until the boss, then becomes controllable at the start of the Debtman fight (Decision 5).

Repeat talk, **SL_LYRA_R1** · Lyra:
> Warehouse first. Compliments later, or never.
Repeat talk, **SL_NIM_R1** · Nim:
> I didn't hear a plan. I heard coin. Go on.

### 4.1 Optional parcel quest **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)

**SL_PARCEL_01** · Nim
> If you're already walking the Merchant District,
> take this parcel to the stall under the blue awning.
**SL_PARCEL_02** · SYSTEM *(choice)*
> Accept? [Yes] [No]
**SL_PARCEL_03_YES** · Nim
> No Crown seal. No speeches. Come back for your coin.
**SL_PARCEL_04_NO** · Nim
> Suit yourself. The stall isn't going anywhere.

[STAGE] Yes: start `Q_SIDE_PARCEL`, give key item `item_nim_parcel`. In the Merchant District, the stallkeeper (`VM_PARCEL_01`) takes it without reading it.

**VM_PARCEL_01** · Stallkeeper
> That's Nim's hand. I never saw you.
**VM_PARCEL_02** · SYSTEM
> Delivered: Nim's Parcel.

**SL_PARCEL_05** · Nim *(turn-in)*
> Clean enough. Here.
**SL_PARCEL_06** · SYSTEM
> Obtained: 60 Gold, Antidote x2.
[STAGE] Complete `Q_SIDE_PARCEL`. Set `flag_parcel_done`.

---

## 5. The seized warehouse — `LC_HEIST` **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)

[STAGE] A Crown seized-goods warehouse on a Lower City lane. Night or late hours play better, but daylight can work if Design prefers. Lyra picks a side door or a padlock. Inside: crates, a cage or chest, the scholar's notes. No need for a full dungeon; a short stealth-or-fight interior is enough. If a fight breaks before the notes, keep the Debtman for the exit (section 6).

**LC_HEIST_01** · Lyra **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> Side door. Watch the lane. If someone shouts,
> I was never with you.
**LC_HEIST_02** · Taren **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> Comforting.
**LC_HEIST_03** · Lyra **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> I don't do comforting. I do quiet.

**LC_LOCK_01** · NARRATION **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> The lock gives under Lyra's picks with an unimpressed click.

**LC_NOTE_01** · NARRATION **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) *(the notes)*
> A scholar's hand, hurried. A sketch of a hollow in the hills
> a day's walk from the capital. Architect doors. Still standing.
**LC_NOTE_02** · NARRATION **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> "I will not be at court. If they want the rest,
> they can walk to the sanctuary themselves."
**LC_NOTE_03** · Kael **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> A day's walk. That's a path.
**LC_NOTE_04** · SYSTEM **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> Obtained: Scholar's Notes (Story Item).
[STAGE] Add key item `item_scholar_notes`. Set `flag_scholar_notes`. The notes do not explain the Veil, Lumen, or the Crown Engine, and they do not use the name Aethari.

**LC_HEIST_04** · Lyra **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> You have your paper. I have my coin coming.
> Let's not die in a hallway about it.

[STAGE] On the way out, the job breaks. **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) break (Decision 2): **the Debtman** and a couple of toughs are waiting at the door, there to recover the notes and/or remind Lyra of a debt. That is as close as this chapter should come to her Black Hand ties. Do not name a Black Hand leader **[O]** (question 6).

**LC_BREAK_01** · The Debtman **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> Easy. That's a heavy bag of paper for a light thief.
**LC_BREAK_02** · Lyra **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> It's a job, not a gift. Walk around.
**LC_BREAK_03** · The Debtman **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> Someone still wants those notes. And someone still
> wants you reminded what a debt sounds like.
**LC_BREAK_04** · Taren **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> She's with us.
**LC_BREAK_05** · Lyra **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> Don't do me favors. We can run, or we can finish this.
> I'm finishing it.

[STAGE] Lyra chooses to stay and finish. She is now exposed. The Debtman fight begins.

---

## 6. The Debtman — boss intro, fight, and defeat — `DM`

**[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) The chapter boss is a human Lower City enforcer tied to the stolen document, not a named Black Hand leader. His name in this chapter is **the Debtman**, a moniker only, not a Black Hand title. He is beaten and withdraws alive (Decision 3). Not Ash-corrupted.

### 6.1 Intro — `DM_INTRO` **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)

**DM_INTRO_01** · The Debtman
> Put the notes down. Walk away lighter than you came.
> That's the generous version.
**DM_INTRO_02** · Kael
> We're not putting them down.
**DM_INTRO_03** · The Debtman
> Then this is the other version.
**DM_INTRO_04** · Lyra
> You want a reminder? Here's one.
> I finish what I take.

[STAGE] Battle start: `enc_debtman`. The Debtman plus 1–2 Lower City toughs. Suggested player level 10–13. Human, not Ash-corrupted. Proposed kit: a fast knife strike; **Collect** (a debuff or a small HP drain); a bind or net that can Slow or Immobilize one target. When the toughs fall, he fights meaner and faster. Exact stats are for Coder and Design to balance.

[STAGE] **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) join (Decision 5): **Lyra Veyne enters the party at the start of this fight.** She takes the **3rd party slot**. Starting weapon: **twin daggers** **[CANON]**. Starting skills **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) (Decision 4): **Twin Cut**, **Open Vein**, and **Cutthroat** (passive). Poison and stealth skills can unlock later. Exact numbers stay **[O]**; do not invent percentages. Formation is the player's to rearrange; a back-row default fits her role, but do not story-lock it **[O]** (question 36). Set `flag_lyra_in_battle`.

**DM_SYS_01** · SYSTEM **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> Lyra Veyne has joined the party.
> She takes the third party slot.
**DM_SYS_02** · SYSTEM **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> Weapon: twin daggers.
> Starting skills: Twin Cut, Open Vein, and Cutthroat (passive).
**DM_SYS_03** · SYSTEM **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> Twin Cut: two successive dagger hits.
> Open Vein: a strike that applies Bleed.
**DM_SYS_04** · SYSTEM **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> Cutthroat: Lyra's critical hits come more often.

**DM_SYS_05** · SYSTEM *(optional, first Open Vein)* **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> Bleed deals damage over time. Some foes shake it off.
> Some don't.

Phase-change bark **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026), when the last tough falls:

**DM_PHASE2_01** · The Debtman
> Fine. I'll collect it myself.

### 6.2 Defeat — `DM_DEFEAT` **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)

[STAGE] **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) outcome (Decision 3): the Debtman is beaten and withdraws, alive, with a last reminder about debts. Living leaves the implication of her ties in place without naming anyone.

**DM_DEFEAT_01** · The Debtman
> Enough. Keep the paper. The debt doesn't go with it.
**DM_DEFEAT_02** · Lyra
> Tell whoever sent you I finished the job.
> They can bill me when they can find me.
**DM_DEFEAT_03** · The Debtman
> They can always find you. That's the point.
**DM_DEFEAT_04** · Taren
> She's walking out with us.
**DM_DEFEAT_05** · The Debtman
> Then you're in it too. Don't look surprised later.

[STAGE] The Debtman leaves, or falls and is dragged off by a tough. No unique Ash drop. Rewards are for Coder to set (placeholder: XP and gold for level 10–13). The notes remain in the party's inventory. Set `flag_debtman_beaten`.

**DM_REWARD_01** · SYSTEM **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> The way out is clear. The notes are still in hand.

---

## 7. Lyra's join — `LY_JOIN` **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)

[STAGE] Quiet lane or a return to the Salt Lamp doorway. Lyra is now exposed. She stays because of that, and because the job is finished, not because she believes in Mira or the Yoke. Loyalty is later. She is a professional, not a convert. If she already joined at the start of the fight, do not add her a second time; this is the conversation.

**LY_JOIN_01** · Taren **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> You could have run.
**LY_JOIN_02** · Lyra **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> And died tired in an alley when they caught up.
> I finish jobs. That's how I stay paid, and breathing.
**LY_JOIN_03** · Kael **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> The notes point at a sanctuary a day from the walls.
> I'm going.
**LY_JOIN_04** · Lyra **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> Then I'm going as far as that paper goes.
> I'm already on someone's list. Your company is cover.
**LY_JOIN_05** · Taren **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> We aren't a hiding place.
**LY_JOIN_06** · Lyra **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> Don't look at me like I signed an oath.
> I signed a job.
**LY_JOIN_07** · Kael **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> That's enough for today.
**LY_JOIN_08** · Lyra **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> Good. You can keep the grim. He can keep the speeches.
> I'll keep the knives.

[STAGE] **Lyra Veyne** is a permanent party member **[C]**. Set `flag_lyra_recruited`. Complete `Q_BV_S4`. Start `Q_BV_S5`: Find the Hollow Sanctuary named in the notes. Party size is now 3. She may needle Taren's sermons and Kael's silence in later repeat talk; that is humor, not a change of heart.

Repeat talk, **LY_JOIN_R1** · Lyra **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026):
> A day's walk to a pile of Architect doors.
> Try to keep up, both of you.

Repeat talk with Nim, **SL_NIM_B1** · Nim **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026):
> I didn't see a fight. I didn't see her leave with you.
> If anyone asks, you drank water and overpaid.

---

## 8. Lower City after the job (`_B`) and the hub, revisited **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)

[STAGE] The Lower City is a little more watchful. The warehouse can be locked again. District barks below are after `flag_lyra_recruited` / `flag_debtman_beaten` where it helps; earlier _A barks can still play in districts the player visits before the heist.

**LC_HAWKER_B1** · Street hawker
> You're famous for half a night. I'd spend that fame
> on the road, not in my lane.
**VM_GATE_B1** · Gate Captain *(if they return to the gate)*
> Still here. Still not a miracle. If you're leaving,
> leave before I learn a second name for your friend.
**AD_MEET_B1** · Alden *(optional return; still a friend, no split)*
> You found a path. I can see it on your faces.
> Go walk it. I'll still be here when you come back.
**VM_TEMPLE_B1** · Acolyte
> If you're walking out to old stones, be careful.
> The Ash finds people who dig.

### 8.1 Reading the notes again **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)

**LC_NOTE_R1** · NARRATION *(if the notes are examined in the menu or at an interact)*
> A sanctuary in a hollow, a day's walk from Valemere.
> Architect doors. The writer would not stay at court.
**LC_NOTE_R2** · Kael
> Then that's where we go.

---

## 9. Handoff toward the Hollow Sanctuary — `VM_HANDOFF` **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)

[STAGE] A city gate or a west-country road out of Valemere, pointed at the countryside a day's travel away. Leaving this way ends Chapter 3. Do not play the Hollow Sanctuary itself. That is Chapter 4. Do not play a second Fallen Knight sighting here.

**VM_WEST_SIGN** · NARRATION **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> West country road. Hills by sundown tomorrow, if you don't linger.

**VM_HANDOFF_01** · Taren **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> A day's walk. Alden will keep. The Crown will not
> get kinder while we're gone.
**VM_HANDOFF_02** · Lyra **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> Then walk. I didn't pull a warehouse job
> to camp under a gate and talk about feelings.
**VM_HANDOFF_03** · Kael **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> We walk.

[STAGE] Complete Chapter 3 when the party uses the west-country road toward the Hollow Sanctuary. `Q_BV_S5` is already active. Set `flag_chapter3_complete`.

**VM_HANDOFF_04** · SYSTEM **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> Quest updated: Find the Hollow Sanctuary named in the notes.
**VM_HANDOFF_05** · SYSTEM **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
> Chapter 3 — Crowns and Alleys — Complete.

[STAGE] Offer a save **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026), in the same spirit as Chapters 1 and 2, without an unexplained blackout. Chapter 4 begins on the approach to the Hollow Sanctuary.

---

## 10. Decisions (Kevin, Nov 14 2026)

Kevin approved these six recommendations and the full script (every former proposed line and texture) on Nov 14 2026, at 3:53 PM ET. Chosen options and the rest of this file are **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026). Rejected options are kept for the record, struck through. Open questions remain **[O]**.

### 1. Where they meet Alden, and when

The meeting itself was already confirmed and cannot be skipped. Placement is now settled.

**[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) **Option A (chosen):** In **Weigh-House Square**, on the seam of the Merchant District and the Lower City, unmissable on the way to the Salt Lamp, before the job. He speaks the "when we hold the city" line in the open, then greets them as friends.

- ~~**Option B:** In a private Lower City room, after they have started asking around.~~ *(Not chosen.)*
- ~~**Option C:** After the heist, once Lyra has joined.~~ *(Not chosen.)*

### 2. How the heist breaks

**[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) **Option A (chosen):** The Debtman and toughs cut them off as they leave with the notes, there to recover the prize and/or remind Lyra of a debt.

- ~~**Option B:** A Crown sweep hits the warehouse; the Debtman arrives in the chaos as a third party after the same notes.~~ *(Not chosen.)*
- ~~**Option C:** Nim double-crosses them and sends the enforcer.~~ *(Not chosen.)*

### 3. The enforcer's name, and whether he lives

**[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) **Option A (chosen):** Keep the working name **the Debtman** as a moniker only, not a Black Hand title. He is beaten and withdraws alive, leaving the debt hanging.

- ~~**Option B:** Give him a personal name (for example **Harst**) and use "the Debtman" as a street nickname. He withdraws alive.~~ *(Not chosen.)*
- ~~**Option C:** Keep the moniker, and kill him in the fight.~~ *(Not chosen.)*

### 4. Lyra's starting skills

The bible already gave her role (critical hits, bleeding, poison, multiple attacks, stealth, fast damage) and twin daggers. Exact numbers stay **[O]**.

**[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) **Option A (chosen):** At join: **Twin Cut** (two successive hits), **Open Vein** (applies Bleed), and **Cutthroat** (passive: increased critical chance). Poison and stealth skills unlock later.

- ~~**Option B:** Twin Cut and Open Vein only; no starting passive.~~ *(Not chosen.)*
- ~~**Option C:** Start with Bleed, Poison, and a stealth opener all at once.~~ *(Not chosen.)*

### 5. When Lyra becomes controllable

**[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) **Option A (chosen):** At the start of the Debtman fight, after a short mid-heist line ("I'm finishing it."). The longer "I signed a job" conversation happens after the battle.

- ~~**Option B:** After the fight only. During the battle she is a guest ally, or the party fights without her.~~ *(Not chosen.)*
- ~~**Option C:** A full join conversation before they enter the warehouse, then the heist.~~ *(Not chosen.)*

### 6. Chapter title, and who sells the lead

**[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) **Option A (chosen):** The chapter title is **Crowns and Alleys**. The lead is sold by **Nim**, a fence at a Lower City dive called **the Salt Lamp**.

- ~~**Option B:** Keep **Crowns and Alleys**, but an unnamed bartender sells the lead (no Nim, no Salt Lamp).~~ *(Not chosen.)*
- ~~**Option C:** Retitle the chapter **The Lower City**, with Nim at the Salt Lamp.~~ *(Not chosen.)*

---

## Approved (Kevin, Nov 14 2026, 3:53 PM ET)

Kevin approved every proposed item in this script as canon, including the chapter title and levels, the Fallen Knight's road line, Weigh-House Square, Nim and the Salt Lamp, **A Parcel Unsealed**, the Debtman's moniker, kit, and survival, Lyra's starting skills and join timing, all NPC names and barks, quest stage text, and the chapter-complete presentation. Open questions in the bible remain open (the nature of Lyra's Black Hand ties, Black Hand leadership, Alden's backstory and rank, the Broken Yoke's leadership, Aldric's motives, Tomas's and Elira's fates, what destroyed Greyhaven, where the three friends grew up, Lumen, the Crown Engine, and the Fallen Knight's identity).

Confirmed excerpt can go to Coder for `docs/story/`.
