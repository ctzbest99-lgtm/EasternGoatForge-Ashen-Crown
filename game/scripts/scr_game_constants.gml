/// scr_game_constants — shared macros and enums for the exploration + battle prototype.
/// Values here are prototype defaults, not approved design decisions.

// Room handles used by the encounter flow (create these rooms in the IDE; names must match).
#macro OVERWORLD_ROOM rm_overworld
#macro BATTLE_ROOM rm_battle_test

// Town wake-up after defeat (owner decision 2026-11-14).
// There is no town room yet, so this defaults to the overworld test room.
// When the town room is built:
//   1. Change TOWN_RESPAWN_ROOM to that room's asset name (e.g. rm_town).
//   2. Place one obj_respawn_point in open space (inn, shrine, etc.). Its x/y
//      (and optional facing_x / facing_y in Instance Creation Code) override
//      TOWN_RESPAWN_X / TOWN_RESPAWN_Y. The room must also contain obj_player.
//   3. If you prefer not to use a marker, set TOWN_RESPAWN_X / TOWN_RESPAWN_Y
//      to a known open position in the town room instead.
#macro TOWN_RESPAWN_ROOM rm_overworld
#macro TOWN_RESPAWN_X 320
#macro TOWN_RESPAWN_Y 180

// Show encounter trigger placeholders in-game while prototyping. Set to false to hide them.
#macro DEBUG_SHOW_TRIGGERS true

// Guard multiplies incoming damage by this value (minimum 1 damage still applies).
#macro GUARD_DAMAGE_MULTIPLIER 0.5

// Explicit battle states. The battle controller is only ever in exactly one of these.
enum BATTLE_STATE {
    INTRO,          // announce the enemy
    ROUND_START,    // clear Guard, reset the command queue
    COMMAND_SELECT, // each living party member picks Attack or Guard
    PLAYER_ACTION,  // resolve queued party actions one at a time
    ENEMY_TURN,     // enemy attacks one living party member
    MESSAGE,        // show `message`, wait for confirm, then go to `next_state`
    VICTORY,        // grant rewards once
    DEFEAT,         // party has fallen; after EXIT they wake up in town
    ERROR,          // bad encounter data (e.g. unknown enemy id)
    EXIT            // hand control back to the overworld exactly once
}
