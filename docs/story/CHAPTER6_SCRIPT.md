# ASHEN CROWN — Chapter 6 Script: "The Green Silence" (Act III: The Blackwood)

Route: the Blackwood treeline → `rm_blackwood_deep` (the road under the trees, the burn lines, the first carved stone) → `rm_blackwood_hollow` (Cinderhollow, the burners' hamlet) → the patrol's last camp → the burn line and its keeper → back to Cinderhollow's edge.

> **Status: APPROVED 2026-11-16 — CANON.** The owner approved all eight decisions in §10 as recommended, so this script is canon in the Chapter 1–5 format and the build may proceed. Line-level **[PROPOSED]** tags stay as provenance (they mark what this script invented rather than inherited), not as open questions. The act title, **The Blackwood**, is **[CANON]**; the chapter title *The Green Silence* is **[CANON, approved 2026-11-16]**.
> **Built 2026-11-16, not played.** `rm_blackwood_deep`, `rm_blackwood_hollow`, `scr_ch6_story`, `scr_dialogue_data_ch6` and the chapter's markers now exist; `python3 validate_gamemaker.py` passes and closes one of the unresolved room references (thirteen became twelve). Nothing has been compiled or playtested in GameMaker: the rooms are blockouts on `ts_blackwood`, the wood's own placeholder atlas (`tools/gen_blackwood_tileset.py`), the burners use the placeholder NPC sprite, and TEST_PLAN F16–F28 are unchecked.
> Levels: **18–19** **[PLACEHOLDER]** — the band the `blackwood` encounter table and the Act III enemy batch already assume.
> Chapter 6 is the first of Act III's three chapters: the road ends, the forest's people are met, and the word *tithe* is heard for the first time.

Source of truth: `STORY_BIBLE.md` and the approved `CHAPTER5_SCRIPT.md` handoff. Presentation: FF1-style top-down exploration (confirmed). Battles are presumed FF1-style menu battles (still open).

## How to read this file (for Coder)

- Every dialogue node has a stable ID: `PREFIX_PLACE_NN`, as with Chapters 1–5.
- Prefixes: `BW_` for the wood and its road, `CH_` for Cinderhollow and its people, `PT_` for the patrol's camp, `BH_` for the Burn-Line Hulk.
- Format: `**ID** · Speaker` followed by the dialogue-box text. Each `>` line is one box line: at most 2 lines per box, each under 90 characters. A node with more than 2 lines is several boxes in sequence (each pair of lines is one box).
- `NARRATION` = text with no speaker. `SYSTEM` = tutorial or UI text. `[STAGE]` = direction for Coder and Design, not shown in game.
- Tags: **[CANON]** = from the design doc / `STORY_BIBLE.md`. **[C-confirmed]** = an owner decision already made. **[PROPOSED]** = invented for this draft. **[O]** = an open bible question, untouched.
- Suggested story flags are in `code` font. They are suggestions; Coder should match them to the real project.
- **Naming guide:** the party says **Aethari** in dialogue (learned in Chapter 4). UI, bestiary, item and quest text stay on **Architects**.
- **What this chapter must not do:**
  - Explain the Ash, the forest, the stone doors, the Lost Ones, the Crownveil, Lumen or the Crown Engine **[O]**.
  - Say where Mira is, or confirm she passed the doors **[O]**.
  - Let Cinderhollow know anything the party needs. They are frightened people with a custom, not a lore delivery system.
  - Name or connect the Fallen Knight. He does not appear **[C-confirmed direction, outline decision 7]**.
  - Bring Alden or the split with Taren forward **[O]**.
  - Kill Cinderhollow off for shock value. The hamlet's survival is the act's point.
  - Answer what the tithe buys. Berrin says what they do, never what it earns them.

---

## 0. Quest text

### Main quest: What the Forest Keeps — `Q_MAIN_BLACKWOOD` **[PROPOSED title]**

**Description:** "A sealed order told the garrison to stop looking. Someone is paying to keep this forest quiet."

Chapter 5 closed `Q_MAIN_BEYOND_VEIL` at stage 7 and handed off at the treeline. Chapter 6 opens the Act III quest.

| Stage | ID | Objective text | Set when |
|---|---|---|---|
| 1 | `Q_MBW_S1` | "Follow the Crown's order into the Blackwood." | Chapter 6 entry, after `BG_HANDOFF` |
| 2 | `Q_MBW_S2` | "Find out what Cinderhollow pays, and to whom." | The Burn-Line Hulk dies |

`Q_BV_S7` stays complete. The Act II quest closes rather than growing an eighth stage, so the journal shows a finished act and a new one.

### Side quest hook: The Next Name — `Q_SIDE_TITHE` **[PROPOSED]**

Berrin's household is on this autumn's list. Chapter 6 only plants the hook — the party learns the name and the date; the choice itself is Chapter 7's. The quest does not open here.

---

## 1. The treeline — `BW_HANDOFF`

[STAGE] The chapter opens exactly on Chapter 5's closing shot: the garrison behind, the treeline ahead, `BG_HANDOFF`'s card cleared and `Q_MBW_S1` set. Late afternoon. Late-game party: **Kael, Taren, Lyra, Caelan, Sera** (five, four active — the reserve choice is the player's first in the game). Levels 18–19.

**BW_HANDOFF_01** · Taren
> Road ends here. After this it's deer trails.
> Crown patrols don't walk deer trails.

**BW_HANDOFF_02** · Sera
> They walked this one.
> Someone wanted them to.

**BW_HANDOFF_03** · Lyra
> Then we walk it too, and we don't announce it.
> No torches unless the dark makes us.

**BW_HANDOFF_04** · Kael
> Stay close. If the trees start looking alike,
> say so — that's how it starts.

[STAGE] Crossing into `rm_blackwood_deep` sets `ch6_entered`. **Recommended: no random encounters on the first screen.** The wood should be quiet before it is dangerous; the first fight comes after the carved stone in §2.

---

## 2. Under the canopy — `BW_DEEP`

[STAGE] The road narrows; the light goes wrong. `obj_night_overlay` runs **during the day** here for the first time in the game — dim, not black — and `snd_amb_forest` plays. The screen is built to be walked slowly: three stretches of trees, a stone with a mark on it, and no enemies until the third stretch.

**BW_DEEP_01** · NARRATION
> The road narrows until the trees close over it.
> It is the middle of the afternoon. It is not bright.

**BW_DEEP_02** · Caelan
> Light's coming through the canopy and still landing grey.
> That isn't shade. Shade moves.

**BW_DEEP_03** · Lyra
> Charcoal. Somebody's been burning here, and recently.
> Not a camp — a trade.

[STAGE] The carved stone sits half-buried at the road's edge: a shallow crown around a black sun, cut by hand. It is the same mark as the Watchtower banner, the Basement carvings and Mira's pendant, and the chapter shows it without naming it. Interacting with it is optional and must never be required.

**BW_STONE_01** · Kael
> Same mark. Watchtower, the basement under Greyhaven.
> Now out here, on a stone nobody's read in years.

**BW_STONE_02** · Sera
> It's older than the road.
> The road was built around it.

**BW_STONE_03** · Taren
> Then somebody knew it was here and went to the trouble.
> I hate that.

[STAGE] Past the stone the first encounter group can trigger from the existing `blackwood` table — `shade_stalker` and `lost_one` only. Sets `ch6_stone_seen`. **The moth group and the Warden group belong to Chapter 8**; do not roll them here.

---

## 3. Cinderhollow — `CH_ARRIVE`

[STAGE] A clearing kept clear by burning: eight or nine charcoal burners, low huts, kiln mounds, a burn line of cleared ground around the whole hamlet. No walls and no weapons in sight. They are not hostile and they are not surprised. The hamlet is `rm_blackwood_hollow`; `snd_amb_fire` under the forest bed.

**CH_ARRIVE_01** · NARRATION
> The trees stop. Not cleared — burned back, in a ring,
> and kept that way.

**CH_ARRIVE_02** · Burner
> Crown. You're Crown.
> You're late and you're fewer than last time.

**CH_ARRIVE_03** · Kael
> We're not Crown.
> We're looking for the ones who were.

**CH_ARRIVE_04** · Burner
> Then you're late too.

[STAGE] **Berrin** is the headman: old, deliberate, keeps his hands busy so he does not have to look at anyone. He is the chapter's one real conversation, and the party may leave and return. Sets `ch6_hollow_met`.

**CH_BERRIN_01** · Berrin
> Berrin. I speak for the hollow, such as it is.
> You'll want water. Then you'll want answers.

**CH_BERRIN_02** · Kael
> The patrol that came through here.
> Where did they go?

**CH_BERRIN_03** · Berrin
> Into the wood. Same as the others.
> The forest takes a share. We pay it, and it lets us stay.

**CH_BERRIN_04** · Lyra
> A share of what?

**CH_BERRIN_05** · Berrin
> Of what's owed.
> Ask me a different question.

**CH_BERRIN_06** · Sera
> How long has the Crown been paying it for you?

**CH_BERRIN_07** · Berrin
> Since before me. Since before the road.
> When they stopped, the wood noticed.

[STAGE] Repeat talk, allowed any number of times, one node per visit, in order. Each should add a person rather than a fact.

**CH_TALK_01** · Burner
> Kiln's cold three days. Wet wood.
> You want to be useful, carry something.

**CH_TALK_02** · Burner
> My brother went out for kindling in spring.
> I don't go out for kindling.

**CH_TALK_03** · Child
> Mother says don't go past the burn line.
> Everyone says that. Everyone goes anyway.

[STAGE] Berrin's household is named once, in passing, and the date of the autumn share is mentioned without the party understanding the word yet — this is the `Q_SIDE_TITHE` hook. Sets `ch6_tithe_hook`.

**CH_TITHE_01** · Berrin
> My daughter's name goes down this autumn.
> That's the custom. It's not a thing you argue with.

**CH_TITHE_02** · Kael
> Goes down where?

**CH_TITHE_03** · Berrin
> Where it goes.
> You'll want the camp. East, past the second burn line.

---

## 4. The patrol's last camp — `PT_CAMP`

[STAGE] A Crown camp that was never struck: two tents, a cold fire, bedrolls, and no bodies. The armour is stacked, not scattered. On the table, a Crown notice with a seal that is not the Crown's, broken open. This is where the order's origin is *noticed*, not explained — the party already read the order in Chapter 5.

**PT_CAMP_01** · NARRATION
> Two tents. A fire gone cold in the night, not the rain.
> The bedrolls are rolled.

**PT_CAMP_02** · Taren
> Armour's stacked. Boots are lined up.
> Nobody dies that tidy.

**PT_CAMP_03** · Caelan
> They undressed. Or they were undressed.
> Either way they went without a fight.

**PT_CAMP_04** · Sera
> The notice. Same seal as the one at the garrison.
> Not the Crown's. Broken from the inside.

**PT_CAMP_05** · Lyra
> So whoever wrote it wanted the patrol to stop looking.
> And the patrol opened it anyway.

**PT_CAMP_06** · Kael
> Take it. We'll want it when we find who sealed it.

[STAGE] Interacting with the notice sets `ch6_seal_seen` and gives the player the item `Broken Order` (key item, no mechanical effect). Sets `ch6_camp_found`. Leaving the camp east leads to the burn line.

---

## 5. The burn line — `BH_FIGHT`

[STAGE] The third burn line is the widest, and the keeper of it is a **Briar Hulk** grown into the clearing's edge: a mass of thorn and root the burners have been feeding by burning back everything else. It is a beast, not a person, and nothing is learned from killing it. Boss fight, `burn_line_hulk` in the existing `grp_burn_line_hulk` group (Hulk + 1 Shade Stalker). No dialogue from the creature.

**BH_INTRO_01** · NARRATION
> The burn line ends at a wall of thorn that is not a wall.
> It is breathing.

**BH_INTRO_02** · Caelan
> That's not a hedge. That's a thing that grew into one.
> It's been fed.

**BH_INTRO_03** · Kael
> Then we cut it back.

[STAGE] After victory: `ch6_hulk_defeated`, then `Q_MBW_S2` set. The thorn does not burn and does not bleed; the burners will not come near it. Boss music (`snd_mus_boss`) and the boss-bar presentation already used in Chapters 1–5.

**BH_AFTER_01** · Taren
> Dead. Nothing behind it but more trees.
> Whatever it was guarding, it wasn't guarding that.

**BH_AFTER_02** · Lyra
> Berrin knew it was here. He sent us east.
> He wanted it gone and wouldn't say so.

---

## 6. The share — `CH_FEED`

[STAGE] Back at Cinderhollow. Berrin is waiting, and this is the chapter's last beat: he says the thing he has been avoiding since the first conversation. He does not explain it, and the party does not get to resolve it here.

**CH_FEED_01** · Berrin
> You killed it. Good.
> It'll grow back before the frost.

**CH_FEED_02** · Kael
> You could have told us what it was.

**CH_FEED_03** · Berrin
> I could have.

**CH_FEED_04** · Berrin
> You asked what we pay. I'll tell you, and then you'll go.
> We don't pay it. We feed it.

**CH_FEED_05** · Sera
> Feed it what?

**CH_FEED_06** · Berrin
> The shrine's under the roots, south of here.
> Go and look. I won't stop you and I won't come.

[STAGE] `ch6_feed_revealed`. The chapter ends here: Berrin turns back to his kiln, the forest ambience rises, and the screen fades on the treeline path south. No act-complete card — that belongs to Chapter 8. Handoff text: `Q_MBW_S2` remains active with its objective reworded to "Find the shrine under the roots." (Chapter 7's opening replaces the stage.)

**CH_END_01** · NARRATION
> Berrin goes back to his kiln. The hollow goes quiet behind you.
> South, the trees are older.

---

## 7. Cast, flags and items

| Name | Role | Notes |
|---|---|---|
| Berrin **[PROPOSED]** | Cinderhollow's headman | Old, deliberate, keeps his hands busy. Not a villain, not a guide. |
| Burners (3 speaking) **[PROPOSED]** | Hamlet | Frightened people with a trade and a custom. |
| A child **[PROPOSED]** | Hamlet | One line, the burn line. |
| Briar Hulk | Chapter boss | A beast. No dialogue, no motive. |
| The patrol | Absent | Armour, boots, a bedroll and a notice. No bodies, ever. |

| Flag | Set by | Meaning |
|---|---|---|
| `ch6_entered` | Crossing into `rm_blackwood_deep` | Chapter 6 began |
| `ch6_stone_seen` | Reading the carved stone (optional) | The mark has been seen out here |
| `ch6_hollow_met` | First Berrin conversation | Cinderhollow is known |
| `ch6_tithe_hook` | Berrin's household line | The side quest is planted |
| `ch6_seal_seen` | The camp notice | The broken seal is in hand |
| `ch6_camp_found` | Entering the camp | The patrol's fate is known |
| `ch6_hulk_defeated` | Boss victory | The burn line is clear |
| `ch6_feed_revealed` | Berrin's last scene | The word *feed* has been said |
| `Q_MBW_S1` / `Q_MBW_S2` | Entry / boss victory | Main quest stages |

**Item:** `Broken Order` — key item, no mechanical effect, description "A Crown notice with a seal that is not the Crown's. Opened from the inside." **[PROPOSED]**

---

## 8. Encounters and balance

- **Table:** the existing `blackwood` table, unmodified, levels 18–20.
- **Allowed groups in this chapter:** `shade_stalker`, `lost_one`, `lost_one` + `briar_hulk`, `shade_stalker` + `briar_hulk`. **Not allowed here:** `night_moth_swarm` (Chapter 7's night) and anything naming `door_warden` (Chapter 8).
- **Boss:** `grp_burn_line_hulk` — `burn_line_hulk` + 1 × `shade_stalker`, already in the data and simulated at **100% win, 7.6 rounds, 0.44 deaths, 42% party HP left** for a party of four at 18–19 (`ACT3_OUTLINE.md` §7). No changes proposed to those numbers.
- **Level cap blocker:** the chapter is written for 18–19 and `PARTY_MAX_LEVEL` is 20, so nothing here is blocked by the cap; Chapters 7–8 and Act IV are (outline decision 9).
- Nothing in this chapter has been simulated as a *chapter* — only the boss fight, in isolation.

---

## 9. Build plan for this chapter

1. **Dialogue data** — `scr_dialogue_data_ch6`, nodes exactly as above (`BW_*`, `CH_*`, `PT_*`, `BH_*`).
2. **Story script** — `scr_ch6_story`: entry after `BG_HANDOFF`, the camp, the boss gate, Berrin's last scene, and the south path.
3. **Rooms** — `rm_blackwood_deep` and `rm_blackwood_hollow` as blockouts on `ts_blackwood`, the wood's own placeholder atlas (rows 0–49 are `ts_zone1`, rows 50–64 are the dark material), markers for the treeline, the carved stone, the camp and the burn line.
4. **Art** — Blackwood art (a placeholder `ts_blackwood` atlas exists; Design's real tileset is still the act's largest art debt); 16×24 overworld sets for `shade_stalker`, `lost_one`, `briar_hulk`; the carved stone as scenery; the briar wall.
5. **Audio** — `snd_amb_forest` on entry, `snd_amb_fire` in the hollow, `snd_mus_boss` for the Hulk.
6. **Docs/tests** — CHANGELOG, TEST_PLAN rows, DECISIONS entry, and this file's status header once approved.

**Built 2026-11-16:** 1–3 are done (`scr_dialogue_data_ch6` 51 nodes; `scr_ch6_story`; both rooms plus `scr_ch6_markers_data`). 4 is untouched — both rooms are `ts_wrenfield` blockouts and the burners use `spr_story_npc_placeholder`. 5 is half done: `snd_amb_forest` and `snd_amb_fire` are wired through `scr_audio_room_enter`; the Hulk's boss music and bar come from the existing battle path. 6 is done except the rows themselves: TEST_PLAN F16–F28 are unchecked because nothing has been played. One deliberate deviation: `Q_MBW_S2`'s objective is not reworded at the chapter's end (see `DECISIONS_AND_OPEN_QUESTIONS.md` §"Chapter 6 built").

---

## 10. Decisions (approved 2026-11-16)

All eight were approved as recommended by the owner on 2026-11-16; the text below is kept as the record of what was decided and why.

1. **Chapter title *The Green Silence*** — *Recommended: keep.* Alternatives: *The Burn Line*, *Cinderhollow*.
2. **Cinderhollow and the burners exist at all** — *Recommended: keep.* They give the act a human face and the moral question in Chapter 7 without touching canon.
3. **Berrin** as headman and the chapter's single real conversation — *Recommended: keep.* Alternative: a nameless elder, which loses the repeat-talk relationship.
4. **The patrol's fate:** armour stacked, boots lined, no bodies, ever — *Recommended: keep.* It is the chapter's horror and it must not be explained in Act III.
5. **The broken seal is noticed here, not decoded** — *Recommended: keep.* Chapter 5 already established the order; Chapter 6 only shows the patrol opened it from the inside.
6. **The Briar Hulk is a beast with no dialogue or motive** — *Recommended: keep.* Nothing is learned from the fight; the chapter's information comes from people.
7. **The chapter ends on the word *feed*, with no act card** — *Recommended: keep.* The act card belongs to Chapter 8, as Act II's did to Chapter 5.
8. **The side quest's hook appears here but does not open** — *Recommended: keep.* The choice (pay with a stranger, or refuse and lose a villager) is Chapter 7's, per outline decision 8.
