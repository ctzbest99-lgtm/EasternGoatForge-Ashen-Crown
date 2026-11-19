# ASHEN CROWN — Chapter 10 Script: "The Barrow Road" (Act IV: The Forgotten King)

Route: out of Coleford's south track → the maintained road the survey paid for → **`rm_barrow_gate`**, the gatehouse in the hillside where the road stops being a road → the gate itself, and the thing the Crown built to keep it shut.

> **Status: BUILT 2026-11-16 from the approved Act IV outline — not individually approved, not played.**
> Built: `scr_dialogue_data_ch10` (48 nodes: 44 scripted + 4 wiring-only), `scr_ch10_story` (entry, the survey post, the gatehouse scene, the Warden gate with retry, the aftermath, the chapter end), `rm_barrow_gate` (28×20, on the `ts_barrow` crypt atlas, 34 rooms total), `scr_build_barrow_gate`, `scr_ch10_markers_data`, `Q_MAIN_CROWN` stages S3–S4 (S5–S6 defined for Chapter 11), and the wiring into the dialogue chain, the battle-finish hook, the controller's step and room-start hooks, the exit script and the audio set. `rm_barrow_gate` and `rm_barrow_halls` (Chapter 11) are built; the only unresolved references are Acts V–VIII.
> **Alden is not a battle ally.** The battle system has no ally slot, so his part in the Warden fight is scripted — he holds the outer gate and is still standing when it is over. This is the one place the approved decision ("fights beside the party") is only partly implemented, and it is recorded rather than dressed up.
> **Not played.** The gatehouse now builds on the `ts_barrow` crypt atlas (unseen in an IDE), the Warden reuses the sanctuary construct's strips, and Alden has a dedicated set and portraits but no battle strips. Level band **22** [PROPOSED, the middle of Act IV's 21–23].

Source of truth: `STORY_BIBLE.md` and `ACT4_OUTLINE.md` §4. Presentation: FF1-style top-down exploration; menu battles.

## How to read this file (for Coder)

- Prefixes: `RG_` for the road and the gatehouse, `SP_` for the survey marker, `BW_` for the Barrow Warden and its aftermath, `AD_` for Alden on the road, `CH10_` for the chapter's own beats.
- Format: `**ID** · Speaker`, each `>` line one box line. `NARRATION` = no speaker; `SYSTEM` = UI; `[STAGE]` = direction, not shown.
- **What this chapter must not do:** say who built the gate or why; let the Warden speak; open the tomb; name the Forgotten King; explain the marks on the gate; let Alden's sincerity curdle on screen; bring in the Fallen Knight; show King Aldric IV.

---

## 0. Quest text

### Main quest — `Q_MAIN_CROWN` "The King Who Was Forgotten" (continued)

| Stage | ID | Objective text | Set when |
|---|---|---|---|
| 3 | `Q_MC_S3` | "Get past the barrow's warden." | Chapter 10 entry |
| 4 | `Q_MC_S4` | "Open the tomb of the forgotten king." | Warden defeated |

Stages 5–6 (`Q_MC_S5`, `Q_MC_S6`) are Chapter 11's and are already in `scr_quest_data.gml` so the journal never has a gap.

---

## 1. The road the survey paid for — `RG_ARRIVE`

[STAGE] South of Coleford the track stops being graded and then, half a mile later, starts being graded again: gravel, drainage ditches, a culvert. Nobody farms here. `snd_amb_wind` under the overworld bed. Alden rides with them and is enjoying himself, which the chapter lets him do. Sets `ch10_entered`, `Q_MC_S3`.

**RG_ARRIVE_01** · NARRATION
> The track loses its gravel, and then a mile later it has gravel again.
> Cut stone in the ditch, laid to drain. Somebody maintains this.

**RG_ARRIVE_02** · Lyra
> That's not a farmer's work. That's a road gang's work.
> Paid, and paid regularly, for a long time.

**RG_ARRIVE_03** · Caelan
> "Maintained. Item not assessed."
> This is what the money bought. A road to something they would not write down.

**RG_ARRIVE_04** · Alden
> I've been reading that page every night since Coleford, and I keep arriving at the same place.
> Somebody in the Crown has been paying for this road out of a budget nobody audits.

**RG_ARRIVE_05** · Taren
> You say that like it's a revelation. I've been saying it since the ledger.

**RG_ARRIVE_06** · Alden
> You've been saying it with your arms crossed. I've been saying it with a map.
> It's the same sentence. Mine travels better.

**RG_ARRIVE_07** · Sera
> Both of you stop. Look at the hill.

### 1.1 The survey marker — `SP_POST` (optional)

[STAGE] A stone post at the roadside, the Crown's survey mark cut into it and the year worn down to a shape. Inspecting sets `ch10_post_seen`. No quest stage.

**SP_POST_01** · NARRATION
> A squat stone post, cut with the Crown's survey mark. The year has worn to a shape.
> There is a second mark under it, older, chiselled flat.

**SP_POST_02** · Caelan
> They cut the old mark off and put theirs on top.
> That's not a survey. That's a correction.

**SP_POST_03** · Taren
> Same hand as the ledger page. Same habit.
> Somebody in this kingdom has been very busy with a chisel.

---

## 2. The gatehouse — `RG_GATE`

[STAGE] The road runs into a hillside and stops at a gatehouse: two square towers, a lintel, and an iron gate across the road, shut. The stone is old. The iron is not — it has been replaced, at least once, and recently enough that the hinges are clean. Above the arch, the same shallow crown-around-a-black-sun the party has seen on the Watchtower banner, the Basement carvings, Mira's pendant and the doors. Sets `ch10_gate_seen`.

**RG_GATE_01** · NARRATION
> The road ends at a gatehouse built into the hill. Two towers, a lintel, and an iron gate across the road.
> The stone is older than the Crown. The iron is newer than the Crown.

**RG_GATE_02** · Caelan
> The gate's been replaced. Twice, by the look of the hinge seats.
> The gatehouse has been here since before there was a kingdom to pay for it.

**RG_GATE_03** · Sera
> And above the arch.

**RG_GATE_04** · NARRATION
> Cut into the lintel: a shallow crown, ringing a black sun.
> The same mark as the banner, the carvings under Greyhaven, the pendant, and the doors.

**RG_GATE_05** · Kael
> Fourth time. Fifth. Nobody has explained it once.

**RG_GATE_06** · Alden
> I've seen it on a hundred banners and never once looked at it.
> That's the trick, isn't it. Put a thing on everything and nobody sees it.

**RG_GATE_07** · Lyra
> The gate's shut from this side. Bolted, not locked.

**RG_GATE_08** · Taren
> Then somebody's inside.

**RG_GATE_09** · Caelan
> Or something is, and it's been bolting the door every night for a hundred years.
> Alden. You wanted a reason. This is what one looks like.

**RG_GATE_10** · Alden
> I wanted a reason. I didn't say I wanted it to be a door with something behind it.
> Open it.

[STAGE] Opening the gate is not a puzzle and has no check: the party lifts the bar. The moment the bar comes off, the Warden wakes.

---

## 3. The Barrow Warden — `BW_INTRO`

[STAGE] The Warden is Crown oath-work, not Aethari: a thing of iron plates and bound oath, the shape the Door Warden had but the make of a later hand. It has no language, no face, and no interest in the party beyond the gate. Fight: `grp_barrow_warden` (`barrow_warden`, level 22, 1701 HP, two phases, DEF +20% and ATK +15% at the shift). Boss music and boss bar. Sets `ch10_warden_fight`.

**BW_INTRO_01** · NARRATION
> The bar comes off and hits the road.
> Inside the gatehouse, something iron takes a step.

**BW_INTRO_02** · Caelan
> That's not Aethari work. Look at the plates — riveted, replaceable.
> This was built to be maintained.

**BW_INTRO_03** · Sera
> By the same budget as the road.

**BW_INTRO_04** · NARRATION
> It comes out of the arch at a walking pace: a head taller than Taren, plated in iron, and where a face should be there is a plate with the crown-and-sun struck into it.

**BW_INTRO_05** · Taren
> It's not going to talk.

**BW_INTRO_06** · Kael
> No. Alden — the outer gate. Hold it, and don't be a hero.

**BW_INTRO_07** · Alden
> I've never been a hero. I've been reliable. There's a difference, and it's the only thing I've got.

[STAGE] Boss bar: **the Barrow Warden**. The only sound it makes is the shift itself: the plating along its arm splits and folds back over itself, and underneath there is more iron. It was built to be repaired, and it has been. (That beat is the data's `phase2_line`, so it is shown by the battle system rather than queued as dialogue.)

[STAGE] On victory: `ch10_warden_defeated`, `Q_MC_S4`, and the gate stands open. Alden is where he was told to stand.

**BW_AFTER_01** · NARRATION
> The Warden comes apart the way a wall comes apart: in pieces, all at once, and then it is rubble with a sword in it.
> Behind it, the gate is open. The road goes on into the hill.

**BW_AFTER_02** · Alden
> I held the gate.

**BW_AFTER_03** · Lyra
> You held the gate.

**BW_AFTER_04** · Alden
> I'd like that recorded. Somewhere. In one of your ledgers.

**BW_AFTER_05** · Taren
> You all right?

**BW_AFTER_06** · Alden
> No. I've just watched a thing made of iron and promises get up off the ground twice.
> I'm going to need a minute, and then I'm going to want to know who wrote the promises.

**BW_AFTER_07** · Caelan
> That's the right question. It's also the one nobody in this kingdom has been allowed to ask.

**BW_AFTER_08** · Sera
> Then we ask it inside.

---

## 4. What the gate was for — `CH10_END`

[STAGE] The road beyond the gate, seen from the threshold: cut steps going down, and air moving up out of the hill, cold and dry. The chapter does not enter the tomb. `rm_barrow_halls` is Chapter 11's room. Sets `chapter10_complete`.

**CH10_END_01** · NARRATION
> Past the gate the road becomes steps, cut down into the hill.
> The air coming up them is cold, dry, and moving.

**CH10_END_02** · Caelan
> Ventilation. Somebody built this to be breathed in.
> Tombs don't need air. This isn't only a tomb.

**CH10_END_03** · Lyra
> Then what is it?

**CH10_END_04** · Caelan
> A place somebody expected to come back from.

**CH10_END_05** · Alden
> The page said "the fifth holding". No name, no tax line, no road on any map.
> We're standing on the road. There's a holding under it.

**CH10_END_06** · Taren
> And the Crown's been paying to keep the door shut and the air moving.
> For a hundred years. For a thing it won't write down.

**CH10_END_07** · Sera
> Whatever's down there, it was important enough to guard and shameful enough to forget.
> Both. At once. That's what we're walking into.

**CH10_END_08** · Kael
> Then we walk in rested, with everything we brought, and we don't split up.
> Alden, stay behind Caelan. You're not the only one who wants to ask the question, and I'd like us all to get to ask it.

**CH10_END_09** · SYSTEM
> Quest updated: Open the tomb of the forgotten king.
> Chapter 10 — The Barrow Road — Complete.

---

## 5. Cast and flags

| Name | Role | Notes |
|---|---|---|
| The Barrow Warden | Chapter boss | Crown oath-work, no language, no face beyond the struck plate. Two phases. |
| Alden Marr | Companion, not a party member | Holds the outer gate. Sincere, useful, and the first to say the promises need a name. |
| The gatehouse | The chapter's answer | Old stone, replaced iron, the mark above the arch. Not explained. |

| Flag | Set by | Meaning |
|---|---|---|
| `ch10_entered` | Entering `rm_barrow_gate` | Chapter 10 began |
| `ch10_post_seen` | §1.1 | The overwritten survey mark is known |
| `ch10_gate_seen` | §2 | The gatehouse and the mark are known |
| `ch10_warden_fight` | §3 | The fight happened |
| `ch10_boss_cool` | A lost fight | The gate re-arms once the party steps back |
| `ch10_warden_defeated` | Boss victory | The gate is open |
| `chapter10_complete` | §4 | Chapter done |
| `Q_MC_S3` / `Q_MC_S4` | Entry / boss victory | Main quest stages |

---

## 6. Encounters and balance

- **Table:** `crown_barrow` (21–23) on the road approach. Chapter 10 runs at 22, so the road rolls `oath_iron` + `barrow_husk` and the moth group rather than the level-21 town groups. The gatehouse forecourt has no random encounters.
- **Boss:** `grp_barrow_warden` — solo `barrow_warden` (1701 HP, 59 ATK, 42 DEF, lightning-weak, two phases with DEF +20% / ATK +15% at the shift). Simulated at level 22: **100% wins in 7.4 rounds with 0.54 deaths (+Caelan)** and **98% in 9.9 rounds with 0.46 deaths (+Sera)**, 45–47% party HP left. At level 23 it is 7.1–9.5 rounds. The fight is meant to be long rather than lethal.
- **Alden is not in the battle.** No ally slot exists; his participation is the scene and the aftermath.
- **Simulation is a model, not a playtest.** Nothing here has been compiled or run in an IDE.

---

## 7. Build plan, and what was built

1. **This script** — done 2026-11-16.
2. **Dialogue data** — `scr_dialogue_data_ch10`, generated by `tools/gen_ch10_dialogue.py` from this file. **Done** (48 nodes: 44 scripted + 4 wiring-only).
3. **Story script** — `scr_ch10_story`: entry, the post, the gate scene, the Warden gate and its retry, the aftermath, the chapter end. **Done.**
4. **Room** — `rm_barrow_gate`, 28×20 on `ts_barrow` via `tools/gen_ch10_rooms.py`, closing the reference Chapter 9 introduced. **Done.**
5. **Quests** — `Q_MC_S3` on entry, `Q_MC_S4` on victory, with S5–S6 already defined for Chapter 11. **Done.**
6. **Art** — a barrow/hillside tileset and the Warden's own strips (it borrows the sanctuary construct's). Alden's sprite is still missing. **Not done.**
7. **Audio** — `wind` for the road and the gatehouse; the tomb proper needs a dungeon bed in Chapter 11. **Partly done.**

**Deviations, recorded rather than hidden:** Alden does not occupy a battle slot, and the Warden's "physical resistance in its second phase" from the outline is implemented as a DEF buff because the battle system has no damage-type resistance.
