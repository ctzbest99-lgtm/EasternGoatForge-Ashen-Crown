/// scr_ruin — the Zone 1 slice behind the ruin door: what opens it, what waits inside, and what a boss
/// victory or a defeat does. The content is data so setting up the room is a checklist, not lore
/// scattered through object events, and so the gate and the encounter list can be tested.

#macro RUIN_ROOM "rm_dungeon1"
#macro RUIN_ENTRY_MARKER "ruin_start"
#macro RUIN_DOOR_SCRIPT "ruin_door"
#macro RUIN_LOCKED_SCRIPT "ruin_door_locked"
#macro RUIN_OPEN_FLAG "npc_hermit_quest_done"
#macro RUIN_BOSS_ID "ruin_warden"
#macro RUIN_BOSS_FLAG "ruin_boss_defeated"
#macro RUIN_RARE_ID "pale_shade"

/// @desc True once the Hermit has checked the follow-up off: that is what opens the door. The door does
/// not look at the door-found flag, so finding it early cannot unlock it.
function scr_ruin_door_open(_flags) {
    return scr_flags_has(_flags, RUIN_OPEN_FLAG);
}

/// @desc Which scene the door says, or "" when it can simply be entered. The first look records that the
/// door was found; every later look says it is barred, without setting anything again.
function scr_ruin_door_script(_flags) {
    if (scr_ruin_door_open(_flags)) return "";
    if (!scr_flags_has(_flags, "ruin_door_found")) return RUIN_DOOR_SCRIPT;
    return RUIN_LOCKED_SCRIPT;
}

/// @desc What waits inside, as placement data. marker_id names the obj_room_marker each encounter stands
/// on, so the room setup is unambiguous. `rare` marks the placeholder encounter.
function scr_ruin_encounters() {
    return [
        { enemy_id: "bandit", marker_id: "ruin_bandit_a", rare: false },
        { enemy_id: "bandit", marker_id: "ruin_bandit_b", rare: false },
        { enemy_id: "fallen_knight", marker_id: "ruin_knight", rare: false },
        { enemy_id: RUIN_RARE_ID, marker_id: "ruin_rare", rare: true }
    ];
}

/// @desc The flag a victory sets, or "" for an ordinary encounter.
function scr_ruin_victory_flag(_enemy_id) {
    if (_enemy_id == RUIN_BOSS_ID) return RUIN_BOSS_FLAG;
    return "";
}

/// @desc True once the boss has fallen, so the room can stay open on a later visit.
function scr_ruin_boss_defeated(_flags) {
    return scr_flags_has(_flags, RUIN_BOSS_FLAG);
}
