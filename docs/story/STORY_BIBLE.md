# ASHEN CROWN — Story Bible

**Studio:** Eastern Goat Forge · **Engine:** GameMaker Studio (GML) · **Genre:** Dark medieval fantasy RPG, classic turn-based combat · **Platform:** PC
**Source:** `MASTER_GDD.txt` (master design doc). This file contains only what that doc says. Anything the doc leaves undecided is marked **Open** and listed in [Open questions for Kevin](#10-open-questions-for-kevin).

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

### 2.2 The Architects
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

---

## 3. Regions

**[C]** The world has seven major regions. Smaller named settlements: Greyhaven (a region in its own right) and Millhaven (see below; confirmed Nov 14 2026).

| # | Region | Canon details |
|---|---|---|
| 1 | **Kingdom of Eldoria** | The central kingdom. Capital: **Valemere** (about 80,000 residents). Districts: Royal District, Merchant District, Lower City, Temple District, Military District, Old Quarter. Major hub for politics, quests, shops, factions and party development. |
| 2 | **Greyhaven** | Kael's hometown. A small farming and trading settlement of about 1,200 residents. **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) Already destroyed when Kael arrives. The destruction itself is not played. |
| 3 | **Blackwood** | A cursed forest: missing travelers, strange creatures, ancient stone doors, unnatural darkness, forgotten ruins, connections to Mira's disappearance. |
| 4 | **Ironspine Mountains** | A dangerous mountain region with ancient Architect ruins: mountain passes, abandoned mines, underground structures, ancient machines, powerful enemies, important Crownveil discoveries. |
| 5 | **Drowned Coast** | A coastal region with submerged remains of an ancient civilization: flooded ruins, coastal villages, shipwrecks, underwater or submerged exploration where technically appropriate, ancient records. |
| 6 | **Ashlands** | A dead region beyond the Crownveil: ash-covered ground, distorted landscapes, mutated creatures, broken ancient structures, dangerous environmental effects, major story revelations. |
| 7 | **Frostwilds** | A northern region: frozen ruins, snow-covered settlements, an ancient northern civilization, difficult environmental conditions, late-game enemies and story content. |

### Millhaven **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
- A settlement, and Taren Holt's place of origin.
- **[O]** Its region, size, layout and current state. Whether Kael, Taren and Alden grew up together there or in Greyhaven (Kael's home).

### Greyhaven locations [C]
Varyn House · Rusted Boar Tavern · Greyhaven Chapel · Blacksmith · General Store · Town Square · Old Watchtower · North Gate

- **[C]** The Zone 1 area list for Greyhaven gives the same places, minus the Old Watchtower, and calls the chapel just "Chapel." It names Greyhaven a safe area with no random battles. In Zone 1 the Old Watchtower is a separate dungeon, reached after the Old Road and the Bandit Camp.
- **[O]** Whether the Old Watchtower is inside Greyhaven or out along the road.
- **[O]** No region has a canon map or layout. The "ancient northern civilization" in the Frostwilds is not named, and the doc doesn't say whether it is the Architects.

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
- **Note for Coder:** the party now has **two frontline melee fighters, Kael and Taren**. Formation and targeting rules should allow both to hold front slots, and their kits should be distinct. Taren's skills are still open.
- **Note for Coder:** the equipment system needs a **"heavy sword" weapon category**. Taren can equip any weapon in it, and his starting weapon is a bastard sword in that category. Which other characters, if any, can use heavy swords is **[O]**, as is the list of heavy swords.
- **[O]** Whether the story restricts swapping, e.g. forced or locked members in certain scenes, and when members join.

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
- At the end of Chapter 1 it reacts to the sealed stone door.
- **[O]** The symbol's design is undefined.

### 5.2 Lyra Veyne — Rogue [C]
- **Weapon:** twin daggers. **Role:** critical hits, bleeding, poison, multiple attacks, stealth, fast damage.
- **Personality:** sarcastic, selfish at first, loyal once trust is earned, brings occasional humor.
- **Background:** from the lower city and the criminal underworld. Has ties to the Black Hand.
- **[O]** Where and how she joins. The nature of her Black Hand ties.

### 5.3 Caelan Rook — Arcanist [C]
- **Weapon:** spellbook. **Role:** fire, ice, lightning and dark magic; exploiting enemy weaknesses; magical damage.
- **Background:** former royal scholar. He knows more about the Crownveil, and why it broke, than he admits at first.
- **[O]** What exactly he knows. How and when he joins.

### 5.4 Seraphine "Sera" Thorn — Warden [C]
- **Weapon:** holy sword. **Role:** healing, shields, buffs, resurrection, holy damage.
- **Background:** former Silver Guard knight. She left the kingdom after witnessing something inside the royal palace.
- **[O]** What she saw. How and when she joins.

### 5.5 Taren Holt — Rebel Captain, permanent party member **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026)
- **[C]** In the design doc he appears only in Alden's entry: "Kael and Taren must stop him."
- **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) **Beliefs:** freedom is worth fighting for. He stands for the Broken Yoke's (the rebellion's) **original purpose: freedom for the people.** He wants to dismantle the oppressive system so that people govern themselves.
- **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) **Kael:** childhood friends who fight alongside one another.
- **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) **Alden:** also Alden's childhood friend. Alden becomes Taren's greatest disappointment.
- **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) **Ideological opposite of Alden:** both start with the same dream, but Alden decides he should rule Eldoria himself. That makes the betrayal especially painful for Taren.
- **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) **Party:** a permanent party member, part of the five-person roster.
- **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) **Story weight:** his friendship with Kael and his history with Alden should make the final Alden confrontation one of the most emotional moments in the game. He should be more than a warrior.
- **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) **Profile:** full name **Taren Holt**. **Age** 27. **Origin** Millhaven. **Class** Rebel Captain. **Faction** The Broken Yoke. **Role** Warrior / frontline fighter. **Weapon class** heavy swords: he can equip any sword classified as heavy, and his signature and starting weapon is a bastard sword. Childhood friend of Kael and Alden. *(This replaces the earlier Scout/Thief class and knife.)*
- **[O]** Specific skills, and when and how he joins the party.
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
- **[O]** All of the above details. Who defeats Aldric, and how. When and how Alden and Taren split.

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

The beats below follow that route. **[O]** The doc doesn't say exactly where the Tomas, pendant and Fallen Knight beats happen. Their positions here are suggestions only.

1. **Return to Greyhaven** (level 1, safe, no random battles). Kael comes home to an already destroyed village. **[C-confirmed]** The destruction is not played. His dying father says *“Your sister… she went into the woods.”* Kael searches the ruins of Varyn House and finds Mira's wooden pendant, with no body. **[C-confirmed]** **Opening quest: Find Mira.** **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) The order follows `CHAPTER1_SCRIPT.md`: arrival, then Tomas in the forge (he passes out, not dead), then the pendant in the Varyn House ruins, after which Corwin opens the North Gate.
2. **Greyhaven Farmlands** (level 1–2). Bandits and Ash Wolves. The **first guaranteed Bandit encounter** teaches combat.
3. **Hunter's Camp** (level 2, optional). Old Hunter Renn. Optional quest reward: Hunter's Charm.
4. **Old Road** (level 2–3). Bandits, Ash Wolves, Ashen Wretches, and the rare Ashbound Hunter.
5. **Ashbound Hunter special encounter** (rare, 3–5%, recommended level 3–5; can appear on the Old Road, at the Bandit Camp and in the Watchtower). "An arrow lands beside Kael before combat begins." **Story clue:** a parchment reads *“Find the girl. The Varyn girl is still alive.”* **[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) **The parchment can't be missed:** the first Ashbound Hunter fight in the Old Watchtower is guaranteed and drops the parchment if the player hasn't already got it. The rare 3–5% encounter stays in place elsewhere.
6. **Abandoned Bandit Camp** (level 3–4). Bandits, Fallen Knights, Ashen Wretches, rare Ashbound Hunter. Possible chest rewards: Minor Potion x3, Antidote x2, 50 Gold, Iron Sword.
7. **Fallen Knight lines** (**[C-confirmed]** (Confirmed by Kevin, Nov 14 2026) line 1 at the Bandit Camp's north exit, line 2 at the top of the Basement stairs): *“Your father knew what was coming.”* … later *“She opened the door.”*
8. **Old Watchtower** (level 4–7, main dungeon). Fallen Knights, Grave Spiders, Hollow Soldiers, Ashbound Hunter. Locked doors, keys, chests, traps, environmental lore, ancient symbols. **Banner clue:** an old royal banner bears the same symbol as Kael's pendant and the symbol connected to the Crownveil.
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
    **[O]** What "everything stops" *means* in the story. Whether this door is the same passage beneath Greyhaven that Mira opened.

---

## 7. Eight-act outline

**[C]** The main story is planned as eight acts, each with real gameplay (not just cutscenes): main and side quests, new areas, NPCs, character development, dungeons, bosses, story revelations, equipment progression and party development.

| Act | Chapter name | Status |
|---|---|---|
| 1 | The Night of Ash | **[C]** Zone 1 detailed (section 6) |
| 2 | The Broken Crown | **[O]** Not yet detailed |
| 3 | The Blackwood | **[O]** Not yet detailed |
| 4 | The Forgotten King | **[O]** Not yet detailed |
| 5 | The Fallen Knight | **[O]** Not yet detailed |
| 6 | Beneath the Mountains | **[O]** Not yet detailed |
| 7 | The Ashlands | **[O]** Not yet detailed |
| 8 | The Truth | **[O]** Not yet detailed |
| Finale | **The Ashen Crown** (final endgame sequence) | **[O]** Not yet detailed |

- **[O]** The names suggest region links (Blackwood, Ironspine as "Beneath the Mountains", Ashlands), but the doc never assigns regions to acts. The act list has no clear place for Valemere, the Drowned Coast or the Frostwilds. The doc also doesn't name the "Forgotten King."

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
- **Canon:** everything tagged [C] above, including all verbatim dialogue.
- **Unconfirmed:** Endings 1–3.
- **Open:** everything in section 10.

## 10. Open questions for Kevin

**People**
1. Who or what is the Ash King? How does it connect to the Crownveil, the Ash, and "the entity beyond it"?
2. Who is the Fallen Knight who recognizes Kael? Is he one of the Fallen Knight enemies, and is he the subject of Act 5?
3. Who is the Blackguard (name, history)? How does he know Mira and Kael?
4. What did Sera see inside the royal palace?
5. What exactly does Caelan know about the Crownveil and why it broke?
6. What are Lyra's Black Hand ties?
7. When and where do Lyra, Caelan, Sera and Taren join the party?
8. Taren's specific skills. (Class Rebel Captain, frontline warrior role, heavy-sword weapon class with a bastard sword as signature and starting weapon, and age 27 are settled.)
9. Where did Kael (Greyhaven), Taren (Millhaven) and Alden grow up together: Millhaven, Greyhaven or elsewhere? Where is Alden from? When and how did Alden and Taren split? Where is Millhaven, and what is it like?
10. Elira's fate: alive, dead or missing after Greyhaven?
11. What is Tomas's ultimate fate (he passes out in Chapter 1, not dead), and what did he know "was coming"?
12. Who is the "Forgotten King" in Act 4?
13. Alden's backstory, his exact role in the Broken Yoke, and who defeats King Aldric IV, and how.
14. What are Aldric IV's motives for hiding the Crownveil's failure?

**Events and world**
15. What destroyed Greyhaven, and how? (Timing is settled: before Kael arrives, not played.)
16. What is "the Night of Ash" as an event?
17. Is the passage beneath Greyhaven that Mira opened the same as the Crownveil Door at the end of Zone 1? Where is the Old Watchtower relative to Greyhaven?
18. What happened to Mira's black stone?
19. Why do the Architect carvings resemble Mira?
20. Who wrote the Ashbound parchment, and who sent the Ashbound Hunter?
21. What does "Then everything stops" mean in the story? (The on-screen presentation is settled: a hard cut to black.)
22. What does the pendant's shared symbol look like, and is it the crown around a black sun?
23. Why does a royal banner carry the Crownveil symbol? What does the crown know?
24. Where exactly does the Crownveil run? It is believed to protect Eldoria, but the Ashlands lie "beyond" it. What is it keeping in?
25. What are the answers to the six gradual Crownveil truths, and in which acts are they revealed?
26. Is the Frostwilds' "ancient northern civilization" the Architects or a separate people?
27. Which acts map to which regions? Where do Valemere, the Drowned Coast and the Frostwilds fall in the eight acts?
28. Who leads the Broken Yoke, and how is it structured? (Name settled. Taren is a Rebel Captain.)
29. Is Greyhaven Chapel part of the Radiant Flame?
30. What is Mira's age now? The doc gives "twelve when the tragedy began." How much time has passed?

**Endings and systems that touch lore**
> **Note for Coder:** the party is **5 members with 4 active** (Kael, Lyra, Caelan, Sera, Taren). The Adventure menu's Party Order needs a reserve slot. Kael and Taren are both frontline melee fighters. See "Party roster" in section 5.
31. Which ending(s) are final, and what are the branching conditions (choices, relationships)?
32. How does Alden's Ending C relate to the three Crownveil endings? Is it a separate branch, a step before the finale, or a fourth ending?
33. What is "the entity" in Endings 2 and 3, and is it the Ash or the Ash King?
34. Kael's Ashen Resolve says "Ash increases by 1." What is the Ash stat or meter?
35. Party swapping: does the story restrict it (locked or forced members in certain scenes)? Does the reserve member earn XP?
36. Battle presentation: are battles FF1-style menu battles (the current assumption)? The doc's "hybrid, varying by encounter" note still needs his final word. (The exploration camera is settled.)

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
