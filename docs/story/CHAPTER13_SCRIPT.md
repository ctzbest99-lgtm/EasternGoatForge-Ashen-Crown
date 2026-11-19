# ASHEN CROWN — Chapter 13 Script: "What the Tide Kept" (Act V: The Fallen Knight)
<!-- audit-skip: approved script; dialogue data is not generated yet -->

Route: **`rm_saltreach`** → **`rm_saltreach_pier`** (new; blockout first) → by boat through the reef → **`rm_flooded_ruins`** (new; blockout first): an Aethari record hall left dry for one hour at low tide, then drowned.

> **Status: APPROVED 2026-11-18 — not built, not played.**
> This is the second chapter script of Act V. No dialogue data, story script, room, marker table or quest row exists; the Act V enemy batch exists as data. The script carries no combat numbers; the Leviathan's stats are in the batch and simulated with `--act5`.
> **Level band 25** (the approved `PARTY_MAX_LEVEL` rise to 27 is not applied; the cap is still 24). Five in the party, four active; no recruit.
> **Alden is off-screen.** He has no scene, letter or second-hand message in this chapter.
> **Not played.** The pier and ruin are blockouts; the Leviathan has no art; the boatman is a placeholder.
> **This chapter's one job:** find the record of the crossings and learn what the village's toll has been feeding. It does not explain the ten scraped names, the knight, the drowned civilisation or the Crownveil.
> **Approved decisions 2026-11-18:** the record room is Aethari-built and Crown-used; the Aethari inscription is a record-hall text; the legible name is Maelin Orr; the chisel is Crown issue; the leviathan is a beast, not a god. See §13. The chapter is approved as story; it is not built or played.

Source of truth: `ACT5_OUTLINE.md` §4; `STORY_BIBLE.md` §3 (the Drowned Coast), §5.12 (the Fallen Knight), and the approved `CHAPTER12_SCRIPT.md`. Presentation: FF1-style top-down exploration; menu battles.

## How to read this file (for Coder)

- Prefixes: `FP_` for the outer pier and departure, `FR_` for the flooded ruins, `KN_` for the knight in the dry chamber, `LV_` for the Leviathan, `CH13_` for the chapter's own beats.
- Format: `**ID** · Speaker`, each `>` line one box line. `NARRATION` = no speaker; `SYSTEM` = UI; `[STAGE]` = direction, not shown.
- **What this chapter must not do:** let Caelan translate the ten scraped names; say the drowned civilisation is Aethari; explain what the ten became; name the knight; have the knight fight here; say Mira crossed, or that Kael's father did; explain the Crownveil; turn the Leviathan into a god or a construct.

---

## 0. Quest text

### Main quest — `Q_MAIN_FALLEN` "The Knight Who Came Back"

Stages 1–2 were set in Chapter 12. This chapter sets stages 3 and 4; stages 5–6 belong to Chapter 14.

| Stage | ID | Objective text | Set when |
|---|---|---|---|
| 3 | `Q_MF_S3` | "Find the record of the crossings." | Chapter 13 entry |
| 4 | `Q_MF_S4` | "Reach the wreck the ledger names." | the ship's name is read |

`Q_SIDE_TOLL` is already complete from Chapter 12 and has no branch in this chapter.

---

## 1. The outer pier — `FP_DEPART`

[STAGE] Dawn in the boat, clear of `rm_saltreach_pier`: the outer pier is a line of black stones behind them, the village a row of grey roofs along the shore. The ledger is wrapped in oilcloth in Caelan's pack. The reef is ahead, white in the grey light. Room entry sets `ch13_entered`, `ch13_depart`, `Q_MF_S3`; `snd_amb_water` continues from Saltreach.

**FP_DEPART_01** · NARRATION
> The outer pier falls behind them, older than the harbour: black stones fitted without mortar, the water below clear all the way down.
> The boat is the only one left on the coast that will take the reef.

**FP_DEPART_02** · Sera
> The village isn't coming.

**FP_DEPART_03** · Lyra
> Good.

**FP_DEPART_04** · Taren
> They're awake now. They'll be watching from the windows.

**FP_DEPART_05** · Kael
> Let them.

**FP_DEPART_06** · Fisher
> One hour. Maybe less.

**FP_DEPART_07** · Caelan
> The ruin is dry at low tide?

**FP_DEPART_08** · Fisher
> The top of it. The rest is water.

**FP_DEPART_09** · Sera
> And the boat?

**FP_DEPART_10** · Fisher
> I wait outside the ruin. I don't go in.

**FP_DEPART_11** · Taren
> Why not?

**FP_DEPART_12** · Fisher
> Because the last man who did didn't come out.

**FP_DEPART_13** · Lyra
> That's a good reason.

**FP_DEPART_14** · Kael
> We're not here to stay. We find the record, we leave.

**FP_DEPART_15** · Caelan
> If it's still there.

**FP_DEPART_16** · NARRATION
> The boat turns south. The village shrinks to a row of grey roofs, then to a line of smoke, then to nothing.
> The reef is white ahead. The water between it and the shore is black.

**FP_DEPART_17** · Fisher
> The tide turns at the second bell. There is no bell. I'll shout.

**FP_DEPART_18** · Kael
> We'll hear you.

**FP_DEPART_19** · NARRATION
> The oars go in. The boat turns toward the cut in the reef.

---

## 2. The reef passage — `FR_APPROACH`

[STAGE] The boat passes through a cut in the reef. The water is shallow enough to see the bottom, then deep enough to see nothing. The ruin rises out of the sea ahead: a low dome of black stone, half drowned, with one dry door above the waterline. Sets `ch13_reef_crossed`, `ch13_ruins_seen`.

**FR_APPROACH_01** · NARRATION
> The reef is a white line across the sea. The cut through it is narrow enough that the boat has to be rowed, not sailed.
> On the far side, the water goes black.

**FR_APPROACH_02** · Fisher
> There. The stone that shouldn't be there.

**FR_APPROACH_03** · Caelan
> It's Aethari.

**FR_APPROACH_04** · Sera
> You can tell from here?

**FR_APPROACH_05** · Caelan
> The angles. The stone doesn't weather like ours.

**FR_APPROACH_06** · Lyra
> It's a doorway in the water.

**FR_APPROACH_07** · Taren
> How long has it been under?

**FR_APPROACH_08** · Fisher
> Since before Saltreach. Maybe before the Crown.

**FR_APPROACH_09** · Caelan
> The upper hall is dry. The lower is still flooded.

**FR_APPROACH_10** · Kael
> Then we start at the top.

**FR_APPROACH_11** · Fisher
> I'll hold here. If the water starts running out, get back. That's the tide turning under you.

**FR_APPROACH_12** · Sera
> And if we don't?

**FR_APPROACH_13** · Fisher
> I'll tell them you went to the reef.

**FR_APPROACH_14** · NARRATION
> The boat scrapes stone. The ruin's threshold is a black step above the water, dry and sharp, as if it was cut yesterday.
> The air coming out of it is cold and smells of salt and old bronze.

**FR_APPROACH_15** · Lyra
> No birds.

**FR_APPROACH_16** · Caelan
> No fish, either.

**FR_APPROACH_17** · Taren
> Then we're the first thing that's been in here in a while.

**FR_APPROACH_18** · Kael
> Stay close. Touch nothing that's still writing.

---

## 3. The dry threshold — `FR_ARRIVE`

[STAGE] The upper hall is dry and cold. The door is a vertical cut with an inscription down one side; the letters are Aethari. The floor is black stone, dry above a clear waterline. The lower stair goes down into shallow water. A bronze plate has been set into the wall beside the door, newer than the stone. Sets `ch13_record_seen`.

**FR_ARRIVE_01** · NARRATION
> The door is a vertical cut in the dome, tall enough for two people, narrow enough that they have to go in one at a time.
> The inscription runs down the left side, worn but not erased.

**FR_ARRIVE_02** · Caelan
> "A record of what the water kept."

**FR_ARRIVE_03** · Kael
> The crossings.

**FR_ARRIVE_04** · Caelan
> The bronze is. The stone is older.

**FR_ARRIVE_05** · Sera
> This isn't a tomb.

**FR_ARRIVE_06** · Caelan
> No. It's a record room. The stone is Aethari. The bronze is newer.

**FR_ARRIVE_07** · Taren
> The Crown found it and moved in.

**FR_ARRIVE_08** · Caelan
> Not moved in. Used. The waterline is wrong for a permanent office.

**FR_ARRIVE_09** · Lyra
> They came at low tide. Like us.

**FR_ARRIVE_10** · Kael
> Then they had an hour too.

**FR_ARRIVE_11** · NARRATION
> The upper hall is a long rectangle, dry above a line that runs knee-high along the walls. Below the line, the stone is green and soft. Above it, the stone is black and sharp.
> There are shelves. Tablets. A table.

**FR_ARRIVE_12** · Caelan
> There are records. A lot of them.

**FR_ARRIVE_13** · Sera
> No bodies.

**FR_ARRIVE_14** · Caelan
> No bodies.

**FR_ARRIVE_15** · Taren
> That's not better.

**FR_ARRIVE_16** · Kael
> Watch the stairs. The water's moving.

**FR_ARRIVE_17** · NARRATION
> The water in the lower stair is moving against the tide. It comes up one step, stops, and goes down again.
> Nothing in the room is making it move.

**FR_ARRIVE_18** · Lyra
> Tell me that's the sea.

**FR_ARRIVE_19** · Caelan
> It's the sea.

**FR_ARRIVE_20** · Lyra
> You're a bad liar.

---

## 4. The record hall — `FR_RECORD`

[STAGE] The record hall: stone shelves, bronze plates, a central table, salt in the joints. Most of the tablets are blank or corroded; one bronze plate is clean. A steel chisel lies in a leather roll beside it. Sets `ch13_list_seen`. The water in the lower stair has climbed one step since they came in.

**FR_RECORD_01** · NARRATION
> The hall is a library for things that were never meant to be read twice.
> The shelves hold stone tablets, most of them blank. A few still have the ghosts of letters under the salt.

**FR_RECORD_02** · Caelan
> Crossings. A list.

**FR_RECORD_03** · Kael
> Eleven lines.

**FR_RECORD_04** · Caelan
> Eleven names. Ten struck out.

**FR_RECORD_05** · Sera
> Struck out?

**FR_RECORD_06** · Caelan
> Chiselled. Deep. Not weather.

**FR_RECORD_07** · Lyra
> Someone didn't want them read.

**FR_RECORD_08** · Taren
> Or wanted them counted.

**FR_RECORD_09** · Caelan
> Both. The tool is still here.

**FR_RECORD_10** · NARRATION
> A steel chisel in a leather roll, laid square to the plate. The handle is worn dark. The edge is bright.
> The cuts in the bronze are the same width as the chisel.

**FR_RECORD_11** · Kael
> Crown issue?

**FR_RECORD_12** · Caelan
> The mark is the Crown's. Old.

**FR_RECORD_13** · Sera
> Same as the tomb.

**FR_RECORD_14** · Caelan
> Same angle. Same depth. I can't tell you it's the same hand.

**FR_RECORD_15** · Taren
> You don't have to.

**FR_RECORD_16** · NARRATION
> The tenth line is a scar. The eleventh is a name.

**FR_RECORD_17** · Lyra
> Can you read any of the others?

**FR_RECORD_18** · Caelan
> No. The bronze is gone under the cuts. There's nothing left to read.

**FR_RECORD_19** · Kael
> Then why leave one?

**FR_RECORD_20** · Caelan
> Because someone wanted one name left.

---

## 5. The eleven — `FR_ELEVEN`

[STAGE] The eleventh name is legible: **Maelin Orr**, knight-ordinary. No house, no return date. The ten struck lines have no recoverable names. Sets `ch13_name_seen`. The water has climbed another step.

**FR_ELEVEN_01** · NARRATION
> The last line is untouched. The bronze around it is clean.
> **Maelin Orr. Knight-ordinary.**

**FR_ELEVEN_02** · Caelan
> Maelin Orr.

**FR_ELEVEN_03** · Kael
> I don't know it.

**FR_ELEVEN_04** · Lyra
> Should we?

**FR_ELEVEN_05** · Caelan
> If we did, that would be the problem.

**FR_ELEVEN_06** · Sera
> No title beyond knight?

**FR_ELEVEN_07** · Caelan
> No house. No date of return.

**FR_ELEVEN_08** · Taren
> The others have dates?

**FR_ELEVEN_09** · Caelan
> The others have holes.

**FR_ELEVEN_10** · Kael
> Not my father. Not Mira.

**FR_ELEVEN_11** · Caelan
> I can't read them. I can't tell you that.

**FR_ELEVEN_12** · Sera
> Why leave this one?

**FR_ELEVEN_13** · Caelan
> A receipt. A warning. I don't know.

**FR_ELEVEN_14** · Lyra
> It's a name. Names are for finding.

**FR_ELEVEN_15** · Taren
> Or for blaming.

**FR_ELEVEN_16** · NARRATION
> The plate is cold. The name is cut clean, with none of the hesitation in the other lines.
> Whoever struck the ten stopped before this one.

**FR_ELEVEN_17** · Kael
> The knight said eleven went.

**FR_ELEVEN_18** · Caelan
> Then this is the eleventh. Or the one they left to count.

**FR_ELEVEN_19** · Sera
> Which?

**FR_ELEVEN_20** · Caelan
> The note says keep the count. It doesn't say why.

**FR_ELEVEN_21** · Taren
> It doesn't have to. Someone wanted a name left.

**FR_ELEVEN_22** · Lyra
> And we found it.

**FR_ELEVEN_23** · Kael
> We're not here to guess. We're here to read.

---

## 6. The chisel — `FR_CHISEL`

[STAGE] A wax note under the chisel, in the Crown's old hand: "Ten returned. Strike the names. Keep the count." The ten returned; the eleventh did not, or was not counted. Caelan cannot tell which. Sets `ch13_chisel_seen`. The water is at the third step.

**FR_CHISEL_01** · NARRATION
> There is a strip of wax under the chisel, pressed flat and dry. The hand is Crown, old, small and exact.
> It says: **Ten returned. Strike the names. Keep the count.**

**FR_CHISEL_02** · Caelan
> That's all.

**FR_CHISEL_03** · Sera
> Ten returned.

**FR_CHISEL_04** · Taren
> And the eleventh?

**FR_CHISEL_05** · Caelan
> Didn't come back. Or wasn't counted.

**FR_CHISEL_06** · Lyra
> Which?

**FR_CHISEL_07** · Caelan
> The note doesn't say.

**FR_CHISEL_08** · Kael
> The tomb had the same cuts.

**FR_CHISEL_09** · Caelan
> The same order. Someone has been erasing the Crown's crossings for a long time.

**FR_CHISEL_10** · Taren
> Or erasing the evidence of them.

**FR_CHISEL_11** · Sera
> There's a difference?

**FR_CHISEL_12** · Caelan
> Only to the people who were crossed.

**FR_CHISEL_13** · NARRATION
> The water in the lower stair moves again. This time it comes up two steps and stays.

**FR_CHISEL_14** · Lyra
> That's not the tide.

**FR_CHISEL_15** · Caelan
> No.

**FR_CHISEL_16** · Kael
> The count can wait. We need the lower hall.

**FR_CHISEL_17** · Sera
> Why?

**FR_CHISEL_18** · Kael
> Because whatever's moving it came from down there.

**FR_CHISEL_19** · Taren
> And because the record isn't finished.

**FR_CHISEL_20** · Caelan
> It never is.

---

## 7. The lower hall — `FR_LOWER`

[STAGE] The lower stair goes into shallow water. The water is warm. The hall below is a midden of slate fragments, hundreds of them, blank or worn. The walls are lined with empty record niches. A dry passage above the waterline leads deeper. Sets `ch13_lower_seen`. The water is at the top of the lower stair.

**FR_LOWER_01** · NARRATION
> The stairs go down into water. It is warm.
> The lower hall is long and low. The walls are lined with niches, each one the size of a hand.

**FR_LOWER_02** · Lyra
> It's warm.

**FR_LOWER_03** · Caelan
> It shouldn't be.

**FR_LOWER_04** · Sera
> What's that on the floor?

**FR_LOWER_05** · NARRATION
> Slate. Hundreds of pieces, worn round at the edges, spread across the floor like shingle.
> Some still have the shape of a letter. Most are blank.

**FR_LOWER_06** · Kael
> The tablets.

**FR_LOWER_07** · Lyra
> The names.

**FR_LOWER_08** · Caelan
> The slates. The names were cut into them. The tide takes them through the cut and leaves them here. The water took the rest.

**FR_LOWER_09** · Taren
> It's a midden.

**FR_LOWER_10** · Sera
> It's a stomach.

**FR_LOWER_11** · Caelan
> Don't.

**FR_LOWER_12** · Kael
> It's a beast. It doesn't know what a name is.

**FR_LOWER_13** · Taren
> Then the village has been feeding it for nothing.

**FR_LOWER_14** · Caelan
> Not nothing. It left them alone.

**FR_LOWER_15** · Sera
> That's not a bargain. That's a habit.

**FR_LOWER_16** · Lyra
> A habit with teeth.

**FR_LOWER_17** · NARRATION
> Something moves under the water at the far end of the hall. The slate shifts with it, a long slow wave, and settles.
> The water goes still.

**FR_LOWER_18** · Kael
> Back. Slow.

**FR_LOWER_19** · Caelan
> The dry passage. There.

**FR_LOWER_20** · NARRATION
> A cut in the wall above the waterline, just wide enough for a person. The stone inside is dry.
> The water below it is not moving.

**FR_LOWER_21** · Taren
> That's where it wants us to go.

**FR_LOWER_22** · Kael
> Then we go.

**FR_LOWER_23** · Sera
> Or we leave.

**FR_LOWER_24** · Kael
> The record isn't finished.

---

## 8. The dry chamber — `KN_DRY`

[STAGE] A dry inner chamber above the waterline: a stone bench, a dead lamp, a slit window on the reef. The knight stands with his back to the passage. He is not armed. He does not turn until Kael is inside. Sets `ch13_knight_seen`.

**KN_DRY_01** · NARRATION
> The chamber is dry. There is a stone bench, a lamp with no oil, and a slit window that looks out on the reef.
> The knight stands with his back to the passage.

**KN_DRY_02** · Sera
> Someone's here.

**KN_DRY_03** · NARRATION
> He does not turn.

**KN_DRY_04** · Kael
> You.

**KN_DRY_05** · The Knight
> You found the count.

**KN_DRY_06** · Kael
> You knew it was here.

**KN_DRY_07** · The Knight
> I knew what it would cost to read it.

**KN_DRY_08** · Taren
> Who are you?

**KN_DRY_09** · The Knight
> A knight. The kind the Crown stopped counting.

**KN_DRY_10** · Kael
> What does that mean?

**KN_DRY_11** · The Knight
> Eleven went. Ten came back wrong. I am not the wrong one.

**KN_DRY_12** · Kael
> What does wrong mean?

**KN_DRY_13** · The Knight
> It means they came back.

**KN_DRY_14** · Sera
> And you?

**KN_DRY_15** · The Knight
> I came back too.

**KN_DRY_16** · Lyra
> That's not a count.

**KN_DRY_17** · The Knight
> No.

**KN_DRY_COUNT_01** · Caelan
> Eleven went. Ten came back. You're not the eleventh, and you're not one of the ten.

**KN_DRY_COUNT_02** · The Knight
> Correct.

**KN_DRY_COUNT_03** · Kael
> Then what are you?

**KN_DRY_COUNT_04** · The Knight
> A knight.

**KN_DRY_18** · Kael
> My father—

**KN_DRY_19** · The Knight
> Your father knew what was coming.

**KN_DRY_20** · Kael
> You said that before.

**KN_DRY_21** · The Knight
> It was true then.

**KN_DRY_22** · Caelan
> The list. Maelin Orr.

**KN_DRY_23** · The Knight
> The one they left.

**KN_DRY_24** · Caelan
> Why?

**KN_DRY_25** · The Knight
> Because the count needed a number.

**KN_DRY_26** · Kael
> Where does the passage go?

**KN_DRY_27** · The Knight
> Down.

**KN_DRY_28** · Sera
> We can follow.

**KN_DRY_29** · The Knight
> No. You can't.

**KN_DRY_30** · NARRATION
> He walks into the flooded passage. The water takes him without a ripple.
> The lamp on the bench is still cold.

**KN_DRY_31** · Kael
> Wait—

**KN_DRY_32** · NARRATION
> The passage is empty. The water is still.

[STAGE] Sets `ch13_knight_gone`.

**KN_DRY_33** · Sera
> He didn't even get wet.

**KN_DRY_34** · Caelan
> He did. The water didn't.

**KN_DRY_35** · Taren
> That's not possible.

**KN_DRY_36** · Caelan
> No.

**KN_DRY_37** · Kael
> He said eleven went.

**KN_DRY_38** · Caelan
> And ten came back wrong.

**KN_DRY_39** · Lyra
> And he's not the wrong one.

**KN_DRY_40** · Taren
> We don't know what that means.

**KN_DRY_41** · Kael
> We know he's been ahead of us since Greyhaven.

**KN_DRY_42** · Sera
> And he still hasn't blocked the way.

**KN_DRY_43** · NARRATION
> The water in the lower hall moves again. This time it does not stop.

---

## 9. The Leviathan — `LV_INTRO`

[STAGE] The lower hall floods fast. The Leviathan comes up out of the far end: a long, pale beast of shell and weed, older than the room, its eyes like wet slate. It is not a construct. It blocks the stairs. Sets `ch13_leviathan_fight`.

**LV_INTRO_01** · NARRATION
> The water rises out of the lower hall and keeps rising. It is warm. It smells of salt and something older.
> The thing comes up with it.

**LV_INTRO_02** · Lyra
> It's coming.

**LV_INTRO_03** · Caelan
> The passage. Maybe the knight woke it.

**LV_INTRO_04** · Kael
> Or it was always awake.

**LV_INTRO_05** · NARRATION
> It fills the hall. Shell, weed, a long pale body that does not end where a body should. Its eyes are flat and wet and fixed on the stairs.
> It is not a construct. Nothing about it was made.

**LV_INTRO_06** · Sera
> It's not a construct.

**LV_INTRO_07** · Caelan
> No. It's a beast. Older than the room.

**LV_INTRO_08** · Taren
> Then it can die.

**LV_INTRO_09** · Kael
> We need the stairs.

**LV_INTRO_10** · NARRATION
> It blocks the stairs. It does not roar. The water roars for it.

**LV_INTRO_11** · SYSTEM
> The Saltreach Leviathan.

**LV_INTRO_12** · Kael
> Weapons. Now.

[STAGE] Fight: `grp_salt_leviathan`, level 25, two phases, no dialogue. Its second phase is the data's shift: the water goes still, then the tide inside it turns and it rises; `leviathan_tide` hits the whole party. The room floods faster with each surge. No HP, ATK, DEF, XP or gold number is set in this script; the enemy batch and `--act5` simulation own them.

---

## 10. The fight — `LV_FIGHT`

[STAGE] The fight runs in the lower hall and on the stairs. The party has to keep the line above the water. The Leviathan is a beast; it has no lines, no name in the script and no second form beyond the phase shift.

**LV_FIGHT_01** · NARRATION
> The first surge takes the floor out from under them. The second takes the stairs.
> It does not chase. It does not need to. The water does.

**LV_FIGHT_02** · Sera
> It's not angry.

**LV_FIGHT_03** · Caelan
> It's feeding.

**LV_FIGHT_04** · Taren
> Then we're the next course.

**LV_FIGHT_05** · Kael
> Hold the line. Don't let it get above us.

**LV_FIGHT_06** · NARRATION
> Its shell cracks. The water goes still.
> Then the tide inside it turns.

[STAGE] Phase 2: the water goes still, then the Leviathan rises and the room floods faster. It uses `leviathan_tide`. On victory: it sinks; the water pulls back down the stairs; the slates settle. Sets `ch13_leviathan_defeated`.

**LV_FIGHT_07** · NARRATION
> It goes down slowly, the way a wave goes down, and does not come back up.
> The water pulls back down the stairs. The slates settle.

**LV_FIGHT_08** · Sera
> Is it dead?

**LV_FIGHT_09** · Caelan
> It's leaving.

**LV_FIGHT_10** · Taren
> There's a difference?

**LV_FIGHT_11** · Caelan
> There usually is.

**LV_FIGHT_12** · Kael
> We move. The tide's still coming.

---

## 11. What the tide kept — `LV_AFTER`

[STAGE] The lower hall drains enough to cross. The slate midden is exposed: hundreds of blank tablets. The party understands what the toll was feeding. Caelan reads the ship's name from the ledger in the dry air. Sets `ch13_after`.

**LV_AFTER_01** · NARRATION
> The lower hall is a field of slate. The water has pulled back to the far end, and the stones are white where it left them.
> There are no names left on any of them.

**LV_AFTER_02** · Lyra
> The slates.

**LV_AFTER_03** · Caelan
> They're just slate. The names are gone.

**LV_AFTER_04** · Sera
> Then what did it eat?

**LV_AFTER_05** · Caelan
> The same thing the village gave it. The writing.

**LV_AFTER_06** · Taren
> It ate the names.

**LV_AFTER_07** · Caelan
> It ate the slate. The name was the part that mattered to the village.

**LV_AFTER_08** · Kael
> The toll was real. The bargain wasn't.

**LV_AFTER_09** · Caelan
> The bargain was real to them.

**LV_AFTER_10** · Sera
> And now?

**LV_AFTER_11** · Caelan
> Now the village will keep writing names, and the tide will keep taking them, and there'll be nothing at the other end.

**LV_AFTER_12** · Taren
> That's worse.

**LV_AFTER_13** · Kael
> No. It's the truth.

**LV_AFTER_14** · NARRATION
> The water pulls at their boots. The boatman's shout comes down the stair, thin and urgent.

**LV_AFTER_15** · Caelan
> The ledger. The ship's name.

**LV_AFTER_16** · Kael
> You said it was under the stain.

**LV_AFTER_17** · Caelan
> It was. The page has dried. **Patient Crown.**

[STAGE] Sets `ch13_ship_named`, `Q_MF_S4`.

**LV_AFTER_18** · Taren
> The last crossing.

**LV_AFTER_19** · Caelan
> The last entry. Sent. The return column is blank.

**LV_AFTER_20** · Kael
> Where is it?

**LV_AFTER_21** · Caelan
> On the reef. The boatman said there's a hull at low tide.

**LV_AFTER_22** · Lyra
> Of course there is.

**LV_AFTER_23** · NARRATION
> The boatman shouts again. The water is at the second step.

**LV_AFTER_24** · Kael
> Move.

**LV_AFTER_25** · Sera
> The knight said eleven went.

**LV_AFTER_26** · Caelan
> The ship is the last crossing.

**LV_AFTER_27** · Lyra
> And one name on it never came back.

---

## 12. The reef — `CH13_END`

[STAGE] The boat pulls out of the ruin as the tide returns. The reef is still white; beyond it, at the edge of the low water, a hull is visible. Sets `chapter13_complete`.

**CH13_END_01** · NARRATION
> They come out of the ruin with the water at their heels. The boat is where the Fisher left it, turned broadside, oars ready.
> The reef is a white line. Beyond it, a black shape is coming up out of the water.

**CH13_END_02** · Fisher
> You're late.

**CH13_END_03** · Kael
> We're here.

**CH13_END_04** · Fisher
> The tide's turning. The reef'll be under in an hour.

**CH13_END_05** · Caelan
> The wreck. The *Patient Crown*.

**CH13_END_06** · Fisher
> That old thing? It's been on the reef since my father's time.

**CH13_END_07** · Taren
> Can we reach it?

**CH13_END_08** · Fisher
> At low tide. Not after.

**CH13_END_09** · Kael
> Then we go now.

**CH13_END_10** · Sera
> The reef will be under in an hour.

**CH13_END_11** · Caelan
> We can make it.

**CH13_END_12** · Lyra
> The *Patient Crown* has waited this long.

**CH13_END_13** · NARRATION
> The boat turns toward the reef. The hull is low and black and patient, and the name on its bow is still legible.
> **Patient Crown.**

**CH13_END_14** · SYSTEM
> Chapter 13 — What the Tide Kept — Complete.

---

## 13. Cast, flags, encounters and build

| Name | Role | Notes |
|---|---|---|
| The Fisher | Boatman | The Saltreach villager from Chapter 12. Rows the party to the reef and waits outside it. Not named. |
| Maelin Orr | Name on the record | Knight-ordinary, the legible eleventh. Not present; no known relation to the party, Kael's father, Mira or the knight. |
| The Knight | Story character | Waiting in the dry chamber. Speaks; does not fight. Still unnamed, unexplained and unfollowed. |
| The Saltreach Leviathan | Chapter boss | A beast, not a construct or a god. Two phases, no dialogue. It has been living in the drowned lower hall and eating the slate the tide brings. |
| The party | Five, four active | Kael, Taren, Lyra, Caelan, Sera. No recruit. |
| Alden Marr | Off-screen | No scene, letter or message in this chapter. |

| Flag | Set by | Meaning |
|---|---|---|
| `ch13_entered` | Pier entry | Chapter 13 began |
| `ch13_depart` | §1 | The boat left Saltreach |
| `ch13_reef_crossed` | §2 | The party reached the ruin |
| `ch13_ruins_seen` | §2 | The flooded structure seen |
| `ch13_record_seen` | §3 | The record room entered |
| `ch13_list_seen` | §4 | The bronze list found |
| `ch13_name_seen` | §5 | Maelin Orr read |
| `ch13_chisel_seen` | §6 | The chisel and the wax note found |
| `ch13_lower_seen` | §7 | The slate midden seen |
| `ch13_knight_seen` | §8 | The knight met in the dry chamber |
| `ch13_knight_gone` | §8 | The knight left through the flooded passage |
| `ch13_leviathan_fight` | §9 | The fight began |
| `ch13_leviathan_defeated` | §10 | The Leviathan is down |
| `ch13_after` | §11 | The toll's remains understood |
| `ch13_ship_named` | §11 | The *Patient Crown* read from the ledger; `Q_MF_S4` |
| `chapter13_complete` | §12 | Chapter done |

### Encounters and balance

- **No random encounters in `rm_saltreach_pier` or `rm_flooded_ruins`.** The ruin is a timed set-piece; the `drowned_coast` table stays Chapter 12's coast approach. A random fight on the tide clock would punish exploration, not pace it.
- **Boss:** `grp_salt_leviathan` — solo `salt_leviathan`, level 25, two phases, no dialogue. Its second phase uses `leviathan_tide`, the act's all-party tide surge. HP/ATK/DEF, XP and gold are in `scr_enemy_database.gml`; the tuning run is `tools/balance_sim.py --act5`.
- **No knight fight.** He leaves before the Leviathan wakes. The dry chamber is a scene, not an encounter.
- **The Leviathan is a beast.** It has no name in the script, no lines and no bargain. The village's custom is the human shape of the toll; the beast is what the custom fed.

### Build plan

1. **This script** — approved 2026-11-18.
2. **Rooms** — `rm_saltreach_pier` and `rm_flooded_ruins`, blockouts first. The pier is a short stone arm with the boat and the Fisher; the ruin has a dry upper hall, a flooded lower hall, the dry chamber and the lower stair. Marker tables and the overworld `saltreach_pier` / `flooded_ruins` stubs flipped to `status: "built"`.
3. **Dialogue data** — `scr_dialogue_data_ch13` via a new `tools/gen_ch13_dialogue.py`, following the Chapter 10–12 generators. No wiring-only extras are required yet.
4. **Story script** — `scr_ch13_story`: pier, reef, record hall, list, chisel, lower hall, knight, Leviathan gate with retry, aftermath, ship name, return to the boat.
5. **Quests** — `Q_MAIN_FALLEN` S3 at entry, S4 at the ship's name. `Q_SIDE_TOLL` stays complete from Chapter 12; no new side quest.
6. **Art and audio** — the Leviathan's battle sheet is the act's largest art dependency; the pier and ruin are stone-and-water blockouts until a coast tileset exists. `snd_amb_water` runs through the pier and the upper ruin; the lower hall may use the dungeon bed.
7. **Playtest** — last, and only in an IDE.

### Decisions (approved 2026-11-18)

- **The record room is Aethari-built and Crown-used.** Caelan can read the Aethari inscription and the newer bronze; this does not confirm that the drowned civilisation was Aethari. The room is a surviving Aethari structure the Crown found and used at low tide, not a statement about the people who drowned around it.
- **The Aethari inscription is a record-hall text, not a crossing record.** Caelan translates "A record of what the water kept"; the bronze list is the Crown's crossings. The stone is older than the account cut into the bronze.
- **The ten names are unrecoverable.** The cuts are too deep; Caelan explicitly cannot read them. The chapter shows the erasure, not the erased.
- **The legible name is Maelin Orr.** A knight-ordinary, not a known character, not Kael's father, not Mira, not the knight. The name is left by whoever struck the ten; the script does not say why.
- **The wax note says "Ten returned. Strike the names. Keep the count."** It establishes the ten returned and were erased; it does not say what "returned wrong" means. The eleventh's blank return is not explained.
- **The chisel is Crown issue.** The cuts match the tomb's in angle and depth; Caelan can say "same order", not "same hand". The script does not name the office that did the erasing.
- **The Leviathan is a beast.** It is not a god, a construct or a keeper. The village's toll was a custom built around a predator; the predator ate the slate and left the village alone. That is all the chapter confirms.
- **The knight does not fight here.** He speaks, leaves through water the party cannot follow, and is gone before the Leviathan wakes. His line is the outline's line, unchanged.
- **The ship is the *Patient Crown*.** Caelan reads the name from the ledger when the page dries. The name is the hook to Chapter 14; the ledger's last entry is sent, not returned.
- **No new named villagers.** The Fisher is the same role from Chapter 12; the boatman is not a new character.

### Still open

- **Playtest.** The Leviathan's numbers are in the enemy batch and the `--act5` simulation; no battle has been compiled or played.
- **The level cap.** `PARTY_MAX_LEVEL` is still 24; the approved rise to 27 is not applied.
- **Maelin Orr's place in the larger story** is not decided. The name is a thread for a later act, not an answer here.
- **The reason the Crown stopped counting** is left for a later act; this chapter only shows that it did.

### What this chapter must not do

- Let Caelan translate the ten scraped names, or recover them from the bronze.
- Confirm that the drowned civilisation was Aethari; the room's builders are Aethari, the drowned people are not identified.
- Explain what the ten became, what "wrong" means, or why the eleventh was left.
- Name the knight, have him fight here, or let the party follow him through the flooded passage.
- Say Mira crossed the Crownveil, or that Kael's father did.
- Explain the Crownveil, the Ash, Lumen or the Crown Engine.
- Turn the Leviathan into a god, a construct or a willing keeper of a bargain.
- Grade the Chapter 12 slate choice or revisit it; this chapter does not return to the village.
