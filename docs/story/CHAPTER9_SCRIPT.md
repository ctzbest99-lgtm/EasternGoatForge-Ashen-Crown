# ASHEN CROWN — Chapter 9 Script: "The Crown's Ledger" (Act IV: The Forgotten King)

Route: the road south out of the Blackwood → **`rm_town`**, a Crown market town [PROPOSED name: **Coleford**] → the magistrate's ledger house → the road south again, where the survey says a barrow field should not be.

> **Status: BUILT 2026-11-16 from the approved Act IV outline — not individually approved, not played.**
> Built: `scr_dialogue_data_ch9` (106 nodes), `scr_ch9_story` (entry, Vell's scene and yielding boss, the page, Nessa's choice, Alden, the chapter end), `rm_town` (34×20 blockout, 34 rooms total), `scr_build_town`, `scr_ch9_markers_data`, the `Q_MAIN_CROWN` and `Q_SIDE_LEDGER` quest rows, and the wiring into dialogue, encounters, the controller, the zone-entrance exit script and the audio set. `rm_town` and `rm_barrow_gate` (Chapter 10) are built; the only unresolved references are Acts V–VIII.
> **Not played.** Alden now has a dedicated overworld set and portrait, and Vell and Nessa have dedicated overworld sets (2026-11-18); the town now builds on the `ts_coleford` atlas (unseen in an IDE). The copy branch's `ch9_shop_discount` is read by `scr_shop_buy_price` (10% off, [PROPOSED], every shop). Level band **21** [PROPOSED, the bottom of Act IV's 21–23].
> **This chapter's one job:** get the party out of the wood and into the Crown, show Alden Marr as a friend, and put a torn page in their hands. It does not explain the mark, the doors, the pendant's answer or the Crown's founding.

Source of truth: `STORY_BIBLE.md` (Alden §5.6, Aldric IV §5.7) and `ACT4_OUTLINE.md` §3. Presentation: FF1-style top-down exploration; menu battles.

## How to read this file (for Coder)

- Every dialogue node has a stable ID: `PREFIX_PLACE_NN`, as with Chapters 1–8.
- Prefixes: `TN_` for the town and its road, `VG_` for Magistrate Vell and the ledger, `CL_` for the clerk and the side quest, `AL_` for Alden Marr, `CH9_` for the chapter's own beats.
- Format: `**ID** · Speaker`, each `>` line one box line.
- `NARRATION` = no speaker; `SYSTEM` = UI or quest text; `[STAGE]` = direction, not shown.
- **What this chapter must not do:** let Vell explain why the page was removed; let Alden say what he wants the throne for beyond the serfs; make Alden's ambition visible as ambition; split Alden from Taren; name the Fallen Knight; reveal what the pendant's answer was; use King Aldric IV on screen; open any door.

---

## 0. Quest text

### Main quest — `Q_MAIN_CROWN` "The King Who Was Forgotten" **[PROPOSED, not yet in `scr_quest_data.gml`]**

Act III's `Q_MAIN_BLACKWOOD` closes at S6 when the act card shows ("Learn what the doors want." stays its last stage — the journal text is fixed data and is deliberately not reworded).

| Stage | ID | Objective text | Set when |
|---|---|---|---|
| 1 | `Q_MC_S1` | "Find the Crown's record of what it built." | Chapter 9 entry |
| 2 | `Q_MC_S2` | "Take the torn page to the barrow field." | Vell yields (§5) |

### Side quest — `Q_SIDE_LEDGER` "The Page Nobody Asked For" **[PROPOSED]**

Opens in §5 and closes in §6, the same scene. Reward on the copy branch: a standing discount at Coleford's shop (`ch9_shop_discount`) and one line in Act V. Nothing about it touches the main quest.

| Stage | ID | Objective text | Set when |
|---|---|---|---|
| 1 | `Q_SL_S1` | "Vell's clerk wants the page copied before it leaves." | §5 |
| 2 | `Q_SL_S2` | "Decide whether the clerk gets her copy." | §6 choice |

---

## 1. Out of the wood — `TN_ROAD`

[STAGE] The chapter opens on the road south of `rm_blackwood_doors`, in daylight for the first time in an act. Fields, a hedge, cart ruts, a levy board with a Crown seal on it. The wood is behind them and does not follow. `snd_amb_road` (or the existing day field bed). Sets `ch9_entered`. The pendant is not mentioned here; nobody has explained the sound and this chapter does not try.

**TN_ROAD_01** · NARRATION
> The trees end the way a wall ends. One step of leaf litter, then a hedge, then a field with sheep in it.
> The road is graded. Someone maintains it.

**TN_ROAD_02** · Lyra
> Cart ruts. Deep ones. This road gets used.
> We came through a wood where the patrols stopped and came out on a road the Crown keeps swept.

**TN_ROAD_03** · Caelan
> The Blackwood is one day from a market town.
> That is not a wilderness. That is a border somebody chose.

**TN_ROAD_04** · Sera
> A border with what on the other side?

**TN_ROAD_05** · Caelan
> That is the question the whole act is going to ask.

**TN_ROAD_06** · Taren
> Then let's go ask it where there's a roof and a ledger.
> I've had enough of standing in the dark listening to stones.

**TN_ROAD_07** · Kael
> Coleford. We buy what we need, we ask what the Crown keeps, and we don't tell anyone where we came from.

**TN_ROAD_08** · Taren
> You say that like it'll work.

**TN_ROAD_09** · Kael
> It won't. But we'll know the town before it knows us.

---

## 2. Coleford — `TN_TOWN`

[STAGE] A Crown market town at 21st-century-ordinary scale for this setting: a square, a levy board, a shop, an inn, a magistrate's house with a sealed door and a clerk's window. Nobody is frightened. Nobody has heard of the Blackwood's trouble, and the ones who have heard do not believe it. `snd_town_day` (existing town bed). Sets `ch9_town_seen`. Shop opens here; the party's Act III gold is spendable but there is no Act IV gear yet — the shop's best stock is still Chapter 5's, and the chapter says so in the shop's own line rather than pretending.

**TN_TOWN_01** · NARRATION
> The square is swept. The levy board has this quarter's grain price on it, written in a careful hand.
> Two children are playing at swords with sticks, and one of them is winning.

**TN_TOWN_02** · Sera
> They don't know.

**TN_TOWN_03** · Lyra
> They know the price of grain and the price of wool.
> That's what a town knows.

**TN_TOWN_04** · Caelan
> The wood is a day away and it may as well be a story.
> Ask anyone here and they'll tell you the patrols keep it clear.

**TN_TOWN_05** · Taren
> The patrols are standing in the leaf litter facing a bowl.
> I've been in a cell with better information than this town.

**TN_TOWN_06** · Kael
> Then we don't argue with them. We go where the paper is.

### 2.1 The levy board — `TN_BOARD` (optional)

[STAGE] Inspectable. The board is not a puzzle; it is the chapter's evidence that the Crown's administration runs perfectly and knows nothing. Reading it sets `ch9_board_read` and adds one line to §5's page text. No quest stage.

**TN_BOARD_01** · NARRATION
> Grain, wool, salt, and a line for "survey, Crown lands, quarterly."
> The survey line has a number beside it and no description.

**TN_BOARD_02** · Caelan
> They pay for a survey every quarter.
> Someone rides out four times a year and writes down what the Crown owns.

**TN_BOARD_03** · Lyra
> Then somewhere there's a shelf of those.
> Let's go find out what's on it.

---

## 3. The ledger house — `VG_MEET`

[STAGE] The magistrate's house: a public room with a counter, a strongbox, and a wall of ledgers in matched bindings. Magistrate **Vell** is behind the counter, mid-forties, ink on his cuffs, entirely unafraid. He is not a villain and the scene must not play him as one. Sets `ch9_ledger_seen`. The ledger the party wants is the Crown land survey, and it is short a page — cut out, not lost.

**VG_MEET_01** · NARRATION
> The public room smells of dust and lamp oil. The ledgers are matched, numbered, and in better repair than the road outside.
> The magistrate does not stand up.

**VG_MEET_02** · Vell
> Crown land survey. You'll want the quarterly volumes.
> They're public. Sit down, wash your hands, and don't touch the bindings.

**VG_MEET_03** · Caelan
> You keep them open to the public.

**VG_MEET_04** · Vell
> I keep them correct. Open is a consequence.
> There's a difference, and it's the only thing I've got.

**VG_MEET_05** · Taren
> We're looking for what the Crown built. Roads, walls, anything older than the roads.
> Specifically anything it built and then stopped writing down.

[STAGE] Vell goes still for the first time. He knows exactly which volume. This is the chapter's turn.

**VG_MEET_06** · Vell
> Which quarter?

**VG_MEET_07** · Taren
> You tell me.

**VG_MEET_08** · Vell
> I'll show you the shelf. You'll find the gap yourself.
> Everyone does. Nobody asks.

**VG_MEET_09** · NARRATION
> The volume is the oldest on the shelf. The page has been cut out with a blade, close to the binding, and the stub is still there.
> The cut is old. The leather has closed over it.

**VG_MEET_10** · Sera
> Who removed it?

**VG_MEET_11** · Vell
> Before my time. Before the man before my time.
> I've been the magistrate here for eleven years and I have never once been asked that question.

**VG_MEET_12** · Kael
> I'm asking it.

**VG_MEET_13** · Vell
> And I'm telling you I don't know. I know what the volume says on either side of the gap.
> I know the survey that quarter covered four holdings and the page would have been the fifth.

**VG_MEET_14** · Caelan
> A fifth holding with no name.

**VG_MEET_15** · Vell
> A fifth holding with no name, no tax line, and no road on any map I own.
> Now you know what I know. I'd like you to leave.

[STAGE] The party does not leave. Vell reaches under the counter — not for a weapon; for the bell. He calls the guard detail because that is the procedure, and the chapter should read as a man following procedure, not as a man choosing violence.

**VG_MEET_16** · Vell
> I'd like you to leave, and I'm aware that you won't.
> So we'll do this the way the book says.

---

## 4. The magistrate's guard — `VG_FIGHT`

[STAGE] Fight: `grp_magistrate_vell` — Vell plus two `crown_guard_elite`, boss music and boss bar, at level 21. Vell is a yielding boss (`yields: true`, `yield_flag: "flag_vell_yielded"`): at 0 HP he stops and lives, exactly as Reeve Calder does. He does not use a weapon; his kit is a clerk's — a heavy ledger, a guard stance, and shouting for the men who actually fight. Sets `ch9_vell_fight`.

**VG_FIGHT_01** · NARRATION
> Vell steps back behind the counter and rings the bell twice, unhurried.
> The door opens on two of the Crown's guard, in clean plate, who look bored until they see the party.

**VG_FIGHT_02** · Crown Guard
> Magistrate. Say the word.

**VG_FIGHT_03** · Vell
> The word is "detain." Nobody dies in my public room.

**VG_FIGHT_04** · Taren
> That's the first sensible thing anyone's said in this town.

[STAGE] Boss bar: **Magistrate Vell**. His adds are the fight; he is the reason it is a fight. No phase line — he has one phase and yields.

**VG_FIGHT_05** · Vell
> You'll note I'm not running. I'd like that noted.
> I'm also not the one who cut the page out, and I'd like that noted more.

[STAGE] On yield: `flag_vell_yielded` is set by the battle system. The adds stand down; the fight ends as a victory with them alive.

**VG_YIELD_01** · Vell
> Enough. Enough.
> Guard — stand down. They've won the room, not the argument.

**VG_YIELD_02** · Crown Guard
> Magistrate —

**VG_YIELD_03** · Vell
> I said stand down. Fetch the survey box and put it on the counter.
> Then go and stand outside and be bored again.

---

## 5. The page — `VG_PAGE`

[STAGE] Vell gives up the box: the survey's binding stubs, a loose index, and — from a drawer, not the shelf — the page itself. He has had it for eleven years and never asked why. This is the chapter's information beat, and it gives a place without giving an answer. Sets `ch9_page_taken`, `Q_MC_S2`. If `ch9_board_read`, he also confirms the quarterly survey line on the board is the same survey.

**VG_PAGE_01** · Vell
> The page was in the drawer when I took this post. In an envelope with my predecessor's hand on it.
> "For the next one." That's all it says.

**VG_PAGE_02** · Caelan
> He left it for you.

**VG_PAGE_03** · Vell
> He left it for whoever came after him, and I am whoever came after him.
> I have looked at it perhaps six times in eleven years. I have never once ridden out to see.

**VG_PAGE_04** · NARRATION
> The page is a survey: bearings, distances, a holding marked with a barrow field, and a road to it drawn in a different hand from the rest.
> At the bottom, in the surveyor's column: "Maintained. Item not assessed."

**VG_PAGE_05** · Lyra
> Maintained. They've been paying to keep a road open to a field nobody owns.

**VG_PAGE_06** · Sera
> "Item not assessed." That's not a mistake. That's an instruction.

**VG_PAGE_07** · Vell
> Yes. It is.
> And I have signed the quarterly return every year of my tenure, and the line has always been paid, and I have never asked.

**VG_PAGE_08** · Taren
> Why not?

**VG_PAGE_09** · Vell
> Because a man who asks is a man who is asked about.
> I'm a filing problem, boy. I've made myself one on purpose.

**VG_PAGE_10** · Kael
> Then we'll be the ones who ask.
> You keep the volume. We'll take the page.

**VG_PAGE_11** · Vell
> Take it. It's been in my drawer long enough to be a confession.

---

## 6. The clerk's copy — `CL_CHOICE`

[STAGE] Vell's clerk, **Nessa** — Perrin's cousin, from Cinderhollow originally, and the only person in the room who is frightened — asks for an hour with the page before it leaves. She is not asking for the Crown. She is asking because she has family on the Blackwood side and wants to know what her cousin's taxes have been paying for. Opens `Q_SIDE_LEDGER` at `Q_SL_S1`. Both branches are open; neither is marked right.

**CL_CHOICE_01** · Nessa
> Magistrate — the page. Before it goes.
> An hour. I'll copy it and put it back in the drawer and no one will know it moved.

**CL_CHOICE_02** · Vell
> It's not mine to lend. Ask them.

**CL_CHOICE_03** · Nessa
> My cousin burns charcoal at the wood's edge. He's paid the survey line his whole life.
> I'd like to know what he bought.

**CL_CHOICE_04** · Kael
> Your call, Nessa. Say it and we'll do it.
> Or say nothing and we'll take the page and be gone before the bell rings again.

---

### 6.1 If the player says "Copy it. An hour." — `CL_COPY`

[STAGE] Sets `ch9_page_copied`, `ch9_shop_discount`, `Q_SIDE_LEDGER` to "complete". Nessa copies the page at the counter while the party waits; the town shop's keeper (her uncle) knocks a standing discount off the party's purchases for the rest of the game. One line in Act V refers to a copy existing in Coleford.

**CL_COPY_01** · Kael
> Copy it. An hour. We'll be at the inn.

**CL_COPY_02** · Nessa
> Thank you.

**CL_COPY_03** · Vell
> Don't thank them. Thank the fact that nobody in this town reads.
> If they did, we'd all be answering questions.

**CL_COPY_04** · NARRATION
> She copies it in a clear, careful hand, and blots it, and sands it, and does not look up once.
> When she's done she folds the copy into her sleeve and hands the page back without a word.

---

### 6.2 If the player says "No. The page doesn't leave our hands." — `CL_TAKE`

[STAGE] Sets `ch9_page_kept`, `Q_SIDE_LEDGER` to "complete". No reward, no discount. Nessa accepts it the way a clerk accepts a decision, and one line follows the party out of the door.

**CL_TAKE_01** · Kael
> No. The page doesn't leave our hands.
> Not for an hour, not for a minute.

**CL_TAKE_02** · Nessa
> I understand.

**CL_TAKE_03** · Taren
> Do you?

**CL_TAKE_04** · Nessa
> I'm a clerk, sir. Understanding things I can't change is the whole of my work.
> Mind the step on your way out.

---

## 7. Alden Marr — `AL_MEET`

[STAGE] Alden is in the town's inn, on the rebellion's business, and he has been here three days. He is warm with Kael, careful with Taren, and easy with everyone else — the same man he was in Valemere. He is not lying about anything he says here. The scene plants the word **legitimacy**, and it must not show him wanting the throne. Sets `ch9_alden_met`, then `ch9_alden_pact`. Taren says yes too quickly, and the chapter does not comment on it. No split.

**AL_MEET_01** · NARRATION
> Alden is at the inn's back table with a pot of tea and three separate piles of paper, and he stands up so fast the chair goes over.

**AL_MEET_02** · Alden
> Kael.
> You look like a man who has been in a wood for a month.

**AL_MEET_03** · Kael
> Two. It was two.

**AL_MEET_04** · Alden
> Then sit down and eat something that isn't smoked, and tell me what the Crown has been hiding out there.

**AL_MEET_05** · Taren
> What makes you think it's hiding something?

**AL_MEET_06** · Alden
> Because I've been three days in a Crown town asking what the Crown owns, and every answer has been a form.
> A form is what a man writes when he doesn't want to write the truth.

[STAGE] Alden has his own copy of the survey's index — bought, borrowed, or copied; he does not say which, and the chapter does not ask. This is the first piece of the act's machinery clicking together.

**AL_MEET_07** · Alden
> There's a gap in the survey. Four holdings that quarter and a fifth with no name.
> I've been trying to find a man who'd say the fifth's name out loud. You've found a page.

**AL_MEET_08** · Caelan
> You know what's on it?

**AL_MEET_09** · Alden
> I know what it would have to be. Land the Crown maintains and doesn't assess is land the Crown is frightened of.
> And a Crown that's frightened of a field is a Crown with a reason.

**AL_MEET_10** · Sera
> That's a large conclusion from a missing page.

**AL_MEET_11** · Alden
> It's the only conclusion a man can reach from a missing page, and I've had three days to reach it.
> I'm not asking you to agree. I'm asking to come with you.

**AL_MEET_12** · Kael
> Why?

**AL_MEET_13** · Alden
> Because whoever sits the throne next will need a reason, and the Crown has spent a hundred years making sure nobody has one.
> I want to know what it buried. That's all. I want to know what it buried.

**AL_MEET_14** · Taren
> Then come. We leave at first light.

[STAGE] Taren answers before Kael does, and Kael notices. Alden notices too and says nothing about it — he is pleased, and the chapter must let him be pleased without making it sinister.

**AL_MEET_15** · Kael
> Taren.

**AL_MEET_16** · Taren
> What? He wants the same thing we want.
> You've been asking who built the door since the Watchtower. He's asking who hid the answer. It's the same question with a roof on it.

**AL_MEET_17** · Alden
> I'll take that as a yes from the both of you.
> I've got a horse, a map with a hole in it, and no intention of being left behind.

**AL_MEET_18** · Lyra
> Can you fight?

**AL_MEET_19** · Alden
> Badly. But I can run, and I can lie to a magistrate, and I've never once been the first to leave a room.

**AL_MEET_20** · Sera
> That's not an answer.

**AL_MEET_21** · Alden
> It's the honest one. Ask me again on the road.

---

## 8. The road south — `CH9_END`

[STAGE] Out of the town at first light, the survey page folded in Kael's coat. The road south is graded for another mile and then stops being graded. The barrow field is on the page and not on any signpost. Sets `chapter9_complete`. Chapter card. `rm_barrow_gate` is Chapter 10's room and is not entered here.

**CH9_END_01** · NARRATION
> The road holds for a mile past the last house, then loses its gravel and becomes a track.
> Somewhere ahead of them, according to a page nobody was supposed to have, the Crown has been paying to keep a road open.

**CH9_END_02** · Alden
> You know what I keep thinking about?

**CH9_END_03** · Kael
> Tell me.

**CH9_END_04** · Alden
> Somebody cut that page out and then kept the book.
> They didn't burn it. They didn't burn the whole shelf. They cut one page and left the stub where anyone could see it.

**CH9_END_05** · Caelan
> Because a gap can be explained. A missing book can't.

**CH9_END_06** · Alden
> No. Because they wanted it found.
> By the right person. Eventually. After a hundred years.

**CH9_END_07** · Taren
> Or because they were frightened, and frightened men are lazy.

**CH9_END_08** · Alden
> That's the better answer. I'm hoping it's the worse one.

**CH9_END_09** · SYSTEM
> Quest updated: Take the torn page to the barrow field.
> Chapter 9 — The Crown's Ledger — Complete.

---

## 9. Cast and flags

| Name | Role | Notes |
|---|---|---|
| Magistrate Vell | Chapter boss (yields) | A career clerk who has known about the gap for eleven years and never asked. Lives. |
| Crown Guard Elite ×2 | Boss adds | Clean plate, bored, following procedure. |
| Nessa | Vell's clerk, Perrin's cousin | From Cinderhollow. Wants to know what her cousin's taxes bought. |
| Alden Marr | Ally, not yet a party member | Sincere, warm, useful. Wants a reason for whoever sits the throne next. |

| Flag | Set by | Meaning |
|---|---|---|
| `ch9_entered` | Entering the south road | Chapter 9 began |
| `ch9_town_seen` | Entering `rm_town` | Coleford is known |
| `ch9_board_read` | Inspecting the levy board | The survey line is known |
| `ch9_ledger_seen` | §3 | The gap is known |
| `ch9_vell_fight` | §4 | The fight happened |
| `flag_vell_yielded` | Battle system (data) | Vell lived |
| `ch9_page_taken` | §5 | The party holds the page |
| `ch9_page_copied` / `ch9_page_kept` | §6 choice | What Nessa got |
| `ch9_shop_discount` | §6 copy branch | Standing shop discount in Coleford |
| `ch9_alden_met` / `ch9_alden_pact` | §7 | Alden is with them |
| `chapter9_complete` | §8 | Chapter done |
| `Q_MC_S1` / `Q_MC_S2` | Entry / Vell yields | Main quest stages |
| `Q_SL_S1` / `Q_SL_S2` | §6 open / choice | Side quest stages |

---

## 10. Encounters and balance

- **Table:** `crown_barrow` (21–23) on the road and in the town's outskirts. Chapter 9 runs at 21 and should lean on `crown_guard_elite` + `barrow_husk` and the two-guard `oath_iron` group. The town square itself has no random encounters; the fights belong to the road and the ledger house's back yard.
- **Boss:** `grp_magistrate_vell` — Vell (1022 HP, 52 ATK, 38 DEF, yields) + 2 × `crown_guard_elite` (152 HP each). Simulated at level 21: **100% wins in 6.5 rounds with 0.62 deaths (party + Caelan) and 8.1 rounds with 0.20 deaths (+ Sera)**, 35–39% party HP left. At level 23 it is 6.1–7.1 rounds and 18% HP left — the fight is not meant to be a wall, and it isn't.
- **The yield matters to balance:** the fight ends the moment Vell reaches 0 HP, with both guards still standing. Killing him is not possible through normal play, which is the point — the Crown's face in this chapter is a man who stops when the procedure says stop.
- **Simulation is a model, not a playtest.** No room, no script and no battle has been run in an IDE.

---

## 11. Build plan, and what exists

1. **This script** — done 2026-11-16, written to the approved outline and the shipped data.
2. **Dialogue data** — `scr_dialogue_data_ch9`, generated by `tools/gen_ch9_dialogue.py` from this file. **Done** (106 nodes: 96 scripted + 11 wiring-only).
3. **Story script** — `scr_ch9_story`: entry, the board, the ledger scene, the Vell gate, the page, the clerk choice, Alden's scene and the chapter end. **Done.**
4. **Room** — `rm_town`, a 34×20 blockout with its marker table, generated by `tools/gen_ch9_rooms.py`. **Done.** It closes the `rm_town` reference and adds `rm_barrow_gate` as the next act's.
5. **Quest rows** — `Q_MAIN_CROWN` and `Q_SIDE_LEDGER` in `scr_quest_data.gml`. **Done.**
6. **Art** — **Alden's overworld set and portrait: done 2026-11-18** (16×24 set, three 48×48 portraits; appearance is art direction, not story canon). He is on screen in three chapters and no longer borrows another NPC's silhouette. Vell's and Nessa's dedicated 16×24 sets are done (2026-11-18), so the ledger house no longer puts placeholder bodies on screen; Coleford still needs a town tileset that is not Wrenfield's.
7. **Audio** — `rm_town` uses the `wind` bed; there is no town bed and the ledger house has no interior bed. **Partly done.**

**Deviations and open points, recorded rather than hidden:** Coleford is a name this script invented [PROPOSED]; Vell, Nessa and the survey page are all [PROPOSED] Act IV content, not bible canon; and Alden's line about "whoever sits the throne next" is deliberately the furthest the text goes toward his Ending C, which stays locked, unplaced and unresolved.
