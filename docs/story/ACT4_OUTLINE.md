# ASHEN CROWN — Act IV Outline: "The Forgotten King"

> **Status: DECISIONS APPROVED 2026-11-16 (all ten as recommended); the chapters themselves are not written and the act is not built.** The seven Act IV enemies, the `crown_barrow` encounter table, the three boss groups, the sprite fallbacks and the matching bestiary rows are in the data, and `PARTY_MAX_LEVEL` is now 24. Act IV is still PROPOSED as story: nothing here is canon. This is the outline Act IV needs before a chapter script can be written, in the same shape as `ACT3_OUTLINE.md`. §9 lists ten decisions for the owner; each has a recommendation. The act title **The Forgotten King** is **[O]** canon (bible §7 gives the title and nothing else), and bible question 13 — *who is the Forgotten King?* — is answered here only as a proposal.
> **Level band: 21–23 [PROPOSED], and it is blocked.** `PARTY_MAX_LEVEL` is 20. Act IV cannot be played at its own band until the cap moves; §9.8 recommends 24, which is the same decision Act III's outline already asked for.

Source of truth: `STORY_BIBLE.md` (Alden Marr, Ending C, Aldric IV, the mark), `ACT3_OUTLINE.md` §5 (where Act III leaves the party), and the built state of the game. Where canon is silent this outline says so and lists the choice.

---

## 0. What is already in the build

- **The engine does not need to change for this act.** Dialogue, flags, quests, scripted bosses, marker-driven rooms, save schema v3 and the audio set all exist. Act IV is content.
- **The enemy data now exists** (added 2026-11-16 on the decisions below): seven ids at 21–23, the `crown_barrow` table and `grp_magistrate_vell` / `grp_barrow_warden` / `grp_forgotten_king`, with `PARTY_MAX_LEVEL` raised to 24. The Bestiary goes 35 → 42 entries, and the validator reports 42 entries, 42 distinct names, 42 with art. **No chapter uses any of it yet.**
- **Rooms:** 31 rooms exist in total, and **every Act IV room is built** — `rm_town`, `rm_barrow_gate`, `rm_barrow_halls`, `rm_barrow_deep`. The validator's remaining unresolved references (`rm_ironspine_*`, `rm_ashlands_*`, `rm_saltreach*`, `rm_shipwreck`, `rm_rimehold`, `rm_flooded_ruins`, `rm_frozen_ruins`) all belong to Acts V–VIII.
- **Art:** 18 enemy kinds still have no 16×24 overworld set, and the act boss would need battle art, a portrait-scale presence and a bestiary row. Nothing in Act IV can ship visually on existing assets except reused common enemies.
- **Alden has no sprite at all** (measured in `ASSET_INVENTORY.md`), and this act puts him on screen in three chapters.

## 1. Canon anchors this act must satisfy

From `STORY_BIBLE.md`, locked or confirmed:

- **Alden Marr's ending is locked as a concept, not as a scene** (§5.6, Ending C): Alden begins wanting to free the serfs and rebuild Eldoria, ambition corrupts him, and *after King Aldric IV is defeated* he takes the capital and claims the throne. Kael and Taren must stop him, in a three-phase battle. **Placement and conditions are [O]**, and it is not necessarily the only ending.
- **King Aldric IV** rules the Crown, knows the Crownveil is failing, has hidden the truth, and is defeated at some point before Alden seizes the capital. His personality and the reason for the cover-up are **[O]**.
- **The mark** — a crown ringing a black sun — is on the Watchtower banner, the Basement carvings, Mira's pendant and the Aethari doors. It is **[CANON]** and its meaning stays **[O]**.
- **The split between Alden and Taren has not happened** as of Act III, and the bible explicitly keeps *when and how* it happens **[O]**.
- **Sera's silence about the palace** and **Caelan's about what he knows** stay intact.
- The party says **Aethari** in dialogue; UI, bestiary and quest text stay on **Architects**.

## 2. Shape: three chapters (9–11)

Act II had four chapters because it had four recruits. Act III has three because it has none and its length comes from the place. **Act IV has no recruits either**, so three is the shape that fits: a beginning in a Crown town, a middle on the barrow road, and an end in the tomb.

A fourth chapter would have to invent a recruit or a subplot the bible does not support; a fifth act already needs to carry the Fallen Knight, the mountains, the Ashlands and the truth. Three is the recommendation (§9.2).

**Route:** the Blackwood's south road → **`rm_town`**, a Crown market town → the barrow hills → **`rm_barrow_gate`** → **`rm_barrow_halls`** → **`rm_barrow_deep`**, the Forgotten King's tomb → the road out, south, toward Act V.

## 3. Chapter 9 — The Crown's Ledger

**Script: [CHAPTER9_SCRIPT.md](CHAPTER9_SCRIPT.md)** — **built 2026-11-16**: `rm_town`, `scr_dialogue_data_ch9` (106 nodes), `scr_ch9_story`, the quest rows and the wiring. Not played; every NPC is a placeholder.

**Room:** `rm_town` (already referenced; 34×20 blockout).

**What happens (all [PROPOSED]):**
1. The party comes out of the Blackwood into a Crown town that has heard nothing and believes nothing. The doors are behind them, unanswered, and the only lead left is paper: **the Crown's own record of what it built.** The town's magistrate holds the local ledger, and the ledger has a page torn out.
2. **Alden Marr is here**, on the rebellion's business, and he is the same friend he was in Valemere: warm to Kael, careful with Taren, sincere about the serfs. He is also the first person to say the word *legitimacy* out loud — the Crown's line has a hole in it, and someone has been filling that hole for a hundred years.
3. The magistrate, **Vell**, is not a villain: he is a career clerk who knows the ledger is short a page, has known for years, and has never asked why. He yields rather than dies (§9.6), and the page he gives up is a survey of a barrow field that no Crown map shows.
4. The chapter ends with Alden proposing they go together. **Taren says yes too quickly**, and the chapter does not comment on it. No split.

**Boss:** **Magistrate Vell** — human, level 21, yields at 0 HP on the existing `yields_if_flag` hook. A Crown functionary with a guard detail, fought in the ledger house.

**What the chapter must not do:** let Vell explain the cover-up, or make Alden's ambition visible as ambition. He is sincere here. The reader may suspect him; Taren does not yet.

## 4. Chapter 10 — The Barrow Road

**Script: [CHAPTER10_SCRIPT.md](CHAPTER10_SCRIPT.md)** — **built 2026-11-16**: `rm_barrow_gate`, `scr_dialogue_data_ch10` (48 nodes), `scr_ch10_story`, quest stages S3–S4 and the wiring. Not played; Alden has no battle slot and no sprite, and the gatehouse is a blockout.

**Room:** `rm_barrow_gate` (28×20 blockout, built).

**What happens (all [PROPOSED]):**
1. The survey's barrow field is real, and the Crown has been quietly maintaining a road to it for a century: gravel, drainage, a gate that was rebuilt rather than repaired. Someone has been visiting.
2. The barrow's guardian is not Aethari — it is **Crown work**, a thing of iron and oath built to keep a door shut from this side. It is the act's answer to Chapter 8's doors in miniature: **a door that opens from the far side, sealed here instead.** The party fights it because it will not let anyone past, and it does not speak.
3. **Alden fights beside the party** (as an ally the engine can already support: a non-controllable NPC in the battle line, or a scripted damage source — §9.5). This is the chapter where the friendship is still real.
4. The chapter ends at the gate with the seal cracked and the smell of cold stone coming out of the hill.

**Boss:** **the Barrow Warden** — level 22, a Crown-made construct, two phases, resistant to physical damage in its second phase. Reuses the Aethari construct's *silhouette language* without being Aethari.

**What the chapter must not do:** name the Fallen Knight, imply he has been here, or let Alden do anything the player would call a betrayal yet.

## 5. Chapter 11 — The Forgotten King

**Rooms:** `rm_barrow_halls` (30×20) and `rm_barrow_deep` (26×20) — both built.

**Script: [CHAPTER11_SCRIPT.md](CHAPTER11_SCRIPT.md)** — **built 2026-11-16**: both rooms, `scr_dialogue_data_ch11` (81 nodes), `scr_ch11_story`, quest stages S5–S6 and the seal choice. Not played; the tomb is a blockout and the King borrows the sanctuary warden's strips. The charter names the mark **the Crownveil** — the phrase canon already uses — and explains nothing about it. *The Ashen Crown* stays reserved for the finale.

**What happens (all [PROPOSED]):**
1. The halls are a royal tomb with the names chiselled off: every inscription has been struck through with the same chisel, in the same hand, at the same time. **The forgetting was an act, not an accident.** This is the act's horror and its history beat.
2. The last chamber holds **the Forgotten King** — the king before the Crown's line, buried with the **seal and the charter** that legitimised his house. He is not a ghost and not a puppet: he is a corpse that has been *kept*, and the thing keeping him is the same oath-work as the Warden.
3. **The charter names the mark.** Not what it means — what it is *called*, in the Crown's oldest hand, and the name is one the player has seen before without reading (the Watchtower banner, the Basement carvings). One line of text, no explanation. **This is the act's one revelation and it must stay a name, not a definition.**
4. The King fights because the tomb's oath requires a keeper, not because he hates the party. Three phases, and his last phase is the oath breaking rather than a monster appearing.
5. **Alden takes the seal** if the party lets him, or the party keeps it — a choice with no correct answer (§9.4). Either way **the act does not say what he will do with it.** Taren's first real doubt lands here, in one line, and the chapter ends before he says it out loud.
6. The act ends on the road south: Act V is titled after the Fallen Knight, and this outline leaves him entirely to it.

**Boss:** **the Forgotten King** — level 23, three phases, act boss.

**What the chapter must not do:** explain the Ash, the Crownveil, the Aethari's fate, Lumen or the Crown Engine; state that the King is Aethari; let the King name Mira, the Fallen Knight, or Alden's future.

## 6. Quests

**Main quest [PROPOSED]:** `Q_MAIN_CROWN` — *"The King Who Was Forgotten"*. Act III's `Q_MAIN_BLACKWOOD` closes at S6 ("Learn what the doors want." stays its last stage and the quest is set complete), mirroring how Act II closed rather than growing an eighth stage.

| Stage | Objective text | Set by |
|---|---|---|
| `S1` | "Find the Crown's record of what it built." | Chapter 9 entry |
| `S2` | "Take the torn page to the barrow field." | Vell yields |
| `S3` | "Get past the barrow's warden." | Chapter 10 entry |
| `S4` | "Open the tomb of the forgotten king." | Barrow Warden defeated |
| `S5` | "Learn what the charter names." | Chapter 11 entry |
| `S6` | "Decide who carries the seal." | The King's defeat |

**Side quest hook (now in the data as Chapter 9's built quest):** `Q_SIDE_LEDGER` — *"The Page Nobody Asked For"*. Vell's clerk, **Perrin's cousin** (a new minor NPC), wants the torn page copied before it goes into the party's pack; the reward is a shop discount in `rm_town` and a line in Act V. Deliberately small: Act IV's weight is in the main line.

## 7. Encounters, bosses and balance

**Encounter table:** `crown_barrow` at 21–23, five groups over seven ids, all now in `scr_enemy_database.gml`. **None of it is used by a room or a script yet.**

| Id | Role | Level | Notes |
|---|---|---|---|
| `crown_guard_elite` | common | 21 | Crown soldier, human. Reuses `occupation_soldier` art until its own exists. |
| `barrow_husk` | common | 21 | What the tomb keeps. New art needed. |
| `oath_iron` | common | 22 | Crown oath-work construct. Reuses `aethari_automaton` silhouette. |
| `grave_moth` | common | 22 | The moths, scaled and renamed for the barrow. Reuses `night_moth_swarm` art. |
| `barrow_warden` | boss | 22 | Ch 10 boss, two phases, physical resistance in phase 2. |
| `forgotten_king` | boss | 23 | Act boss, three phases. |
| `magistrate_vell` | boss | 21 | Ch 9 boss, yields. Human, no new art needed if a Crown officer sprite is reused. |

**Balance was simulated before any chapter was written** (`python3 tools/balance_sim.py --act4`, 1,200 runs per row, party at 21–23 in Chapter 5 gear). The first numbers were too soft — every boss was won 100% — so the Warden went to ×2.2 HP and +4 ATK and the King to ×2.1 HP and +3 ATK. As shipped:

| Fight | Lv | Party (+Caelan) | Party (+Sera) |
|---|---|---|---|
| Ch 9: Vell + 2 Guard Elites | 21 | 100%, 6.5 rounds, 0.62 deaths | 100%, 8.1 rounds, 0.20 deaths |
| Ch 10: Barrow Warden (1701 HP) | 22 | 100%, 7.4 rounds, 0.54 deaths | 98%, 9.9 rounds, 0.46 deaths |
| Ch 11: the Forgotten King (1714 HP) | 23 | 97%, 8.5 rounds, 0.99 deaths | 95%, 9.9 rounds, 0.71 deaths |
| the Forgotten King, under-levelled | 21 | 81%, 9.5 rounds, 1.65 deaths | 83%, 10.8 rounds, 1.38 deaths |

The band edges are 3–5 rounds at 77–89% party HP with no deaths, and the King at 21 is still winnable but punishing — arriving at the act's top level is worth it. **The simulation is a model, not a playtest:** nothing has been compiled, and these rows rest on the formulas in `scr_battle_math.gml`, not on the game.

Two mechanical gaps the data exposed:

- ~~The King has two phases, not three.~~ **Fixed:** the battle system now supports a second shift (`phase3_at` → `phase_actions[2]`), and the King uses it at 30% — the oath letting go. Simulated at 23 with all three phases: 98% / 93% by party, 79–82% at 21.
- **Vell's yield flag is `flag_vell_yielded`**, set by the battle system the way Calder's is. No script reads it yet — Chapter 9 will be the first.

**Two constraints worth stating before any numbers are chosen:**
- The party ends Act III at 20 with Chapter 5 gear and no Act IV equipment. A level-21 common with Act III weapons will feel like a wall unless the act also adds a weapon/armour tier; that is a content decision, not a tuning one.
- Sera's Smite and Caelan's Ember already define the damage ceiling in the simulation. An act boss with no AoE will be safe at any HP, which is the same lesson Act III's Hulk taught.

## 8. Build plan (when this outline is approved) — **executed: Chapters 9–11 are built**

1. **Level cap** — raise `PARTY_MAX_LEVEL` to 24 and confirm the XP curve still lands 21–23 at sensible XP totals (decision 8).
2. **Enemy batch** — seven ids, `crown_barrow` table, boss groups `grp_magistrate_vell`, `grp_barrow_warden`, `grp_forgotten_king`; then extend `tools/balance_sim.py` and tune before writing lines against the numbers.
3. **Art** — Alden's overworld set and portrait (**required**: he is on screen in all three chapters and currently has nothing), the Forgotten King (battle + overworld), the barrow's tileset or a stone-heavy blockout, the charter and seal as scenery/item icons.
4. **Rooms** — `rm_town` (already referenced) and four barrow rooms, all blockouts first.
5. **Dialogue data + story scripts** — `scr_dialogue_data_ch9..11` and `scr_ch9_story..scr_ch11_story`, generated from `CHAPTER9_SCRIPT.md..CHAPTER11_SCRIPT.md` by the existing generators.
6. **Audio** — `snd_amb_dungeon` for the tomb, `snd_amb_water` is still unassigned and this act does not need it; the barrow may want a new bed.
7. **Playtest** — last, and only in an IDE.

## 9. Decisions for the owner — **APPROVED 2026-11-16, all ten as recommended**

1. **Where Act IV happens.** *Recommended: the Crown heartland* — a market town and a barrow field inside Eldoria, reached from the Blackwood's south road. Alternatives: the **Drowned Coast** (Saltreach, `rm_saltreach`/`rm_saltreach_pier`/`rm_shipwreck`) or the **Frostwilds** (Rimehold, `rm_rimehold`), either of which would assign a region the bible leaves unassigned and reorder Acts V–VIII.
2. **Three chapters (9–11)?** *Recommended: yes.* No recruits; the act's length is the town, the road and the tomb.
3. **Who the Forgotten King is.** *Recommended: the king before the Crown's line, buried with the seal and charter that legitimised his house, with his name chiselled off on purpose.* Alternatives: an Aethari king (which starts to answer the Aethari question), or an ancestor of Aldric IV (which makes the cover-up a family matter and shrinks it).
4. **The seal and the charter.** *Recommended: keep both, and let the player choose who carries the seal, with no correct answer and no stated consequence.* This is the act's only branch and it must not resolve Alden.
5. **Alden on screen.** *Recommended: present in all three chapters, sincere, fighting beside the party in Chapter 10, and never framed as a traitor.* The split stays open; Ending C stays locked and untouched. **This needs his sprite** — the largest single art dependency of the act.
6. **The bosses.** *Recommended as written:* Magistrate Vell (human, yields), the Barrow Warden (Crown-made construct, two phases), the Forgotten King (three phases, act boss). Alternative: cut Vell and open on the road, which loses the human face of the Crown.
7. **The charter names the mark — a name, not a meaning.** *Recommended: yes.* It is the act's one revelation: the mark has a name the player has already seen, and the name explains nothing. Alternative: no revelation at all, which leaves Act IV as pure travel.
8. **Level band 21–23 and `PARTY_MAX_LEVEL` 24.** *Recommended: yes to both*, as Act III's outline already recommended. Without the raise, the act cannot be played at its band, and Act V has nowhere to go.
9. **A new enemy batch and its art.** *Recommended: seven ids, three of them bosses, with reused art for three commons and new art for the act boss and the barrow tileset.* Alternative: reuse every existing strip and ship the act visually wrong — cheaper, and it would read as cheap.
10. **Rooms.** *Recommended: `rm_town` (already referenced, so the validator list shrinks) plus `rm_barrow_gate`, `rm_barrow_halls`, `rm_barrow_deep`.* No `rm_ironspine_*` (Act VI, "Beneath the Mountains") and no `rm_ashlands_*` (Act VII) — those belong to their own acts.

## 10. Open questions this act must leave open

Bible question numbers: the Ash and the Ash King (1), the Fallen Knight's identity (2), what Sera saw (4), what Caelan knows (5), Lumen (8), the Crown Engine (9), what destroyed Greyhaven (16), the Night of Ash (17), whether the Crownveil Door is the passage beneath Greyhaven (18), Mira's stone (19), why the carvings resemble Mira (20), "everything stops" (22), why the royal banner bears the mark (24), where the Crownveil runs (25). **Act IV may add questions; it answers none of these.** In particular:

- **Who is the Forgotten King, really** (bible 13) — this outline proposes an answer, and the act itself should give it only as far as a name on a tomb and a charter.
- **What Alden will do with the seal** — not stated, not foreshadowed as villainy, not resolved.
- **Whether the Crown's founding is a lie** — the act shows the erasure, never the reason.

## 11. What Act IV must not do

- Defeat or reveal King Aldric IV, or move Ending C forward.
- Split Alden from Taren, or let anyone call him a traitor.
- Bring the Fallen Knight on screen; Act V is his.
- Open the Aethari doors, or say what is behind them.
- Explain the mark, the Ash, the Crownveil, the Aethari's fate, Lumen or the Crown Engine.
- Say where Mira is, or confirm she passed the doors.
- Break Sera's or Caelan's silence.
- Use the Ironspine, Ashlands, Saltreach or Rimehold rooms — they belong to Acts V–VIII.
