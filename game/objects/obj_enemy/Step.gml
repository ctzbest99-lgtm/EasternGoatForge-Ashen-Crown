/// obj_enemy : Step
/// Contact encounters. The enemy does not chase or patrol yet; it is a static encounter marker.
var _player_obj = asset_get_index("obj_player");
if (_player_obj < 0) {
    armed = true;
    exit;
}

/// A menu or a conversation pauses contact: the player cannot move, so no new encounter should start
/// behind either one.
if (variable_global_exists("menu_open") && global.menu_open) exit;
if (variable_global_exists("dialogue_open") && global.dialogue_open) exit;
if (variable_global_exists("shop_open") && global.shop_open) exit;

/// A boss that has fallen stays fallen: a reloaded save re-creates the room's placed instances, so the
/// flag is checked every step rather than once at Create, because the save loads after they exist.
if (enemy_id == RUIN_BOSS_ID && scr_ruin_boss_defeated(scr_flags_ensure_global())) {
    instance_destroy();
    exit;
}

var _touching = place_meeting(x, y, _player_obj);
var _battle_active = global.battle_active;

if (scr_encounter_should_start(_touching, armed, _battle_active)) {
    armed = false;
    /// Passing id as source_instance lets the controller remove this enemy on victory. If no battle
    /// could start (controller missing), re-arm so the contact is not silently swallowed.
    if (scr_battle_start(enemy_id, id) == noone) armed = true;
    exit;
}

/// Re-arms only after the player steps away, so a defeat cannot loop straight back into the fight.
if (scr_encounter_rearm(_touching, _battle_active)) armed = true;
