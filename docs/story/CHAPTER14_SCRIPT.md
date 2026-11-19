# ASHEN CROWN — Chapter 14 Script: "The Knight Who Came Back" (Act V: The Fallen Knight)
<!-- audit-skip: approved script; dialogue data is not generated yet -->

Route: **`rm_flooded_ruins`** → the reef at low tide → **`rm_shipwreck`** (new; blockout first): the *Patient Crown*, the hull the ledger names, grounded on the reef with its log still aboard.

> **Status: APPROVED 2026-11-18 — not built, not played.**
> This is the third and final chapter script of Act V. No dialogue data, story script, room, marker table or quest row exists; the Act V enemy batch exists as data. The script carries no combat numbers; the Fallen Knight's stats and yield path are in the batch and simulated with `--act5`.
> **Level band 26** (the approved `PARTY_MAX_LEVEL` rise to 27 is not applied; the cap is still 24). Five in the party, four active; no recruit.
> **Alden is off-screen.** He has no scene, letter or second-hand message in this chapter.
> **Not played.** The wreck is a blockout; the knight reuses the Fallen Knight strip; the crossing token has no icon yet.
> **This chapter's one job:** reveal the office, not the man; let the knight yield; leave the crossing token and the log in the party's hands. It does not name him, explain the ten, say Kael's father or Mira crossed, or open the Crownveil.
> **Approved decisions 2026-11-18:** the knight remains unnamed; the fight is a test, not an execution; the log's reason for stopping stays unwritten; the token has no mechanical function—it is a receipt. See §10. The chapter is approved as story; it is not built or played.

Source of truth: `ACT5_OUTLINE.md` §5; `STORY_BIBLE.md` §5.12 (the Fallen Knight), §2.4 (the Crownveil), and the approved `CHAPTER12_SCRIPT.md` / `CHAPTER13_SCRIPT.md`. Presentation: FF1-style top-down exploration; menu battles.

## How to read this file (for Coder)

- Prefixes: `RK_` for the reef and wreck exterior, `WL_` for the wreck log, `FK_` for the knight, `CT_` for the crossing token, `CH14_` for the chapter's own beats.
- Format: `**ID** · Speaker`, each `>` line one box line. `NARRATION` = no speaker; `SYSTEM` = UI; `[STAGE]` = direction, not shown.
- **What this chapter must not do:** name the knight; say whether he is the Fallen Knight enemy type; say Kael's father crossed the Crownveil, or that Mira did, or where she is; explain what happened to the ten; kill the knight; explain what the token opens; open the Crownveil; split Alden from Taren; move Ending C.

---

## 0. Quest text

### Main quest — `Q_MAIN_FALLEN` "The Knight Who Came Back"

Stages 1–4 were set in Chapters 12–13. This chapter sets stages 5 and 6 and completes the quest.

| Stage | ID | Objective text | Set when |
|---|---|---|---|
| 5 | `Q_MF_S5` | "Face the knight who has been following you." | Chapter 14 entry |
| 6 | `Q_MF_S6` | "Learn what he leaves you." | the knight yields |
| — | complete | — | the chapter ends |

`Q_SIDE_TOLL` is already complete from Chapter 12 and has no branch in this chapter.

---

## 1. The reef — `RK_ARRIVE`

[STAGE] Low tide on the reef. The boat is grounded at the edge of the white water; the *Patient Crown* lies on its side in the shallows, hull black and intact, masts gone. The Fisher waits with the boat. Room entry sets `ch14_entered`, `ch14_wreck_seen`, `Q_MF_S5`; `snd_amb_water` continues.

**RK_ARRIVE_01** · NARRATION
> The reef at low tide is a white plain. The water between the coral heads is knee-deep and warm.
> The *Patient Crown* lies on its side in the middle of it, hull black, masts gone, one rail still above the water.

**RK_ARRIVE_02** · Fisher
> There. The *Patient Crown*.

**RK_ARRIVE_03** · Kael
> You know it.

**RK_ARRIVE_04** · Fisher
> Everyone on the coast knows it. The ship they found empty. No crew. No cargo. Just the hull and the log.

**RK_ARRIVE_05** · Sera
> Empty.

**RK_ARRIVE_06** · Fisher
> That's what they say. I wasn't there.

**RK_ARRIVE_07** · Caelan
> The log.

**RK_ARRIVE_08** · Taren
> The Crown's last crossing.

**RK_ARRIVE_09** · Fisher
> I'll wait at the edge. The tide won't.

**RK_ARRIVE_10** · Kael
> An hour?

**RK_ARRIVE_11** · Fisher
> Less.

**RK_ARRIVE_12** · NARRATION
> The hull is black and wet and does not look old. The name on the bow is cut deep enough to read from the water.
> **Patient Crown.**

**RK_ARRIVE_13** · Lyra
> The Crown named a ship after patience.

**RK_ARRIVE_14** · Caelan
> It's a virtue they liked in other people.

**RK_ARRIVE_15** · Sera
> It's a crossing ship.

**RK_ARRIVE_16** · Caelan
> Berths. Chains. A sealed hold.

**RK_ARRIVE_17** · Kael
> For knights.

**RK_ARRIVE_18** · Taren
> For cargo.

**RK_ARRIVE_19** · Lyra
> Same thing, to the Crown.

**RK_ARRIVE_20** · Kael
> We go in. Watch the tide line.

---

## 2. The hull — `RK_HULL`

[STAGE] The wreck's main deck is above water; the lower decks are flooded. A brass case is visible through the broken cabin door. There are no bodies. Sets `ch14_hull_seen`. The tide is at the hull's lower rail.

**RK_HULL_01** · NARRATION
> The main deck is above the water. The lower decks are not.
> The hull is fitted like a barracks: narrow berths, chain points, a sealed hold with the Crown's mark on the door.

**RK_HULL_02** · Sera
> No bodies.

**RK_HULL_03** · Taren
> No crew.

**RK_HULL_04** · Caelan
> They found it empty.

**RK_HULL_05** · Lyra
> A ship doesn't sail itself.

**RK_HULL_06** · Kael
> It didn't. It ran aground.

**RK_HULL_07** · NARRATION
> The reef is shallow here. The hull is opened along one side, but the damage is old, not fresh.
> Somebody took the crew off. Or the crew took themselves off.

**RK_HULL_08** · Sera
> Where did they go?

**RK_HULL_09** · Caelan
> Not here.

**RK_HULL_10** · Taren
> The log.

**RK_HULL_11** · Caelan
> The cabin. The case is still sealed.

**RK_HULL_12** · Kael
> Then we read it before the tide does.

**RK_HULL_13** · NARRATION
> The cabin door is jammed half-open. The brass case sits on the chart table, waxed shut, the Crown's seal unbroken.

---

## 3. The log — `WL_LOG`

[STAGE] The captain's cabin. The log is a bound book in a brass case, dry under the wax. It records the crossings: dates, names, returns. The last entry is the *Patient Crown*. The last page says only "No further crossings." No reason, no signature. Sets `ch14_log_seen`, `ch14_log_read`. The water is at the cabin door.

**WL_LOG_01** · NARRATION
> The cabin is dry. The wax held.
> The log is a bound book, the size of a ledger, the pages still white at the edges.

**WL_LOG_02** · Caelan
> Crossings. Dates. Names.

**WL_LOG_03** · Kael
> The same as the ledger.

**WL_LOG_04** · Caelan
> The same. The last entry is this ship.

**WL_LOG_05** · Sera
> What does it say?

**WL_LOG_06** · Caelan
> The last crossing. Eleven names. Ten returned.

**WL_LOG_07** · Taren
> And the eleventh?

**WL_LOG_08** · Caelan
> No return.

**WL_LOG_09** · Kael
> Maelin Orr.

**WL_LOG_10** · Caelan
> Yes.

**WL_LOG_11** · Sera
> Then the count is real.

**WL_LOG_13** · NARRATION
> The last page has a single line, in a different hand from the entries. It is not a signature.
> **No further crossings.**

**WL_LOG_14** · Kael
> That's it?

**WL_LOG_15** · Caelan
> No reason. No name. A date.

**WL_LOG_16** · Taren
> They stopped.

**WL_LOG_17** · Caelan
> All at once.

**WL_LOG_18** · Sera
> Because of the ten?

**WL_LOG_19** · Caelan
> The log doesn't say.

**WL_LOG_20** · Lyra
> A book that stops writing is still a book.

**WL_LOG_21** · Kael
> Take it.

**WL_LOG_22** · Caelan
> It's the only thing they left.

**WL_LOG_23** · NARRATION
> Caelan wraps the log in the waxed cloth and puts it in his pack. The case stays on the table, open and empty.

---

## 4. The knight — `FK_APPEAR`

[STAGE] The main deck. The knight is waiting at the rail, back to the sea, not armed. He has been there long enough for the weed to settle around his boots. Sets `ch14_knight_seen`. The tide is at the deck rail.

**FK_APPEAR_01** · NARRATION
> He is on the deck when they come up.
> He stands at the rail with his back to the sea, hands empty, the wind moving his coat.

**FK_APPEAR_02** · Kael
> You.

**FK_APPEAR_03** · The Knight
> You read the log.

**FK_APPEAR_04** · Kael
> You knew it was here.

**FK_APPEAR_05** · The Knight
> I kept it here.

**FK_APPEAR_06** · Taren
> You sank it.

**FK_APPEAR_07** · The Knight
> The reef did. I didn't stop it.

**FK_APPEAR_08** · Sera
> Why?

**FK_APPEAR_09** · The Knight
> So the Crown would stop looking for it.

**FK_APPEAR_10** · Kael
> The crossings had already stopped.

**FK_APPEAR_11** · The Knight
> Yes.

**FK_APPEAR_12** · Kael
> Why?

**FK_APPEAR_13** · The Knight
> That's the question.

**FK_APPEAR_14** · Kael
> You said eleven went. Ten came back wrong.

**FK_APPEAR_15** · The Knight
> I did.

**FK_APPEAR_16** · Kael
> What does wrong mean?

**FK_APPEAR_17** · The Knight
> It means they came back.

**FK_APPEAR_18** · Taren
> That's not an answer.

**FK_APPEAR_19** · The Knight
> No.

**FK_APPEAR_20** · Kael
> I'm not leaving without one.

**FK_APPEAR_21** · The Knight
> Then you'll have to take it.

**FK_APPEAR_22** · NARRATION
> He draws. The blade is plain and old, and it does not waver.
> He does not step toward Kael. He waits.

**FK_APPEAR_23** · Sera
> Kael—

**FK_APPEAR_24** · Kael
> I know.

---

## 5. The fight — `FK_FIGHT`

[STAGE] Fight: `grp_fallen_knight_last`, level 26, two phases. The knight is testing Kael, not trying to kill him. No dialogue during the fight. At 50% he stops holding back. At 0 HP he yields; the engine's `yields` path runs, sets `flag_fallen_knight_last_yielded`; do not play the death animation and do not award bestiary kill credit. Sets `ch14_knight_fight`.

**FK_FIGHT_01** · NARRATION
> He is faster than a man his age has any right to be. He gives ground when he wants to, not when he has to.
> He is not aiming for the others.

**FK_FIGHT_02** · Sera
> He's not trying to kill us.

**FK_FIGHT_03** · Taren
> He's trying to see if we can stop him.

**FK_FIGHT_04** · Kael
> Then stop him.

**FK_FIGHT_TAREN** · Taren
> He's leaving the others alone. He wants you.

**FK_FIGHT_KAEL** · Kael
> Then he can have me.

[STAGE] Phase 2 at 50%: he stops holding back. The water on the deck moves with him. He still does not speak. The fight is the act boss; the outcome is a yield, not a death.

**FK_FIGHT_05** · NARRATION
> The second phase is not anger. It is the moment he decides they are worth the whole of it.
> The deck is wet. The tide is coming back.

**FK_FIGHT_06** · Kael
> Enough.

**FK_FIGHT_07** · NARRATION
> The knight goes down on one knee. His blade stays in his hand. He does not raise it.

---

## 6. The yield — `FK_YIELD`

[STAGE] The knight yields at 0 HP. He is alive. No kill, no death animation, no bestiary credit. Sets `ch14_knight_yielded`, `flag_fallen_knight_last_yielded`, `Q_MF_S6`.

**FK_YIELD_01** · NARRATION
> He kneels on the wet deck, breathing hard, and lets the blade rest across his knee.
> He does not look beaten. He looks finished.

**FK_YIELD_02** · Kael
> Enough.

**FK_YIELD_03** · The Knight
> Yes.

**FK_YIELD_04** · Sera
> Don't.

**FK_YIELD_05** · Kael
> We're not killing him.

**FK_YIELD_06** · Taren
> He asked for it.

**FK_YIELD_07** · Kael
> He asked for a fight. He got one.

**FK_YIELD_08** · NARRATION
> The knight laughs, once, without sound.
> He sheathes the blade.

**FK_YIELD_09** · The Knight
> You're stronger than he was.

**FK_YIELD_10** · Kael
> Than who?

**FK_YIELD_11** · The Knight
> That's the question.

---

## 7. The office — `FK_TALK`

[STAGE] The knight sits on the rail. The tide is coming back around the hull. He talks without being asked. Sets `ch14_office_heard`. The tide is at his boots.

**FK_TALK_01** · The Knight
> The Crown has been sending knights across the Crownveil for a hundred years.

**FK_TALK_02** · Kael
> Across.

**FK_TALK_03** · The Knight
> To the other side. To see what was there. To see what came back.

**FK_TALK_04** · Sera
> And the ones who came back?

**FK_TALK_05** · The Knight
> They're called Fallen Knights.

**FK_TALK_06** · Taren
> That's a title.

**FK_TALK_07** · The Knight
> It's an office.

**FK_TALK_08** · Caelan
> The Fallen Knights. The ones we've fought.

**FK_TALK_09** · The Knight
> The same name. I never said it was the same thing.

**FK_TALK_SERA** · Sera
> They sent knights. Not soldiers. Knights.

**FK_TALK_CAELAN** · Caelan
> A hundred years of crossings. The archives have nothing.

**FK_TALK_10** · Kael
> Are you one of them?

**FK_TALK_11** · The Knight
> I'm a knight. I came back.

**FK_TALK_12** · Kael
> That's not an answer.

**FK_TALK_13** · The Knight
> No.

**FK_TALK_14** · Kael
> Eleven went. Ten came back wrong.

**FK_TALK_15** · The Knight
> Yes.

**FK_TALK_16** · Kael
> What happened to them?

**FK_TALK_17** · The Knight
> They came back wrong.

**FK_TALK_18** · Sera
> What does wrong mean?

**FK_TALK_19** · The Knight
> It means they weren't the same. It means the Crown couldn't use them.
> That's all I'm going to say.

**FK_TALK_20** · Caelan
> The Crown stopped counting.

**FK_TALK_21** · The Knight
> Yes.

**FK_TALK_22** · Caelan
> Why?

**FK_TALK_23** · The Knight
> Because the count stopped being useful.

**FK_TALK_24** · Kael
> My father. Did he—?

**FK_TALK_25** · The Knight
> Your father asked me the same question. She didn't ask at all.

**FK_TALK_26** · Kael
> Mira.

**FK_TALK_27** · The Knight
> She opened the door. I told you that.

**FK_TALK_28** · Kael
> Where is she?

**FK_TALK_29** · The Knight
> You're still asking the wrong question.

**FK_TALK_30** · Taren
> Then what's the right one?

**FK_TALK_31** · The Knight
> Why the Crown stopped counting.

**FK_TALK_32** · Caelan
> The log doesn't say.

**FK_TALK_33** · The Knight
> No. It wouldn't.

**FK_TALK_34** · Sera
> You could tell us.

**FK_TALK_35** · The Knight
> I could.

**FK_TALK_36** · NARRATION
> He looks at the sea beyond the reef. The tide is coming in across the white coral, covering it inch by inch.

**FK_TALK_37** · Kael
> You said I was early.

**FK_TALK_38** · The Knight
> You were.

**FK_TALK_39** · Kael
> For what?

**FK_TALK_40** · The Knight
> The crossing.

---

## 8. The token — `CT_TOKEN`

[STAGE] The knight takes a bronze token from his coat and sets it on the rail. It bears the Crown's mark: a crown around a black sun. Sets `ch14_token`. The tide is at the rail.

**CT_TOKEN_01** · NARRATION
> He reaches into his coat and sets something on the rail.
> A bronze disc, the size of a coin, worn smooth. A crown around a black sun.

**CT_TOKEN_MARK** · NARRATION
> Kael's hand goes to the pendant at his throat. The knight sees it and says nothing.

**CT_TOKEN_02** · The Knight
> This is what they gave us.

**CT_TOKEN_03** · Kael
> A token.

**CT_TOKEN_04** · The Knight
> A crossing token. Every knight got one.

**CT_TOKEN_05** · Caelan
> What does it do?

**CT_TOKEN_06** · The Knight
> It opens nothing. It remembers.

**CT_TOKEN_07** · Sera
> Remembers what?

**CT_TOKEN_08** · The Knight
> That you went.

**CT_TOKEN_09** · Taren
> That's not a key.

**CT_TOKEN_10** · The Knight
> No.

**CT_TOKEN_11** · Kael
> Why give it to me?

**CT_TOKEN_12** · The Knight
> Because you'll go.

**CT_TOKEN_13** · Kael
> Where?

**CT_TOKEN_14** · The Knight
> You'll know when you're ready.

**CT_TOKEN_15** · Kael
> That's not an answer.

**CT_TOKEN_16** · The Knight
> No.

**CT_TOKEN_17** · NARRATION
> He sets the token on the rail between them. It is warm from his hand.

**CT_TOKEN_18** · The Knight
> The log is yours. The count is yours. The rest is the Crown's.

**CT_TOKEN_19** · Kael
> And you?

**CT_TOKEN_20** · The Knight
> I'm done counting.

**CT_TOKEN_21** · NARRATION
> He steps off the wreck into the shallows. The water is at his knees, then his waist.
> He walks north-east, toward the coast road and the mountains beyond it.

**CT_TOKEN_22** · Kael
> Wait—

**CT_TOKEN_23** · NARRATION
> He does not look back. The reef is white around him. Then there is only the reef.

[STAGE] Sets `ch14_knight_gone`.

**CT_TOKEN_24** · Sera
> He's leaving.

**CT_TOKEN_25** · Taren
> Let him.

**CT_TOKEN_26** · Kael
> He said I'll go.

**CT_TOKEN_27** · Caelan
> He said you'll know when.

**CT_TOKEN_28** · Lyra
> That's not a comfort.

**CT_TOKEN_29** · Caelan
> No.

**CT_TOKEN_30** · NARRATION
> Kael picks up the token. It is heavier than it looks.
> The tide is at the hull.

---

## 9. The wreck goes under — `CH14_END`

[STAGE] The tide returns. The party leaves the wreck with the log and the token; the *Patient Crown* slips off the reef. On the boat, the Ironspine is visible on the horizon. Sets `chapter14_complete`, `flag_act5_complete`; completes `Q_MAIN_FALLEN`.

**CH14_END_01** · NARRATION
> The tide comes back across the reef. The water climbs the hull, covers the name, and keeps going.
> The *Patient Crown* slips off the reef without a sound.

**CH14_END_02** · Fisher
> You cut it close.

**CH14_END_03** · Kael
> We're done.

**CH14_END_04** · Fisher
> The ship?

**CH14_END_05** · Caelan
> Going under.

**CH14_END_06** · NARRATION
> The boat pulls away. The wreck is a black shape under the water, then a shadow, then nothing.

**CH14_END_07** · Sera
> The token.

**CH14_END_08** · Kael
> It's not a key.

**CH14_END_09** · Caelan
> No.

**CH14_END_10** · Lyra
> Then what is it?

**CH14_END_11** · Caelan
> A receipt.

**CH14_END_12** · Taren
> For what?

**CH14_END_13** · Caelan
> A crossing.

**CH14_END_14** · Kael
> Not yet.

**CH14_END_15** · NARRATION
> The boat turns north-east. The Ironspine is a grey line on the horizon, still a day away.
> The log is in Caelan's pack. The token is in Kael's hand.

**CH14_END_16** · SYSTEM
> Chapter 14 — The Knight Who Came Back — Complete.

**CH14_END_17** · SYSTEM
> Act V — The Fallen Knight — Complete.

---

## 10. Cast, flags, encounters and build

| Name | Role | Notes |
|---|---|---|
| The Knight | Act boss / story character | The Fallen Knight story character. Unnamed throughout. Fights once, yields at 0 HP, lives, gets no bestiary kill credit. |
| The *Patient Crown* | Wreck | The Crown's last crossing ship. Grounded on the reef; log in a waxed brass case. No crew, no bodies. |
| The Fisher | Boatman | Waits at the edge of the reef. Not named. |
| The party | Five, four active | Kael, Taren, Lyra, Caelan, Sera. No recruit. |
| Alden Marr | Off-screen | No scene, letter or message in this chapter. |

| Flag | Set by | Meaning |
|---|---|---|
| `ch14_entered` | Reef entry | Chapter 14 began; `Q_MF_S5` |
| `ch14_wreck_seen` | §1 | The *Patient Crown* reached |
| `ch14_hull_seen` | §2 | The wreck's fittings and empty decks seen |
| `ch14_log_seen` / `ch14_log_read` | §3 | The log found and read |
| `ch14_knight_seen` | §4 | The knight met on the deck |
| `ch14_knight_fight` | §5 | The fight began |
| `ch14_knight_yielded` | §6 | The knight yielded; `Q_MF_S6` |
| `flag_fallen_knight_last_yielded` | §6 | Engine yield flag from the boss data |
| `ch14_office_heard` | §7 | The office explained |
| `ch14_token` | §8 | The crossing token received |
| `ch14_knight_gone` | §8 | The knight left inland |
| `chapter14_complete` | §9 | Chapter done |
| `flag_act5_complete` | §9 | Act V complete |

### Encounters and balance

- **Boss:** `grp_fallen_knight_last` — solo `fallen_knight_last`, level 26, two phases, `yields: true`. The engine sets `flag_fallen_knight_last_yielded` at 0 HP; the story uses `ch14_knight_yielded`. No death animation, no bestiary kill credit, no loot from the knight himself.
- **No random encounters on the reef or in `rm_shipwreck`.** The wreck is a timed story dungeon; the only fight is the knight. The `drowned_coast` table stays Chapter 12's coast approach.
- **The fight is a test.** He is not trying to kill Kael or the party; the second phase is him taking the fight seriously. The party wins by stopping him, not by executing him.
- **The log and token are story items, not inventory items yet.** The build needs a story-item path for both; do not add them to the shop or loot tables.

### Build plan

1. **This script** — approved 2026-11-18.
2. **Room** — `rm_shipwreck`, a blockout first: reef exterior, main deck, cabin, the rail where the knight waits. Marker table and the overworld `shipwreck` stub flipped to `status: "built"`.
3. **Dialogue data** — `scr_dialogue_data_ch14` via a new `tools/gen_ch14_dialogue.py`, following the Chapter 10–13 generators.
4. **Story script** — `scr_ch14_story`: reef, hull, log, knight, fight, yield, office, token, departure, act end.
5. **Quests** — `Q_MAIN_FALLEN` S5 at entry, S6 at the yield, complete at the chapter end. `Q_SIDE_TOLL` stays complete; no new side quest.
6. **Boss integration** — `grp_fallen_knight_last` already exists; the story must use the engine's yield path and must not play a death. Confirm the bestiary does not record a kill.
7. **Art and audio** — the wreck is a stone-and-water blockout until a coast/wreck tileset exists; the knight reuses the Fallen Knight strip; the crossing token needs an icon or a story-item placeholder. `snd_amb_water` for the reef; the wreck may use the dungeon bed.
8. **Playtest** — last, and only in an IDE.

### Decisions (approved 2026-11-18)

- **The knight stays unnamed.** Speaker tag is "The Knight" throughout. No line gives him a name, a house or a rank beyond "knight".
- **The office is revealed in his words, not a document.** The Crown sent knights across for a century; the ones who came back are called Fallen Knights. The script does not say whether he is the enemy type, which one he is, whether the Crown sent him, or what he wants beyond the test.
- **The fight is a test, not an execution.** He yields at 0 HP; the party does not kill him. The engine's `yields` path is used; no death animation and no bestiary kill credit.
- **The ten stay unexplained.** He says they came back wrong and that the Crown couldn't use them; he refuses to say more. The script does not name them, show them or explain what "wrong" means.
- **Kael's father and Mira stay where canon leaves them.** The line is the outline's exact line: "Your father asked me the same question. She didn't ask at all." It does not say either crossed.
- **The log's reason is unwritten.** The last page says "No further crossings" with no reason and no signature. The knight says the count stopped being useful; that is not the same as the reason.
- **The token has no mechanical function.** It is a bronze crossing token with the crown-and-black-sun mark. It opens nothing and remembers; Caelan calls it a receipt for a crossing. The script does not say what, if anything, it will open.
- **The knight leaves inland.** He walks north-east toward the coast road and the mountains. The party lets him go; there is no chase and no disappearance trick.
- **The wreck is empty of bodies.** The crew's fate is not shown and not explained. The log and the fittings are the evidence; the people are not.

### Still open

- **Playtest.** The knight's numbers and yield path are in the enemy batch and the `--act5` simulation; no battle has been compiled or played.
- **The level cap.** `PARTY_MAX_LEVEL` is still 24; the approved rise to 27 is not applied.
- **The token's use, if any,** is for a later act. The script defines what it means, not what it opens.
- **The knight's identity, whether the Crown sent him, and whether he is the enemy type,** stay open. The act gives him an office and no name.
- **The reason the Crown stopped crossing** is not written; Chapter 14 only records that it did.

### What this chapter must not do

- Name the knight, give him a house, or confirm he is the Fallen Knight enemy type.
- Kill him, play a death animation, award kill credit, or have the party execute him after the yield.
- Say Kael's father crossed the Crownveil, or that Mira did, or where Mira is.
- Explain what happened to the ten, what "wrong" means, or who Maelin Orr was.
- Explain what the token opens, open the Crownveil, show its far side, or explain the Ash, Lumen or the Crown Engine.
- Split Alden from Taren, move Ending C, or bring Alden on screen.
- Let Caelan explain the Aethari's fate or break Sera's silence about the palace.
