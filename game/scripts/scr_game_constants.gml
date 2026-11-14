/// scr_game_constants — shared macros and enums for the exploration + battle prototype.
/// Values here are prototype defaults, not approved design decisions.

// Room handles used by the encounter flow (create these rooms in the IDE; names must match).
#macro OVERWORLD_ROOM rm_overworld
#macro BATTLE_ROOM rm_battle_test

// Town wake-up after defeat (owner decision 2026-11-14).
// No separate town room yet. Respawn is Greyhaven, at the Varyn House
// player_start marker (tile 186, 171 → 2984, 2752, facing down).
// scr_build_overworld also spawns obj_respawn_point there, which overrides
// these constants if present. When a real town room is built:
//   1. Change TOWN_RESPAWN_ROOM to that room's asset name (e.g. rm_town).
//   2. Place one obj_respawn_point in open space (inn, shrine, etc.).
//   3. Or set TOWN_RESPAWN_X / TOWN_RESPAWN_Y to a known open position.
#macro TOWN_RESPAWN_ROOM rm_overworld
#macro TOWN_RESPAWN_X 2984
#macro TOWN_RESPAWN_Y 2752

// Show encounter trigger placeholders in-game while prototyping. Set to false to hide them.
#macro DEBUG_SHOW_TRIGGERS true

// Guard multiplies incoming damage by this value (minimum 1 damage still applies).
#macro GUARD_DAMAGE_MULTIPLIER 0.5

// Defeat penalty (owner decision 2026-11-14; percentages are defaults pending tuning).
// Gold: floor(current shared gold * DEFEAT_GOLD_LOSS_PCT), never below 0.
// XP: floor(progress toward next level * DEFEAT_XP_LOSS_PCT), never a level-down
// or a negative total. No level system exists yet (roadmap step 4), so this is
// currently floor(total shared XP * DEFEAT_XP_LOSS_PCT).
#macro DEFEAT_GOLD_LOSS_PCT 0.5
#macro DEFEAT_XP_LOSS_PCT 0.1

// Random encounters while walking (owner decision 2026-11-14; rates pending tuning).
// A "step" is ENCOUNTER_STEP_PIXELS of actual movement (default: one 32px placeholder tile).
// After grace, a randomized counter in [MIN, MAX] counts down; 0 starts a fight from the
// current area table. Standing still, sliding into a wall, or locked input does not count.
// Set RANDOM_ENCOUNTERS_ENABLED to false to compile them out, or flip
// global.game.random_encounters_enabled in the debugger at runtime.
#macro RANDOM_ENCOUNTERS_ENABLED true
#macro ENCOUNTER_STEP_PIXELS 32
#macro ENCOUNTER_STEPS_MIN 8
#macro ENCOUNTER_STEPS_MAX 24
#macro ENCOUNTER_GRACE_STEPS 5

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
// Owner decision 2026-11-14: XP goes only to members who took at least one turn
// (Attack, Guard, or Swap) in that battle. A reserve member who never swapped in
// receives none. Kept as a named rule rather than a share percentage.
#macro XP_REQUIRES_PARTICIPATION true
// Total XP to reach level L (L>=2): XP_CURVE_QUAD*(L-1)^2 + XP_CURVE_LIN*(L-1).
// L1=0, L2=30, L3=100, L4=210, L5=360, L10=1710, L20=7410.
#macro XP_CURVE_QUAD 20
#macro XP_CURVE_LIN 10
#macro LEVEL_UP_HP_GROWTH 4
#macro LEVEL_UP_ATTACK_GROWTH 1
#macro LEVEL_UP_DEFENSE_GROWTH 1
// Debug only: add a second placeholder ally so multi-member battle can be tested. Not canon.
// Prefer DEBUG_ADD_FULL_ROSTER for canon members (4 active + 1 reserve).
#macro DEBUG_ADD_PLACEHOLDER_ALLY false
// Debug only: all five roster members join. Active: Kael, Lyra, Caelan, Sera. Reserve: Taren Holt.
#macro DEBUG_ADD_FULL_ROSTER false

// Optional camera: if Viewport 0 is enabled (or created by scr_map_enable_camera),
// the controller follows obj_player. Recommended view is 320×180, displayed at 2×.
#macro CAMERA_FOLLOW_PLAYER true

// Explicit battle states. The battle controller is only ever in exactly one of these.
enum BATTLE_STATE {
    INTRO,          // announce the enemy
    ROUND_START,    // clear Guard, reset the command queue
    COMMAND_SELECT, // each living party member picks Attack or Guard
    PLAYER_ACTION,  // resolve queued party actions one at a time
    ENEMY_TURN,     // enemy attacks one living party member
    MESSAGE,        // show `message`, wait for confirm, then go to `next_state`
    VICTORY,        // grant rewards once, then maybe LEVEL_UP
    LEVEL_UP,       // show one level-up message, then the next or EXIT
    DEFEAT,         // party has fallen; after EXIT they wake up in town
    ERROR,          // bad encounter data (e.g. unknown enemy id)
    EXIT            // hand control back to the overworld exactly once
}
