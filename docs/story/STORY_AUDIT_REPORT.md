# ASHEN CROWN — Story, Lore & Canon Audit

**Audit date:** 2026-11-18  
**Repository:** `EasternGoatForge-Ashen-Crown`  
**Working branch:** `freebuff/act5-ch12-script`  
**Scope:** All eight acts, the finale, the story bible, the fourteen chapter scripts, dialogue data, quest data, story flags, rooms, bosses, transitions and persistence.  
**Status:** Audit only. No game code, story data or existing canon document was modified by this audit.

---

## 1. Executive summary

ASHEN CROWN has a strong, unusually well-documented opening four acts and a genuinely distinctive central mystery. It does **not** yet have a complete eight-act narrative.

The campaign is implemented through **Chapter 11**. Chapters 1–11 exist as 34 rooms, 95 scripts, 1,026 dialogue ids (1,011 structured nodes plus 15 legacy dispatcher case labels) and 43 bestiary entries, but **none of it has been compiled or playtested in GameMaker**. Act V (Chapters 12–14) is fully approved as story and has **638 scripted dialogue ids and zero implementation**. Acts VI–VIII and the finale have **titles, a region assignment and some data-only gear/enemies, but no outlines, chapter scripts, quests, dialogue, rooms or endings**.

The most important consequences:

1. **The playable story stops at the end of Act IV.** Chapter 11 has no exit to Act V, no Act V content exists, and the only post-Act IV story-adjacent content is three standalone Ashlands rooms that open too early.
2. **Alden Marr's locked Ending C has no implementation.** He has 48 dialogue lines and a scripted presence in Chapters 3, 9, 10 and 11. He has no turn, no seizure of the capital, no three-phase boss and no final confrontation with Kael and Taren.
3. **King Aldric IV never appears.** The name has zero references in GML. There is no defeat scene, no boss, no motive and no palace location.
4. **Mira Varyn's present-day story is dormant.** She is the opening quest and the emotional spine, but her name appears only 20 times across the built chapters, and not at all in Chapters 9–11. There is no present-day scene, no answer and no planned payoff after Act V.
5. **The opening main quest is not implemented.** `Q_MAIN_FIND_MIRA` is absent from `scr_quest_data.gml`; its nine stages exist only as comments/marker metadata; the marker engine never reads `quest_start` or `quest_advance`; and `CV_END` never completes it or starts `Q_MAIN_BEYOND_VEIL`.
6. **The campaign has no ending.** There are no ending triggers, no epilogue, no credits sequence, and no final selection among Ending C and the three unconfirmed Crownveil endings.
7. **The Fallen Knight reveal is approved but unbuilt.** Act V's "office, not a man" revelation exists only in approved scripts. The knight's identity, his relation to Kael's family, and his place in the final act remain open.
8. **The Broken Yoke is a name, not an organisation.** It has no leader, structure, base, founding story, suppression campaign or postwar fate. Alden's rise therefore has no political machinery behind it.
9. **Two concrete quest-stage bugs and one missing reward item** exist in built content: `Q_ST_S2` and `Q_SL_S2` are never set, and `item_cinderhollow_charm` has no item definition.
10. **Documentation status has drifted.** The bible still calls Chapter 6 proposed, Act IV "C-confirmed", Act V "PROPOSED", and the region map open, while the decision log says the opposite.

The good news is that the existing material is coherent enough to finish rather than replace. The audit found **three narrative contradictions or broken promises**: one direct line-to-line contradiction (the pendant in Chapter 8) and two promised payoffs that were never written (the Blackwood tithe and the Crown ledger). That is not a collapsed continuity. Most gaps are missing content, not broken canon.

---

## 2. Method and evidence

### 2.1 Documents read

- `docs/story/STORY_BIBLE.md`
- `docs/story/ACT2_OUTLINE.md`–`ACT5_OUTLINE.md`
- `docs/story/CHAPTER1_SCRIPT.md`–`CHAPTER14_SCRIPT.md`
- `docs/GAME_DESIGN_DOCUMENT.md`
- `docs/DEVELOPMENT_ROADMAP.md`
- `docs/DECISIONS_AND_OPEN_QUESTIONS.md`
- `docs/AI_AGENT_DEVELOPMENT_BACKLOG.md`
- `docs/EQUIPMENT_PROGRESSION.md`
- `docs/PLAYTEST_RUNBOOK.md`
- The story, quest, dialogue, marker, save, shop, enemy and encounter scripts under `game/scripts/`

### 2.2 Static checks run

| Check | Result |
|---|---|
| `python3 validate_gamemaker.py` | **ALL CHECKS PASSED** with 4 warnings; 34 rooms, 43 bestiary entries, 8 unresolved room references; 4 encounter tables roll out-of-band enemies (`zone01_old_road`, `zone01_bandit_camp`, `zone01_watchtower`, `zone01_basement_hall`) |
| `python3 tools/audit_chapters.py` | **No wiring problems found**; 37 dialogue nodes listed as unreferenced by a dispatcher |
| Dialogue data count | 12 files, **1,026 defined ids** (1,011 structured nodes plus 15 legacy `case` labels), no duplicate id |
| Dialogue coverage | Every scripted id in Chapters 1–11 resolves to a dialogue node; Chapters 12–14 have **638 ids and 0 nodes** |
| Placeholder dialogue | **64** `PLACEHOLDER` wiring/art-pass cases in built chapters (Ch2 6, Ch3 6, Ch4 4, Ch5 9, Ch6 10, Ch7 7, Ch8 3, Ch9 11, Ch10 4, Ch11 4) |
| Quest data | **8** quest definitions; `Q_MAIN_FIND_MIRA`, `Q_MAIN_FALLEN` and `Q_SIDE_TOLL` absent |
| Quest stages | `Q_ST_S2` and `Q_SL_S2` defined but never set |
| Story flags | **144** distinct flags set; **121** read through `scr_flag_get`; several set-only flags are intentional one-shots, but `ch11_seal_alden` / `ch11_seal_party` have no downstream consumer |
| Rooms | 34 built; 8 unresolved references; no coast, Ironspine or Frostwilds room |
| Boss data | Blackguard through Forgotten King in data; Act V bosses data-only; no Alden, Aldric IV or Ash King enemy |
| Ending code | No ending, epilogue or credits trigger anywhere |
| Engine test | **Not run.** No GameMaker IDE, compile, runtime or playtest was available. |

### 2.3 What “implemented” means in this report

- **Written:** a chapter script or outline exists.
- **Approved:** the owner has approved it as story or canon.
- **Built:** data, scripts and rooms exist in the repository.
- **Playable:** compiled and played. **Nothing in this repository has met that bar.**
- **Unverified implementation:** source/data exists but has never been compiled or played.

No statement in this audit should be read as a claim that a chapter is playable, balanced, bug-free or visually complete.

---

## 3. Canon baseline used by this audit

### 3.1 Locked or confirmed

- Kael Varyn is the protagonist; Mira Varyn is his younger sister; the party is Kael, Taren, Lyra, Caelan and Sera, with four active and one reserve.
- The Ash, the Aethari, the Crownveil, the Ashen Crown, the Forgotten King, the serf rebellion, the Broken Yoke, King Aldric IV, Mira Varyn and the Fallen Knight are established terms. They must not be casually renamed or conflated.
- **Alden Marr's ending concept is locked as Ending C — The Last Usurper.** He begins sincerely wanting to free the serfs, is gradually consumed by ambition, takes the capital after Aldric IV is defeated, claims the throne, and must be stopped by Kael and Taren in a three-phase battle. He must remain tragic, not become an ordinary evil villain.
- Chapters 1–5 are approved canon. Chapter 6 is approved canon. Act II's four chapter titles and level bands are approved.
- Act III's Chapters 7–8 are **built but not individually approved**; Act IV's decisions are approved but its three chapters are **built but not individually approved**; Act V's Chapters 12–14 are **approved as story but entirely unbuilt**.
- Acts VI–VIII and the finale *The Ashen Crown* have **titles only**. They are not outlined, scripted or built.
- Endings 1–3 (Restore the Crownveil, Destroy the Crownveil, Break the Cycle) are marked **[U] unconfirmed** in the bible. Only Ending C is locked, and even its placement and conditions are open.

### 3.2 What is not canon

- Act IV's Forgotten King identity, the charter naming the mark **the Crownveil**, Coleford, Vell, Nessa, the Barrow Warden and the seal choice are **PROPOSED** story, even though they are built.
- Act III's Chapters 7–8, Berrin, the tithe, the Blackwood Matriarch and the Door Warden are **PROPOSED** except where Chapter 6's approval covers them.
- Act V's Drowned Coast, Saltreach, Ilsa Fen, Maelin Orr, the Toll-Keeper, the Leviathan and the office reveal are **approved as story** but not canonised by the bible, which still labels the act **PROPOSED**.
- The Ashlands rooms, Sarn, the Act VII gear shelf and the "Ash Crown" helm are **built ahead of their act** and are not documented canon.
- Anything in this audit marked **recommendation**, **option** or **proposal** is not canon and requires owner approval.

---

## 4. Act-by-act scorecard

| Act | Title | Chapters | Outline | Story written | Dialogue implemented | Quests | Rooms | Bosses | Transition to next act | Playable |
|---|---|---|---|---:|---|---|---|---|---|---|
| I | The Night of Ash | 1 | Complete | Approved | 114 nodes | `Q_FM` missing; `Q_SIDE_RENN` | Greyhaven, farmlands, camp, watchtower, basement, arena | Blackguard | Yes | No |
| II | The Broken Crown | 2–5 | Complete | Approved | 523 nodes | `Q_BV` + 3 side quests | Wrenfield, Valemere, Hollow Sanctuary, garrison | Calder, Debtman, Warden, Hailen | Yes | No |
| III | The Blackwood | 6–8 | Complete | Ch6 approved; Ch7–8 built unapproved | 139 nodes | `Q_MBW` + `Q_SIDE_TITHE` | 5 Blackwood rooms | Burn-Line Hulk, Matriarch, Door Warden | Yes | No |
| IV | The Forgotten King | 9–11 | Complete | Decisions approved; chapters built unapproved | 235 nodes | `Q_MC` + `Q_SIDE_LEDGER` | Coleford, barrow gate, halls, deep | Vell, Barrow Warden, Forgotten King | **No** | No |
| V | The Fallen Knight | 12–14 | Approved | Approved | **0 of 638** | `Q_MF` / `Q_ST` absent | **0** | 3 data-only | **No** | No |
| VI | Beneath the Mountains | — | **None** | **None** | 0 | 0 | 0 (2 unresolved names) | 0 | **No** | No |
| VII | The Ashlands | — | **None** | **None** | 0 | 0 | 3 standalone rooms | 0 | **No** | No |
| VIII | The Truth | — | **None** | **None** | 0 | 0 | 0 (2 unresolved names) | 0 | **No** | No |
| Finale | The Ashen Crown | — | **None** | **None** | 0 | 0 | 0 | 0 | **Ends the game** | No |

**Dialogue totals:** 114 + 523 + 139 + 235 = **1,011 structured nodes**; plus 15 legacy dispatcher case labels = **1,026 defined ids**. Chapters 12–14 add **638** scripted ids with no data.  
**Room totals:** 34 built, of which three are Act VII Ashlands rooms, one is the title room, one is the battle test room, and one is the overworld hub.

---

## 5. Highest-priority findings

### A-01 — CRITICAL — The campaign has no playable continuation after Chapter 11

**File / section:** `game/scripts/scr_ch11_story.gml` §6.3; `game/scripts/scr_ch11_markers_data.gml`; `game/scripts/scr_map_markers_data.gml`; absent `scr_ch12_story.gml`, `scr_dialogue_data_ch12.gml`, `scr_saltreach_markers_data.gml`.  
**Issue:** Chapter 11 completes `Q_MAIN_CROWN`, sets `flag_act4_complete`, and plays the Act IV card. The barrow-deep room has only an exit back to the halls; the gatehouse exits north to Coleford and south to the halls. There is no exit to the Drowned Coast, no Act V room, and no Act V story script. The only post-Act IV entrances that open are the three Act VII Ashlands rooms.  
**Why it matters:** The main story cannot be continued past the Act IV card. The player can backtrack, but there is no next objective, no Act V, and no route toward Acts VI–VIII or the finale. This is the single largest reason the game is not a complete narrative.  
**Recommendation:** Build the approved Chapters 12–14 (rooms, markers, dialogue data, story scripts, quest rows) and add the Act IV→V coast-road transition. Until then, label Act IV's ending as the current playable endpoint in the roadmap and do not describe the game as an eight-act campaign.  
**Owner approval:** Yes for new rooms/transitions and any added scene text; the approved scripts themselves already have story approval.

### A-02 — CRITICAL — Act V is approved as story but has zero implementation

**File / section:** `docs/story/ACT5_OUTLINE.md` §8; `docs/story/CHAPTER12_SCRIPT.md`–`CHAPTER14_SCRIPT.md`; absent `game/scripts/scr_ch12_story.gml`, `scr_dialogue_data_ch12.gml`, `scr_saltreach_markers_data.gml`.  
**Issue:** The three Act V scripts contain **638 dialogue ids** (198 + 256 + 184) but no dialogue data, no story script, no room, no marker table and no quest row. The seven enemies, the `drowned_coast` table and three boss groups exist only as data. The four room names (`rm_saltreach`, `rm_saltreach_pier`, `rm_flooded_ruins`, `rm_shipwreck`) are unresolved references.  
**Why it matters:** Act V is the bridge from the built game to the unbuilt final acts and the act that pays off the Fallen Knight. Without it, the approved story is invisible to the player and the campaign cannot reach Acts VI–VIII.  
**Recommendation:** Treat Act V as the next content milestone. Build it in the approved order: Saltreach and the toll, the pier and the flooded record hall, the wreck and the knight; wire `Q_MAIN_FALLEN`, `Q_SIDE_TOLL`, the conditional Alden letter and the Act VI exit. Keep the act's deliberate silences: no knight name, no Mira answer, no Crownveil explanation.  
**Owner approval:** No for implementing approved scripts; yes for any new line, room or beat not in the scripts.

### A-03 — CRITICAL — Acts VI–VIII and the finale have no story at all

**File / section:** absent `docs/story/ACT6_OUTLINE.md`, `ACT7_OUTLINE.md`, `ACT8_OUTLINE.md`, finale outline; `docs/story/STORY_BIBLE.md` §7.  
**Issue:** The repository contains only the titles **Beneath the Mountains**, **The Ashlands**, **The Truth** and the finale **The Ashen Crown**, plus a fixed region map in `docs/DECISIONS_AND_OPEN_QUESTIONS.md` (VI = Ironspine, VII = Ashlands, VIII = Frostwilds). There is no outline, chapter breakdown, quest, character beat, boss, dungeon, revelation schedule or ending plan for any of them.  
**Why it matters:** Three acts and the finale are the majority of the remaining story. Without outlines, the existing lore questions have no scheduled answers, the companions have no late-game arcs, and Alden's takeover has no build-up.  
**Recommendation:** Before writing more Act V prose, write one-page act outlines for VI–VIII and the finale, each with: chapter titles, level band, region, dungeon, boss, main quest, side quests, companion focus, lore questions answered/raised, and transition. Do not fill the outlines with approved canon until the owner signs off.  
**Owner approval:** Yes.

### A-04 — CRITICAL — Alden's Ending C has no implementation

**File / section:** `docs/story/STORY_BIBLE.md` §5.6, §8; `game/scripts/scr_dialogue_data_ch3.gml`, `scr_dialogue_data_ch9.gml`–`scr_dialogue_data_ch11.gml`; absent Alden enemy, capital rooms, ending trigger.  
**Issue:** Alden has 48 dialogue lines across four chapters. He is a sincere friend in Valemere, a sincere ally in Coleford and the barrow, and the man who takes the seal in Chapter 11. There is no scene of his ambition becoming action, no split from Taren, no seizure of the capital, no three-phase boss and no final choice. The name "Alden" has zero references in `scr_enemy_database.gml`, `scr_encounter_tables.gml` or `scr_bestiary.gml`.  
**Why it matters:** Ending C is the one locked ending in the project. It is also the emotional climax of Taren's arc and the political climax of the story. At present the player would experience Alden as a friend who disappears after Act IV, not as a tragic usurper.  
**Recommendation:** Define and build the Alden arc across Acts VI–VIII: at least two scenes of his method becoming ruthless, Taren's first open opposition, the capital seizure after Aldric's defeat, and a three-phase final battle whose phases dramatise the idealist, the commander and the usurper. Keep him sympathetic in every phase.  
**Owner approval:** Yes. This is locked canon and cannot be improvised.

### A-05 — CRITICAL — King Aldric IV never appears and has no defeat

**File / section:** `docs/story/STORY_BIBLE.md` §5.7; all GML.  
**Issue:** `grep -rin "aldric" game/scripts game/objects` returns **zero** matches. Aldric exists only in documentation: ruler of Eldoria, knows the Crownveil is failing, hides the truth, is defeated before Alden takes the capital. There is no palace room, no court, no scene, no boss and no explanation of his motives.  
**Why it matters:** Alden's takeover is defined as happening *after* Aldric falls. Without Aldric, the political conflict has no incumbent, the Crown has no face, and Alden's seizure has nothing to seize.  
**Recommendation:** Decide who defeats Aldric and how. Build the royal capital/palace as an Act VIII location, give Aldric a scene and a motive for the cover-up, and stage his fall before Alden's takeover. Whether the party or Alden lands the final blow is an owner decision with major consequences for Ending C.  
**Owner approval:** Yes.

### A-06 — CRITICAL — Mira's present-day payoff is absent

**File / section:** `docs/story/STORY_BIBLE.md` §5.10; dialogue data across Chapters 1–11.  
**Issue:** Mira's name appears 13 times in Chapter 1, 5 times in Chapter 2, once in Chapter 3, zero times in Chapters 4–7, once in Chapter 8, and zero times in Chapters 9–11. She has no present-day scene, no voice, no body and no answer. The Ashbound parchment says she is alive; the carvings resemble her; the Blackguard says she crossed the Crownveil; the pendant answers the door. None of these leads is paid off.  
**Why it matters:** Kael's stated goal is finding Mira. The central emotional question goes dormant for most of the built game, and the approved Act V scripts deliberately keep her off-screen. Without a planned payoff, the final act has no emotional centre.  
**Recommendation:** Decide by Act VIII whether Mira is alive, changed, dead, or something else, and stage at least one present-day encounter or communication before the final choice. Do not answer the mystery early; schedule the reveal. If the mystery is meant to remain open, say so explicitly and make the ending about Kael's choice rather than a factual answer.  
**Owner approval:** Yes.

### A-07 — CRITICAL — The opening main quest is not implemented

**File / section:** `docs/story/CHAPTER1_SCRIPT.md` §0; `game/scripts/scr_quest_data.gml`; `game/scripts/scr_map_markers_data.gml`; `game/scripts/scr_dialogue_data.gml` `CV_END`; `game/scripts/scr_ch2_story.gml` `scr_ch2_tick`.  
**Issue:** `Q_MAIN_FIND_MIRA` has no entry in `scr_quest_data.gml`. Its nine stages `Q_FM_S1`–`Q_FM_S9` exist only as marker metadata and comments. The marker engine reads `requires_flag`, `script_id` and similar fields but never reads `quest_start` or `quest_advance`. `CV_END` sets `flag_chapter1_complete` but never completes Find Mira or starts Beyond the Veil. `Q_MAIN_BEYOND_VEIL` starts in `scr_ch2_tick` after `CV_WAKE`, not at the door.  
**Why it matters:** The first quest in the game is invisible in the journal and never advances or completes. The player receives a "Quest updated: Find Mira → Beyond the Veil" line without either quest changing. This is a break in the main storyline, not a cosmetic omission.  
**Recommendation:** Add `Q_MAIN_FIND_MIRA` with the nine approved stages and descriptions; set its stages from the approved chapter checkpoints; complete it when the Blackguard falls; start `Q_MAIN_BEYOND_VEIL` at `CV_END` and carry `Q_BV_S1` into Chapter 2. Remove the redundant/contradictory quest-change line or make it true.  
**Owner approval:** No for restoring approved quest text; yes if new wording is added.

### A-08 — CRITICAL — There is no ending, epilogue or credits sequence

**File / section:** `docs/story/STORY_BIBLE.md` §8; all GML.  
**Issue:** No script or data contains an ending trigger, ending scene, epilogue, credits roll, final choice or post-finale state. Endings 1–3 are marked **[U] unconfirmed**; Ending C is locked as a concept but has no placement or conditions. `grep -rin "ending|epilogue|credits|finale"` finds only incidental uses (e.g. "ending its part in the fight").  
**Why it matters:** The game cannot conclude. Even a perfect build of Acts V–VIII would stop at the last boss with no denouement, no fate for Mira, Alden, the party, the serfs or the Crownveil.  
**Recommendation:** Before Act VIII is written, decide the ending structure: which of Endings 1–3 remain, how Ending C relates to them, what choices gate them, and what the epilogue must show. Then write the final choice, the Alden confrontation, the Crownveil resolution and a per-character epilogue.  
**Owner approval:** Yes.

### A-09 — HIGH — Act IV has no exit to Act V, and Act VII opens instead

**File / section:** `game/scripts/scr_ch11_markers_data.gml`; `game/scripts/scr_map_markers_data.gml` lines for `crownveil_breach` and `ashlands_broken_structure`.  
**Issue:** `rm_barrow_deep` has one exit, back to `rm_barrow_halls`; the gatehouse has one north exit to Coleford and one south exit to the halls. There is no coast road or Act V doorway. Meanwhile the overworld entrances to `rm_ashlands_breach` and `rm_ashlands_ruins` require only `flag_act4_complete`, so the first content the player can reach after Act IV is Act VII's region, three acts early.  
**Why it matters:** The intended sequence IV→V→VI→VII→VIII is reversed at the one point where the player is most likely to explore. The Ashlands rooms also reveal lore and gear that belong to Act VII without Act V or VI context.  
**Recommendation:** Add the Act V coast exit when Chapters 12–14 are built. Gate the Ashlands entrances on the Act VI completion flag (or hide them until Act VII) and mark the current `flag_act4_complete` gate as a temporary preview, not a story transition.  
**Owner approval:** Yes for progression gating; no for the eventual Act V transition once approved.

### A-10 — HIGH — The Fallen Knight is approved but unresolved

**File / section:** `docs/story/ACT5_OUTLINE.md` §1, §10; `docs/story/CHAPTER14_SCRIPT.md`; `game/scripts/scr_dialogue_data_ch1_extra.gml`, `ch3`, `ch5`; `scr_enemy_database.gml` `fallen_knight_last`.  
**Issue:** The knight has four built sightings and 6 dialogue lines. Act V's approved reveal is that "Fallen Knight" is an **office**, not a man: the Crown sent knights across the Crownveil and counted the ones who came back. The act deliberately does not name him, say whether he is the enemy type, or say what he wants. The identity, history, connection to Kael's family and role in the ending remain open.  
**Why it matters:** The Fallen Knight is the title character of Act V and one of the story's most personal mysteries. An office reveal is a strong middle beat, but it is not a character resolution. If Acts VI–VIII do not return to him, the player never learns who he is or why he followed Kael.  
**Recommendation:** Keep Act V's office reveal, then schedule the personal answer for Act VI or VIII. Decide whether he is one of the eleven, Kael's father, a Crown agent, or a man who chose to come back; do not confirm any of these in Act V. Give him one later scene with Kael and Taren that makes the answer matter.  
**Owner approval:** Yes.

### A-11 — HIGH — Companion arcs and personal quests are missing

**File / section:** `docs/story/STORY_BIBLE.md` §5.2–§5.5, §5.10; `game/scripts/scr_quest_data.gml`.  
**Issue:** None of the five companions has a personal quest. Taren's only non-main arc is his friendship with Alden, which never splits. Lyra's Black Hand debt is raised and dropped. Caelan's knowledge of why the Veil broke is explicitly withheld and never paid off. Sera's palace secret is explicitly refused and never paid off. Kael's middle, late and end arc quotes ("I need to know why this happened", "If I have to sacrifice myself…", "I can't keep losing people…") do not appear in GML; only "I just need to find Mira" does.  
**Why it matters:** The party is the player's main relationship with the story. Four of the five companions currently join, fight and comment, but do not change. The final act will have no earned emotional stakes for them.  
**Recommendation:** Give each companion one personal quest or scene chain, scheduled by act: Taren/Alden and the Yoke; Lyra/Black Hand; Caelan/Aethari and the Engine; Sera/the palace and the Silver Guard; Kael/Mira and the family. Use Kael's approved arc quotes as act milestones, not as optional barks.  
**Owner approval:** Yes for new story content.

### A-12 — HIGH — The Broken Yoke is a name without a political structure

**File / section:** `docs/story/STORY_BIBLE.md` §4; `docs/story/ACT2_OUTLINE.md` §5; dialogue data.  
**Issue:** The Broken Yoke is named in dialogue and on the Wrenfield notice board. Taren is a Rebel Captain; Derry is a contact who will not name a leader; Alden's rank and role are open. There is no founding scene, leader, council, base, hierarchy, suppression campaign or postwar fate. The rebellion has no questline and no NPC beyond Derry and Taren.  
**Why it matters:** Alden's fall is a political tragedy. If the Yoke is only a label, his decision to seize the throne has no movement to betray and the serfs have no agency in their own liberation. The ending cannot show what happens to the rebellion because the rebellion was never dramatised.  
**Recommendation:** Define the Yoke's structure and leadership before Act VI: a council of cells, a field captain (Taren), an ideologue or delegate (Alden), a base or network, and a Crown suppression policy. Add at least one Yoke questline and one scene of the serfs acting for themselves. Show the movement splitting over Alden's method, and show its fate after the final battle.  
**Owner approval:** Yes.

### A-13 — HIGH — “The Ash Veil” is not a defined term in the repository

**File / section:** `docs/story/STORY_BIBLE.md` §2.3–§2.4; `game/scripts/scr_item_data.gml` comment "Act VI — the Ash Veil"; all dialogue.  
**Issue:** The established barrier term is **the Crownveil**; "the Veil" is its shorthand. "The Ash" is the corrupting force. **"Ash Veil"** appears only as an internal comment on Act VI item tiers and is not defined in the bible or any script. The user brief treats "The Ash Veil" as a major established lore term.  
**Why it matters:** Three different concepts — the Crownveil, the Ash, and "the Ash Veil" — can be accidentally merged. The finale's title, **The Ashen Crown**, is a fourth term. Terminology drift is the fastest way to break the mystery.  
**Recommendation:** Ask the owner whether "Ash Veil" is (a) a synonym for the Crownveil, (b) the Ash's region beyond the barrier, (c) a separate phenomenon, or (d) a phrase to retire. Until answered, use **Crownveil** in story text and **the Ash** for the force; do not add "Ash Veil" to canon.  
**Owner approval:** Yes.

### A-14 — HIGH — Documentation status contradicts itself

**File / section:** `docs/story/STORY_BIBLE.md` header and §7; `docs/story/ACT2_OUTLINE.md` header; `docs/story/ACT4_OUTLINE.md` header; `docs/story/ACT5_OUTLINE.md` header; `docs/DECISIONS_AND_OPEN_QUESTIONS.md` region-map section; `docs/GAME_DESIGN_DOCUMENT.md`.  
**Issue:** The bible header calls Chapter 6 **PROPOSED** while `CHAPTER6_SCRIPT.md` says **APPROVED 2026-11-16 — CANON**. The bible's Act III table calls the act **[O] title only** while the act is built. The bible's Act IV heading says **[C-confirmed]** while the outline says the chapters are **not individually approved**. The bible's Act V heading says **[PROPOSED]** while all ten decisions and Chapters 12–14 are approved as story. The bible §7 says the region map is open while the decision log says it is fixed. `ACT2_OUTLINE.md` says Chapter 5's title/levels are still proposed although they were approved on 2026-11-16.  
**Why it matters:** Writers and implementers cannot tell which material is safe to build on. This is how unapproved Act IV story becomes treated as canon by accident.  
**Recommendation:** Do not rewrite history; add dated status notes at the top of each stale section and reconcile the status labels in one pass. Preserve the existing text and decision log. Mark every built-but-unapproved item **PROPOSED** consistently.  
**Owner approval:** No for status corrections; yes for changing any canon designation.

### A-15 — MEDIUM — Two quests skip their decision stage, and one reward item is undefined

**File / section:** `game/scripts/scr_quest_data.gml`; `game/scripts/scr_ch7_story.gml`; `game/scripts/scr_ch9_story.gml`; `game/scripts/scr_item_data.gml`.  
**Issue:** `Q_SIDE_TITHE` defines `Q_ST_S2` ("Decide what to tell Berrin") but only ever sets `Q_ST_S1` before setting the quest complete. `Q_SIDE_LEDGER` defines `Q_SL_S2` ("Decide whether the clerk gets her copy") but only sets `Q_SL_S1` before completing. Separately, `scr_ch7_story.gml` grants `item_cinderhollow_charm` by name/id, but no `scr_item_make("item_cinderhollow_charm", …)` entry exists, so the approved "accessory, DEF +2" reward has no item data.  
**Why it matters:** The journal jumps from "accept" to "complete" without showing the choice stage, and the tithe reward may be an unusable item. Both are visible player-facing defects in built content.  
**Recommendation:** Set `Q_ST_S2` immediately before the tithe choice and `Q_SL_S2` immediately before the clerk choice; complete only after the branch resolves. Add the Cinderhollow Charm item definition with the approved DEF +2 and description. Add a validator check that every quest stage is set somewhere and every granted item id exists.  
**Owner approval:** No; these restore approved text/data.

### A-16 — MEDIUM — Shop tiers unlock Act V–VII gear two acts early

**File / section:** `game/scripts/scr_shop_data.gml` `scr_story_act`, `shop_blackwood_carter`, `shop_ashlands_outpost`.  
**Issue:** `scr_story_act()` returns 6 after Chapter 5, 7 after Act III and 8 after Act IV. Mott's cart (`shop_blackwood_carter`) is wired and carries the Act V and Act VI rows; those rows unlock at story act 6, during Chapter 6 at levels 18–19, while the gear is tuned for levels 24–26. Sarn's Ashlands shop is wired and its Act VII row unlocks at story act 7; the room is reachable after Act IV, so Act VII gear can be bought before Act V.  
**Why it matters:** The intended equipment progression is one of the game's pillars. A level 18 party can buy level 24–26 gear, and a post-Act IV party can buy Act VII gear before the Drowned Coast. This trivialises Acts III–IV and undermines the act structure.  
**Recommendation:** Gate each stock row by the chapter/act that owns it, not by a coarse `scr_story_act` number. Hold the Act V/VI rows until Act V's first shop, and the Act VII row until Act VII. If a stopgap is needed, gate by party level as well as story flag.  
**Owner approval:** Yes — this changes progression and shop design.

### A-17 — MEDIUM — Eight room references are unresolved, including every Act V coast room

**File / section:** `python3 validate_gamemaker.py`; `game/scripts/scr_audio.gml`; `docs/DEVELOPMENT_ROADMAP.md`.  
**Issue:** The validator lists `rm_flooded_ruins`, `rm_frozen_ruins`, `rm_ironspine_mine`, `rm_ironspine_ruins`, `rm_rimehold`, `rm_saltreach`, `rm_saltreach_pier` and `rm_shipwreck` as unresolved. The four coast rooms are Act V's entire location set; the two Ironspine rooms are Act VI; the two Frostwilds rooms are Act VIII. No substitute rooms should be invented.  
**Why it matters:** The unresolved list is the concrete map of missing acts. It also means Act V cannot be built without creating its four rooms, and Act VI/VIII cannot be built without their regions.  
**Recommendation:** Build the rooms act by act, starting with Act V's four. Keep the validator's list as the completion metric; do not “fix” it by deleting references or inventing placeholder rooms. Add the Act VI/VIII rooms only when their outlines are approved.  
**Owner approval:** Yes for new locations; build of approved Act V rooms can proceed with the act.

### A-18 — MEDIUM — Placeholder and unreferenced dialogue needs a review pass

**File / section:** `game/scripts/scr_dialogue_data*.gml`; `tools/audit_chapters.py`.  
**Issue:** The chapter audit reports **no wiring problems** but lists **37 nodes** as unreferenced by a dispatcher. Some are genuine dead drafts (several sign/lore/repeat lines in Chapters 1–4), while others are reached through marker `script_chain`s or battle phase lookups that the tool cannot see. **64** built nodes are marked `PLACEHOLDER` wiring/art-pass lines.  
**Why it matters:** The built chapters contain lines that may never play and lines that are not the approved script. This is normal for a blockout, but it makes “dialogue complete” claims unsafe and complicates a final polish pass.  
**Recommendation:** Classify the 37 nodes into (a) marker/dynamic false positives, (b) intentionally cut lines to delete, and (c) missing markers to place. Replace the 64 placeholders with approved text or mark them clearly as temporary. Do not delete anything until the classification is reviewed.  
**Owner approval:** No for classification; yes for cutting or rewriting approved lines.

### A-19 — MEDIUM — Chapter 8 contradicts Chapter 1 about the pendant

**File / section:** `game/scripts/scr_dialogue_data.gml` `CV_END_02`; `game/scripts/scr_dialogue_data_ch8.gml` `PD_SCENE_04`.  
**Issue:** Chapter 1: "The pendant at Kael's chest grows warm. It is reacting to the door." Chapter 8: "The pendant is warm through the cloth before he has it out of his coat. **It is the first time it has done anything at all.**"  
**Why it matters:** This is a direct contradiction between two approved scenes, and it weakens the Chapter 8 beat: the pendant's answer is a repetition of Chapter 1, not a first event.  
**Recommendation:** Change Chapter 8 to "the first time since the Watchtower" or "the first time it has answered" (owner-approved wording). Do not change Chapter 1.  
**Owner approval:** Yes — both chapters are approved text.

### A-20 — LOW — “Act I — The Ashen Road” is a zone name, not the act title

**File / section:** `docs/story/STORY_BIBLE.md` §6–§7; `docs/story/CHAPTER1_SCRIPT.md` title; `game/scripts/scr_dialogue_data.gml` `CV_END_06`.  
**Issue:** The established act title is **The Night of Ash**. **The Ashen Road** is Zone 1's name. The user brief calls Act I "The Ashen Road".  
**Why it matters:** Using the zone name as the act title will produce inconsistent cards, trackers and marketing copy.  
**Recommendation:** Keep **The Night of Ash** as the act title and **The Ashen Road** as the zone name. If the owner wants to retitle the act, do it once, everywhere, with approval.  
**Owner approval:** Yes for a retitle; no for keeping the established distinction.

---

## 6. What is intentionally mysterious — do not “fix” these

The following are deliberate unknowns, not audit failures. The defect is the **absence of a scheduled reveal**, not the absence of an answer.

- The true nature and origin of the Ash.
- What the Crownveil was built to keep in.
- What lies beyond the Crownveil.
- What happened to the Aethari.
- Why the carvings resemble Mira.
- What happened when Mira opened the door.
- Mira's current fate.
- The Fallen Knight's identity and whether he is one of the eleven.
- What Sera saw in the palace.
- What Caelan knows about why the Veil broke.
- The meaning of “Then everything stops.”
- The meaning of “the Night of Ash” as an event.
- Why the royal banner bears the crown-around-a-black-sun.
- Who sent the Ashbound Hunter and the parchment.
- What the Ashen Crown actually is.
- Who or what the Ash King is.
- Which of Endings 1–3 are final, and how Ending C relates to them.

The audit recommends **scheduling** these answers, not inventing them in a report. See `LORE_QUESTIONS_AND_CANON.md`.

---

## 7. What is not a defect

- **No GameMaker compile or playtest.** The repository has never been opened in the IDE. “Built” in this audit means source/data only. This is a verification gap, not proof of a bug.
- **Blockout rooms and placeholder sprites.** The Blackwood, Valemere, the Hollow Sanctuary, the barrow and the Ashlands use placeholder tilesets and reused NPC sprites. This is art debt, not a story defect.
- **Data-only Act V enemies.** The seven enemies, the Drowned Coast table and the three boss groups are tuned by simulation, not playtested. Their numbers are placeholders.
- **Unconfirmed Endings 1–3.** They are candidates, not cut content. The audit does not treat their absence as a continuity error.
- **Chapter 1's destroyed Greyhaven is not played.** That is an approved owner decision, not a missing flashback.
- **Sera's and Caelan's refusals to explain.** Those are deliberate characterisation and mystery, not missing dialogue.

---

## 8. Recommended order of work

1. **Owner decisions first.** Resolve the canon questions that block structure: Act I title, Ash Veil term, region map status, Ending C's relation to Endings 1–3, who defeats Aldric, and whether Mira is answered or deliberately left open.
2. **Fix the opening quest.** Add `Q_MAIN_FIND_MIRA`, set its stages, complete it at the Blackguard, start `Q_MAIN_BEYOND_VEIL` at `CV_END`, and remove the false quest-change line.
3. **Fix built-content defects.** `Q_ST_S2`, `Q_SL_S2`, the Cinderhollow Charm item, the Chapter 8 pendant line, and the shop/Ashlands gating.
4. **Build Act V.** Rooms, markers, dialogue data, story scripts, `Q_MAIN_FALLEN`, `Q_SIDE_TOLL`, the conditional Alden letter and the Act VI exit.
5. **Write Act VI–VIII and finale outlines.** One page each, with chapter titles, levels, regions, dungeons, bosses, quests, companion focus, lore answers and transitions.
6. **Write the companion arcs and the Alden turn.** These are the emotional load-bearing walls; they cannot be left to the final act.
7. **Write the ending structure and epilogue.** Decide which endings exist, how they branch, and what the player sees after the final battle.
8. **Then build, in act order, with playtests at each act boundary.** Do not build Act VII before Act V/VI simply because three rooms already exist.

---

## 9. Limitations

- No GameMaker IDE, compiler or runtime was available. No chapter, boss, transition or save was played.
- No browser or visual inspection was used; this is a source/document audit.
- Act V–VIII cannot be tested because they are not implemented.
- Some “unreferenced” dialogue may be reached through dynamic battle or marker paths the static audit cannot see. The audit labels those as review items, not dead content.
- The repository contains many pre-existing uncommitted changes. This audit added only the six new documents under `docs/story/` and did not modify game files or existing canon.
- The story bible's status labels are internally inconsistent; this audit uses the most specific approved decision and says so where the labels conflict.

---

## 10. Companion documents

- `STORY_MISSING_CONTENT.md` — everything that needs to be written, expanded or implemented.
- `CHARACTER_COMPLETION_TRACKER.md` — every character and their remaining requirements.
- `LORE_QUESTIONS_AND_CANON.md` — established canon, unresolved mysteries, proposed options and approval items.
- `EIGHT_ACT_COMPLETION_TRACKER.md` — chapter-by-chapter completion state for all eight acts and the finale.
- `STORY_CONTINUITY_REPORT.md` — contradictions, timeline issues, broken arcs, documentation drift and unverified implementation.

---

**Bottom line:** ASHEN CROWN is not a story that needs replacing. It is a story that stops at Chapter 11, with a strong approved Act V waiting to be built, and three acts plus a finale that have not been outlined. The canon is coherent enough to finish; the missing work is substantial, specific and now enumerated.
