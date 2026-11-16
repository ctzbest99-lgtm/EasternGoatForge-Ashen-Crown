/// obj_enemy : Step
/// Contact encounters. The enemy does not chase or patrol yet; it is a static encounter marker.
var _player_obj = asset_get_index("obj_player");
if (_player_obj < 0) {
    armed = true;
    exit;
}

/// A menu pauses contact: the player cannot move, so no new encounter should start behind it.
if (variable_global_exists("menu_open") && global.menu_open) exit;

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
