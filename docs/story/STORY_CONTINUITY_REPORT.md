# ASHEN CROWN — Story Continuity Report

**Audit date:** 2026-11-18  
**Scope:** All eight acts, the finale, all chapter scripts, dialogue data, quests, flags and rooms.  
**Status:** Audit only. No story or code was changed.

**Classification used in this report:**

- **Confirmed contradiction** — two pieces of content cannot both be true.
- **Missing explanation** — the story promises or requires an answer and does not provide one.
- **Intentional mystery** — an authored unknown; not a defect.
- **Documentation inconsistency** — documents disagree with each other or with the code.
- **Unverified implementation** — code exists, but playability/behavior was not tested.
- **Choice consequence gap** — a choice exists but later content does not acknowledge it.

---

## 1. Summary

| Class | Count | Meaning |
|---|---:|---|
| **Confirmed narrative contradictions / broken promises** | **3** | Lines/scenes that contradict each other, or promise a payoff that was never written |
| **Confirmed implementation contradictions** | **8** | Data/scripts that cannot work as written |
| **Missing explanations** | **30** | Payoffs the story has not delivered |
| **Intentional mysteries** | **18** | Deliberate unknowns; do not “fix” by inventing |
| **Documentation inconsistencies** | **18** | Docs vs docs or docs vs code |
| **Unverified implementation** | **8** | No compile/playtest evidence |
| **Choice consequence gaps** | **10** | Choices with no later acknowledgment |

**Headline:** ASHEN CROWN's premise, terminology and act structure are coherent. Its **payoffs** are not. The built acts repeatedly promise a later answer, a later consequence or a later scene, and the later content does not exist.

---

## 2. Confirmed narrative contradictions and broken promises

| ID | File / section | Issue | Why it matters | Recommendation | Priority | Owner approval |
|---|---|---|---|---|---|---|
| **C-01** | `CHAPTER1_SCRIPT.md` `CV_END_02` vs `CHAPTER8_SCRIPT.md` `PD_SCENE_04` | Chapter 1: the pendant reacts to the sealed door and something touches the other side. Chapter 8: the pendant “has done nothing since the night we found it. This is the first time it has done anything at all.” | The Chapter 8 scene's awe depends on the pendant being inert; Chapter 1 already showed it reacting. | Change Chapter 8 to “the first time since Greyhaven” / “the first time it has answered like this,” or remove the Chapter 1 reaction. Do not change both. | **HIGH** | Yes |
| **C-02** | `CHAPTER7_SCRIPT.md` §2.1 vs `scr_ch7_story.gml` | The refusal branch's stage note promises that “a line later in the act” will refer to the household being short a name and the hollow being quieter. No later line does; the branch only sets `ch7_tithe_refused` and completes the quest. | A player choice is described as having a later echo and then dropped. | Add the promised line in Chapter 7's glade/end or a later act; or remove the stage note and accept the branch as local. | **MEDIUM** | Yes |
| **C-03** | `CHAPTER9_SCRIPT.md` §5–§6 vs `scr_ch9_story.gml` | The copy branch's stage note promises “one line in Act V” referring to a copy existing in Coleford. No Act V line or flag consumes it; only the shop discount is implemented. | The ledger is the act's political evidence; dropping it weakens the Crown/Yoke plot. | Add the line/scene to Chapter 12–14 or remove the promise. | **MEDIUM** | Yes |
**Not a contradiction:** Tomas being “dying” in Chapter 1 and “still unconscious” in Chapter 2 is consistent. He passes out; he does not die on screen.

---

## 3. Confirmed implementation contradictions

These are data/script defects, not authorial contradictions. They still break the story as played.

| ID | File / section | Issue | Why it matters | Recommendation | Priority | Owner approval |
|---|---|---|---|---|---|---|
| **X-01** | `CHAPTER1_SCRIPT.md` `Q_MAIN_FIND_MIRA`; `scr_quest_data.gml` | Chapter 1's opening quest has 9 scripted stages and is absent from the quest table. | The player's first objective cannot exist. | Add `Q_MAIN_FIND_MIRA` with its 9 stages, objectives, rewards and completion; wire `CV_END`. | **CRITICAL** | No for implementation; yes for any story change |
| **X-02** | `CHAPTER7_SCRIPT.md`; `scr_ch7_story.gml`; `scr_quest_data.gml` | `Q_ST_S1` is started and immediately completed; `Q_ST_S2` is never set. | Stage 2 of the tithe quest is unreachable; the quest line dead-ends. | Set `Q_ST_S2` when the tithe choice resolves, or delete the unused stage. | **HIGH** | No |
| **X-03** | `CHAPTER9_SCRIPT.md`; `scr_ch9_story.gml`; `scr_quest_data.gml` | `Q_SL_S1` is started and immediately completed; `Q_SL_S2` is never set. | Stage 2 of the ledger quest is unreachable. | Set `Q_SL_S2` when the page choice resolves, or delete the unused stage. | **HIGH** | No |
| **X-04** | `scr_ch7_story.gml`; `scr_item_data.gml` | `item_cinderhollow_charm` is granted but has no item definition. | The reward is a null item; inventory/UI may fail or show nothing. | Add the item, or remove the grant and give an existing item. | **HIGH** | Yes for a new item |
| **X-05** | `scr_map_markers_data.gml`; `scr_ch11_story.gml` | Act VII's Ashlands rooms open on `flag_act4_complete`, not on an Act VII flag. | The player can enter the endgame region in Act IV, before Acts V–VI. | Gate on `flag_act7_started`/`flag_act6_complete`; keep `flag_act4_complete` for Act V. | **HIGH** | Yes for gating change |
| **X-06** | `scr_story_act.gml`; `scr_shop_data.gml` | `scr_story_act()` unlocks Act V/VI gear after Chapter 5 and Act VII gear after Act III/IV. | The party can buy late-game gear early; the progression curve is broken. | Unlock tiers on the actual act flags: Act V after Ch11, Act VI after Ch14, Act VII after Act VI. | **HIGH** | Yes |
| **X-07** | `scr_ch11_story.gml`; `CHAPTER12_SCRIPT.md` §8 | The seal choice sets `ch11_seal_alden` / `ch11_seal_party`, but no implemented content checks it; the only branch is the unbuilt Act V letter. | The choice is presented as a branch and currently changes nothing that can be played. | Build the Act V letter/absence, and add at least one later check in Acts VI–VIII. | **HIGH** | Yes |
| **X-08** | `CHAPTER1_SCRIPT.md` §9 vs `scr_dialogue_data.gml` `CV_END`; `scr_save.gml` | Chapter 1 says “Offer a save [C-confirmed]”; `CV_END` calls `scr_save_menu_open("save", false, true)` with `_quiet = true`. Outside a save room the function returns `noone`, so no prompt appears. | The chapter-end save promised by the approved script is not delivered; the player may lose progress. | Allow a one-off save at the door, or update the approved script/owner decision to say there is no save. | **MEDIUM** | Yes for the story change |

---

## 4. Missing explanations

These are not mysteries. They are promises, setups or required payoffs the story has not delivered.

| ID | File / section | What is missing | Why it matters | Recommendation | Priority | Owner approval |
|---|---|---|---|---|---|---|
| **M-01** | `ACT2_OUTLINE.md` §3; `CHAPTER2_SCRIPT.md`–`CHAPTER5_SCRIPT.md` | How Alden turns from sincere friend to usurper. | Ending C has no tragic transition. | Schedule the turn across Acts VI–VIII; use the seal, the Yoke split and Taren. | **CRITICAL** | Yes |
| **M-02** | Bible §2.1, §5.7; `ACT4_OUTLINE.md` | Who defeats Aldric IV, how, and what happens to him. | Alden's takeover has no trigger. | Decide the defeat scene and the king's fate before Act VIII. | **CRITICAL** | Yes |
| **M-03** | Bible §4; `ACT2_OUTLINE.md`; Ch2–5 | Who leads the Broken Yoke and how it is structured. | The rebellion has no face or chain of command. | Approve a leader/council/cell structure; show it in Act II or VI. | **CRITICAL** | Yes |
| **M-04** | Bible §8; `ACT5_OUTLINE.md` | What happens to the serfs after the final confrontation. | The rebellion's whole point is unresolved. | Write an epilogue state: freed, betrayed, divided or still under the Crown. | **HIGH** | Yes |
| **M-05** | `CHAPTER1_SCRIPT.md`; `CHAPTER2_SCRIPT.md` | What Tomas knew “was coming.” | The Fallen Knight's line has no content. | Decide Tomas's knowledge and reveal it in Act V/VI. | **HIGH** | Yes |
| **M-06** | `CHAPTER1_SCRIPT.md`; `scr_dialogue_data.gml` | Elira Varyn's fate. | Kael's mother vanishes from the story. | Decide dead/missing/alive; pay off in Kael's arc. | **HIGH** | Yes |
| **M-07** | Bible §5.2; Ch1, Ch8; Act V outline | Mira's present-day fate and role. | The central mystery has no present-day scene or payoff. | Decide rescue/reckoning/grief; schedule the reveal. | **CRITICAL** | Yes |
| **M-08** | `CHAPTER5_SCRIPT.md`; `ACT2_OUTLINE.md` | What Sera saw in the palace. | Her recruitment condition is never answered. | Reveal in Act VI/VIII; tie it to Aldric or the Engine. | **HIGH** | Yes |
| **M-09** | `CHAPTER4_SCRIPT.md`; `ACT2_OUTLINE.md` | What Caelan knows about why the Crownveil broke. | His secrecy has no payoff. | Reveal in Act VI; make it the Engine's failure or the Aethari's choice. | **HIGH** | Yes |
| **M-10** | `CHAPTER3_SCRIPT.md`; `ACT2_OUTLINE.md` | The nature of Lyra's Black Hand debt. | Her “I stay because I'm exposed” is a placeholder, not an arc. | Decide the debt/leverage and pay it in Act V/VI. | **HIGH** | Yes |
| **M-11** | `CHAPTER1_SCRIPT.md`; `scr_ch1_story.gml` | The Blackguard's name, history and source of knowledge. | The first boss is a mystery with no later answer. | Decide his faction and relation to the Crown/Fallen Knight; reveal in Act V. | **HIGH** | Yes |
| **M-12** | `CHAPTER1_SCRIPT.md`; `scr_ch1_story.gml` | Who wrote the Ashbound parchment and sent the Hunter. | The “Mira is alive” hook has no author. | Decide the sender; connect to the Ashbound or the Crown. | **HIGH** | Yes |
| **M-13** | Bible §5.2 | What happened to Mira's black stone. | A major clue disappears after Chapter 1. | Decide its location/function; pay it off at the door or in Act VIII. | **HIGH** | Yes |
| **M-14** | Bible §5.2; Ch1 carvings | Why the ancient carvings resemble Mira. | The resemblance is the story's strongest mystery and has no answer. | Decide literal/prophetic/lineage/manipulation; reveal in Act VIII. | **HIGH** | Yes |
| **M-15** | `CHAPTER1_SCRIPT.md` `CV_END` | What “Then everything stops” means. | The chapter's final beat is unexplained. | Decide time-stop/drain/unconsciousness; show the answer in Act V/VI. | **MEDIUM** | Yes |
| **M-16** | Bible §7; Act I title | What “The Night of Ash” refers to as an event. | The act title may be a promise the story never explains. | Define the event or confirm it is only a title. | **MEDIUM** | Yes |
| **M-17** | Bible §2.4; Ch1, Ch8 | Why the Crownveil is failing. | The core mystery has no cause. | Decide Engine failure/Ash corrosion/Mira's opening/Crown neglect. | **CRITICAL** | Yes |
| **M-18** | Bible §2.2, §2.5 | What happened to the Aethari. | The ancient civilization's fate is a core revelation. | Decide destruction/transformation/sealing/decline; reveal in Act VI. | **CRITICAL** | Yes |
| **M-19** | Bible §7–§8 | What the Ashen Crown and the Ash King are. | The finale and its antagonist are undefined. | Decide both, separately; do not merge them by accident. | **CRITICAL** | Yes |
| **M-20** | Bible §5.12; `ACT5_OUTLINE.md` | The Fallen Knight's identity. | Act V reveals the office, not the man. | Decide the personal answer by Act VIII. | **CRITICAL** | Yes |
| **M-21** | Bible §5.1; `CHAPTER1_SCRIPT.md`; `CHAPTER11_SCRIPT.md` | Why the royal banner bears the Crownveil mark. | The royal line's link to the barrier is unexplained. | Decide founded-by-Aethari/custodian/usurped-symbol. | **HIGH** | Yes |
| **M-22** | Bible §4; `ACT2_OUTLINE.md` | What happens to the Broken Yoke after Alden takes the throne. | The political plot has no middle. | Write the split and the movement's wartime role. | **HIGH** | Yes |
| **M-23** | Ch2–Ch11 | What happens to Calder, Hailen, the Debtman, Vell and Nessa. | Major antagonists/allies vanish after their chapters. | Give each a one-scene aftermath or a return. | **MEDIUM** | Yes |
| **M-24** | `scr_ch11_story.gml`; `scr_map_markers_data.gml` | The Act IV→V transition. | The campaign dead-ends after the barrow. | Build the coast road/exit and the Act V entry. | **CRITICAL** | Yes |
| **M-25** | Bible §5.2 Q31 | Mira's current age / how long ago the tragedy began. | Kael's age and Mira's age cannot be reconciled without a timeline. | Add a timeline; decide whether time passes differently beyond the Veil. | **HIGH** | Yes |
| **M-26** | Bible §3 Frostwilds | Whether the Frostwilds civilization is Aethari or separate. | Act VIII's setting has no history. | Decide before outlining Act VIII. | **MEDIUM** | Yes |
| **M-27** | Bible §2.7 | Where the Crown Engine is and what state it is in. | Act VI has no dungeon or revelation. | Decide before outlining Act VI. | **CRITICAL** | Yes |
| **M-28** | `scr_item_data.gml` item-comment; user brief | What “the Ash Veil” is. | The term is used as a major lore element but is undefined. | Define as Crownveil synonym/separate phenomenon, or retire it. | **HIGH** | Yes |
| **M-29** | Bible §8 | Which of Endings 1–3 are real, and how Ending C relates. | The finale has no final branch structure. | Decide the ending set and C's placement. | **CRITICAL** | Yes |
| **M-30** | Bible §8; all outlines | Alden's final fate after the three-phase battle. | The locked ending has no epilogue. | Decide death/yield/exile/arrest and who writes the aftermath. | **CRITICAL** | Yes |

---

## 5. Intentional mysteries

These are authored unknowns. **Do not resolve them in a continuity fix.** The defect is the absence of a scheduled reveal, not the absence of an answer in this report.

| ID | Mystery | Evidence | Why it is deliberate | Scheduled reveal recommendation | Priority if unscheduled |
|---|---|---|---|---|---|
| **I-01** | The Ash's origin and nature | Bible §2.3: “not native to the world”; factions disagree | The bible explicitly says not to reveal it early | Act VI/VII | HIGH |
| **I-02** | Why the Crownveil was built | Bible §2.4: core twist; six gradual truths | The twist is the story's spine | Act VI | CRITICAL |
| **I-03** | What lies beyond the Crownveil | Bible §2.4; Ashlands | Exploration/revelation | Act VII | HIGH |
| **I-04** | What happened to the Aethari | Bible §2.2; §2.5 | The ancient civilization's fate is a planned revelation | Act VI | CRITICAL |
| **I-05** | What happened when Mira opened the door | Ch1; Ch8; Blackguard | The central personal mystery | Act VIII | CRITICAL |
| **I-06** | Mira's current fate | Ch1 pendant; parchment; no body | The story's engine | Act VIII | CRITICAL |
| **I-07** | Why the carvings resemble Mira | Ch1 Basement | A deliberate uncanny clue | Act VIII | HIGH |
| **I-08** | The Fallen Knight's identity | Four sightings; Act V office reveal | Act V answers the office, not the man | Act VIII | CRITICAL |
| **I-09** | What Sera saw in the palace | Ch5 | Her secret is a recruitment condition | Act VI/VIII | HIGH |
| **I-10** | What Caelan knows | Ch4 | He explicitly refuses to answer | Act VI | HIGH |
| **I-11** | What “everything stops” means | Ch1 `CV_END` | Deliberate cliffhanger | Act V/VI | MEDIUM |
| **I-12** | What the Night of Ash is | Act I title | May be an event, prophecy or cover story | Act II/IV | MEDIUM |
| **I-13** | Why the royal banner bears the mark | Ch1 | Connects Crown to barrier | Act IV/V | HIGH |
| **I-14** | Who sent the Ashbound parchment | Ch1 | The “Mira is alive” hook | Act V | HIGH |
| **I-15** | What the Ashen Crown is | Finale title | Reserved for the endgame | Finale | CRITICAL |
| **I-16** | Who or what the Ash King is | Bible §2.4; Milestone 12 | The endgame antagonist is deliberately undefined | Act VII/VIII | CRITICAL |
| **I-17** | How Ending C relates to Endings 1–3 | Bible §8 | The ending structure is deliberately open | Before Act VIII | CRITICAL |
| **I-18** | Whether the “entity” is the Ash or the Ash King | Bible §8 | The final choice's nature is deliberately open | Finale | CRITICAL |

**Do not** label any of these as a plot hole in a bug tracker. Label them “mystery — reveal scheduled/not scheduled.”

---

## 6. Documentation inconsistencies

| ID | Documents | Inconsistency | Why it matters | Recommendation | Priority | Owner approval |
|---|---|---|---|---|---|---|
| **D-01** | `STORY_BIBLE.md` header vs audit date | Header says “Last updated 2026-11-16”; the Act V decision is 2026-11-17. | Readers cannot tell which decisions are incorporated. | Update the header when the bible is next edited. | **LOW** | No |
| **D-02** | `STORY_BIBLE.md` §7 status table vs chapter approvals | The table's statuses predate the Act IV/V decisions. | “Approved” and “built” are conflated. | Replace with the four-state table used in `EIGHT_ACT_COMPLETION_TRACKER.md` §7. | **MEDIUM** | No |
| **D-03** | User brief vs `STORY_BIBLE.md` §6–§7 | Act I is called “The Ashen Road” in the brief; the bible's act title is **The Night of Ash**, and The Ashen Road is Zone 1. | Act cards, trackers and marketing can drift. | Keep the act/zone distinction, or retitle once with owner approval. | **LOW** | Yes for retitle |
| **D-04** | `STORY_BIBLE.md` §7 vs `DECISIONS_AND_OPEN_QUESTIONS.md` | Bible says region mapping is open; the 2026-11-16 decision fixes V = Drowned Coast, VI = Ironspine, VII = Ashlands, VIII = Frostwilds. | Act VI–VIII planning is ambiguous. | Ratify the map in the bible. | **MEDIUM** | No for doc fix |
| **D-05** | Bible §7 vs Chapters 7–8 | Chapters 7–8 are built but not individually approved; some docs describe them as approved. | Unapproved content can be mistaken for canon. | State “built, unapproved” until signed off. | **HIGH** | No |
| **D-06** | Bible §7 vs Chapters 9–11 | Act IV decisions are approved; the chapters are built but not individually approved. | Same risk as D-05. | State “decisions approved; chapters unapproved.” | **HIGH** | No |
| **D-07** | Bible §7 vs `ACT5_OUTLINE.md` | Act V is labeled PROPOSED in the bible but approved as story in the outline/decisions. | The next content milestone's canon status is unclear. | Ratify Act V story approval in the bible. | **HIGH** | Yes |
| **D-08** | Scripts vs GML | Scripts use “Gold”; some docs/UI use “Gil.” | Currency naming is inconsistent. | Pick one term and use it everywhere. | **LOW** | Yes |
| **D-09** | `CHAPTER1_SCRIPT.md` vs `scr_quest_data.gml` | Chapter 1's quest table defines only `Q_BV_S1`; the GML defines seven stages, and Chapters 2–5 advance stages that are not listed in one quest spec. | The journal can show more stages than the chapter script owns, and a later writer can miss one. | Put all seven stages in one quest spec and have each chapter cite the stage it advances. | **LOW** | No |
| **D-10** | `CHAPTER1_SCRIPT.md` vs `scr_quest_data.gml` | The opening `Q_MAIN_FIND_MIRA` exists in the script, not in data. | The first quest is missing. | Add it; update the tracker. | **CRITICAL** | No for implementation |
| **D-11** | `tools/audit_chapters.py` output vs docs | 37 dialogue nodes are unreferenced. | Dead content or missing triggers. | Classify each as intentional sign/lore or dead node. | **MEDIUM** | No |
| **D-12** | `tools/audit_chapters.py` output vs docs | 64 dialogue cases are PLACEHOLDER. | Some are test scaffolding, some may be player-visible. | List them; replace or mark debug-only. | **MEDIUM** | No |
| **D-13** | Bible §7 vs `scr_item_data.gml` | The finale is **The Ashen Crown**; the Act VII helm is **Ash Crown**. | The names are near-identical. | Rename the helm or add a one-line distinction. | **LOW** | Yes |
| **D-14** | User brief vs repository | “The Ash Veil” is treated as a major term; it appears only in an item comment. | A core lore term has no definition. | Define or retire it. | **HIGH** | Yes |
| **D-15** | Bible §5.15 vs item data | The Ash King is a story element but only appears in two item acquisition strings. | The endgame antagonist has no presence. | Define or deliberately omit until Act VII. | **HIGH** | Yes |
| **D-16** | Bible §5.12 vs bestiary | “Fallen Knight” is both a story character and an enemy type. | Readers cannot tell whether they are the same. | State the distinction explicitly. | **MEDIUM** | Yes |
| **D-17** | Bible §3 vs eight-act plan | The world has seven regions; the story has eight acts plus a finale. | Region/act mapping is not one-to-one. | Keep the map in the tracker; explain the overlap. | **LOW** | No |
| **D-18** | `STORY_BIBLE.md` §10 vs this audit | 37 questions are listed; several have been partly resolved since. | The question register is stale. | Point §10 to this document's status table. | **LOW** | No |

---

## 7. Unverified implementation

These are **verification gaps**, not confirmed defects. They must not be reported as passes.

| ID | Area | What was not verified | Why it matters | What would verify it |
|---|---|---|---|---|
| **U-01** | Compile | No GameMaker compile was run. | GML syntax/resource errors may exist. | Open the project in the GameMaker IDE and compile. |
| **U-02** | Playthrough | No chapter was played start to finish. | Route, triggers and soft-locks are unverified. | Play Chapters 1–11 in order. |
| **U-03** | Act V | No Act V content exists to play. | 638 approved ids are unverified as prose and as flow. | Build the rooms/scripts, then play. |
| **U-04** | Save/load | Schema v4 persists flags/quests, but no save/load round-trip was tested. | Story progress may not survive. | Save at each act, reload, verify flags/quests. |
| **U-05** | Endings | No ending/credits code exists. | The finale cannot be verified. | Implement the ending, then test every branch. |
| **U-06** | Balance | No encounter/level curve was tested. | Level cap/act bands may break. | Play with the intended party at each band. |
| **U-07** | Visual/audio | No sprites, UI, audio or camera were reviewed in-engine. | Presentation may not match the docs. | Compile and inspect each room. |
| **U-08** | Export | No Windows/other export was built. | The game may not package. | Run the export target. |

**Rule:** “Built” means source exists. It does not mean “playable,” “tested” or “approved.”

---

## 8. Choice consequence matrix

| ID | Choice | Immediate effect | Later acknowledgment | Missing consequence | Priority |
|---|---|---|---|---|---|
| **CC-01** | Refuse or pay the Blackwood tithe | +50 Gold if refused; flag set | None | The “answer later” promised in Ch7 | **MEDIUM** |
| **CC-02** | Copy or keep the Crown ledger page | Shop discount if copied; flag set | Shop discount only | The promised Act V line; political use of the evidence | **MEDIUM** |
| **CC-03** | Seal the barrow as Alden or as the party | Different epilogue line; Alden letter branch | One optional letter in Ch12 | No mechanical or later political consequence; `ch11_seal_*` has no consumer | **HIGH** |
| **CC-04** | Renn's side quest | 30 Gold | None | Renn's fate/thanks later | **LOW** |
| **CC-05** | Oda's side quest | Potions + 40 Gold | None | Oda/Bram later | **LOW** |
| **CC-06** | Parcel side quest | 60 Gold + potion | None | The recipient's story | **LOW** |
| **CC-07** | Blackwood tithe side quest | 50 Gold | None | The forest's reaction | **LOW** |
| **CC-08** | Ledger side quest | 75 Gold + Elixir | None | The evidence's later use | **LOW** |
| **CC-09** | `Q_BV` main quest | Progresses through Acts II–III | Quest completes | No branch for how the party treated the prisoners/witnesses | **MEDIUM** |
| **CC-10** | Spare or kill Chapter 1–11 bosses | Bosses leave/yield/die | None | No later return or political consequence | **MEDIUM** |

**What this shows:** only **one** choice (the ledger) changes a system, and only **one** choice (the seal) changes a later scene. The story's choices are mostly local. The user's requirement for meaningful consequences is not met yet.

---

## 9. Timeline audit

| Event / anchor | Evidence | Issue | Recommendation | Priority |
|---|---|---|---|---|
| Kael is 24; served four years | Bible §5.1 | Consistent with leaving at 20. | Keep. | — |
| Mira was 12 “when the tragedy began” | Bible §5.2 Q31 | Current age unknown; Kael's four years do not date the tragedy. | Add a timeline: tragedy year, Mira's current age, time beyond the Veil. | **HIGH** |
| Chapter 1 is one night | `CHAPTER1_SCRIPT.md` | Consistent. | Keep. | — |
| Chapter 2 begins the morning after | `CHAPTER2_SCRIPT.md` | Consistent with Tomas still unconscious. | Keep. | — |
| Chapters 2–5 travel to Valemere/Blackwood | Scripts | No travel times or dates. | Add a simple “days since Greyhaven” tracker if needed. | **LOW** |
| Chapters 6–8 are the Blackwood | Scripts | No season/date. | Keep vague; avoid contradictory weather. | **LOW** |
| Chapters 9–11 are Coleford/barrow | Scripts | No date. | Keep. | — |
| Act V is the coast | `ACT5_OUTLINE.md` | No route/time from Coleford. | Establish the coast road and travel time. | **MEDIUM** |
| Aethari are “thousands of years” old | Bible §2.2 | Consistent. | Keep. | — |
| Crown has ruled for centuries | Bible §2.1 | Consistent with the Forgotten King being pre-Crown. | Keep. | — |
| Fallen Knight office is “a century” old | `ACT5_OUTLINE.md` | Consistent, but the knight's personal age is unknown. | Decide whether he is long-lived, cursed or ordinary. | **MEDIUM** |
| No absolute year/date anywhere | All docs | The story cannot be dated. | Add a one-page timeline bible; do not put dates in dialogue unless needed. | **MEDIUM** |

**No confirmed timeline contradiction exists.** The problem is missing anchors, not conflicting dates.

---

## 10. Geography audit

| Place | Act | Evidence | Issue | Recommendation | Priority |
|---|---|---|---|---|---|
| Greyhaven | I | Bible §3; Ch1 | Destroyed before play; five interiors + overworld. | Keep. | — |
| Old Watchtower | I | Ch1 | Relation to Greyhaven/passage unclear. | Decide whether it is the same passage Mira opened. | **HIGH** |
| Millhaven Road / Wrenfield | II | Ch2 | Millhaven itself is a signpost, not a location. | Decide whether to build Millhaven or keep it off-screen. | **MEDIUM** |
| Valemere | II | Ch3 | Capital is a hub; palace/Royal District not built. | Build the palace for Act VIII/finale. | **HIGH** |
| Hollow Sanctuary | II | Ch4 | Complete dungeon. | Keep. | — |
| Blackwood Road Garrison | II | Ch5 | Complete blockout. | Keep. | — |
| Blackwood | III | Ch6–8 | Five rooms; no world-map position. | Add to a world map. | **LOW** |
| Coleford / barrow field | IV | Ch9–11 | Four rooms; no coast road. | Add the Act V exit. | **HIGH** |
| Drowned Coast / Saltreach | V | Outline/scripts | Zero rooms; four unresolved refs. | Build. | **CRITICAL** |
| Ironspine | VI | Bible/outline | Zero rooms; two refs. | Build after Act V. | **HIGH** |
| Ashlands | VII | Bible; three rooms | Rooms open after Act IV; no story. | Gate and build. | **HIGH** |
| Frostwilds / Rimehold | VIII | Bible | Zero rooms; two refs. | Build after outline. | **HIGH** |
| Capital palace | VIII/finale | Bible | No room. | Build for Aldric/Alden. | **CRITICAL** |

**No confirmed geography contradiction exists.** The map is incomplete, not inconsistent.

---

## 11. Character knowledge audit

This checks who knows what, when, and whether the story has earned it.

| Character | Knows | Source | When learned | Payoff | Status |
|---|---|---|---|---|---|
| **Kael** | Mira is alive; the mark; the door | Parchment, pendant, Blackguard | Ch1 | Act VIII | **Earned, unpaid** |
| **Taren** | Alden; the Yoke; the war | Personal history | Ch2 | Act VIII | **Earned, unpaid** |
| **Lyra** | Black Hand; the Lower City | Personal history | Ch3 | Act V/VI | **Earned, unpaid** |
| **Caelan** | The Crownveil broke; Lumen; the Engine | Former royal scholar | Before Ch4 | Act VI | **Unexplained knowledge; intentional secret** |
| **Sera** | What she saw in the palace | Silver Guard | Before Ch5 | Act VI/VIII | **Unexplained knowledge; intentional secret** |
| **Alden** | The tomb line; the seal | Present in Ch11 | Ch11 | Act VIII | **Earned if present; branch-dependent** |
| **Aldric** | The Veil is failing | King's knowledge | Before Ch1 | Act VIII | **Stated, never shown** |
| **Fallen Knight** | Tomas knew; Mira opened the door | Unknown | Before Ch1 | Act V/VIII | **Unexplained knowledge; mystery** |
| **Mira** | The stone; the passage | Personal experience | Before Ch1 | Act VIII | **Absent; no present-day knowledge** |
| **Blackguard** | Mira crossed the Crownveil | Unknown | Ch1 | Act V | **Unexplained knowledge; mystery** |
| **Door Warden** | The door; “she opened it” | Ancient guardian | Ch8 | Act VIII | **Unexplained knowledge; mystery** |
| **Ashbound Hunter** | Mira is alive | Parchment | Ch1 | Act V | **Unexplained knowledge; mystery** |
| **Vell** | The Crown's ledger; the barrow | Magistrate | Ch9 | Ch11 | **Earned, local** |
| **Maelin** | The eleven; the crossings | Record keeper | Act V | Act V | **Earned, local** |

**Rule:** A character may keep a secret, but the story must eventually show how they learned it. Caelan, Sera, the Fallen Knight, the Blackguard, the Door Warden and the Ashbound Hunter currently have **unexplained knowledge**. For the last four, that is intentional mystery; for Caelan and Sera, it is a promised reveal.

---

## 12. Arc integrity

| Character | Want | Need | Flaw | Turn | Missing scenes | Status |
|---|---|---|---|---|---|---|
| **Kael** | Find Mira | Accept the truth/choose | Guilt, vengeance | The door, the coast, the truth | Present-day Mira; Elira/Tomas closure; dark night | **Strong start, no final act** |
| **Taren** | Free the serfs | Choose the movement over Alden | Loyalty to Alden | The Yoke split | Yoke structure; split; personal quest | **Strong start, no middle** |
| **Lyra** | Pay the debt/be free | Choose people over exit | Self-interest | The Black Hand choice | Debt payoff; personal quest | **Charming, unresolved** |
| **Caelan** | Atone/know | Tell the truth | Secrecy | The Engine | What he knows; personal quest | **Setup, no payoff** |
| **Sera** | Redeem/avenge | Tell what she saw | Silence | The palace | The secret; personal quest; order | **Setup, no payoff** |
| **Alden** | Free the serfs | Accept he cannot rule alone | Ambition | The seal/capital | Backstory; Yoke rank; turn; boss | **Setup, no tragedy yet** |
| **Aldric** | Preserve the kingdom | Admit the truth | Concealment | The fall of the capital | Entire character | **Stated, absent** |
| **Fallen Knight** | Warn/stop crossings | Face what he brought back | Silence | The office reveal | Identity; personal answer | **Office revealed, man open** |
| **Mira** | Unknown | Unknown | Unknown | The door | Everything present-day | **Mystery, no character** |

---

## 13. Severity and resolution order

### P0 — before anything else

1. **X-01** `Q_MAIN_FIND_MIRA` (CRITICAL).
2. **M-24** Act IV→V transition (CRITICAL).
3. **M-01/M-02** Alden's turn and Aldric's defeat decisions (CRITICAL).
4. **M-07/M-29/M-30** Mira, endings and Alden's fate decisions (CRITICAL).
5. **X-05** Ashlands gate (HIGH, but can break progression if left).
6. **X-06** `scr_story_act` thresholds (HIGH).

### P1 — before calling Acts I–IV complete

7. **C-01** pendant line.
8. **X-02/X-03** `Q_ST_S2`/`Q_SL_S2`.
9. **X-04** Cinderhollow Charm.
10. **C-02/C-03** tithe/ledger promises.
11. **D-05/D-06** Chapter 7–8 and 9–11 approval status.
12. **D-09** `Q_BV` stage count.

### P2 — Act V production

13. Build the four coast rooms.
14. Build 638 dialogue nodes.
15. Add `Q_MAIN_FALLEN` and `Q_SIDE_TOLL`.
16. Wire `ch11_seal_*` to the letter/absence.
17. Build the Act V→VI transition.
18. Playtest Act V.

### P3 — Acts VI–VIII and finale

19. Outline Act VI (Ironspine/Engine/Caelan).
20. Outline Act VII (Ashlands/Ash King/Yoke split).
21. Outline Act VIII (Frostwilds/Mira/Aldric/Alden).
22. Outline the finale (Ashen Crown/three-phase Alden/ending).
23. Write the companion arcs across V–VIII.
24. Write the epilogue.

### P4 — documentation and polish

25. D-01/D-02/D-04/D-07 status fixes.
26. D-08 Gold/Gil.
27. D-13 Ash Crown vs Ashen Crown.
28. D-14 Ash Veil.
29. D-15 Ash King.
30. D-18 §10 pointer.

---

## 14. What is not a contradiction

To prevent false fixes:

- **Mira at 12 “when the tragedy began”** is not a contradiction with Kael at 24; the elapsed time is simply unstated.
- **Tomas “dying” in Chapter 1 and “unconscious” in Chapter 2** is consistent; he passes out and is still alive.
- **Alden being off-screen in Act V** is intentional; the letter/absence is the branch.
- **The Fallen Knight not dying in Act V** is intentional; he yields, and the office reveal is the point.
- **Caelan and Sera refusing to explain** are intentional secrets, not plot holes.
- **No Alden letter on `ch11_seal_party`** is intentional; the absence is the branch.
- **The Ashlands rooms existing before Act VII** is production order, not lore. The gate is the defect (X-05).
- **The Ash King being undefined** is an intentional mystery, not a missing name.
- **Endings 1–3 being unconfirmed** is a decision gap, not a contradiction.
- **The Ashen Crown having no definition** is a reserved reveal, not a mistake — but it must be defined before the finale is written.

---

## 15. Bottom line

ASHEN CROWN is **consistent in its premise** and **inconsistent in its payoffs**.

- The first four acts form a coherent chain with a dead end at Act IV.
- The central character arcs are set up and not paid off.
- The political plot has a rebellion without a leader, a king without a scene and a usurper without a turn.
- The mystery plot has clues without scheduled answers.
- The choice plot has choices without later consequences.
- The implementation has an opening quest that does not exist and an ending that does not exist.

The fix is not a rewrite. It is a **decision pass** (M-01, M-02, M-07, M-17–M-20, M-29–M-30), a **payoff pass** (the 30 missing explanations), and a **production pass** (Act V, then VI–VIII, then the finale). Until those happen, the story should be described as **four built acts, one approved unbuilt act, three outlined titles and an unwritten finale** — not as a complete eight-act game.
