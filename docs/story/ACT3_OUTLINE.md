# ASHEN CROWN — Act III Outline: "The Blackwood"

**Studio:** Eastern Goat Forge · **Engine:** GameMaker Studio (GML) · **Genre:** Dark medieval fantasy RPG, classic turn-based combat · **Platform:** PC

**Status: PROPOSED — nothing in this file is canon.** The act title (*The Blackwood*) is **[CANON]**, and the beats it must carry are fixed by `CHAPTER5_SCRIPT.md` and `STORY_BIBLE.md`. Everything else — chapter count, chapter titles, the hamlet, the tithe, bosses, quest text — is an outline for the owner to accept, change or reject. Section 9 lists the ten decisions that need a yes or no.
> **The whole act is built** (2026-11-16): Chapters 6–8 have scripts, dialogue data, story scripts and five rooms, all as Wrenfield blockouts, and **nothing has been compiled or played**. Chapter 6's eight decisions are owner-approved; Chapters 7–8 were built from this outline's recommended decisions under the standing instruction to keep building, and are awaiting individual approval. Every room reference in this outline now resolves.

**Source of canon:** `MASTER_GDD.txt`, `STORY_BIBLE.md`, `CHAPTER5_SCRIPT.md` (approved 2026-11-16). Sibling: `ACT2_OUTLINE.md`.

---

## 0. What is already in the build

Act III is the only act with engine data waiting for it. None of this needs new code to be useful:

| Already present | Where |
|---|---|
| Act III enemies, levels 18–20: `shade_stalker` (18, fast, holy-weak), `briar_hulk` (18, tanky, fire-weak), `lost_one` (18, holy-weak), `night_moth_swarm` (19, fire-weak, blind/sleep), `door_warden` (19 elite, lightning-weak), `blackwood_matriarch` (20 boss, two phases, holy-weak) — plus `ward_sentinel`, `glyph_wisp`, `aethari_automaton` from the Hollow Sanctuary set for the stone doors. The three boss/add ids tuned in §7 are in too: `burn_line_hulk`, `door_warden_boss`, `ward_sentinel_late` | `scr_enemy_database.gml` |
| Encounter table `blackwood`, levels 18–20, five groups, and the three boss groups `grp_burn_line_hulk`, `grp_blackwood_matriarch`, `grp_door_warden_boss` | `scr_encounter_tables.gml` |
| Battle background `spr_bg_battle_blackwood` (320×180) and battle area `blackwood` | `scr_ch1_battle_bg` / `scr_battle_system` |
| Two stub entrances already pointing at Act III rooms: `rm_blackwood_deep` (the Chapter 5 handoff, spawn `from_garrison`) and `rm_blackwood_doors` (an overworld entrance: "Ancient stone doors in the cursed forest") | `scr_ch5_markers_data.gml`, `scr_map_markers_data.gml` |
| `Q_BV_S7` active, the act-complete card, and `BG_HANDOFF` at the treeline | `scr_ch5_story.gml` |
| Forest ambience bed (`snd_amb_forest`) and the unused night bed (`snd_amb_night`) | `scr_audio.gml` |

Not present, and needed: rooms, dialogue data, a story script, a Blackwood tileset, overworld sets for the Act III enemies (all nine are on the art-gap list), and a level cap above 20 (section 8).

---

## 1. Canon anchors: what Act III must satisfy

- **The act is the Blackwood** **[CANON]**: "a cursed forest: missing travelers, strange creatures, ancient stone doors, unnatural darkness, forgotten ruins, connections to Mira's disappearance."
- **The party has a written reason to go.** Chapter 5 ended with a sealed Crown order bearing a **non-Crown seal** telling the garrison to **stop looking** for a missing patrol. The order is the hook: someone outside the Crown's chain is paying to keep this forest quiet **[C-confirmed, Ch5 §14 decision 7]**.
- **The Fallen Knight's warning is the tone line:** *"The forest has already taken its share. It will want another."* **[C-confirmed 2026-11-16]** It is ominous and must stay unexplained.
- **The full five-person roster is available.** Four fight; the first reserve choice the player makes in a chapter (Sera joined last) is now a real decision **[CANON, five-person roster]**.
- **Levels 18–20** **[PLACEHOLDER]** — the band the enemy batch and the `blackwood` table already assume.
- **The mystery holds.** Section 11 lists what Act III cannot resolve. The design rule from the bible: "The story must preserve the mystery of the Crownveil and the Ash."

---

## 2. Shape: three chapters (6–8)

Act I is one chapter; Act II is four (2–5) because it had four recruits. Act III has **no recruits** — the roster is complete — so its length should come from the place, not from party-building. Three chapters give it a beginning (the forest's edge and the people who live under it), a middle (what the forest has been paid), and an end (the doors), and leave Act IV free to open wherever the owner wants.

| Ch | Title **[PROPOSED]** | Rooms | Boss **[PROPOSED]** | Beats |
|---|---|---|---|---|
| 6 | **The Green Silence** | `rm_blackwood_deep`, `rm_blackwood_hollow` | the Burn-Line Hulk (`briar_hulk`, boss-scaled) | the road ends; the charcoal burners' hamlet; the patrol that vanished; the first carved stone |
| 7 | **The Share** | `rm_blackwood_shrine`, `rm_blackwood_glade` | the **Blackwood Matriarch** (`blackwood_matriarch`, existing boss) | who pays the tithe and why; the Lost Ones; the shrine under the roots |
| 8 | **The Door in the Wood** | `rm_blackwood_doors` | the **Door Warden** (`door_warden`, boss-scaled with `ward_sentinel` adds) | the Aethari doors; the pendant answers; a crack, not an answer; handoff to Act IV |

Two of those room names already exist as unresolved references (`rm_blackwood_deep`, `rm_blackwood_doors`), so building them also closes two of the thirteen validator warnings. `rm_blackwood_hollow`, `rm_blackwood_shrine` and `rm_blackwood_glade` are new names.

---

## 3. Chapter 6 — The Green Silence

**Route:** the Garrison road east → the treeline → `rm_blackwood_deep` (the road under the trees, the burn lines, the first carved stone) → `rm_blackwood_hollow` (Cinderhollow, the burners' hamlet) → back into the deep wood.

**What happens (all [PROPOSED]):**
1. The road narrows under the canopy and the light goes wrong — the room is the first place in the game with the **night overlay on during the day** (`obj_night_overlay` already exists; Act III is its natural home). Nothing chases the party yet.
2. **Cinderhollow** is eight or nine charcoal burners living in a clearing they keep clear by burning. They are not hostile, not helpful, and not surprised by the patrols going missing: "The forest takes a share. We pay it and it lets us stay." Their headman — **Berrin** **[PROPOSED]** — will not say what the share *is*, only that it is owed every autumn and that the Crown's patrol stopped paying.
3. The party can find the patrol's last camp: armour, no bodies, and a Crown notice with the **non-Crown seal** broken open. This is where the order's origin is noticed, not explained.
4. The burn lines are held by a **Briar Hulk** that has grown into the clearing's edge — the chapter's boss fight. It is a beast, not a person, and nothing is learned from killing it.
5. The chapter ends when Berrin, after the hulk dies, finally points at the shrine and says the thing he has been avoiding: "We don't pay it. We *feed* it." **[PROPOSED]**

**Encounter table:** the existing `blackwood` table, unmodified. Chapter 6 should run `shade_stalker`/`lost_one` and `lost_one`+`briar_hulk`/`shade_stalker` groups only; the moth group and the Door Warden group belong to Chapter 8's approach.

**What the chapter must not do:** explain the Ash, name what the forest is, connect the door to Mira, or let the burners know anything the party needs. They are frightened people with a custom, not a lore delivery system.

---

## 4. Chapter 7 — The Share

**Route:** `rm_blackwood_shrine` (the shrine under the roots, the pit, the ash) → `rm_blackwood_glade` (the Matriarch's clearing) → the treeline road toward the doors.

**What happens (all [PROPOSED]):**
1. The shrine is Aethari-built and far older than the burners' custom: a stone basin, a carved crown around a black sun (the mark the player already knows from the Watchtower banner, the Basement carvings and Mira's pendant — **shown, not explained**).
2. The **Lost Ones** are the shrine's doing: people the burners "gave", still walking. This is the chapter's horror beat and its moral one. A Lost One that the party recognizes — a name from the missing patrol, or a Cinderhollow face — makes the tithe personal. **[PROPOSED]**
3. The **Blackwood Matriarch** holds the glade. She is Design's proposed boss, already in the data with two phases and a `trans` shift; her phase line and the reason she is here stay vague ("the wood keeps its own"). Killing her does not free the Lost Ones and the chapter says so.
4. The chapter ends with the shrine's basin dry and the doors visible from the glade's far edge: the forest's share was being paid *to* something, and the something is behind the doors.

**Encounter table:** `lost_one` + `briar_hulk`/`shade_stalker`, and `night_moth_swarm` groups; the moths are the night's hazard and this is the first room where night ambience (`snd_amb_night`, currently unused) should play.

**What the chapter must not do:** say who or what the Matriarch serves, confirm the Lost Ones are Ash-touched, or resolve whether the tithe ever worked.

---

## 5. Chapter 8 — The Door in the Wood

**Route:** `rm_blackwood_doors` — the clearing, the doors, the Warden, and the aftermath.

**What happens (all [PROPOSED]):**
1. The clearing is Aethari work at a scale the Hollow Sanctuary only hinted at: a door in a stone face, sealed, with **ward sentinels** standing in the leaf litter. The room is the act's dungeon in miniature: a short approach, two ward encounters, then the door.
2. The **Door Warden** is the guardian the sanctuary's construct implied — same makers, different duty. Fight it with `ward_sentinel` adds (the group already exists in the table as `door_warden` + `night_moth_swarm`; a boss-scaled Warden with two Sentinels is the [PROPOSED] version).
3. **The pendant reacts.** This is the one thing the chapter must deliver: the mark on the door is the mark on the pendant, and the party's own proof that Mira's road went this way. The door does **not** open. A seam of light, a sound from the far side, and it goes quiet — the Chapter 1 ending beat, repeated where the player can finally ask a question about it.
4. **The Fallen Knight does not appear.** He has had his two Act II sightings; Act 5 is titled after him, and spending him here would flatten that. **[PROPOSED — decision 7]**
5. Handoff: the act ends on the doors with a new main-quest stage and the act-complete card, mirroring how Act II ended at the treeline. Act IV opens on the party's decision about what to do with a door they cannot open.

---

## 6. Quests

**Main quest [PROPOSED]:** `Q_MAIN_BLACKWOOD` — *"What the Forest Keeps"*.

| Stage | Objective text **[PROPOSED]** | Set by |
|---|---|---|
| `S1` | "Follow the Crown's order into the Blackwood." | Chapter 6 entry (after `BG_HANDOFF`) |
| `S2` | "Find out what Cinderhollow pays, and to whom." | Chapter 6 boss defeated |
| `S3` | "Reach the shrine under the roots." | Chapter 7 entry |
| `S4` | "Face what holds the glade." | Chapter 7 boss defeated |
| `S5` | "Find the stone doors." | Chapter 8 entry |
| `S6` | "Learn what the doors want." | Act III complete (door scene) |

`Q_BV_S7` stays complete; the Act II quest closes rather than growing an eighth stage, so the journal shows a finished act and a new one.

**Optional side quest [PROPOSED]:** `Q_SIDE_TITHE` — *The Next Name*. Berrin's household is on the list for this autumn. The player can either talk him out of paying (which loses a Cinderhollow NPC for the rest of the act and gains nothing mechanical) or help him choose a name from outside the hamlet (which the shrine accepts). Reward: 120 Gold and a Cinderhollow Charm (accessory, DEF +2) **[PLACEHOLDER]**. This is the act's moral decision; it must have no "correct" answer and must not change the main quest.

---

## 7. Encounters, bosses and balance

**Encounter table:** already written (`blackwood`, 18–20). Boss groups to add **[PROPOSED, data change]**:

| Fight | Group | Simulated result (party of four) |
|---|---|---|
| Ch 6 boss | `grp_burn_line_hulk`: **`burn_line_hulk` + 1 × `shade_stalker`** | 100% win, 7.6 rounds, 0.44 deaths, 42% party HP left |
| Ch 7 boss | `grp_blackwood_matriarch` (already in data): `blackwood_matriarch` + 1 × `shade_stalker` | 97% win, 7.3 rounds, 0.77 deaths, 26% left |
| Ch 8 boss | `grp_door_warden_boss`: **`door_warden_boss` + 2 × `ward_sentinel_late`** | 96% win, 8.2 rounds, 1.02 deaths, 24% left |

**In the data as of 2026-11-16.** `scr_enemy_database.gml` now carries `burn_line_hulk` (boss 18, 1260 HP, 55 ATK, fire-weak), `door_warden_boss` (boss 19, 1286 HP, 46 ATK, 37 DEF, lightning-weak) and `ward_sentinel_late` (common 20, 143 HP, 46 ATK, 36 DEF), and `blackwood_matriarch` picked up `hp_mult: 1.5` (686 → 1029 HP). The boss is named **The Door Warden** in the data, so the Bestiary does not show two identical "Door Warden" rows beside the elite; `ward_sentinel_late` shares the Ward Sentinel row instead of adding one. The three boss groups are in `scr_encounter_tables.gml`, and the new ids resolve to the base creature's battle strips in `scr_sprites.gml`. One Stalker in Chapter 6, not two: with two the act's first boss (89%, 8.4 rounds, 1.27 deaths) was harder than its second, which is backwards — the second Stalker is the Act IV escalation.

**Simulated (2026-11-16).** `tools/balance_sim.py` now has an Act III block (`ch6_tables()`, 2000–4000 runs a row) modelling the wood as it is coded: Fade (attacks miss until the next round), Blinding Dust (70%, 50% physical miss), Drowsy Dust (50%, two turns), the Matriarch's two phases and Ash Breath (0.8× to the whole party), and Sera's Mend / Smite. Party is Kael / Taren / Lyra with Caelan, and again with Sera, at levels 18–20, in Chapter 5 gear — there are no Act III weapons or armour yet.

**Before the tuning, the act had no teeth.** All three bosses at their chapter levels:

| Fight | Lv | Win % | Rounds | Deaths | Party HP left |
|---|---|---|---|---|---|
| Burn-Line Hulk (alone, HP ×1.0) | 18 | 100% | 5.1 | 0.01 | 74% |
| Blackwood Matriarch (HP ×1.0) | 19 | 100% | 5.0 | 0.16 | 47% |
| Door Warden + 2 L14 Sentinels | 20 | 100% | 4.7 | 0.00 | 78% |

Four things came out of the sweep:

1. **HP alone does not make the Hulk dangerous.** A single-target boss with no AoE spreads its damage over four members, so ×2.5 HP still lost 0 fights in 2000 (9.6 rounds, 0.40 deaths, 46% left). Two Shade Stalkers do more for the fight than tripling its HP; ATK does the rest.
2. **The Matriarch is the one boss that scales.** Ash Breath hits everyone, so ×1.5 HP turns 5.0 rounds / 47% left into 6.7 rounds / 91% wins / 1.0 deaths. That is the shape the act wants.
3. **One level is worth more than a boss phase.** At 20 the Matriarch is *easier* (54% left) than at 19 (47%) — tiered growth is that steep against the template. It also means the level cap raise (decision 9) is load-bearing: at 20 every fight in this act is comfortable.
4. **The Sentinels must be level 20.** As level-14 commons they die in one hit and the Ch 8 fight ends in 4.7 rounds with 78% HP left; at level 20 the same fight takes 57%.

**Sera's Smite is not the holy answer.** With `atk_bonus: 0` on the Holy Sword her 1.3× holy × 1.5 weakness lands about what Caelan's Ember does, and the Sera party is slightly *slower* on the Matriarch (5.6 rounds vs 5.0) because she spends turns on Mend. Even a +6 ATK sword only moves the tuned fight from 92% to 93% wins and 7.6 to 7.3 rounds. Give the sword stats for her sake, not the boss's. The full tables, including the HP and ATK sweeps, are in `docs/DECISIONS_AND_OPEN_QUESTIONS.md` §"Act III balance check". Every number is a simulation: none of these fights has been played.

**Level cap blocker:** `PARTY_MAX_LEVEL` is 20 and the act ends at 20. Raising it (24 recommended) is a decision, not a tweak: XP curve, level-up growth, and the enemy-scaling template all assume the current cap.

---

## 8. Build plan (when the outline is approved)

1. **Dialogue data** — `scr_dialogue_data_ch6`; prefixes `BW_` (the wood), `CH_` (Cinderhollow), `MT_` (the Matriarch), `DW_` (the Door Warden, if it speaks at all — recommended: it does not).
2. **Story script** — `scr_ch6_story` covering handoff → Chapter 6 → Chapter 7 → Chapter 8, flags for the tithe choice, and the door scene.
3. **Rooms** — three blockouts on the `ts_blackwood` placeholder atlas as an interim (rows 0–49 are `ts_zone1`, rows 50–64 are dark wood material), plus the two referenced rooms so the validator's unresolved list shrinks.
4. **Art** — Design's real Blackwood tileset (only a placeholder atlas exists); overworld sets for the nine Act III enemies (all on the gap list); the Matriarch's overworld set; the Aethari door as scenery.
5. **Audio** — `snd_amb_night` finally assigned (Chapter 7 on), `snd_amb_forest` for the approach, boss music for two of the three fights.
6. **Balance** — done for the outline: `tools/balance_sim.py` has the Act III block and §7 carries the tuned numbers. What remains is the engine-side side of it — the four data entries (`burn_line_hulk`, a level-20 `ward_sentinel`, and the `hp_mult` / `atk_add` on the Matriarch and Door Warden) and then a played pass.
7. **Playtest** — last, and only in an IDE.

---

## 9. Decisions for the owner

Each with a recommendation. Approving all ten would make this act buildable in the Chapter 2–5 format.

1. **Three chapters (6–8)?** *Recommended: yes.* No recruits to spend chapters on; three gives the act an arc without padding. Alternative: two (6–7) with the doors as Chapter 7's finale.
2. **Chapter titles:** *The Green Silence* / *The Share* / *The Door in the Wood*. *Recommended as written.* Alternatives: *The Tithe*, *Cinderhollow*, *What the Wood Keeps*.
3. **Cinderhollow and its burners** are invented here, not from the design doc. *Recommended: keep them* — they give the forest a human face and a moral question without touching canon. Alternative: cut the hamlet and run the act as pure wilderness, which removes decision 8 and the side quest.
4. **The tithe** — people are given to the shrine, and have been for longer than the burners remember. *Recommended: keep, unresolved.* It explains the missing patrol without explaining the Ash.
5. **Bosses:** Burn-Line Hulk (briar_hulk, boss-scaled, ×1.5 HP, +12 ATK, with two Shade Stalkers), the Blackwood Matriarch (existing, ×1.5 HP), the Door Warden (door_warden, boss-scaled at ×2.0 HP, with two level-20 Sentinels). *Recommended* — these are the simulated numbers from §7; the four data changes they need are listed there.
6. **Does the door open?** *Recommended: no.* A seam, a sound, and silence. Opening it in Act III would answer the question Act IV or V should ask.
7. **The Fallen Knight in Act III?** *Recommended: absent.* He has two Act II sightings and Act 5 is named for him.
8. **The side quest's choice** — pay the tithe with a stranger, or refuse and lose a villager. *Recommended: keep both options, no correct answer, no main-quest effect.* Reward 120 Gold + accessory (PLACEHOLDER).
9. **Level band 18–20 and raising `PARTY_MAX_LEVEL` to 24.** *Recommended: yes to both.* Without the cap raise, the act ends at the ceiling and Act IV has nowhere to go. The simulation also shows the band's top is generous — at 20 even the tuned bosses are comfortable — so Act IV's own numbers will have to start above the level-20 curve rather than reuse it.
10. **Rooms:** `rm_blackwood_deep` and `rm_blackwood_doors` (already referenced, build them so the validator list shrinks) plus `rm_blackwood_hollow`, `rm_blackwood_shrine`, `rm_blackwood_glade`. *Recommended as written.*

---

## 10. Open questions this act deliberately leaves open

Bible question numbers: the Ash and the Ash King (1, 34), the Fallen Knight's identity (2), what Sera saw (4), what Caelan knows (5), Lumen (8), the Crown Engine (9), what destroyed Greyhaven (16), the Night of Ash (17), whether the Crownveil Door is the passage beneath Greyhaven (18), Mira's stone (19), why the carvings resemble Mira (20), what "everything stops" means (22), why the royal banner bears the mark (24), and where the Crownveil runs (25). Act III touches several of these and **answers none**. It should raise the count of questions the player is carrying, not lower it.

---

## 11. What Act III must not do

- Explain the Ash, the Crownveil, the Aethari's fate, Lumen or the Crown Engine.
- Say where Mira is, or confirm she passed the doors.
- Let the Lost Ones or the Matriarch explain the tithe's origin.
- Break Sera's silence about the palace, or Caelan's about what he knows.
- Bring Alden or the split with Taren forward.
- Name or resolve the Fallen Knight.
- Kill off Cinderhollow wholesale for shock value; the hamlet's survival is the act's point.
- End on a cliffhanger that needs a cutscene to explain — it ends on a door and a question, like Chapter 1 did.
