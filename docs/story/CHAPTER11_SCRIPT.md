# ASHEN CROWN — Chapter 11 Script: "The Forgotten King" (Act IV: The Forgotten King)

Route: the steps below `rm_barrow_gate` → **`rm_barrow_halls`** (30×20), a royal tomb with every name chiselled off → **`rm_barrow_deep`** (26×20), the last chamber, the kept king, the charter and the seal → the act's end.

> **Status: BUILT 2026-11-16 from the approved Act IV outline — not individually approved, not played.**
> Built: `scr_dialogue_data_ch11` (81 nodes: 77 scripted + 4 wiring-only), `scr_ch11_story` (halls entry, the two optional lore scenes, the charter, the King gate with retry, the aftermath, the seal choice, the act card), `rm_barrow_halls` (30×20) and `rm_barrow_deep` (26×20) with `scr_build_barrow_halls`, `scr_build_barrow_deep` and `scr_ch11_markers_data`, `Q_MAIN_CROWN` S5–S6, and the wiring into the dialogue chain, the battle-finish hook, the controller's step and room-start hooks and the audio set. **All of Act IV's room references now resolve** — what is left on the validator's list belongs to Acts V–VIII.
> **The mark is named, not explained.** §3.4 reveals that the Crown's oldest hand calls the mark **the Crownveil** — the phrase the bible and Chapter 1 already use for it (*"a Crownveil symbol"*). The charter gives the name and nothing more: no meaning, no origin, no answer to why the royal banner bears it. **The Ashen Crown stays reserved for the finale** (bible, ending table) and is deliberately not used for the mark.
> **Not played.** The tomb now builds on the `ts_barrow` crypt atlas (unseen in an IDE), the King reuses the sanctuary warden's strips, and every NPC is a placeholder. Level band **23**; this is the act boss.

Source of truth: `STORY_BIBLE.md` and `ACT4_OUTLINE.md` §5, §9, §11. Presentation: FF1-style top-down exploration; menu battles.

## How to read this file (for Coder)

- Prefixes: `BH_` for the halls, `FD_` for the deep chamber, `BK_` for the charter and the name, `FK_` for the King, `SL_` for the seal choice, `AD_` for Alden in the tomb, `ACT4_` for the act card.
- Format: `**ID** · Speaker`, each `>` line one box line. `NARRATION` = no speaker; `SYSTEM` = UI; `[STAGE]` = direction, not shown.
- **What this chapter must not do:** explain the Ash, the Crownveil, the Aethari's fate, Lumen or the Crown Engine; say the King is Aethari; let the King name Mira, the Fallen Knight or Alden's future; resolve Alden; bring the Fallen Knight on screen; move Ending C.

---

## 0. Quest text

| Stage | ID | Objective text | Set when |
|---|---|---|---|
| 5 | `Q_MC_S5` | "Learn what the charter names." | Entering `rm_barrow_halls` |
| 6 | `Q_MC_S6` | "Decide who carries the seal." | The King's defeat |
| — | complete | — | The seal choice resolves |

---

## 1. The halls — `BH_ARRIVE`

[STAGE] Stone steps down into a hall that was built to be walked through by crowds: processional width, niches on both walls, a ceiling that goes up further than the torchlight. Every inscription has been struck through. `snd_amb_dungeon`. Sets `ch11_entered`, `Q_MC_S5`.

**BH_ARRIVE_01** · NARRATION
> The steps end in a hall built for crowds. The ceiling goes up past the torchlight.
> There is dust on the floor and no footprints in it but theirs.

**BH_ARRIVE_02** · Lyra
> Somebody swept this. Not recently. But somebody swept it.

**BH_ARRIVE_03** · Caelan
> Look at the niches.

**BH_ARRIVE_04** · NARRATION
> Each niche holds a name cut into the stone. Every name has been struck through with a chisel: one diagonal, then another, the same depth, the same angle, the same hand.

**BH_ARRIVE_05** · Sera
> That's not weathering. That's work.

**BH_ARRIVE_06** · Caelan
> The same hand, the same chisel, done in one campaign. Nobody forgets a king by accident.
> Somebody stood where we're standing and crossed out every name in this room.

**BH_ARRIVE_07** · Taren
> Then why keep the room?

**BH_ARRIVE_08** · Caelan
> Because you can't cross out a room. You can only cross out what's written in it.

**BH_ARRIVE_09** · Alden
> I've spent four years arguing that the Crown lies to the people who keep it fed.
> I never once thought it would go back and edit the dead.

**BH_ARRIVE_10** · Kael
> It went back and edited the dead. Keep walking.

### 1.1 The struck names — `BH_NAMES` (optional)

[STAGE] Inspecting a niche sets `ch11_names_seen`. Repeat look plays `BH_NAMES_R1`.

**BH_NAMES_01** · NARRATION
> The name is gone under the chisel, but the title above it was left: *keeper of the fifth holding*. The same words as the survey page.

**BH_NAMES_02** · Lyra
> Fifth holding. Coleford's ledger said the fifth holding had no tax line.
> It had a person in it.

**BH_NAMES_03** · Caelan
> It had a whole house in it. This is the house.

### 1.2 The grave goods — `BH_NICHE` (optional)

[STAGE] A niche with the offerings still in it: a cup, a knife, a child's shoe. Sets `ch11_niche_seen`.

**BH_NICHE_01** · NARRATION
> A cup, a knife, and a shoe sized for a child. The offerings were never taken.
> Whoever crossed out the names did not rob the dead.

**BH_NICHE_02** · Sera
> That's the part I can't make fit. They hated this house enough to erase it and careful enough not to touch its offerings.

**BH_NICHE_03** · Caelan
> Careful isn't the same as kind. Somebody was afraid of this room.

---

## 2. The last chamber — `FD_ARRIVE`

[STAGE] The hall narrows into a chamber with a single dais. On the dais, a body in royal grave-clothes, kept rather than decayed, iron oath-work bolted through the wrists and ribs. Beside it, a stone lectern with a charter under glass that is not glass. On a stand of its own, the seal. Sets `fd_entered`.

**FD_ARRIVE_01** · NARRATION
> The chamber has one piece of furniture in it and it is a throne.
> The man sitting in it has been dead for a very long time and has not finished doing it.

**FD_ARRIVE_02** · Sera
> That's not a body. That's a body somebody maintains.

**FD_ARRIVE_03** · Caelan
> Iron through the wrists. Through the ribs. The same riveted plate as the Warden, but older.
> They built the guardian into the king.

**FD_ARRIVE_04** · Taren
> Why?

**FD_ARRIVE_05** · Caelan
> So the house would have a keeper. Not a ghost. A keeper.

**FD_ARRIVE_06** · Alden
> There's a charter.

**FD_ARRIVE_07** · NARRATION
> A stone lectern at the foot of the dais. Under a sheet of something clearer than glass, a charter: one page, the Crown's oldest hand, and a seal pressed at the bottom that is not the Crown's seal.

**FD_ARRIVE_08** · Kael
> The seal's on the outside. That's the one we came for.
> Read the charter first.

---

## 3. The charter — `BK_CHARTER`

[STAGE] Reading is the act's one revelation and it is required: the King does not wake until the name is read aloud. Sets `ch11_charter_read`, then plays the waking.

**BK_CHARTER_01** · NARRATION
> The charter is one page. Land, obedience, the founding of a house, and the words *by this mark shall it be known*.
> At the bottom, pressed into the wax: a crown ringing a black sun.

**BK_CHARTER_02** · Caelan
> It's a foundation charter. Somebody legitimised a house with this.
> Read the line at the top. The old hand. Before the Crown wrote like the Crown.

**BK_CHARTER_03** · NARRATION
> One line, older than the rest, in a hand that cuts instead of flows:
> *The mark of the Crownveil.*

**BK_CHARTER_04** · Kael
> The Crownveil.

**BK_CHARTER_05** · Sera
> That's what it's called.
> Like the door.

**BK_CHARTER_06** · Lyra
> That's all it is? A name?

**BK_CHARTER_07** · Caelan
> That's all the page says. A name and a seal and a house.
> It doesn't tell us what it means. It tells us what to call it, and it tells us somebody wanted it called that in front of witnesses.
> Whether the door is named after the mark or the mark after the door, nobody wrote down. Don't ask me to guess.

**BK_CHARTER_08** · Taren
> So we've come a hundred miles for a name.

**BK_CHARTER_09** · Caelan
> We've come a hundred miles to learn the mark has a name the Crown stopped saying.
> That's not nothing. That's a thing somebody was made to stop saying.

**BK_CHARTER_10** · Alden
> Say it again.

**BK_CHARTER_11** · Kael
> The Crownveil.

**BK_CHARTER_12** · NARRATION
> On the dais, the kept king's head comes up.
> The iron through his wrists takes the weight of his hands, and the oath-work in his chest turns over once, like a key.

**BK_CHARTER_13** · Sera
> It heard the name.

**BK_CHARTER_14** · Caelan
> It's been waiting to hear the name.

[STAGE] → §4.

---

## 4. The keeper — `FK_INTRO`

[STAGE] The Forgotten King: a corpse kept by Crown oath-work, and the oath requires a keeper. He is not a ghost and not a puppet, he does not hate the party, and he does not speak in sentences. Fight: `grp_forgotten_king` (level 23, 1714 HP, 61 ATK, three mechanical phases — ATK/SPD +20% at 60%, another ATK +15% and heavier attacks at 30%). Boss music and boss bar. Sets `ch11_king_fight`.

**FK_INTRO_01** · NARRATION
> He stands. It takes a long time and none of it is graceful.
> The iron in his chest is doing the work his body stopped doing.

**FK_INTRO_02** · Caelan
> It's not him. It's the oath wearing him.
> Same as the Warden. Older. Worse.

**FK_INTRO_03** · Alden
> He's not attacking us. He's standing between us and the seal.

**FK_INTRO_04** · Sera
> Same thing, from where I'm standing.

**FK_INTRO_05** · Taren
> He's not going to stop.

**FK_INTRO_06** · Kael
> No. Form up. Don't touch the seal until he's down.

[STAGE] His second phase is the data's `phase2_at: 0.6` shift: *"The oath breaks. Something underneath it does not."* The third is `phase3_at: 0.3`: *"The oath lets go. What is left was always a man."* — the corpse spending what the oath was holding, with heavier attacks and a further ATK rise. §5 is what happens when that phase ends.

---

## 5. What the oath was holding — `FK_AFTER`

[STAGE] On victory: `ch11_king_defeated`, `Q_MC_S6`. The body is finally a body. The seal is still on its stand and the chamber is very quiet. Sets `ch11_king_defeated`.

**FK_AFTER_01** · NARRATION
> The iron goes still, and then the body does what bodies do.
> It takes a while. Nobody says anything while it happens.

**FK_AFTER_02** · Caelan
> The oath let go. That's all that was holding him up.
> There's no ghost here. There never was.

**FK_AFTER_03** · Sera
> Then what did we fight?

**FK_AFTER_04** · Caelan
> A promise that outlasted the man who made it.

**FK_AFTER_05** · Taren
> Say that again for the ones at the back.

**FK_AFTER_06** · Caelan
> Somebody promised this tomb a keeper, and the promise kept its word a hundred years after everybody who could be thanked for it was dead.

**FK_AFTER_07** · NARRATION
> The seal sits on its stand. A crown ringing a black sun, small enough for a hand.

**FK_AFTER_08** · Alden
> That's it. That's what the road was for. That's what the ledger was paying for.
> A door, a keeper, and a stamp.

**FK_AFTER_09** · Lyra
> A stamp with a name on it.

**FK_AFTER_10** · Alden
> The old name. The one nobody's been allowed to say.

**FK_AFTER_11** · NARRATION
> Nobody moves toward the stand.

---

## 6. The seal — `SL_CHOICE`

[STAGE] The act's only branch, and it has no correct answer and no stated consequence. Two options, so the choice is a decision rather than a menu. Sets `ch11_seal_alden` or `ch11_seal_party`; on either, `Q_MAIN_CROWN` completes and the act card plays.

**SL_CHOICE_01** · Kael
> Somebody has to carry it out of here. It can't stay.

**SL_CHOICE_02** · Alden
> I'll take it.

**SL_CHOICE_03** · NARRATION
> He says it before anyone else can, and he does not explain himself, which is new.

**SL_CHOICE_04** · Taren
> Alden.

**SL_CHOICE_05** · Alden
> I'm not going to argue for it. I'm telling you what I'd do with it, and you can decide I'm wrong.
> Whoever sits the throne next will need a reason. This is a reason with a name on it.

[STAGE] → the player chooses in §6.1 / §6.2. **Taren's doubt is one line and stays unspoken-to-resolution.**

### 6.1 If the player lets Alden take it — `SL_ALDEN`

**SL_ALDEN_01** · Kael
> Take it.

**SL_ALDEN_02** · NARRATION
> Alden picks the seal up the way you pick up something you intend to give back.
> He puts it inside his coat without looking at it again.

**SL_ALDEN_03** · Alden
> Thank you. I mean that. I'm not going to make a speech about it.
> When there's a reason to show it, I'll show it to all of you first.

**SL_ALDEN_04** · Taren
> …

**SL_ALDEN_05** · Alden
> Taren.

**SL_ALDEN_06** · Taren
> It's a long walk back. Let's take it in daylight.

### 6.2 If the party keeps it — `SL_PARTY`

**SL_PARTY_01** · Kael
> No. It stays with us.

**SL_PARTY_02** · Alden
> All right.

**SL_PARTY_03** · NARRATION
> He steps back from the stand and puts his hands where everyone can see them, which is either grace or a lesson in how to be trusted, and nobody can tell which.

**SL_PARTY_04** · Alden
> For what it's worth — I think you're wrong. I'd have said the same in your place.
> That's not the same as being sure.

**SL_PARTY_05** · Taren
> …

### 6.3 The act card — `ACT4_END`

[STAGE] Plays immediately after the branch. Sets `chapter11_complete`, `flag_act4_complete`; `Q_MAIN_CROWN` completes first.

**ACT4_END_01** · NARRATION
> They climb out of the barrow into a grey afternoon with the whole road to walk back.
> Behind them, the tomb is a hill again.

**ACT4_END_02** · Caelan
> It has a name. That's what we have: a name and the paper it was written on.
> Everything else in this kingdom is going to have to be asked about that name.

**ACT4_END_03** · Sera
> Then we ask. Out loud. In front of people.

**ACT4_END_04** · Alden
> That's a plan I can carry.

**ACT4_END_05** · NARRATION
> Taren walks at the back of the line the whole way to Coleford, and says nothing, and does not once look at Alden's coat.

**ACT4_END_06** · SYSTEM
> Quest complete: The King Who Was Forgotten.
> Chapter 11 — The Forgotten King — Complete.
> Act IV — The Forgotten King — Complete.

---

## 7. Cast, flags, encounters and build

| Name | Role | Notes |
|---|---|---|
| The Forgotten King | Act boss | A kept corpse, held by Crown oath-work. No language, no hatred, no explanation. Three mechanical phases. |
| The Crownveil | The mark's name | The charter's oldest line. The same word canon already uses for the mark, given as a name and never as a meaning. |
| Alden Marr | Companion | Asks for the seal once, states his reasoning, accepts either answer. Not framed as a traitor. |
| Taren Holt | Companion | His first real doubt: one ellipsis, one silence on the walk back. The chapter ends before he says it. |

| Flag | Set by | Meaning |
|---|---|---|
| `ch11_entered` | Halls entry | Chapter 11 began |
| `ch11_names_seen` / `ch11_niche_seen` | §1.1 / §1.2 | Optional hall lore |
| `fd_entered` | Deep entry | The last chamber reached |
| `ch11_charter_read` | §3 | The charter names the mark |
| `ch11_king_fight` / `ch11_boss_cool` | §4 / a lost fight | The fight happened / the gate re-arms |
| `ch11_king_defeated` | Victory | The King is down and the seal is free |
| `ch11_seal_alden` / `ch11_seal_party` | §6.1 / §6.2 | The act's branch |
| `chapter11_complete` / `flag_act4_complete` | §6.3 | Chapter and act complete |

- **Boss:** `grp_forgotten_king` — solo `forgotten_king`, level 23, 1714 HP, 61 ATK, 45 DEF, three phases. Simulated with all three at 23: **98% in 8.5 rounds, 1.07 deaths (+Caelan)** and **93% in 9.8 rounds, 0.85 deaths (+Sera)**; at level 21 it is **79–82%** in 9.4–10.8 rounds. The third phase now exists in data and engine; §5 is its aftermath.
- **Encounters:** `crown_barrow` in `rm_barrow_halls` only. The deep chamber has no random encounters, so the boss is never walked into tired.
- **Alden is not in the battle line** (no ally slot exists).

### Build plan, and what was built

1. **This script** — done 2026-11-16.
2. **Dialogue data** — `scr_dialogue_data_ch11`, generated by `tools/gen_ch11_dialogue.py` from this file. **Done** (81 nodes: 77 scripted + 4 wiring-only).
3. **Story script** — `scr_ch11_story`: entry, the halls lore, the charter, the King gate with retry, the aftermath, the seal choice, the act card. **Done.**
4. **Rooms** — `rm_barrow_halls` (30×20) and `rm_barrow_deep` (26×20) via `tools/gen_ch11_rooms.py`, closing Act IV's last two references. **Done.**
5. **Quests** — `Q_MC_S5` on halls entry, `Q_MC_S6` on the King's defeat, complete at the choice. **Done.**
6. **Art** — the tomb needs its own tileset and the King his own strips; he borrows `sanctuary_warden`'s. **Not done.**
7. **Audio** — `dungeon` bed for both rooms; the King needs a boss theme distinct from the Warden's. **Partly done.**

**Deviations, recorded:** Alden has no battle slot, and the mark's name is a [PROPOSED] choice the owner can reverse in one line. (The King's third phase was a recorded deviation until the battle system gained a second shift; it now runs.)
