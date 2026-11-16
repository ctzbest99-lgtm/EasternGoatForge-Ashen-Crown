# ASHEN CROWN — Act V Outline: "The Fallen Knight"

> **Status: DECISIONS APPROVED 2026-11-16 (all ten as recommended); no chapter is written and nothing in the act is built.** §9 records the approvals; the alternatives are kept beneath it as the record of what was considered. **Approval changed no code and no data:** the level cap is still 24 (decision 7 recommends 27 and is not applied), no Act V enemy id or encounter table exists, the four coast rooms are still stub entrances, and no line of dialogue has been written. This is the outline Act V needs before a chapter script can exist, in the same shape as `ACT3_OUTLINE.md` and `ACT4_OUTLINE.md`. The act title **The Fallen Knight** is **[C]** (bible §7). Bible question 2 — who the knight is, whether he is one of the Fallen Knight enemies, and whether he is Act V's subject — is answered here only as a proposal, and partly left open on purpose.
> **Level band: 24–26 [PROPOSED], blocked on the level cap.** `PARTY_MAX_LEVEL` is 24 and Act IV's band is 21–23, so the party ends Act IV at most two levels into this act's floor. §9.7 recommends 27. Without the raise the act cannot be played at its own band, exactly as Act IV could not before its own cap decision.
> **No code, room, enemy, item or line of dialogue exists for this act.** Every number below is a proposal to be simulated before anything is written against it.

Source of truth: `STORY_BIBLE.md` (§2.2 Aethari, §2.3 the Ash, §2.4 the Crownveil, §3 regions, §5.12 the Fallen Knight, §7 the eight acts), `ACT4_OUTLINE.md` §5 and the built Chapters 1–11. Where canon is silent this outline says so and lists the choice.

---

## 0. What is already in the build

- **Nothing of Act V is built.** No room, no marker table, no story script, no dialogue data, no enemy. This document is the first artifact.
- **The four rooms already exist as names, and only as names.** `rm_saltreach`, `rm_saltreach_pier`, `rm_flooded_ruins` and `rm_shipwreck` are referenced by stub entrances in `rm_overworld` (tiles 200,243 · 200,276 · 97,245 · 291,272) and are four of the ten unresolved references the validator reports. Building this act removes four of them; the other six (`rm_rimehold`, `rm_frozen_ruins`, `rm_ironspine_mine`, `rm_ironspine_ruins`, `rm_ashlands_breach`, `rm_ashlands_ruins`) belong to Acts VI–VIII.
- **The water bed is already in the project and unused.** `snd_amb_water` has been generated since the audio pass and no room assigns it. This act is its natural home.
- **The engine needs no change for the act's shape**, with three limits worth naming up front: a boss shifts phase once (`phase2_at`), there is no ally battle slot (Act IV's Alden workaround was scripted damage), and damage-type resistance does not exist. Boss #3 below is written to fit all three.
- **Art debt is the act's largest cost.** 18 enemy kinds still lack 16×24 overworld sets, and a leviathan needs battle art that cannot be borrowed from anything in the project. Saltreach's tileset does not exist; the coast would be a Wrenfield blockout like Acts III–IV until one does.
- **The party is full.** Five members, four active. Act V has no recruit — same as Acts III and IV — so its length has to come from the place and from what the party already is.

## 1. Canon anchors this act must satisfy

From `STORY_BIBLE.md`, locked or confirmed:

- **Act V is titled *The Fallen Knight*** (§7, **[C]**). Nothing else about it is canon.
- **The knight himself** (§5.12): he recognises Kael, says *"Your father knew what was coming"* and *"She opened the door."* Four sightings so far, never named, never fighting: the Bandit Camp's north exit and the Basement stairs in Chapter 1; the Valemere road (*"You cannot cross where she did. Not yet."*); the Blackwood treeline (*"The forest has already taken its share. It will want another."*). **Who he is stays [O]; whether he is one of the Fallen Knight enemies stays [O].**
- **"Fallen Knight" is also an enemy type** — a Zone 1 elite. The story character and the enemy share a name, and canon has never said whether that is a coincidence, a rank, or the same thing.
- **The Crownveil** (§2.4) keeps people inside Eldoria and is failing. What it runs through, and what crossing costs, stay **[O]**.
- **The Ash** (§2.3) is what the Blackguard was corrupted by. This act may show more of what it does to people; it may not explain what it is.
- **The Drowned Coast** (§3) is canon: submerged remains of an ancient civilisation, flooded ruins, coastal villages, shipwrecks, **ancient records**. Its named village **Saltreach** is canon; its size, layout, state and act are **[O]**. Whether the drowned civilisation is Aethari is **[O]**.
- **Sera's silence about the palace** and **Caelan's about what he knows** stay intact — the ruin's Aethari script is Caelan's to read, not to explain.
- **Alden and Taren have not split**, and Ending C is untouched.
- The party says **Aethari**; UI, bestiary and quest text stay on **Architects**.

## 2. Shape: three chapters (12–14), and why the coast

Act II had four chapters because it had four recruits. Acts III and IV have three, no recruits, and length from the place. **Act V follows that shape**, and the route follows geography: Act IV ends on the road south, and the only unassigned region that lies south of the barrow field is the **Drowned Coast**. The Frostwilds is canonically northern and late-game content; the Ironspine is Act VI by its own title; the Ashlands are beyond the Crownveil and Act VII.

Assigning the coast answers bible question 28's open half for this act alone — *where the Drowned Coast falls in the eight acts* — and nothing else.

**Route:** the barrow road south → the coast road → **`rm_saltreach`**, a village that pays the sea → **`rm_saltreach_pier`** → by boat to **`rm_flooded_ruins`**, the drowned Aethari structure → **`rm_shipwreck`**, the hull the record names → inland, north-east, toward the Ironspine (Act VI).

**What the act is about:** the knight has followed Kael for five chapters without ever blocking him. This act reveals **the office and not the man**: the Crown has been sending knights across the Crownveil for a century, some came back, and "Fallen Knight" is what the ones who came back are called. It does not say which one he is, whether he was sent, or what he wants — and the player leaves with a token and no name.

## 3. Chapter 12 — *The Salt Toll*

**Room:** `rm_saltreach` (new; blockout first). A village on a shelf of black rock, salt pans above the tide line, a bell tower with no bell, and a slate at the harbour where one name is written each tide.

**What happens (all [PROPOSED]):**
1. Saltreach pays the sea. One name a tide, written on the slate by the reeve; the tide takes the slate, and the village believes the sea takes nothing else. It has done this for as long as anyone will say, and the Crown taxes the salt it produces.
2. The party arrives to find the tide late, the slate unwritten, and the village arguing about whose name goes on it. **The Crown's salt reeve is not a villain**: she is a clerk enforcing a levy she did not set, in a village whose custom she does not believe in. She yields rather than dies, like Vell and Calder before her (§9.6).
3. **Beneath the reeve's house is the office**: a ledger of crossings — knights sent across the Crownveil, one line each, most marked *returned*, one page with the name scraped off. It is the act's first fact and its only one this chapter: **the Crown has been sending people across, for a very long time, and it counts the ones who come back.**
4. The chapter's horror is the toll itself: the party can end it (§6) and the village will not thank them for it. There is no correct answer and the act does not grade it.
5. **The knight appears on the pier at the end of the chapter** and says one new line **[PROPOSED]**: *"You're early. She was later than you."* He walks out along the pier and is not there when the party follows.

**Boss:** **the Toll-Keeper** — level 24, the drowned thing in the bell tower that collects the slate. Two phases. It does not speak and has no name in the script; the village calls it the keeper.

**What the chapter must not do:** let the reeve explain the crossings, or let anyone in Saltreach recognise the knight.

## 4. Chapter 13 — *What the Tide Kept*

**Room:** `rm_flooded_ruins` (new; blockout first). The tide leaves the upper structure dry for about an hour; the rest is under water and walkable as shallow ruin.

**What happens (all [PROPOSED]):**
1. The drowned structure is **Aethari work**, and Caelan can read the parts that are above the waterline: not a tomb, not a gate — **a record room**. Lists.
2. **The list is eleven names.** Ten have been scraped off with the same chisel Act IV's tomb used — the same hand, the same century, the same intent. The eleventh is legible and is not Kael's father's, not Mira's, and not the knight's. **The act does not say whose it is.**
3. The thing that keeps the ruin is what the toll has been feeding: **the Leviathan**, a beast, not a construct. It is the act's set-piece fight and the reason the toll exists at all. The village has been buying its indifference with names, and the player learns that the day after they may have ended it.
4. **The knight is waiting in the deepest dry chamber.** He does not fight here. He says one line **[PROPOSED]**: *"Eleven went. Ten came back wrong. I am not the wrong one."* He leaves through water the party cannot follow.

**Boss:** **the Saltreach Leviathan** — level 25, two phases, act set-piece. New battle art is required; nothing in the project can stand in for it without reading as a placeholder.

**What the chapter must not do:** let Caelan translate the scraped names, let the party follow the knight, or confirm the drowned civilisation is Aethari.

## 5. Chapter 14 — *The Knight Who Came Back*

**Room:** `rm_shipwreck` (new; blockout first). The hull the ledger names, grounded on a reef at low tide, still holding the fittings of a ship that carried something official.

**What happens (all [PROPOSED]):**
1. The wreck is **the last crossing ship**: a Crown vessel fitted to carry knights to the Crownveil and back, its log still in its case. The log is the act's second fact: crossings stopped, all at once, and the reason is not written down.
2. **The knight is here, and this time he fights** — not to kill Kael, but to find out whether he can cross. At 0 HP **he yields and does not die** (the `yields_if_flag` path Vell uses). The fight is the act boss because the title promises it; the man survives it because his identity is not this act's to spend.
3. After the fight he speaks, and gives the act its shape: the office, the eleven, the ten who came back wrong, and the one line that keeps Kael's father and Mira exactly where canon leaves them **[PROPOSED]**: *"Your father asked me the same question. She didn't ask at all."* He leaves **a crossing token** — the object the Crown gave a knight going across — and walks inland, north-east, toward the mountains.
4. The act ends on the reef at low tide, with the token in the party's pack, the log in it, and the Ironspine on the horizon. **No one says what the token is for.** Act VI is the mountains.

**Boss:** **the Fallen Knight** — level 26, two phases, yields at 0 HP, no death, no bestiary kill credit. He is the only enemy in the act whose name the player already knew.

**What the chapter must not do:** name him, say whether he is the enemy type, say Kael's father crossed, say what happened to the ten, kill him, or open the Crownveil.

## 6. Quests

**Main quest [PROPOSED]:** `Q_MAIN_FALLEN` — *"The Knight Who Came Back"*. Act IV's `Q_MAIN_CROWN` closes at S6 (complete), the way Acts II and III closed rather than growing a seventh stage.

| Stage | Objective text | Set by |
|---|---|---|
| `S1` | "Follow the coast road to Saltreach." | Chapter 12 entry |
| `S2` | "Find out what the village pays the tide." | the Toll-Keeper defeated |
| `S3` | "Find the record of the crossings." | Chapter 13 entry |
| `S4` | "Reach the wreck the ledger names." | the Leviathan defeated |
| `S5` | "Face the knight who has been following you." | Chapter 14 entry |
| `S6` | "Learn what he leaves you." | the knight yields |

**Side quest [PROPOSED]:** `Q_SIDE_TOLL` — *"One Name a Tide"*. The slate, the reeve and the village's arithmetic: break the slate and the toll ends, or write a name and the village keeps its bargain another season. Both endings are quiet; the reward is the same either way and the village's line about the party is not. Deliberately small: Act V's weight is in the knight, and Act IV already carries a branch with no correct answer.

## 7. Encounters, bosses and balance

**Proposed batch — nothing of this exists in the data.** No level, HP, XP or gold number below has been simulated; Act IV's lesson was that unsimulated numbers are wrong numbers.

| Id | Role | Level | Notes |
|---|---|---|---|
| `drowned_husk` | common | 24 | What the coast keeps. Needs new art, or the `barrow_husk` strip recoloured. |
| `salt_wretch` | common | 24 | Reuses `ashen_wretch` art until its own exists. |
| `tide_crawler` | common | 25 | Crab-shelled scavenger. Reuses nothing well; new art. |
| `wreck_shade` | common | 25 | The drowned crew. Reuses `hollow_soldier` silhouette. |
| `toll_keeper` | boss | 24 | Ch 12, two phases. |
| `salt_leviathan` | boss | 25 | Ch 13, two phases, act set-piece. New art required. |
| `fallen_knight_last` | boss | 26 | Ch 14, two phases, yields, no kill credit. Reuses the Fallen Knight strip. |

**Where the numbers come from:** Act IV's pattern — write the ids into `scr_enemy_database.gml`, add the `drowned_coast` table and three boss groups (`grp_toll_keeper`, `grp_salt_leviathan`, `grp_fallen_knight_last`), extend `tools/balance_sim.py` with `--act5`, and tune **before** writing a line of dialogue against them. The band edges to hit are the same as Act IV's: 3–5 rounds at 77–89% party HP with no deaths for commons, and the act boss winnable at the band floor but punishing.

**Two constraints worth stating now:**
- **A level-24 common with Act IV gear will feel like a wall** unless the act adds a weapon and armour tier. That is a content decision (§9.10), not tuning.
- **The leviathan cannot reuse anything.** A boss whose art is a recoloured wretch reads as unfinished in a way a blockout room does not.

## 8. Build plan (the act is approved; this is the order to build it in)

1. **Level cap** — raise `PARTY_MAX_LEVEL` to 27 and confirm the XP curve lands 24–26 at sensible totals (decision 7).
2. **Enemy batch** — seven ids, the `drowned_coast` table and three boss groups; extend `balance_sim.py` with `--act5` and tune before writing lines.
3. **Art** — the leviathan's battle sheet, the coast's tileset or a stone-and-water blockout, Saltreach's village dressing, the crossing token icon. Alden's sprite is not this act's dependency; the coast's water is.
4. **Rooms** — `rm_saltreach`, `rm_saltreach_pier`, `rm_flooded_ruins`, `rm_shipwreck`, all blockouts first, with their marker tables and the four stub entrances flipped to `status: "built"`.
5. **Dialogue data + story scripts** — `scr_dialogue_data_ch12..14` and `scr_ch12_story..scr_ch14_story`, generated from `CHAPTER12_SCRIPT.md..CHAPTER14_SCRIPT.md` by the existing generators.
6. **Audio** — assign `snd_amb_water`, which has been unused since it was generated; the wreck may want the dungeon bed under it.
7. **Wiring** — quest rows, the seal branch from Chapter 11 (`ch11_seal_alden` / `ch11_seal_party`) feeding one letter or the lack of one, and the exit north-east toward Act VI.
8. **Playtest** — last, and only in an IDE.

## 9. Decisions for the owner — **APPROVED 2026-11-16, all ten as recommended**

**The owner approved all ten as recommended on 2026-11-16.** The consequences are recorded in `docs/DECISIONS_AND_OPEN_QUESTIONS.md` under "Act V outline (decisions approved 2026-11-16)", including the region map this fixes for Acts V–VIII. Approval is story and scope only: no enemy, room, quest row, tile or line exists yet, and every number in §7 still has to be simulated before it is used.

1. **Where Act V happens.** *Recommended: the **Drowned Coast** — Saltreach, its pier, the flooded ruins and the wreck.* It is south of Act IV's road, it uses four room names that already exist, and it assigns the region bible question 28 leaves open. Alternative: the **Frostwilds** (Rimehold, frozen ruins), which is canonically northern and late-game and would reorder Acts VI–VIII.
2. **Three chapters (12–14)?** *Recommended: yes.* No recruit; the length is the village, the ruin and the wreck.
3. **Is the knight Act V's subject?** *Recommended: yes — and he is fought once, as the act boss, and yields at 0 HP without dying.* The title promises him; canon never says he cannot fight, only that he has not. Alternative: he never fights and the act boss is the leviathan, which keeps him purely a witness and costs the act its title beat.
4. **What the act reveals.** *Recommended: the office, not the man — the Crown has sent knights across for a century, some came back, and that is what they are called.* It does **not** say which one he is, that he was sent, or that Kael's father crossed. Alternative: reveal nothing, which makes Act V a coast chapter with a cameo.
5. **The toll.** *Recommended: keep it — one name a tide, a village that believes it is buying safety, and a choice with no correct answer.* It is the act's human cost and its only branch. Alternative: cut it and the village becomes scenery.
6. **The bosses.** *Recommended as written:* the Toll-Keeper (silent, drowned), the Leviathan (beast, set-piece), the Fallen Knight (yields). Alternative: drop the Toll-Keeper and open the act on the pier, which loses the village's hold on the player.
7. **Level band 24–26 and `PARTY_MAX_LEVEL` 27.** *Recommended: yes to both.* Act IV's band tops at 23 against a cap of 24; without the raise this act starts at its own ceiling.
8. **Alden.** *Recommended: off-screen for the whole act, present only as one letter whose existence depends on Chapter 11's seal choice — and no split.* He is in the capital doing what the party let him do. Alternative: bring him to Saltreach, which repeats Act IV and spends a beat the split will need.
9. **Rooms.** *Recommended: the four already-referenced coast rooms* (`rm_saltreach`, `rm_saltreach_pier`, `rm_flooded_ruins`, `rm_shipwreck`), which takes the validator's unresolved list from ten to six. No `rm_rimehold`, `rm_frozen_ruins`, `rm_ironspine_*` or `rm_ashlands_*` — those belong to Acts VI–VIII.
10. **A new enemy batch, a new tier of gear and its art.** *Recommended: seven ids, three bosses, one new weapon/armour tier, and real art for the leviathan and the coast.* Alternative: reuse every strip and ship the act visually wrong — cheaper, and it would read as cheap, which is exactly what Act III and IV were warned about.

## 10. Open questions this act must leave open

Bible question numbers: the Ash and the Ash King (1), **the Fallen Knight's identity (2)**, what Sera saw (4), what Caelan knows (5), Lumen (8), the Crown Engine (9), what destroyed Greyhaven (16), the Night of Ash (17), whether the Crownveil Door is the passage beneath Greyhaven (18), Mira's stone (19), why the carvings resemble Mira (20), "everything stops" (22), why the royal banner bears the mark (24), where the Crownveil runs (25). **Act V may add questions; it answers one half of one of them (region assignment, 28) and none of the rest.** In particular:

- **Who the knight is** (2) — this outline gives him an office and keeps his name, his history and his relationship to Kael's father exactly where canon left them.
- **Whether he is one of the Fallen Knight enemies** (2) — the act shows the name is a category and never says he belongs to it.
- **What the Crownveil does to the people who cross it** — ten came back wrong, and "wrong" is all the act says.
- **Whose name is the eleventh** — legible, and not anyone the player knows.
- **Whether the drowned civilisation is Aethari** — Caelan reads the script; nobody translates the history.
- **What Alden is doing with the seal** — the letter says what he says, not what he means.

## 11. What Act V must not do

- Name the Fallen Knight, kill him, or confirm he is the enemy type.
- Say Kael's father crossed the Crownveil, or that Mira did, or where she is.
- Open the Crownveil, show its far side, or explain the Ash, Lumen or the Crown Engine.
- Split Alden from Taren, or move Ending C forward.
- Let Caelan explain the Aethari's fate, or break Sera's silence about the palace.
- Use the Frostwilds, Ironspine or Ashlands rooms — they belong to Acts VI–VIII.
- Present any number in §7 as balanced before it has been simulated.
