# ASHEN CROWN — Chapter 7 Script: "The Share" (Act III: The Blackwood)

Route: the burn line's far side → `rm_blackwood_shrine` (the shrine under the roots, the basin, the Lost Ones) → `rm_blackwood_glade` (the Matriarch's clearing) → the far edge of the glade, where the doors show through the trees.

> **Status: BUILT 2026-11-16 from the approved Act III outline, decisions as recommended — not yet individually approved, not played.** Built under the standing instruction to keep building the acts and chapters. The outline's §9 decisions 4–8 are implemented as recommended: the tithe stays unresolved, the Matriarch holds the glade, the door is not opened here, the Fallen Knight does not appear, and the side quest offers both choices with no correct answer.
> **Not played.** `rm_blackwood_shrine` and `rm_blackwood_glade` are Wrenfield blockouts, the Lost Ones use the placeholder NPC sprite, and nothing has been compiled.
> Levels: **19–20** **[PLACEHOLDER]** — the top of the act's band (`blackwood`, 18–20).

Source of truth: `STORY_BIBLE.md` and `ACT3_OUTLINE.md` §4. Presentation: FF1-style top-down exploration; menu battles.

## How to read this file (for Coder)

- Every dialogue node has a stable ID: `PREFIX_PLACE_NN`, as with Chapters 1–6.
- Prefixes: `SH_` for the shrine under the roots, `LT_` for the Lost Ones, `TT_` for the tithe and the side quest, `GL_` for the glade, `MT_` for the Blackwood Matriarch, `CH7_` for the chapter's own beats.
- Format: `**ID** · Speaker`, each `>` line one box line.
- `NARRATION` = no speaker; `SYSTEM` = UI or tutorial text; `[STAGE]` = direction, not shown.
- **What this chapter must not do:** say who or what the Matriarch serves; confirm the Lost Ones are Ash-touched; resolve whether the tithe ever worked; let the Matriarch or the Lost Ones explain the tithe's origin; say where Mira is.

---

## 0. Quest text

### Main quest — `Q_MAIN_BLACKWOOD` "What the Forest Keeps" (continued)

| Stage | ID | Objective text | Set when |
|---|---|---|---|
| 3 | `Q_MBW_S3` | "Reach the shrine under the roots." | Chapter 7 entry (Berrin's "south of here") |
| 4 | `Q_MBW_S4` | "Face what holds the glade." | Chapter 7 boss defeated |

### Side quest — `Q_SIDE_TITHE` "The Next Name" **[PROPOSED]**

Opens in §2 and closes in the same scene. Reward on the second choice: 120 Gold and a Cinderhollow Charm (accessory, DEF +2) **[PLACEHOLDER]**. Neither choice touches the main quest.

| Stage | ID | Objective text | Set when |
|---|---|---|---|
| 1 | `Q_ST_S1` | "Berrin's household is on this autumn's list." | §2 opens (after `ch6_tithe_hook`) |
| 2 | `Q_ST_S2` | "Decide what to tell Berrin." | §2 choice |

---

## 1. The shrine under the roots — `SH_ARRIVE`

[STAGE] South of the burn line, past trees older than the road. The shrine is Aethari work: a low stone face, a dry basin, and the shallow crown around a black sun cut into the lintel — the mark from the Watchtower banner, the basement under Greyhaven and Mira's pendant. The party has seen it four times now. Nobody names it. `snd_amb_night` plays here for the first time in the act, under `snd_amb_forest`. Sets `ch7_entered`.

**SH_ARRIVE_01** · NARRATION
> The roots give way to a stone face that was cut, not grown.
> A basin in front of it, dry, and older than the trees around it.

**SH_ARRIVE_02** · Caelan
> Aethari. Same hand as the sanctuary, older work.
> They built this to be used, not admired.

**SH_ARRIVE_03** · Lyra
> Used for what? There's no door.
> Just a bowl and a wall.

**SH_ARRIVE_04** · Taren
> Bowl's for something going in.
> I've been in enough cells to know where this is going.

**SH_ARRIVE_05** · Kael
> Spread out. Don't touch the basin until we know what it holds.

[STAGE] The basin is inspectable (§1.1) and never required. Sets `ch7_basin_seen`.

**SH_BASIN_01** · Kael
> Dry. Not rained in, not cracked.
> Something takes what goes in here and doesn't leave a stain.

**SH_BASIN_02** · Sera
> There's a lip worn into the stone on this side.
> People stood here. A lot of people. For a long time.

**SH_BASIN_03** · Lyra
> Then they stopped.
> Berrin's patrols stopped. The wood noticed the difference.

---

## 2. The tithe, said plainly — `TT_MEET`

[STAGE] Berrin is waiting where the trees start, having followed them despite what he said at the kiln. He does not come closer to the shrine. This is the side quest's scene: his daughter's name is on this autumn's list, and the party has now seen the basin. Both options are open and neither is marked as right. Sets `ch7_tithe_open`, opens `Q_SIDE_TITHE` at `Q_ST_S1`.

**TT_MEET_01** · Berrin
> I said I wouldn't come. I came as far as the trees.
> That's as far as I've come in forty years.

**TT_MEET_02** · Kael
> Your daughter's name goes down this autumn.

**TT_MEET_03** · Berrin
> It does.
> You've seen the bowl. Now you know what "down" means.

**TT_MEET_04** · Sera
> And the ones who went before her are still walking.

**TT_MEET_05** · Berrin
> Yes.
> That's the custom. It's not a thing you argue with.

**TT_MEET_06** · Taren
> It's a thing you can argue with. I'm arguing with it now.

[STAGE] The choice. Two options, no third, and the scene does not tell the player which is kind. Wording is the player's reply.

**TT_CHOICE_01** · Kael
> Your call, Berrin. Say it and we'll do it.
> Or say nothing and we'll go on and leave you to it.

---

### 2.1 If the player says "Don't pay it. Let the wood go hungry." — `TT_REFUSE`

[STAGE] Sets `ch7_tithe_refused`, `Q_SIDE_TITHE` to "complete". No reward. Berrin does not thank them. A line later in the act refers to the household being short a name and the hollow being quieter; there is no named villager to remove, so nothing else changes.

**TT_REFUSE_01** · Kael
> Don't pay it. Let the wood go hungry and see what it does.

**TT_REFUSE_02** · Berrin
> Then you'll have my daughter's name and my house empty.
> You'll have done it from the road, mind. I'll be here.

**TT_REFUSE_03** · Berrin
> Go on to the glade. I'll walk back.
> I'd rather you weren't at my kiln when it gets dark.

---

### 2.2 If the player says "Then choose a name from outside. Someone we bring you." — `TT_PAY`

[STAGE] Sets `ch7_tithe_paid`, `Q_SIDE_TITHE` to "complete", grants 120 Gold and the Cinderhollow Charm. Berrin accepts it the way a man accepts weather. Nothing here says the custom works.

**TT_PAY_01** · Kael
> Then choose a name from outside. Someone we bring you.
> Not your daughter. Not anyone in the hollow.

**TT_PAY_02** · Berrin
> You'd do that.
> You'd bring a stranger to a bowl in the roots and call it mercy.

**TT_PAY_03** · Taren
> I'd call it a choice someone else made for once.
> Take it or leave it, Berrin.

**TT_PAY_04** · Berrin
> Then take this, and don't tell the hollow where it came from.
> It's what we'd have paid a carrier.

---

## 3. The ones who were given — `LT_MEET`

[STAGE] Between the shrine and the glade the Lost Ones are standing in the leaf litter, facing the shrine, not moving. One wears the boots that were lined up neatly at the patrol's camp in Chapter 6 (`PT_CAMP_02`). The party recognizes it and cannot help it. This is the chapter's horror beat and it must stay a fact, not an explanation. Sets `ch7_lost_seen`.

**LT_MEET_01** · NARRATION
> They are standing between the trees, facing the shrine.
> None of them are breathing hard. None of them blink.

**LT_MEET_02** · Caelan
> Six. Seven. More behind them.
> They're not guarding anything. They're waiting.

**LT_MEET_03** · Lyra
> That one. The boots.
> Those are the boots from the camp. Lined up by the bedroll.

**LT_MEET_04** · Taren
> The patrol went in without a fight.
> Now I know why nobody fought.

**LT_MEET_05** · Sera
> They walked here themselves.
> Look at the ground. One set of prints, going in, none coming out.

**LT_MEET_06** · Kael
> We don't touch them.
> Whatever they are now, they were people who paid.

[STAGE] The Lost Ones do not attack unless the party crosses the glade's edge: the encounter zone's `lost_one` groups do the fighting, and killing them is not framed as a mercy anywhere. The chapter must not let the Lost Ones explain anything.

---

## 4. The glade — `GL_ARRIVE`

[STAGE] A clearing the size of the garrison yard, and nothing in it has been burned back — the trees are simply absent, in a ring, the way Cinderhollow is absent of trees by fire. The Matriarch is at the far edge, and the doors show through the gap behind her: two standing stones and a seam of dark, thirty paces apart. The party sees the doors before they fight. Sets `ch7_glade_seen`.

**GL_ARRIVE_01** · NARRATION
> The trees stop, and this time nothing burned them.
> Across the clearing, past the far edge, two stones stand with a dark seam between them.

**GL_ARRIVE_02** · Caelan
> That's not a ruin. That's a door.
> It's been shut since before the road, and it was built shut.

**GL_ARRIVE_03** · Lyra
> Then what's the thing in the middle of the clearing?
> Because it's looking at us.

---

## 5. The Blackwood Matriarch — `MT_INTRO`

[STAGE] The Matriarch is the act's second boss: an old, rooted thing with two phases (`blackwood_matriarch` in the data, `hp_mult: 1.5`, Ash Breath on the whole party, a `trans` shift at half HP). She holds the glade, not the door. She does not explain the tithe, the Lost Ones or herself, and killing her frees nobody — the chapter says so afterwards.

**MT_INTRO_01** · NARRATION
> It is the size of the shrine and it has been here longer than the hollow.
> What looks like bark is a hide, and what looks like a root is an arm.

**MT_INTRO_02** · Caelan
> It's not guarding the door. It's guarding the clearing.
> The burners have been feeding it the same way they fed the hulk.

**MT_INTRO_03** · Sera
> Then it has eaten better than the hollow has.
> Look at it.

**MT_INTRO_04** · Kael
> Weapons out. We're not here for the door yet.
> We're here for the bowl.

**MT_INTRO_05** · NARRATION
> The Matriarch turns, and the clearing is smaller than it was.

[STAGE] Fight: `grp_blackwood_matriarch` (Matriarch + 1 Shade Stalker), boss music and boss bar. Her phase line at the shift is the only thing she "says" — bark, not language; nothing in it is translated.

**MT_PHASE_01** · NARRATION
> The hide splits along the back and something older moves under it.

[STAGE] After victory: `ch7_matriarch_defeated`, `Q_MBW_S4` set. Nothing is freed. The Lost Ones are still standing when the party looks back.

**MT_AFTER_01** · Taren
> It's dead. The ones at the shrine haven't moved.
> Not one of them.

**MT_AFTER_02** · Caelan
> Then it was never holding them.
> It was just the biggest thing in the wood.

**MT_AFTER_03** · Sera
> Berrin said they feed it. He didn't say what it does with what it's fed.
> Now we know: nothing. It just eats.

**MT_AFTER_04** · Kael
> The basin's dry, the patrol's still standing, and the door's still shut.
> Take the measure of it. We're not finishing this today.

---

## 6. The act hands off — `CH7_END`

[STAGE] The chapter ends on the glade's far edge, looking at the doors through the trees — visible, not reached. `rm_blackwood_doors` is Chapter 8's room. Sets `ch7_glade_crossed`, moves `Q_MBW_S5` only in Chapter 8's opening. No act card: that belongs to Chapter 8 (§5 of the outline).

**CH7_END_01** · NARRATION
> The seam between the stones is dark in a way the shade is not.
> From here it looks like a door that was closed from the inside.

**CH7_END_02** · SYSTEM
> Quest updated: Find the stone doors.
> Chapter 7 — The Share — Complete.

---

## 7. Cast and flags

| Name | Role | Notes |
|---|---|---|
| Berrin | Cinderhollow's headman | Follows them as far as the trees, and no further. |
| The Lost Ones | The shrine's doing | Standing, waiting, recognizable. No dialogue, no explanation. |
| The patrol's youngest | One Lost One | Identified by the boots from `PT_CAMP_02`. Never named. |
| The Blackwood Matriarch | Chapter boss | Two phases, no language, guards the clearing. |

| Flag | Set by | Meaning |
|---|---|---|
| `ch7_entered` | Entering `rm_blackwood_shrine` | Chapter 7 began |
| `ch7_basin_seen` | Inspecting the basin | The bowl has been seen |
| `ch7_tithe_open` | §2 scene | The side quest is open |
| `ch7_tithe_refused` / `ch7_tithe_paid` | §2 choice | Which way the tithe went |
| `ch7_lost_seen` | §3 | The Lost Ones are known |
| `ch7_glade_seen` | Entering `rm_blackwood_glade` | The doors are known to be here |
| `ch7_matriarch_defeated` | Boss victory | The glade is clear |
| `ch7_glade_crossed` | §6 | The chapter is over |
| `Q_MBW_S3` / `Q_MBW_S4` | Entry / boss victory | Main quest stages |
| `Q_ST_S1` / `Q_ST_S2` | §2 open / choice | Side quest stages |

**Item:** `item_cinderhollow_charm` — accessory, DEF +2, "A charcoal burner's charm, given quietly and not explained." **[PLACEHOLDER numbers]**

---

## 8. Encounters and balance

- **Table:** `blackwood` (18–20), unmodified. Chapter 7 runs `lost_one` + `briar_hulk` / `shade_stalker` and the `night_moth_swarm` group — the moths are the night's hazard and `snd_amb_night` is theirs.
- **Boss:** `grp_blackwood_matriarch` (already in data): 97% win, 7.3 rounds, 0.77 deaths, 26% party HP left at 19–20 (`ACT3_OUTLINE.md` §7). No changes proposed.
- Nothing in this chapter has been simulated as a chapter, only the boss in isolation.

---

## 9. Build plan, and what was built

1. **Dialogue data** — `scr_dialogue_data_ch7`, nodes as above. **Done.**
2. **Story script** — `scr_ch7_story`: entry, basin, the tithe choice and its two branches, the Lost Ones, the glade and the Matriarch gate. **Done.**
3. **Rooms** — `rm_blackwood_shrine` and `rm_blackwood_glade`, Wrenfield blockouts, plus the marker tables. **Done.**
4. **Art** — Blackwood tileset, the Lost Ones' overworld set, the Matriarch's overworld set, the doors as scenery. **Not done** (unchanged art debt).
5. **Audio** — `snd_amb_night` assigned to the shrine and glade. **Done.**
6. **Docs/tests** — CHANGELOG, TEST_PLAN, DECISIONS, outline status. **Done.**

**Deviations, recorded rather than hidden:** the tithe choice's "loses a Cinderhollow NPC for the rest of the act" consequence has no named villager to remove, so it is a flag and dialogue only; and `Q_MBW_S3` is set on room entry rather than by a cutscene, because Chapter 6 already ends on Berrin's direction.
