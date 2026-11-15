/// scr_game_constants — shared macros and enums for the exploration + battle prototype.
/// Values here are prototype defaults, not approved design decisions.

// Room handles used by the encounter flow (create these rooms in the IDE; names must match).
#macro OVERWORLD_ROOM rm_overworld
#macro BATTLE_ROOM rm_battle_test
#macro TITLE_ROOM rm_title

// Town wake-up after defeat (owner decision 2026-11-14).
// No separate town room yet. Respawn is Greyhaven town_square
// (tile 199, 176 → 3192, 2832, facing down), not the south-road player_start.
// scr_build_overworld also spawns obj_respawn_point there, which overrides
// these constants if present. When a real town room is built:
//   1. Change TOWN_RESPAWN_ROOM to that room's asset name (e.g. rm_town).
//   2. Place one obj_respawn_point in open space (inn, shrine, etc.).
//   3. Or set TOWN_RESPAWN_X / TOWN_RESPAWN_Y to a known open position.
#macro TOWN_RESPAWN_ROOM rm_overworld
#macro TOWN_RESPAWN_X 3192
#macro TOWN_RESPAWN_Y 2832

// Show encounter trigger placeholders in-game while prototyping. Set to false to hide them.
#macro DEBUG_SHOW_TRIGGERS true

// Versioned JSON saves (save1.sav–save3.sav). DEBUG_SAVE_ANYWHERE (F5) is off by default.
#macro SAVE_SCHEMA_VERSION 3 // v3 (Adventure menu): bestiary seen/defeated log. v1/v2 saves are migrated on load.
#macro SAVE_SLOT_COUNT 3
#macro DEBUG_SAVE_ANYWHERE false

// Shop sell rate and item effects. All PLACEHOLDER (no prices in the story docs).
#macro SHOP_SELL_RATE 0.5
#macro ITEM_MINOR_POTION_HEAL 15

// Guard multiplies incoming damage by this value (minimum 1 damage still applies).
#macro GUARD_DAMAGE_MULTIPLIER 0.5

// Escape (battle command, spec §12). Chance = base + (party level - enemy level) * step,
// clamped. Level is averaged over the living members on each side. PLACEHOLDER tuning.
#macro BATTLE_ESCAPE_BASE_CHANCE 0.55
#macro BATTLE_ESCAPE_LEVEL_STEP 0.06
#macro BATTLE_ESCAPE_MIN_CHANCE 0.10
#macro BATTLE_ESCAPE_MAX_CHANCE 0.90

// Defeat penalty (owner decision 2026-11-14; percentages are defaults pending tuning).
// Gold: floor(current shared gold * DEFEAT_GOLD_LOSS_PCT), never below 0.
// XP: floor(progress toward next level * DEFEAT_XP_LOSS_PCT), never a level-down
// or a negative total (see scr_apply_defeat_penalty).
#macro DEFEAT_GOLD_LOSS_PCT 0.5
#macro DEFEAT_XP_LOSS_PCT 0.1

// Random encounters while walking (owner decision 2026-11-14; rates pending tuning).
// A "step" is ENCOUNTER_STEP_PIXELS of actual movement (default: one 16px tile).
// After grace, a randomized counter in [MIN, MAX] counts down; 0 starts a fight from the
// current area table. Standing still, sliding into a wall, or locked input does not count.
// Set RANDOM_ENCOUNTERS_ENABLED to false to compile them out, or flip
// global.game.random_encounters_enabled in the debugger at runtime.
#macro RANDOM_ENCOUNTERS_ENABLED true
#macro ENCOUNTER_STEP_PIXELS 16
#macro ENCOUNTER_STEPS_MIN 8
#macro ENCOUNTER_STEPS_MAX 24
#macro ENCOUNTER_GRACE_STEPS 5

// Rare Ashbound Hunter random encounter (CHAPTER1_SCRIPT.md §4.1). 3–5% of
// random fights in opted-in areas; 0.04 is the midpoint, pending tuning.
// Also exposed at runtime as global.game.ashbound_rare_chance for debugging.
#macro ASHBOUND_HUNTER_RARE_CHANCE 0.04

// Party and progression (roadmap step 4 / five-person roster). Placeholder numbers, pending owner approval.
// Five permanent members (Kael, Lyra, Caelan, Sera, Taren Holt); four fight at a time, one reserve slot.
#macro PARTY_ROSTER_SIZE 5
#macro PARTY_ACTIVE_MAX 4
#macro PARTY_RESERVE_MAX 1
#macro PARTY_MAX_SIZE PARTY_ACTIVE_MAX // backward-compatible alias: cap of the active battle party
#macro PARTY_MAX_LEVEL 20
#macro KAEL_BASE_HP 30
#macro KAEL_BASE_ATTACK 6
#macro KAEL_BASE_DEFENSE 2
// Placeholder base stats for the other four (not canon, pending owner approval).
#macro LYRA_BASE_HP 24
#macro LYRA_BASE_ATTACK 7
#macro LYRA_BASE_DEFENSE 1
#macro CAELAN_BASE_HP 22
#macro CAELAN_BASE_ATTACK 8
#macro CAELAN_BASE_DEFENSE 1
#macro SERA_BASE_HP 28
#macro SERA_BASE_ATTACK 4
#macro SERA_BASE_DEFENSE 4
// Taren Holt: warrior / frontline; slightly tougher than Kael's balanced line.
#macro TAREN_BASE_HP 36
#macro TAREN_BASE_ATTACK 8
#macro TAREN_BASE_DEFENSE 3
// Battle upgrade (feature/battle-upgrade). PLACEHOLDER SPD / MDEF / MP, not canon, pending owner approval.
// Kael is faster than every Chapter 1 regular except the Ashbound Hunter, so the party still
// usually acts first in Zone 1 (keeps Chapter 1 balance close to the old "party then enemy" order).
#macro KAEL_BASE_SPD 10
#macro KAEL_BASE_MDEF 2
#macro KAEL_BASE_MP 6
#macro LYRA_BASE_SPD 14
#macro LYRA_BASE_MDEF 2
#macro LYRA_BASE_MP 6
#macro CAELAN_BASE_SPD 9
#macro CAELAN_BASE_MDEF 5
#macro CAELAN_BASE_MP 16
#macro SERA_BASE_SPD 8
#macro SERA_BASE_MDEF 5
#macro SERA_BASE_MP 12
#macro TAREN_BASE_SPD 9
#macro TAREN_BASE_MDEF 2
#macro TAREN_BASE_MP 12
// Owner decision 2026-11-14: when an enemy dies, its XP is credited to each
// member who has already taken a turn (Attack, Guard, or Swap) and is not KO'd
// at that moment. Banked pending XP is applied at victory; a defeat grants none.
// A reserve member who never took a turn receives none. Gold stays shared.
#macro XP_REQUIRES_PARTICIPATION true
// Total XP to reach level L (L>=2): XP_CURVE_QUAD*(L-1)^2 + XP_CURVE_LIN*(L-1).
// L1=0, L2=30, L3=100, L4=210, L5=360, L10=1710, L20=7410.
#macro XP_CURVE_QUAD 20
#macro XP_CURVE_LIN 10
#macro LEVEL_UP_HP_GROWTH 4
#macro LEVEL_UP_ATTACK_GROWTH 1
#macro LEVEL_UP_DEFENSE_GROWTH 1
// PLACEHOLDER growth for the new stats (flat per level for every member until per-class curves are set).
#macro LEVEL_UP_MP_GROWTH 2
#macro LEVEL_UP_SPD_GROWTH 1
#macro LEVEL_UP_MDEF_GROWTH 1
// Balance pass (PLACEHOLDER): level-ups INTO level LEVEL_UP_TIER_LEVEL and above use the *_HIGH
// growth. Chapter 1 runs at levels 1–7, so its numbers are unchanged. Chapter 2 suggests 8–10.
// Tuned with tools/balance_sim.py (table in docs/DECISIONS_AND_OPEN_QUESTIONS.md).
#macro LEVEL_UP_TIER_LEVEL 8
#macro LEVEL_UP_HP_GROWTH_HIGH 10
#macro LEVEL_UP_ATTACK_GROWTH_HIGH 2
#macro LEVEL_UP_DEFENSE_GROWTH_HIGH 2
#macro LEVEL_UP_MP_GROWTH_HIGH 3
#macro LEVEL_UP_SPD_GROWTH_HIGH 1
#macro LEVEL_UP_MDEF_GROWTH_HIGH 1
// MP recovery (PLACEHOLDER). Ether restores ITEM_ETHER_MP; the Wrenfield inn (The Bent Post)
// restores HP and MP for the active party and reserve for INN_WRENFIELD_PRICE gold.
#macro ITEM_ETHER_MP 10
#macro INN_WRENFIELD_PRICE 30
// Debug only: add a second placeholder ally so multi-member battle can be tested. Not canon.
// Prefer DEBUG_ADD_FULL_ROSTER for canon members (4 active + 1 reserve).
#macro DEBUG_ADD_PLACEHOLDER_ALLY false
// Debug only: all five roster members join. Active: Kael, Lyra, Caelan, Sera. Reserve: Taren Holt.
#macro DEBUG_ADD_FULL_ROSTER false

// Overworld scale (16×16 tiles; 16×24 player sprites). Pending owner approval.
#macro TILE_SIZE 16
#macro PLAYER_MOVE_SPEED 1
#macro PLAYER_INTERACT_REACH 4
#macro PLAYER_WALK_FPS 8

// Battle sprite playback. Attack / hurt / death use BATTLE_ANIM_FPS; idle loops at BATTLE_IDLE_FPS.
// BATTLE_SPRITE_SCALE is applied in Draw GUI so 32×48 battlers read clearly on a 640×360 GUI.
#macro BATTLE_ANIM_FPS 10
#macro BATTLE_IDLE_FPS 6
#macro BATTLE_SPRITE_SCALE 2
// GUI is locked to 320×180 in scr_ui_init (FF1 layout, ×4 to 1280×720).
// BATTLE_SPRITE_SCALE is legacy (2× on a 640 GUI) and is no longer multiplied in draw.

// Blackguard phases (STORY_BIBLE §5.13 / CHAPTER1_SCRIPT.md §8): 60% HP and 20% HP.
#macro BLACKGUARD_PHASE2_HP_PCT 0.6
#macro BLACKGUARD_PHASE3_HP_PCT 0.2
#macro TITLE_EMBER_FPS 12

// Multi-enemy battles, skills, and buffs (feature/battle-upgrade). All PLACEHOLDER tuning.
#macro BATTLE_MAX_REGULAR_ENEMIES 3     // random / regular groups: 1–3 enemies
#macro BATTLE_MAX_ADDS 3                // a boss can bring up to 3 adds
#macro BATTLE_WEAKNESS_MULTIPLIER 1.5   // damage × this when the skill element matches `weakness`
#macro BATTLE_SPD_TIEBREAK 0.99         // turn order = SPD + random(0..this); keeps ties fair, never reorders a real SPD gap
#macro BATTLE_VICTORY_MP_REGEN 2        // living active members regain this much MP after a win (PLACEHOLDER; kept alongside the inn and Ether)
#macro BATTLE_DEAD_ENEMY_FADE_FRAMES 30 // defeated regulars fade out after their death clip; a yielding boss stays
#macro BATTLE_BLIND_MISS_CHANCE 0.5      // blind: physical attacks miss this often (PLACEHOLDER, batch 8 moths)
#macro BATTLE_HEAL_ALLY_THRESHOLD 0.6    // field surgeon heals only when an ally is below this HP fraction (PLACEHOLDER)
#macro CALDER_ADD_COUNT 2               // occupation_soldier adds in grp_reeve_calder (script says 2–3; Design mockup shows 2)
#macro BATTLE_BLEED_PCT 0.06            // bleed ticks this fraction of max HP each round; never kills (PLACEHOLDER)
#macro BATTLE_POISON_PCT 0.05            // poison ticks this fraction of max HP each round; never kills (PLACEHOLDER)
#macro BATTLE_CHEAP_SHOT_PCT 1.5        // Cheap Shot damage multiplier against a guarding target (PLACEHOLDER)
#macro BATTLE_LAST_STAND_ATK_PCT 1.15    // Last Stand: Kael's ATK below 25% HP (canon: +15%, CHAPTER1_SCRIPT.md §2.1)
#macro BATTLE_LAST_STAND_DEF_PCT 1.10    // Last Stand: Kael's DEF below 25% HP (canon: +10%, CHAPTER1_SCRIPT.md §2.1)
#macro BATTLE_SLOW_SPD_PCT 0.5           // slow: SPD multiplied by this while the bind holds (PLACEHOLDER)
#macro BATTLE_CRIT_BASE 0.05            // base critical hit chance (PLACEHOLDER)
#macro BATTLE_CUTTHROAT_CRIT_BONUS 0.15 // Lyra's Cutthroat passive: crit chance + this (PLACEHOLDER)
#macro BATTLE_CRIT_MULTIPLIER 1.5        // critical hits deal × this damage (PLACEHOLDER)

// Optional camera: if Viewport 0 is enabled (or created by scr_map_enable_camera),
// the controller follows obj_player. Recommended view is 320×180, displayed at 2×.
// The follow function lives in scr_map_tilemaps.gml (one definition).
#macro CAMERA_FOLLOW_PLAYER true

// Explicit battle states. The battle controller is only ever in exactly one of these.
enum BATTLE_STATE {
    INTRO,          // announce the enemy group
    ROUND_START,    // clear Guard, tick buff durations, reset the command queue
    COMMAND_SELECT, // each living party member picks Attack / Skill / Guard / Swap
    SKILL_SELECT,   // pick a skill (MP cost shown; greyed when MP is short)
    ITEM_SELECT,    // pick a consumable from the inventory (Chapter 3: the Item command)
    TARGET_SELECT,  // pick an enemy (or ally) target for Attack or a single-target skill
    TURN_NEXT,      // build / walk the SPD-sorted turn order for this round
    PLAYER_ACTION,  // resolve the current party turn
    ANIMATING,      // play attack / skill / hurt / death clips, then queue the pending message
    PHASE_SHIFT,    // Blackguard p1to2 / p2to3 transition at 60% / 20% HP
    STANCE_SHIFT,   // a boss's one-time stance clip when all of its adds have fallen (Reeve Calder)
    ENEMY_TURN,     // resolve the current enemy turn (weighted AI action)
    MESSAGE,        // show `message`, wait for confirm, then go to `next_state`
    VICTORY,        // grant rewards once, then maybe LEVEL_UP
    LEVEL_UP,       // show one level-up message, then the next or EXIT
    DEFEAT,         // party has fallen; after EXIT they wake up in town
    ERROR,          // bad encounter data (e.g. unknown enemy id)
    EXIT            // hand control back to the overworld exactly once
}
