# ASHEN CROWN — Eight-Act Completion Tracker

**Audit date:** 2026-11-18  
**Scope:** Every act, every chapter, every transition and the finale.  
**Status:** Audit only. No game content was changed.

**Important structural note:** the story bible treats the main story as **eight acts** plus a separate finale, **The Ashen Crown**. This tracker preserves that distinction. If the owner intends the finale to be Act VIII, that is a structural decision that must be made explicitly; this document does not collapse the two.

---

## 1. Structure at a glance

| Act | Title | Chapters | Region | Outline | Story | Implementation | Playable |
|---|---|---|---|---|---:|---|---|
| **I** | **The Night of Ash** | 1 | Greyhaven / The Ashen Road (Zone 1) | Complete | Approved | 114 dialogue nodes; rooms, boss, quests partial | **No** |
| **II** | **The Broken Crown** | 2–5 | Eldoria / Valemere / Wrenfield / Hollow Sanctuary / Blackwood Road Garrison | Complete | Approved | 523 dialogue nodes; rooms, bosses, quests | **No** |
| **III** | **The Blackwood** | 6–8 | Blackwood | Complete | Ch6 approved; Ch7–8 built unapproved | 139 dialogue nodes; 5 rooms; 3 bosses | **No** |
| **IV** | **The Forgotten King** | 9–11 | Coleford / barrow field | Complete | Decisions approved; chapters built unapproved | 235 dialogue nodes; 4 rooms; 3 bosses | **No** |
| **V** | **The Fallen Knight** | 12–14 | Drowned Coast / Saltreach | Approved | Approved | **0 of 638 nodes; 0 rooms** | **No** |
| **VI** | **Beneath the Mountains** | — | Ironspine | **None** | **None** | 0 | **No** |
| **VII** | **The Ashlands** | — | Ashlands | **None** | **None** | 3 standalone rooms; no story | **No** |
| **VIII** | **The Truth** | — | Frostwilds / Rimehold | **None** | **None** | 1 standalone armoury room; no story | **No** |
| **Finale** | **The Ashen Crown** | — | Capital / unknown | **None** | **None** | 0 | **No** |

**Act I title note:** the user brief calls Act I "The Ashen Road." The repository's established act title is **The Night of Ash**; **The Ashen Road** is Zone 1's name. See `STORY_CONTINUITY_REPORT.md` D-03.

---

## 2. Chapter-by-chapter table

| Act | Ch. | Title | Level band | Script | Dialogue data | Quests | Key flags | Rooms | Boss | Transition | Approval | Playtest |
|---|---|---:|---|---:|---|---|---|---|---|---|---|---|
| I | 1 | The Night of Ash | 1–7 | `CHAPTER1_SCRIPT.md` | 114 (92 + 22 extra) | `Q_FM` **missing**; `Q_SIDE_RENN` | `flag_chapter1_complete` | Greyhaven (5 interiors), overworld, Old Watchtower, Basement | Blackguard | **Yes** → Ch2 | Approved | No |
| II | 2 | The Weight of the Yoke | 8–10 | `CHAPTER2_SCRIPT.md` | 122 | `Q_BV`; `Q_SIDE_ODA` | `flag_act2_started`, `flag_execution_stopped`, `flag_taren_recruited` | Millhaven Road, Wrenfield, Bent Post, store; Watchtower backtrack | Reeve Calder | **Yes** → Ch3 | Approved | No |
| II | 3 | Crowns and Alleys | 10–13 | `CHAPTER3_SCRIPT.md` | 149 | `Q_BV`; `Q_SIDE_PARCEL` | `flag_scholar_notes`, `flag_lyra_recruited` | Valemere Road, Valemere, Salt Lamp, warehouse | The Debtman | **Yes** → Ch4 | Approved | No |
| II | 4 | The Old Name | 13–16 | `CHAPTER4_SCRIPT.md` | 101 | `Q_BV` | `flag_aethari_name_learned`, `flag_caelan_recruited` | Hollow Approach, Hollow Sanctuary | Sanctuary Warden | **Yes** → Ch5 | Approved | No |
| II | 5 | The Deserted Oath | 16–18 | `CHAPTER5_SCRIPT.md` | 151 | `Q_BV` | `flag_hailen_yields`, `flag_sera_recruited`, `flag_chapter5_complete`, `flag_act2_complete` | Blackwood Road Garrison, Garrison Keep | Commander Hailen | **Yes** → Ch6 | Approved | No |
| III | 6 | The Green Silence | 18–19 | `CHAPTER6_SCRIPT.md` | 55 | `Q_BV` complete; `Q_MBW`; `Q_SIDE_TITHE` hook | `ch6_entered`, `ch6_tithe_hook` | Blackwood Deep, Cinderhollow | Burn-Line Hulk | **Yes** → Ch7 | Approved | No |
| III | 7 | The Share | 19–20 | `CHAPTER7_SCRIPT.md` | 50 | `Q_MBW`; `Q_SIDE_TITHE` | `ch7_tithe_refused`/`paid` | Blackwood Shrine, Glade | Blackwood Matriarch | **Yes** → Ch8 | **Built, unapproved** | No |
| III | 8 | The Door in the Wood | 20 | `CHAPTER8_SCRIPT.md` | 34 | `Q_MBW` | `ch8_pendant_answered`, `flag_act3_complete` | Blackwood Doors | Door Warden | **Yes** → Ch9 | **Built, unapproved** | No |
| IV | 9 | The Crown's Ledger | 21 | `CHAPTER9_SCRIPT.md` | 106 | `Q_MBW` complete; `Q_MC`; `Q_SIDE_LEDGER` | `ch9_page_copied`/`kept`, `ch9_shop_discount` | Coleford (`rm_town`) | Magistrate Vell | **Yes** → Ch10 | **Built, unapproved** | No |
| IV | 10 | The Barrow Road | 22 | `CHAPTER10_SCRIPT.md` | 48 | `Q_MC` | `ch10_gate_seen` | Barrow Gate | Barrow Warden | **Yes** → Ch11 | **Built, unapproved** | No |
| IV | 11 | The Forgotten King | 23 | `CHAPTER11_SCRIPT.md` | 81 | `Q_MC` complete | `ch11_seal_alden`/`party`, `flag_act4_complete` | Barrow Halls, Barrow Deep | Forgotten King | **No** → Act V | **Built, unapproved** | No |
| V | 12 | The Salt Toll | 24 | `CHAPTER12_SCRIPT.md` | **198 scripted / 0 implemented** | `Q_MF`; `Q_ST` | `ch12_*` (unbuilt) | **None** (`rm_saltreach` missing) | Toll-Keeper (data only) | **No** → Ch13 | **Approved, unbuilt** | No |
| V | 13 | What the Tide Kept | 25 | `CHAPTER13_SCRIPT.md` | **256 scripted / 0 implemented** | `Q_MF` | `ch13_*` (unbuilt) | **None** (`rm_saltreach_pier`, `rm_flooded_ruins` missing) | Saltreach Leviathan (data only) | **No** → Ch14 | **Approved, unbuilt** | No |
| V | 14 | The Knight Who Came Back | 26 | `CHAPTER14_SCRIPT.md` | **184 scripted / 0 implemented** | `Q_MF` | `ch14_*` (unbuilt) | **None** (`rm_shipwreck` missing) | Fallen Knight (data only) | **No** → Act VI | **Approved, unbuilt** | No |
| VI | — | Beneath the Mountains | — | **None** | 0 | 0 | 0 | `rm_ironspine_mine`, `rm_ironspine_ruins` missing | 0 | **No** | **Title only** | No |
| VII | — | The Ashlands | — | **None** | 0 | 0 | 0 | 3 built rooms | 0 | **No** | **Title only** | No |
| VIII | — | The Truth | — | **None** | 0 | 0 | 0 | `rm_rimehold` (armoury only), `rm_frozen_ruins` missing | 0 | **No** | **Title only** | No |
| Finale | — | The Ashen Crown | — | **None** | 0 | 0 | 0 | 0 | 0 | **Ends the game** | **Title only** | No |

**Dialogue total:** 1,026 defined ids (1,011 structured nodes plus 15 legacy dispatcher case labels); 638 approved Act V ids unbuilt.

---

## 3. The twelve audit questions, act by act

### 3.1 Act I — The Night of Ash

| # | Question | Answer |
|---|---|---|
| 1 | Is the outline complete? | **Yes.** Zone 1's route, bosses, quests and clues are detailed in `STORY_BIBLE.md` §6 and `CHAPTER1_SCRIPT.md`. |
| 2 | Is the story written? | **Yes.** Chapter 1 is approved canon. |
| 3 | Are chapter scripts present? | **Yes.** `CHAPTER1_SCRIPT.md`. |
| 4 | Are dialogue nodes implemented? | **Yes, 114 nodes.** All scripted ids resolve; 37 audit-wide unreferenced nodes include several Chapter 1 signs (review list). |
| 5 | Are quests implemented? | **No, not fully.** `Q_MAIN_FIND_MIRA` is absent; `Q_SIDE_RENN` works; `Q_MAIN_BEYOND_VEIL` starts in Chapter 2, not at `CV_END`. |
| 6 | Are story flags implemented? | **Yes** for `flag_chapter1_complete`, pendant, banner, Blackguard, FK; **no** for the Find Mira quest state. |
| 7 | Are characters introduced correctly? | **Yes.** Kael, Tomas, Pell, Hob, Ilse, Marda, Wenna, Dov, Corwin, Renn, the Blackguard and the Fallen Knight are established. Elira is absent. |
| 8 | Are important events missing? | The opening quest; the quest transition; Elira's fate; Tomas's death/recovery; the parchment follow-up; the Crownveil Fragment's purpose; the Blackguard's identity. |
| 9 | Are locations and transitions implemented? | **Yes.** Greyhaven, farmlands, Hunter's Camp, Old Road, Bandit Camp, Watchtower, Basement, arena; exit back to the overworld and the Chapter 2 road. |
| 10 | Is the act playable? | **No verified playability.** Built, never compiled or played. |
| 11 | Does it connect to Act II? | **Yes.** The backtrack through the Watchtower and the Millhaven Road entrance (`flag_act2_started`) connect. |
| 12 | Does it preserve canon? | **Yes**, except the missing opening quest and the Chapter 8 pendant contradiction (later act). |

**Missing to complete Act I:** `Q_MAIN_FIND_MIRA`; quest transition; Elira/Tomas closure; parchment/Fragment payoff; Blackguard identity; classify unused sign nodes.

---

### 3.2 Act II — The Broken Crown

| # | Question | Answer |
|---|---|---|
| 1 | Is the outline complete? | **Yes.** `ACT2_OUTLINE.md` covers four chapters, four recruits, four bosses and the aftermath. |
| 2 | Is the story written? | **Yes.** Chapters 2–5 are approved canon. |
| 3 | Are chapter scripts present? | **Yes.** `CHAPTER2_SCRIPT.md`–`CHAPTER5_SCRIPT.md`. |
| 4 | Are dialogue nodes implemented? | **Yes, 523 nodes.** All scripted ids resolve; 64 placeholder cases audit-wide, 25 of them in Act II. |
| 5 | Are quests implemented? | **Yes** for `Q_BV`, `Q_SIDE_ODA` and `Q_SIDE_PARCEL`; no companion quests. |
| 6 | Are story flags implemented? | **Yes** for recruitment, Calder, Hailen, execution, act completion. |
| 7 | Are characters introduced correctly? | **Yes.** Taren, Lyra, Caelan, Sera, Alden, Calder, Oda, Bram, Nim, Derry, Hailen, the Debtman and the supporting cast are established. |
| 8 | Are important events missing? | The Yoke's structure; Alden's backstory/rank; Millhaven; the childhood friendship; companion interiors; the later payoffs for Sera, Caelan and Lyra; Calder/Hailen/Debtman aftermath. |
| 9 | Are locations and transitions implemented? | **Yes.** Wrenfield, Valemere, Salt Lamp, warehouse, Hollow Sanctuary, garrison, keep; Act II→III handoff. |
| 10 | Is the act playable? | **No verified playability.** Built, never compiled or played. |
| 11 | Does it connect to Act III? | **Yes.** `rm_blackwood_deep` via the Ch5 handoff. |
| 12 | Does it preserve canon? | **Yes.** The approved recruitment order, titles, levels and bosses are intact. |

**Missing to complete Act II:** Yoke structure/Alden rank; Millhaven/childhood scene; companion interiority; secret payoffs setup; Hailen/Calder/Debtman aftermath.

---

### 3.3 Act III — The Blackwood

| # | Question | Answer |
|---|---|---|
| 1 | Is the outline complete? | **Yes.** `ACT3_OUTLINE.md` has three chapters, five rooms, three bosses and ten decisions. |
| 2 | Is the story written? | **Partial.** Chapter 6 is approved; Chapters 7–8 are written and built but not individually approved. |
| 3 | Are chapter scripts present? | **Yes.** `CHAPTER6_SCRIPT.md`–`CHAPTER8_SCRIPT.md`. |
| 4 | Are dialogue nodes implemented? | **Yes, 139 nodes** (55 + 50 + 34). All scripted ids resolve; 20 placeholders in Act III. |
| 5 | Are quests implemented? | **Yes** for `Q_MBW`; `Q_SIDE_TITHE` works but skips `Q_ST_S2`; the Cinderhollow Charm lacks item data. |
| 6 | Are story flags implemented? | **Yes** for act entry, tithe, Matriarch, Door Warden, pendant, act completion. |
| 7 | Are characters introduced correctly? | **Yes.** Berrin, the burners, the child, the Matriarch, the Lost Ones, the Door Warden and the Fallen Knight's absence are consistent. |
| 8 | Are important events missing? | Chapter 7–8 approval; the later tithe consequence; the charm item; the Lost Ones' origin; the Door Warden's builders. |
| 9 | Are locations and transitions implemented? | **Yes.** Deep wood, Cinderhollow, shrine, glade, doors; Act III→IV exit to Coleford. |
| 10 | Is the act playable? | **No verified playability.** Built, never compiled or played. |
| 11 | Does it connect to Act IV? | **Yes.** `rm_blackwood_doors` → `rm_town`. |
| 12 | Does it preserve canon? | **Partial.** Chapter 6 is canon; Chapters 7–8 are proposed. The pendant line contradicts Chapter 1. |

**Missing to complete Act III:** Chapter 7–8 approval; `Q_ST_S2`; Cinderhollow Charm item; promised tithe line; Lost Ones/Door Warden lore decision; Chapter 8 pendant line.

---

### 3.4 Act IV — The Forgotten King

| # | Question | Answer |
|---|---|---|
| 1 | Is the outline complete? | **Yes.** `ACT4_OUTLINE.md` has three chapters, four rooms, three bosses, two quests and the seal branch. |
| 2 | Is the story written? | **Partial.** All ten decisions approved; all three chapters written and built, but **not individually approved**. |
| 3 | Are chapter scripts present? | **Yes.** `CHAPTER9_SCRIPT.md`–`CHAPTER11_SCRIPT.md`. |
| 4 | Are dialogue nodes implemented? | **Yes, 235 nodes** (106 + 48 + 81). All scripted ids resolve; 19 placeholders in Act IV. |
| 5 | Are quests implemented? | **Yes** for `Q_MC` and `Q_SIDE_LEDGER`; `Q_SL_S2` is skipped; the promised Act V line is absent. |
| 6 | Are story flags implemented? | **Yes** for Vell, page, Alden, seal, act completion; `ch11_seal_*` has no downstream consumer. |
| 7 | Are characters introduced correctly? | **Yes.** Alden, Vell, Nessa, the Barrow Warden and the Forgotten King are established; the King has no spoken dialogue. |
| 8 | Are important events missing? | Chapter approval; the King's identity; the charter sign-off; the seal's consequence; the Act V exit; the promised ledger line. |
| 9 | Are locations and transitions implemented? | **Partial.** Coleford, barrow gate, halls and deep are built; **no Act V transition**. |
| 10 | Is the act playable? | **No verified playability.** Built, never compiled or played. |
| 11 | Does it connect to Act V? | **No.** There is no coast road, Act V doorway or next objective. |
| 12 | Does it preserve canon? | **Partial.** The act's proposed identity/charter are built but unapproved. |

**Missing to complete Act IV:** chapter approval; King identity; charter sign-off; seal consequence; Act V exit; `Q_SL_S2`; Act V line; Alden battle presence.

---

### 3.5 Act V — The Fallen Knight

| # | Question | Answer |
|---|---|---|
| 1 | Is the outline complete? | **Yes.** `ACT5_OUTLINE.md` has three chapters, four rooms, three bosses, two quests, the seal branch and ten approved decisions. |
| 2 | Is the story written? | **Yes.** Chapters 12–14 are approved as story. |
| 3 | Are chapter scripts present? | **Yes.** `CHAPTER12_SCRIPT.md`–`CHAPTER14_SCRIPT.md`. |
| 4 | Are dialogue nodes implemented? | **No.** 638 scripted ids, **0 GML nodes**. |
| 5 | Are quests implemented? | **No.** `Q_MAIN_FALLEN` and `Q_SIDE_TOLL` have no rows. |
| 6 | Are story flags implemented? | **No.** No `scr_ch12`/`13`/`14` scripts; the seal flags have no consumer. |
| 7 | Are characters introduced correctly? | **Script only.** Ilsa Fen, the Fisher, Maelin Orr, the Toll-Keeper, the Leviathan and the knight are approved but unbuilt. |
| 8 | Are important events missing? | The entire act: Saltreach, the toll, the record hall, the eleven, the wreck, the yield, the office reveal, the token, the Act VI exit. |
| 9 | Are locations and transitions implemented? | **No.** Four rooms missing; no Act V→VI transition. |
| 10 | Is the act playable? | **No.** Not implemented. |
| 11 | Does it connect to Act VI? | **No.** No exit, no Act VI content. |
| 12 | Does it preserve canon? | **Yes as approved story**, but the bible still labels it PROPOSED; no implementation to verify. |

**Missing to complete Act V:** every implementation layer. This is the next content milestone.

---

### 3.6 Act VI — Beneath the Mountains

| # | Question | Answer |
|---|---|---|
| 1 | Is the outline complete? | **No.** No `ACT6_OUTLINE.md`. |
| 2 | Is the story written? | **No.** |
| 3 | Are chapter scripts present? | **No.** |
| 4 | Are dialogue nodes implemented? | **No.** |
| 5 | Are quests implemented? | **No.** |
| 6 | Are story flags implemented? | **No.** |
| 7 | Are characters introduced correctly? | **No characters.** |
| 8 | Are important events missing? | The entire act: Ironspine, the Aethari city/Engine, Caelan's arc, the Crownveil's failure, a boss, a transition. |
| 9 | Are locations and transitions implemented? | **No.** `rm_ironspine_mine`, `rm_ironspine_ruins` unresolved; no transition. |
| 10 | Is the act playable? | **No.** |
| 11 | Does it connect to Act VII? | **No.** |
| 12 | Does it preserve canon? | **N/A** — no content. |

**Missing to complete Act VI:** everything. Start with an approved outline.

---

### 3.7 Act VII — The Ashlands

| # | Question | Answer |
|---|---|---|
| 1 | Is the outline complete? | **No.** No `ACT7_OUTLINE.md`. |
| 2 | Is the story written? | **No.** |
| 3 | Are chapter scripts present? | **No.** |
| 4 | Are dialogue nodes implemented? | **No chapter dialogue**; only Sarn's four trader lines and lore markers. |
| 5 | Are quests implemented? | **No.** |
| 6 | Are story flags implemented? | **No** act flags; the rooms open on `flag_act4_complete`. |
| 7 | Are characters introduced correctly? | **Sarn only**, code-only; no Ash King, no Yoke leader, no act cast. |
| 8 | Are important events missing? | The entire act: the Ashlands story, the Ash King, the breach choice, the Yoke/Alden rupture, a boss, a transition. |
| 9 | Are locations and transitions implemented? | **Partial.** Three rooms built (`rm_ashlands_breach`, `rm_ashlands_ruins`, `rm_ashlands_depths`), but no act transition and the overworld entrances open too early. |
| 10 | Is the act playable? | **No story**, though the rooms are walkable in source. |
| 11 | Does it connect to Act VIII? | **No.** |
| 12 | Does it preserve canon? | **N/A** — the rooms are built ahead of the story and are not canon. |

**Missing to complete Act VII:** an outline, chapters, quests, characters, the Ash King, a boss, a transition and a gate that does not open in Act IV.

---

### 3.8 Act VIII — The Truth

| # | Question | Answer |
|---|---|---|
| 1 | Is the outline complete? | **No.** No `ACT8_OUTLINE.md`. |
| 2 | Is the story written? | **No.** |
| 3 | Are chapter scripts present? | **No.** |
| 4 | Are dialogue nodes implemented? | **No.** |
| 5 | Are quests implemented? | **No.** |
| 6 | Are story flags implemented? | **No.** |
| 7 | Are characters introduced correctly? | **No.** Aldric IV, the Ash King, the Frostwilds civilization and the capital cast are absent. |
| 8 | Are important events missing? | The entire act: Rimehold, the frozen ruins, the Crownveil truth, Mira, Aldric's fall, Alden's takeover, the final choice setup. |
| 9 | Are locations and transitions implemented? | **No.** `rm_rimehold` is an armoury-only room; `rm_frozen_ruins` is unresolved; no palace; no transition. |
| 10 | Is the act playable? | **No.** |
| 11 | Does it connect to the finale? | **No.** |
| 12 | Does it preserve canon? | **N/A** — no content. |

**Missing to complete Act VIII:** everything. Start with an approved outline and the Aldric/Alden decisions.

---

### 3.9 Finale — The Ashen Crown

| # | Question | Answer |
|---|---|---|
| 1 | Is the outline complete? | **No.** |
| 2 | Is the story written? | **No.** |
| 3 | Are chapter scripts present? | **No.** |
| 4 | Are dialogue nodes implemented? | **No.** |
| 5 | Are quests implemented? | **No.** |
| 6 | Are story flags implemented? | **No.** |
| 7 | Are characters introduced correctly? | **No.** Alden's final form, the Ashen Crown, the entity and the ending cast are absent. |
| 8 | Are important events missing? | The meaning of the Ashen Crown; Alden's three-phase boss; the Taren confrontation; the Crownveil/Ash resolution; Mira; the final choice; the epilogue; credits. |
| 9 | Are locations and transitions implemented? | **No.** No finale room, no ending trigger. |
| 10 | Is the finale playable? | **No.** |
| 11 | Does it conclude the story? | **No.** |
| 12 | Does it preserve canon? | **N/A** — no content; Ending C is locked but unbuilt. |

**Missing to complete the finale:** everything. This is the ending; nothing can substitute for it.

---

## 4. Transition matrix

| From | To | Status | Evidence / blocker |
|---|---|---|---|
| I | II | **Working in data** | Backtrack through Watchtower; `flag_act2_started` opens Millhaven Road; `CV_WAKE` starts `Q_BV`. |
| II | III | **Working in data** | Ch5 `to_blackwood` → `rm_blackwood_deep`. |
| III | IV | **Working in data** | Ch8 `to_town` → `rm_town`. |
| **IV** | **V** | **Missing** | No coast exit; `rm_barrow_deep` only returns to halls; no Act V rooms. |
| **V** | **VI** | **Missing** | Act V unbuilt; no Ironspine transition. |
| **VI** | **VII** | **Missing** | Act VI absent; Ashlands rooms open early instead. |
| **VII** | **VIII** | **Missing** | Act VII absent; no Frostwilds transition. |
| **VIII** | **Finale** | **Missing** | Act VIII absent; no ending trigger. |

**Why it matters:** Four of seven act boundaries are missing. The campaign is a four-act chain with a dead end, not an eight-act chain.

---

## 5. Region and room coverage

| Region | Act(s) | Built rooms | Missing rooms | Notes |
|---|---|---|---|---|
| **Greyhaven / The Ashen Road** | I | Overworld, 5 Greyhaven interiors, Old Watchtower, Basement | — | Zone 1 complete |
| **Eldoria / Valemere** | II | Valemere Road, Valemere, Salt Lamp, warehouse | Palace/Royal District interior (VIII/finale) | Capital is a hub, not a full city |
| **Wrenfield / Millhaven Road** | II | Millhaven Road, Wrenfield, Bent Post, store | Millhaven itself (optional) | Taren's hometown is a road sign |
| **Hollow Sanctuary** | II | Approach, Sanctuary | — | Complete dungeon |
| **Blackwood Road Garrison** | II | Garrison, Keep | — | Blockout |
| **Blackwood** | III | Deep, Hollow, Shrine, Glade, Doors | — | 5 rooms; blockouts |
| **Coleford / Barrow** | IV | Town, Gate, Halls, Deep | — | 4 rooms; blockouts |
| **Drowned Coast** | V | **0** | Saltreach, Pier, Flooded Ruins, Shipwreck | Four unresolved refs |
| **Ironspine** | VI | **0** | Mine, Ruins | Two unresolved refs |
| **Ashlands** | VII | Breach, Ruins, Depths | — | 3 rooms; no story; open too early |
| **Frostwilds** | VIII | Armoury only | Rimehold, Frozen Ruins | One unresolved ref (`rm_frozen_ruins`) |
| **Finale** | Finale | **0** | Final dungeon/room | No name, no content |

**Counts:** 34 built rooms; 8 unresolved references; 0 playtested.

---

## 6. Quest coverage by act

| Act | Main quest | Side quests | Missing |
|---|---|---|---|
| I | `Q_FM` **missing**; `Q_BV` starts in II | `Q_SIDE_RENN` | `Q_FM`; transition |
| II | `Q_BV` | `Q_SIDE_ODA`, `Q_SIDE_PARCEL` | Companion quests; Yoke questline |
| III | `Q_MBW` | `Q_SIDE_TITHE` (stage bug; missing item) | Chapter 7–8 approval; later tithe line |
| IV | `Q_MC` | `Q_SIDE_LEDGER` (stage bug; missing Act V line) | Seal consequence; Act V exit |
| V | `Q_MAIN_FALLEN` **missing** | `Q_SIDE_TOLL` **missing** | Entire implementation |
| VI | **Missing** | **Missing** | Entire act |
| VII | **Missing** | **Missing** | Entire act |
| VIII | **Missing** | **Missing** | Entire act |
| Finale | **Missing** | — | Entire finale |

---

## 7. Approval and canon state

| Content | Written | Approved | Built | Canon |
|---|---|---|---|---|
| Chapter 1 | Yes | Yes | Yes | **Canon** |
| Chapters 2–5 | Yes | Yes | Yes | **Canon** |
| Chapter 6 | Yes | Yes | Yes | **Canon** |
| Chapters 7–8 | Yes | **No** | Yes | **Proposed** |
| Chapters 9–11 | Yes | **No** | Yes | **Proposed** (decisions approved) |
| Chapters 12–14 | Yes | **Yes as story** | **No** | Approved story, not bible-canon |
| Acts VI–VIII | **No** | **No** | **No** | Titles only |
| Finale | **No** | **No** | **No** | Title only |

**Why it matters:** “Written,” “approved,” “built” and “playable” are four different states. This table is the honest status.

---

## 8. Critical path to completion

1. **Owner decisions.** Resolve the 20 decisions in `LORE_QUESTIONS_AND_CANON.md` §10, especially Act I title, Ash Veil, Ending C, Aldric, Mira and the Broken Yoke.
2. **Opening quest.** Add `Q_MAIN_FIND_MIRA`, wire its stages, fix `CV_END`, start `Q_BV`.
3. **Built-content fixes.** `Q_ST_S2`, `Q_SL_S2`, Cinderhollow Charm, Chapter 8 pendant line, shop tiers, Ashlands gate.
4. **Act V.** Build all four rooms, 638 nodes, `Q_MF`, `Q_ST`, the seal letter and the Act VI exit.
5. **Act VI outline.** Ironspine, Engine, Caelan, the Crownveil's failure.
6. **Act VII outline.** Ashlands, Ash King, Yoke/Alden rupture.
7. **Act VIII outline.** Frostwilds, Mira, Aldric's fall, Alden's takeover.
8. **Finale outline.** Ashen Crown, three-phase Alden, final choice, epilogue.
9. **Companion arcs and the Alden turn.** Schedule them across V–VIII; do not leave them to the finale.
10. **Build in act order, playtest at each boundary.** Do not build Act VII before V–VI because three rooms exist.

---

## 9. Act-level completion percentages (rough, by deliverable)

These are planning estimates, not quality scores. They count outline/story/script/dialogue/quests/rooms/boss/transition/approval/playtest.

| Act | Estimated completion | Why |
|---|---:|---|
| I | ~85% | Built and approved; missing opening quest, quest transition, family payoffs |
| II | ~90% | Built and approved; missing companion/Yoke depth |
| III | ~80% | Built; Ch7–8 unapproved; two quest defects; lore gaps |
| IV | ~80% | Built; chapters unapproved; no Act V exit; seal payoff missing |
| V | ~35% | Outline + approved scripts + enemy data; zero implementation |
| VI | ~5% | Title + region only |
| VII | ~10% | Title + three rooms + shop; no story |
| VIII | ~5% | Title + region only |
| Finale | ~2% | Title only |

**Overall story completion:** the built acts are strong but unverified; Act V is ready to build; Acts VI–VIII and the finale are not outlined. A rough campaign completion is **~55–60% by content**, **0% by playtest**.

---

## 10. Bottom line

ASHEN CROWN currently has:

- **A complete, approved, built Act I.**
- **A complete, approved, built Act II.**
- **A built Act III with its last two chapters unapproved.**
- **A built Act IV with its three chapters unapproved and no exit.**
- **A fully approved, entirely unbuilt Act V.**
- **Three titles and one region map for Acts VI–VIII.**
- **A title for the finale and no ending.**

The eight-act structure is sound. The missing work is concentrated, not diffuse: one approved act to build, three acts to outline, one finale to write, and a set of character/political payoffs that must be scheduled before the final act. The next honest milestone is a playable Act V, not another Act VII room.
