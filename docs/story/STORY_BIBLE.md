# ASHEN CROWN — Story Bible

**Studio:** Eastern Goat Forge · **Engine:** GameMaker Studio (GML) · **Genre:** Dark medieval fantasy RPG, classic turn-based combat · **Platform:** PC
**Source:** this bible's own canon, the chapter scripts (`CHAPTER1_SCRIPT.md`–`CHAPTER11_SCRIPT.md`), the act outlines (`ACT2_OUTLINE.md`–`ACT5_OUTLINE.md`) and every owner decision through **2026-11-16**, which are recorded in the [Decision log](#11-decision-log). (The older `MASTER_GDD.txt` this header used to cite is not in the repository; no substitute has been invented.) Anything still undecided is marked **Open** and listed in [Open questions for Kevin](#10-open-questions-for-kevin). Chapter scripts `CHAPTER1_SCRIPT.md`–`CHAPTER5_SCRIPT.md` are all approved canon; `ACT2_OUTLINE.md` carries the Act II structure. `CHAPTER6_SCRIPT.md` is a **PROPOSED** draft for the owner — nothing in it is canon yet.

## Canon status legend

| Tag | Meaning | What Coder and Design should do |
|---|---|---|
| **[C]** Canon | Stated in the master design doc | Build from it as written |
| **[C-confirmed]** Confirmed canon | Decided by Kevin after the doc was written (see the [Decision log](#11-decision-log)) | Build from it. It overrides the doc |
| **[PROPOSED]** Proposed | A suggestion from the lore agent that Kevin hasn't approved | Don't build it as final yet |
| **[C-locked]** Locked canon | The doc explicitly says it is locked | Never change it without Kevin |
| **[O]** Open | Undecided, ambiguous, or mentioned but not defined | Don't invent it. Use a placeholder and ask Kevin |
| **[U]** Unconfirmed | A candidate the doc gives, explicitly not final | Can prototype it, but don't ship it as canon |

Quotes are copied exactly from the doc (curly quotes and ellipses included).

---

## 1. Premise and tone

- **[C]** ASHEN CROWN is "a dark medieval fantasy RPG about a ruined kingdom, a mysterious ancient barrier, a missing sister, and the dangerous consequences of humanity uncovering something that was never meant to be found."
- **[C]** Kael Varyn, a former soldier, comes home to find his village destroyed and his younger sister missing. His personal search turns into a journey into the forgotten history of the kingdom of Eldoria and the truth behind an ancient force called **the Ash**.
- **[C]** Tone ingredients: dark fantasy, medieval kingdoms, ancient ruins, political corruption, religious conflict, tragic character development, mystery, exploration, party relationships, difficult moral decisions, and occasional humor and character banter.
- **[C]** It should feel like a classic RPG with modern quality-of-life improvements. Classic Final Fantasy inspires the structure and presentation only. Copying its characters, art, music, maps or assets is not allowed.
- **[C]** The look is dark, atmospheric medieval fantasy: stone castles, medieval villages, ruined fortresses, ancient underground structures, dense forests, forgotten temples, snow-covered ruins, ash-covered wastelands, distinct enemy designs, readable character sprites and detailed environmental storytelling. If the project uses pixel art, keep the style consistent.
- **[C]** Story rule: "The story must preserve the mystery of the Crownveil and the Ash."
- **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) **Exploration camera:** FF1-style top-down for the overworld and exploration.
- **[O]** **Battle presentation:** presumably FF1-style menu battles unless Kevin says otherwise. The doc also mentions a "hybrid, varying by encounter" presentation, so this still needs his final word.

---

## 2. World

### 2.1 Eldara and Eldoria
- **[C]** The game takes place on the continent of **Eldara**.
- **[C]** **Eldoria** is the central kingdom. It is an old kingdom built on the remains of an ancient civilization (the Architects).
- **[C]** Its people believe an enormous magical barrier, the **Crownveil**, has protected the kingdom for centuries. The Crownveil is now beginning to fail.
- **[C]** Eldoria is ruled by **King Aldric IV**. The kingdom is growing more unstable. The king knows the Crownveil is failing and has hidden the truth.
- **[C]** The population is split between loyalty to the crown, religious belief, rebellion, and fear of the Ash.
- **[C]** The royal government is **not** entirely evil. It includes ordinary people, corrupt officials, honorable soldiers, and people who sincerely believe they are protecting the kingdom.

### 2.2 The Architects (also called the Aethari, see 2.5)
- **[C]** An ancient civilization that existed thousands of years before modern Eldoria. Their knowledge of magic and technology was far beyond that of modern kingdoms.
- **[C]** They **created the Crownveil**.
- **[C]** Their surviving records are fragmented, damaged and hard to interpret.
- **[C]** Their civilization disappeared. What remains: underground cities, stone doors, ancient machinery, forgotten temples, strange symbols, ruined fortresses, records about the Ash, and evidence of a catastrophic event.
- **[C]** The player gradually discovers the Architects' true purpose.
- **[O]** What that purpose was, what the catastrophe was, and what happened to the Architects.

### 2.3 The Ash
- **[C]** A mysterious force that is **not native to the world**.
- **[C]** It can corrupt creatures, people and locations. It should shape enemies, bosses, environment design and story events.
- **[C]** It should stay mysterious for much of the game: "Do not reveal every aspect of the Ash immediately."
- **[C]** What each faction believes:

| Group | Belief about the Ash |
|---|---|
| The Church (Radiant Flame) | Corruption, and punishment for mankind |
| Royal scholars | An unknown magical phenomenon |
| The Ashbound | Alive, and it communicates with those who listen |
| Architect records | It came from outside this world |

- **[C]** Ashburn is a planned status effect. The Ash King appears in the doc as a story element but is never defined (**[O]**).

### 2.4 The Crownveil
- **[C]** An ancient barrier created by the Architects. It is deteriorating in the present day.
- **[C]** Core twist: "The Crownveil was not built to keep something out. It was built to keep something in."
- **[C]** Its failure is connected to the destruction of Greyhaven and the disappearance of Mira Varyn.
- **[C]** The Ashlands lie "beyond the Crownveil."
- **[C]** Truths the player learns **gradually** (each one is canon as a *question to be answered*, but the answers are **[O]**):
  1. Why the Crownveil was created.
  2. What lies beyond it.
  3. Why it is failing.
  4. What happened to the Architects.
  5. Why Mira became involved.
  6. Why the Ash King is connected to it.
- **[C] Must stay mysterious:** the true nature of the Ash and of the Crownveil should not be revealed early. Pace these revelations across the acts. Chapter 1 gives clues only (the shared symbol, the carvings, "She crossed the Crownveil").

### 2.5 The Aethari **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
- An extraordinarily advanced civilization. They understood things modern humans barely recognize:
  - the ancient magic known as **Lumen**
  - the nature of the Crownveil
  - the relationship between life and the Ash
  - how to build powerful magical mechanisms
  - how to contain supernatural forces
- They built enormous cities, sanctuaries, temples and underground structures.
- Their greatest achievement was the **Crown Engine**, a mechanism associated with maintaining the Crownveil.
- **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) Caelan is recruited at an abandoned Aethari sanctuary (Act II): **the Hollow Sanctuary**, a day's travel from Valemere in the countryside. It is a self-contained dungeon.
- **[C-confirmed]** (Kevin via Coder, Nov 14 2026) **The Aethari and the Architects are the same people.** "We can use both names depending on who's talking about them." Everything in 2.2 (The Architects) applies to the Aethari too.

#### Naming guide: Aethari vs Architects **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
| Name | Who uses it |
|---|---|
| **Architects** (the common modern Eldorian term) | Ordinary people, villagers, soldiers, the Crown, most of the Radiant Flame, and Kael early in the game. Also the **default for UI, bestiary and quest text**. |
| **Aethari** (the true, old name) | People with deep or forbidden knowledge: Caelan (former royal scholar), royal scholars and archives, the Aethari's own records and inscriptions, some of the Ashbound, and anyone who has learned the truth. **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) Kael and the party shift to "Aethari" in dialogue after the revelation at Caelan's recruitment in Act II, at the Hollow Sanctuary. UI, bestiary and quest text stay on "Architects." |

Example lines **[C-confirmed]**, illustrations of the guide and not scripted scenes:
- Villager: "Don't go poking at those old Architect stones. Nothing good comes up out of the ground."
- Kael (early): "More Architect carvings. Whoever they were, they liked doors."
- Caelan: "The Architects. That's what the textbooks call them. They called themselves the Aethari."
- Inscription (Aethari record): "Here the Aethari set the first stone of the Veil."
- Kael (after the revelation): "The Aethari built this to hold something. We need to know what."

- **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) Where the sanctuary is: the Hollow Sanctuary, a day's travel from Valemere in the countryside.
- **[O]** What the sanctuary was for, and why it was abandoned. What happened to the Aethari (same as the open Architects question).

### 2.6 Lumen **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
- The ancient magic the Aethari understood.
- **[O]** How it works. How it relates to modern magic (Caelan's fire, ice, lightning and dark spells, Sera's holy magic), and whether modern magic descends from it. Whether Ending 3's "magic is permanently destroyed" includes Lumen. Any connection to the Ash.

### 2.7 The Crown Engine **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
- The Aethari's greatest achievement: a mechanism associated with maintaining the Crownveil.
- **[O]** Where it is, its current state (and whether its condition causes the Crownveil's failure), how it works, and whether it ties to the crown imagery (the carvings' crown around a black sun, the royal banner, the game's title).

---

## 3. Regions

**[C]** The world has seven major regions. Smaller named settlements: Greyhaven (a region in its own right) and Millhaven (see below; confirmed Nov 14 2026).

| # | Region | Canon details |
|---|---|---|
| 1 | **Kingdom of Eldoria** | The central kingdom. Capital: **Valemere** (about 80,000 residents). Districts: Royal District, Merchant District, Lower City, Temple District, Military District, Old Quarter. Major hub for politics, quests, shops, factions and party development. |
| 2 | **Greyhaven** | Kael's hometown. A small farming and trading settlement of about 1,200 residents. **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) Already destroyed when Kael arrives. The destruction itself is not played. |
| 3 | **Blackwood** | A cursed forest: missing travelers, strange creatures, ancient stone doors, unnatural darkness, forgotten ruins, connections to Mira's disappearance. |
| 4 | **Ironspine Mountains** | A dangerous mountain region with ancient Architect ruins: mountain passes, abandoned mines, underground structures, ancient machines, powerful enemies, important Crownveil discoveries. |
| 5 | **Drowned Coast** | A coastal region with submerged remains of an ancient civilization: flooded ruins, coastal villages, shipwrecks, underwater or submerged exploration where technically appropriate, ancient records. **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) The named coastal village is **Saltreach**. |
| 6 | **Ashlands** | A dead region beyond the Crownveil: ash-covered ground, distorted landscapes, mutated creatures, broken ancient structures, dangerous environmental effects, major story revelations. |
| 7 | **Frostwilds** | A northern region: frozen ruins, snow-covered settlements, an ancient northern civilization, difficult environmental conditions, late-game enemies and story content. **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) The named settlement is **Rimehold**. |

### Millhaven **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
- A settlement, and Taren Holt's place of origin.
- **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) It lies near **Wrenfield**, the Crown-occupied village where Taren's recruitment begins in early Act II.
- **[O]** Its region, size, layout and current state. Whether Kael, Taren and Alden grew up together there or in Greyhaven (Kael's home).

### Wrenfield **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
- The Crown-occupied village near Millhaven where Taren Holt is recruited in Act II. Full Chapter 2 script: `CHAPTER2_SCRIPT.md` (approved Nov 14 2026, 3:00 PM ET).
- The Crown has seized several villagers, accused of aiding the Broken Yoke, and scheduled them for public execution. The party and Taren stop the hanging and free all of the accused, with a close call (the rope is already on a neck when they intervene). The Crown retreats; the village stays under occupation.
- The prisoner with the rope is **Bram**, a young man among four accused on the posted list. His sister **Oda** offers the optional quest **The One on the List** (reward: Minor Potion x2, 40 Gold), which can be accepted before the hanging and turns in afterward. If Oda is not spoken to beforehand, the quest can start and complete on a single talk after the rescue.
- Locations in the village: the square and gallows, checkpoints at the approaches, **The Bent Post** (tavern, keeper **Perrin**), and a store run by **Len**.
- Chapter 2 boss: **Reeve Calder**, a Crown occupation officer who believes he is keeping order. Human, not Ash-corrupted. Fought with a small detachment of Crown Soldiers. Kit: Guard; a shout that buffs his soldiers; a heavy strike; a harder stance when the detachment falls. After the fight he yields, lives, and withdraws with his remaining men to the village checkpoints.

### Millhaven Road **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
- The overworld road from the Watchtower / Greyhaven route toward Wrenfield and the Millhaven area. Suggested levels 8–10. Encounters may include Crown Patrols as well as Bandits and Ash Wolves.
- The hook to Wrenfield is unmissable here: a **Traveler** delivers it, with a weathered Crown notice as backup. If Greyhaven is visited first, **Pell** and **Corwin** say the same thing. Millhaven may be named on a signpost but is not toured **[O]** (question 10).

### Wrenfield and Millhaven Road NPCs **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)

| Name | Role | Location |
|---|---|---|
| **Reeve Calder** | Crown occupation officer; Chapter 2 boss. Yields, lives, withdraws to the checkpoints | Wrenfield square, then the checkpoints |
| **Bram** | Close-call prisoner; one of the four accused | Wrenfield gallows / square after the rescue |
| **Oda** | Bram's sister; giver of **The One on the List** | Wrenfield square |
| **Perrin** | Tavern keeper of **The Bent Post** | Wrenfield |
| **Len** | Shopkeeper | Wrenfield store |
| **Traveler** | Delivers the unmissable hook toward Wrenfield | Millhaven Road (first stretch) |
| **Crown Sergeant** | Holds the Wrenfield approach; still there after the Crown pulls back | Wrenfield gate / checkpoint |
| **Crown Soldiers** | Occupation troops; some unwilling, some firm. Also appear as road patrols | Wrenfield square and checkpoints; Millhaven Road |

### Valemere Road **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
- The overworld road from Wrenfield's west exit to the capital. Suggested levels 10–13. Crown presence increases as the walls come into view. Encounters may include Crown Patrols, Bandits, and tougher Zone 2 road enemies.
- **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) The first Act II Fallen Knight sighting is here, after Taren has joined and before the city. He is never named and never fights. His line: *“You cannot cross where she did. Not yet.”* He walks off. Set `flag_fk_seen_3`.
- Optional: **Derry**, a Broken Yoke contact who will not name a leader; a hamlet rumor that the king has been closed up in the Royal District (Aldric's motives stay **[O]**, question 15).

### Valemere (Act II hub) **[C / C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
- **[C]** Capital of Eldoria, about 80,000 residents. Districts: Royal, Merchant, Lower City, Temple, Military, Old Quarter. Major hub for politics, quests, shops, factions and party development.
- Full Chapter 3 script: `CHAPTER3_SCRIPT.md` (approved Nov 14 2026, 3:53 PM ET). Chapter title: **Crowns and Alleys**. Suggested levels 10–13.
- The Royal District is visible and largely closed. Official channels will not talk about the Crownveil's failure, or about Mira. The Lower City is where the party buys a lead the Crown will not give. Taren's presence as a Rebel Captain colors the gates, checkpoints, and NPC talk. They are not here to seize the city.
- Named Chapter 3 places: the gates; **Weigh-House Square** (on the seam of the Merchant District and the Lower City); **the Salt Lamp**, a Lower City dive run by the fence **Nim**; a Crown seized-goods warehouse on a Lower City lane; a west-country road out of the city toward the Hollow Sanctuary.
- The party meets **Alden Marr** in person in Weigh-House Square, unmissable on the way to the Salt Lamp, before the job. He greets them as friends, is sincere about freeing the serfs, and speaks one line that already thinks ahead to "when we hold the city." There is no split.
- Nim sells the lead: seized notes belonging to a royal scholar who left court, pointing at the Hollow Sanctuary, and using the word "Architects" only. They do not explain the Veil, name Lumen, locate the Crown Engine, or have to name Caelan Rook.
- Optional side quest: **A Parcel Unsealed** (`Q_SIDE_PARCEL`), given by Nim (reward: 60 Gold, Antidote x2). It can be accepted before or after Lyra joins and does not require her.
- Chapter 3 boss: **the Debtman**, a human Lower City enforcer tied to the stolen document, not a named Black Hand leader. The Debtman is a moniker, not a Black Hand title. Fought with 1–2 Lower City toughs. Kit: a fast knife strike; **Collect** (a debuff or a small HP drain); a bind or net that can Slow or Immobilize one target; he fights meaner and faster when the toughs fall. Exact stats stay for Coder and Design to balance. After the fight he withdraws, alive, leaving the debt hanging.
- The chapter ends on a complete screen and a save, then hands off toward the Hollow Sanctuary (Chapter 4).

### Valemere and Valemere Road NPCs **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)

| Name | Role | Location |
|---|---|---|
| **Alden Marr** | First on-screen appearance; greets Kael and Taren as friends. No split | Weigh-House Square |
| **Lyra Veyne** | Second recruit; takes the paid warehouse job, then joins the party | the Salt Lamp, then the party |
| **the Debtman** | Chapter 3 boss; human Lower City enforcer (moniker only). Withdraws, alive | seized-goods warehouse |
| **Nim** | Fence; sells the scholar-notes lead; giver of **A Parcel Unsealed** | the Salt Lamp |
| **Gate Captain** | Admits the party; notes Kael's Greyhaven service and looks hard at Taren | Valemere gates |
| **Derry** | Optional Broken Yoke contact; will not name a leader | Valemere Road |
| **Acolyte of the Radiant Flame** | Temple presence; doctrine details and leaders stay **[O]** | Temple District |
| **Crown Clerk** | Official channel; will not talk about the Crownveil or Mira | Merchant District |
| **Drill Sergeant** | Notes Kael's old drill and Taren watching the yard | Military District |
| **Crown Guard** | Turns petitioners away; Royal District closed this month | Royal District exterior |
| **Stallkeeper** | Merchant goods; also the turn-in for Nim's parcel | Merchant District |
| **Street hawker** | Points the way to the Salt Lamp | Lower City mouth |

### The Hollow Sanctuary **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
- The abandoned Aethari sanctuary where Caelan Rook is recruited in Act II.
- A day's travel from Valemere, in the countryside. A self-contained dungeon.
- This is where the party learns the Aethari name and, afterward, shifts to saying "Aethari" in dialogue (see 2.5).
- Chapter 4 is **The Old Name** **[C-confirmed]** (approved Nov 15 2026), levels **13–16** **[C-confirmed]**. Full script: `CHAPTER4_SCRIPT.md`.
- Caelan becomes controllable at the start of the Warden fight, in the fourth slot, as Lyra does at the Debtman; the join conversation follows the battle **[C-confirmed]**.
- Chapter 4 boss: **the Sanctuary Warden** **[C-confirmed]** — an ancient Aethari guardian-construct that shows Aethari mechanisms without explaining the Crown Engine.
- **Whose scholar-notes the party carries** (from the Chapter 3 heist) is left **unstated** **[C-confirmed]**: Caelan recognizes the Crown seal, not necessarily the hand. That is a canon silence, not a gap to imply away.
- Alden does not appear; Taren has one optional line **[C-confirmed]**.
- The chapter ends on the road out of the hollow with `Q_BV_S6` active and the chapter-complete screen.
- **[O]** What the sanctuary was for, and why it was abandoned.

### The Blackwood Road Garrison **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
- The royal garrison where Seraphine Thorn is recruited in Act II. A royal post on the forest road toward the Blackwood.
- Sera is detained there as a deserter. The party comes for a Blackwood lead and finds her. She will not say what she saw in the palace (that remains **[O]**).
- Chapter 5 is **The Deserted Oath** **[C-confirmed]** (approved Nov 16 2026), levels **16–18** **[C-confirmed]**. Full script: `CHAPTER5_SCRIPT.md`.
- The party is **not** let in: the gate sergeant's ledger has Taren's name and the gate closes behind them, so the Hailen fight is an arrest that fails rather than an ambush **[C-confirmed]**.
- Sera is held **awaiting transport to the capital, not formally sentenced** **[C-confirmed]**.
- Sera joins **after** the fight, in the records-room aftermath, and is available from the road onward **[C-confirmed]**.
- The Blackwood lead is a **sealed Crown order bearing a non-Crown seal**, telling the post to stop looking **[C-confirmed]**.
- The chapter ends at the **Blackwood treeline** with `Q_BV_S7` active and the act-complete card **[C-confirmed]**. Built as two rooms, `rm_blackwood_garrison` and `rm_garrison_keep` **[C-confirmed]**.
- Chapter 5 boss: **Commander Hailen** — the garrison's commanding officer, an honorable Crown soldier holding a bad post. Not a villain, not Ash-corrupted, no cruelty or cowardice **[CANON]**. The player may choose before the fight not to kill Crown soldiers, which sets `flag_hailen_yields` and lets him yield; otherwise he fights to the death **[C-confirmed]**.

### Saltreach **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
- The named coastal village of the **Drowned Coast**.
- **[O]** Its size, layout, current state, and where the Drowned Coast falls in the eight acts.

### Rimehold **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
- The named settlement of the **Frostwilds**.
- **[O]** Its size, layout, current state, and where the Frostwilds falls in the eight acts. Whether the Frostwilds' "ancient northern civilization" is the Aethari/Architects is also still **[O]**.

### Greyhaven locations [C]
Varyn House · Rusted Boar Tavern · Greyhaven Chapel · Blacksmith · General Store · Town Square · Old Watchtower · North Gate

- **[C]** The Zone 1 area list for Greyhaven gives the same places, minus the Old Watchtower, and calls the chapel just "Chapel." It names Greyhaven a safe area with no random battles. In Zone 1 the Old Watchtower is a separate dungeon, reached after the Old Road and the Bandit Camp.
- **[O]** Whether the Old Watchtower is inside Greyhaven or out along the road.
- **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) Named settlements: **Saltreach** (Drowned Coast coastal village) and **Rimehold** (Frostwilds settlement). **[O]** No region has a canon map or layout. The "ancient northern civilization" in the Frostwilds is not named, and the doc doesn't say whether it is the Architects.

---

## 4. Factions

| Faction | Canon [C] | Open [O] |
|---|---|---|
| **The Crown** | Eldoria's ruling government, led by King Aldric IV. Its military keeps order across the kingdom. Not portrayed as purely evil. | Named officials and generals. |
| **Radiant Flame** | The dominant religious institution. Teaches that the Ash is a corruption of mankind. Members range from sincere believers to dangerous extremists. | Leaders, doctrine details, and whether Greyhaven Chapel belongs to it. |
| **Silver Guard** | An elite military order serving the kingdom. Seraphine Thorn once served in its ranks. | Its leadership and its relationship to the Royal Army. |
| **Black Hand** | A criminal organization operating across the kingdom. Controls smuggling, information, underground trade and criminal networks. Lyra has ties to it. | Leaders, and the nature of Lyra's ties. |
| **Ashbound** | People who have become connected to the Ash. Some worship it, some study it, others believe they understand its true nature. Their beliefs are deliberately varied. In-game, the Ashbound Hunter enemy carries the parchment about Mira. | Who leads them, if anyone. Who sent the Hunter, and why. |
| **The Broken Yoke** (the rebellion) | The population is split partly toward "rebellion," and Alden Marr has a "relationship with the rebellion" that is still to be written. **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) The rebellion is named **the Broken Yoke**. Its original purpose is freedom for the people, a system people govern themselves, and Taren embodies it. Taren Holt is a Rebel Captain in it. Alden starts out sharing its dream, then turns to seizing the throne himself. | Its leader, structure and base. Alden's exact role and rank in it, and whether he splits from it or takes it with him. |

---

## 5. Characters

### Party roster **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
- **Five playable party members:** Kael (Vanguard), Lyra (Rogue), Caelan (Arcanist), Sera (Warden), Taren (Rebel Captain, heavy swords; starts with a bastard sword). **Four fight at a time.** This overrides the doc's "The party contains four main characters."
- **[C]** Classic ordered party: formation affects targeting, defense and damage, and the player rearranges the order through the Adventure menu.
- **Note for Coder:** Party Order must support **4 active slots plus 1 reserve slot**, letting the player swap a reserve member in and out. Battle, the save system and XP rules need to handle a benched member (whether the reserve earns XP is **[O]**).
- **Note for Coder:** the party now has **two frontline melee fighters, Kael and Taren**. Formation and targeting rules should allow both to hold front slots, and their kits should be distinct. Taren's skill kit is set in 5.5, with numbers still open. Lyra's starting kit is set in 5.2 (Twin Cut, Open Vein, Cutthroat), with numbers still open.
- **Note for Coder:** the equipment system needs a **"heavy sword" weapon category**. Taren can equip any weapon in it, and his starting weapon is a bastard sword in that category. Which other characters, if any, can use heavy swords is **[O]**, as is the list of heavy swords.
- **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) **Recruitment order, all in Act II (The Broken Crown):** 1) Taren Holt, at **Wrenfield**, a Crown-occupied village near Millhaven (public execution of accused rebel sympathizers; all of the accused are freed, the village stays occupied). 2) Lyra Veyne, in Valemere's Lower City (a paid job to steal a seized scholar's document that points to the Hollow Sanctuary). 3) Caelan Rook, at **the Hollow Sanctuary**, an abandoned Aethari sanctuary a day's travel from Valemere; the party learns the Aethari name here. 4) Seraphine Thorn, at **the Blackwood Road Garrison**, where she is detained as a deserter. Since everyone else joins in Act II, Kael travels alone in Act I (consistent with `CHAPTER1_SCRIPT.md`).
- **[O]** Whether the story restricts swapping, e.g. forced or locked members in certain scenes. The reserve slot only matters once the fifth member joins (Sera).

### 5.1 Kael Varyn — protagonist [C]
- **Age** 24 · **Home** Greyhaven · **Class** Vanguard · **Weapon** Longsword · **Role** Balanced frontline physical fighter (frontline damage, balanced physical attacks, protection, consistent damage).
- **Personality:** quiet, stubborn, protective, occasionally sarcastic, loyal, haunted by his past.
- **Greatest strength:** protecting others. **Greatest weakness:** survivor's guilt.

**Family [C]**
- **Father, Tomas Varyn:** former soldier who became a blacksmith. Dying when Kael returns.
- **Mother, Elira Varyn:** the village healer.
- **Sister, Mira Varyn:** younger sister, "twelve when the tragedy began." Central to the opening story.

**Backstory [C]**
1. Kael served four years in the Royal Army.
2. He returns to Greyhaven after the village has been destroyed. **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) He arrives after the destruction, and the destruction is not played.
3. His father is dying. Tomas tells him: *“Your sister… she went into the woods.”*
4. Kael searches the ruins of his home and finds **Mira's wooden pendant**. There is no body. **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) He finds it in the ruins of Varyn House. She did not give it to him.
5. Earlier, Mira had found a **strange black stone** in the woods. It bore a symbol connected to the Crownveil. She was told to throw it away but kept it.
6. A **Fallen Knight** recognizes Kael and says: *“Your father knew what was coming.”* Later the knight says: *“She opened the door.”*
7. Mira found a passage beneath Greyhaven and accidentally opened something connected to the Crownveil. "Something came looking for her."

**Arc quotes [C]**
| Stage | Line |
|---|---|
| Beginning | “I just need to find Mira.” |
| Middle | “I need to know why this happened.” |
| Late | “If I have to sacrifice myself to stop this, so be it.” |
| End | “I can’t keep losing people because I’m afraid to let them go.” |

**Abilities [C]**
- **Last Stand (passive):** when Kael drops below 25% HP, Attack +15% and Defense +10%.
- **Ashen Resolve (later ability):** when an ally is defeated, Attack +20%, Defense +20%, and "Ash increases by 1." **[O]** The doc never defines an "Ash" stat or meter.

**The wooden pendant [C]**
- A permanent story item: Mira's wooden pendant, which Kael **finds in the ruins of Varyn House**. **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) Mira did not give it to him. This replaces the doc's line "given by Mira."
- It carries the same symbol as the old royal banner in the Old Watchtower and the symbol connected to the Crownveil.
- **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) That shared symbol is **a crown ringing a black sun**, the same mark as the Watchtower banner and the Watchtower Basement carvings.
- At the end of Chapter 1 it reacts to the sealed stone door.

### 5.2 Lyra Veyne — Rogue [C]
- **Weapon:** twin daggers. **Role:** critical hits, bleeding, poison, multiple attacks, stealth, fast damage.
- **Personality:** sarcastic, selfish at first, loyal once trust is earned, brings occasional humor.
- **Background:** from the lower city and the criminal underworld. Has ties to the Black Hand.
- **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) **Joins:** second recruit, in Act II, in Valemere's Lower City. The lead is sold by **Nim**, a fence at **the Salt Lamp**. Mid-heist, **the Debtman** and his toughs cut the party off as they leave with the notes. Lyra becomes controllable at the start of the Debtman fight (3rd party slot). The longer "I signed a job" conversation happens after the battle. She finishes the job and stays because she is now exposed.
- **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) **Recruitment hook:** the party needs a thief to steal a seized document (a scholar's notes) that points toward the Hollow Sanctuary. Lyra takes the job for coin.
- **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) **Starting skills at join (Chapter 3):** Twin Cut (two successive hits), Open Vein (applies Bleed), and Cutthroat (passive: increased critical chance). Poison and stealth skills unlock later. Exact numbers stay **[O]**. **Note for Coder:** these need balancing values in the skill and character databases. Use placeholders until they're set.
- **[O]** The nature of her Black Hand ties (question 6). The Debtman can imply a debt; that does not define the ties, or name Black Hand leadership.

### 5.3 Caelan Rook — Arcanist [C]
- **Weapon:** spellbook. **Role:** fire, ice, lightning and dark magic; exploiting enemy weaknesses; magical damage.
- **Background:** former royal scholar. He knows more about the Crownveil, and why it broke, than he admits at first.
- **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) **Joins:** third recruit, in Act II, at **the Hollow Sanctuary**, an abandoned **Aethari** sanctuary a day's travel from Valemere in the countryside (see 2.5 and 2.7).
- **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) At this recruitment the party learns the Aethari name: inscriptions say "Aethari," and Caelan explains that "Architects" is the textbook name. Party dialogue shifts to "Aethari" afterward; UI, bestiary and quest text stay on "Architects."
- **[C-confirmed]** (Nov 15 2026) **Recruitment texture (`CHAPTER4_SCRIPT.md`):** found in the sanctuary's records hall, lamp lit, spellbook in hand, wary of Crown colors. He names **Lumen** and the **Crown Engine** without explaining either, and deflects questions about why the Veil broke: "If I told you what I think, you would take it for an answer. It isn't one yet." He becomes controllable at the start of the Sanctuary Warden fight (4th slot) and joins permanently after the battle, because the answers are not in the stone. Starting skills: **Ember** (fire), **Frost Lance** (ice), **Arc Bolt** (lightning); dark magic unlocks later. Skill names are approved; numbers stay **[O]**.
- **[O]** What exactly he knows about the Crownveil and why it broke, and what he was hiding from at the sanctuary.

### 5.4 Seraphine "Sera" Thorn — Warden [C]
- **Weapon:** holy sword. **Role:** healing, shields, buffs, resurrection, holy damage.
- **Background:** former Silver Guard knight. She left the kingdom after witnessing something inside the royal palace.
- **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) **Joins:** fourth recruit, in Act II, at **the Blackwood Road Garrison**. She is detained there as a deserter. The party comes for a Blackwood lead and finds her. She will not say what she saw in the palace.
- **Chapter 5 — The Deserted Oath** **[C-confirmed]** (approved Nov 16 2026), levels 16–18. She is held awaiting transport to the capital, not formally sentenced; the party is let into the garrison only as far as the gate before it closes behind them.
- **Joins after the Hailen fight** **[C-confirmed]**, in the records-room aftermath, in time for the chapter's silence in the shadows and the road into Act III. She is the fourth and last Act II recruit, which fills the five-person roster.
- **Starting skills: Mend, Aegis, Smite** **[C-confirmed]** — one heal, one shield, one holy attack. Numbers are **[O]**; her `holy_sword` weapon exists as an id with no stats yet. No resurrection or party-wide buff at join; those are later unlocks **[PROPOSED]**.
- Her refusal to say what she saw is protected in dialogue: nobody asks twice, and the chapter does not hint at it **[C-confirmed]**.
- **Chapter 5 boss: Commander Hailen**, an honorable Crown officer holding a bad post; the fight is an arrest that fails, and the player may choose to let him yield **[C-confirmed]**.
- **[O]** What she saw inside the royal palace.

### 5.5 Taren Holt — Rebel Captain, permanent party member **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
- **[C]** In the design doc he appears only in Alden's entry: "Kael and Taren must stop him."
- **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) **Beliefs:** freedom is worth fighting for. He stands for the Broken Yoke's (the rebellion's) **original purpose: freedom for the people.** He wants to dismantle the oppressive system so that people govern themselves.
- **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) **Kael:** childhood friends who fight alongside one another.
- **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) **Alden:** also Alden's childhood friend. Alden becomes Taren's greatest disappointment.
- **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) **Ideological opposite of Alden:** both start with the same dream, but Alden decides he should rule Eldoria himself. That makes the betrayal especially painful for Taren.
- **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) **Party:** a permanent party member, part of the five-person roster.
- **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) **Story weight:** his friendship with Kael and his history with Alden should make the final Alden confrontation one of the most emotional moments in the game. He should be more than a warrior.
- **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) **Profile:** full name **Taren Holt**. **Age** 27. **Origin** Millhaven. **Class** Rebel Captain. **Faction** The Broken Yoke. **Role** Warrior / frontline fighter. **Weapon class** heavy swords: he can equip any sword classified as heavy, and his signature and starting weapon is a bastard sword. Childhood friend of Kael and Alden. *(This replaces the earlier Scout/Thief class and knife.)*
- **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) **Skill kit.** Theme: a frontline captain who leads the party, where Kael is the lone protector.
  - **Rallying Cry:** raises the party's Attack for 3 turns.
  - **Cleave:** a heavy bastard-sword swing that hits all enemies for reduced damage.
  - **Shield the Line:** for 2 turns, Taren takes hits aimed at the back row (uses the formation system).
  - **Breaking Blow:** a slow, powerful strike that lowers the target's Defense.
  - **Unbowed (passive):** resists Fear and Stun.
  - **Banner of the Yoke (later ability):** when an ally falls, restores some HP to all surviving allies. It mirrors Kael's Ashen Resolve.
- **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) **Starting skills at join (Chapter 2):** Rallying Cry, Cleave, and Unbowed (passive). Shield the Line, Breaking Blow, and Banner of the Yoke still have no confirmed unlock levels.
- **[O]** Exact numbers: MP costs, % values, how much damage Cleave loses, how much Defense Breaking Blow removes, and remaining unlock levels. **Note for Coder:** these need balancing values in the skill and character databases. Use placeholders until they're set.
- **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) **Joins:** first recruit, early in Act II, at **Wrenfield**, a village near Millhaven occupied by royal soldiers. The Crown has seized several villagers, accused of aiding the rebellion, and scheduled them for public execution. The party and Taren stop the hanging and free all of the accused, with a close call (the rope is already on a neck; the prisoner is **Bram**). The Crown retreats; the village stays under occupation. At Wrenfield, Taren speaks of Alden with warmth; they have not split.
- **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) Taren becomes controllable at the start of the Calder fight, after the close call and a short recognition. The longer join conversation happens after the battle.
- Chapter 2 boss: **Reeve Calder**, a Crown occupation officer who believes he is keeping order. After the fight he yields, lives, and withdraws with his remaining men to the village checkpoints.
- **[O]** Where the three grew up together. Taren is from Millhaven and Kael from Greyhaven, so was it Millhaven, Greyhaven or somewhere else? Alden's origin is also undefined.
- **[O]** What a "Rebel Captain" means in the Broken Yoke's structure, and who commands him.
- Not in Chapter 1. Canon doesn't place him there, so `CHAPTER1_SCRIPT.md` is unchanged.

### 5.6 Alden Marr — major tragic antagonist [C-locked concept]
- **[C-locked]** His ending concept is locked as **Ending C — The Last Usurper.**
- **[C]** At first he genuinely wants to free the serfs and rebuild Eldoria. He believes the crown has failed the people, and his original goal is to dismantle it and build a better future.
- **[C]** Ambition gradually corrupts him. After King Aldric IV is defeated, Alden takes the capital and claims the throne himself, becoming the thing he set out to destroy.
- **[C]** "Kael and Taren must stop him." His final battle has three phases.
- **[C]** He must stay tragic, never evil without explanation. Players should understand his motivation even when his actions become unacceptable.
- **[C]** He still needs backstory, a sprite, equipment, stats, abilities, dialogue, story appearances, his relationship with the rebellion, and the three-phase boss fight.
- **[C]** "Preserve this ending concept as canon, but do not assume it is the only ending the player can receive."
- **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) Alden is a childhood friend of **Taren** and becomes Taren's greatest disappointment. They start with the same dream: Taren keeps faith with self-government, while Alden decides he should rule Eldoria himself. The final Alden confrontation should be one of the game's most emotional moments, driven by Taren's friendship with Kael and his history with Alden.
- **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) **Act II appearances:** Taren speaks of him with warmth at Wrenfield. In Valemere the party meets him in person in **Weigh-House Square**, unmissable on the way to the Salt Lamp, before the job: still a friend, still sincere about freeing the serfs, with one line that already thinks ahead to "when we hold the city" (spoken in the open, then he greets them). They do not split in Act II.
- **[O]** All of the above details. Who defeats Aldric, and how. When and how Alden and Taren split (not in Act II).

### 5.7 King Aldric IV [C]
- Ruler of Eldoria and leader of the Crown. Knows the Crownveil is failing and has hidden the truth. He is defeated at some point before Alden seizes the capital (Ending C concept).
- **[O]** His personality, his motives for the cover-up, and whether he connects to the royal banner symbol or to what Sera saw.

### 5.8 Tomas Varyn [C]
- Kael's father. Former soldier turned blacksmith (Greyhaven has a Blacksmith location). Dying when Kael returns. Says *“Your sister… she went into the woods.”* According to the Fallen Knight, he "knew what was coming."
- **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) In Chapter 1 he lies in his ruined forge (the Blacksmith), tended by Pell. After delivering his line he passes out. He does **not** die on screen in Chapter 1.
- **[O]** His ultimate fate. What he knew, and how.

### 5.9 Elira Varyn [C]
- Kael's mother, the village healer.
- **[O]** Her fate. The doc doesn't say whether she survived Greyhaven's destruction.

### 5.10 Mira Varyn [C]
- Kael's younger sister, twelve when the tragedy began. She kept a black stone with a Crownveil symbol after being told to throw it away. **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) Sister Ilse, the Greyhaven chapel keeper, is the one who told her to throw it away. Mira had asked Ilse what the mark meant. She found a passage beneath Greyhaven and accidentally opened something connected to the Crownveil, and something came looking for her.
- Her wooden pendant was found in the ruins, with no body.
- The Ashbound parchment says she is still alive. The Watchtower carvings show a woman who looks like her. The Blackguard says she "crossed the Crownveil."
- **[O]** Why she was involved, why the carvings resemble her, what happened to the stone, and where she is now.

### 5.11 Old Hunter Renn [C]
- An NPC at the optional Hunter's Camp (Zone 1, recommended level 2). His optional quest rewards the **Hunter's Charm** (+2% critical hit).
- **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) A gruff, dry old woodsman who knew Kael's family. His quest is **Thinning the Pack** (`Q_SIDE_RENN`): defeat 5 Ash Wolves in the Farmlands or on the Old Road, then return to Renn for the Hunter's Charm. He hints that the wolves are weak to fire.

### 5.12 The Fallen Knight (story character) [C]
- He recognizes Kael and says *“Your father knew what was coming.”* and later *“She opened the door.”*
- **[C]** Separately, "Fallen Knight" is a common elite enemy type (Zone 1), and Act 5 is titled "The Fallen Knight."
- **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) **Chapter 1 placement:** line 1 at the Abandoned Bandit Camp's north exit, after which he walks off toward the Watchtower. Line 2 at the top of the Watchtower Basement stairs, after which he descends and vanishes. He never fights and is never named in Chapter 1.
- **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) **Act II appearances:** two brief non-combat sightings, never named. One on the road to Valemere after Taren has joined, with the confirmed line *“You cannot cross where she did. Not yet.”* (`flag_fk_seen_3`; see `CHAPTER3_SCRIPT.md`). One after the Blackwood Road Garrison, at the first trees, with the confirmed line *“The forest has already taken its share. It will want another.”* (`CHAPTER5_SCRIPT.md`, approved Nov 16 2026). Cryptic lines only. He walks off.
- **[O]** Who he is, whether he is one of the Fallen Knight enemies, and whether he is the subject of Act 5.

### 5.13 The Blackguard — Zone 1 boss [C]
- A former Royal Knight corrupted by the Ash. Recommended player level 5–7, 450 HP total, weak to Holy.
- **Phase 1 — The Knight:** armor, sword, shield. Heavy Slash, Shield Bash, Guard, Counter.
- **Phase 2 — The Corruption (60% HP):** his helmet cracks and Ash pours from the armor. Attack goes up and the shield is lost. Ash Slash, Dark Lunge, Blood Oath.
- **Phase 3 — Hollow Knight (20% HP):** the armor is engulfed in Ash. Attack +40%, Speed +30%, Defense −20%. New ability: Execution.
- **[O]** His name, and how he knows Mira and Kael.

### 5.14 Greyhaven survivors **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
| Name | Role | Location |
|---|---|---|
| Pell | Young survivor tending Tomas. Runs the forge as an equipment shop | Blacksmith |
| Hob | Tavern keeper. Hid in the cellar and heard the destruction, but won't describe it | Rusted Boar Tavern |
| Sister Ilse | Chapel keeper. Told Mira to throw away the black stone. Her faith or order is left unnamed (still open) | Greyhaven Chapel |
| Marda | Shopkeeper. Sells Minor Potions and Antidotes | General Store |
| Old Wenna | Elderly survivor | Town Square |
| Dov | Boy about Mira's age. Says Mira claimed she found "a door in the ground" under the town and wouldn't say where | Town Square |
| Corwin | Militia watchman. Keeps the gate shut until Kael has seen Tomas, and mentions small tracks heading north | North Gate |

### 5.15 The Ash King [O]
- Named twice: as one of the gradual Crownveil truths ("Why the Ash King is connected to it") and in Milestone 12 ("Ash King story"). Not defined anywhere else.

---

## 6. Chapter 1 / Zone 1 — "The Ashen Road" story beats

**[C]** Chapter title (Act 1): *The Night of Ash*. Zone name: *The Ashen Road*. Recommended levels 1–7. Main settlement: Greyhaven. Main dungeon: Old Watchtower. Zone boss: the Blackguard.
**[C]** Route: Greyhaven → Farmlands → Hunter's Camp (optional) → Old Road → Abandoned Bandit Camp → Old Watchtower → Watchtower Basement → Blackguard → Crownveil Door.

### Zone 1 signs **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)

| Location | Sign text |
|---|---|
| North Gate | "North Gate. Keep it barred after dark." |
| Hunter's Camp | "Hunter's Camp. Wolves thick this season — ask for Renn." |
| Old Road | "Old Road. Travel in daylight. Crown Patrol" *(an old, weathered notice)* |
| Abandoned Bandit Camp | "Turn back. This is our road now." *(the second line is crossed out)* |
| Old Watchtower | "Old Watchtower. Property of the Crown. Closed by order." |

These signs are also recorded in `CHAPTER1_SCRIPT.md`.

The beats below follow that route. **[O]** The doc doesn't say exactly where the Tomas, pendant and Fallen Knight beats happen. Their positions here are suggestions only.

1. **Return to Greyhaven** (level 1, safe, no random battles). Kael comes home to an already destroyed village. **[C-confirmed]** The destruction is not played. His dying father says *“Your sister… she went into the woods.”* Kael searches the ruins of Varyn House and finds Mira's wooden pendant, with no body. **[C-confirmed]** **Opening quest: Find Mira.** **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) The order follows `CHAPTER1_SCRIPT.md`: arrival, then Tomas in the forge (he passes out, not dead), then the pendant in the Varyn House ruins, after which Corwin opens the North Gate.
2. **Greyhaven Farmlands** (level 1–2). Bandits and Ash Wolves. The **first guaranteed Bandit encounter** teaches combat.
3. **Hunter's Camp** (level 2, optional). Old Hunter Renn. Optional quest reward: Hunter's Charm.
4. **Old Road** (level 2–3). Bandits, Ash Wolves, Ashen Wretches, and the rare Ashbound Hunter.
5. **Ashbound Hunter special encounter** (rare, 3–5%, recommended level 3–5; can appear on the Old Road, at the Bandit Camp and in the Watchtower). "An arrow lands beside Kael before combat begins." **Story clue:** a parchment reads *“Find the girl. The Varyn girl is still alive.”* **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) **The parchment can't be missed:** the first Ashbound Hunter fight in the Old Watchtower is guaranteed and drops the parchment if the player hasn't already got it. The rare 3–5% encounter stays in place elsewhere.
6. **Abandoned Bandit Camp** (level 3–4). Bandits, Fallen Knights, Ashen Wretches, rare Ashbound Hunter. Possible chest rewards: Minor Potion x3, Antidote x2, 50 Gold, Iron Sword.
7. **Fallen Knight lines** (**[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) line 1 at the Bandit Camp's north exit, line 2 at the top of the Basement stairs): *“Your father knew what was coming.”* … later *“She opened the door.”*
8. **Old Watchtower** (level 4–7, main dungeon). Fallen Knights, Grave Spiders, Hollow Soldiers, Ashbound Hunter. Locked doors, keys, chests, traps, environmental lore, ancient symbols. **Banner clue:** an old royal banner bears the same symbol as Kael's pendant and the symbol connected to the Crownveil. **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) That symbol is a crown ringing a black sun, the same mark as the Basement carvings. Show this design; do not use a placeholder sprite.
9. **Watchtower Basement: Architect carvings.** A giant crown surrounds a black sun. A woman stands before a stone door. She resembles Mira, even though the carvings are thousands of years old.
10. **Blackguard Arena: boss intro (verbatim)**
    > **Blackguard:** “You shouldn’t have come here.”
    > **Kael:** “Where is my sister?”
    > **Blackguard:** “You still don’t know.”
    > **Kael:** “Know what?”
    > **Blackguard:** “What she opened.”
11. **Blackguard fight** (three phases, see 5.13).
12. **Blackguard defeat (verbatim)**
    > **Blackguard:** “The girl didn’t disappear, Kael.”
    > **Kael:** “What did you say?”
    > **Blackguard:** “She crossed the Crownveil.”
13. **Rewards:** 250 XP, 100 Gold, Blackguard's Longsword, Crownveil Fragment.
14. **Chapter ending at the Crownveil Door.** The main quest changes from **Find Mira → Beyond the Veil**. The pendant reacts to the sealed stone door. "Something touches the other side. Then everything stops." **Chapter 1 completes.**
    **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) **Presentation:** hard cut to black and silence, then the quest-change and chapter-complete screens and a save prompt. The Blackguard collapses into ash and empty armor when defeated.
    **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) **Act II opens** with Kael coming to on this side of the still-sealed door. The pendant is quiet. He backtracks through the Watchtower and may optionally stop in Greyhaven (Tomas still unconscious; Elira and the cause of the destruction remain untouched) before taking the road toward Millhaven.
    **[O]** What "everything stops" *means* in the story. Whether this door is the same passage beneath Greyhaven that Mira opened.

---

## 7. Eight-act outline

**[C]** The main story is planned as eight acts, each with real gameplay (not just cutscenes): main and side quests, new areas, NPCs, character development, dungeons, bosses, story revelations, equipment progression and party development.

| Act | Chapter name | Status |
|---|---|---|
| 1 | The Night of Ash | **[C]** Zone 1 detailed (section 6) |
| 2 | The Broken Crown | **[C-confirmed]** — recruitment act, four chapters (2–5), all four scripts approved and built. Detail in `ACT2_OUTLINE.md`, summarized below. |
| 3 | The Blackwood | **[O]** Title canon; the rest is not. A [PROPOSED] outline exists in `ACT3_OUTLINE.md` (three chapters, ten decisions for the owner) |
| 4 | The Forgotten King | **[O]** Title canon only. A [PROPOSED] outline exists in `ACT4_OUTLINE.md` (three chapters, ten decisions, a proposed answer to question 13) |
| 5 | The Fallen Knight | **[O]** Title canon; decisions approved 2026-11-16. `ACT5_OUTLINE.md` proposes three chapters, and all ten decisions were approved as recommended; Chapter 12 drafted, not built. |
| 6 | Beneath the Mountains | **[O]** Not yet detailed |
| 7 | The Ashlands | **[O]** Not yet detailed |
| 8 | The Truth | **[O]** Not yet detailed |
| Finale | **The Ashen Crown** (final endgame sequence) | **[O]** Not yet detailed |

### Act II — The Broken Crown (summary) **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)

Act II is four chapters (Chapters 2–5), each with a recruit and a chapter boss. All four titles are now canon: **The Weight of the Yoke** (Ch 2, Nov 14 2026), **Crowns and Alleys** (Ch 3, Nov 14 2026), **The Old Name** (Ch 4, Nov 15 2026) and **The Deserted Oath** (Ch 5, Nov 16 2026). Level bands are 8–10, 10–13, 13–16 and 16–18. Kael travels alone until the first recruit, and the act ends with a full five-person roster.

1. **Opening.** Kael comes to on this side of the still-sealed Crownveil Door. The pendant is quiet. What "everything stops" means stays **[O]**. He backtracks through the Watchtower, may optionally stop in Greyhaven (Tomas still unconscious; Elira and the destruction remain untouched), and takes the road toward Millhaven after survivors or travelers mention Crown hangings — and that Taren Holt has been seen with the Broken Yoke.
2. **Chapter 2, The Weight of the Yoke (Wrenfield).** Taren's recruitment, during a public execution of villagers accused of aiding the rebellion. The party and Taren stop the hanging and free all of the accused (close call: the rope is already on **Bram**'s neck). The Crown retreats; the village stays under occupation. **Oda**, Bram's sister, offers the optional quest **The One on the List**. Taren becomes controllable at the start of the Calder fight; the longer join conversation is after the battle. He speaks of Alden with warmth. Boss: **Reeve Calder**, a Crown occupation officer who believes he is keeping order; he yields, lives, and withdraws to the checkpoints. The hook to Wrenfield is unmissable on the Millhaven Road (a traveler, with a Crown notice as backup; Pell and Corwin repeat it if Greyhaven is visited). The chapter ends on a complete screen and a save, then hands off to the Valemere road. All of `CHAPTER2_SCRIPT.md` is canon.
3. **Chapter 3, Crowns and Alleys (Valemere).** The capital is the Act II hub (suggested levels 10–13). The first Act II Fallen Knight sighting is on the Valemere road (*“You cannot cross where she did. Not yet.”*). The party meets **Alden Marr** in person in **Weigh-House Square**: still a friend, still sincere about freeing the serfs, with one line that already thinks ahead to "when we hold the city." No split in this act. **Nim**, a fence at **the Salt Lamp**, sells a paid job to steal seized scholar's notes that point to the Hollow Sanctuary. **Lyra** takes the job for coin. Mid-heist **the Debtman** cuts them off; she becomes controllable at the start of that fight (starting skills: Twin Cut, Open Vein, Cutthroat) and stays because she is now exposed. Boss: **the Debtman**, a human Lower City enforcer (a moniker, not a Black Hand title) tied to the stolen document; he withdraws, alive. Optional quest: **A Parcel Unsealed**. The chapter ends on a complete screen and a save, then hands off toward the Hollow Sanctuary. All of `CHAPTER3_SCRIPT.md` is canon.
4. **Chapter 4, The Old Name (the Hollow Sanctuary).** **[C-confirmed]** (approved Nov 15 2026), levels 13–16. An abandoned Aethari sanctuary a day's travel from Valemere in the countryside. **Caelan** is recruited here and becomes controllable at the start of the Warden fight. Inscriptions say "Aethari." Caelan explains that "Architects" is the textbook name. The party shifts to "Aethari" in dialogue afterward; UI, bestiary and quest text stay on "Architects." Boss: **the Sanctuary Warden**, an Aethari guardian-construct. The chapter ends on the road out of the hollow with `Q_BV_S6` active. Whose scholar-notes the party carries is left unstated. What the sanctuary was for, why it was abandoned, what Caelan knows about why the Veil broke, Lumen, and the Crown Engine's state all stay **[O]**.
   All of `CHAPTER4_SCRIPT.md` is canon.
5. **Chapter 5, The Deserted Oath (the Blackwood Road Garrison).** **[C-confirmed]** (approved Nov 16 2026), levels 16–18. **Sera** is held there as a deserter, awaiting transport to the capital and not formally sentenced. The gate closes behind the party; the lead is a sealed Crown order bearing a non-Crown seal. Sera will not say what she saw in the palace (that stays **[O]**). Boss: **Commander Hailen**, an honorable officer who tries to arrest the party and may be allowed to yield. Sera joins after the fight. The chapter ends at the Blackwood treeline, handing Act III its opening. All of `CHAPTER5_SCRIPT.md` is canon.
6. **Fallen Knight.** Two brief non-combat sightings, never named: one on the road to Valemere after Taren joins (*“You cannot cross where she did. Not yet.”*); one after the garrison, at the first trees: *“The forest has already taken its share. It will want another.”* **[C-confirmed]** (Nov 16 2026). He never blocks the road, never draws and is gone by the time anyone reaches the treeline. His identity stays **[O]**.

### Act IV — The Forgotten King (built 2026-11-16, unplayed) **[C-confirmed]**

`ACT4_OUTLINE.md` proposes the act that follows the doors: a Crown market town, a barrow field the Crown has quietly maintained for a century, and a tomb whose inscriptions were chiselled off on purpose. Its one revelation is a **name** for the mark, never a meaning. **Alden Marr is on screen in all three chapters**, sincere and fighting beside the party, and the act deliberately does not split him from Taren — Ending C stays untouched. Its seven enemies now exist and were simulated (levels 21–23, `crown_barrow` table, three boss groups; `PARTY_MAX_LEVEL` is 24), and **all three chapters are built, unplayed** — Coleford, the barrow gatehouse, the halls and the last chamber; 235 dialogue nodes, two quests, the act boss and the seal branch. The tomb's charter gives the mark the name **the Crownveil** — the term this bible and Chapter 1 already use for it — which is a name and not a meaning: question 13 stays open as a proposed answer, question 24 (why the royal banner bears the mark) is untouched, and *The Ashen Crown* remains reserved for the finale. **Alden's sprite does not exist**, he has no battle slot, and every room is a blockout.

### Act V — The Fallen Knight (outline only) **[PROPOSED]**

`ACT5_OUTLINE.md` proposes the act that follows the barrow road south: the **Drowned Coast**, where Saltreach pays the sea one name a tide, a flooded Aethari record room whose list of eleven names has ten scraped off, and the wreck that carried the Crown's last crossing. Its one revelation is an **office, not a man** — "Fallen Knight" is what the Crown calls the knights it sent across the Crownveil and got back — and the knight is fought once, as the act boss, yields at 0 HP, is not named and does not die. Three chapters (12–14) at levels 24–26 **[PROPOSED]**, which needs `PARTY_MAX_LEVEL` raised to 27; the four coast rooms the overworld already references become the act's rooms, `snd_amb_water` gets its first use, and Alden appears only as a letter whose existence depends on Chapter 11's seal choice. Bible question 2 — who he is, and whether he is one of the Fallen Knight enemies — stays open. **All ten decisions were approved as recommended on 2026-11-16**; Chapter 12 is drafted, nothing is built, and the approved level cap (27) is not applied.

### Act III — The Blackwood (built 2026-11-16, unplayed) **[C-confirmed for Ch 6; PROPOSED for Ch 7–8]**

`ACT3_OUTLINE.md` sets out a three-chapter act (6 *The Green Silence*, 7 *The Share*, 8 *The Door in the Wood*) built on the nine Act III enemies and the `blackwood` encounter table that already exist, ending at the Aethari stone doors with the pendant answering and no answer given. **All three chapters are built as of 2026-11-16** — dialogue, story flow and the five rooms — but none of it has been compiled or played, and Chapters 7–8's decisions are still awaiting the owner's individual approval. Chapter 6 *The Green Silence* — its title, Cinderhollow, Berrin, the tithe, the stacked armour and the Burn-Line Hulk — was **approved 2026-11-16** and is canon; Chapter 7 *The Share* and Chapter 8 *The Door in the Wood*, their bosses, the side quest's choice, the level cap raise and the rest of the room list are still **PROPOSED** in its §9. The act answers none of the open questions and keeps the Fallen Knight out of it.

- **[O]** The names suggest region links (Blackwood, Ironspine as "Beneath the Mountains", Ashlands), but the doc never assigns regions to acts. **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) Valemere is the Act II hub; Act II is set in the Kingdom of Eldoria and hands off to the Blackwood for Act III. The Drowned Coast (named village: **Saltreach**) and the Frostwilds (named settlement: **Rimehold**) still have no act assignment. The doc also doesn't name the "Forgotten King."

---

## 8. Endings

**[C]** Three possible endings have been discussed. "The final selection and exact branching conditions remain to be finalized." Endings should reflect player choices, relationships and major decisions where practical. "Do not implement an ending as canon until the developer confirms the final choice."

| Ending | Summary | Status |
|---|---|---|
| Ending 1 — Restore the Crownveil | Kael sacrifices himself to become its guardian. The world is protected, but Kael is lost. | **[U]** |
| Ending 2 — Destroy the Crownveil | The barrier is destroyed, the entity beyond it is released, and the old order collapses. | **[U]** |
| Ending 3 — Break the Cycle | The entity is destroyed without sacrificing Kael, but magic is permanently destroyed. | **[U]** |
| Ending C — The Last Usurper | Alden Marr takes the capital after Aldric IV falls and claims the throne. Kael and Taren (Kael's and Alden's childhood friend) must stop him (three-phase battle). | **[C-locked]** as a concept. Placement and conditions **[O]**. Not necessarily the only ending. |

---

## 9. Canon at a glance

- **Locked:** the Alden Marr Ending C concept.
- **Confirmed (Nov 14 2026):** Taren Holt (27, from Millhaven, Rebel Captain of the Broken Yoke, frontline warrior), and a five-person roster with four active in battle.
- **Confirmed by Kevin (Nov 14 2026):** FF1-style top-down exploration camera; Kael finds the pendant in the Varyn House ruins; Kael arrives after Greyhaven's destruction, which is not played; all of `CHAPTER1_SCRIPT.md` (every line and scene in it is canon).
- **Confirmed by Kevin (Nov 14 2026), Act II:** opening after the sealed door (meaning of "everything stops" still open); **Wrenfield** (execution stopped, all accused freed, village stays occupied); **Reeve Calder**; Lyra's Lower City document job; **the Hollow Sanctuary**; the Aethari name shift at Caelan's recruitment (UI stays "Architects"); Alden met in Valemere as a friend, no split in this act; **the Blackwood Road Garrison** (Sera detained as a deserter); **Commander Hailen**; two unnamed Fallen Knight sightings in Act II. Detail: `ACT2_OUTLINE.md`. Remaining outline texture is Chapters 4–5, still **[PROPOSED]**.
- **Confirmed by Kevin (Nov 14 2026), world and Chapter 1:** the Drowned Coast coastal village is **Saltreach**; the Frostwilds settlement is **Rimehold**; the pendant, Watchtower banner and Basement carvings share one mark, a crown ringing a black sun; Zone 1 sign text is set (North Gate, Hunter's Camp, Old Road, Abandoned Bandit Camp, Old Watchtower).
- **Confirmed by Kevin (Nov 14 2026):** all of `CHAPTER2_SCRIPT.md` (every line and scene in it is canon), including the title **The Weight of the Yoke**; the Millhaven Road hook; **Bram**, **Oda**, and **The One on the List**; Taren's join timing and starting skills (Rallying Cry, Cleave, Unbowed); Calder's kit, yield, and withdrawal; chapter-complete screen and a save, then the Valemere road.
- **Confirmed by Kevin (Nov 14 2026):** all of `CHAPTER3_SCRIPT.md` (every line and scene in it is canon), including the title **Crowns and Alleys**; levels 10–13; the Fallen Knight's Valemere-road line; **Weigh-House Square**; **Nim** and **the Salt Lamp**; **A Parcel Unsealed**; **the Debtman** (moniker; he lives); Lyra's join timing and starting skills (Twin Cut, Open Vein, Cutthroat); chapter-complete screen and a save, then the road toward the Hollow Sanctuary.
- **Confirmed by Kevin (Nov 15 2026):** all of `CHAPTER4_SCRIPT.md` — the title **The Old Name**, levels 13–16, Caelan controllable from the start of the Warden fight, his starting kit (Ember, Frost Lance, Arc Bolt), the boss **Sanctuary Warden**, the anonymity of the scholar-notes' owner, Alden absent, and the handoff on the road out of the hollow.
- **Confirmed by Kevin (Nov 16 2026):** all of `CHAPTER5_SCRIPT.md` — the title **The Deserted Oath**, levels 16–18, the party not being admitted to the garrison, Sera held awaiting transport and joining after the fight, her kit (Mend, Aegis, Smite), the pre-battle choice that lets Hailen yield, the sealed non-Crown order as the Blackwood lead, the Fallen Knight's second line (*“The forest has already taken its share. It will want another.”*), the two-room build and the treeline handoff that ends Act II.
- **Canon:** everything tagged [C] above, including all verbatim dialogue.
- **Unconfirmed:** Endings 1–3.
- **Open:** everything in section 10 still marked **[O]**.

## 10. Open questions for Kevin

**People**
1. Who or what is the Ash King? How does it connect to the Crownveil, the Ash, and "the entity beyond it"?
2. Who is the Fallen Knight who recognizes Kael? Is he one of the Fallen Knight enemies, and is he the subject of Act 5? *(Act II appearances settled, Nov 14 2026: two brief non-combat sightings, never named. First sighting line settled in `CHAPTER3_SCRIPT.md`: “You cannot cross where she did. Not yet.” Second sighting line still proposed. Identity still open.)*
3. Who is the Blackguard (name, history)? How does he know Mira and Kael?
4. What did Sera see inside the royal palace?
5. What exactly does Caelan know about the Crownveil and why it broke?
6. What are Lyra's Black Hand ties? *(Chapter 3 settled, Nov 14 2026: the Debtman can imply a debt, and her ties stay implied only. The nature of the ties, and Black Hand leadership, are still open.)*
7. ~~Details of each Act II recruitment beyond its setting: the occupied village's name and what happens at the execution, Lyra's Lower City storyline, the Aethari sanctuary's location, and which royal garrison Sera is at.~~ **Resolved (Nov 14 2026):** Wrenfield; the hanging is stopped and all of the accused are freed (close call), but the village stays occupied; Lyra takes a paid job from Nim at the Salt Lamp to steal seized scholar's notes pointing to the sanctuary, finishes the broken heist when the Debtman cuts them off, and stays because she is exposed; the Hollow Sanctuary, a day's travel from Valemere in the countryside; the Blackwood Road Garrison, where Sera is detained as a deserter. Chapter 2 and Chapter 3 scene texture is now canon in `CHAPTER2_SCRIPT.md` and `CHAPTER3_SCRIPT.md`. Scene texture for Chapters 4–5 is now canon in `CHAPTER4_SCRIPT.md` (approved Nov 15 2026) and `CHAPTER5_SCRIPT.md` (approved Nov 16 2026).
8. What is Lumen, how does it relate to modern magic, and does Ending 3's "magic permanently destroyed" include it?
9. The Crown Engine: where is it, what state is it in, how does it work, and is its condition why the Crownveil is failing?
10. Where did Kael (Greyhaven), Taren (Millhaven) and Alden grow up together: Millhaven, Greyhaven or elsewhere? Where is Alden from? When and how did Alden and Taren split? Where is Millhaven, and what is it like? **(Partly resolved, Nov 14 2026:** they do not split in Act II. Taren speaks of Alden with warmth at Wrenfield; the party meets him in Weigh-House Square in Valemere as a friend, before the Lower City job. Childhood setting, Alden's origin, Millhaven's details, and when they later split are still open.)
11. Elira's fate: alive, dead or missing after Greyhaven?
12. What is Tomas's ultimate fate (he passes out in Chapter 1, not dead), and what did he know "was coming"?
13. Who is the "Forgotten King" in Act 4? **(Proposed, not confirmed:** the king before the Crown's line, his name chiselled off on purpose, buried with the seal and charter that legitimised his house — see `ACT4_OUTLINE.md` §5 and §9.3.**)**
14. Alden's backstory, his exact role in the Broken Yoke, and who defeats King Aldric IV, and how. *(Act II appearance settled, Nov 14 2026: met in Weigh-House Square as a friend, with one line that thinks ahead to "when we hold the city." Backstory, rank, and Aldric's defeat are still open.)*
15. What are Aldric IV's motives for hiding the Crownveil's failure? *(A Chapter 3 rumor says the king has been closed up in the Royal District. Motives are still open.)*

**Events and world**
16. What destroyed Greyhaven, and how? (Timing is settled: before Kael arrives, not played.)
17. What is "the Night of Ash" as an event?
18. Is the passage beneath Greyhaven that Mira opened the same as the Crownveil Door at the end of Zone 1? Where is the Old Watchtower relative to Greyhaven?
19. What happened to Mira's black stone?
20. Why do the Architect carvings resemble Mira?
21. Who wrote the Ashbound parchment, and who sent the Ashbound Hunter?
22. What does "Then everything stops" mean in the story? (The on-screen presentation is settled: a hard cut to black. **Act II opening settled, Nov 14 2026:** Kael comes to on this side of the still-sealed door; the pendant is quiet. The meaning of the phenomenon is still open.)
23. ~~What does the pendant's shared symbol look like, and is it the crown around a black sun?~~ **Resolved (Nov 14 2026):** a crown ringing a black sun, the same mark as the Watchtower banner and the Watchtower Basement carvings.
24. Why does a royal banner carry the Crownveil symbol? What does the crown know? *(The mark itself is settled, Nov 14 2026: a crown ringing a black sun. Why the banner bears it, and what the crown knows, are still open.)*
25. Where exactly does the Crownveil run? It is believed to protect Eldoria, but the Ashlands lie "beyond" it. What is it keeping in?
26. What are the answers to the six gradual Crownveil truths, and in which acts are they revealed?
27. Is the Frostwilds' "ancient northern civilization" the Architects or a separate people?
28. Which acts map to which regions? Where do Valemere, the Drowned Coast and the Frostwilds fall in the eight acts? **(Partly resolved, Nov 14 2026:** Valemere is the Act II hub; Act II is set in the Kingdom of Eldoria and hands off to the Blackwood for Act III. Named settlements: Saltreach on the Drowned Coast, Rimehold in the Frostwilds. Those two regions, and a full act-to-region map, are still open.)
29. Who leads the Broken Yoke, and how is it structured? (Name settled. Taren is a Rebel Captain.)
30. Is Greyhaven Chapel part of the Radiant Flame?
31. What is Mira's age now? The doc gives "twelve when the tragedy began." How much time has passed?

**Endings and systems that touch lore**
> **Note for Coder:** the party is **5 members with 4 active** (Kael, Lyra, Caelan, Sera, Taren). The Adventure menu's Party Order needs a reserve slot. Kael and Taren are both frontline melee fighters. See "Party roster" in section 5.
32. Which ending(s) are final, and what are the branching conditions (choices, relationships)?
33. How does Alden's Ending C relate to the three Crownveil endings? Is it a separate branch, a step before the finale, or a fourth ending?
34. What is "the entity" in Endings 2 and 3, and is it the Ash or the Ash King?
35. Kael's Ashen Resolve says "Ash increases by 1." What is the Ash stat or meter?
36. Party swapping: does the story restrict it (locked or forced members in certain scenes)? Does the reserve member earn XP?
37. Battle presentation: are battles FF1-style menu battles (the current assumption)? The doc's "hybrid, varying by encounter" note still needs his final word. (The exploration camera is settled.)

## 11. Decision log

| Date | Decision (by Kevin) | Effect on this bible |
|---|---|---|
| Nov 14 2026 | Exploration and overworld camera is FF1-style top-down. | Section 1 marked confirmed. The camera question is resolved. Battle presentation stays open, presumed to be FF1-style menu battles. |
| Nov 14 2026 | Kael **finds** Mira's wooden pendant in the ruins of Varyn House. She did not give it to him. | Replaces the doc's line "The wooden pendant given by Mira." Sections 5.1 and 6 updated. The pendant question is resolved. |
| Nov 14 2026 | Kael arrives home **after** Greyhaven is destroyed. The destruction is not played. | Sections 3, 5.1 and 6 updated. The timing question is resolved. *What* destroyed Greyhaven stays open. |
| Nov 14 2026 | Approved everything proposed in `CHAPTER1_SCRIPT.md` as canon. | New Greyhaven survivors section (now 5.14), plus updates to Tomas, Mira, Renn, the Fallen Knight and section 6. Ilse told Mira to discard the stone. Tomas passes out and doesn't die on screen (fate still open). Fallen Knight placement settled. Renn's personality and quest settled. Hard cut to black at the ending. Resolved questions removed: Renn's content, Fallen Knight placement, Tomas dying on screen, missable parchment, and the ending presentation. |
| Nov 14 2026 | The parchment can't be missed: the first Ashbound Hunter fight in the Old Watchtower is guaranteed. | Section 6, beat 5 updated. The rare encounter is kept elsewhere. |
| Nov 14 2026 | Defined Taren: childhood friend of Kael (they fight side by side) and of Alden (Taren's greatest disappointment). Believes freedom is worth fighting for and embodies the rebellion's original purpose. Ideological opposite of Alden. Permanent party member, more than a warrior. The final Alden confrontation should be one of the most emotional moments. | New 5.5 Taren entry (later sections renumbered 5.6–5.14). Alden entry, Ending C row and rebellion faction row updated. "Who is Taren?" removed. New open items: his class, weapon, role, age and join point; the childhood setting. |
| Nov 14 2026 | Party is a five-person roster (Kael, Lyra, Caelan, Sera, Taren), four in battle at a time. | New "Party roster" block in section 5 overrides the doc's four-member party. Coder note: Party Order needs a reserve slot. New open item: story restrictions on swapping, and reserve XP. |
| Nov 14 2026 | ~~Taren's class is Scout/Thief, and he uses a knife or small blade.~~ *(Superseded by the next entry.)* | Taren entry and party roster updated. Open question trimmed to his skills, combat role and age. A [PROPOSED] scouting and utility direction was added so he doesn't overlap with Lyra. |
| Nov 14 2026 | **Revision, supersedes Scout/Thief:** Taren Holt, age 27, from Millhaven, class Rebel Captain, faction the Broken Yoke (the rebellion's name), role warrior / frontline fighter, childhood friend of Kael and Alden. | Taren entry rewritten. The Scout/Thief class, the knife and the [PROPOSED] Lyra-overlap note were removed, and his weapon is now open. Party roster updated, with a Coder note about two frontline melee fighters. The rebellion row became the Broken Yoke. Millhaven added. Questions resolved: the rebellion's name and Taren's age. |
| Nov 14 2026 | Taren's weapon is a bastard sword. **Corrected the same day:** his weapon class is heavy swords. He can equip any heavy sword, and the bastard sword is his signature and starting weapon. | Taren entry and party roster updated, plus a Coder note for a "heavy sword" equipment category. The weapon is no longer open, and the open question is trimmed to his skills. |
| Nov 14 2026 | Approved Taren Holt's skill kit (the captain who leads the party): Rallying Cry, Cleave, Shield the Line, Breaking Blow, Unbowed (passive), Banner of the Yoke (later ability). | Kit added to 5.5. Taren's skills question removed. Exact numbers are open, with a Coder balancing note. |
| Nov 14 2026 | Act II recruitment plan: Taren (Crown-occupied village near Millhaven, villagers seized for aiding the rebellion and set for public execution) → Lyra (Valemere Lower City) → Caelan (abandoned Aethari sanctuary) → Sera (royal garrison). | Join points added to each character and to the party roster. Act II row filled in. Millhaven marked as near the occupied village. New open term "Aethari" (2.5). The join-point question is trimmed to recruitment details. |
| Nov 14 2026 | Act II's working title stays **The Broken Crown**. An earlier outline called Act II "The Broken Yoke," but that is now the rebellion's name only. | Act outline unchanged. Use "The Broken Yoke" only for the faction. |
| Nov 14 2026 | Defined the Aethari: an extraordinarily advanced civilization that understood Lumen (ancient magic), the nature of the Crownveil, the relationship between life and the Ash, magical mechanisms, and the containment of supernatural forces. They built enormous cities, sanctuaries, temples and underground structures. Their greatest achievement was the Crown Engine, associated with maintaining the Crownveil. | 2.5 rewritten. New 2.6 Lumen and 2.7 Crown Engine, details open. [PROPOSED, pending Kevin] working assumption: Aethari = the Architects' own name. Open questions updated. |
| Nov 14 2026 | (Kevin via Coder) "We can use both names depending on who's talking about them." The Aethari and the Architects are the same people. | 2.5: the link is confirmed, and the working assumption and the "don't state it in game text" rule are removed. 2.2 heading cross-referenced. A [PROPOSED] naming guide was added for Kevin's review. The open question was removed. |
| Nov 14 2026 | Approved the Aethari vs Architects naming guide. | 2.5 naming guide and its example lines changed from [PROPOSED] to [C-confirmed]. |
| Nov 14 2026 | Act II, decision 1: the occupied village is **Wrenfield**. The party and Taren stop the hanging and free all of the accused (close call: the rope is already on a neck). The Crown retreats; the village stays under occupation. | Wrenfield added under Regions. Taren's join entry and the Act II summary updated. Question 7 resolved on the village name and the prisoners' fate. |
| Nov 14 2026 | Act II, decision 2: after "everything stops," Kael comes to on this side of the still-sealed door. The pendant is quiet. He backtracks through the Watchtower, may optionally stop in Greyhaven (Tomas still unconscious; Elira and the destruction untouched), and takes the road toward Millhaven after survivors or travelers mention Crown hangings and that Taren Holt has been seen with the rebellion. | Cross-reference added at the end of section 6. Act II summary opening filled in. Question 22 still open for *meaning*; the Act II opening is settled. |
| Nov 14 2026 | Act II, decision 3: Lyra's Lower City hook is a paid job to steal a seized document (a scholar's notes or a ledger) that points to the abandoned sanctuary. Mid-heist the job breaks; she finishes it and stays because she is now exposed. Her Black Hand ties stay undefined. | Lyra entry updated. Question 7 resolved on the Lower City storyline; question 6 (the nature of her ties) stays open. |
| Nov 14 2026 | Act II, decision 4: the abandoned Aethari sanctuary is **the Hollow Sanctuary**, a day's travel from Valemere in the countryside, a self-contained dungeon. | New Hollow Sanctuary location. 2.5 and Caelan's join entry updated. "Where the sanctuary is" resolved; what it was for and why it was abandoned stay open. Question 7 resolved on the sanctuary's location. |
| Nov 14 2026 | Act II, decision 5: Sera is recruited at **the Blackwood Road Garrison**. She is detained there as a deserter. The party comes for a Blackwood lead and finds her. She will not say what she saw in the palace. | New Blackwood Road Garrison location. Sera's join entry and the Act II summary updated. Question 7 resolved on which garrison; question 4 (what she saw) stays open. |
| Nov 14 2026 | Act II, decision 6: the party learns the Aethari name in Act II, at the Hollow Sanctuary, when Caelan joins. Inscriptions say "Aethari." Caelan explains that "Architects" is the textbook name. Party dialogue shifts afterward; UI, bestiary and quest text stay "Architects." | 2.5 naming guide: the act of the language shift is no longer open. Caelan entry and the Act II summary updated. The six Crownveil truths (question 26) stay open. |
| Nov 14 2026 | Act II, decision 7: Taren speaks of Alden with warmth at Wrenfield. In Valemere the party meets him in person: still a friend, still sincere about freeing the serfs, with one line that already thinks ahead to "when we hold the city." No split in this act. | Alden entry and the Act II summary updated. Question 10 partly resolved (they do not split in Act II). Backstory, rank, and when they later split stay open (questions 10 and 14). |
| Nov 14 2026 | Act II, decision 8: the Fallen Knight has two brief Act II sightings, never named and never fighting. One on the road after Taren joins; one after the garrison, hinting at the woods. Cryptic lines only. He walks off. | Fallen Knight entry (5.12) and the Act II summary updated. Question 2: appearances settled; identity still open. |
| Nov 14 2026 | Act II, decision 9: chapter bosses are human Crown or underworld officers, not Ash-corrupted, except the sanctuary construct. Ch 2: **Reeve Calder**, a Crown occupation officer who believes he is keeping order. Ch 3: a Lower City enforcer tied to the stolen document, not a named Black Hand leader. Ch 4: an ancient sanctuary guardian-construct (shows Aethari mechanisms; does not explain the Crown Engine). Ch 5: **Commander Hailen**, an honorable garrison commander who tries to stop Sera and the party. | Reeve Calder and Commander Hailen added as canon. Act II treated as four chapters (2–5). The Lower City enforcer's name and the construct's name stay **[PROPOSED]** in `ACT2_OUTLINE.md`. |
| Nov 14 2026 | The Drowned Coast coastal village is **Saltreach**. | Saltreach added under Regions and to the Drowned Coast row. Question 28 still open for act placement; only the village's name is settled. |
| Nov 14 2026 | The Frostwilds settlement is **Rimehold**. | Rimehold added under Regions and to the Frostwilds row. Question 27 (whether the ancient northern civilization is the Architects) stays open. Question 28 still open for act placement. |
| Nov 14 2026 | The pendant symbol is a crown ringing a black sun, the same mark as the Watchtower banner and the Watchtower Basement carvings. | Sections 5.1 and 6 (banner clue) updated. Question 23 resolved. Question 24 (why the banner bears the mark, and what the crown knows) stays open. `CHAPTER1_SCRIPT.md` no longer calls for a placeholder sprite. |
| Nov 14 2026 | Zone 1 sign text: North Gate ("North Gate. Keep it barred after dark."); Hunter's Camp ("Hunter's Camp. Wolves thick this season — ask for Renn."); Old Road ("Old Road. Travel in daylight. Crown Patrol", an old weathered notice); Abandoned Bandit Camp ("Turn back. This is our road now.", second line crossed out); Old Watchtower ("Old Watchtower. Property of the Crown. Closed by order."). | New "Zone 1 signs" block in section 6. The same text was added to `CHAPTER1_SCRIPT.md`. |
| Nov 14 2026 | Chapter 2, decision 1: **Reeve Calder** is beaten and yields. He lives and withdraws with his remaining men to the village checkpoints. Wrenfield stays occupied. | Wrenfield and Taren entries updated. Calder's kit and the rest of the Chapter 2 script stay **[PROPOSED]**. |
| Nov 14 2026 | Chapter 2, decision 2: Taren becomes controllable at the start of the Calder fight, after the close call and a short recognition ("Kael—? Later. The rope."). The longer join conversation happens after the battle. | Taren's join entry updated. Other Chapter 2 join dialogue stays **[PROPOSED]**. |
| Nov 14 2026 | Chapter 2, decision 3: the hook to Wrenfield is unmissable on the Millhaven Road (a traveler, with a Crown notice as backup). If Greyhaven is visited, Pell and Corwin say the same thing. | Act II summary updated. Greyhaven remains optional. Exact hook wording stays **[PROPOSED]** in `CHAPTER2_SCRIPT.md`. |
| Nov 14 2026 | Chapter 2, decision 4: Taren's starting skills are Rallying Cry, Cleave, and Unbowed (passive). | Taren entry updated. Shield the Line, Breaking Blow, and Banner of the Yoke still have no confirmed unlock levels. Exact numbers stay open. |
| Nov 14 2026 | Chapter 2, decision 5: the close-call prisoner is **Bram**. His sister **Oda** offers the optional quest **The One on the List**, which turns in after the rescue. | Wrenfield entry updated. Quest rewards and dialogue stay **[PROPOSED]** in `CHAPTER2_SCRIPT.md`. |
| Nov 14 2026 | Chapter 2, decision 6: the chapter title is **The Weight of the Yoke**. It ends on a chapter-complete screen and a save prompt, then hands off to the Valemere road (Chapter 3). | Act II summary updated. *(Superseded later the same day by the full Chapter 2 script approval.)* |
| Nov 14 2026 | Approved everything proposed in `CHAPTER2_SCRIPT.md` as canon. | Wrenfield, Millhaven Road, and Chapter 2 NPC entries filled in (Calder's kit and yield; Bram, Oda, and **The One on the List**; Perrin of The Bent Post; Len; the Traveler; the Crown Sergeant and Crown Soldiers). Chapter 2 summary and canon-at-a-glance updated. The earlier limit on the Chapter 2 script was lifted. Open questions in section 10 are unchanged. |
| Nov 14 2026 | Chapter 3, decision 1: the party meets Alden in **Weigh-House Square**, unmissable on the way to the Salt Lamp, before the job. He speaks the "when we hold the city" line in the open, then greets them as friends. | Alden entry and the Act II summary updated. Backstory, rank, and any later split stay open (questions 10 and 14). |
| Nov 14 2026 | Chapter 3, decision 2: mid-heist, **the Debtman** and his toughs cut them off as they leave with the notes, there to recover the prize and/or remind Lyra of a debt. | Lyra entry and the Valemere section updated. Question 6 (the nature of her ties) stays open. |
| Nov 14 2026 | Chapter 3, decision 3: the enforcer's name in this chapter is **the Debtman**, a moniker only, not a Black Hand title. He is beaten and withdraws alive, leaving the debt hanging. | Valemere and Lyra entries updated. Black Hand leadership stays open. |
| Nov 14 2026 | Chapter 3, decision 4: Lyra's starting skills are Twin Cut, Open Vein, and Cutthroat (passive). Poison and stealth skills unlock later. | Lyra entry updated. Exact numbers stay open. |
| Nov 14 2026 | Chapter 3, decision 5: Lyra becomes controllable at the start of the Debtman fight, after a short mid-heist line. The longer "I signed a job" conversation happens after the battle. | Lyra's join entry updated. |
| Nov 14 2026 | Chapter 3, decision 6: the chapter title is **Crowns and Alleys**. The lead is sold by **Nim**, a fence at **the Salt Lamp**. | Act II summary updated. |
| Nov 14 2026 | Approved everything proposed in `CHAPTER3_SCRIPT.md` as canon. | Valemere Road, Valemere, and Chapter 3 NPC entries filled in (Weigh-House Square; Nim and the Salt Lamp; **A Parcel Unsealed**; the Debtman's moniker, kit, and survival; Lyra's join timing and starting skills; the Fallen Knight's Valemere-road line). Chapter 3 title, levels 10–13, summary, and canon-at-a-glance updated. Open questions in section 10 are unchanged except for placement and texture notes. |
| Nov 15 2026 | Approved all eight Chapter 4 decisions: title **The Old Name**; levels 13–16; Caelan controllable from the start of the Warden fight (4th slot); his starting kit Ember / Frost Lance / Arc Bolt, no passive; the scholar-notes' owner left unstated as canon silence; Alden absent with one optional Taren line; boss **Sanctuary Warden**; handoff on the road out of the hollow with `Q_BV_S6`. | Chapter 4 entries filled in (Hollow Sanctuary, Caelan, the Act II summary, canon at a glance). `CHAPTER4_SCRIPT.md` is now canon. |
| Nov 16 2026 | Approved all eleven Chapter 5 decisions: title **The Deserted Oath**; levels 16–18; Sera controllable **after** the fight; Hailen's yield as a **pre-battle choice** (`flag_hailen_yields`); Sera's kit **Mend / Aegis / Smite**; the party is **not** admitted to the garrison; the Blackwood lead is a **sealed Crown order with a non-Crown seal**; the Fallen Knight's second line *“The forest has already taken its share. It will want another.”*; end at the **treeline** with `Q_BV_S7`; **two rooms** (`rm_blackwood_garrison`, `rm_garrison_keep`); Sera **awaiting transport, not sentenced**. | Sera's entry rewritten, the Blackwood Road Garrison entry filled in, the Act II summary completed, and the act recorded as fully scripted. `CHAPTER5_SCRIPT.md` is now canon; Act II is complete. |
