# ASHEN CROWN — Missing Story Content

**Audit date:** 2026-11-18  
**Purpose:** Everything that needs to be written, expanded or implemented before the eight-act story is complete.  
**Status:** Audit only. No content was added to the game.

This document is deliberately additive. It does not remove or rename anything. Where a recommendation would change approved text or canon, it is marked **owner approval required**.

---

## 1. Missing at a glance

| Category | Present | Missing |
|---|---|---:|
| Acts with a story outline | I–V | **VI, VII, VIII, finale** |
| Chapters with a script | 1–14 | **15 onward** (not numbered in canon) |
| Chapters implemented | 1–11 | **12–14** (approved, zero implementation) |
| Scripted dialogue ids implemented | 1,026 (1,011 structured nodes + 15 legacy case labels) | **638** approved Act V ids; all Act VI–VIII |
| Main quests | 4 (`Q_BV`, `Q_MBW`, `Q_MC`, plus `Q_FIND` absent) | **`Q_MAIN_FIND_MIRA`, `Q_MAIN_FALLEN`, Acts VI–VIII, finale** |
| Side quests | 5 | **`Q_SIDE_TOLL`**, companion quests, Yoke questline, Acts VI–VIII side content |
| Room references resolved | 34 rooms | **8 unresolved**; no coast, Ironspine or Frostwilds room |
| Act V rooms | 0 | **4** (`rm_saltreach`, `rm_saltreach_pier`, `rm_flooded_ruins`, `rm_shipwreck`) |
| Act V bosses | data only | **3 implemented encounters** |
| Alden boss | none | **three-phase Ending C encounter** |
| Aldric IV | none | **appearance, court, defeat** |
| Ash King | item strings only | **definition, appearance, encounter** |
| Endings | none | **final choice, Ending C, possible 1–3, epilogue, credits** |
| Transitions | I→II, II→III, III→IV | **IV→V, V→VI, VI→VII, VII→VIII, VIII→finale** |
| Playtested content | none | **all of it** |

---

## 2. Act-level missing content

### 2.1 Act I — The Night of Ash

**State:** Built and approved; unplayed. One chapter, levels 1–7.

**Missing or incomplete:**

1. **The opening main quest.** `Q_MAIN_FIND_MIRA` is not in `scr_quest_data.gml`. Its nine stages exist only in `CHAPTER1_SCRIPT.md` and marker metadata. The journal has no active quest at game start.
2. **The quest transition.** `CV_END` never completes Find Mira or starts Beyond the Veil; the system line says the quest changed, but only `flag_chapter1_complete` is set.
3. **Elira Varyn.** Kael's mother has no GML reference. The only trace is the environmental line "Mother's table. Split down the middle." Her fate is open.
4. **Tomas's fate.** He passes out and is still unconscious in Chapter 2. He neither wakes nor dies. The emotional beat of leaving him is unresolved.
5. **The Ashbound parchment.** It says Mira is alive and is a guaranteed drop, but no NPC reacts to it and no quest follows it. It is a clue with no next step.
6. **The Crownveil Fragment.** It is granted as a key item after the Blackguard but has no use, description of purpose, or later reference. It is a major artifact with no payoff.
7. **The Blackguard's identity.** He knows Mira and says she crossed the Crownveil, then dies. His name, history, faction and source of knowledge are unresolved.
8. **Sign/lore lines without markers.** Several defined interaction nodes (`GH_GATE_SIGN`, `FL_SIGN_01`, `HC_SIGN_01`, `BC_ENTER_01`, `BC_SIGN_01`) are not placed in the built rooms. Review whether they are cut or missing.
9. **The pendant's Chapter 1 reaction is contradicted in Chapter 8** (see `STORY_CONTINUITY_REPORT.md` F-01).

**Why it matters:** Act I is the promise the rest of the game must pay. The missing quest and the dormant family threads make the opening less guided and less emotionally closed than the script intends.

**Recommendation:** Add the quest row and stage wiring; decide Elira's and Tomas's fates; give the parchment and the Fragment at least one later consumer; classify the unused sign nodes.

**Owner approval:** No for restoring approved quest text; yes for Elira/Tomas/fate decisions and new uses for the Fragment.

---

### 2.2 Act II — The Broken Crown

**State:** Complete, approved, built; unplayed. Chapters 2–5, levels 8–18.

**Missing or incomplete:**

1. **Companion interiority.** Taren, Lyra, Caelan and Sera all join and have strong recruitment scenes, but none has a personal quest or a post-join arc. Their secrets are raised and deferred.
2. **Taren's past.** He is from Millhaven, a childhood friend of Kael and Alden, and a Rebel Captain. Millhaven is a road, not a place. The childhood friendship has no scene.
3. **Lyra's debt.** The Debtman says the debt does not go with the paper and that "they can always find you." No later scene collects on it.
4. **Caelan's knowledge.** He refuses to say why the Veil broke. The refusal is excellent; the payoff is absent.
5. **Sera's palace secret.** She refuses to explain what she saw. The refusal is explicit and in character; the payoff is absent.
6. **The Broken Yoke.** Derry will not name a leader; Taren is a captain; Alden's rank is open. There is no structure, base, founding story or suppression campaign.
7. **Alden's backstory.** He is a friend and a sincere revolutionary, but where he came from, how he met Kael and Taren, and what he does in the Yoke are open.
8. **Hailen's and Calder's aftermath.** Both can yield and live; neither returns. Their survival has no later consequence.
9. **The sealed non-Crown order.** It is the Blackwood lead, but its issuer and seal are not resolved. This may be intentional; it needs a scheduled answer.
10. **No companion-specific side content.** The three side quests are Renn, Oda and Nim's parcel; none develops the party.

**Why it matters:** Act II is the recruitment act. It succeeds at introducing everyone, but it does not yet give the player a reason to care about their futures beyond the main plot.

**Recommendation:** Add one personal scene per companion in Act II or early Act III, then a payoff later. Define the Yoke's structure and Alden's place in it. Use Millhaven for at least one Taren scene.

**Owner approval:** Yes for new character content; no for preserving the existing recruitment scenes.

---

### 2.3 Act III — The Blackwood

**State:** Chapters 6–8 built; Chapter 6 approved, Chapters 7–8 built but not individually approved; unplayed. Levels 18–20.

**Missing or incomplete:**

1. **Individual approval for Chapters 7–8.** Their titles, bosses, tithe choice, level cap change and room list are still **PROPOSED** in `ACT3_OUTLINE.md` §9.
2. **`Q_ST_S2`.** The side quest defines a "Decide what to tell Berrin" stage but never sets it; the journal jumps from S1 to complete.
3. **The Cinderhollow Charm.** `scr_ch7_story.gml` grants `item_cinderhollow_charm`, but no item definition exists. The approved DEF +2 accessory is not a real item.
4. **The tithe's later consequence.** The Chapter 7 script promises a later line about Berrin's household being short a name; no GML reads `ch7_tithe_refused` or `ch7_tithe_paid` after the scene.
5. **The `ch6_tithe_hook` gate.** Chapter 6 sets it, but Chapter 7 does not check it, so the tithe scene can open without the hook. This may be acceptable, but it is not what the script says.
6. **The Lost Ones.** They are a strong image and a lore hook, but their origin and relation to the Matriarch are not explained. This may be intentional; it needs a planned answer or a deliberate silence.
7. **The Door Warden.** Its duty is shown, not explained, which is correct. Its builders, age and relation to the Aethari doors are open.
8. **The Fallen Knight is absent from Act III.** That is intentional and approved; note it so a later writer does not add him.
9. **Act III→IV transition exists** (`rm_blackwood_doors` → `rm_town`) and works in data. No missing transition.

**Why it matters:** Act III is the first act built without a recruit. It carries the mystery and the atmosphere, but its side quest has visible defects and its two newest chapters are not yet canon.

**Recommendation:** Get individual approval for Chapters 7–8; fix the quest stage and charm; add the promised tithe line; decide whether the Lost Ones are explained in Act III or later.

**Owner approval:** Yes for Chapter 7–8 approval; no for the quest/item fixes.

---

### 2.4 Act IV — The Forgotten King

**State:** Decisions approved; all three chapters built but not individually approved; unplayed. Chapters 9–11, levels 21–23.

**Missing or incomplete:**

1. **Individual approval for Chapters 9–11.** The outline says Act IV is still **PROPOSED as story**; the bible heading says **[C-confirmed]**. The chapters need an explicit approval record.
2. **The Forgotten King's identity.** The "king before the Crown's line" and the charter naming the mark **the Crownveil** are proposed, not approved.
3. **The Forgotten King has no dialogue.** He is a silent boss. If that is deliberate, it should be recorded; if not, he needs at least one line or a narrated memory.
4. **The seal's consequence.** `ch11_seal_alden` and `ch11_seal_party` are set, but no downstream script reads them. The approved Act V letter exists only on the Alden branch and is unbuilt.
5. **The Act IV→V transition.** There is no coast road, no Act V doorway and no next objective after the act card.
6. **`Q_SL_S2`.** The ledger side quest defines a "Decide whether the clerk gets her copy" stage but never sets it.
7. **The promised Act V line.** The ledger quest's copy branch is supposed to produce "one line in Act V"; no such line exists in the Act V scripts or data.
8. **Vell and Nessa.** They are built characters and now have dedicated 16×24 overworld sets (2026-11-18), but no portraits. Their roles are complete enough; only the portraits are missing.
9. **Alden's fighting.** He is a scripted ally with no battle slot. The party cannot control him, and his contribution is not a full combat presence.
10. **The barrow gate's south exit.** The gatehouse exits north to Coleford and south to the halls; there is no road south out of the act.

**Why it matters:** Act IV contains the first explicit name for the mark and the first real test of Alden's character. Its unapproved status and missing exit make it a bridge that does not yet land.

**Recommendation:** Approve or revise Chapters 9–11; get a ruling on the Forgotten King's identity and the charter's name; add the Act V exit; wire the seal flags into Act V; fix `Q_SL_S2` and the promised line.

**Owner approval:** Yes for the act's canon status and the King's identity; no for the transition/quest fixes once approved.

---

### 2.5 Act V — The Fallen Knight

**State:** All ten decisions approved 2026-11-16; Chapters 12–14 approved as story (2026-11-17 / 2026-11-18); **zero implementation**. Levels 24–26.

This is the largest ready-to-build block in the project.

**Missing implementation:**

| Item | Required |
|---|---|
| Chapter 12 *The Salt Toll* | `scr_ch12_story.gml`, `scr_dialogue_data_ch12.gml` (198 ids), `scr_saltreach_markers_data.gml`, `rm_saltreach`, `Q_MAIN_FALLEN` S1–S2, `Q_SIDE_TOLL` S1–S2, Ilsa Fen, the Toll-Keeper encounter, the conditional Alden letter |
| Chapter 13 *What the Tide Kept* | `scr_ch13_story.gml`, `scr_dialogue_data_ch13.gml` (256 ids), `scr_saltreach_pier_markers_data.gml`, `scr_flooded_ruins_markers_data.gml`, `rm_saltreach_pier`, `rm_flooded_ruins`, `Q_MF` S3–S4, the eleven-name record, Maelin Orr, the Saltreach Leviathan |
| Chapter 14 *The Knight Who Came Back* | `scr_ch14_story.gml`, `scr_dialogue_data_ch14.gml` (184 ids), `scr_shipwreck_markers_data.gml`, `rm_shipwreck`, `Q_MF` S5–S6, the *Patient Crown*, the Fallen Knight yield, the office reveal, the crossing token, the Act VI exit |
| Shared | Act V quest rows, chapter/act flags, `snd_amb_water`, coast tileset or blockout, boss art, Alden letter branch, save/transition behavior |

**Missing story decisions inside the approved scripts:**

- The knight's identity remains open by design; the act reveals the office, not the man.
- Whether the Crown sent him remains open.
- Whether he is the same as the `fallen_knight` enemy type remains open.
- What the crossing token opens remains open.
- What Alden means by the letter remains open.
- What happened to the ten remains open.
- Whether the drowned civilisation is Aethari remains open.
- Mira and Kael's father stay where canon leaves them.

**Why it matters:** Act V is the only act with a complete approved script and no implementation. Building it is the shortest path to a playable continuation and the necessary bridge to Acts VI–VIII.

**Recommendation:** Build Act V as the next content milestone. Do not add answers the act deliberately withholds. Wire the seal branch and the Act VI exit from the start, so the next act has a landing place.

**Owner approval:** No for implementation; yes for any new line, room or beat not in the approved scripts.

---

### 2.6 Act VI — Beneath the Mountains

**State:** Title only; region fixed to the Ironspine by the Act V decision. No outline, chapter, quest, room, enemy or boss.

**Missing:**

- An act outline with chapter titles, level band, route and dungeon structure.
- The Ironspine hub and at least `rm_ironspine_mine` / `rm_ironspine_ruins`.
- The Aethari underground city/engine revelation and its relation to the Crownveil.
- Caelan's personal arc and the first real answer to "what does he know?"
- A main quest, side quests, NPCs, a boss and a transition to Act VII.
- A level plan that fits under or raises `PARTY_MAX_LEVEL` 27.

**Why it matters:** Act VI is the natural home for the Aethari and the Crown Engine, two of the largest unanswered lore questions. It is also the act that must make Caelan's reticence pay off.

**Recommendation (PROPOSED, not canon):** Use the Ironspine as a descent act: a mining/settler hub, an Aethari ruin, the Engine or its absence, and a first confrontation with the idea that the Crownveil is a container. Keep the Ash King offstage until Act VII.

**Owner approval:** Yes.

---

### 2.7 Act VII — The Ashlands

**State:** Title only; three standalone rooms built (`rm_ashlands_breach`, `rm_ashlands_ruins`, `rm_ashlands_depths`); Sarn's shop and lore text; no chapter, quest, enemy table or boss.

**Missing:**

- An act outline and chapter scripts.
- A story use for the three built rooms and the undercroft shrine.
- The Ash King's definition, first appearance and encounter.
- The fate of the Ashlands, the breach and the people who live at its edge.
- Taren's/Yoke's political climax and Alden's escalation.
- A main quest, side quests, NPCs beyond Sarn, a boss and a transition to Act VIII.
- Act VII gear tuning and encounter tables (currently shop data only).

**Why it matters:** The Ashlands are the most evocative region in the bible and the three rooms already exist. They cannot carry an act by atmosphere alone; the Ash King and the Ash's nature need a story.

**Recommendation (PROPOSED, not canon):** Use the Ashlands as the act where the Ash stops being weather and becomes a presence. Put the Ash King or its herald here, force the party to choose what to do about the breach, and bring the Yoke/Alden conflict to open rupture. Do not answer Mira here unless the outline says so.

**Owner approval:** Yes.

---

### 2.8 Act VIII — The Truth

**State:** Title only; region fixed to the Frostwilds (`rm_rimehold`, `rm_frozen_ruins`); no outline, chapter, quest, enemies or boss. The armoury courtyard `rm_rimehold` is built ahead of the act as a tier-VIII shop stopgap; the rest of Rimehold is not.

**Missing:**

- An act outline and chapter scripts.
- Rimehold and the frozen ruins.
- The Frostwilds' ancient civilisation: Aethari or separate?
- The truth of the Crownveil, the Ash, the Aethari and Mira.
- King Aldric IV's fall and Alden's seizure of the capital.
- The final choice setup and the transition to the finale.
- A boss and a level plan.

**Why it matters:** Act VIII is the convergence act. It must pay off the lore, the political plot and the protagonist's family without collapsing into exposition.

**Recommendation (PROPOSED, not canon):** Use the Frostwilds for the oldest record and the coldest answer, then return to Valemere for Aldric's fall and Alden's takeover. The act should end with the party choosing how to confront Alden, not with the final battle itself.

**Owner approval:** Yes.

---

### 2.9 Finale — The Ashen Crown

**State:** Title only; no outline, scene, boss, ending or epilogue.

**Missing:**

- The meaning of the Ashen Crown.
- The final dungeon/sequence.
- Alden's three-phase boss and the Taren confrontation.
- The Crownveil/Ash resolution.
- Mira's role and the final choice.
- Ending C and the decision about Endings 1–3.
- A per-character epilogue and the fate of the serfs, the Yoke and the Crown.
- Credits.

**Why it matters:** The finale is the ending. Nothing else can substitute for it.

**Recommendation:** Write the ending structure before the finale dungeon. Decide what the Ashen Crown is, what the final choice costs, and what each companion and faction gets in the epilogue. Then build the Alden encounter around the answer.

**Owner approval:** Yes.

---

## 3. Chapter-level missing content

### 3.1 Chapters 1–11 — built chapters

| Chapter | Missing / incomplete content | Priority | Approval |
|---|---|---|---|
| 1 | `Q_MAIN_FIND_MIRA`; quest transition; Elira fate; Tomas closure; parchment follow-up; Fragment purpose; unused sign nodes; Blackguard identity | CRITICAL / HIGH / MEDIUM | Yes for fate/purpose; no for quest wiring |
| 2 | Taren/Millhaven scene; Yoke structure; Alden backstory; companion interiors; Hailen/Calder aftermath | HIGH | Yes |
| 3 | Lyra debt payoff setup; Black Hand context; Nim/Derry aftermath; Alden's Yoke role | HIGH | Yes |
| 4 | Caelan's knowledge payoff setup; Aethari history; sanctuary purpose; notes owner (canon silence) | HIGH | Yes |
| 5 | Sera's palace secret payoff setup; Silver Guard context; Hailen aftermath; sealed order issuer | HIGH | Yes |
| 6 | Approved; `ch6_tithe_hook` gate; Berrin character texture; Lost Ones origin | LOW / MEDIUM | No for gate; yes for lore |
| 7 | Chapter approval; `Q_ST_S2`; Cinderhollow Charm item; post-tithe line; Lost Ones/Matriarch link | MEDIUM | Yes for approval; no for fixes |
| 8 | Chapter approval; pendant contradiction; Door Warden lore; Act III card | MEDIUM / HIGH | Yes for text fix/approval |
| 9 | Chapter approval; `Q_SL_S2`; Nessa/Vell art; Act V line; charter sign-off; Alden's ambition seed | MEDIUM / HIGH | Yes |
| 10 | Chapter approval; Alden battle presence; survey marker texture; Barrow Warden origin | MEDIUM | Yes |
| 11 | Chapter approval; Forgotten King dialogue; seal consequence; Act V exit; act card | HIGH / CRITICAL | Yes |

### 3.2 Chapters 12–14 — approved, unbuilt

| Chapter | Required content | Priority |
|---|---|---|
| 12 *The Salt Toll* | Saltreach, Ilsa Fen, the slate, the Toll-Keeper, the ledger of crossings, the conditional Alden letter, `Q_MF` S1–S2, `Q_ST` S1–S2, `rm_saltreach`, `snd_amb_water` | HIGH |
| 13 *What the Tide Kept* | The pier, the flooded Aethari record hall, the eleven names, Maelin Orr, the Leviathan, `Q_MF` S3–S4, `rm_saltreach_pier`, `rm_flooded_ruins` | HIGH |
| 14 *The Knight Who Came Back* | The *Patient Crown*, the log, the knight's test, the yield, the office reveal, the crossing token, `Q_MF` S5–S6, `rm_shipwreck`, Act VI exit | HIGH |

### 3.3 Chapters 15+ — not numbered in canon

No chapter titles, numbers, levels or scripts exist for Acts VI–VIII. Any numbering in this audit is a planning suggestion, not canon.

---

## 4. Missing character content

The full per-character register is in `CHARACTER_COMPLETION_TRACKER.md`. The major missing scenes:

| Character | Missing scene / payoff | Priority |
|---|---|---|
| Kael | Middle/late/end arc beats; Mira answer; family closure; final choice | CRITICAL |
| Taren | Alden split; Yoke leadership; final confrontation; personal quest | CRITICAL |
| Lyra | Black Hand/debt payoff; personal quest; late-game trust | HIGH |
| Caelan | Aethari/Engine truth; why he hid; personal quest | HIGH |
| Sera | Palace secret; Silver Guard past; personal quest | HIGH |
| Alden | Turn from friend to usurper; takeover; three-phase boss | CRITICAL |
| Aldric IV | Appearance; motive; court; defeat | CRITICAL |
| Fallen Knight | Identity; family connection; role in ending | HIGH |
| Mira | Present-day scene; fate; role in ending | CRITICAL |
| Tomas | Death or recovery; what he knew | HIGH |
| Elira | Fate; one scene or explicit silence | HIGH |
| Broken Yoke | Leader; structure; base; postwar fate | HIGH |
| Ash King | Definition; appearance; encounter | CRITICAL |
| Forgotten King | Approval; name/history; dialogue or deliberate silence | HIGH |
| Blackguard | Identity/history; source of knowledge | HIGH |
| Ilsa Fen | Implementation of approved Chapter 12 role | HIGH |
| Maelin Orr | Implementation of approved Chapter 13 role | HIGH |
| Vell / Nessa | Sprites; minor texture | LOW |
| Sarn | Act VII story role beyond shop | MEDIUM |
| Mott / Berrin / Nim / Derry | Return or aftermath | LOW / MEDIUM |

---

## 5. Missing quests

### 5.1 Current quest data

`game/scripts/scr_quest_data.gml` contains **8** quests:

1. `Q_MAIN_BEYOND_VEIL`
2. `Q_MAIN_BLACKWOOD`
3. `Q_MAIN_CROWN`
4. `Q_SIDE_TITHE`
5. `Q_SIDE_RENN`
6. `Q_SIDE_LEDGER`
7. `Q_SIDE_ODA`
8. `Q_SIDE_PARCEL`

### 5.2 Missing quests

| Quest id | Type | Act | Stages | Giver / source | Status | Why it matters |
|---|---|---|---|---|---|---|
| `Q_MAIN_FIND_MIRA` | Main | I | 9 (`Q_FM_S1`–`S9`) | Opening / Greyhaven | **Missing from data** | The opening quest and the journal's first entry; stages only in comments/markers |
| `Q_MAIN_FALLEN` | Main | V | 6 (`S1`–`S6`) | Chapter 12 | **Missing** | Act V's spine; the knight and the coast |
| `Q_SIDE_TOLL` | Side | V | 2 (`S1`–`S2`) | Saltreach | **Missing** | The slate choice; Act V's only side quest |
| Act VI main | Main | VI | TBD | TBD | **No outline** | The Ironspine/Aethari/Engine act |
| Act VII main | Main | VII | TBD | TBD | **No outline** | The Ashlands/Ash King act |
| Act VIII main | Main | VIII | TBD | TBD | **No outline** | The truth/Aldric/Alden act |
| Finale quest | Main | Finale | TBD | TBD | **No outline** | The Ashen Crown/ending |
| Companion quests (×5) | Side | II–VIII | TBD | Taren, Lyra, Caelan, Sera, Kael | **None** | The party has no personal arcs |
| Broken Yoke questline | Side | II–VIII | TBD | Derry/Taren | **None** | The rebellion has no playable story |
| Act VI–VIII side quests | Side | VI–VIII | TBD | TBD | **None** | The late game has no optional content |

### 5.3 Quest defects in existing data

| Quest | Defect | Priority |
|---|---|---|
| `Q_SIDE_TITHE` | `Q_ST_S2` defined but never set; quest jumps from S1 to complete | MEDIUM |
| `Q_SIDE_LEDGER` | `Q_SL_S2` defined but never set; quest jumps from S1 to complete | MEDIUM |
| `Q_MAIN_FIND_MIRA` | Entire quest absent | CRITICAL |
| `Q_MAIN_BEYOND_VEIL` | Starts in Chapter 2, not at `CV_END`; `CV_END` announces the change early | MEDIUM |
| `Q_SIDE_LEDGER` | Promised "one line in Act V" not implemented | LOW |
| `Q_SIDE_TITHE` | Promised later tithe consequence not implemented | LOW |
| `Q_MAIN_CROWN` | Chapter 9 doc says it is not in quest data; it is | LOW (doc) |

---

## 6. Missing flags and story triggers

| Flag / trigger | Consumer | Status | Why it matters |
|---|---|---|---|
| `quest_Q_MAIN_FIND_MIRA`, `Q_FM_S1`–`S9` | Journal / Chapter 1 | **Missing** | No opening quest state |
| `ch11_seal_alden` | Act V letter | **Set, never read** | The seal choice has no consequence |
| `ch11_seal_party` | Act V letter/absence | **Set, never read** | The other half of the choice has no consequence |
| `ch12_*` flags | Chapter 12 | **No script** | Act V cannot start |
| `ch13_*` / `ch14_*` flags | Chapters 13–14 | **No script** | Act V cannot continue or end |
| `flag_act5_complete` / `chapter14_complete` | Act VI transition | **Missing** | No act boundary |
| `flag_act6_complete` | Act VII transition | **Missing** | No act boundary |
| `flag_act7_complete` | Act VIII transition | **Missing** | No act boundary |
| `flag_act8_complete` / ending flags | Finale/ending | **Missing** | No ending trigger |
| `ch7_tithe_refused` / `ch7_tithe_paid` | Later NPC line | **Set, no consumer** | Choice has no later consequence |
| `ch9_page_copied` / `ch9_page_kept` | Act V line | **Set, no consumer** | Choice has no later dialogue |
| `ch6_tithe_hook` | Chapter 7 gate | **Set, no consumer** | The side quest can open without the hook |
| `flag_hailen_yielded` | Later Hailen content | **Set, no later consumer** | Survival has no payoff |
| `flag_reeve_calder_yielded` / `flag_debtman_yielded` | Later content | **Set, no later consumer** | Mercy has no payoff |
| `flag_vell_yielded` | Later content | **Set, no later consumer** | Mercy has no payoff |

**Note:** Some set-only flags are one-shot "seen" guards and are not defects. The table lists only flags whose narrative payoff is missing or whose absence blocks an act.

---

## 7. Missing rooms and locations

| Location | Act | Status | Notes |
|---|---|---|---|
| `rm_saltreach` | V | **Missing** | Coastal village; unresolved reference |
| `rm_saltreach_pier` | V | **Missing** | Outer pier/reef; unresolved reference |
| `rm_flooded_ruins` | V | **Missing** | Aethari record hall; unresolved reference |
| `rm_shipwreck` | V | **Missing** | The *Patient Crown*; unresolved reference |
| `rm_ironspine_mine` | VI | **Missing** | Ironspine; unresolved reference |
| `rm_ironspine_ruins` | VI | **Missing** | Aethari ruins; unresolved reference |
| `rm_rimehold` | VIII | **Built (armoury only)** | Armoury courtyard and tier-VIII shop; no chapter or settlement content |
| `rm_frozen_ruins` | VIII | **Missing** | Frostwilds ruins; unresolved reference |
| Valemere palace / Royal District interior | VIII/Finale | **Missing** | No room for Aldric's court or Alden's throne |
| Millhaven | II | **Missing** | Taren's hometown; only a road exists |
| Aethari city / Crown Engine site | VI | **Undefined** | No canon name; do not invent one as final |
| Ash King's seat / final dungeon | VII/VIII | **Undefined** | No canon name |
| Finale room | Finale | **Missing** | No Ashen Crown room |
| `rm_ashlands_breach` | VII | Built | 3 rooms exist; no story |
| `rm_ashlands_ruins` | VII | Built | No story |
| `rm_ashlands_depths` | VII | Built | No story |

---

## 8. Missing bosses and enemies

| Boss | Act | Status | Required |
|---|---|---|---|
| Blackguard | I | Implemented | No change |
| Reeve Calder | II | Implemented (yields) | No change |
| The Debtman | II | Implemented (yields) | No change |
| Sanctuary Warden | II | Implemented | No change |
| Commander Hailen | II | Implemented (yield branch) | No change |
| Burn-Line Hulk | III | Implemented | No change |
| Blackwood Matriarch | III | Implemented | No change |
| Door Warden | III | Implemented | No change |
| Magistrate Vell | IV | Implemented (yields) | No change |
| Barrow Warden | IV | Implemented | No change |
| Forgotten King | IV | Implemented (3 phases) | Chapter approval |
| Toll-Keeper | V | **Data only** | Chapter 12 encounter/scene |
| Saltreach Leviathan | V | **Data only** | Chapter 13 encounter/scene |
| Fallen Knight | V | **Data only** | Chapter 14 encounter/yield |
| Act VI boss | VI | **Missing** | Outline + enemy data + scene |
| Act VII boss | VII | **Missing** | Outline + enemy data + scene |
| Act VIII boss | VIII | **Missing** | Outline + enemy data + scene |
| **Alden Marr** | Finale | **Missing** | Three-phase Ending C encounter |
| **King Aldric IV** | VIII | **Missing** | Appearance and defeat |
| **Ash King** | VII/VIII | **Missing** | Definition and encounter |

The bestiary has **43** entries. It contains no Alden, Aldric IV or Ash King row.

---

## 9. Missing endings and epilogue

| Element | Status | Required |
|---|---|---|
| Ending C — The Last Usurper | **Locked concept, no scene** | Alden's takeover, three-phase battle, Taren confrontation, resolution |
| Ending 1 — Restore the Crownveil | **[U] unconfirmed** | Owner decision: keep, cut or redesign |
| Ending 2 — Destroy the Crownveil | **[U] unconfirmed** | Owner decision |
| Ending 3 — Break the Cycle | **[U] unconfirmed** | Owner decision |
| Final choice | **Missing** | What the player chooses, when, and what it costs |
| Mira's fate | **Missing** | Answer or deliberate open ending |
| Alden's fate | **Missing** | Death, exile, imprisonment or mercy |
| Party epilogues | **Missing** | One per companion, reflecting choices |
| Serfs / Broken Yoke | **Missing** | What happens to the rebellion and the freed serfs |
| Crown / Eldoria | **Missing** | Who rules, what remains |
| Crownveil / Ash | **Missing** | What happens to the barrier and the Ash |
| Credits | **Missing** | End-of-game sequence |
| Ending flags/save state | **Missing** | Persist which ending was reached |

---

## 10. Missing dialogue and implementation

| Item | Count / status | Notes |
|---|---|---|
| Act V dialogue ids | **638 approved, 0 implemented** | 198 + 256 + 184 |
| Act VI–VIII dialogue | **0** | No scripts |
| Placeholder dialogue in built chapters | **64** | Wiring/art-pass lines, not approved script |
| Unreferenced dialogue nodes | **37** | Some marker/dynamic false positives; review list |
| Sign/lore nodes without markers | At least 10 | Ch1–4; review before deletion |
| Boss intro scenes for Act V | **0** | Scripts exist; no data |
| Alden confrontation dialogue | **0** | No scene |
| Aldric IV dialogue | **0** | No scene |
| Ash King dialogue | **0** | No scene |
| Ending/epilogue dialogue | **0** | No scene |
| Companion personal quest dialogue | **0** | No quests |

---

## 11. Missing systems and validation

These are not new features for their own sake; they are the minimum needed to keep the story implementable.

1. **Quest-stage validator.** Every stage defined in `scr_quest_data.gml` should be set by at least one script, and every set stage should exist. This would have caught `Q_ST_S2` and `Q_SL_S2`.
2. **Item-id validator.** Every `scr_inventory_add` id should resolve to `scr_item_data.gml`. This would have caught `item_cinderhollow_charm`.
3. **Ending state.** The save schema has flags, but no ending id, no branch record and no post-finale state. Add only when the ending structure is approved.
4. **Choice consequence register.** The tithe, ledger and seal choices need explicit downstream consumers. A small table in the story docs would make the promises visible.
5. **Act transition checklist.** Every act should have an exit marker, a target room, a target spawn and a completion flag. The current IV→V gap would have been caught by a checklist.
6. **Companion quest tracker.** No data structure exists for per-companion quest state. It can use the existing quest/flags system; no new engine is required.
7. **Lore answer schedule.** A table of question → act answered → scene id. This prevents the final act from becoming an exposition dump.

---

## 12. Prioritized missing-content backlog

### P0 — Required to make the story continue

1. `Q_MAIN_FIND_MIRA` data + stage wiring + `CV_END` transition.
2. Act IV→V exit and Act V rooms/scripts/dialogue/quests.
3. `Q_MAIN_FALLEN`, `Q_SIDE_TOLL`, the conditional Alden letter.
4. Act V→VI exit.
5. A written outline for Act VI.

### P1 — Required to make the story coherent

6. Act VI–VIII outlines and finale outline.
7. Alden's turn, Aldric's defeat and the capital sequence.
8. Mira's present-day payoff and the Crownveil/Ash answers.
9. Companion personal quests/payoffs.
10. The Broken Yoke's structure and postwar fate.
11. The ending structure and epilogue.

### P2 — Required to make the built content clean

12. Chapter 7–8 and 9–11 approval records.
13. `Q_ST_S2`, `Q_SL_S2`, `item_cinderhollow_charm`.
14. Chapter 8 pendant line.
15. Shop tier and Ashlands gate.
16. Placeholder/unreferenced dialogue review.
17. Sign/lore marker placement.
18. Nessa/Vell sprites, Act V art, Act VII/VIII tilesets.

---

## 13. What not to do

- Do not invent answers to the deliberate mysteries in order to “finish” a document.
- Do not rename the Crownveil, the Ash, the Ashen Crown, the Aethari, the Broken Yoke or the Fallen Knight.
- Do not combine the Crownveil and the Ashen Crown.
- Do not make Alden an ordinary villain or change Ending C.
- Do not delete Act IV's proposed material before the owner rules on it.
- Do not build Act VII before Acts V–VI simply because three rooms exist.
- Do not claim any chapter is playable until it is compiled and played.

---

**Bottom line:** The missing content is concentrated in one approved-but-unbuilt act (V), three unoutlined acts (VI–VIII), one unwritten finale, one missing opening quest, and a set of character/political payoffs that must be scheduled before the final act. The built chapters need fixes, not replacement.
