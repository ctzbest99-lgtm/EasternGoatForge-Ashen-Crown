# ASHEN CROWN — Lore Questions and Canon

**Audit date:** 2026-11-18  
**Purpose:** Separate established canon from deliberate mysteries, missing explanations and proposed answers that require owner approval.  
**Status:** Audit only. **No option in this document is canon unless it is marked [C] or [C-confirmed].**

**Rule:** This document does not answer the story's mysteries. It records what is known, what is missing, and what the owner must decide.

---

## 1. Canon status legend

| Tag | Meaning |
|---|---|
| **[C]** | Canon, stated in the story bible or an approved chapter script |
| **[C-confirmed]** | Canon confirmed by the owner after the original document |
| **[C-locked]** | Locked canon; cannot be changed without the owner |
| **[PROPOSED]** | A proposal; not approved |
| **[O]** | Open; do not invent |
| **[U]** | Unconfirmed; a candidate, not final |
| **OPTION** | An audit suggestion for discussion; never canon |

---

## 2. Term register — do not conflate these

| Term | Established meaning | Source | Risk if conflated |
|---|---|---|---|
| **The Ash Veil** | **Not defined anywhere in the repository.** The phrase appears only as an internal comment on Act VI item tiers ("Act VI — the Ash Veil"). | `game/scripts/scr_item_data.gml` | Could be mistaken for the Crownveil, the Ash, or the Ashlands. **Needs an owner decision.** |
| **The Ash** | A mysterious force **not native to the world**. It corrupts creatures, people and locations. Factions disagree about it. Its origin, purpose and consciousness are open. | Bible §2.3 | Merging it with the Crownveil removes the core twist: the barrier was built to keep something in. |
| **The Crownveil** | An ancient barrier created by the Architects/Aethari. It is failing. It was built to keep something **in**, not out. The Ashlands lie beyond it. Its failure is connected to Greyhaven and Mira. | Bible §2.4 | The barrier is not the Ash, not the Ashen Crown and not the Ash King. |
| **The Ashen Crown** | The title of the final endgame sequence. **No definition exists.** It is deliberately reserved for the finale and is not the same term as the Crownveil. | Bible §7, §8 | Could be confused with the Act VII helm "Ash Crown" or with the Crownveil. |
| **Ash Crown** | An Act VII helmet item: "A circlet of fused ash and iron. DEF +8, MDEF +5." | `scr_item_data.gml` | A mundane item shares a near-identical name with the finale. Recommend renaming or explicitly distinguishing it. |
| **The Ash King** | Named twice in the bible as a Crownveil truth and a Milestone 12 story element; never defined. Two item strings call items "The Ash King's guard" and "The Ash King's standard." | Bible §2.4, §5.15; item data | Could be the entity, a person, a title or a metaphor. No canon answer. |
| **The Aethari / the Architects** | The same ancient civilization. "Architects" is the common modern Eldorian term; "Aethari" is the true old name. They built the Crownveil and the Crown Engine, understood Lumen, and disappeared. | Bible §2.2, §2.5 | Treating them as two peoples breaks the Act II revelation. |
| **Lumen** | The ancient magic the Aethari understood. How it works, how it relates to modern magic, and whether Ending 3 destroys it are open. | Bible §2.6 | Could become a generic mana substitute if not defined. |
| **The Crown Engine** | The Aethari's greatest achievement, a mechanism associated with maintaining the Crownveil. Location, state and operation are open. | Bible §2.7 | If it is the Crownveil itself, the distinction collapses. |
| **The Forgotten King** | The Act IV boss. The proposed identity is the king before the Crown's line, his name chiselled off on purpose, buried with the seal and charter that legitimised his house. **Not approved.** | `ACT4_OUTLINE.md` §5, §9.3; `CHAPTER11_SCRIPT.md` | Built content presents a proposed identity as if it were canon. |
| **The Fallen Knight** | A recurring armored figure who knows Kael and his father; also a Zone 1 enemy type. Act V's approved reveal: "Fallen Knight" is an **office**, not a man — the Crown sent knights across the Crownveil and counted the ones who came back. Identity open. | Bible §5.12; `ACT5_OUTLINE.md` | Treating the office reveal as the man's identity leaves the personal mystery unresolved. |
| **The Night of Ash** | The title of Chapter 1 / Act I. As an **event**, it is undefined. | Bible §6–§7 | The title may refer to Greyhaven's destruction, the Crownveil's failure, a prophecy or a cover story. |
| **The Broken Yoke** | The serf rebellion. Taren is a Rebel Captain. Alden is involved. The leader, structure, base and postwar fate are open. | Bible §4; `ACT2_OUTLINE.md` | It is not the act title. Act II is **The Broken Crown**. |
| **Eldara / Eldoria** | Eldara is the continent; Eldoria is the central kingdom; Valemere is the capital (about 80,000 people); the Crownveil is believed to protect it. | Bible §2.1, §3 | Do not use Eldara and Eldoria interchangeably. |
| **The mark** | A crown ringing a black sun. It appears on the Watchtower banner, the Basement carvings, Mira's pendant and the Aethari doors. Its **meaning** is open; its **name** is proposed as the Crownveil in Act IV. | Bible §5.1; `CHAPTER11_SCRIPT.md` | The mark is not the Crownveil itself; the charter gives it a name, not a definition. |
| **"The entity"** | The thing released in Endings 2–3. Whether it is the Ash, the Ash King or something else is open. | Bible §8 | Do not assume it is the Ash King. |

---

## 3. Established canon ledger

### 3.1 World and history

- The game takes place on the continent of **Eldara**, in the central kingdom of **Eldoria**.
- Eldoria is an old kingdom built on the remains of the **Architects/Aethari**.
- The **Crownveil** is an ancient barrier the people believe has protected the kingdom for centuries. It is failing.
- The **Ash** is a corrupting force **not native to the world**. It shapes enemies, locations and story events.
- The **Ashlands** lie beyond the Crownveil. They are a dead region of ash, distorted landscapes, mutated creatures and broken ancient structures.
- The **Aethari** were an extraordinarily advanced civilization. They understood **Lumen**, the nature of the Crownveil, the relationship between life and the Ash, magical mechanisms and containment. They built enormous cities, sanctuaries, temples and underground structures. Their greatest achievement was the **Crown Engine**, associated with maintaining the Crownveil.
- The Aethari disappeared. Their records are fragmented. What remains includes underground cities, stone doors, ancient machinery, forgotten temples, strange symbols, ruined fortresses and evidence of a catastrophe.
- The **Crownveil was not built to keep something out. It was built to keep something in.** This is the core twist.
- The Ashlands lie beyond the barrier. The Crownveil's failure is connected to the destruction of Greyhaven and the disappearance of Mira Varyn.

### 3.2 The Crown and the royal line

- **King Aldric IV** rules Eldoria. He knows the Crownveil is failing and has hidden the truth. The kingdom is unstable.
- The royal government is not wholly evil: it contains ordinary people, corrupt officials, honorable soldiers and sincere believers.
- A royal banner bears the crown-around-a-black-sun mark. Why the Crown uses the mark is open.
- The Act IV charter (PROPOSED) names the mark **the Crownveil** and legitimises the royal house. This is a name, not an explanation.
- Aldric is defeated at some point **before** Alden takes the capital. Who defeats him, how, and what happens to him are open.
- **Alden Marr** begins as a sincere revolutionary, is gradually consumed by ambition, takes the capital after Aldric's defeat, claims the throne, and must be stopped by Kael and Taren in a three-phase battle. This is **Ending C — The Last Usurper**, locked as a concept.

### 3.3 Mira and the Varyn family

- **Kael Varyn**, 24, from Greyhaven, served four years in the Royal Army, and returns after the village is destroyed.
- **Tomas Varyn** is his father, a former soldier and blacksmith, dying when Kael returns. He says: "Your sister… she went into the woods." He passes out; he does not die on screen.
- **Elira Varyn** is his mother, the village healer. Her fate is open.
- **Mira Varyn** is his younger sister, "twelve when the tragedy began." Her current age is open.
- Mira found a **black stone** with the crown-around-a-black-sun mark. **Sister Ilse** told her to throw it away; she kept it.
- Mira found a passage beneath Greyhaven and accidentally opened something connected to the Crownveil. "Something came looking for her."
- Kael finds Mira's **wooden pendant** in the ruins of Varyn House. There is no body. The pendant carries the mark.
- The **Ashbound parchment** says: "Find the girl. The Varyn girl is still alive."
- The **Watchtower carvings** show a woman who resembles Mira, though the carvings are thousands of years old.
- The **Blackguard** says: "She crossed the Crownveil."
- At the end of Chapter 1, the pendant reacts to the sealed stone door. In Chapter 8, it reacts again and something answers from the far side; the door does not open.
- Mira has **no present-day scene and no speaker lines** in the built game.

### 3.4 The Fallen Knight

- An armored figure who recognizes Kael and says: "Your father knew what was coming." Later: "She opened the door."
- Four built sightings: the Bandit Camp north exit, the Watchtower Basement stairs, the Valemere road ("You cannot cross where she did. Not yet.") and the Blackwood treeline ("The forest has already taken its share. It will want another.").
- He never blocks the road, never draws in Act I–II, and is gone by the time the party reaches him.
- Act V's approved reveal: **the office, not the man.** The Crown has been sending knights across the Crownveil for a century; "Fallen Knight" is what the ones who came back are called.
- He is fought once in Act V, yields at 0 HP, is not named, does not die, and gets no bestiary kill credit.
- His identity, his relation to Kael's father, whether he is one of the eleven, and whether he is the enemy type are open.

### 3.5 The party

- **Kael** — Vanguard; longsword; balanced frontline fighter.
- **Taren Holt** — 27, from Millhaven; Rebel Captain of the Broken Yoke; heavy swords; childhood friend of Kael and Alden.
- **Lyra Veyne** — Rogue; twin daggers; Lower City; Black Hand ties; joins for coin and stays because she is exposed.
- **Caelan Rook** — Arcanist; former royal scholar; knows more about the Crownveil and why it broke than he admits; names Lumen and the Crown Engine without explaining them.
- **Sera (Seraphine Thorn)** — Warden; former Silver Guard; detained as a deserter; will not say what she saw in the palace.
- Five-person roster, four active in battle, one reserve.

### 3.6 Factions

- **The Crown** — Aldric IV; knows the Crownveil is failing; hides the truth; occupies Wrenfield; maintains the barrow road.
- **The Broken Yoke** — the serf rebellion; Taren is a captain; Derry is a contact; Alden is involved; leader/structure open.
- **The Silver Guard** — an elite military order; Sera's former order; leadership open.
- **The Black Hand** — a criminal network; Lyra has ties; leadership open.
- **The Radiant Flame** — the Church; believes the Ash is corruption and punishment; leadership/doctrine open.
- **The Ashbound** — people connected to the Ash; beliefs vary; one Hunter carries the parchment; who sent them is open.
- **The Aethari** — the ancient civilization; disappeared; ruins and records remain.

### 3.7 Endings

- **Ending C — The Last Usurper** is locked as a concept. Placement and conditions are open.
- **Ending 1 — Restore the Crownveil**, **Ending 2 — Destroy the Crownveil** and **Ending 3 — Break the Cycle** are **[U] unconfirmed**. They are candidates, not canon.
- The final selection and branching conditions are open. Do not implement an ending as canon until the owner confirms it.

---

## 4. Deliberate mysteries vs missing explanations

### 4.1 Deliberate mysteries — do not “fix” by inventing an answer

These are authored unknowns. The defect is the absence of a **scheduled reveal**, not the absence of an answer in this document.

1. The true nature and origin of the Ash.
2. Why the Crownveil was created and what it keeps in.
3. What lies beyond the Crownveil.
4. What happened to the Aethari.
5. Why Mira became involved.
6. What happened when Mira opened the door.
7. Mira's current fate.
8. Why the carvings resemble Mira.
9. The Fallen Knight's identity.
10. What Sera saw in the palace.
11. What Caelan knows about why the Veil broke.
12. The meaning of "Then everything stops."
13. The Night of Ash as an event.
14. Why the royal banner bears the mark.
15. Who sent the Ashbound Hunter and the parchment.
16. What the Ashen Crown actually is.
17. Who or what the Ash King is.
18. How Ending C relates to Endings 1–3.

### 4.2 Missing explanations — these are not mysteries, they are gaps

These are things the story has already promised to explain or show, but has not:

- How Alden turns from friend to usurper.
- Who defeats Aldric IV and how.
- What happens to the Broken Yoke after Alden takes the throne.
- What happens to the serfs after the final confrontation.
- What Tomas knew "was coming."
- Elira's fate.
- Whether Mira is alive, and what her role in the ending is.
- What the Crownveil Fragment is for.
- What happens to the Ashbound parchment after Chapter 1.
- What the seal choice changes.
- What the tithe and ledger choices change later.
- How the party reaches Acts V–VIII.

---

## 5. The 37 open questions in the story bible

The bible's §10 lists 37 questions. This register preserves them and adds the audit's status. Where a question has been partly resolved, the resolution is recorded; nothing is removed.

### 5.1 People

| # | Question | Status | What is established | What is missing / decision | Options (PROPOSED — NOT CANON) | Priority / approval |
|---|---|---|---|---|---|---|
| 1 | Who or what is the Ash King? How does it connect to the Crownveil, the Ash and "the entity beyond it"? | **Open** | Named as a Crownveil truth and in Milestone 12; two item strings; connected to the Ashlands. | Definition, appearance, relation to the entity, role in the ending. | (A) An ancient Aethari ruler transformed by the Ash. (B) The Ash's avatar/consciousness. (C) A title borne by the guardian of the Crownveil. (D) The "entity" itself. | CRITICAL / Yes |
| 2 | Who is the Fallen Knight who recognizes Kael? Is he one of the Fallen Knight enemies, and is he the subject of Act V? | **Partly resolved** | Four sightings; "Your father knew what was coming"; "She opened the door"; Act V reveals the office, not the man. | His name, history, family connection, whether he is one of the eleven, whether he is the enemy type, his role after Act V. | (A) One of the eleven who came back wrong. (B) Kael's father (do not confirm without owner). (C) A Crown knight who chose to warn Kael. (D) An office/title, not a single man. | CRITICAL / Yes |
| 3 | Who is the Blackguard (name, history)? How does he know Mira and Kael? | **Open** | Ch1 boss; says Mira crossed the Crownveil; dies into ash/armor. | Name, history, faction, source of knowledge, connection to the Fallen Knight/Crown. | (A) A former royal guard. (B) One of the knights sent across. (C) A deserter who recognized Kael. (D) A cultist of the Ash. | HIGH / Yes |
| 4 | What did Sera see inside the royal palace? | **Open** | She left the Silver Guard; refuses to explain; "that's the whole answer" is a condition of joining. | The event, why it matters, when it is revealed. | (A) Aldric's bargain with the Ash/Crownveil. (B) The Crown Engine's failure. (C) An order to sacrifice someone. (D) Mira on the other side. | HIGH / Yes |
| 5 | What exactly does Caelan know about the Crownveil and why it broke? | **Open** | Former royal scholar; names Lumen and the Crown Engine; refuses to answer because "you would take it for an answer. It isn't one yet." | The content of his knowledge, why he hid, when he reveals it. | (A) The Crown Engine is failing. (B) The Crownveil was built to contain the Ash. (C) The Aethari caused the catastrophe. (D) He knows Mira's mark/role. | HIGH / Yes |
| 6 | What are Lyra's Black Hand ties? | **Open** | Lower City; Black Hand ties; Debtman implies a debt; he is not a Black Hand leader. | The nature of the ties, the debt, Black Hand leadership, payoff. | (A) She owes money. (B) She is a former member. (C) A family member is held as leverage. (D) She is a freelance asset. | HIGH / Yes |
| 7 | Details of each Act II recruitment beyond its setting. | **Resolved** | Wrenfield, Valemere, Hollow Sanctuary, Blackwood Road Garrison; Chapters 2–5 approved. | Nothing structural; scene texture is canon. | — | — |
| 8 | What is Lumen, how does it relate to modern magic, and does Ending 3's "magic permanently destroyed" include it? | **Open** | Ancient Aethari magic; Caelan names it; no mechanics. | Definition, relation to modern magic, role in endings. | (A) A source magic that modern magic descends from. (B) A distinct Aethari practice. (C) The Crown Engine's fuel. (D) The Ash's opposite. | HIGH / Yes |
| 9 | The Crown Engine: where is it, what state is it in, how does it work, and is its condition why the Crownveil is failing? | **Open** | Aethari's greatest achievement; associated with maintaining the Crownveil. | Location, state, operation, causal link to the failure. | (A) Beneath the Ironspine (Act VI). (B) Beneath the capital. (C) Beyond the Crownveil. (D) The Ashen Crown itself. | CRITICAL / Yes |
| 10 | Where did Kael, Taren and Alden grow up together? Where is Alden from? When and how did Alden and Taren split? Where is Millhaven, and what is it like? | **Partly resolved** | Kael from Greyhaven; Taren from Millhaven; Taren and Alden are childhood friends; no split in Act II; Alden met as a friend in Valemere. | The childhood setting, Alden's origin, Millhaven's details, the split. | (A) Millhaven. (B) Greyhaven. (C) A third place. (D) The road/army. | HIGH / Yes |
| 11 | Elira's fate: alive, dead or missing after Greyhaven? | **Open** | Village healer; Kael's mother; no GML reference beyond "Mother's table." | Alive/dead/missing; whether she appears. | (A) Dead in the destruction. (B) Missing. (C) Alive elsewhere. (D) Taken because of what Tomas knew. | HIGH / Yes |
| 12 | What is Tomas's ultimate fate (he passes out in Chapter 1, not dead), and what did he know "was coming"? | **Open** | Dying; passes out; still unconscious in Chapter 2; Fallen Knight says he knew. | Death/recovery; the content of his knowledge; a farewell. | (A) He dies off-screen between acts. (B) He wakes and explains. (C) He is killed for what he knows. (D) He remains asleep as an open wound. | HIGH / Yes |
| 13 | Who is the "Forgotten King" in Act IV? | **PROPOSED** | The king before the Crown's line, name chiselled off, buried with the seal/charter that legitimised his house. | Owner approval; name or deliberate namelessness; relation to Aethari/Crownveil. | (A) Pre-Crown human king. (B) Last Aethari ruler. (C) A puppet/keeper. (D) A title, not a person. | HIGH / Yes |
| 14 | Alden's backstory, his exact role in the Broken Yoke, and who defeats King Aldric IV, and how. | **Partly resolved** | Met as a friend in Valemere; sincere about the serfs; seed of ambition; Ending C locked. | Backstory, Yoke rank, the split, Aldric's defeat. | (A) The party defeats Aldric; Alden takes credit. (B) Alden defeats Aldric. (C) The Crown collapses from within. (D) The Ash kills Aldric. | CRITICAL / Yes |
| 15 | What are Aldric IV's motives for hiding the Crownveil's failure? | **Open** | He knows; he hides it; the kingdom is unstable. | Personality, motive, relationship to the mark/Crownveil. | (A) Prevent panic. (B) Protect a bargain. (C) Preserve his legitimacy. (D) He is dying and wants a legacy. | HIGH / Yes |

### 5.2 Events and world

| # | Question | Status | What is established | What is missing / decision | Options (PROPOSED — NOT CANON) | Priority / approval |
|---|---|---|---|---|---|---|
| 16 | What destroyed Greyhaven, and how? | **Open** | Destruction happens before Kael arrives; not played. | Cause, agent, relation to Mira/Crownveil. | (A) The Ash through the opened passage. (B) The Crown's forces. (C) The Crownveil's failure. (D) Something Mira released. | HIGH / Yes |
| 17 | What is "the Night of Ash" as an event? | **Open** | Ch1/Act I title; no definition. | Whether it is Greyhaven's destruction, a prophecy, the Crownveil's first failure or a cover story. | (A) The night Greyhaven died. (B) A recurring event. (C) The night the Crownveil first failed. (D) A Crown cover story. | HIGH / Yes |
| 18 | Is the passage beneath Greyhaven that Mira opened the same as the Crownveil Door at the end of Zone 1? Where is the Old Watchtower relative to Greyhaven? | **Open** | Mira found a passage beneath Greyhaven; the Watchtower has a sealed door; Kael backtracks through it. | Identity of the two passages; geography. | (A) Same passage, different entrances. (B) Two doors in one network. (C) Different doors. (D) The Watchtower was built over the passage. | HIGH / Yes |
| 19 | What happened to Mira's black stone? | **Open** | She kept it after Ilse told her to discard it. | Its location, function, relation to the pendant/door. | (A) She took it through the door. (B) It is in the passage. (C) The Crown took it. (D) It became the pendant's mark. | HIGH / Yes |
| 20 | Why do the Architect carvings resemble Mira? | **Open** | The carvings show a woman who looks like Mira; they are thousands of years old. | Explanation; whether it is literal, prophetic, lineage or manipulation. | (A) Reincarnation/lineage. (B) The carvings are a warning, not a portrait. (C) Mira is connected to the Aethari. (D) The Ash shows Kael what he fears. | HIGH / Yes |
| 21 | Who wrote the Ashbound parchment, and who sent the Ashbound Hunter? | **Open** | The parchment says Mira is alive; a guaranteed Hunter drops it. | Author, sender, purpose, relation to Mira/Crown/Yoke. | (A) An Ashbound sect. (B) The Crown. (C) Mira. (D) Alden's network. | HIGH / Yes |
| 22 | What does "Then everything stops" mean? | **Open** | The presentation is a hard cut to black; Act II opens on this side of the sealed door; the pendant is quiet. | The phenomenon's meaning. | (A) Time stops at the door. (B) The door drains magic. (C) Kael loses consciousness. (D) Something on the other side pauses. | MEDIUM / Yes |
| 23 | What does the pendant's shared symbol look like, and is it the crown around a black sun? | **Resolved** | A crown ringing a black sun; on the banner, Basement carvings, pendant and doors. | Nothing visual; the meaning remains open. | — | — |
| 24 | Why does a royal banner carry the Crownveil symbol? What does the Crown know? | **Open** | The mark is on the royal banner; the Crown has hidden the Veil's failure. | The link between the royal line and the mark; what the Crown knows. | (A) The royal line was founded by the Aethari. (B) The mark is a Crown claim to legitimacy. (C) The Crown serves the barrier. (D) The banner is older than the Crown. | HIGH / Yes |
| 25 | Where exactly does the Crownveil run? It is believed to protect Eldoria, but the Ashlands lie "beyond" it. What is it keeping in? | **Open** | The Ashlands are beyond the barrier; it keeps something in; it is failing. | Geography; the contained thing; relation to the Ash/Ash King. | (A) A ring around Eldoria. (B) A line across the continent. (C) Seven gates/breaches. (D) The Ashlands are inside the barrier. | CRITICAL / Yes |
| 26 | What are the answers to the six gradual Crownveil truths, and in which acts are they revealed? | **Open** | The six questions are: why created, what lies beyond, why failing, what happened to the Aethari, why Mira, why the Ash King. | Answers and a reveal schedule. | Recommended schedule in §7; answers are owner decisions. | CRITICAL / Yes |
| 27 | Is the Frostwilds' "ancient northern civilization" the Architects or a separate people? | **Open** | The Frostwilds has an ancient northern civilization; Rimehold is its named settlement. | Identity; relation to Aethari/Crownveil. | (A) Aethari. (B) A separate people. (C) A colony. (D) A later culture that inherited Aethari ruins. | HIGH / Yes |
| 28 | Which acts map to which regions? Where do Valemere, the Drowned Coast and the Frostwilds fall in the eight acts? | **Resolved by decision, docs inconsistent** | Act II = Valemere/Eldoria; Act III = Blackwood; Act V = Drowned Coast; Act VI = Ironspine; Act VII = Ashlands; Act VIII = Frostwilds. | Ratify in the bible; update §7. | — | MEDIUM / No for doc fix; yes for any change |
| 29 | Who leads the Broken Yoke, and how is it structured? | **Open** | Named; Taren is a Rebel Captain; Derry will not name a leader; Alden is involved. | Leader, council, cells, base, Alden's rank, split, postwar fate. | (A) Decentralized cells with a council. (B) A hidden leader. (C) Taren as field captain, Alden as ideologue. (D) A mass movement with no single leader. | CRITICAL / Yes |
| 30 | Is Greyhaven Chapel part of the Radiant Flame? | **Open** | Sister Ilse keeps the chapel; her order/faith is unnamed. | Affiliation; doctrine; relation to the Crown. | (A) Radiant Flame. (B) An older local faith. (C) Independent. (D) A suppressed order. | LOW / Yes |
| 31 | What is Mira's age now? The doc gives "twelve when the tragedy began." How much time has passed? | **Open** | Kael is 24; Mira was 12 when the tragedy began; no date for the tragedy. | Timeline; Mira's current age; whether time passes differently beyond the Veil. | (A) Six years passed; Mira is 18. (B) Twelve years passed; Mira is 24. (C) Time is unstable beyond the Veil. (D) The "twelve" is symbolic. | HIGH / Yes |

### 5.3 Endings and systems

| # | Question | Status | What is established | What is missing / decision | Options (PROPOSED — NOT CANON) | Priority / approval |
|---|---|---|---|---|---|---|
| 32 | Which ending(s) are final, and what are the branching conditions? | **Open** | Endings 1–3 are [U]; Ending C is locked as a concept. | Final selection; branch conditions; relationship/choice tracking. | (A) One true ending + C. (B) Multiple endings by choice. (C) C is the final act, other endings are variations. (D) C is one of four. | CRITICAL / Yes |
| 33 | How does Alden's Ending C relate to the three Crownveil endings? Is it a separate branch, a step before the finale, or a fourth ending? | **Open** | C is locked; placement/conditions open; "not necessarily the only ending." | Structural relation. | (A) C is the final act after the Crownveil choice. (B) C is a branch triggered by the seal. (C) C is a post-finale epilogue. (D) C is a fourth ending. | CRITICAL / Yes |
| 34 | What is "the entity" in Endings 2 and 3, and is it the Ash or the Ash King? | **Open** | Endings 2–3 release/destroy an entity; no definition. | Identity; relation to Ash/Ash King. | (A) The Ash. (B) The Ash King. (C) A separate Aethari entity. (D) The Crown Engine's intelligence. | CRITICAL / Yes |
| 35 | Kael's Ashen Resolve says "Ash increases by 1." What is the Ash stat or meter? | **Open, not implemented** | The ability description exists in the bible; no Ash stat/meter in GML. | Define, replace or remove the clause. | (A) A corruption meter. (B) A resource for late skills. (C) A narrative counter. (D) Remove the clause. | MEDIUM / Yes |
| 36 | Party swapping: does the story restrict it? Does the reserve member earn XP? | **Open** | Five roster, four active, one reserve; no story restrictions defined. | Story locks/forced members; reserve XP. | (A) Free swapping except scripted scenes. (B) Forced members in key scenes. (C) Reserve earns reduced XP. (D) Reserve earns full XP. | MEDIUM / Yes |
| 37 | Battle presentation: FF1-style menu battles or hybrid? | **Open** | Exploration camera is FF1-style; battle presentation is presumed menu-driven. | Final presentation. | (A) FF1-style menu battles. (B) Hybrid by encounter. (C) Action/timed. | MEDIUM / Yes |

---

## 6. Audit-added questions not numbered in the bible

These are real gaps the bible's 37 questions do not capture.

| ID | Question | Why it matters | Options (PROPOSED — NOT CANON) | Priority / approval |
|---|---|---|---|---|
| **E-01** | What is "the Ash Veil"? | The user brief treats it as a major term; the repository does not define it. | (A) A synonym for the Crownveil. (B) The Ash's region beyond the barrier. (C) A separate phenomenon. (D) Retire the phrase. | HIGH / Yes |
| **E-02** | What is the Ashen Crown? | It is the finale title and has no definition. | (A) A physical crown that controls the Crownveil/Engine. (B) The throne/legitimacy. (C) The Ash King's crown. (D) A metaphor for rule. (E) The final dungeon/artifact. | CRITICAL / Yes |
| **E-03** | Why is the Crownveil failing now? | A core mystery; no cause. | (A) The Crown Engine is failing. (B) The Ash is corroding it. (C) Mira's opening damaged it. (D) The Crown's maintenance/cover-up caused it. | CRITICAL / Yes |
| **E-04** | What happened to the Aethari? | A core mystery; no answer. | (A) Destroyed by the Ash. (B) Became the Ash. (C) Sealed themselves beyond the Veil. (D) Died out after building the Engine. (E) Still exist beyond the barrier. | CRITICAL / Yes |
| **E-05** | What is the Crownveil's connection to the royal bloodline? | The royal banner bears the mark; the charter legitimises the house; no explanation. | (A) The royal line was founded by Aethari. (B) The Crown is the barrier's custodian. (C) The mark is a usurped symbol. (D) The bloodline is irrelevant; the Crown stole the mark. | HIGH / Yes |
| **E-06** | What is Mira's current age and the timeline of the tragedy? | Kael is 24; Mira was 12 "when the tragedy began"; no date. | (A) Six years ago; Mira 18. (B) Twelve years ago; Mira 24. (C) Time is unstable beyond the Veil. (D) "Twelve" is symbolic. | HIGH / Yes |
| **E-07** | Who leads the Broken Yoke? | The rebellion has no face or structure. | See Q29. | CRITICAL / Yes |
| **E-08** | Who defeats King Aldric IV? | Ending C depends on it. | (A) The party. (B) Alden. (C) The Crown collapses. (D) The Ash. | CRITICAL / Yes |
| **E-09** | How does Alden turn? | The locked ending needs a tragic transition. | (A) The seal convinces him he is the only legitimate ruler. (B) A Yoke schism. (C) A brutal Crown act. (D) Taren's refusal. | CRITICAL / Yes |
| **E-10** | Who is the Fallen Knight? | The title character of Act V remains unnamed. | See Q2. | CRITICAL / Yes |
| **E-11** | Who or what is the Ash King? | See Q1. | See Q1. | CRITICAL / Yes |
| **E-12** | Where did the Ash come from? | Canon says "not native to the world"; no origin. | (A) Outside the world. (B) Aethari experiment. (C) A natural cosmic force. (D) The Crown Engine's exhaust. | HIGH / Yes |
| **E-13** | Where is the Crown Engine? | Act VI's natural subject. | (A) Ironspine. (B) Capital. (C) Beyond the Veil. (D) The Ashen Crown. | CRITICAL / Yes |
| **E-14** | Is the Act VII "Ash Crown" helm the same as the Ashen Crown? | The names collide. | (A) Rename the helm. (B) Explicitly distinguish them. (C) Make the helm a clue to the finale. | LOW / Yes |
| **E-15** | Is Act I titled "The Night of Ash" or "The Ashen Road"? | The user brief and the docs disagree. | (A) Keep The Night of Ash; Ashen Road is Zone 1. (B) Retitle the act. | LOW / Yes |

---

## 7. Recommended reveal schedule (PROPOSED — NOT CANON)

This is a pacing recommendation, not an answer key. It schedules **which questions** each act should raise or answer, so the finale does not become an exposition dump.

| Act | Raise | Answer (recommended) | Keep open |
|---|---|---|---|
| **I** | Mira, the mark, the Ash, the Fallen Knight, the Blackguard's line | Nothing conclusive | Everything |
| **II** | The Aethari name, Lumen, the Crown Engine, Sera's secret, Caelan's knowledge, the Yoke | The Aethari/Architects are the same people | What the Aethari became; what Caelan knows; what Sera saw |
| **III** | The doors, the pendant, the Lost Ones, the tithe | The mark is ancient and predates the Crown; the pendant answers | What the doors want; where Mira is; what the Ash is |
| **IV** | The barrow, the erasure, the charter, the seal | The mark's **name** is the Crownveil; the forgetting was deliberate | What the name means; why the royal banner bears it; what the seal does |
| **V** | The coast, the crossings, the eleven, the knight | "Fallen Knight" is an **office**, not a man; the Crown has sent knights across | Who this knight is; whether the Crown sent him; what the token opens; where Mira is |
| **VI** | The Ironspine, the Aethari city, the Crown Engine, Caelan | What the Engine is; why the Crownveil is failing; what Caelan knew | What happened to the Aethari; the Ash's origin; Mira |
| **VII** | The Ashlands, the breach, the Ash King, the Yoke/Alden rupture | The Ash King's relation to the Crownveil; the Ash is not merely weather | Mira; the final choice; the Ashen Crown |
| **VIII** | Rimehold, the oldest record, Aldric's fall, Alden's takeover | The Crownveil's truth; Mira's fate (or a deliberate open ending); Aldric's defeat; Alden's claim | The final choice's cost |
| **Finale** | The Ashen Crown, Alden, the entity | The Ashen Crown's meaning; the final choice; Ending C; the epilogue | Nothing that the ending does not deliberately leave open |

**Why this schedule:** It preserves the existing pacing (clues in I–IV, office in V), gives Acts VI–VIII distinct revelation work, and prevents Mira/Ash King/Ashen Crown from all landing in the final hour.

**Owner approval:** Yes. This is a structural recommendation, not canon.

---

## 8. Deep dives on the major mysteries

### 8.1 The Ash Veil, the Ash and the Crownveil

**Known:**

- The Ash is **not native to the world**; it corrupts creatures, people and places.
- The Crownveil is an ancient barrier built by the Aethari; it is failing; it was built to keep something **in**.
- The Ashlands lie beyond the Crownveil.
- The Crownveil's failure is connected to Greyhaven and Mira.
- The Ash King is connected to the Crownveil, but undefined.
- The Ashbound believe the Ash is alive and communicates; the Church calls it corruption/punishment; royal scholars call it an unknown phenomenon; Aethari records say it came from outside the world.

**Missing:**

- Whether "the Ash Veil" is a separate term, a synonym for the Crownveil, or the Ash's region.
- The Ash's origin, purpose and consciousness.
- What the Crownveil contains, and why the containment is failing.
- The relationship between the Ash and the Ash King.
- The relationship between the Ash and the Crown Engine.

**Options (PROPOSED — NOT CANON):**

- **Ash Veil = Crownveil.** The "Ash Veil" is the common name for the barrier because the Ash is what it keeps in. This is the simplest reading, but it risks collapsing two terms.
- **Ash Veil = the Ash's side.** The Ash Veil is the region/condition beyond the barrier, not the barrier itself. The Crownveil is the wall; the Ash Veil is what the wall holds back.
- **Ash Veil = a separate phenomenon.** A veil of Ash that appears at breaches, distinct from the Crownveil.
- **Retire the phrase.** Use Crownveil for the barrier and the Ash for the force; do not add a third term.

**Recommendation:** Do not use "Ash Veil" in story text until the owner decides. If it is retained, define it in one line and never use it as a synonym for the Crownveil in the same scene.

**Owner approval:** Yes.

### 8.2 The Aethari, Lumen and the Crown Engine

**Known:**

- The Aethari (Architects) were an advanced ancient civilization.
- They understood Lumen, the Crownveil, the relationship between life and the Ash, magical mechanisms and containment.
- They built cities, sanctuaries, temples, underground structures, the Crownveil and the Crown Engine.
- They disappeared; their records are fragmented; their ruins remain.
- The Crown Engine is associated with maintaining the Crownveil.
- Caelan names Lumen and the Crown Engine but will not explain them.

**Missing:**

- What happened to the Aethari.
- How Lumen works and how it relates to modern magic.
- Where the Crown Engine is and what state it is in.
- Whether the Engine's condition causes the Crownveil's failure.
- The Aethari's relationship with the Crown/royal line.
- Whether the Frostwilds civilization is Aethari or separate.

**Options (PROPOSED — NOT CANON):**

- **The Engine is failing because it was built to contain the Ash, and the Ash has learned to corrode it.** This ties the Ash, the Engine and the Veil together.
- **The Engine is intact; the Crown's maintenance/cover-up is the failure.** This makes the political plot causal.
- **The Engine is the Crownveil's core; the barrier is a projection.** This makes the Engine the final dungeon.
- **The Engine was never finished; the Aethari disappeared before they could complete it.** This makes the catastrophe the Aethari's unfinished work.

**Recommendation:** Decide the Engine's location and state in Act VI, not the finale. Caelan's arc should be the human cost of that answer.

**Owner approval:** Yes.

### 8.3 The Crownveil, the royal line and Mira

**Known:**

- The Crownveil was built to keep something in.
- It is failing; Greyhaven and Mira are connected to the failure.
- The royal banner bears the mark; the Act IV charter (PROPOSED) names the mark the Crownveil and legitimises the royal house.
- Mira found a black stone with the mark, kept it, found a passage beneath Greyhaven, and opened something.
- Her pendant reacts to the sealed door; the carvings resemble her.

**Missing:**

- Why the Crownveil was created and what it contains.
- Why it is failing.
- Why Mira became involved.
- Whether the passage beneath Greyhaven is the Watchtower door.
- What happened to Mira's stone.
- Why the carvings resemble Mira.
- What the royal line knows/owes the barrier.

**Options (PROPOSED — NOT CANON):**

- **Mira is a descendant/keeper.** The carvings resemble her because her bloodline is tied to the barrier. This risks making her special by birth rather than choice.
- **Mira was in the wrong place at the wrong time.** She found the passage, opened it, and the barrier responded. This keeps her ordinary and the tragedy personal.
- **Mira was chosen by the Ash/Crownveil.** The stone called to her; the carvings are a warning/prophecy. This makes her a target, not a bloodline.
- **The carvings are not literal.** They show a generic woman/keeper; Kael sees Mira because he is desperate. This preserves ambiguity but can feel like a cheat if never clarified.

**Recommendation:** Decide whether Mira's role is **bloodline**, **choice** or **accident** before Act VIII. Each gives a different ending. Do not answer in Act V.

**Owner approval:** Yes.

### 8.4 The Ashen Crown and the Ash King

**Known:**

- The Ashen Crown is the finale title; no definition.
- The Ash King is named as a Crownveil truth and a Milestone 12 element; no definition.
- The Ash King's guard/standard are item acquisition strings.
- The Ashlands are beyond the Crownveil.
- The Crownveil keeps something in.

**Missing:**

- What the Ashen Crown is.
- Who or what the Ash King is.
- How they relate to the Crownveil, the Ash and the entity.
- Which one is the final antagonist.

**Options (PROPOSED — NOT CANON):**

- **The Ashen Crown is a physical crown that controls the Crown Engine.** The Ash King is its current bearer/guardian. The finale is a fight over the crown.
- **The Ashen Crown is the throne/legitimacy.** The Ash King is a political/religious title. The finale is about who rules.
- **The Ashen Crown is the Ash King's crown.** The Ash King is the entity beyond the Veil; the crown is the containment key.
- **The Ashen Crown is a metaphor.** The "crown" is the burden of rule/the Ash's mark; the finale is about breaking the cycle.

**Recommendation:** Do not make the Ashen Crown and the Ash King the same thing by accident. Decide which is the object, which is the person and which is the ending. Keep the names distinct.

**Owner approval:** Yes.

### 8.5 The Forgotten King

**Known / proposed:**

- Act IV's tomb belongs to the king before the Crown's line.
- His name was chiselled off on purpose.
- He was buried with the seal and charter that legitimised the royal house.
- He is a corpse kept by oath-work, not a ghost.
- The charter names the mark **the Crownveil**.
- He has no speaker lines; the party reads the tomb.

**Missing:**

- Owner approval of the identity.
- His name or a deliberate namelessness.
- His relation to the Aethari/Crownveil.
- Why the erasure happened.
- What the seal/charter actually legitimise.
- What his discovery means for Alden's claim.

**Options (PROPOSED — NOT CANON):**

- **Pre-Crown human king.** The Crown overthrew him and erased him to legitimise its own line. This is the current proposed reading and the most politically useful for Alden.
- **Last Aethari ruler.** The tomb is Aethari, and the Crown stole its legitimacy. This ties the Forgotten King to the ancient civilization.
- **A puppet/keeper.** He was installed by the Aethari/Crown to guard the seal; his name was erased to hide the office.
- **A title, not a person.** "The Forgotten King" is a role in the oath-work, not a man.

**Recommendation:** Approve or revise the current proposed identity before calling Act IV canon. The political meaning of the tomb depends on it.

**Owner approval:** Yes.

### 8.6 The Fallen Knight

**Known:**

- Four sightings; recognizes Kael and his father; says "She opened the door."
- Act V reveals the **office**: the Crown sent knights across the Crownveil and counted the ones who came back.
- He is fought once, yields, is not named, does not die.
- Whether he is one of the eleven, whether the Crown sent him, and what he wants are open.

**Missing:**

- His identity.
- His relation to Tomas and Mira.
- His place in the ending.
- Whether he is the same as the `fallen_knight` enemy type.

**Options (PROPOSED — NOT CANON):**

- **One of the eleven who came back wrong.** The office reveal is personal: he is the eleventh, or the one who should not have come back.
- **Kael's father.** Tomas crossed and came back; the knight is either Tomas or someone who knew him. This is a strong emotional option but conflicts with Tomas being at home dying unless handled carefully.
- **A Crown knight who chose to warn Kael.** He is not one of the eleven; he serves/once served the Crown and is trying to prevent another crossing.
- **An office, not a man.** There have been many Fallen Knights; this one is the current holder, and the man is deliberately unrecoverable.

**Recommendation:** Keep Act V's office reveal. Decide the personal answer by Act VIII. If the answer is "Kael's father," do not confirm it in Act V; the current scripts already leave it open.

**Owner approval:** Yes.

### 8.7 Mira

**Known:**

- Younger sister; 12 when the tragedy began; current age open.
- Found the black stone; kept it; found the passage; opened something.
- Pendant found in the ruins; no body.
- Parchment says she is alive.
- Carvings resemble her.
- Blackguard says she crossed the Crownveil.
- Pendant reacts to the door; something answers; the door does not open.
- No present-day scene.

**Missing:**

- Her fate.
- Her motivation.
- Her role in the ending.
- Her current age.
- Whether she is alive, changed, dead or something else.

**Options (PROPOSED — NOT CANON):**

- **Alive beyond the Veil.** Kael can reach her, but she has changed. The finale is a rescue or a choice to let her go.
- **The guardian/keeper.** She crossed and became part of the barrier/Engine. Freeing her may require destroying the Crownveil.
- **The Ash King's vessel.** She is the person the Ash/Ash King is using. This is a dark option; it risks villainising her.
- **Dead, but present through the pendant/Ash.** The mystery is grief, not rescue. The finale is about accepting loss.
- **She chose to stay.** She is alive and lucid, but she believes she must hold the door. The final choice is whether to respect that.

**Recommendation:** Decide whether the story is a rescue, a reckoning or a grief story. Do not answer before Act VIII. The current clues support any of the first, second, fourth or fifth options; the third needs careful setup.

**Owner approval:** Yes.

### 8.8 Alden, Aldric and Ending C

**Known:**

- Alden starts as a sincere friend/revolutionary; ambition gradually corrupts him.
- After Aldric IV is defeated, Alden takes the capital and claims the throne.
- Kael and Taren must stop him in a three-phase battle.
- He must remain tragic, not ordinary evil.
- Act IV gives him the seal choice and the line "whoever sits the throne next will need a reason."
- Act V keeps him off-screen except for a conditional letter.

**Missing:**

- His backstory and Yoke rank.
- The turn.
- The Taren split.
- Aldric's defeat.
- The capital seizure.
- The three-phase boss.
- His final fate.
- The Ending C trigger.

**Options (PROPOSED — NOT CANON):**

- **The seal convinces him.** Holding the charter/seal, he believes he is the only legitimate claimant. The turn is intellectual and tragic.
- **The Yoke splits.** Alden chooses centralized rule to finish the war; Taren chooses the movement. The turn is political.
- **A Crown atrocity.** Alden responds with a ruthless act that saves lives but crosses a line. The turn is moral.
- **Taren's refusal.** Alden asks Taren to join him; Taren refuses; Alden chooses the throne over the friendship. The turn is personal.

**Recommendation:** Use at least two of these, across Acts VI–VIII. The final battle should have three phases that dramatise the idealist, the commander and the usurper, not three monster forms. Taren must be the one who answers him, with Kael beside him.

**Owner approval:** Yes. This is locked canon and the emotional climax.

---

## 9. Canon risks

| Risk | Evidence | Why it matters | Recommendation | Approval |
|---|---|---|---|---|
| **Ash Veil vs Crownveil** | "Ash Veil" only in an item comment; the barrier is the Crownveil | A third term could collapse the core twist | Decide or retire the phrase | Yes |
| **Ashen Crown vs Ash Crown** | `item_ash_crown` is an Act VII helm; the finale is The Ashen Crown | Name collision weakens the finale's title | Rename the helm or explicitly distinguish | Yes |
| **Forgotten King identity built but unapproved** | Chapters 9–11 present the pre-Crown king/charter | Unapproved story is presented as playable canon | Approve or revise before calling Act IV canon | Yes |
| **Crownveil name in the charter is proposed** | Chapter 11 names the mark the Crownveil | The name is a major revelation; it needs sign-off | Approve the name or revise | Yes |
| **Fallen Knight office approved, identity open** | Act V scripts; bible §5.12 | The act answers the office, not the man | Schedule the personal answer | Yes |
| **Endings 1–3 unconfirmed** | Bible §8 [U] | The finale has no final selection | Decide which endings exist | Yes |
| **Ending C placement open** | Bible §8 | The locked ending has no trigger | Decide its relation to the other endings | Yes |
| **Region map fixed in decisions, open in bible** | DECISIONS vs bible §7 | Act VI–VIII planning is ambiguous | Ratify the map in the bible | No for doc fix |
| **Act I title vs zone name** | Bible: act = The Night of Ash; zone = The Ashen Road | Cards/trackers can drift | Keep the distinction or retitle once | Yes for retitle |
| **Mira has no present-day scene** | 0 speaker lines; 20 mentions | The central mystery has no emotional payoff | Schedule a present-day beat | Yes |
| **Aldric has zero GML references** | `grep` = 0 | The political conflict has no incumbent | Build the king and the court | Yes |
| **Ash King is undefined** | Two item strings | The endgame has no antagonist definition | Define or deliberately omit | Yes |

---

## 10. Decisions requiring owner approval

| ID | Decision | Why it blocks work | Recommended timing |
|---|---|---|---|
| **D-01** | Is "the Ash Veil" a synonym for the Crownveil, a separate phenomenon, or retired? | Terminology and lore consistency | Before Act VI |
| **D-02** | What is the Ashen Crown? | Finale title/dungeon/ending | Before Act VIII |
| **D-03** | Who or what is the Ash King? | Act VII/VIII antagonist | Before Act VII |
| **D-04** | What is the Ash's origin/purpose? | Core mythology and ending | Before Act VIII |
| **D-05** | Why is the Crownveil failing? | Act VI revelation | Before Act VI |
| **D-06** | Where is the Crown Engine and what state is it in? | Act VI dungeon/revelation | Before Act VI |
| **D-07** | What happened to the Aethari? | Act VI/VIII revelation | Before Act VI |
| **D-08** | What is Mira's fate and role in the ending? | Kael's arc and finale | Before Act VIII |
| **D-09** | Who is the Fallen Knight? | Act V–VIII personal mystery | Before Act VIII |
| **D-10** | Is the Forgotten King's proposed identity approved? | Act IV canon status | Before calling Act IV canon |
| **D-11** | What is Aldric IV's motive, and who defeats him? | Alden's takeover and Ending C | Before Act VIII |
| **D-12** | How does Alden turn, and what is his final fate? | Ending C | Before Acts VI–VIII |
| **D-13** | Which of Endings 1–3 exist, and how does C relate to them? | Finale structure | Before Act VIII |
| **D-14** | Who leads the Broken Yoke, and what is its structure/fate? | Political plot | Before Act VI |
| **D-15** | What are Tomas's and Elira's fates? | Kael's family arc | Before Act VI |
| **D-16** | Where did Kael, Taren and Alden grow up? | The central friendship | Before Act VI |
| **D-17** | What is Mira's current age/timeline? | Continuity and casting | Before Act VI |
| **D-18** | Is "Ash Crown" (the helm) renamed or distinguished from The Ashen Crown? | Terminology | Before Act VII |
| **D-19** | Is Act I "The Night of Ash" or "The Ashen Road"? | Act title consistency | Before any final tracker/marketing |
| **D-20** | What is the Ash stat/meter in Ashen Resolve? | Ability text/system | Before final UI pass |

---

## 11. What not to do

- Do not answer a deliberate mystery in a design document and call it canon.
- Do not use "Ash Veil" as a synonym for the Crownveil without an owner decision.
- Do not merge the Ashen Crown, the Ash Crown, the Crownveil and the Ash King.
- Do not make the Fallen Knight's office reveal his identity.
- Do not make Mira the Ash King without explicit approval and extensive setup.
- Do not make Alden evil without a tragic transition.
- Do not change Ending C or the three-phase battle concept.
- Do not treat Endings 1–3 as canon; they are unconfirmed.
- Do not invent a name for the Forgotten King, the Ash King, the Crown Engine or the Aethari city in this audit.
- Do not treat the region map as canon until the bible reflects the decision.

---

## 12. Sources

- `docs/story/STORY_BIBLE.md` §2.1–§2.7, §3, §4, §5.1–§5.15, §6–§8, §10–§11.
- `docs/story/ACT2_OUTLINE.md`–`ACT5_OUTLINE.md`.
- `docs/story/CHAPTER1_SCRIPT.md`–`CHAPTER14_SCRIPT.md`.
- `docs/DECISIONS_AND_OPEN_QUESTIONS.md`, especially the Act V region-map decision.
- `game/scripts/scr_dialogue_data*.gml` for built references.
- `game/scripts/scr_item_data.gml`, `scr_quest_data.gml`, `scr_bestiary.gml`, `scr_enemy_database.gml`.
- `python3 validate_gamemaker.py` and `python3 tools/audit_chapters.py`.

---

**Bottom line:** The lore is coherent at the level of premise and mystery, and thin at the level of answers and institutions. The most urgent decisions are the Ash Veil term, the Crownveil's failure/Engine, the Aethari's fate, Mira's role, the Fallen Knight's identity, Aldric's defeat and the ending structure. None of those should be guessed in a report; all of them now have a decision record and a proposed schedule.
