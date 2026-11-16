/// obj_battle_controller : Destroy
/// Every exit path — victory, defeat, or manual removal — restores exploration input and clears the
/// encounter lock, so a battle can never leave the overworld unable to move.
for (var _i = 0; _i < array_length(locked_players); _i++) {
    if (instance_exists(locked_players[_i])) locked_players[_i].input_enabled = true;
}
global.battle_active = false;

/// The battle fights with a party member by reference, so a mid-battle destroy must not leave it guarding.
if (battle != undefined && battle.player != undefined) battle.player.guarding = false;

/// A trigger that supplied itself as _source_instance disappears on victory, so it cannot be re-entered.
if (battle != undefined && battle.state == BATTLE_PHASE.VICTORY && source_instance != noone && instance_exists(source_instance)) {
    with (source_instance) instance_destroy();
}
