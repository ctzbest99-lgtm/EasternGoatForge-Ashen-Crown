# ASHEN CROWN — Act II Outline: "The Broken Crown"

**Studio:** Eastern Goat Forge · **Engine:** GameMaker Studio (GML) · **Genre:** Dark medieval fantasy RPG, classic turn-based combat · **Platform:** PC
**Status:** Kevin approved the nine Act II recommendations on Nov 14 2026. Those choices, and the scenes that depend on them, are **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026). Remaining texture — chapter titles, level bands, quest stage text, exact dialogue lines, some NPC and boss names, and other connective beats — is still **[PROPOSED]**.
**Source of canon:** `MASTER_GDD.txt` and `STORY_BIBLE.md`. Chapter 1 remains `CHAPTER1_SCRIPT.md`. Confirmed Act II material is also recorded in the bible.

The act title is **The Broken Crown** **[C]**. **The Broken Yoke** is the rebellion's name only **[C-confirmed]**. Do not retitle this act.

---

## How to read this file

| Tag | Meaning |
|---|---|
| **[C]** | Canon from the master design doc. Build from it as written. |
| **[C-confirmed]** | Confirmed by Kevin after the doc. Build from it. It overrides the doc. |
| **[PROPOSED]** | Invented for this outline. Kevin has not approved it. Do not build it as final. |
| **[O]** | An open question in the bible. This outline does not answer it. It only points at the question. |

Suggested story flags are in `code` font. They are suggestions for Coder, not a database spec.

**[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) UI, bestiary, and quest text keep using **Architects** as the default (naming guide). The party shifts to **Aethari** in dialogue after the revelation at Caelan's recruitment in this act (see 7.2).

---

## 1. Act overview

**[C]** Act II is a full playable act: main and side quests, new areas, NPCs, character development, dungeons, bosses, revelations, equipment, and party growth. It is not a sequence of cutscenes.

**[C-confirmed]** Kael travels alone through Act I. Everyone else joins in Act II, in this order:

1. **Taren Holt** — **Wrenfield**, the Crown-occupied village near Millhaven, during a public execution of villagers accused of aiding the rebellion. **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
2. **Lyra Veyne** — Valemere's Lower City.
3. **Caelan Rook** — **the Hollow Sanctuary**, an abandoned Aethari sanctuary a day's travel from Valemere in the countryside. **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
4. **Seraphine "Sera" Thorn** — **the Blackwood Road Garrison**. **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)

**[C-confirmed]** Five-person roster, four in battle at a time. The reserve slot only matters once Sera joins.

### Arc in brief

**[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) The Crownveil Door at the end of Chapter 1 does not let Kael through. He comes to on this side of the still-sealed door; the pendant is quiet. The main quest **Beyond the Veil** **[C]** continues, but he needs another path, and he cannot walk it alone. After an optional stop in Greyhaven, he takes the road toward Millhaven and walks into the execution at Wrenfield, where he finds Taren. They stop the hanging, free all of the accused, and leave the village still under occupation. Together they reach Valemere, where they meet Alden as a friend and recruit Lyra in the Lower City on a job to steal a scholar's notes that point to the Hollow Sanctuary. There Caelan joins, and the party learns the old name of the people they have been calling Architects. Sera is recruited at the Blackwood Road Garrison, where she is detained as a deserter, and a lead from that garrison turns the party toward the Blackwood — Act III.

This act gathers the party, plants Alden as a friend, and gives the player one real revelation (the name **Aethari**) without answering the open questions about the Ash, the Crownveil's purpose, Lumen, the Crown Engine, Mira, or the Fallen Knight.

### What this act must not do

- Do not name or reveal the Fallen Knight. Do not have him fight. His identity, and whether he is the subject of Act 5, stay **[O]** (bible question 2). His two Act II sightings are settled (section 10).
- Do not decide what "everything stops" means **[O]** (question 22). Act II opens with Kael coming to on this side of the still-sealed door; the phenomenon itself is unexplained.
- Do not answer what Caelan knows about why the Crownveil broke **[O]** (question 5). He may withhold. He may hint. He may not explain.
- Do not decide what Sera saw in the royal palace **[O]** (question 4). She does not describe it.
- Do not define the nature of Lyra's Black Hand ties **[O]** (question 6). She has ties **[C]**. That is all this outline uses.
- Do not locate or explain the Crown Engine's state, or how Lumen works **[O]** (questions 8 and 9). Both may be named. Neither is solved.
- Do not say what happened to the Aethari, why Mira is in the carvings, what the Ash King is, who leads the Broken Yoke, where the three friends grew up, or Alden's rank **[O]**. They do not split from Alden in this act; when they do is still **[O]**.
- Do not resolve Tomas, Elira, or what destroyed Greyhaven **[O]**.
- Do not start Alden's seizure of the throne, defeat King Aldric IV, or stage Alden's three-phase final battle. Those belong to the locked Ending C concept, later **[C-locked / O placement]**.
- Do not send the party into the Ashlands, and do not pretend the Crown is purely evil **[C]**.

---

## 2. Confirmed pieces this act is built from

- **Taren Holt** **[C-confirmed]**: age 27, from Millhaven, Rebel Captain of the Broken Yoke, frontline heavy-sword user (starts with a bastard sword). Childhood friend of Kael and of Alden. Believes freedom is worth fighting for and stands for the Yoke's original purpose: freedom for the people, and a system they govern themselves. Alden becomes his greatest disappointment, but that disappointment is not completed in this act. Skill kit (Rallying Cry, Cleave, Shield the Line, Breaking Blow, Unbowed, and later Banner of the Yoke) is confirmed; exact numbers stay **[O]**.
- **Lyra Veyne** **[C]**: twin daggers, Lower City and the criminal underworld, sarcastic, selfish at first, loyal once trust is earned, occasional humor. Joins second, in the Lower City **[C-confirmed]**. Surface hook for that join is now confirmed (section 6.4); the nature of her Black Hand ties stays **[O]**.
- **Caelan Rook** **[C]**: former royal scholar. Knows more about the Crownveil, and why it broke, than he admits at first. Joins third, at **the Hollow Sanctuary** **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026).
- **Sera Thorn** **[C]**: former Silver Guard. She left the kingdom after witnessing something inside the royal palace. Joins fourth, at **the Blackwood Road Garrison**, where she is detained as a deserter **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026). What she saw stays **[O]**.
- **Alden Marr** **[C]**: at first he genuinely wants to free the serfs and rebuild Eldoria. Ambition gradually corrupts him. He must stay tragic, never evil without explanation. **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) In this act Taren speaks of him with warmth at Wrenfield, and the party meets him in Valemere as a friend; there is no split here.
- **Valemere** **[C]**: capital of Eldoria, about 80,000 residents. Districts: Royal, Merchant, Lower City, Temple, Military, Old Quarter. Major hub for politics, quests, shops, factions, and party development. **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) It is the Act II hub.
- **Lumen** **[C-confirmed]**: the ancient magic the Aethari understood. How it works is **[O]**.
- **The Crown Engine** **[C-confirmed]**: the Aethari's greatest achievement, a mechanism associated with maintaining the Crownveil. Where it is, its state, and whether its condition causes the failure are **[O]**.
- **Kael's middle-arc line** **[C]**: “I need to know why this happened.” Act II is where that shift should start to be felt, without abandoning “I just need to find Mira.”

**[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) Named Act II places and officers: **Wrenfield**, **the Hollow Sanctuary**, **the Blackwood Road Garrison**, **Reeve Calder**, and **Commander Hailen**.

---

## 3. Chapter map

Act I was a single chapter (Chapter 1, "The Night of Ash"). **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) Act II is four chapters (Chapters 2–5), one recruit and one chapter boss each, ending on the road to the Blackwood. Chapter 2's title, **The Weight of the Yoke**, is **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026). Titles for Chapters 3–5 and all suggested levels stay **[PROPOSED]**.

| Chapter | Title **[PROPOSED]** | Main locations | Recruit | Boss | Suggested levels **[PROPOSED]** |
|---|---|---|---|---|---|
| 2 | The Weight of the Yoke **[C-confirmed]** | Road from the Watchtower; optional return to Greyhaven; **Wrenfield** **[C-confirmed]** | Taren Holt | **Reeve Calder**, Crown occupation officer **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) | 8–10 |
| 3 | Crowns and Alleys | Road to the capital; **Valemere** (Lower City as the story focus; other districts as hub) | Lyra Veyne | A Lower City enforcer tied to the stolen document, not a named Black Hand leader **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026). Working name **the Debtman** is still **[PROPOSED]**. | 10–13 |
| 4 | The Old Name | Countryside a day's travel from Valemere; **the Hollow Sanctuary** **[C-confirmed]** | Caelan Rook | An ancient sanctuary guardian-construct **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026). Working name **the Sanctuary Warden** is still **[PROPOSED]**. | 13–16 |
| 5 | The Deserted Oath | **The Blackwood Road Garrison** **[C-confirmed]** | Sera Thorn | **Commander Hailen**, the garrison's commanding officer **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) | 16–18 |

Region-to-act mapping for the rest of the game stays **[O]** (question 28). **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) This act uses the Kingdom of Eldoria and Valemere as its hub, and hands off to the Blackwood for Act III. It does not claim the Drowned Coast, Ironspine, Frostwilds, or Ashlands.

**Note for Coder:** party size grows 1 → 2 → 3 → 4, then 5 with one reserve when Sera joins. Taren arrives with a bastard sword in the heavy-sword category. Banner of the Yoke is a later ability and does not have to unlock in this act. Formation should already allow two frontliners (Kael and Taren).

---

## 4. Main quest: Beyond the Veil

**[C]** The quest title and the change from Find Mira are canon. The Chapter 1 script leaves stage `Q_BV_S1` as "Find a way beyond the Veil." Proposed stages for Act II:

| Stage | ID | Objective text | Completes when |
|---|---|---|---|
| 1 | `Q_BV_S1` | Find a way beyond the Veil. *(carried out of Chapter 1)* | Kael leaves the sealed door and takes the road toward Millhaven |
| 2 | `Q_BV_S2` | Seek help near Millhaven. | Taren is recruited |
| 3 | `Q_BV_S3` | Travel to Valemere for answers. | The party enters Valemere |
| 4 | `Q_BV_S4` | Search the Lower City for a lead. | Lyra is recruited and the stolen document is in hand |
| 5 | `Q_BV_S5` | Find the Hollow Sanctuary named in the notes. | Caelan is recruited and the Aethari name is learned |
| 6 | `Q_BV_S6` | Investigate the Blackwood Road Garrison. | Sera is recruited and the Blackwood lead is obtained |
| 7 | `Q_BV_S7` | Follow the trail into the Blackwood. | The party enters Act III |

Stage IDs and objective text are **[PROPOSED]**. The completion events they point at are **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) where they match the nine decisions (Taren at Wrenfield, the Lower City document, the Aethari name at the Hollow Sanctuary, Sera and the Blackwood lead at the garrison).

Optional side-quest hooks, also **[PROPOSED]**, not fully designed here: a Wrenfield family looking for a missing accused relative; a Lower City courier job that can raise or lower Lyra's trust; a Radiant Flame petition in the Temple District (doctrine details and leaders stay **[O]**); a sanctuary side-chamber with fragmented records that hint, but do not explain, Lumen.

---

## 5. Chapter 2 — "The Weight of the Yoke" **[PROPOSED title]**

### 5.1 Opening, after "everything stops"

**[C / C-confirmed]** Chapter 1 ends at the sealed stone door. The pendant reacts. Something touches the other side. Then everything stops. Hard cut to black, quest change, save prompt.

**[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) Act II begins with Kael coming to on *this* side of the same door. The door is still sealed. The pendant is quiet. Nothing explains the blackout (question 22 stays **[O]**).

Beats:

1. **[PROPOSED]** Kael tries the door again. It does not open. He understands, at least, that he cannot follow Mira this way. The Blackguard's empty armor is where it fell.
2. **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) He backtracks through the Old Watchtower and out onto the road. He may optionally stop in Greyhaven: Tomas is still unconscious in the forge, tended by Pell. Elira is not resolved. Survivors still do not explain the destruction. **[O]** questions 11, 12, and 16 are untouched.
3. **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) Hook toward Millhaven: survivors or travelers mention Crown patrols hanging people for aiding the rebellion in a village near Millhaven, and that **Taren Holt** has been seen with the Broken Yoke. Kael goes looking for him. **[PROPOSED]** The speaker can be Pell, Corwin, or a traveler on the Old Road.
4. **[PROPOSED]** He travels alone (still Act II, but before the first recruit). Road encounters can start to include Crown patrols as well as the Zone 1 enemy types, at a higher level band.

Set `flag_act2_started`. Advance to `Q_BV_S2`.

The Fallen Knight does not appear at the door. His first Act II sighting is on the road after Taren joins (section 10).

### 5.2 Wrenfield

**[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) **Wrenfield** is the Crown-occupied village near Millhaven. The Crown has seized several villagers, accused of aiding the rebellion, and scheduled them for public execution. Taren's recruitment starts here.

Millhaven's region, size, layout, and current state stay **[O]** (question 10). This outline does not tour Millhaven. It can be seen as a place-name on a signpost, or heard in Taren's mouth, without being described.

Key scenes:

1. **Approach.** **[PROPOSED]** Checkpoints on the road. Notices naming the accused as Yoke sympathizers. The village square has been cleared for a hanging. Ordinary soldiers, not monsters, hold the line. Some look unwilling. The Crown is not a cartoon.
2. **The square.** **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) Several villagers bound at the gallows. **Reeve Calder**, a Crown occupation officer, is the chapter boss; he believes he is keeping order in an unstable kingdom. **[PROPOSED]** He reads the sentence. Taren is already here, or arrives as Kael does: bastard sword in hand, trying to stop the hanging without getting the prisoners killed in the rush.
3. **Recognition.** **[PROPOSED]** Kael and Taren see each other across the square. No long reunion yet. There is no time.
4. **The fight.** **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) They fight Reeve Calder, a human Crown officer, not an Ash-corrupted foe. **[PROPOSED]** Scripted chaos, then the boss. Kael and Taren fight on the same line for the first time in the game. Rallying Cry can be introduced here as a short tutorial bark once Taren is controllable, or immediately after he joins. Possible kit direction for Calder: heavy guard, a shout that buffs his soldiers, a post-break stance when the detachment falls. If he yields or falls, he should still read as a man who thought he was protecting the kingdom.
5. **The prisoners.** **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) All of the accused are cut down alive, but only just — a rope is already on a neck when they reach the gallows. The Crown retreats. The village remains occupied; the party does not "liberate" the region. Taren has protected people today. The work is not done.
6. **Aftermath, personal stake.** Taren's stake is the one already confirmed: freedom is worth fighting for, and these are people the Crown would hang to keep its grip. **[PROPOSED]** He also will not let Kael walk the rest of this road alone. He asks about Greyhaven and Mira; Kael tells him what little he knows (the pendant, the parchment, "She crossed the Crownveil"). Taren does not turn that into a recruitment speech for the Yoke. He joins Kael's search, and he does not hide that the Yoke's fight and Kael's fight are going to keep crossing.
7. **The Alden seed.** **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) Taren speaks of Alden with warmth, as a childhood friend who still shares the dream. He does not know disappointment yet. No split is shown. **[PROPOSED]** A line in this spirit, not final wording: "Alden's in the capital, talking to people who still think the Crown will save them. He'll want to see you." Alden's rank and the Yoke's leadership stay **[O]** (questions 14 and 29).
8. **Where they grew up** is **[O]** (question 10). They can call each other old friends. They should not settle the town.

**Boss: Reeve Calder** **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) — a Crown occupation officer who believes he is keeping order. Not Ash-corrupted. His kit and whether he yields or falls stay **[PROPOSED]**.

Suggested flags: `flag_wrenfield_entered`, `flag_execution_stopped`, `flag_taren_recruited`. Advance to `Q_BV_S3`. Taren is now in the party (2 members).

---

## 6. Chapter 3 — "Crowns and Alleys" **[PROPOSED title]**

### 6.1 The road to Valemere

**[PROPOSED]** Kael and Taren travel from the Millhaven area to the capital. Overworld road, small settlements, Crown presence increasing as they near the walls.

**[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) Fallen Knight sighting 1 happens on this road (section 10), after Taren has joined and before the city.

**[PROPOSED]** Optional: a Broken Yoke contact who will not name a leader, or a rumor that the king has been closed up in the Royal District. Do not explain Aldric's motives **[O]** (question 15).

### 6.2 Valemere, the hub

**[C]** Valemere is the major hub. Open shops, inns, faction presence, and side content in the listed districts as Design is able to support them. The Royal District can be visible and largely closed. The Temple District can show the Radiant Flame as a living institution without deciding Greyhaven Chapel's affiliation **[O]** (question 30).

**[PROPOSED]** Taren is a Rebel Captain walking into the capital. Kael is a former Royal Army soldier come home to a ruined village. That tension should color gates, checkpoints, and NPC talk. They are not here to seize the city.

**[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) They come to the Lower City for a lead the Crown will not give, and Taren also wants to find Alden. **[PROPOSED]** Official channels will not talk about the Crownveil's failure, or about Mira; the Lower City is where you buy what the Crown will not say.

Set `flag_entered_valemere`. Advance to `Q_BV_S4`.

### 6.3 Alden in the capital

**[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) The party meets Alden in Valemere, in person. He greets Kael and Taren as friends. He is sincere about freeing the serfs and about the Crown having failed the people **[C]**. He has one line that already thinks ahead to "when we hold the city." Taren hears a plan. The player can hear a seed. There is no argument, and no split.

**[PROPOSED]** The meeting is in a square or a Lower City room, not a throne. Sample wording, not final: "When we hold this city, we can actually build something." If they miss him in the street, a short scene later in the chapter should still put him in front of the player, so the confirmed meeting cannot be skipped.

Set `flag_alden_met`. His backstory, exact role, and any break with Taren stay **[O]**.

### 6.4 Lyra's recruitment — Lower City

**[C-confirmed]** She joins here. **[C]** She is selfish at first. She has ties to the Black Hand. The nature of those ties stays **[O]** (question 6).

**[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) hook:

1. The party needs a thief to steal a seized document — a scholar's notes or a ledger — that points toward the abandoned sanctuary (the Hollow Sanctuary).
2. **Lyra Veyne** takes the job for coin.
3. Mid-heist, the job breaks. She can run or finish it. She finishes it and stays because she is now exposed.

**[PROPOSED]** connective texture for that hook:

- A broker, bartender, or fence sells the lead. The notes belonged to a royal scholar who left court. They mention an abandoned sanctuary and, at most, the word "Architects" in ordinary speech. They do not explain the Veil.
- Lyra is dry, useful, and not interested in Mira or in the Yoke. She may needle Taren's sermons and Kael's grim silence. That is her humor, not a change of heart.
- The break in the job may be a sweep, a double-cross, or an enforcer sent to recover the same prize. She finishes because leaving it half-done will get her killed or owned, not because she believes in the party yet.
- **Boss:** a human Lower City enforcer tied to the stolen document, not a named Black Hand leader **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026). Working name **the Debtman** is still **[PROPOSED]**. He can imply that someone in the underworld wanted the notes, or wanted Lyra reminded of a debt. That is as close as this act should come to her ties. Leadership of the Black Hand stays **[O]**.
- Personal stake, still **[PROPOSED]** wording: loyalty is later; she is a professional, not a convert. A line in this spirit: "Don't look at me like I signed an oath. I signed a job."

The document points the party at the Hollow Sanctuary (Chapter 4) without locating the Crown Engine or explaining Lumen.

Suggested flags: `flag_lower_city_job`, `flag_lyra_recruited`, `flag_scholar_notes`. Advance to `Q_BV_S5`. Party size is now 3.

---

## 7. Chapter 4 — "The Old Name" **[PROPOSED title]**

### 7.1 The Hollow Sanctuary

**[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) Caelan is recruited at **the Hollow Sanctuary**, the abandoned Aethari sanctuary, a day's travel from Valemere in the countryside. It is a self-contained dungeon.

**[O]** What it was for, and why it was abandoned (section 2.5).

**[PROPOSED]** Dungeon texture: stone doors, faded mechanisms, fragmented inscriptions, and enemies that can include hollow remnants or lingering wards. It should feel Aethari, not like a Crown fort and not like the Blackwood.

The scholar's notes get the party to the door. Kael, Taren, and Lyra still say **Architects** on the way in, in ordinary speech **[C-confirmed]** naming guide).

### 7.2 How the party learns the Aethari truth

**[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) The party learns the Aethari name in this act, at the Hollow Sanctuary, when Caelan joins.

Beats:

1. **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) Interior inscriptions use the old name, **Aethari**. **[PROPOSED]** One may sit in the same family as the confirmed illustration, "Here the Aethari set the first stone of the Veil," without adding new claims about purpose or catastrophe.
2. **[PROPOSED]** **Caelan Rook** is found in an inner hall, among records and a mechanism that no longer moves. He is wary of Crown pursuit and of anyone who looks like a soldier. He is a former royal scholar **[C]**. He does not give a full confession.
3. **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) He explains that "Architects" is the textbook name, and that they called themselves the Aethari. **[PROPOSED]** Final wording can follow the confirmed example line: "The Architects. That's what the textbooks call them. They called themselves the Aethari."
4. **[PROPOSED]** He may also name **Lumen** as the magic they understood, and the **Crown Engine** as their greatest achievement, a mechanism associated with maintaining the Crownveil **[C-confirmed]**. He does not say how Lumen works, where the Engine is, what state it is in, or whether its condition is why the Veil is failing **[O]**.
5. If asked why the Crownveil broke, he knows more than he admits **[C]**. **[PROPOSED]** A deflection in this spirit: "If I told you what I think, you would take it for an answer. It isn't one yet." Question 5 stays open.
6. **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) After this scene, Kael and the party start saying **Aethari** in dialogue. UI, bestiary, and quest text stay on **Architects** per the naming guide.

This is the act's story revelation. It is a name, and a true identity, not the six Crownveil truths **[O]** (question 26). What happened to the Aethari, why the Veil was created, what it is keeping in, and why Mira's face is in the old carvings remain unanswered.

### 7.3 The guardian-construct, and Caelan's personal stake

**[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) The chapter boss is an ancient sanctuary guardian-construct. It shows Aethari mechanisms without touching or explaining the Crown Engine.

**[PROPOSED]** The sanctuary is not safe. The construct still holds the inner door, or wakes when the records are disturbed. Working name: **the Sanctuary Warden**. After the fight, the sanctuary is no longer a place Caelan can hide.

**Personal stake.** **[PROPOSED]** Caelan has been alone with knowledge he will not yet spend. The Crown would rather a vanished scholar than a talking one. Greyhaven and the failing Veil are the disaster he feared and did not stop — he can feel that without saying what he knows. He joins because the rest of the answers are not in this stone, and because a party already hunting the Veil is the only place left to stand. He remains reserved. He remains incomplete.

Suggested flags: `flag_sanctuary_entered`, `flag_aethari_name_learned`, `flag_caelan_recruited`. Advance to `Q_BV_S6`. Party size is now 4 (full battle party, no reserve yet).

---

## 8. Chapter 5 — "The Deserted Oath" **[PROPOSED title]**

### 8.1 The Blackwood Road Garrison

**[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) Sera joins at **the Blackwood Road Garrison**, a royal post on the forest road. She is detained there as a deserter. The party comes for a Blackwood lead and finds her. She will not say what she saw in the palace. What she saw stays **[O]** (question 4).

**[PROPOSED]** Why this lead, in more detail: the scholar's notes, a Valemere rumor, or a Crown dispatch points to patrol reports, a prisoner, or sealed orders about the woods — a practical path toward the Veil, not a tour of the palace. A line from Sera in this spirit, not final wording: "I know what I saw. I will not make it a story for a courtyard."

### 8.2 Recruitment scene and personal stake

**[PROPOSED]** beats around the confirmed setup:

1. The party enters under suspicion. Taren's presence makes it worse. Kael's old service makes it complicated. Lyra wants a side door. Caelan wants the records.
2. They find Sera in detention, or being moved for judgment. She recognizes a mess when she sees one. She does not immediately volunteer.
3. **Commander Hailen**, the garrison's commanding officer, is an honorable Crown soldier. **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) He tries to stop Sera and the party. **[PROPOSED]** He believes Sera broke her oath and that the party is a rebel cell walking in through the front gate. He is trying to hold a post on a bad road in an unstable kingdom. He is not a villain in a mask.
4. **Boss: Commander Hailen** **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026). **[PROPOSED]** Likely with garrison elite. A clean, human fight. Holy and discipline, not Ash. Sera may enter as an ally mid-battle or immediately after, depending on what plays cleanly in GameMaker.
5. **Personal stake.** **[PROPOSED]** Sera still believes in protecting people. That was the point of the Silver Guard. She no longer believes in the Crown that asked her to look away. Joining Kael is a way to keep the oath she actually made, without serving Aldric. She does not need to denounce every honorable soldier to do that. Hailen can live, yield, or fall; he should not be cartoonishly broken.

Set `flag_garrison_entered`, `flag_sera_recruited`. Party size is now 5, with four in battle and one reserve **[C-confirmed]**. **Note for Coder:** this is the first moment the reserve slot is required. Whether the story locks anyone in for this garrison fight, and whether the reserve earns XP, stay **[O]** (question 36).

### 8.3 The Blackwood lead, and the handoff to Act III

Act III is **The Blackwood** **[C]**. Blackwood is a cursed forest: missing travelers, strange creatures, ancient stone doors, unnatural darkness, forgotten ruins, and connections to Mira's disappearance **[C]**. This act should arrive at that threshold, not play the forest.

**[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) The party obtains a Blackwood lead at the garrison, and follows that trail toward Act III.

**[PROPOSED]** Among the garrison records, a prisoner's effects, or a patrol map: travelers vanishing under the trees; Ashbound sighted in the dark; mention of a stone door in the forest. Caelan can recognize a mark without explaining it. The party does not need a confirmed Mira sighting. The connection already exists in canon; a documentary lead is enough.

**[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) Fallen Knight sighting 2 happens after the garrison, hinting at the woods (section 10). **[PROPOSED]** Placement: just beyond the garrison, at the first trees of the forest road.

Quest update: `Q_BV_S7` — Follow the trail into the Blackwood. Set `flag_blackwood_lead`, `flag_act2_complete`. **[PROPOSED]** Chapter / act complete screen and a save prompt, in the same spirit as Chapter 1's ending, but without another unexplained blackout.

The party that walks toward the trees is complete for the first time: Kael, Taren, Lyra, Caelan, and Sera. **[PROPOSED]** Kael's question is no longer only "where is Mira." It is starting to be "why this happened." The Veil is still a mystery. The woods are next.

---

## 9. The Alden thread (Act II)

**[C]** He begins sincere. Ambition gradually corrupts him. **[C-confirmed]** He is Taren's childhood friend and will become Taren's greatest disappointment. The final confrontation should be one of the most emotional moments in the game. **[O]** When and how they split, his rank, and his full backstory. They do not split in this act.

**[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) through-line for Chapters 2–3; later-chapter texture still **[PROPOSED]**:

| Chapter | Alden |
|---|---|
| 2 | **[C-confirmed]** Present only in Taren's mouth, with warmth and a shared dream. |
| 3 | **[C-confirmed]** A face-to-face meeting in Valemere. Friend, not foe. One seed of "when we hold the city." No split. |
| 4 | **[PROPOSED]** Absent, or a short letter / message that still sounds like an ally. |
| 5 | **[PROPOSED]** Still not the antagonist. No appearance required. |

Do not use Act II to start Ending C. The player should leave this act liking Alden, or at least understanding him, so that later disappointment has somewhere to land.

---

## 10. The Fallen Knight in Act II

**[C / C-confirmed]** In Chapter 1 he appears twice, never fights, and is never named. Line 1: “Your father knew what was coming.” Line 2: “She opened the door.”

**[O]** Who he is (question 2). This outline does not answer it, and does not hint at a true name.

**[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) Two more non-combat sightings, then he walks off, as before. Cryptic lines only. He is never named and never fights.

1. **On the road to Valemere, after Taren has joined.** He bars nothing and explains nothing. **[PROPOSED]** A short line in this spirit: "You cannot cross where she did. Not yet." Set `flag_fk_seen_3`.
2. **After the garrison, hinting at the woods.** **[PROPOSED]** Placement: just beyond the Blackwood Road Garrison, at the first trees. A short line in this spirit: "The forest has already taken its share." Set `flag_fk_seen_4`.

No battle. No helmet removal. No reunion with Tomas's secret. No claim that he is, or is not, the subject of Act 5.

---

## 11. Decisions (Kevin, Nov 14 2026)

Kevin approved all nine recommendations on Nov 14 2026. Chosen options are **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026). Rejected options are kept for the record, struck through.

### 1. The occupied village: name, and the prisoners' fate

**[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) **Option A (chosen):** The village is **Wrenfield**. The party and Taren stop the hanging and free all of the accused, with a close call (the rope is already on a neck when they intervene). The Crown retreats, but the village stays under occupation.

- ~~**Option B:** Working name Wrenfield. They save most, but at least one villager is hanged before they reach the gallows, so the victory is bitter.~~ *(Not chosen.)*
- ~~**Option C:** The rescue fails in part; Taren joins in the aftermath, driven by what he could not prevent.~~ *(Not chosen.)*

### 2. How Act II opens after Chapter 1's "everything stops"

The meaning of the phenomenon stays **[O]** (question 22).

**[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) **Option A (chosen):** Kael comes to on this side of the still-sealed door. The pendant is quiet. He backtracks through the Watchtower, may optionally stop in Greyhaven (Tomas still unconscious; Elira and the cause of the destruction remain untouched), and takes the road toward Millhaven after survivors or travelers mention Crown hangings — and that Taren Holt has been seen with the rebellion.

- ~~**Option B:** A time skip of days. Kael is already on the road when the act starts, with the failed door treated as prior.~~ *(Not chosen.)*
- ~~**Option C:** The pendant or a third party (not the Fallen Knight's identity) forces him toward the village with no return to Greyhaven.~~ *(Not chosen.)*

### 3. Lyra's Lower City hook

The nature of her Black Hand ties stays **[O]** (question 6).

**[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) **Option A (chosen):** The party needs a thief to steal a seized document (a scholar's notes or a ledger) that points toward the abandoned sanctuary. Lyra takes the job for coin. Mid-heist, the job breaks; she can run or finish it. She finishes it and stays because she is now exposed.

- ~~**Option B:** Lyra is paid to rob or watch Kael (a Greyhaven soldier asking the wrong questions). The job collapses; she switches sides for self-interest.~~ *(Not chosen.)*
- ~~**Option C:** She is in immediate danger in the Lower City (a sweep, a debt collection) and joins as a way out.~~ *(Not chosen.)*

### 4. Where the abandoned Aethari sanctuary is

What it was for, and why it was abandoned, stay **[O]**.

**[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) **Option A (chosen):** A day's travel from Valemere, in the countryside. The sanctuary is named **the Hollow Sanctuary**. It is a self-contained dungeon.

- ~~**Option B:** Hidden under Valemere's Old Quarter, reached from the city.~~ *(Not chosen.)*
- ~~**Option C:** On the edge of Blackwood, doubling as the door into Act III.~~ *(Not chosen.)*

### 5. Which royal garrison, and why Sera is there

What she saw in the palace stays **[O]** (question 4).

**[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) **Option A (chosen):** **The Blackwood Road Garrison**, a garrison on the Blackwood road. Sera is detained there as a deserter. The party comes for a Blackwood lead and finds her. She will not say what she saw.

- ~~**Option B:** The Military District in Valemere. She is in hiding or under quiet house arrest in the capital.~~ *(Not chosen.)*
- ~~**Option C:** She has returned to the garrison to warn them and is not believed; the party arrives in the middle of that failure.~~ *(Not chosen.)*

### 6. When the party learns the Aethari name and starts using it

**[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) **Option A (chosen):** In Act II, at the Hollow Sanctuary, when Caelan joins. Inscriptions say "Aethari." Caelan explains that "Architects" is the textbook name. Party dialogue shifts afterward; UI, bestiary, and quest text stay "Architects" per the guide.

- ~~**Option B:** Caelan uses "Aethari" from the moment he joins, but the party does not adopt it until a later act, after a deeper revelation.~~ *(Not chosen.)*
- ~~**Option C:** The name is withheld until a later act (Blackwood, the Forgotten King, or beyond).~~ *(Not chosen.)*

### 7. How Alden appears in Act II

His backstory, rank, and the moment he and Taren split stay **[O]** (questions 10 and 14). They do not split in this act.

**[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) **Option A (chosen):** Taren speaks of him with warmth in Wrenfield. In Valemere the party meets him in person: still a friend, still sincere about freeing the serfs, with one line that already thinks ahead to "when we hold the city." No split in this act.

- ~~**Option B:** He is spoken of only. The first meeting is reserved for a later act.~~ *(Not chosen.)*
- ~~**Option C:** Act II includes the start of the split (a public disagreement with Taren).~~ *(Not chosen.)*

### 8. Fallen Knight appearances in Act II

His identity remains **[O]** (question 2). He is never named and never fights, matching Chapter 1.

**[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) **Option A (chosen):** Two brief sightings. One on the road after Taren joins; one after the garrison, hinting at the woods. Cryptic lines only. He walks off.

- ~~**Option B:** One sighting only, at the act's end, pointing toward Blackwood.~~ *(Not chosen.)*
- ~~**Option C:** No appearance in Act II. He returns in a later act.~~ *(Not chosen.)*

### 9. Chapter bosses

**[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) **Option A (chosen):** Ch 2: a Crown occupation officer (**Reeve Calder**) who believes he is keeping order. Ch 3: a Lower City enforcer tied to the stolen document, not a named Black Hand leader (working name still **[PROPOSED]**). Ch 4: an ancient sanctuary guardian-construct, to show Aethari mechanisms without touching the Crown Engine (working name still **[PROPOSED]**). Ch 5: an honorable garrison commander (**Commander Hailen**) who tries to stop Sera and the party.

- ~~**Option B:** Replace the human officers with Ash-corrupted versions of the same roles.~~ *(Not chosen.)*
- ~~**Option C:** One Ash-corrupted mid-act dungeon boss and fewer human bosses.~~ *(Not chosen.)*

---

*Confirmed Act II material is recorded in `STORY_BIBLE.md`. Remaining [PROPOSED] texture stays in this file until Kevin approves a full Act II script.*
