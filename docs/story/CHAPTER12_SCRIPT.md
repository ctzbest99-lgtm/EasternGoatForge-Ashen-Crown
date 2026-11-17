# ASHEN CROWN — Chapter 12 Script: "The Salt Toll" (Act V: The Fallen Knight)
<!-- audit-skip: draft chapter; dialogue data is not generated yet -->

Route: the barrow road south → the coast road → **`rm_saltreach`** (new; blockout first): a village on a shelf of black rock, salt pans above the tide line, a bell tower with no bell, and the slate at the harbour where one name is written each tide.

> **Status: DRAFT 2026-11-17 from the approved Act V outline — not individually approved, not built, not played.**
> This is the first chapter script of Act V. No dialogue data, story script, room, marker table, enemy id or quest row exists. It is written for review and then generation; it deliberately carries no combat numbers, because `ACT5_OUTLINE.md` §7 requires the `--act5` simulation before any line is written against them.
> **Level band 24** [PROPOSED, blocked on the approved `PARTY_MAX_LEVEL` rise to 27; the cap is still 24]. Five in the party, four active; no recruit.
> **Alden is off-screen for the whole act.** He appears only as one letter, and only if Chapter 11 ended with `ch11_seal_alden`.
> **Not played.** Saltreach is a Wrenfield blockout until a coast tileset exists, the Toll-Keeper has no art, and every villager is a placeholder.
> **This chapter's one job:** show the toll, put the ledger of crossings in the party's hands, and end with the knight on the pier. It does not explain the crossings, the knight, Mira, the Crownveil or the drowned civilisation.
> **Draft decisions 2026-11-17:** the reeve is Ilsa Fen; the half-cut name is hers; Alden's letter stays conditional; she is not a battle. See §11. The chapter itself is still not individually approved, built or played.

Source of truth: `STORY_BIBLE.md` §3 (the Drowned Coast, Saltreach) and §5.12 (the Fallen Knight), plus `ACT5_OUTLINE.md` §3. Presentation: FF1-style top-down exploration; menu battles.

## How to read this file (for Coder)

- Prefixes: `CR_` for the coast road, `SV_` for Saltreach, `RV_` for the reeve and the levy house, `BT_` for the bell tower, `TK_` for the Toll-Keeper, `LG_` for the ledger, `TS_` for the slate choice, `ADL_` for Alden's letter, `KT_` for the knight on the pier, `CH12_` for the chapter's own beats.
- Format: `**ID** · Speaker`, each `>` line one box line. `NARRATION` = no speaker; `SYSTEM` = UI; `[STAGE]` = direction, not shown.
- **What this chapter must not do:** let the reeve explain the crossings; let anyone in Saltreach recognise the knight; name the knight; say Mira crossed, or that Kael's father did; explain what "returned" means; confirm the drowned civilisation is Aethari; name the Toll-Keeper; grade the slate choice; show Alden on screen.

---

## 0. Quest text

### Main quest — `Q_MAIN_FALLEN` "The Knight Who Came Back" **[PROPOSED, not yet in `scr_quest_data.gml`]**

Act IV's `Q_MAIN_CROWN` closes at S6 (complete) when the seal choice resolves. Act V starts a new quest rather than growing a seventh stage.

| Stage | ID | Objective text | Set when |
|---|---|---|---|
| 1 | `Q_MF_S1` | "Follow the coast road to Saltreach." | Chapter 12 entry |
| 2 | `Q_MF_S2` | "Find out what the village pays the tide." | the Toll-Keeper is defeated |

S3–S6 belong to Chapters 13–14 and should be defined in `scr_quest_data.gml` at the same time so the journal never has a gap:

| Stage | ID | Objective text | Set when |
|---|---|---|---|
| 3 | `Q_MF_S3` | "Find the record of the crossings." | Chapter 13 entry |
| 4 | `Q_MF_S4` | "Reach the wreck the ledger names." | the Leviathan is defeated |
| 5 | `Q_MF_S5` | "Face the knight who has been following you." | Chapter 14 entry |
| 6 | `Q_MF_S6` | "Learn what he leaves you." | the knight yields |

### Side quest — `Q_SIDE_TOLL` "One Name a Tide" **[PROPOSED]**

Opens on arrival and closes at the slate in §7, in the same chapter. Both endings are quiet, give the same reward and are not graded.

| Stage | ID | Objective text | Set when |
|---|---|---|---|
| 1 | `Q_ST_S1` | "Find out what the village pays the tide." | Chapter 12 entry |
| 2 | `Q_ST_S2` | "Decide what happens to the slate." | the Toll-Keeper is defeated |
| — | complete | — | the slate choice resolves (§7) |

Reward: **200 gold**, the same either way — the reeve's pouch of the Crown's salt money. No unique item.

---

## 1. The coast road — `CR_ARRIVE`

[STAGE] South of the barrow field the road stops pretending to be a road: it narrows, turns, and comes out on a shelf of black rock above the sea. Salt pans step down toward the water on the left. Ahead, a village of grey stone and low roofs, one bell tower with an empty arch, and one boat in the harbour. `snd_amb_water` — the first room to use it. The tide is out further than it should be. Sets `ch12_entered`, `Q_MF_S1`, `Q_ST_S1`.

**CR_ARRIVE_01** · NARRATION
> The road comes out above the sea and stops being a road. Black rock, salt wind, and a line of flat pans stepping down to the water.
> The tide is out. Further out than the pans were built for.

**CR_ARRIVE_02** · Sera
> Sea.

**CR_ARRIVE_03** · Lyra
> Not just sea. Salt. They're working it.
> Those pans are old. Older than the village, maybe.

**CR_ARRIVE_04** · Caelan
> Above the tide line, cut to flood at the right hour. Somebody built this coast to be lived on.
> And they built the village where the rock lets them.

**CR_ARRIVE_05** · Taren
> Then why is there one boat?

**CR_ARRIVE_06** · NARRATION
> One boat. Patched, drawn up on the shingle. No nets hanging. No gulls over the roofs.
> The bell tower has no bell in it.

**CR_ARRIVE_07** · Sera
> That tower's empty.

**CR_ARRIVE_08** · Lyra
> No bell. No birds. No smoke except one chimney.
> I don't like a village that's quiet before it's dark.

**CR_ARRIVE_09** · Caelan
> The water's wrong. Look at the reef.
> It should be under. It's been out since dawn.

**CR_ARRIVE_10** · Kael
> We walk in slow. We're not the Crown, and we're not here to collect anything.

**CR_ARRIVE_11** · Taren
> We're armed.

**CR_ARRIVE_12** · Kael
> Then we walk in slower.

---

## 2. Saltreach — `SV_ARRIVE`

[STAGE] The village square is a widening of the harbour road: a well, a levy board, four streets, and the bell tower at the seaward end. Half the village is gathered at the harbour, around a niche cut into the sea wall. A hand-sized slate tablet sits in it, blank. The argument reaches the square before the party does. Sets `ch12_village_seen`.

**SV_ARRIVE_01** · NARRATION
> The square is a well, a levy board and a tower. The levy board has the Crown's seal on it and fresh salt in the grain of the wood.
> At the harbour, half the village is standing around a niche in the sea wall.

**SV_ARRIVE_02** · Fisher
> It has to be a name from the village.

**SV_ARRIVE_03** · Net-mender
> It's always been a name from the village.

**SV_ARRIVE_04** · Fisher
> Then whose?

**SV_ARRIVE_05** · Old Salter
> Mine. I'm old. I've had my tide.

**SV_ARRIVE_06** · Net-mender
> No.

**SV_ARRIVE_07** · Boy
> The strangers. They came with swords. The sea likes a sword.

**SV_ARRIVE_08** · Reeve Fen
> The sea doesn't like anything. That's the point of it.

[STAGE] The crowd turns. The reeve is Ilsa Fen, a small woman in a Crown clerk's coat, ink on her cuffs, a chisel in her hand. She does not look surprised to see five armed travellers. She looks tired.

**SV_ARRIVE_09** · Reeve Fen
> Ilsa Fen. The Crown's salt reeve.
> You picked a bad day to be strangers.

**SV_ARRIVE_10** · Kael
> We're not staying. We're on the road south.

**SV_ARRIVE_11** · Reeve Fen
> There is no road south. There is the sea, and there is the boat, and the boat won't go until the tide turns.
> Today the tide is late.

**SV_ARRIVE_12** · Sera
> How late?

**SV_ARRIVE_13** · Reeve Fen
> Since dawn.

**SV_ARRIVE_14** · Caelan
> That isn't late. The water's pulled back past the reef. That's wrong.

**SV_ARRIVE_15** · Reeve Fen
> Then you understand why they're arguing.

**SV_ARRIVE_16** · Lyra
> About whose name goes on the slate.

**SV_ARRIVE_17** · Reeve Fen
> One a tide. The village agrees on one. I write it.

**SV_ARRIVE_18** · Taren
> And if they can't agree?

**SV_ARRIVE_19** · Reeve Fen
> Then the sea chooses.

**SV_ARRIVE_20** · Kael
> That's not a choice.

**SV_ARRIVE_21** · Reeve Fen
> No.
> Come up to the levy house. You can argue in the warm, and I can get a look at you before the village decides you're an answer.

**SV_ARRIVE_22** · NARRATION
> She turns back toward the square. The crowd lets her through, and does not stop watching the party.

### 2.1 The salt pans — `SV_PANS` (optional)

[STAGE] A pan above the tide line, raked into ridges, white at the edges. Sets `ch12_pans_seen`. Repeat look plays `SV_PANS_R1`.

**SV_PANS_01** · NARRATION
> The pan is raked into shallow ridges. Salt crusts the stone where the water has been let out.
> A wooden shovel stands upright in it, left where the work stopped.

**SV_PANS_02** · Fisher
> Crown salt. Best on the coast, they say.
> The levy takes half. The toll takes the rest.

**SV_PANS_03** · Lyra
> The toll takes salt?

**SV_PANS_04** · Fisher
> The toll takes a name. The Crown takes the salt. The sea takes the slate.
> We pay in the order we can afford.

### 2.2 The bell tower — `SV_BELL` (optional)

[STAGE] The tower's door is open; the stairs go up into dark. No bell rope. No bell. Salt has got into the stone. Sets `ch12_bell_seen`.

**SV_BELL_01** · NARRATION
> The tower is empty all the way up. The bell frame is still there, the bolts cut clean.
> Salt has got into the stone. The sea is very loud in an empty tower.

**SV_BELL_02** · Net-mender
> The Crown took the bell. Twenty years ago. Levy arrears.

**SV_BELL_03** · Sera
> And the keeper came after?

**SV_BELL_04** · Net-mender
> The keeper came after.
> Nobody goes up now. There's nothing up there but the sound.

### 2.3 The slate — `SV_SLATE` (optional)

[STAGE] The niche in the sea wall: a hand-sized tablet of slate, worn concave in the middle, the stone around it grooved by years of the same hand setting it in. Sets `ch12_slate_seen`.

**SV_SLATE_01** · NARRATION
> The tablet is smaller than a plate and worn smooth in the middle, where the names have been written and taken, written and taken.
> The stone around the niche is grooved from the same hand setting it in, tide after tide.

**SV_SLATE_02** · Caelan
> There's no record. No list. The names go out with the water.

**SV_SLATE_03** · Old Salter
> The sea keeps the record.

**SV_SLATE_04** · Kael
> That's what worries me.

### 2.4 The boat — `SV_BOAT` (optional)

[STAGE] One boat, drawn up on the shingle, patched in three places, a single mast. Sets `ch12_boat_seen`.

**SV_BOAT_01** · NARRATION
> The boat is old and patched and sound. Somebody has been keeping it carefully.
> It is the only way off the village by water.

**SV_BOAT_02** · Fisher
> She won't go past the reef. Not with the tide like this.
> When it turns, maybe. If it turns.

**SV_BOAT_03** · Taren
> And if it doesn't?

**SV_BOAT_04** · Fisher
> Then you're here for the tide.

---

## 3. The levy house — `RV_OFFICE`

[STAGE] The reeve's house is one room down and one room up: an office with salt weights, tax rolls, a Crown seal in a box, and a narrow bed against the wall. No ornament. A second door at the back, low, with a lock. She pours water without asking and sets the jug down. Sets `ch12_reeve_met`.

**RV_OFFICE_01** · Reeve Fen
> Sit. You're not prisoners. There's water.

**RV_OFFICE_02** · Kael
> You've been writing the names.

**RV_OFFICE_03** · Reeve Fen
> I weigh salt, I collect the levy, and once a tide I write a name on a slate.
> Two of those are my job.

**RV_OFFICE_04** · Sera
> And the third?

**RV_OFFICE_05** · Reeve Fen
> The third is the village's. I inherited it with the house.

**RV_OFFICE_06** · Caelan
> You don't believe it.

**RV_OFFICE_07** · Reeve Fen
> I believe the village stops working if it doesn't happen. I've seen it.
> That's enough.

**RV_OFFICE_08** · Taren
> You write a name every tide.

**RV_OFFICE_09** · Reeve Fen
> The name the village gives me. I've never chosen one.

**RV_OFFICE_10** · Sera
> That's not better.

**RV_OFFICE_11** · Reeve Fen
> No. It's just true.

**RV_OFFICE_12** · Kael
> What happens if nobody writes one?

**RV_OFFICE_13** · Reeve Fen
> The tide takes the slate. The boats go out and come back. The village believes one pays for the other.
> I've buried fishermen. None of them in a year the slate went unwritten. That is not proof. It is enough for them.

**RV_OFFICE_14** · Lyra
> And you call it?

**RV_OFFICE_15** · Reeve Fen
> An accident. But I'm the only one who does.

**RV_OFFICE_16** · NARRATION
> She lifts the lid of the salt box, looks at the seal inside, and closes it again. The levy board outside has the same seal on it, freshly cut.

**RV_OFFICE_17** · Reeve Fen
> The Crown taxes the salt. If the boats stop, the levy fails, and the Crown sends soldiers who will not argue with a custom. They will take the salt and the boats and the tower.
> I write the name so the village keeps its boats. That is the whole of it.

**RV_OFFICE_18** · Caelan
> That's a chain of things you didn't choose.

**RV_OFFICE_19** · Reeve Fen
> Yes. I'm a clerk.

**RV_OFFICE_20** · Kael
> The tide's late. What does that mean?

**RV_OFFICE_21** · Reeve Fen
> It means the village has until dark to agree. After that, I write the name I'm given, or I write nothing.

**RV_OFFICE_22** · Sera
> And if you write nothing?

**RV_OFFICE_23** · Reeve Fen
> Then we find out what the sea does when it isn't paid.
> There's a chest under this house. It came with the office. The key came with it. I've never opened it.

**RV_OFFICE_24** · Caelan
> Why not?

**RV_OFFICE_25** · Reeve Fen
> The last reeve told me it was the Crown's other account. I have enough trouble with the one I can read.

**RV_OFFICE_26** · NARRATION
> She looks at the window. The light is going. Out in the harbour, somebody has started to argue again.

---

## 4. The late tide — `TK_INTRO`

[STAGE] Dusk at the harbour. The water is still out past the reef. The village is gathered around the niche; the reeve holds the tablet and the chisel. The argument has worn down into silence. The bell tower stands over them, empty. Sets `ch12_tide_wait`.

**TK_INTRO_01** · Fisher
> Write a name.

**TK_INTRO_02** · Net-mender
> Whose?

**TK_INTRO_03** · Old Salter
> Mine.

**TK_INTRO_04** · Boy
> The strangers.

**TK_INTRO_05** · Reeve Fen
> No.

**TK_INTRO_06** · Fisher
> Then yours.

**TK_INTRO_07** · Reeve Fen
> I was going to.

[STAGE] The crowd goes quiet. She turns the tablet over. A name is half-cut into it, stopped after the first letter. She does not show it to the village.

**TK_INTRO_08** · NARRATION
> The tower has no bell. The sound comes anyway: a low note, carried through the stone, the way a bell sounds when it is a long way underwater.

**TK_INTRO_09** · Sera
> That's the tower.

**TK_INTRO_10** · Caelan
> There's nothing in the tower.

**TK_INTRO_11** · Lyra
> There's something in the tower.

[STAGE] The Toll-Keeper comes down the tower stairs and out into the harbour light: a man-shaped thing of brine and rope, weed where a face should be, hung with the fittings of a boat that did not come back. It carries a hook made for a slate. It does not speak. It walks toward the reeve. Sets `ch12_keeper_fight`.

**TK_INTRO_12** · NARRATION
> It is the shape of a man who drowned standing up. The water in it moves against the tide.
> It looks only at the tablet.

**TK_INTRO_13** · Reeve Fen
> Don't.

**TK_INTRO_14** · Kael
> That's far enough.

[STAGE] It does not stop. The village backs away. The reeve does not move. Kael steps between the keeper and the slate.

**TK_INTRO_15** · Sera
> It's not listening.

**TK_INTRO_16** · Caelan
> It's not a person. It's a collection.

**TK_INTRO_17** · Taren
> Then we stop the collection.

[STAGE] Fight: `grp_toll_keeper`, level 24, two phases. Boss music and boss bar. The keeper has no dialogue and no name beyond what the village calls it. Its second phase is the data's shift: the water in it goes still, then moves against the tide, and the hook comes up. No stat block is set here; §11 explains why.

[STAGE] On victory: the keeper comes apart into brine and rope, and the tablet falls onto the stones. The tide begins to turn. Sets `ch12_keeper_defeated`, `Q_MF_S2`, `Q_ST_S2`.

---

## 5. What the tide left — `TK_AFTER`

[STAGE] The harbour is very quiet. The brine is already draining between the stones. The tablet lies face down. The village does not come closer. The reeve picks it up. Sets `ch12_after_keeper`.

**TK_AFTER_01** · NARRATION
> The thing goes out with the water. There is no body. There is the tablet, face down, and a hook that is already rusting.

**TK_AFTER_02** · Fisher
> It didn't take it.

**TK_AFTER_03** · Old Salter
> It didn't take it.
> Then it will take something else.

**TK_AFTER_04** · Reeve Fen
> No. It will take the slate when it is written. That is the bargain.

**TK_AFTER_05** · Sera
> That thing was the bargain?

**TK_AFTER_06** · Reeve Fen
> That thing was what came when the bargain was late.

**TK_AFTER_07** · Caelan
> It's been fed.

**TK_AFTER_08** · Reeve Fen
> We don't name it.

**TK_AFTER_09** · Taren
> You feed it names.

**TK_AFTER_10** · Reeve Fen
> Yes.

**TK_AFTER_11** · Kael
> No more.

**TK_AFTER_12** · Reeve Fen
> You can't say that for the village.
> But you can say it for me. I'm done pretending I don't know what's under this house.

[STAGE] She takes a key from her coat and holds it out to Kael. Not defeated. Not afraid. A clerk closing an account.

**TK_AFTER_13** · Reeve Fen
> The chest is under the levy office. Take it. Read it. If the Crown asks, I'll say the sea took it.

**TK_AFTER_14** · Sera
> Just like that?

**TK_AFTER_15** · Reeve Fen
> I'm a clerk. When the account doesn't balance, I hand it up.

**TK_AFTER_16** · Taren
> And the name?

**TK_AFTER_17** · Reeve Fen
> The name is still the village's. That hasn't changed.

---

## 6. The office beneath — `LG_LEDGER`

[STAGE] The cellar under the levy house: dry stone, tax rolls in racks, a chest against the back wall with a lock older than the house. The reeve holds the lamp. The chest holds one book, leather, water-stained, the size of a ledger. Sets `ch12_ledger_seen`.

**LG_LEDGER_01** · NARRATION
> The chest is older than the office. The lock is older than the chest. Inside, one book, wrapped in oilcloth that has not been opened in a long time.

**LG_LEDGER_02** · Caelan
> It's a ledger. Not a tax ledger.

**LG_LEDGER_03** · NARRATION
> The first page has one word at the top, in the Crown's old hand: **Crossings**.
> Below it, columns: a date, a name, *sent*, *returned*. The names have titles: knight-ordinary, knight-commander. A handful of houses repeat.

**LG_LEDGER_04** · Sera
> It's a tally.

**LG_LEDGER_05** · Taren
> A tally of people.

**LG_LEDGER_06** · Lyra
> The Crown's been sending knights across the Crownveil.

**LG_LEDGER_07** · Caelan
> And counting the ones who come back. Most of the lines carry the return mark. A few do not.
> The dates run for a hundred years. The hand changes. The columns don't.

**LG_LEDGER_08** · Kael
> Why?

**LG_LEDGER_09** · Caelan
> It doesn't say. There is no reason column.

**LG_LEDGER_10** · NARRATION
> Near the back, one page is different. The name has been scraped out with a chisel: one diagonal, then another, the same depth, the same angle, the same hand as the names in the barrow.
> The *returned* mark is still there.

**LG_LEDGER_11** · Lyra
> Someone came back, and someone didn't want the name in the book.

**LG_LEDGER_12** · Caelan
> Or someone didn't come back, and the name was taken out so the count would balance.
> I don't know which. I'm not going to guess.

**LG_LEDGER_13** · Sera
> The Crown keeps two accounts. The salt and the people.

**LG_LEDGER_14** · Reeve Fen
> I only keep the salt.

**LG_LEDGER_15** · Kael
> You kept this.

**LG_LEDGER_16** · Reeve Fen
> It came with the house.

**LG_LEDGER_17** · NARRATION
> The last entry has a ship's name in the margin, half under the water stain. The *sent* column is filled. The *returned* column is not.

**LG_LEDGER_18** · Kael
> We're taking it.

**LG_LEDGER_19** · Reeve Fen
> If the Crown asks, the sea took it.

**LG_LEDGER_20** · Caelan
> The sea has taken enough.

---

## 7. The slate — `TS_CHOICE`

[STAGE] Back at the harbour. The tide is coming in. The niche is empty; the tablet is in the reeve's hands, the half-cut name facing her. The village has gathered again, quieter now. The chisel is on the sea wall. Sets `ch12_slate_choice`.

**TS_CHOICE_01** · Reeve Fen
> The tide will take the slate in an hour. After that, the bargain is another season.

**TS_CHOICE_02** · Sera
> You were going to write your own name.

**TS_CHOICE_03** · Reeve Fen
> I'm the Crown's clerk. The sea won't know the difference.
> It takes the slate. It has never taken a person. That is what we tell ourselves.

**TS_CHOICE_04** · Taren
> You'd give it a name it's never had.

**TS_CHOICE_05** · Reeve Fen
> I've started it three times. I just haven't finished it.

**TS_CHOICE_06** · Lyra
> Why?

**TS_CHOICE_07** · Reeve Fen
> Because the village couldn't agree, and I'm tired of watching them try.

**TS_CHOICE_08** · Kael
> And if we break it?

**TS_CHOICE_09** · Reeve Fen
> Then the bargain ends. The sea takes nothing. The village learns to sleep without a name on a stone.
> Some of them won't.

**TS_CHOICE_10** · Fisher
> You can't break it.

**TS_CHOICE_11** · Old Salter
> It's kept us.

**TS_CHOICE_12** · Net-mender
> It's kept the boats.

**TS_CHOICE_13** · Reeve Fen
> It's kept the fear in one place. That's not the same.

[STAGE] Choice box, two options. Neither is marked correct; neither changes the reward.

| Option | Effect |
|---|---|
| **"Finish the name."** | Set `ch12_toll_kept`. The reeve finishes the cut; the tide takes the tablet. |
| **"Break the slate."** | Set `ch12_toll_broken`. Kael breaks the tablet; the niche is empty. |

### 7.1 If the name is finished — `TS_KEPT`

**TS_KEPT_01** · NARRATION
> She finishes the cut in three strokes and sets the tablet in the niche. The tide comes up the stones and takes it without a sound.
> The village exhales.

**TS_KEPT_02** · Fisher
> Thank you.

**TS_KEPT_03** · Old Salter
> The sea will take what it's owed.
> You understood that.

**TS_KEPT_04** · NARRATION
> It is not quite gratitude. It is the look a village gives someone who has agreed to carry the same weight.

**TS_KEPT_05** · Reeve Fen
> Another season.
> The boat will be ready at dawn. I'll see to it.

### 7.2 If the slate is broken — `TS_BROKEN`

**TS_BROKEN_01** · NARRATION
> Kael takes the tablet off the sea wall and breaks it across his knee. The sound is small. It does not carry.
> The tide comes up into an empty niche.

**TS_BROKEN_02** · Fisher
> You've taken the only thing that kept us.

**TS_BROKEN_03** · Net-mender
> We'll remember.

**TS_BROKEN_04** · Reeve Fen
> No. You'll remember me. They broke it. I let them.

**TS_BROKEN_05** · NARRATION
> Nobody answers her. The village begins to go back to its houses, one at a time, the way water goes out of a pan.

**TS_BROKEN_06** · Reeve Fen
> The boat will be ready at dawn. I'll see to it.

### 7.3 The reward — both branches

**TS_REWARD_01** · Reeve Fen
> The Crown's salt money. It spends the same.

**TS_REWARD_02** · SYSTEM
> Side quest complete: One Name a Tide.
> Received 200 gold.

[STAGE] Sets `q_side_toll_complete`. Same reward either way. Do not add a judgment line to the journal.

---

## 8. The post — `ADL_LETTER`

[STAGE] The levy office, after dark. If `ch11_seal_alden`, one letter waits on the desk, sealed with plain wax, the address in a hand Kael knows. If `ch11_seal_party`, the desk holds only the Crown's papers. In both branches Kael asks whether the post brought anything.

### 8.1 If Chapter 11 ended with `ch11_seal_alden`

**ADL_LETTER_01** · Reeve Fen
> That came on the last post. I didn't open it.

**ADL_LETTER_02** · NARRATION
> The seal is plain wax. Inside, one page, written quickly and then folded once.

**ADL_LETTER_03** · Alden *(letter)*
> I have it. I haven't shown it to anyone yet.
> I keep thinking about what I said in the tomb — that a reason with a name on it is still a reason.

**ADL_LETTER_04** · Alden *(letter)*
> I'm in the capital. The city is quiet in the way a held breath is quiet.
> I'm not asking you to agree with me. I'm asking you to keep asking.

**ADL_LETTER_05** · Alden *(letter)*
> — A.

**ADL_LETTER_06** · Sera
> He's doing what we let him do.

**ADL_LETTER_07** · Taren
> He's doing what he said he'd do. That's not the same as being wrong.

**ADL_LETTER_08** · Kael
> No. It's not.

[STAGE] Sets `ch12_letter_read`.

### 8.2 If Chapter 11 ended with `ch11_seal_party`

**ADL_NONE_01** · Reeve Fen
> The post came and went. There was nothing for you.

**ADL_NONE_02** · Lyra
> Nothing from the capital.

**ADL_NONE_03** · Taren
> Good.

**ADL_NONE_04** · Kael
> We'll ask him when we see him.

**ADL_NONE_05** · Taren
> If we see him.

[STAGE] Sets `ch12_no_letter`. Do not add a letter or a second-hand message; the absence is the branch.

---

## 9. The pier — `KT_PIER`

[STAGE] Night. The tide is in. The village is dark except for the levy house. The harbour pier goes out past the boats, further than the boats need, and there is a figure at the end of it. No lantern. The sea is loud enough to cover a conversation. Sets `ch12_pier`.

**KT_PIER_01** · NARRATION
> The pier is older than the village. It goes out past the last mooring and keeps going.
> There is a man at the end of it, with his back to the shore.

**KT_PIER_02** · Sera
> Someone's on the end.

**KT_PIER_03** · Taren
> No lantern.

**KT_PIER_04** · Lyra
> He's not fishing.

**KT_PIER_05** · Kael
> Stay here.

[STAGE] Kael walks out. The knight does not turn until Kael is close enough to hear him.

**KT_PIER_06** · The Knight
> You're early. She was later than you.

**KT_PIER_07** · Kael
> Who are you?

[STAGE] The knight walks past him along the pier, toward the end, without hurrying. He does not look back. The others come up behind Kael. When they reach the end of the pier, there is no one there. The boards are wet. There are no footprints.

**KT_PIER_08** · Sera
> Where did he go?

**KT_PIER_09** · Caelan
> The boards are wet. There should be prints.

**KT_PIER_10** · Lyra
> There aren't.

**KT_PIER_11** · Taren
> Then he didn't walk.

**KT_PIER_12** · Kael
> He did. We watched him.

**KT_PIER_13** · Sera
> Who was he?

**KT_PIER_14** · Kael
> The same one from the camp. The road. The wood.
> He's been ahead of us the whole way.

**KT_PIER_15** · Lyra
> And he's never once blocked the way.

**KT_PIER_16** · Kael
> He said "she."

**KT_PIER_17** · Taren
> He's said a lot of things.

**KT_PIER_18** · Kael
> This one was different. He said I was early.

**KT_PIER_19** · Sera
> Early for what?

**KT_PIER_20** · Kael
> That's the question.

[STAGE] The tide comes in under the pier. The village is quiet. The bell tower has no bell.

---

## 10. Chapter end — `CH12_END`

[STAGE] Dawn. The boat is ready. The ledger is wrapped in oilcloth in Caelan's pack. The village is not on the shingle to see them off; the reeve is. The reef is white in the grey light. Sets `chapter12_complete`.

**CH12_END_01** · NARRATION
> They leave before the village wakes. The reeve is on the shingle with the boat's rope in her hand, and she does not say goodbye.

**CH12_END_02** · Reeve Fen
> South of the reef, the water's shallow for a mile. After that, keep the book dry.
> The sea has taken enough.

**CH12_END_03** · Caelan
> The last entry names a ship.

**CH12_END_04** · Kael
> Then we find it.

**CH12_END_05** · Sera
> After the ruins.

**CH12_END_06** · Lyra
> After whatever's in the water.

**CH12_END_07** · Taren
> One thing at a time.

**CH12_END_08** · NARRATION
> The boat goes out past the reef. The tide is in. The coast goes on.

**CH12_END_09** · SYSTEM
> Chapter 12 — The Salt Toll — Complete.

---

## 11. Cast, flags, encounters and build

| Name | Role | Notes |
|---|---|---|
| Ilsa Fen (Reeve Fen) | Crown salt reeve | A clerk enforcing a levy she did not set. Non-combatant; yields the office and the ledger rather than force. She offers her own half-cut name to the slate. Named in this draft. |
| The Toll-Keeper | Chapter boss | A drowned collector, silent, two phases. It has no name in the script; the village calls it the keeper. Not the same thing as the Leviathan. |
| Saltreach villagers | Village | Fisher, Net-mender, Old Salter, Boy. Roles, not names; the village's pressure on the party and on the reeve. |
| The Fallen Knight | Story character | One line on the pier. He is not named, not recognised, not fought, and not explained. |
| Alden Marr | Off-screen | One letter if `ch11_seal_alden`; no letter if `ch11_seal_party`. No split. |

| Flag | Set by | Meaning |
|---|---|---|
| `ch12_entered` | Coast road entry | Chapter 12 began |
| `ch12_village_seen` | §2 | Saltreach and the argument seen |
| `ch12_pans_seen` / `ch12_bell_seen` / `ch12_slate_seen` / `ch12_boat_seen` | §2.1–2.4 | Optional village lore |
| `ch12_reeve_met` | §3 | The reeve's account heard |
| `ch12_tide_wait` | §4 | The late tide and the keeper's arrival |
| `ch12_keeper_fight` | §4 | The fight happened |
| `ch12_keeper_defeated` | §4 | The keeper is down; `Q_MF_S2`, `Q_ST_S2` |
| `ch12_after_keeper` | §5 | The reeve yields the key |
| `ch12_ledger_seen` | §6 | The crossings ledger read |
| `ch12_slate_choice` | §7 | The choice opened |
| `ch12_toll_kept` / `ch12_toll_broken` | §7.1 / §7.2 | The side quest's branch |
| `q_side_toll_complete` | §7.3 | Side quest complete |
| `ch12_letter_read` / `ch12_no_letter` | §8.1 / §8.2 | Alden's letter branch |
| `ch12_pier` | §9 | The pier scene |
| `ch12_knight_seen` | §9 | The knight's fifth sighting |
| `chapter12_complete` | §10 | Chapter done |

### Encounters and balance

- **Table:** `drowned_coast` [PROPOSED, not in data] on the coast road only, using `drowned_husk`, `salt_wretch` and `tide_crawler` [PROPOSED ids]. Saltreach itself has no random encounters; the village must not become a fight.
- **Boss:** `grp_toll_keeper` — solo `toll_keeper`, level 24, two phases, no dialogue. **No HP, ATK, DEF, XP or gold number is set here.** The outline requires the enemy batch and `balance_sim.py --act5` first; this script should be tuned against the simulation before `gen_ch12_dialogue.py` is written. The dialogue does not depend on the numbers, but the gate does.
- **Reeve Fen is not a battle.** She yields the key and the ledger under pressure; the chapter's only fight is the keeper. This is the same non-lethal resolution Vell and Calder get, without inventing a new boss group.
- **The knight does not fight here.** His sighting is a scene, not an encounter.

### Build plan

1. **This script** — draft, 2026-11-17. Awaiting owner review.
2. **Enemy batch + simulation** — add the Act V ids, the `drowned_coast` table and `grp_toll_keeper`; extend `balance_sim.py` with `--act5`; tune the keeper at level 24 before generating dialogue.
3. **Dialogue data** — `scr_dialogue_data_ch12` via a new `tools/gen_ch12_dialogue.py`, following the Chapter 10–11 generators.
4. **Story script** — `scr_ch12_story`: coast entry, village, reeve, keeper gate with retry, aftermath, ledger, slate choice, letter branch, pier, chapter end.
5. **Room** — `rm_saltreach`, a blockout first; marker table; the overworld's `saltreach` entrance flipped to `status: "built"`; the harbour pier is inside this room, not `rm_saltreach_pier`. `rm_saltreach_pier` stays Chapter 13's.
6. **Quests** — `Q_MAIN_FALLEN` S1–S6 and `Q_SIDE_TOLL` S1–S2; the side quest completes at §7.
7. **Art and audio** — a coast/stone-and-water blockout until a tileset exists; the keeper's battle art; `snd_amb_water` for the village and harbour.
8. **Playtest** — last, and only in an IDE.

### Decisions on the draft (2026-11-17)

- **The reeve is Ilsa Fen.** The outline left her unnamed; the draft names her so the chapter has a person rather than a function. Speaker tags use "Reeve Fen"; her first name is given once, when she introduces herself.
- **The half-cut name is hers.** The slate choice is to finish Ilsa's name and keep the bargain, or break the slate and end it. The village believes the sea takes the slate and never a person; the script does not say whether that belief is true. This keeps the choice from becoming a menu of villagers and keeps the sacrifice symbolic rather than a hidden execution.
- **Alden's letter stays conditional and stays a letter.** It exists only on `ch11_seal_alden`; on `ch11_seal_party` there is no letter and no second-hand message. The contents commit him to nothing beyond the capital and the seal. He does not appear, and there is no split.
- **Reeve Fen is not a battle.** She yields the office and the ledger; the Toll-Keeper is the chapter's only fight. The outline's "yields rather than dies" is read as the same non-lethal resolution Vell and Calder get, without inventing an unlisted boss. If a human fight is wanted later, it needs an id, a group and a simulation first.
- **The 200-gold reward is the same on both branches.** No unique item and no journal judgment.
- **The village roles stay roles.** Fisher, Net-mender, Old Salter and Boy are not named; the chapter's named people are Ilsa, the party, Alden (by letter) and the knight (unnamed).

### Still open

- **Combat numbers.** The Toll-Keeper's level is 24 from the outline; HP/ATK/DEF, XP/gold and the phase threshold await `balance_sim.py --act5`.
- **The ship's name** in the ledger's last entry is left for Chapter 14.
- **The scraped page's surviving *returned* mark** is a draft addition; the owner can remove it without touching the rest.
- **Owner approval of the chapter as a whole** is still outstanding.

### What this chapter must not do

- Let the reeve explain the crossings, the ledger, or what "returned" means. She is a clerk; she does not know.
- Let anyone in Saltreach recognise the knight, or react to him as anything but a stranger.
- Name the knight, say Mira crossed, or say Kael's father crossed.
- Confirm the drowned civilisation is Aethari, or explain the Crownveil.
- Name the Toll-Keeper, or explain what it is beyond what the village calls it.
- Grade the slate choice, give one branch a better reward, or have the journal congratulate the player.
- Show Alden on screen, split him from Taren, or move Ending C.
