# ASHEN CROWN — Character Completion Tracker

**Audit date:** 2026-11-18  
**Scope:** Every named character in the story bible, chapter scripts and built dialogue data, plus the factions that function as characters in the political plot.  
**Status:** Audit only. No character, line or canon was changed.

**How to read the status column:**

- **Built:** source/data exists; never compiled or played.
- **Script only:** appears in an approved or proposed chapter script but has no implementation.
- **Data only:** exists as an enemy/shop/art reference, not as a scene.
- **Absent:** no appearance, speaker line or implementation.
- **Unverified:** built, but no engine test.

Line counts are speaker-tagged lines in the 12 `scr_dialogue_data*.gml` files. The files define 1,026 ids: 1,011 structured nodes plus 15 legacy `case` labels in the dispatcher; the speaker counts below cover the structured set. They are a rough measure of presence, not scene count or quality.

---

## 1. Roster at a glance

| Character | Role | First appearance | Join / act | Built lines | Personal quest | Arc status | Final fate | Implementation |
|---|---|---|---|---:|---|---|---|---|
| **Kael Varyn** | Protagonist, Vanguard | Ch1 Greyhaven | Ch1 / Act I | 165 | Main quest only (Mira) | Beginning only | Open | Built Ch1–11; unverified |
| **Taren Holt** | Rebel Captain, heavy swords | Ch2 Wrenfield | Ch2 / Act II | 113 | None | Recruitment + seed | Open; must stop Alden | Built Ch2–11; unverified |
| **Lyra Veyne** | Rogue, twin daggers | Ch3 Salt Lamp | Ch3 / Act II | 70 | None | Recruitment + debt hook | Open | Built Ch3–11; unverified |
| **Caelan Rook** | Arcanist, spellbook | Ch4 Hollow Sanctuary | Ch4 / Act II | 89 | None | Recruitment + withheld knowledge | Open | Built Ch4–11; unverified |
| **Sera (Seraphine Thorn)** | Warden, holy sword | Ch5 Blackwood Road Garrison | Ch5 / Act II | 69 | None | Recruitment + withheld secret | Open | Built Ch5–11; unverified |
| **Alden Marr** | Tragic antagonist; locked Ending C | Mentioned Ch2; on-screen Ch3 | Ally Ch3, 9–11 | 48 | None | Friend + ambition seed; no turn | Locked concept; scene absent | NPC/scripted ally; no boss |
| **King Aldric IV** | Ruler of Eldoria | Ch3 rumor only | — | 0 | None | Absent | Defeated before Alden; scene absent | **Absent** |
| **The Fallen Knight** | Recurring mystery; Act V subject | Ch1 Bandit Camp | Sightings Ch1, 3, 5 | 6 | Act V main | Office reveal approved; identity open | Yields; unnamed; open | Sightings built; Act V unbuilt |
| **Mira Varyn** | Kael's sister; central mystery | Ch1 ruins/pendant/carvings | — | 0 (20 mentions) | Main quest | Absent present-day | Open | Items/clues only; no scene |
| **Tomas Varyn** | Kael's father | Ch1 forge | — | 8+ | None | Dying; passes out | Open; neither wakes nor dies | Built Ch1–2 |
| **Elira Varyn** | Kael's mother; healer | None | — | 0 | None | Absent | Open | **Absent** |
| **The Blackguard** | Ch1 boss | Ch1 arena | — | 5 | None | One-scene | Dies | Built; unverified |
| **The Forgotten King** | Act IV boss | Ch11 last chamber | — | 0 | None | One-scene | Oath breaks; fate open | Built; unverified |
| **The Ash King** | Unnamed endgame power | None | — | 0 | None | Absent | Open | Only item strings |
| **The Broken Yoke** | Serf rebellion | Ch2 Wrenfield | — | Faction | None | Name + Taren/Derry | Open | Mentions only; no leader |
| **Vell** | Coleford magistrate | Ch9 ledger house | — | 20 | `Q_SIDE_LEDGER` giver | One-scene | Yields; lives | Built; placeholder sprite |
| **Nessa** | Vell's clerk | Ch9 ledger house | — | 8 | `Q_SIDE_LEDGER` | One-scene | Open | Built; placeholder sprite |
| **Commander Hailen** | Ch5 boss | Ch5 garrison | — | 17 | None | One-scene; may yield | Lives or dies | Built; unverified |
| **Reeve Calder** | Ch2 boss | Ch2 gallows | — | 10 | None | One-scene; yields | Lives; withdraws | Built; unverified |
| **The Debtman** | Ch3 boss | Ch3 warehouse | — | 8 | None | One-scene; yields | Lives; debt open | Built; unverified |
| **Nim** | Fence, Salt Lamp | Ch3 Salt Lamp | — | 11 | `Q_SIDE_PARCEL` giver | One-scene | Open | Built; unverified |
| **Derry** | Broken Yoke contact | Ch3 Valemere road | — | 4 | None | One-scene | Open | Built; unverified |
| **Berrin** | Cinderhollow burner | Ch6 Cinderhollow | — | 19 | `Q_SIDE_TITHE` | One-scene choice | Open | Built; dedicated sprite |
| **Mott** | Blackwood carter/merchant | Ch6 built-only | — | 4 | None | Code-only merchant | Open | Built; no script/scene |
| **Sarn** | Ashlands outpost trader | Act VII built-only | — | 4 | None | Code-only merchant | Open | Built; no act |
| **Old Hunter Renn** | Hunter's Camp NPC | Ch1 camp | — | 8 | `Q_SIDE_RENN` | One-scene | Open | Built; unverified |
| **Pell** | Greyhaven smith | Ch1 forge | — | 8 | None | One-scene | Open | Built; unverified |
| **Hob** | Greyhaven tavern keeper | Ch1 tavern | — | 5 | None | One-scene | Open | Built; unverified |
| **Sister Ilse** | Greyhaven chapel keeper | Ch1 chapel | — | 5 | None | One-scene | Open | Built; unverified |
| **Marda** | Greyhaven shopkeeper | Ch1 store | — | 3 | None | One-scene | Open | Built; unverified |
| **Old Wenna** | Greyhaven elder | Ch1 square | — | 2? | None | One-scene | Open | Built; unverified |
| **Dov** | Greyhaven boy | Ch1 square | — | 4 | None | One-scene | Open | Built; unverified |
| **Corwin** | Greyhaven watchman | Ch1 north gate | — | 5 | None | One-scene | Open | Built; unverified |
| **Oda** | Bram's sister | Ch2 Wrenfield | — | 4 | `Q_SIDE_ODA` giver | One-scene | Open | Built; unverified |
| **Bram** | Oda's brother | Ch2 gallows | — | 1 | `Q_SIDE_ODA` | One-scene | Alive | Built; unverified |
| **Perrin** | Bent Post tavern keeper | Ch2 Wrenfield | — | 3 | None | One-scene | Open | Built; unverified |
| **Len** | Wrenfield storekeeper | Ch2 Wrenfield | — | 2 | None | One-scene | Open | Built; unverified |
| **Ilsa Fen** | Reeve of Saltreach | Ch12 script | — | 0 | `Q_SIDE_TOLL` | Script only | Open | **Unbuilt** |
| **Maelin Orr** | Legible name on the eleven | Ch13 script | — | 0 | None | Name only | Unknown; not present | **Unbuilt** |
| **The Fisher** | Saltreach boatman | Ch13 script | — | 0 | None | Script only | Open | **Unbuilt** |
| **The Toll-Keeper** | Ch12 boss | Ch12 script | — | 0 | None | Data only | Dies | **Unbuilt** |
| **The Saltreach Leviathan** | Ch13 boss | Ch13 script | — | 0 | None | Data only | Dies | **Unbuilt** |
| **The Knight (Act V)** | Same figure as the Fallen Knight | Ch12–14 scripts | — | 0 | `Q_MAIN_FALLEN` | Approved; unbuilt | Yields; unnamed | **Unbuilt** |

**Generic speakers not listed individually:** Crown Sergeant, Crown Soldier, Crown Guard, Gate Captain, Bandit, Burner, Child, Traveler, Drill Sergeant, Acolyte, Stallkeeper. They have 2–8 lines each and no arc.

---

## 2. The five playable characters

### 2.1 Kael Varyn — protagonist

| Field | Detail |
|---|---|
| **Name / role** | Kael Varyn; Vanguard; longsword; balanced frontline fighter |
| **Age / home** | 24; Greyhaven |
| **First appearance** | Chapter 1, the south road into Greyhaven (`GH_ARRIVAL`) |
| **Story act** | Act I–VIII, finale |
| **Background** | Four years in the Royal Army. Returns to Greyhaven after its destruction. His father Tomas is dying; his mother Elira is unaccounted for; his younger sister Mira is missing. He finds Mira's wooden pendant in the ruins of Varyn House. The pendant carries the crown-around-a-black-sun mark. |
| **Motivation** | Find Mira. The middle arc is supposed to become "I need to know why this happened." The late arc is the willingness to sacrifice himself; the end is learning to let people go. Only the first stage is written. |
| **Relationships** | Mira (sister, central); Tomas and Elira (parents); Taren (childhood friend); Alden (friend); Lyra, Caelan and Sera (companions). |
| **Important dialogue** | `GH_ARRIVAL_01` ("Four years in the Royal Army. Kael Varyn came home to Greyhaven."); `GH_TOMAS` ("Your sister… she went into the woods."); `CV_END_02` (the pendant reacts); `WF_JOIN_08` ("I just need to find Mira."); `CA_MEET_07` ("My sister crossed it."); `PD_SCENE_03`/`PD_SCENE_07` (the pendant answers); `SL_CHOICE_*` (the seal); `ACT4_END_*`. |
| **Personal quest** | The main quest is personal, but there is no separate `Q_KAEL` or family quest. `Q_MAIN_FIND_MIRA` is missing entirely. |
| **Character development** | Beginning: grief, duty, the search. Middle: the first "why" questions in Act II and the pendant in Act III. Late: no sacrifice beat, no fear-of-loss beat, no final choice. The approved arc quotes for middle, late and end do not appear in GML. |
| **Final fate** | Open. Endings 1–3 are unconfirmed; Ending C is locked as a concept but has no scene. Kael may sacrifice himself, destroy the barrier, break the cycle or something else. No ending state exists. |
| **Implementation status** | Playable in Chapters 1–11; built, unverified. No Act V+ implementation. |
| **Missing requirements** | (1) Middle/late/end arc beats and the approved quotes; (2) `Q_MAIN_FIND_MIRA` and its nine stages; (3) a present-day Mira payoff; (4) Tomas/Elira closure; (5) a personal quest or family chain; (6) a final choice; (7) an ending/epilogue. |

**Why it matters:** Kael is the player's fixed point. His opening is strong, but the arc stops developing after Act IV. The final act cannot land if he has not changed.

**Owner approval:** Yes for new arc scenes and any ending decision.

---

### 2.2 Taren Holt — Rebel Captain

| Field | Detail |
|---|---|
| **Name / role** | Taren Holt; Rebel Captain; heavy swords; frontline warrior |
| **Age / home** | 27; Millhaven |
| **First appearance** | Chapter 2, Wrenfield gallows (`WF_GALLOWS`) |
| **Story act** | Act II–VIII, finale |
| **Background** | Childhood friend of Kael and Alden. A captain of the Broken Yoke. He believes freedom is worth fighting for and wants people to govern themselves. Millhaven is named as his home but is not a visitable location. |
| **Motivation** | Free the serfs; keep faith with the Yoke's original purpose; protect Kael; hold Alden to the friendship they had. |
| **Relationships** | Kael (childhood friend, comrade); Alden (childhood friend, eventual greatest disappointment); the party (captain); the Yoke (field captain). |
| **Important dialogue** | `WF_JOIN_07` ("The Yoke's fight and yours are going to keep crossing."); `WF_JOIN_10` ("Alden's in the capital… He'll want to see you."); `WF_JOIN_12` ("For all three of us."); `FK_03_08` (the knight who knows Kael's family); `SL_CHOICE_04` ("Alden."); `ACT4_END_05` (Taren walks at the back, silent). |
| **Personal quest** | None. He has no quest of his own and no Yoke questline. |
| **Character development** | Recruitment: strong. Act II–III: reliable captain, warm about Alden. Act IV: first doubt, one line. No open split, no confrontation, no resolution. |
| **Final fate** | Open. He must stop Alden with Kael. Whether he kills, spares or loses Alden is undecided. |
| **Implementation status** | Playable Chapters 2–11; built, unverified. No Act V+ implementation. |
| **Missing requirements** | (1) A Millhaven/childhood scene with Kael and Alden; (2) the Yoke's structure and Taren's command; (3) the Alden split; (4) the final confrontation; (5) a personal quest; (6) an epilogue. |

**Why it matters:** Taren is the emotional hinge of Ending C. The locked ending says the final Alden confrontation should be one of the game's most emotional moments; at present Taren has one line of doubt and no rupture.

**Owner approval:** Yes.

---

### 2.3 Lyra Veyne — Rogue

| Field | Detail |
|---|---|
| **Name / role** | Lyra Veyne; Rogue; twin daggers; criticals, bleed, poison, stealth |
| **Age / home** | Not stated; Valemere's Lower City / criminal underworld |
| **First appearance** | Chapter 3, the Salt Lamp (`SL_LYRA`) |
| **Story act** | Act II–VIII, finale |
| **Background** | From the Lower City. Has ties to the Black Hand. Takes the scholar's-notes job for coin. The Debtman implies a debt and says "they can always find you." The nature of her ties is open. |
| **Motivation** | Coin and professional survival at first; loyalty once trust is earned. She stays because the job exposes her. |
| **Relationships** | Kael (employer → ally); Taren (professional respect); the party (the first group that does not treat her as disposable); the Black Hand/Debtman (unresolved). |
| **Important dialogue** | `SL_LYRA_05` ("I don't work for causes. I work for coin."); `LC_HEIST_04` ("You have your paper. I have my coin coming."); `DM_DEFEAT_01` ("The debt doesn't go with it."); `DM_DEFEAT_03` ("They can always find you."); `SR_JOIN_02` ("Do you have coin?"). |
| **Personal quest** | None. The debt is a hook with no quest. |
| **Character development** | Recruitment: strong, economical, funny. Act III: professional. Act IV+: no personal beat. She does not choose the party over coin on screen; she is simply still there. |
| **Final fate** | Open. No debt payoff, no Black Hand resolution, no epilogue. |
| **Implementation status** | Playable Chapters 3–11; built, unverified. |
| **Missing requirements** | (1) A Black Hand/debt questline or scene chain; (2) a moment where she chooses the party; (3) a personal quest; (4) a late-game role; (5) an epilogue. |

**Why it matters:** Lyra risks becoming the "rogue who joins for coin and never changes." The Debtman scene is a good start; it needs a payoff.

**Owner approval:** Yes.

---

### 2.4 Caelan Rook — Arcanist

| Field | Detail |
|---|---|
| **Name / role** | Caelan Rook; Arcanist; spellbook; fire, ice, lightning, later dark |
| **Age / home** | Not stated; former royal scholar |
| **First appearance** | Chapter 4, the Hollow Sanctuary records hall (`CA_MEET`) |
| **Story act** | Act II–VIII, finale |
| **Background** | A former royal scholar who left court and was hunted. He knows more about the Crownveil and why it broke than he admits. He names Lumen and the Crown Engine without explaining either. He has been alone with the knowledge for a year. |
| **Motivation** | Answers. He joins because the rest of the answers are not in the stone, and because the party is the only place left to stand. |
| **Relationships** | Kael (mutual need); Taren (blunt respect); Lyra (coin vs knowledge); Sera (two guarded professionals); the Aethari (scholarly obsession). |
| **Important dialogue** | `CA_MEET_10` ("The short version is a name."); `CA_MEET_14` ("I used to be paid to know things."); `CA_MEET_18` ("If I told you what I think, you would take it for an answer. It isn't one yet."); `HS_DOOR_02` ("Architect work. Same as the Watchtower."); `PD_SCENE_02` (the mark, the banner, the basement, the shrine); `CA_JOIN_08` ("Then I'll come as far as the answers."); `CH10_END_06` (the Crown has been paying to keep the door shut). |
| **Personal quest** | None. His knowledge is a main-plot hook, not a personal quest. |
| **Character development** | Recruitment: excellent. Act II–III: exposition with withheld cost. Act IV: the barrow and the Engine. No reveal of what he knows or why he hid it. |
| **Final fate** | Open. No Aethari/Engine resolution, no personal epilogue. |
| **Implementation status** | Playable Chapters 4–11; built, unverified. |
| **Missing requirements** | (1) The Aethari/Engine reveal; (2) why he hid it; (3) a personal quest; (4) a late-game choice; (5) an epilogue. |

**Why it matters:** Caelan is the story's knowledge-bearer. If he never spends what he knows, his reticence becomes a plot device rather than a character.

**Owner approval:** Yes.

---

### 2.5 Seraphine “Sera” Thorn — Warden

| Field | Detail |
|---|---|
| **Name / role** | Seraphine Thorn; Warden; holy sword; healing, shields, holy damage |
| **Age / home** | Not stated; former Silver Guard knight |
| **First appearance** | Chapter 5, the Blackwood Road Garrison yard (`SR_MEET`) |
| **Story act** | Act II–VIII, finale |
| **Background** | A former Silver Guard knight, detained as a deserter and awaiting transport to the capital. She left the order after witnessing something in the royal palace. She will not say what. |
| **Motivation** | Keep her oath to protect people, not a king or a road. She joins because she cannot keep that oath in a cell. |
| **Relationships** | Kael (fellow soldier, guarded respect); Taren (the first honest thing in the yard); Lyra (mutual wariness); Caelan (two people with secrets); the Silver Guard (unresolved). |
| **Important dialogue** | `SR_STAKE_03` ("I took an oath to protect people. Not a king. Not a road. People."); `SR_STAKE_06` ("When I say I won't talk about the palace, that's the whole answer."); `SR_JOIN_01` ("Seraphine Thorn. Sera. Silver Guard, until I wasn't."); `BW_LEAD_11` ("The Crown seals what it can't explain."); `CH10_END_07` ("Whatever's down there, it was important enough to guard and shameful enough to forget."). |
| **Personal quest** | None. The palace secret is a main-plot hook, not a quest. |
| **Character development** | Recruitment: strong, disciplined, warm. Act III–IV: reliable moral compass. No palace reveal, no Silver Guard resolution. |
| **Final fate** | Open. No secret payoff, no order resolution, no epilogue. |
| **Implementation status** | Playable Chapters 5–11; built, unverified. |
| **Missing requirements** | (1) The palace secret; (2) the Silver Guard's fate; (3) a personal quest; (4) a late-game choice; (5) an epilogue. |

**Why it matters:** Sera's refusal is one of the best character beats in the game. It only works if the story eventually earns it.

**Owner approval:** Yes.

---

## 3. The central antagonist and the Crown

### 3.1 Alden Marr — the Last Usurper

| Field | Detail |
|---|---|
| **Name / role** | Alden Marr; revolutionary, ally, eventual usurper; locked Ending C |
| **Age / home** | Not stated; origin open |
| **First appearance** | Mentioned in Chapter 2 (`WF_JOIN_10`); on-screen in Chapter 3, Weigh-House Square (`AD_MEET`) |
| **Story act** | Act II–VIII, finale |
| **Background** | A friend of Kael and Taren, and a believer in freeing the serfs and dismantling the Crown. He meets the party in Valemere as a sincere friend. In Act IV he travels with them, takes the seal if allowed, and says "whoever sits the throne next will need a reason." His backstory, rank in the Yoke and path to ambition are open. |
| **Motivation** | Initially freedom and a better Eldoria. Gradually, the conviction that he should rule because no one else can. The transition is not written. |
| **Relationships** | Kael (friend); Taren (childhood friend, greatest disappointment); the Broken Yoke (rank open); the party (ally in Acts III–IV); the Crown (enemy, then prize). |
| **Important dialogue** | `AD_MEET` (the friend in Valemere); `AL_MEET_13` ("Whoever sits the throne next will need a reason."); `SL_CHOICE_05` ("Whoever sits the throne next will need a reason. This is a reason with a name on it."); `SL_ALDEN_02` (he pockets the seal "the way you pick up something you intend to give back"); `ACT4_END_04` ("That's a plan I can carry."); Chapter 12's conditional letter (unbuilt). |
| **Personal quest** | None. His arc is the main political plot. |
| **Character development** | Friend (Ch3) → ally (Ch9–10) → ambiguous claimant (Ch11). No open break, no seizure, no three-phase boss. The 48 built lines are a strong setup, not a completed tragedy. |
| **Final fate** | Ending C is locked as a concept: he takes the capital after Aldric IV's defeat, claims the throne, and is stopped by Kael and Taren. Whether he dies, is spared or is imprisoned is open. |
| **Implementation status** | NPC/scripted ally in Chapters 3, 9, 10 and 11; no battle slot, no enemy data, no capital, no boss. |
| **Missing requirements** | (1) Backstory and Yoke rank; (2) two or three scenes of ambition becoming method; (3) the Taren split; (4) Aldric's defeat and the capital seizure; (5) a three-phase boss; (6) a final conversation with Kael and Taren; (7) a fate; (8) the Ending C trigger. |

**Why it matters:** Alden is the one locked ending and the story's political and emotional climax. The existing material makes him likable and sincere, which is the right foundation. It does not yet make him a usurper.

**Owner approval:** Yes — locked canon; no major change without owner sign-off.

---

### 3.2 King Aldric IV — the absent king

| Field | Detail |
|---|---|
| **Name / role** | King Aldric IV; ruler of Eldoria and leader of the Crown |
| **First appearance** | Chapter 3 rumor only ("the king has been closed up in the Royal District") |
| **Story act** | Act VIII / finale |
| **Background** | Rules Eldoria. Knows the Crownveil is failing and has hidden the truth. Is defeated at some point before Alden takes the capital. His personality, motives and relationship to the mark are open. |
| **Motivation** | Open. The cover-up is canon; the reason is not. |
| **Relationships** | The Crown; Alden (the man who replaces him); Sera (whatever she saw in the palace); the royal bloodline and the Crownveil (open). |
| **Important dialogue** | None. **Zero GML references.** |
| **Personal quest** | None. |
| **Character development** | None on screen. |
| **Final fate** | Defeated before Alden's takeover. How, by whom and whether he dies are open. |
| **Implementation status** | **Absent.** No room, scene, portrait, enemy or line. |
| **Missing requirements** | (1) A face and a voice; (2) a motive for the cover-up; (3) a court/palace; (4) a defeat scene or boss; (5) a decision on who defeats him; (6) a legacy that shapes Alden's claim. |

**Why it matters:** Alden cannot usurp a throne that has no occupant. Aldric is the political order the story is about.

**Owner approval:** Yes.

---

## 4. The mystery figures

### 4.1 The Fallen Knight

| Field | Detail |
|---|---|
| **Name / role** | The Fallen Knight; recurring silent figure; Act V subject; also an enemy type |
| **First appearance** | Chapter 1, Bandit Camp north exit (`FK_01`) |
| **Story act** | Act I, II, V; later acts open |
| **Background** | An armored figure who recognizes Kael and says "Your father knew what was coming" and "She opened the door." He appears at the Bandit Camp, the Watchtower Basement, the Valemere road ("You cannot cross where she did. Not yet.") and the Blackwood treeline ("The forest has already taken its share. It will want another."). Act V reveals that "Fallen Knight" is an office: the Crown sent knights across the Crownveil and counted the ones who came back. It does not name him. |
| **Motivation** | Open. He follows Kael without blocking him. He tests rather than attacks. He may be warning, guiding or waiting. |
| **Relationships** | Kael (recognizes him and his father); Tomas (knew what was coming); Mira ("she opened the door"); the Crown (the office); the eleven (possible). |
| **Important dialogue** | `FK_01_03` ("Your father knew what was coming."); `FK_02_02` ("She opened the door."); `FK_03_05` ("You cannot cross where she did. Not yet."); `FK4_02` ("The forest has already taken its share. It will want another."); `FK4_04` ("Someone who counted the ones it took."); Chapter 14's "Your father asked me the same question. She didn't ask at all." (unbuilt). |
| **Personal quest** | Act V's `Q_MAIN_FALLEN` (unbuilt). |
| **Character development** | Four sightings and a yield. The office reveal is approved; the man is not. |
| **Final fate** | Yields at 0 HP; not named, not killed, no bestiary kill credit. His later fate is open. |
| **Implementation status** | Sightings built in Chapters 1, 3 and 5; enemy data `fallen_knight_last`; Act V scripts unbuilt. |
| **Missing requirements** | (1) Act V implementation; (2) the identity decision; (3) the family connection; (4) a later scene with Kael/Taren; (5) his role in the ending; (6) whether he is the enemy type. |

**Why it matters:** The Fallen Knight is the title character of Act V and the most personal mystery after Mira. The office reveal is a strong middle beat but not a resolution.

**Owner approval:** Yes.

---

### 4.2 Mira Varyn

| Field | Detail |
|---|---|
| **Name / role** | Mira Varyn; Kael's younger sister; the opening quest and central mystery |
| **First appearance** | Chapter 1: the pendant, the ruined house, the carvings (she does not appear) |
| **Story act** | All; present-day role open |
| **Background** | Younger sister. "Twelve when the tragedy began" (current age open). She found a black stone with the crown-around-a-black-sun mark, was told by Sister Ilse to throw it away, and kept it. She found a passage beneath Greyhaven and accidentally opened something connected to the Crownveil. "Something came looking for her." Her pendant was found in the ruins; there was no body. The Ashbound parchment says she is still alive. The Watchtower carvings show a woman who resembles her. The Blackguard says she crossed the Crownveil. |
| **Motivation** | Open. She may have been curious, chosen, tricked or desperate. The story deliberately withholds it. |
| **Relationships** | Kael (brother); Tomas and Elira (parents); Sister Ilse (told her to discard the stone); the Fallen Knight ("she opened the door"); the Ashbound (the parchment); the Crownveil. |
| **Important dialogue** | She has **no speaker lines**. She is referenced 20 times in built dialogue, 13 of them in Chapter 1. Key references: `GH_TOMAS` ("she went into the woods"), `GH_HOUSE_04` (pendant), `CV_END_02` (pendant reacts), `PD_SCENE_03` (the mark), `PD_SCENE_06` (something answers), `PD_SCENE_07` ("It didn't say her name"). |
| **Personal quest** | The main quest is about her; there is no separate quest. |
| **Character development** | She is an absence, not a character on screen. The clues are consistent; the payoff is missing. |
| **Final fate** | Open. Alive beyond the Veil, changed, dead, guardian, unwilling antagonist, or something else — no answer is canon. |
| **Implementation status** | No present-day scene, no speaker, no actor; item/clue references only. |
| **Missing requirements** | (1) A decision on her fate; (2) at least one present-day scene, message or visible consequence before the ending; (3) her role in the final choice; (4) her current age/timeline; (5) a payoff for the parchment, the carvings and the Blackguard's line. |

**Why it matters:** Mira is the emotional centre of the game. A mystery can remain open, but it cannot remain absent from the finale.

**Owner approval:** Yes.

---

### 4.3 The Ash King

| Field | Detail |
|---|---|
| **Name / role** | The Ash King; undefined endgame power |
| **First appearance** | None; named twice in item acquisition strings ("The Ash King's guard", "The Ash King's standard") |
| **Story act** | VII/VIII/finale |
| **Background** | Named in the bible as one of the six Crownveil truths ("Why the Ash King is connected to it") and in Milestone 12 ("Ash King story"). Not defined anywhere else. Possible relation to the Ash, the Crownveil and "the entity" in Endings 2–3. |
| **Motivation** | Open. |
| **Relationships** | The Ash; the Crownveil; the entity; the Ashlands; the Fallen King/ Forgotten King (open); Mira (open). |
| **Important dialogue** | None. |
| **Personal quest** | None. |
| **Character development** | None. |
| **Final fate** | Open. |
| **Implementation status** | Only two item strings; no enemy, scene, portrait or line. |
| **Missing requirements** | (1) A definition; (2) a first appearance; (3) an encounter or a deliberate absence; (4) a relation to the Crownveil/Ash; (5) a place in the ending. |

**Why it matters:** The Ash King is one of the largest unanswered lore questions and a likely endgame antagonist. The name currently promises more than the game contains.

**Owner approval:** Yes.

---

### 4.4 The Blackguard

| Field | Detail |
|---|---|
| **Name / role** | The Blackguard; Ch1 boss; the man who says Mira crossed |
| **First appearance** | Chapter 1, Old Watchtower arena (`BG_INTRO`) |
| **Story act** | I |
| **Background** | An armored boss in the Old Watchtower. He knows Kael and Mira. He says "You still don't know. What she opened." On defeat: "The girl didn't disappear, Kael. She crossed the Crownveil." He collapses into ash and empty armor. His name, history and faction are open. |
| **Motivation** | Open. He guards the arena/door and knows more than he says. |
| **Relationships** | Kael (recognizes him); Mira (knows what she opened); the Crownveil; possibly the Fallen Knight/Crown. |
| **Important dialogue** | `BG_INTRO_*`; `BG_DEFEAT_*`; `BG_REWARD_01` (sword and Fragment). |
| **Personal quest** | None. |
| **Character development** | One scene, one reveal, one death. |
| **Final fate** | Dies; armor/ash. |
| **Implementation status** | Built boss; unverified. |
| **Missing requirements** | (1) A name; (2) a history; (3) how he knows Mira; (4) whether he is connected to the Fallen Knight or the Crown; (5) a later trace (log, companion line, item). |

**Why it matters:** The first boss delivers the central reveal. If he is only a namesake, the reveal loses weight.

**Owner approval:** Yes for new backstory.

---

### 4.5 The Forgotten King

| Field | Detail |
|---|---|
| **Name / role** | The Forgotten King; Act IV boss; the king before the Crown's line (PROPOSED) |
| **First appearance** | Chapter 11, the last chamber (`FK_INTRO`) |
| **Story act** | IV |
| **Background** | The king before the Crown's line, buried with the seal and the charter that legitimized his house; his name was chiselled off on purpose. He is a corpse kept by oath-work, not a ghost. The tomb's oath requires a keeper. He has no speaker-tagged dialogue; the party reads the charter and fights. |
| **Motivation** | The oath, not hatred. He stands between the party and the seal. |
| **Relationships** | The Crown (erased him); the Aethari (not stated); the barrow Warden (same oath-work); Alden (the seal). |
| **Important dialogue** | None spoken; the charter and the halls carry his history. |
| **Personal quest** | None. |
| **Character development** | One dungeon, one reveal (the name of the mark), one fight. |
| **Final fate** | The oath breaks; his body/fate after the fight is open. |
| **Implementation status** | Built boss; unverified. |
| **Missing requirements** | (1) Owner approval of the proposed identity; (2) a decision on whether silence is deliberate; (3) a name (or a deliberate namelessness); (4) a link to the Aethari/Crownveil; (5) a consequence for the seal. |

**Why it matters:** Act IV's one revelation is a name, and the King is the source of it. If his identity remains unapproved, the act's canon status is unresolved.

**Owner approval:** Yes.

---

## 5. Family and Greyhaven

### 5.1 Tomas Varyn

- **Role:** Kael's father; former soldier, blacksmith; dying.
- **First appearance:** Chapter 1, the ruined forge.
- **Built lines:** 8+ (`GH_TOMAS`, `GH_TOMAS_R1`, `GH2_TOMAS_01`, `GH2_TOMAS_R1`).
- **Background:** Delivers "Your sister… she went into the woods." The Fallen Knight says he "knew what was coming." He passes out; he does not die on screen. In Chapter 2 he is still unconscious, "no worse, no better."
- **Motivation:** Open. Protect his children; perhaps keep a secret about the passage.
- **Relationships:** Kael, Mira, Elira, Pell (carer), the Fallen Knight (knew something).
- **Personal quest:** None.
- **Arc:** Dying father gives the opening clue; no death, no recovery, no explanation.
- **Final fate:** Open.
- **Implementation:** Built Chapters 1–2; unverified.
- **Missing:** A death or recovery; what he knew; a farewell; a consequence for Kael.
- **Priority:** HIGH.
- **Owner approval:** Yes.

### 5.2 Elira Varyn

- **Role:** Kael's mother; village healer.
- **First appearance:** None.
- **Built lines:** 0. The only trace is "Mother's table. Split down the middle." in the ruined house.
- **Background:** The bible says she is the village healer; her fate is explicitly open.
- **Motivation:** Unknown.
- **Relationships:** Kael, Tomas, Mira.
- **Personal quest:** None.
- **Arc:** Absent.
- **Final fate:** Open — alive, dead or missing.
- **Implementation:** **Absent.**
- **Missing:** At least one line, memory or survivor testimony that establishes her fate. If she is deliberately absent, say so in canon.
- **Priority:** HIGH.
- **Owner approval:** Yes.

### 5.3 Greyhaven survivors

| Character | Role | Built lines | Status | Missing |
|---|---|---:|---|---|
| Pell | Smith; tends Tomas; runs forge shop | 8 | Built | A scene after Tomas's fate; shop is functional |
| Hob | Tavern keeper; hid in cellar | 5 | Built | A fuller account of the destruction (he refuses; intentional) |
| Sister Ilse | Chapel keeper; told Mira to discard the stone | 5 | Built | Her order/faith unnamed; a later scene about Mira |
| Marda | Shopkeeper | 3 | Built | Minor closure |
| Old Wenna | Elder | 2? | Built | Minor closure |
| Dov | Boy about Mira's age; "a door in the ground" | 4 | Built | A later scene; he is a key clue |
| Corwin | Watchman; north gate | 5 | Built | Minor closure |
| Old Hunter Renn | Hunter's Camp; `Q_SIDE_RENN` | 8 | Built | Optional; no main-plot role |

**Why it matters:** Greyhaven is the emotional wound. The survivors are well sketched; only Tomas and Elira are unresolved in a way that affects Kael's arc.

**Owner approval:** Yes for new family scenes; no for preserving existing survivors.

---

## 6. Act II supporting cast

| Character | Role | First appearance | Built lines | Quest / function | Status | Missing |
|---|---|---|---:|---|---|---|
| **Reeve Calder** | Crown occupation officer; Ch2 boss | Ch2 gallows | 10 | Yields; lives | Built | Aftermath; does he keep the occupation? |
| **Bram** | Oda's brother; nearly hanged | Ch2 gallows | 1 | `Q_SIDE_ODA` | Built | A later line; he is the face of the rescue |
| **Oda** | Bram's sister; quest giver | Ch2 Wrenfield | 4 | `Q_SIDE_ODA` | Built | Aftermath; the quest completes |
| **Perrin** | Bent Post tavern keeper | Ch2 Wrenfield | 3 | Flavor | Built | Minor closure |
| **Len** | Wrenfield storekeeper | Ch2 Wrenfield | 2 | Shop | Built | Minor closure |
| **Nim** | Fence at the Salt Lamp | Ch3 Valemere | 11 | `Q_SIDE_PARCEL` giver | Built | A later appearance; the parcel's contents |
| **Derry** | Broken Yoke contact | Ch3 Valemere road | 4 | Yoke flavor | Built | A later Yoke scene; he will not name a leader |
| **The Debtman** | Lower City enforcer; Ch3 boss | Ch3 warehouse | 8 | Yields; debt hook | Built | A later collection; Lyra payoff |
| **Gate Captain** | Valemere gate | Ch3 gates | 6 | Flavor | Built | Minor |
| **Crown Clerk** | Official channel | Ch3 Merchant District | 2? | Flavor | Built | Minor |
| **Acolyte of the Radiant Flame** | Temple presence | Ch3 Temple District | 2 | Flavor | Built | Doctrine/leadership open |
| **Drill Sergeant** | Military District | Ch3 | 2 | Flavor | Built | Minor |
| **Stallkeeper** | Merchant; parcel turn-in | Ch3 | 2 | `Q_SIDE_PARCEL` | Built | Minor |
| **Street hawker** | Points to Salt Lamp | Ch3 | 1? | Flavor | Built | Minor |

**Why it matters:** Act II's supporting cast is functional and well used. The only structural gaps are the Yoke and the Debtman/Lyra payoff.

**Owner approval:** Yes for Yoke/debt content; no for preserving existing scenes.

---

## 7. Act III–IV supporting cast

| Character | Role | First appearance | Built lines | Quest / function | Status | Missing |
|---|---|---|---:|---|---|---|
| **Berrin** | Cinderhollow burner; tithe choice | Ch6 Cinderhollow | 19 | `Q_SIDE_TITHE` | Built | Later consequence; approval of Ch7 |
| **Mott** | Blackwood carter/merchant | Ch6 built-only | 4 | Shop | Built | Not in chapter script; confirm canon |
| **The Burners** | Cinderhollow villagers | Ch6 | 4 (Burner) | Flavor | Built | Minor |
| **The Child** | Cinderhollow child | Ch6 | 1? | Flavor | Built | Minor |
| **The Blackwood Matriarch** | Ch7 boss | Ch7 glade | 0 | Boss | Built | Origin/lore; Ch7 approval |
| **The Lost Ones** | Ch7 enemies | Ch7 shrine | 0 | Encounters | Built | Origin; intentional mystery |
| **The Door Warden** | Ch8 boss | Ch8 clearing | 0 | Boss | Built | Origin; Ch8 approval |
| **Vell** | Coleford magistrate; Ch9 boss | Ch9 ledger house | 20 | Yields; `Q_SIDE_LEDGER` | Built | Sprite; Act IV approval |
| **Nessa** | Vell's clerk | Ch9 ledger house | 8 | `Q_SIDE_LEDGER` | Built | Sprite; Act V line |
| **The Barrow Warden** | Ch10 boss | Ch10 gatehouse | 0 | Boss | Built | Origin; Act IV approval |
| **The Forgotten King** | Ch11 boss | Ch11 last chamber | 0 | Boss | Built | Approval; dialogue or deliberate silence |

**Why it matters:** The Act III–IV cast is small and atmospheric; the supporting characters are functions in a dungeon. The major gaps are approval and the two side-quest defects, not missing personalities.

**Owner approval:** Yes for Ch7–8/Act IV approval; no for quest fixes.

---

## 8. Act V cast (approved, unbuilt)

| Character | Role | Script | Status | Missing |
|---|---|---|---|---|
| **Ilsa Fen** | Reeve of Saltreach; the half-cut name | Ch12 | Script only | Implementation; sprite; the slate choice |
| **The Fisher** | Boatman to the reef | Ch13 | Script only | Implementation; sprite; staging |
| **Maelin Orr** | Legible name on the eleven; knight-ordinary; not present | Ch13 | Name only | Implementation; no relation to the party, Kael's father, Mira or the knight |
| **The Toll-Keeper** | Ch12 boss; silent, drowned | Ch12 | Data only | Room, scene, art |
| **The Saltreach Leviathan** | Ch13 boss; beast set-piece | Ch13 | Data only | Room, scene, art |
| **The Fallen Knight** | Ch14 boss; yields; office reveal | Ch14 | Data only + scripts | Room, scene, dialogue data, yield |
| **Alden Marr (letter)** | Conditional letter on `ch11_seal_alden` | Ch12 | Script only | Implementation of the branch; no second-hand message on the party branch |
| **Sarn** | Ashlands trader (Act VII, built early) | Built-only | Built | Act VII story role; confirm canon |

**Why it matters:** Act V's cast is small by design. Its success depends on Ilsa Fen, the knight and the coast, not on a large supporting roster.

**Owner approval:** No for building approved roles; yes for any added character.

---

## 9. Act VI–VIII and finale cast (absent)

| Character / role | Status | Missing |
|---|---|---|
| **King Aldric IV** | Absent | Appearance, court, motive, defeat |
| **The Ash King** | Absent (item strings only) | Definition, appearance, encounter |
| **The Broken Yoke leader** | Absent | Name, structure, base, postwar role |
| **The Radiant Flame leadership** | Absent | Doctrine, leader, relation to the Crown |
| **The Black Hand leadership** | Absent | Leader, structure, Lyra's ties |
| **The Silver Guard leadership** | Absent | Order's fate, Sera's past |
| **Aethari survivors/records** | Absent | Act VI revelation |
| **Frostwilds civilization** | Absent | Act VIII revelation |
| **Alden's capital allies** | Absent | Who backs the usurpation |
| **The Ashen Crown** | Absent | Definition, bearer, final dungeon |

**Why it matters:** The late-game cast is not a list of missing NPCs; it is the missing political and mythological world. The finale cannot be populated only by the five companions and Alden.

**Owner approval:** Yes.

---

## 10. Factions as characters

| Faction | Known | Missing | Priority |
|---|---|---|---|
| **The Crown of Eldoria** | Ruled by Aldric IV; knows the Crownveil is failing; hides the truth; occupies Wrenfield; maintains the barrow road | Court, ministries, army leadership, palace, motive, postwar fate | HIGH |
| **The Broken Yoke** | Named rebellion; Taren is a captain; Derry is a contact; Alden is involved; serfs accused of aiding it | Leader, structure, base, founding, suppression, split, postwar fate | CRITICAL |
| **The Silver Guard** | Sera's former order; elite military order | Leadership, doctrine, relation to the Crown, Sera's exit | MEDIUM |
| **The Black Hand** | Criminal network; Lyra has ties; the Debtman is not its leader | Leadership, structure, Lyra's ties, role in the plot | MEDIUM |
| **The Radiant Flame** | Temple presence; acolyte in Valemere; Greyhaven chapel's order unnamed | Doctrine, leadership, relation to the Crown/Crownveil | MEDIUM |
| **The Ashbound** | Hunter carries the parchment; varied beliefs; some worship/study the Ash | Leader, sender, purpose, relation to Mira | HIGH |
| **The Aethari / Architects** | Ancient advanced civilization; built the Crownveil/Crown Engine; ruins, sanctuaries, doors | Fate, cities, survivors, relation to the Crown, Engine's state | CRITICAL |
| **The Fallen Knights** | An office: knights sent across the Crownveil who came back | List, the eleven, the knight's identity, the Crown's purpose | HIGH |
| **The serfs** | Wrenfield, Cinderhollow, Saltreach; victims of tithes/occupation | Agency, leaders, postwar fate | HIGH |

**Why it matters:** The story's political conflict is only as believable as its factions. At present the Crown has a king who never appears, the rebellion has no leader, and the serfs have no voice of their own.

**Owner approval:** Yes.

---

## 11. Character arc completion matrix

| Character | Beginning | Middle | Late | End | Status |
|---|---|---|---|---|---|
| **Kael** | "I just need to find Mira." Built | "I need to know why this happened." **Missing** | "If I have to sacrifice myself…" **Missing** | "I can't keep losing people…" **Missing** | Beginning only |
| **Taren** | Joins the fight; speaks warmly of Alden. Built | Yoke captain; first doubt. Partial | Open split from Alden. **Missing** | Confronts Alden with Kael. **Missing** | Recruitment + seed |
| **Lyra** | Joins for coin; debt hook. Built | Professional trust. Partial | Chooses the party over the debt. **Missing** | Black Hand/debt resolution. **Missing** | Recruitment + hook |
| **Caelan** | Joins for answers; withholds. Built | Aethari/Engine exposition. Partial | Spends what he knows. **Missing** | Aethari/Engine resolution. **Missing** | Recruitment + withheld |
| **Sera** | Joins for her oath; refuses the palace. Built | Moral compass. Partial | Palace secret payoff. **Missing** | Silver Guard/order resolution. **Missing** | Recruitment + withheld |
| **Alden** | Sincere friend and revolutionary. Built | Ambition seed; takes the seal. Partial | Seizes the capital. **Missing** | Three-phase boss; tragic end. **Missing** | Setup only |
| **Mira** | Absent; clues only. Built | Absent. **Missing** | Absent. **Missing** | Present-day role. **Missing** | Clue only |

**Why it matters:** The matrix shows a consistent pattern: the game is excellent at beginnings and recruitment, and almost empty at late-act payoffs. This is the single most important writing pattern to correct.

**Owner approval:** Yes for all new arc content.

---

## 12. Characters with zero or near-zero implementation

| Character | GML status | Note |
|---|---|---|
| **Elira Varyn** | **0 references** | Only "Mother's table" in the ruined house |
| **King Aldric IV** | **0 references** | Rumor only in Chapter 3 dialogue; no name in GML |
| **Mira Varyn** | **0 speaker lines** | 20 references across built dialogue; no present-day actor |
| **The Ash King** | **2 item strings** | No enemy, scene or line |
| **The Ashen Crown** | **0 story references** | Only the game title/logo; reserved for the finale |
| **The Broken Yoke leader** | **0** | No character exists |
| **The Radiant Flame leader** | **0** | Acolyte only |
| **The Black Hand leader** | **0** | Lyra's ties only |
| **The Silver Guard leader** | **0** | Sera's past only |
| **The Forgotten King (speaker)** | **0 speaker lines** | Built boss; no spoken dialogue |

**Why it matters:** These are not minor omissions. They are the story's missing faces: the mother, the king, the sister, the endgame power, the rebellion's leader and the orders behind three companions.

---

## 13. Character completion priorities

### CRITICAL

1. **Alden's full Ending C arc** — turn, takeover, three-phase boss, Taren confrontation.
2. **Aldric IV** — appearance, motive, defeat, legacy.
3. **Mira** — present-day payoff and role in the ending.
4. **Kael's middle/late/end arc** — the approved quotes and the final choice.
5. **The Broken Yoke** — leader/structure and postwar fate.
6. **The Ash King** — definition and endgame role.

### HIGH

7. **Taren's split from Alden** and his final confrontation.
8. **Sera's palace secret** and Silver Guard resolution.
9. **Caelan's Aethari/Engine knowledge** and why he hid it.
10. **Lyra's Black Hand/debt payoff**.
11. **The Fallen Knight's identity** and family connection.
12. **Tomas's and Elira's fates**.
13. **The Blackguard's identity** and source of knowledge.
14. **The Forgotten King's approval** and dialogue/silence decision.

### MEDIUM

15. Hailen/Calder/Debtman/Vell aftermath.
16. Nim/Derry/Mott/Sarn supporting roles.
17. Ilsa Fen and Maelin Orr implementation.
18. The Radiant Flame/Silver Guard/Black Hand leadership.
19. Vell/Nessa portraits (their 16×24 overworld sets shipped 2026-11-18).
20. The Toll-Keeper/Leviathan/Fallen Knight Act V presentation.

### LOW

21. Greyhaven survivor closure.
22. Wrenfield tavern/store texture.
23. Generic soldier/guard barks.
24. Optional camp/NPC flavor.

---

## 14. What not to do

- Do not make Alden evil without explanation; he must remain tragic.
- Do not kill or redeem a companion for shock value without an arc.
- Do not name the Fallen Knight or answer Mira in a document; those are story decisions, not audit conclusions.
- Do not merge the Ash King, the Forgotten King and the Fallen Knight into one figure without explicit canon support.
- Do not treat a built line as a completed arc.
- Do not claim any character is “fully implemented” until the chapter is compiled and played.

---

**Bottom line:** The cast is introduced well and developed unevenly. The five companions all have strong recruitment scenes and almost no late-game payoff; Alden has a strong setup and no tragedy; Aldric, Mira and the Ash King are absent; the Broken Yoke has no leader. The character work that remains is large but specific, and it is concentrated in Acts V–VIII and the finale.
