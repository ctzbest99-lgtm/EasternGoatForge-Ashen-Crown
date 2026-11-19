# ASHEN CROWN — Chapter 8 Script: "The Door in the Wood" (Act III: The Blackwood)

Route: the glade's far edge → `rm_blackwood_doors` (the clearing, the sentinels, the Door Warden) → the doors themselves, and the one thing the act must deliver.

> **Status: BUILT 2026-11-16 from the approved Act III outline, decisions as recommended — not yet individually approved, not played.** Built under the standing instruction to keep building the story. Outline §9 decisions 6, 7 and 9 are implemented as recommended: **the door does not open**, the **Fallen Knight does not appear**, and the act ends at the doors with the act-complete card.
> **Not played.** The clearing is dressed on the placeholder `ts_blackwood` atlas, the sentinels have their own dedicated overworld set, and nothing has been compiled.
> Levels: **20** **[PLACEHOLDER]** — the act's ceiling. This is the chapter the level cap decision is about; see §8.

Source of truth: `STORY_BIBLE.md` and `ACT3_OUTLINE.md` §5. Presentation: FF1-style top-down exploration; menu battles.

## How to read this file (for Coder)

- Every dialogue node has a stable ID: `PREFIX_PLACE_NN`, as with Chapters 1–7.
- Prefixes: `DW_` for the clearing and the Door Warden, `PD_` for the pendant and the doors, `ACT3_` for the act's own beats.
- `NARRATION` = no speaker; `SYSTEM` = UI text; `[STAGE]` = direction, not shown.
- **What this chapter must not do:** answer what the doors want, where Mira is, what the Ash is, or what the Aethari were; let the Warden explain its duty in words; open the door; show the Fallen Knight; end on a cutscene that explains itself.

---

## 0. Quest text

### Main quest — `Q_MAIN_BLACKWOOD` "What the Forest Keeps" (final stages)

| Stage | ID | Objective text | Set when |
|---|---|---|---|
| 5 | `Q_MBW_S5` | "Find the stone doors." | Chapter 8 entry |
| 6 | `Q_MBW_S6` | "Learn what the doors want." | The pendant scene (§3) |

The quest stays open at S6. Act IV's opening stage replaces it; nothing here marks it complete, because the party has learned nothing conclusive.

---

## 1. The clearing — `DW_ARRIVE`

[STAGE] The trees end all at once at a wall of cut stone, and the stone is not a ruin: courses are square, joints are tight, and the leaf litter has been swept from the bottom step by something that is still here. Ward sentinels stand in the litter, upright and untouched by weather. `snd_amb_forest` under the act's boss-ready silence. Sets `ch8_entered`.

**DW_ARRIVE_01** · NARRATION
> The trees stop at a wall of cut stone, and the wall was squared by hand.
> Nothing about it has fallen down in the years since.

**DW_ARRIVE_02** · Caelan
> This is the sanctuary's work at ten times the size.
> Same courses. Same joints. Same hands, a long time apart.

**DW_ARRIVE_03** · Lyra
> There's no lintel, no roof, no gate.
> Walls without a building. Who builds a wall and stops?

**DW_ARRIVE_04** · Sera
> Someone swept the step.
> Look at the litter. It's pushed to the sides, and recently.

**DW_ARRIVE_05** · Kael
> Then we're expected, and we're late.
> Stay off the step until we know what's standing in the leaves.

[STAGE] The sentinels are inspectable and count as the chapter's dungeon-in-miniature warning (§5.1 of the outline). Sets `ch8_sentinels_seen`.

**DW_SENT_01** · Kael
> Standing. Not leaning, not fallen.
> They've been in this litter since before the road and they haven't rotted.

**DW_SENT_02** · Caelan
> They're the same make as the Warden under the sanctuary.
> If they wake, they wake all at once.

**DW_SENT_03** · Taren
> Then we don't touch the step.
> We go around it and we look at the door first.

---

## 2. The Door Warden — `DW_INTRO`

[STAGE] The wall has one opening, and the Warden stands in it: the sanctuary's construct at a scale that makes the shrine's stone face look like a doorstep. It does not speak. Its duty is the same as the sanctuary's and it will not be talked out of it. Fight: `grp_door_warden_boss` (`door_warden_boss` + 2 × `ward_sentinel_late`), boss music, boss bar.

**DW_INTRO_01** · NARRATION
> The opening in the wall is a door's height and the thing standing in it is taller.
> It has been waiting with its hands at its sides.

**DW_INTRO_02** · Caelan
> It's the Warden's make. Older, bigger, and it hasn't been sleeping.
> It's been standing in a doorway for however long this has been shut.

**DW_INTRO_03** · Sera
> Does it talk?

**DW_INTRO_04** · Caelan
> The last one didn't.
> I don't think this one was made for talking.

**DW_INTRO_05** · Kael
> Then we don't ask it anything.
> Weapons out.

[STAGE] The Warden's "voice" is stone and no words are translated anywhere. After victory: `ch8_warden_defeated`, the sentinels fall where they stood, and the doorway is clear.

**DW_AFTER_01** · Taren
> It's down. The ones in the leaves went down with it.
> Same moment. Same everything.

**DW_AFTER_02** · Caelan
> One maker, one order.
> It was never guarding the wall. It was guarding the opening.

**DW_AFTER_03** · Lyra
> Then the opening's ours.
> Nobody's swept the step for us in a while.

**DW_AFTER_04** · Kael
> Kael. — no. Say it plainly: we go in, we look, we come back out.
> Nobody touches the seam.

---

## 3. The doors — `PD_SCENE`

[STAGE] This is the act's beat and the whole reason the chapter exists: the mark on the door is the mark on Mira's pendant, and the pendant answers. The door does **not** open. A seam of light, a sound from the far side, and silence. Chapter 1's ending repeated where the player can finally ask a question about it — and still no answer. Sets `ch8_pendant_answered`, `Q_MBW_S6`, `flag_act3_complete`, `flag_chapter8_complete`.

**PD_SCENE_01** · NARRATION
> The door is two stones tall and one seam wide, and the seam is dark the way a held breath is quiet.

**PD_SCENE_02** · Caelan
> There. On the lintel. The crown around the black sun.
> The Watchtower banner. The basement. The stone at the shrine. All of it, here.

**PD_SCENE_03** · Kael
> Mira's pendant has that mark on it.
> She had it made before any of this.

**PD_SCENE_04** · NARRATION
> The pendant is warm through the cloth before he has it out of his coat.
> It is the first time it has done anything at all.

**PD_SCENE_05** · Sera
> Kael. The seam.

**PD_SCENE_06** · NARRATION
> Light, thin as a hair, runs the height of the seam and stops.
> From the far side, once, something answers — a sound like a word heard through a wall.
> Then nothing. The pendant cools.

**PD_SCENE_07** · Kael
> It knows the mark. It answered the mark.
> It didn't open, and it didn't say her name.

[STAGE] Nobody explains the sound. Caelan offers the only reading the act allows — that the doors were built to be answered from the far side — and no one confirms it.

**PD_SCENE_08** · Caelan
> It answered and it didn't open. That's not a lock refusing a key.
> That's something on the other side saying not yet.

**PD_SCENE_09** · Taren
> Or it's a door that only opens from inside, and whoever's inside is busy.
> I've had that thought for nine chapters. Say it out loud, someone.

**PD_SCENE_10** · Lyra
> Then we find the inside.
> Not today, but we find it.

**PD_SCENE_11** · Kael
> We mark the clearing. We go back to Berrin and we tell him the bowl stays dry.
> Then we find out who built a door and forgot the handle.

---

## 4. The act ends — `ACT3_END`

[STAGE] The act-complete card and the act's handoff line. No act boss beyond the Warden; no Fallen Knight anywhere in the chapter; no cutscene explaining the sound. Sets `flag_act3_complete` (already set in §3) and offers the quiet save prompt, which is silent unless the party is standing in a save room — they are not, and that is deliberate.

**ACT3_END_01** · SYSTEM
> Quest updated: Learn what the doors want.
> Chapter 8 — The Door in the Wood — Complete.

**ACT3_END_02** · SYSTEM
> Act III — The Blackwood — Complete.

**ACT3_END_03** · NARRATION
> The wood is quiet behind them and the seam is dark when they look back.
> Somewhere south, a road that is not a deer trail yet.

---

## 5. Cast and flags

| Name | Role | Notes |
|---|---|---|
| The Door Warden | Chapter boss | The sanctuary construct's older, larger duty. No words. |
| Ward Sentinels | Adds | Two, level 20, already in the data. |
| The doors | The act's question | Mark answers mark. Seam, sound, silence. Never opened. |

| Flag | Set by | Meaning |
|---|---|---|
| `ch8_entered` | Entering `rm_blackwood_doors` | Chapter 8 began |
| `ch8_sentinels_seen` | Inspecting a sentinel | The clearing's guards are known |
| `ch8_warden_defeated` | Boss victory | The doorway is clear |
| `ch8_pendant_answered` | §3 | The pendant has done something |
| `chapter8_complete` / `flag_act3_complete` | §3/§4 | Chapter and act are done |
| `Q_MBW_S5` / `Q_MBW_S6` | Entry / pendant scene | Main quest stages |

---

## 6. Encounters and balance

- **Table:** the `blackwood` table on the approach only; the clearing itself has one scripted fight and no random encounters, so the boss is never walked into tired.
- **Boss:** `grp_door_warden_boss` (already in data): `door_warden_boss` + 2 × `ward_sentinel_late`, simulated at 96% wins, 8.2 rounds, 1.02 deaths, 24% party HP left at level 20 (`ACT3_OUTLINE.md` §7). No changes proposed.
- **Level cap:** this chapter is written for level 20 and `PARTY_MAX_LEVEL` is 20. Nothing here is blocked, but there is nowhere to grow, which is why the outline recommends raising the cap to 24 before Act IV.

---

## 7. Build plan, and what was built

1. **Dialogue data** — `scr_dialogue_data_ch8`. **Done.**
2. **Story script** — `scr_ch8_story`: entry, the sentinels, the Warden gate, the pendant scene and the act card. **Done.**
3. **Rooms** — `rm_blackwood_doors`, on the placeholder `ts_blackwood` atlas, with its marker table. **Done** — this also closes the last Blackwood room reference the validator was reporting.
4. **Art** — Blackwood tileset, the doors as scenery (the act's single most important piece of environment art), the Warden's overworld scale. **Not done.**
5. **Audio** — boss music through the existing battle path; the pendant scene has no cue of its own and should get one. **Partly done.**
6. **Docs/tests** — CHANGELOG, TEST_PLAN, DECISIONS, outline and bible status. **Done.**

**Deviations, recorded rather than hidden:** the pendant scene carries no dedicated sound cue (none exists in the audio set), and the act-complete card reuses the existing chapter/act card path rather than adding a new screen.
